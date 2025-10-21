import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import userService from './user.service';
import { AppError } from '../../middleware/errorHandler';
import { GENDER } from '../../utils/constants';

const updateProfileSchema = z.object({
  firstName: z.string().min(1).max(100).optional(),
  lastName: z.string().min(1).max(100).optional(),
  phone: z.string().optional(),
  bio: z.string().max(500).optional(),
  birthday: z.string().datetime().or(z.date()).optional(),
  gender: z.enum([GENDER.MALE, GENDER.FEMALE, GENDER.OTHER, GENDER.PREFER_NOT_TO_SAY]).optional(),
  country: z.string().max(100).optional(),
  city: z.string().max(100).optional(),
  instagramHandle: z.string().max(100).optional(),
  interests: z.array(z.string()).optional(),
  isProfilePublic: z.boolean().optional(),
});

const updateSettingsSchema = z.object({
  pushNotifications: z.boolean().optional(),
  emailNotifications: z.boolean().optional(),
  darkMode: z.boolean().optional(),
  language: z.string().max(10).optional(),
  timezone: z.string().max(50).optional(),
});

class UserController {
  /**
   * GET /api/user/profile
   */
  async getProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const profile = await userService.getProfile(req.user.userId);

      res.json({
        success: true,
        data: profile,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * PUT /api/user/profile
   */
  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const data = updateProfileSchema.parse(req.body);
      
      // Convert birthday string to Date if provided
      const profileData = {
        ...data,
        birthday: data.birthday 
          ? (typeof data.birthday === 'string' ? new Date(data.birthday) : data.birthday)
          : undefined,
      };
      
      const profile = await userService.updateProfile(req.user.userId, profileData);

      res.json({
        success: true,
        data: profile,
        message: 'Profile updated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/user/upload-photo
   */
  async uploadPhoto(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      // TODO: Implement file upload to GCS
      // For now, accept a URL
      const { photoUrl } = req.body;

      if (!photoUrl) {
        throw new AppError('Photo URL is required', 400);
      }

      const result = await userService.updateProfilePhoto(req.user.userId, photoUrl);

      res.json({
        success: true,
        data: result,
        message: 'Profile photo updated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/user/settings
   */
  async getSettings(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const settings = await userService.getSettings(req.user.userId);

      res.json({
        success: true,
        data: settings,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * PUT /api/user/settings
   */
  async updateSettings(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const data = updateSettingsSchema.parse(req.body);
      const settings = await userService.updateSettings(req.user.userId, data);

      res.json({
        success: true,
        data: settings,
        message: 'Settings updated successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * DELETE /api/user/account
   */
  async deleteAccount(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const result = await userService.deleteAccount(req.user.userId);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new UserController();


