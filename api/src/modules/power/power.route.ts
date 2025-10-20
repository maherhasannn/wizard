import { Router } from 'express';
import powerController from './power.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

router.get('/categories', powerController.getCategories.bind(powerController));
router.post('/select', authenticate, powerController.saveSelections.bind(powerController));
router.get('/selected', authenticate, powerController.getSelections.bind(powerController));

export default router;


