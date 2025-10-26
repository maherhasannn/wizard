import { Request, Response, NextFunction } from 'express';
import challengeService from './challenge.service';
import { AppError } from '../../middleware/errorHandler';

class ChallengeController {
  /**
   * GET /challenges
   * Get all available challenges
   */
  async getChallenges(req: Request, res: Response, next: NextFunction) {
    try {
      const challenges = await challengeService.getChallenges();
      res.json({ success: true, data: challenges });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /challenges/:id
   * Get challenge details with all rituals
   */
  async getChallengeDetails(req: Request, res: Response, next: NextFunction) {
    try {
      const challengeId = parseInt(req.params.id);
      const userId = req.user?.userId;

      const result = await challengeService.getChallengeDetails(challengeId, userId);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /challenges/my/active
   * Get user's active challenges
   */
  async getActiveChallenges(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challenges = await challengeService.getActiveChallenges(req.user.userId);
      res.json({ success: true, data: challenges });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /challenges/:id/start
   * Start a challenge
   */
  async startChallenge(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challengeId = parseInt(req.params.id);
      const challenge = await challengeService.startChallenge(challengeId, req.user.userId);
      
      res.json({ success: true, data: challenge });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /challenges/:id/pause
   * Pause a challenge
   */
  async pauseChallenge(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challengeId = parseInt(req.params.id);
      const challenge = await challengeService.pauseChallenge(challengeId, req.user.userId);
      
      res.json({ success: true, data: challenge });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /challenges/:id/resume
   * Resume a paused challenge
   */
  async resumeChallenge(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challengeId = parseInt(req.params.id);
      const challenge = await challengeService.resumeChallenge(challengeId, req.user.userId);
      
      res.json({ success: true, data: challenge });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /challenges/:challengeId/rituals/:ritualId/complete
   * Complete a ritual
   */
  async completeRitual(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challengeId = parseInt(req.params.challengeId);
      const ritualId = parseInt(req.params.ritualId);
      
      const result = await challengeService.completeRitual(challengeId, ritualId, req.user.userId);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /challenges/:id/progress
   * Get user's progress in a challenge
   */
  async getProgress(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      
      const challengeId = parseInt(req.params.id);
      const progress = await challengeService.getProgress(challengeId, req.user.userId);
      
      res.json({ success: true, data: progress });
    } catch (error) {
      next(error);
    }
  }
}

export default new ChallengeController();
