import { Router } from 'express';
import networkingController from './networking.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.put('/profile', networkingController.updateProfile.bind(networkingController));
router.get('/discover', networkingController.discover.bind(networkingController));
router.post('/swipe', networkingController.recordSwipe.bind(networkingController));
router.get('/connections', networkingController.getConnections.bind(networkingController));
router.post('/connections/request', networkingController.sendConnectionRequest.bind(networkingController));
router.post('/connections/:id/accept', networkingController.acceptConnection.bind(networkingController));
router.post('/connections/:id/reject', networkingController.rejectConnection.bind(networkingController));
router.get('/search', networkingController.searchUsers.bind(networkingController));
router.get('/user/:id', networkingController.getUserProfile.bind(networkingController));
router.post('/location', networkingController.updateLocation.bind(networkingController));

export default router;

