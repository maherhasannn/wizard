import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import calendarService from './calendar.service';
import { AppError } from '../../middleware/errorHandler';
import { EVENT_TYPES } from '../../utils/constants';

const createEventSchema = z.object({
  title: z.string().min(1).max(200),
  description: z.string().optional(),
  type: z.enum([EVENT_TYPES.MEDITATION, EVENT_TYPES.GOAL, EVENT_TYPES.REMINDER, EVENT_TYPES.CUSTOM]),
  scheduledAt: z.string().datetime().transform(str => new Date(str)),
  duration: z.number().int().min(1).optional(),
  recurrence: z.any().optional(),
  notificationTime: z.number().int().min(0).optional(),
});

const updateEventSchema = createEventSchema.partial();

class CalendarController {
  async getEvents(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await calendarService.getEvents(req.user.userId, page, limit);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getEvent(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const event = await calendarService.getEvent(req.user.userId, parseInt(req.params.id));
      res.json({ success: true, data: event });
    } catch (error) {
      next(error);
    }
  }

  async createEvent(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const data = createEventSchema.parse(req.body);
      const event = await calendarService.createEvent(req.user.userId, data);
      res.status(201).json({ success: true, data: event });
    } catch (error) {
      next(error);
    }
  }

  async updateEvent(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const data = updateEventSchema.parse(req.body);
      const event = await calendarService.updateEvent(req.user.userId, parseInt(req.params.id), data);
      res.json({ success: true, data: event });
    } catch (error) {
      next(error);
    }
  }

  async deleteEvent(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const result = await calendarService.deleteEvent(req.user.userId, parseInt(req.params.id));
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async completeEvent(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const event = await calendarService.completeEvent(req.user.userId, parseInt(req.params.id));
      res.json({ success: true, data: event });
    } catch (error) {
      next(error);
    }
  }

  async getUpcoming(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const limit = parseInt(req.query.limit as string) || 10;
      const events = await calendarService.getUpcoming(req.user.userId, limit);
      res.json({ success: true, data: events });
    } catch (error) {
      next(error);
    }
  }
}

export default new CalendarController();


