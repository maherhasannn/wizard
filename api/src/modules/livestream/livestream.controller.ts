import { Request, Response, NextFunction } from 'express';
import livestreamService from './livestream.service';
import { AppError } from '../../middleware/errorHandler';

class LiveStreamController {
  async getStreams(req: Request, res: Response, next: NextFunction) {
    try {
      const status = req.query.status as any;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const result = await livestreamService.getStreams(status, page, limit);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getStream(req: Request, res: Response, next: NextFunction) {
    try {
      const stream = await livestreamService.getStream(parseInt(req.params.id));
      res.json({ success: true, data: stream });
    } catch (error) {
      next(error);
    }
  }

  async joinStream(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const result = await livestreamService.joinStream(req.user.userId, parseInt(req.params.id));
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async leaveStream(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const result = await livestreamService.leaveStream(req.user.userId, parseInt(req.params.id));
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async sendChatMessage(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const { message } = req.body;
      if (!message) throw new AppError('Message required', 400);
      const chat = await livestreamService.sendChatMessage(req.user.userId, parseInt(req.params.id), message);
      res.json({ success: true, data: chat });
    } catch (error) {
      next(error);
    }
  }

  async getChatMessages(req: Request, res: Response, next: NextFunction) {
    try {
      const limit = parseInt(req.query.limit as string) || 50;
      const messages = await livestreamService.getChatMessages(parseInt(req.params.id), limit);
      res.json({ success: true, data: messages });
    } catch (error) {
      next(error);
    }
  }
}

export default new LiveStreamController();

