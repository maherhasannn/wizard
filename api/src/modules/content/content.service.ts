import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';

class ContentService {
  async getMessageOfDay(date?: Date) {
    const targetDate = date || new Date();
    targetDate.setHours(0, 0, 0, 0);

    const message = await prisma.messageOfDay.findUnique({
      where: { date: targetDate },
    });

    if (!message) {
      throw new AppError('Message of the day not found', 404);
    }

    return message;
  }

  async getVideos(category?: string, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;
    const where: any = { isActive: true };
    if (category) where.category = category;

    const [videos, total] = await Promise.all([
      prisma.video.findMany({
        where,
        skip,
        take: limit,
        orderBy: { uploadedAt: 'desc' },
      }),
      prisma.video.count({ where }),
    ]);

    return { videos, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } };
  }

  async getVideo(videoId: number) {
    const video = await prisma.video.findUnique({
      where: { id: videoId, isActive: true },
    });

    if (!video) {
      throw new AppError('Video not found', 404);
    }

    return video;
  }

  async recordVideoView(userId: number, videoId: number, watchDuration: number) {
    await prisma.userVideoView.create({
      data: { userId, videoId, watchDuration },
    });

    await prisma.video.update({
      where: { id: videoId },
      data: { viewCount: { increment: 1 } },
    });

    return { message: 'View recorded' };
  }

  async getAffirmations(category?: string, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;
    const where: any = { isActive: true };
    if (category) where.category = category;

    const [affirmations, total] = await Promise.all([
      prisma.affirmation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      prisma.affirmation.count({ where }),
    ]);

    return { affirmations, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } };
  }

  async getAffirmation(affirmationId: number) {
    const affirmation = await prisma.affirmation.findUnique({
      where: { id: affirmationId, isActive: true },
    });

    if (!affirmation) {
      throw new AppError('Affirmation not found', 404);
    }

    return affirmation;
  }

  async recordAffirmationInteraction(userId: number, affirmationId: number, feeling?: number) {
    await prisma.userAffirmationInteraction.create({
      data: { userId, affirmationId, feeling },
    });

    return { message: 'Interaction recorded' };
  }
}

export default new ContentService();


