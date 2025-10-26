import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import multer from 'multer';
import networkingService from './networking.service';
import { AppError } from '../../middleware/errorHandler';

// Configure multer for memory storage
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new AppError('Only image files are allowed', 400));
    }
  },
});

const updateProfileSchema = z.object({
  visibility: z.string().optional(),
  lookingFor: z.string().optional(),
  bio: z.string().optional(),
  interests: z.array(z.string()).optional(),
});

const swipeSchema = z.object({
  swipedUserId: z.number().int(),
  direction: z.enum(['LEFT', 'RIGHT']),
});

const locationSchema = z.object({
  latitude: z.number(),
  longitude: z.number(),
});

const createProfileSchema = z.object({
  firstName: z.string().min(1),
  lastName: z.string().min(1).optional(),
  birthday: z.string(),
  gender: z.string(),
  country: z.string(),
  city: z.string(),
  instagramHandle: z.string().optional(),
  interests: z.array(z.string()),
  isProfilePublic: z.boolean().optional(),
});

class NetworkingController {
  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const data = updateProfileSchema.parse(req.body);
      const profile = await networkingService.updateProfile(req.user.userId, data);
      res.json({ success: true, data: profile });
    } catch (error) {
      next(error);
    }
  }

  async discover(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const limit = parseInt(req.query.limit as string) || 20;
      const users = await networkingService.discover(req.user.userId, limit);
      res.json({ success: true, data: users });
    } catch (error) {
      next(error);
    }
  }

  async recordSwipe(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const data = swipeSchema.parse(req.body);
      const result = await networkingService.recordSwipe(req.user.userId, data.swipedUserId, data.direction);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getConnections(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const connections = await networkingService.getConnections(req.user.userId);
      res.json({ success: true, data: connections });
    } catch (error) {
      next(error);
    }
  }

  async sendConnectionRequest(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const targetUserId = parseInt(req.body.targetUserId);
      const connection = await networkingService.sendConnectionRequest(req.user.userId, targetUserId);
      res.json({ success: true, data: connection });
    } catch (error) {
      next(error);
    }
  }

  async acceptConnection(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const connectionId = parseInt(req.params.id);
      const connection = await networkingService.acceptConnection(req.user.userId, connectionId);
      res.json({ success: true, data: connection });
    } catch (error) {
      next(error);
    }
  }

  async rejectConnection(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const connectionId = parseInt(req.params.id);
      const connection = await networkingService.rejectConnection(req.user.userId, connectionId);
      res.json({ success: true, data: connection });
    } catch (error) {
      next(error);
    }
  }

  async searchUsers(req: Request, res: Response, next: NextFunction) {
    try {
      const query = req.query.q as string;
      if (!query) throw new AppError('Search query required', 400);
      const users = await networkingService.searchUsers(query);
      res.json({ success: true, data: users });
    } catch (error) {
      next(error);
    }
  }

  async getUserProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const targetUserId = parseInt(req.params.id);
      const user = await networkingService.getUserProfile(req.user.userId, targetUserId);
      res.json({ success: true, data: user });
    } catch (error) {
      next(error);
    }
  }

  async updateLocation(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const { latitude, longitude } = locationSchema.parse(req.body);
      const result = await networkingService.updateLocation(req.user.userId, latitude, longitude);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async createOrUpdateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const profileData = createProfileSchema.parse(req.body);
      const result = await networkingService.createOrUpdateProfile(req.user.userId, profileData);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async uploadProfilePhoto(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      if (!req.file) throw new AppError('No file uploaded', 400);
      
      const result = await networkingService.uploadProfilePhoto(req.user.userId, req.file);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }

  async getMyProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) throw new AppError('Unauthorized', 401);
      const profile = await networkingService.getMyProfile(req.user.userId);
      res.json({ success: true, data: profile });
    } catch (error) {
      next(error);
    }
  }
}

export { upload };
export default new NetworkingController();
