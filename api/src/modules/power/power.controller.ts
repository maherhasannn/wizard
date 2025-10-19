import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import powerService from './power.service';
import { AppError } from '../../middleware/errorHandler';

const saveSelectionsSchema = z.object({
  categoryIds: z.array(z.number().int()).min(1),
});

class PowerController {
  async getCategories(req: Request, res: Response, next: NextFunction) {
    try {
      const categories = await powerService.getCategories();
      res.json({ success: true, data: categories });
    } catch (error) {
      next(error);
    }
  }

  async saveSelections(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const { categoryIds } = saveSelectionsSchema.parse(req.body);
      const result = await powerService.saveSelections(req.user.userId, categoryIds);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getSelections(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const selections = await powerService.getSelections(req.user.userId);
      res.json({ success: true, data: selections });
    } catch (error) {
      next(error);
    }
  }
}

export default new PowerController();

