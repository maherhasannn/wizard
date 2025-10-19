import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { EventType } from '@prisma/client';

interface CreateEventData {
  title: string;
  description?: string;
  type: EventType;
  scheduledAt: Date;
  duration?: number;
  recurrence?: any;
  notificationTime?: number;
}

interface UpdateEventData extends Partial<CreateEventData> {}

class CalendarService {
  async getEvents(userId: number, page: number = 1, limit: number = 20) {
    const skip = (page - 1) * limit;

    const [events, total] = await Promise.all([
      prisma.calendarEvent.findMany({
        where: { userId },
        skip,
        take: limit,
        orderBy: { scheduledAt: 'asc' },
      }),
      prisma.calendarEvent.count({ where: { userId } }),
    ]);

    return {
      events,
      pagination: { page, limit, total, totalPages: Math.ceil(total / limit) },
    };
  }

  async getEvent(userId: number, eventId: number) {
    const event = await prisma.calendarEvent.findFirst({
      where: { id: eventId, userId },
    });

    if (!event) {
      throw new AppError('Event not found', 404);
    }

    return event;
  }

  async createEvent(userId: number, data: CreateEventData) {
    const event = await prisma.calendarEvent.create({
      data: {
        ...data,
        userId,
      },
    });

    return event;
  }

  async updateEvent(userId: number, eventId: number, data: UpdateEventData) {
    await this.getEvent(userId, eventId);

    const event = await prisma.calendarEvent.update({
      where: { id: eventId },
      data,
    });

    return event;
  }

  async deleteEvent(userId: number, eventId: number) {
    await this.getEvent(userId, eventId);

    await prisma.calendarEvent.delete({
      where: { id: eventId },
    });

    return { message: 'Event deleted successfully' };
  }

  async completeEvent(userId: number, eventId: number) {
    await this.getEvent(userId, eventId);

    const event = await prisma.calendarEvent.update({
      where: { id: eventId },
      data: {
        isCompleted: true,
        completedAt: new Date(),
      },
    });

    return event;
  }

  async getUpcoming(userId: number, limit: number = 10) {
    const events = await prisma.calendarEvent.findMany({
      where: {
        userId,
        scheduledAt: { gte: new Date() },
        isCompleted: false,
      },
      take: limit,
      orderBy: { scheduledAt: 'asc' },
    });

    return events;
  }
}

export default new CalendarService();

