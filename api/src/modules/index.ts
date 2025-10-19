import { Router } from 'express';
import authRoutes from './auth/auth.route';
import userRoutes from './user/user.route';
import meditationRoutes from './meditation/meditation.route';
import calendarRoutes from './calendar/calendar.route';
import networkingRoutes from './networking/networking.route';
import contentRoutes from './content/content.route';
import livestreamRoutes from './livestream/livestream.route';
import powerRoutes from './power/power.route';

const router = Router();

// Mount all module routes
router.use('/auth', authRoutes);
router.use('/user', userRoutes);
router.use('/meditation', meditationRoutes);
router.use('/calendar', calendarRoutes);
router.use('/networking', networkingRoutes);
router.use('/content', contentRoutes);
router.use('/livestream', livestreamRoutes);
router.use('/power', powerRoutes);

export default router;

