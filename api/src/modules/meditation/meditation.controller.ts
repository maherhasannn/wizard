import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import meditationService from './meditation.service';
import { AppError } from '../../middleware/errorHandler';
import { MEDITATION_CATEGORIES } from '../../utils/constants';

const getTracksSchema = z.object({
  category: z.enum([
    MEDITATION_CATEGORIES.AUDIO,
    MEDITATION_CATEGORIES.MUSIC,
    MEDITATION_CATEGORIES.SLEEP
  ]).optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
});

const recordPlaySchema = z.object({
  duration: z.number().int().min(0),
  completed: z.boolean(),
});

class MeditationController {
  /**
   * GET /api/meditation/tracks
   */
  async getTracks(req: Request, res: Response, next: NextFunction) {
    try {
      const params = getTracksSchema.parse(req.query);
      const userId = req.user?.userId;

      const result = await meditationService.getTracks(params, userId);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/meditation/tracks/:id
   */
  async getTrack(req: Request, res: Response, next: NextFunction) {
    try {
      const trackId = parseInt(req.params.id, 10);
      if (isNaN(trackId)) {
        throw new AppError('Invalid track ID', 400);
      }

      const userId = req.user?.userId;
      const track = await meditationService.getTrack(trackId, userId);

      res.json({
        success: true,
        data: track,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/meditation/tracks/:id/favorite
   */
  async addToFavorites(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const trackId = parseInt(req.params.id, 10);
      if (isNaN(trackId)) {
        throw new AppError('Invalid track ID', 400);
      }

      const result = await meditationService.addToFavorites(req.user.userId, trackId);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * DELETE /api/meditation/tracks/:id/favorite
   */
  async removeFromFavorites(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const trackId = parseInt(req.params.id, 10);
      if (isNaN(trackId)) {
        throw new AppError('Invalid track ID', 400);
      }

      const result = await meditationService.removeFromFavorites(req.user.userId, trackId);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/meditation/favorites
   */
  async getFavorites(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const page = parseInt(req.query.page as string, 10) || 1;
      const limit = parseInt(req.query.limit as string, 10) || 20;

      const result = await meditationService.getFavorites(req.user.userId, page, limit);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/meditation/tracks/:id/play
   */
  async recordPlay(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const trackId = parseInt(req.params.id, 10);
      if (isNaN(trackId)) {
        throw new AppError('Invalid track ID', 400);
      }

      const { duration, completed } = recordPlaySchema.parse(req.body);

      const result = await meditationService.recordPlay(
        req.user.userId,
        trackId,
        duration,
        completed
      );

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/meditation/history
   */
  async getHistory(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const page = parseInt(req.query.page as string, 10) || 1;
      const limit = parseInt(req.query.limit as string, 10) || 20;

      const result = await meditationService.getHistory(req.user.userId, page, limit);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/meditation/stats
   */
  async getStats(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const stats = await meditationService.getStats(req.user.userId);

      res.json({
        success: true,
        data: stats,
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new MeditationController();

