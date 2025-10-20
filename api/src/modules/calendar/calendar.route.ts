import { Router } from 'express';
import calendarController from './calendar.controller';
import { authenticate } from '../../middleware/authMiddleware';

const router = Router();

router.use(authenticate);

router.get('/events', calendarController.getEvents.bind(calendarController));
router.post('/events', calendarController.createEvent.bind(calendarController));
router.get('/events/:id', calendarController.getEvent.bind(calendarController));
router.put('/events/:id', calendarController.updateEvent.bind(calendarController));
router.delete('/events/:id', calendarController.deleteEvent.bind(calendarController));
router.post('/events/:id/complete', calendarController.completeEvent.bind(calendarController));
router.get('/upcoming', calendarController.getUpcoming.bind(calendarController));

export default router;


