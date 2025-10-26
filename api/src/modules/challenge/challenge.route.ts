import { Router } from 'express';
import challengeController from './challenge.controller';
import { authenticate, optionalAuthenticate } from '../../middleware/authMiddleware';

const router = Router();

// Public routes (can be viewed without auth)
router.get('/', challengeController.getChallenges.bind(challengeController));
router.get('/:id', optionalAuthenticate, challengeController.getChallengeDetails.bind(challengeController));

// Protected routes (require authentication)
router.use(authenticate);

router.get('/my/active', challengeController.getActiveChallenges.bind(challengeController));
router.post('/:id/start', challengeController.startChallenge.bind(challengeController));
router.post('/:id/pause', challengeController.pauseChallenge.bind(challengeController));
router.post('/:id/resume', challengeController.resumeChallenge.bind(challengeController));
router.post('/:challengeId/rituals/:ritualId/complete', challengeController.completeRitual.bind(challengeController));
router.get('/:id/progress', challengeController.getProgress.bind(challengeController));

export default router;
