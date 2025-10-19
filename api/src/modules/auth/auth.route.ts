import { Router } from 'express';
import authController from './auth.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

// Public routes
router.post('/register', authController.register.bind(authController));
router.post('/login', authController.login.bind(authController));
router.post('/refresh', authController.refreshToken.bind(authController));
router.post('/verify-email', authController.verifyEmail.bind(authController));
router.post('/forgot-password', authController.requestPasswordReset.bind(authController));
router.post('/reset-password', authController.resetPassword.bind(authController));

// Protected routes
router.get('/me', authenticate, authController.getCurrentUser.bind(authController));

export default router;

