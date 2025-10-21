import { Router } from 'express';
import authController from './auth.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

// Public routes
router.post('/register', authController.register.bind(authController));
router.post('/login', authController.login.bind(authController));
router.post('/refresh', authController.refreshToken.bind(authController));
router.post('/forgot-password', authController.requestPasswordReset.bind(authController));
router.post('/reset-password', authController.resetPassword.bind(authController));

// Email verification routes
router.post('/verify-email', authController.verifyEmail.bind(authController));
router.post('/resend-code', authController.resendCode.bind(authController));

// New forgot password flow routes
router.post('/forgot-password-new', authController.forgotPassword.bind(authController));
router.post('/verify-reset-code', authController.verifyResetCode.bind(authController));
router.post('/reset-password-with-code', authController.resetPasswordWithCode.bind(authController));

// Set password after verification
router.post('/set-password', authController.setPassword.bind(authController));

// Protected routes
router.get('/me', authenticate, authController.getCurrentUser.bind(authController));

export default router;


