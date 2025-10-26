import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { ChallengeStatus } from '@prisma/client';

class ChallengeService {
  /**
   * Get all available challenges
   */
  async getChallenges() {
    const challenges = await prisma.challenge.findMany({
      where: {
        isActive: true,
      },
      orderBy: {
        sortOrder: 'asc',
      },
      select: {
        id: true,
        title: true,
        subtitle: true,
        description: true,
        duration: true,
        category: true,
        goals: true,
        icon: true,
        colorTheme: true,
        createdAt: true,
        _count: {
          select: {
            rituals: true,
          },
        },
      },
    });

    return challenges;
  }

  /**
   * Get challenge details with all rituals
   */
  async getChallengeDetails(challengeId: number, userId?: number) {
    const challenge = await prisma.challenge.findUnique({
      where: {
        id: challengeId,
        isActive: true,
      },
      include: {
        rituals: {
          where: {
            isActive: true,
          },
          orderBy: {
            dayNumber: 'asc',
          },
        },
      },
    });

    if (!challenge) {
      throw new AppError('Challenge not found', 404);
    }

    // Get user's progress if authenticated
    let userProgress = null;
    if (userId) {
      userProgress = await prisma.userChallenge.findUnique({
        where: {
          userId_challengeId: {
            userId,
            challengeId,
          },
        },
        include: {
          completions: {
            select: {
              ritualId: true,
              completedAt: true,
            },
          },
        },
      });
    }

    return {
      challenge,
      userProgress,
    };
  }

  /**
   * Get user's active challenges
   */
  async getActiveChallenges(userId: number) {
    const userChallenges = await prisma.userChallenge.findMany({
      where: {
        userId,
        status: {
          in: ['ACTIVE', 'PAUSED'],
        },
      },
      include: {
        challenge: {
          select: {
            id: true,
            title: true,
            subtitle: true,
            description: true,
            duration: true,
            category: true,
            goals: true,
            icon: true,
            colorTheme: true,
          },
        },
        completions: {
          select: {
            ritualId: true,
          },
        },
      },
      orderBy: {
        startedAt: 'desc',
      },
    });

    // Get today's ritual for each active challenge
    const activeChallengesWithRituals = await Promise.all(
      userChallenges.map(async (uc) => {
        const todayRitual = await prisma.ritual.findFirst({
          where: {
            challengeId: uc.challengeId,
            dayNumber: uc.currentDay,
            isActive: true,
          },
        });

        const completedRitualIds = new Set(uc.completions.map(c => c.ritualId));

        return {
          ...uc,
          todayRitual,
          completedRitualIds: Array.from(completedRitualIds),
        };
      })
    );

    return activeChallengesWithRituals;
  }

  /**
   * Start a challenge
   */
  async startChallenge(challengeId: number, userId: number) {
    // Check if challenge exists
    const challenge = await prisma.challenge.findUnique({
      where: {
        id: challengeId,
        isActive: true,
      },
    });

    if (!challenge) {
      throw new AppError('Challenge not found', 404);
    }

    // Check if user already has this challenge
    const existing = await prisma.userChallenge.findUnique({
      where: {
        userId_challengeId: {
          userId,
          challengeId,
        },
      },
    });

    if (existing) {
      throw new AppError('Challenge already started', 400);
    }

    // Create user challenge
    const userChallenge = await prisma.userChallenge.create({
      data: {
        userId,
        challengeId,
        status: 'ACTIVE',
        currentDay: 1,
        startedAt: new Date(),
      },
      include: {
        challenge: {
          select: {
            id: true,
            title: true,
            subtitle: true,
            duration: true,
            category: true,
            goals: true,
            icon: true,
            colorTheme: true,
          },
        },
      },
    });

    return userChallenge;
  }

  /**
   * Pause a challenge
   */
  async pauseChallenge(challengeId: number, userId: number) {
    const userChallenge = await prisma.userChallenge.findUnique({
      where: {
        userId_challengeId: {
          userId,
          challengeId,
        },
      },
    });

    if (!userChallenge) {
      throw new AppError('Challenge not found', 404);
    }

    if (userChallenge.status !== 'ACTIVE') {
      throw new AppError('Challenge is not active', 400);
    }

    const updated = await prisma.userChallenge.update({
      where: {
        id: userChallenge.id,
      },
      data: {
        status: 'PAUSED',
        pausedAt: new Date(),
      },
    });

    return updated;
  }

