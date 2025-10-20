import { Router } from 'express';
import meditationController from './meditation.controller';
import { authenticate, optionalAuthenticate } from '../../middleware/authMiddleware';

const router = Router();

// Public/optional auth routes
router.get('/tracks', optionalAuthenticate, meditationController.getTracks.bind(meditationController));
router.get('/tracks/:id', optionalAuthenticate, meditationController.getTrack.bind(meditationController));

// Protected routes
router.post('/tracks/:id/favorite', authenticate, meditationController.addToFavorites.bind(meditationController));
router.delete('/tracks/:id/favorite', authenticate, meditationController.removeFromFavorites.bind(meditationController));
router.get('/favorites', authenticate, meditationController.getFavorites.bind(meditationController));
router.post('/tracks/:id/play', authenticate, meditationController.recordPlay.bind(meditationController));
router.get('/history', authenticate, meditationController.getHistory.bind(meditationController));
router.get('/stats', authenticate, meditationController.getStats.bind(meditationController));

export default router;


