import { Router } from 'express';
import livestreamController from './livestream.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

router.get('/streams', livestreamController.getStreams.bind(livestreamController));
router.get('/streams/:id', livestreamController.getStream.bind(livestreamController));
router.post('/streams/:id/join', authenticate, livestreamController.joinStream.bind(livestreamController));
router.post('/streams/:id/leave', authenticate, livestreamController.leaveStream.bind(livestreamController));
router.post('/streams/:id/chat', authenticate, livestreamController.sendChatMessage.bind(livestreamController));
router.get('/streams/:id/chat', livestreamController.getChatMessages.bind(livestreamController));

export default router;

