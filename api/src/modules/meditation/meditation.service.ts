import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { MeditationCategory } from '@prisma/client';

interface GetTracksParams {
  category?: MeditationCategory;
  page?: number;
  limit?: number;
  search?: string;
}

class MeditationService {
  /**
   * Get meditation tracks with filters and pagination
   */
  async getTracks(params: GetTracksParams, userId?: number) {
    const { category, page = 1, limit = 20, search } = params;
    const skip = (page - 1) * limit;

    const where: any = {
      isActive: true,
    };

    if (category) {
      where.category = category;
    }

    if (search) {
      where.OR = [
        { title: { contains: search, mode: 'insensitive' } },
        { artist: { contains: search, mode: 'insensitive' } },
      ];
    }

    const [tracks, total] = await Promise.all([
      prisma.meditationTrack.findMany({
        where,
        skip,
        take: limit,
        orderBy: { sortOrder: 'asc' },
        select: {
          id: true,
          title: true,
          artist: true,
          description: true,
          category: true,
          duration: true,
          audioUrl: true,
          imageUrl: true,
          isPremium: true,
          playCount: true,
          favoriteCount: true,
        },
      }),
      prisma.meditationTrack.count({ where }),
    ]);

    // If user is authenticated, check if tracks are favorited
    if (userId) {
      const favorites = await prisma.userMeditationFavorite.findMany({
        where: {
          userId,
          trackId: { in: tracks.map(t => t.id) },
        },
        select: { trackId: true },
      });

      const favoritedIds = new Set(favorites.map(f => f.trackId));

      return {
        tracks: tracks.map(track => ({
          ...track,
          isFavorited: favoritedIds.has(track.id),
        })),
        pagination: {
          page,
          limit,
          total,
          totalPages: Math.ceil(total / limit),
        },
      };
    }

    return {
      tracks,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Get single track details
   */
  async getTrack(trackId: number, userId?: number) {
    const track = await prisma.meditationTrack.findUnique({
      where: { id: trackId, isActive: true },
    });

    if (!track) {
      throw new AppError('Track not found', 404);
    }

    let isFavorited = false;
    if (userId) {
      const favorite = await prisma.userMeditationFavorite.findUnique({
        where: {
          userId_trackId: {
            userId,
            trackId,
          },
        },
      });
      isFavorited = !!favorite;
    }

    return {
      ...track,
      isFavorited,
    };
  }

  /**
   * Add track to favorites
   */
  async addToFavorites(userId: number, trackId: number) {
    // Check if track exists
    const track = await prisma.meditationTrack.findUnique({
      where: { id: trackId },
    });

    if (!track) {
      throw new AppError('Track not found', 404);
    }

    // Add to favorites (or do nothing if already exists)
    await prisma.userMeditationFavorite.upsert({
      where: {
        userId_trackId: {
          userId,
          trackId,
        },
      },
      create: {
        userId,
        trackId,
      },
      update: {},
    });

    // Increment favorite count
    await prisma.meditationTrack.update({
      where: { id: trackId },
      data: { favoriteCount: { increment: 1 } },
    });

    return { message: 'Track added to favorites' };
  }

  /**
   * Remove track from favorites
   */
  async removeFromFavorites(userId: number, trackId: number) {
    const deleted = await prisma.userMeditationFavorite.deleteMany({
      where: {
        userId,
        trackId,
      },
    });

    if (deleted.count > 0) {
      // Decrement favorite count
      await prisma.meditationTrack.update({
        where: { id: trackId },
        data: { favoriteCount: { decrement: 1 } },
      });
    }

    return { message: 'Track removed from favorites' };
  }

  /**
   * Get user's favorite tracks
   */
  async getFavorites(userId: number, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;

    const [favorites, total] = await Promise.all([
      prisma.userMeditationFavorite.findMany({
        where: { userId },
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          track: {
            select: {
              id: true,
              title: true,
              artist: true,
              description: true,
              category: true,
              duration: true,
              audioUrl: true,
              imageUrl: true,
              isPremium: true,
              playCount: true,
              favoriteCount: true,
            },
          },
        },
      }),
      prisma.userMeditationFavorite.count({ where: { userId } }),
    ]);

    return {
      tracks: favorites.map(f => ({ ...f.track, isFavorited: true })),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Record track play
   */
  async recordPlay(userId: number, trackId: number, duration: number, completed: boolean) {
    // Create history entry
    await prisma.userMeditationHistory.create({
      data: {
        userId,
        trackId,
        duration,
        completed,
      },
    });

    // Increment play count
    await prisma.meditationTrack.update({
      where: { id: trackId },
      data: { playCount: { increment: 1 } },
    });

    // Update user stats
    await this.updateUserStats(userId, duration, completed);

    return { message: 'Play recorded successfully' };
  }

  /**
   * Get user's meditation history
   */
  async getHistory(userId: number, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;

    const [history, total] = await Promise.all([
      prisma.userMeditationHistory.findMany({
        where: { userId },
        skip,
        take: limit,
        orderBy: { playedAt: 'desc' },
        include: {
          track: {
            select: {
              id: true,
              title: true,
              artist: true,
              imageUrl: true,
              category: true,
            },
          },
        },
      }),
      prisma.userMeditationHistory.count({ where: { userId } }),
    ]);

    return {
      history,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Get user's meditation stats
   */
  async getStats(userId: number) {
    let stats = await prisma.userMeditationStats.findUnique({
      where: { userId },
    });

    if (!stats) {
      stats = await prisma.userMeditationStats.create({
        data: { userId },
      });
    }

    return stats;
  }

  /**
   * Update user meditation stats
   */
  private async updateUserStats(userId: number, duration: number, completed: boolean) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    let stats = await prisma.userMeditationStats.findUnique({
      where: { userId },
    });

    if (!stats) {
      stats = await prisma.userMeditationStats.create({
        data: {
          userId,
          totalMinutes: Math.floor(duration / 60),
          sessionsCount: 1,
          streak: 1,
          lastSessionDate: today,
        },
      });
      return;
    }

    const updateData: any = {
      totalMinutes: { increment: Math.floor(duration / 60) },
      sessionsCount: { increment: 1 },
    };

    // Update streak
    if (stats.lastSessionDate) {
      const lastSession = new Date(stats.lastSessionDate);
      lastSession.setHours(0, 0, 0, 0);

      const daysDiff = Math.floor((today.getTime() - lastSession.getTime()) / (1000 * 60 * 60 * 24));

      if (daysDiff === 0) {
        // Same day, no change to streak
        updateData.lastSessionDate = today;
      } else if (daysDiff === 1) {
        // Consecutive day, increment streak
        updateData.streak = { increment: 1 };
        updateData.lastSessionDate = today;
      } else {
        // Streak broken, reset to 1
        updateData.streak = 1;
        updateData.lastSessionDate = today;
      }
    } else {
      updateData.streak = 1;
      updateData.lastSessionDate = today;
    }

    await prisma.userMeditationStats.update({
      where: { userId },
      data: updateData,
    });
  }
}

export default new MeditationService();


