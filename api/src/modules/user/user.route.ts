import { Router } from 'express';
import userController from './user.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

// All user routes require authentication
router.use(authenticate);

router.get('/profile', userController.getProfile.bind(userController));
router.put('/profile', userController.updateProfile.bind(userController));
router.post('/upload-photo', userController.uploadPhoto.bind(userController));
router.get('/settings', userController.getSettings.bind(userController));
router.put('/settings', userController.updateSettings.bind(userController));
router.delete('/account', userController.deleteAccount.bind(userController));

export default router;