  /**
   * Resume a paused challenge
   */
  async resumeChallenge(challengeId: number, userId: number) {
    const userChallenge = await prisma.userChallenge.findUnique({
      where: {
        userId_challengeId: {
          userId,
          challengeId,
        },
      },
    });

    if (!userChallenge) {
      throw new AppError('Challenge not found', 404);
    }

    if (userChallenge.status !== 'PAUSED') {
      throw new AppError('Challenge is not paused', 400);
    }

    const updated = await prisma.userChallenge.update({
      where: {
        id: userChallenge.id,
      },
      data: {
        status: 'ACTIVE',
        pausedAt: null,
      },
    });

    return updated;
  }

  /**
   * Complete a ritual
   */
  async completeRitual(challengeId: number, ritualId: number, userId: number) {
    // Verify the ritual belongs to the challenge
    const ritual = await prisma.ritual.findFirst({
      where: {
        id: ritualId,
        challengeId,
        isActive: true,
      },
    });

    if (!ritual) {
      throw new AppError('Ritual not found', 404);
    }

    // Get user challenge with challenge details
    const userChallenge = await prisma.userChallenge.findUnique({
      where: {
        userId_challengeId: {
          userId,
          challengeId,
        },
      },
      include: {
        challenge: {
          select: {
            duration: true,
          },
        },
      },
    });

    if (!userChallenge) {
      throw new AppError('Challenge not started', 404);
    }

    if (userChallenge.status !== 'ACTIVE') {
      throw new AppError('Challenge is not active', 400);
    }

    // Check if already completed
    const existing = await prisma.userRitualCompletion.findUnique({
      where: {
        userChallengeId_ritualId: {
          userChallengeId: userChallenge.id,
          ritualId,
        },
      },
    });

    if (existing) {
      throw new AppError('Ritual already completed', 400);
    }

    // Create completion
    await prisma.userRitualCompletion.create({
      data: {
        userId,
        userChallengeId: userChallenge.id,
        ritualId,
      },
    });

    // Get count of completed rituals for current day
    const completedToday = await prisma.userRitualCompletion.count({
      where: {
        userChallengeId: userChallenge.id,
        ritual: {
          challengeId,
          dayNumber: userChallenge.currentDay,
        },
      },
    });

    // Get total rituals for current day
    const totalToday = await prisma.ritual.count({
      where: {
        challengeId,
        dayNumber: userChallenge.currentDay,
        isActive: true,
      },
    });

    // If all rituals for today are completed, advance to next day
    if (completedToday >= totalToday) {
      const nextDay = Math.min(userChallenge.currentDay + 1, userChallenge.challenge.duration);

      await prisma.userChallenge.update({
        where: {
          id: userChallenge.id,
        },
        data: {
          currentDay: nextDay,
          ...(nextDay > userChallenge.challenge.duration && {
            status: 'COMPLETED',
            completedAt: new Date(),
          }),
        },
      });
    }

    return {
      completed: true,
      currentDay: completedToday >= totalToday ? Math.min(userChallenge.currentDay + 1, userChallenge.challenge.duration) : userChallenge.currentDay,
    };
  }

  /**
   * Get user's progress in a challenge
   */
  async getProgress(challengeId: number, userId: number) {
    const userChallenge = await prisma.userChallenge.findUnique({
      where: {
        userId_challengeId: {
          userId,
          challengeId,
        },
      },
      include: {
        challenge: {
          include: {
            rituals: {
              where: {
                isActive: true,
              },
              orderBy: {
                dayNumber: 'asc',
              },
            },
          },
        },
        completions: {
          select: {
            ritualId: true,
            completedAt: true,
          },
        },
      },
    });

    if (!userChallenge) {
      throw new AppError('Challenge not started', 404);
    }

    const completedRitualIds = new Set(userChallenge.completions.map(c => c.ritualId));

    return {
      ...userChallenge,
      completedRitualIds: Array.from(completedRitualIds),
    };
  }
}

export default new ChallengeService();
