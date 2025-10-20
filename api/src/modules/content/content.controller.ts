import { Request, Response, NextFunction } from 'express';
import contentService from './content.service';
import { AppError } from '../../middleware/errorHandler';

class ContentController {
  async getMessageOfDay(req: Request, res: Response, next: NextFunction) {
    try {
      const message = await contentService.getMessageOfDay();
      res.json({ success: true, data: message });
    } catch (error) {
      next(error);
    }
  }

  async getVideos(req: Request, res: Response, next: NextFunction) {
    try {
      const category = req.query.category as string;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const result = await contentService.getVideos(category, page, limit);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getVideo(req: Request, res: Response, next: NextFunction) {
    try {
      const video = await contentService.getVideo(parseInt(req.params.id));
      res.json({ success: true, data: video });
    } catch (error) {
      next(error);
    }
  }

  async recordVideoView(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const { watchDuration } = req.body;
      const result = await contentService.recordVideoView(req.user.userId, parseInt(req.params.id), watchDuration);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getAffirmations(req: Request, res: Response, next: NextFunction) {
    try {
      const category = req.query.category as string;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const result = await contentService.getAffirmations(category, page, limit);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getAffirmation(req: Request, res: Response, next: NextFunction) {
    try {
      const affirmation = await contentService.getAffirmation(parseInt(req.params.id));
      res.json({ success: true, data: affirmation });
    } catch (error) {
      next(error);
    }
  }

  async recordAffirmationInteraction(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const { feeling } = req.body;
      const result = await contentService.recordAffirmationInteraction(req.user.userId, parseInt(req.params.id), feeling);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }
}

export default new ContentController();


