import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import authService from './auth.service';
import { emailSchema, passwordSchema } from '../../utils/validators';
import { AppError } from '../../middleware/errorHandler';

// Validation schemas
const registerSchema = z.object({
  email: emailSchema,
  password: passwordSchema,
  firstName: z.string().min(1).max(100).optional(),
  lastName: z.string().min(1).max(100).optional(),
});

const loginSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, 'Password is required'),
});

const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

const requestPasswordResetSchema = z.object({
  email: emailSchema,
});

const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  password: passwordSchema,
});

const verifyEmailSchema = z.object({
  email: emailSchema,
  code: z.string().length(6, 'Verification code must be 6 digits'),
});

const resendCodeSchema = z.object({
  email: emailSchema,
});

const forgotPasswordSchema = z.object({
  email: emailSchema,
});

const verifyResetCodeSchema = z.object({
  email: emailSchema,
  code: z.string().length(6, 'Verification code must be 6 digits'),
});

const resetPasswordWithCodeSchema = z.object({
  email: emailSchema,
  code: z.string().length(6, 'Verification code must be 6 digits'),
  password: passwordSchema,
});

const setPasswordSchema = z.object({
  email: emailSchema,
  password: passwordSchema,
});

class AuthController {
  /**
   * POST /api/auth/register
   */
  async register(req: Request, res: Response, next: NextFunction) {
    try {
      const data = registerSchema.parse(req.body);
      const result = await authService.register(data);

      res.status(201).json({
        success: true,
        data: result,
        message: 'User registered successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/login
   */
  async login(req: Request, res: Response, next: NextFunction) {
    try {
      const data = loginSchema.parse(req.body);
      const result = await authService.login(data);

      res.json({
        success: true,
        data: result,
        message: 'Login successful',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/refresh
   */
  async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = refreshTokenSchema.parse(req.body);
      const result = await authService.refreshToken(refreshToken);

      res.json({
        success: true,
        data: result,
        message: 'Token refreshed successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/forgot-password
   */
  async requestPasswordReset(req: Request, res: Response, next: NextFunction) {
    try {
      const { email } = requestPasswordResetSchema.parse(req.body);
      const result = await authService.requestPasswordReset(email);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/reset-password
   */
  async resetPassword(req: Request, res: Response, next: NextFunction) {
    try {
      const { token, password } = resetPasswordSchema.parse(req.body);
      const result = await authService.resetPassword(token, password);

      res.json({
        success: true,
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /api/auth/me
   */
  async getCurrentUser(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user) {
        throw new AppError('User not authenticated', 401);
      }

      const user = await authService.getCurrentUser(req.user.userId);

      res.json({
        success: true,
        data: user,
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/verify-email
   */
  async verifyEmail(req: Request, res: Response, next: NextFunction) {
    try {
      const data = verifyEmailSchema.parse(req.body);
      const result = await authService.verifyEmail(data.email, data.code);

      res.json({
        success: true,
        data: result,
        message: 'Email verified successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/resend-code
   */
  async resendCode(req: Request, res: Response, next: NextFunction) {
    try {
      const data = resendCodeSchema.parse(req.body);
      await authService.resendVerificationCode(data.email);

      res.json({
        success: true,
        message: 'Verification code sent successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/forgot-password
   */
  async forgotPassword(req: Request, res: Response, next: NextFunction) {
    try {
      const data = forgotPasswordSchema.parse(req.body);
      await authService.forgotPassword(data.email);

      res.json({
        success: true,
        message: 'Password reset code sent successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/verify-reset-code
   */
  async verifyResetCode(req: Request, res: Response, next: NextFunction) {
    try {
      const data = verifyResetCodeSchema.parse(req.body);
      await authService.verifyResetCode(data.email, data.code);

      res.json({
        success: true,
        message: 'Reset code verified successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/reset-password-with-code
   */
  async resetPasswordWithCode(req: Request, res: Response, next: NextFunction) {
    try {
      const data = resetPasswordWithCodeSchema.parse(req.body);
      const result = await authService.resetPasswordWithCode(data.email, data.code, data.password);

      res.json({
        success: true,
        data: result,
        message: 'Password reset successfully',
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * POST /api/auth/set-password
   */
  async setPassword(req: Request, res: Response, next: NextFunction) {
    try {
      const data = setPasswordSchema.parse(req.body);
      const result = await authService.setPassword(data.email, data.password);

      res.json({
        success: true,
        data: result,
        message: 'Password set successfully',
      });
    } catch (error) {
      next(error);
    }
  }
}

export default new AuthController();


