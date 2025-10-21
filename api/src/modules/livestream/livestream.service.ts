import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { StreamStatus } from '@prisma/client';

class LiveStreamService {
  async getStreams(status?: StreamStatus, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;
    const where: any = {};
    if (status) where.status = status;

    const [streams, total] = await Promise.all([
      prisma.liveStream.findMany({
        where,
        skip,
        take: limit,
        orderBy: { scheduledAt: 'desc' },
        include: {
          host: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              profilePhoto: true,
            },
          },
        },
      }),
      prisma.liveStream.count({ where }),
    ]);

    return { streams, pagination: { page, limit, total, totalPages: Math.ceil(total / limit) } };
  }

  async getStream(streamId: number) {
    const stream = await prisma.liveStream.findUnique({
      where: { id: streamId },
      include: {
        host: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
          },
        },
      },
    });

    if (!stream) {
      throw new AppError('Stream not found', 404);
    }

    return stream;
  }

  async joinStream(userId: number, streamId: number) {
    await this.getStream(streamId);

    // Check if participant already exists
    const existingParticipant = await prisma.liveStreamParticipant.findFirst({
      where: { streamId, userId },
    });

    if (existingParticipant) {
      // Update existing participant
      await prisma.liveStreamParticipant.update({
        where: { id: existingParticipant.id },
        data: { leftAt: null },
      });
    } else {
      // Create new participant
      await prisma.liveStreamParticipant.create({
        data: { streamId, userId },
      });
    }

    await prisma.liveStream.update({
      where: { id: streamId },
      data: { viewerCount: { increment: 1 } },
    });

    return { message: 'Joined stream successfully' };
  }

  async leaveStream(userId: number, streamId: number) {
    await prisma.liveStreamParticipant.updateMany({
      where: { streamId, userId, leftAt: null },
      data: { leftAt: new Date() },
    });

    await prisma.liveStream.update({
      where: { id: streamId },
      data: { viewerCount: { decrement: 1 } },
    });

    return { message: 'Left stream' };
  }

  async sendChatMessage(userId: number, streamId: number, message: string) {
    const chat = await prisma.liveStreamChat.create({
      data: { userId, streamId, message },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
          },
        },
      },
    });

    return chat;
  }

  async getChatMessages(streamId: number, limit: number = 50) {
    const messages = await prisma.liveStreamChat.findMany({
      where: { streamId },
      take: limit,
      orderBy: { sentAt: 'desc' },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
          },
        },
      },
    });

    return messages.reverse();
  }
}

export default new LiveStreamService();


