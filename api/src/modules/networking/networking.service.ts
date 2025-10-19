import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { ConnectionStatus, SwipeDirection } from '@prisma/client';

class NetworkingService {
  async updateProfile(userId: number, data: any) {
    const profile = await prisma.networkProfile.upsert({
      where: { userId },
      create: { userId, ...data },
      update: data,
    });
    return profile;
  }

  async discover(userId: number, limit: number = 20) {
    const swipedUserIds = await prisma.userSwipe.findMany({
      where: { swiperId: userId },
      select: { swipedUserId: true },
    });
    const swipedIds = swipedUserIds.map(s => s.swipedUserId);

    const users = await prisma.user.findMany({
      where: {
        id: { notIn: [...swipedIds, userId] },
        isProfilePublic: true,
      },
      take: limit,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        bio: true,
        city: true,
        country: true,
        interests: true,
        networkProfile: true,
      },
    });

    return users;
  }

  async recordSwipe(userId: number, swipedUserId: number, direction: SwipeDirection) {
    await prisma.userSwipe.create({
      data: {
        swiperId: userId,
        swipedUserId,
        direction,
      },
    });

    // If right swipe, check for match
    if (direction === 'RIGHT') {
      const reciprocalSwipe = await prisma.userSwipe.findUnique({
        where: {
          swiperId_swipedUserId: {
            swiperId: swipedUserId,
            swipedUserId: userId,
          },
        },
      });

      if (reciprocalSwipe && reciprocalSwipe.direction === 'RIGHT') {
        // Create connection
        await prisma.connection.create({
          data: {
            requesterId: userId,
            receiverId: swipedUserId,
            status: 'ACCEPTED',
            acceptedAt: new Date(),
          },
        });
        return { matched: true };
      }
    }

    return { matched: false };
  }

  async getConnections(userId: number, status?: ConnectionStatus) {
    const where: any = {
      OR: [{ requesterId: userId }, { receiverId: userId }],
    };

    if (status) {
      where.status = status;
    }

    const connections = await prisma.connection.findMany({
      where,
      include: {
        requester: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
            city: true,
            country: true,
          },
        },
        receiver: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
            city: true,
            country: true,
          },
        },
      },
    });

    return connections.map(conn => ({
      ...conn,
      user: conn.requesterId === userId ? conn.receiver : conn.requester,
    }));
  }

  async sendConnectionRequest(userId: number, targetUserId: number) {
    const connection = await prisma.connection.create({
      data: {
        requesterId: userId,
        receiverId: targetUserId,
        status: 'PENDING',
      },
    });
    return connection;
  }

  async acceptConnection(userId: number, connectionId: number) {
    const connection = await prisma.connection.findUnique({
      where: { id: connectionId },
    });

    if (!connection || connection.receiverId !== userId) {
      throw new AppError('Connection not found', 404);
    }

    return prisma.connection.update({
      where: { id: connectionId },
      data: { status: 'ACCEPTED', acceptedAt: new Date() },
    });
  }

  async rejectConnection(userId: number, connectionId: number) {
    const connection = await prisma.connection.findUnique({
      where: { id: connectionId },
    });

    if (!connection || connection.receiverId !== userId) {
      throw new AppError('Connection not found', 404);
    }

    return prisma.connection.update({
      where: { id: connectionId },
      data: { status: 'REJECTED' },
    });
  }

  async searchUsers(query: string, limit: number = 20) {
    const users = await prisma.user.findMany({
      where: {
        isProfilePublic: true,
        OR: [
          { firstName: { contains: query, mode: 'insensitive' } },
          { lastName: { contains: query, mode: 'insensitive' } },
          { city: { contains: query, mode: 'insensitive' } },
        ],
      },
      take: limit,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        city: true,
        country: true,
        bio: true,
      },
    });

    return users;
  }

  async getUserProfile(userId: number, targetUserId: number) {
    const user = await prisma.user.findUnique({
      where: { id: targetUserId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        bio: true,
        city: true,
        country: true,
        interests: true,
        instagramHandle: true,
        networkProfile: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    // Record view
    await prisma.userView.create({
      data: {
        viewerId: userId,
        viewedUserId: targetUserId,
      },
    }).catch(() => {}); // Ignore if already viewed

    return user;
  }

  async updateLocation(userId: number, latitude: number, longitude: number) {
    await prisma.networkProfile.upsert({
      where: { userId },
      create: {
        userId,
        latitude,
        longitude,
        lastLocationUpdate: new Date(),
      },
      update: {
        latitude,
        longitude,
        lastLocationUpdate: new Date(),
      },
    });

    return { message: 'Location updated' };
  }
}

export default new NetworkingService();

