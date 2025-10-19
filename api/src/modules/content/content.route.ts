import { Router } from 'express';
import contentController from './content.controller';
import { authenticate, optionalAuthenticate } from '../../middleware/authMiddleware';

const router = Router();

router.get('/message-of-day', contentController.getMessageOfDay.bind(contentController));
router.get('/videos', contentController.getVideos.bind(contentController));
router.get('/videos/:id', contentController.getVideo.bind(contentController));
router.post('/videos/:id/view', authenticate, contentController.recordVideoView.bind(contentController));
router.get('/affirmations', contentController.getAffirmations.bind(contentController));
router.get('/affirmations/:id', contentController.getAffirmation.bind(contentController));
router.post('/affirmations/:id/interact', authenticate, contentController.recordAffirmationInteraction.bind(contentController));

export default router;

