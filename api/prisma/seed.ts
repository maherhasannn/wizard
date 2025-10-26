import { PrismaClient } from '@prisma/client';
import { hashPassword } from '../src/lib/password';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');

  // Clean existing data (in correct order due to foreign keys)
  await prisma.userRitualCompletion.deleteMany();
  await prisma.userChallenge.deleteMany();
  await prisma.ritual.deleteMany();
  await prisma.challenge.deleteMany();
  await prisma.userPowerSelection.deleteMany();
  await prisma.powerCategory.deleteMany();
  await prisma.liveStreamChat.deleteMany();
  await prisma.liveStreamParticipant.deleteMany();
  await prisma.liveStream.deleteMany();
  await prisma.userAffirmationInteraction.deleteMany();
  await prisma.affirmation.deleteMany();
  await prisma.userVideoView.deleteMany();
  await prisma.video.deleteMany();
  await prisma.messageOfDay.deleteMany();
  await prisma.userView.deleteMany();
  await prisma.userSwipe.deleteMany();
  await prisma.connection.deleteMany();
  await prisma.networkProfile.deleteMany();
  await prisma.eventReminder.deleteMany();
  await prisma.calendarEvent.deleteMany();
  await prisma.userMeditationStats.deleteMany();
  await prisma.userMeditationHistory.deleteMany();
  await prisma.userMeditationFavorite.deleteMany();
  await prisma.meditationTrack.deleteMany();
  await prisma.userSettings.deleteMany();
  await prisma.user.deleteMany();

  console.log('✅ Cleaned existing data');

  // Create test users
  const hashedPassword = await hashPassword('password123');
  
  const users = await Promise.all([
    prisma.user.create({
      data: {
        email: 'gabriella@wizard.app',
        password: hashedPassword,
        firstName: 'Gabriella',
        lastName: 'Martinez',
        bio: 'Meditation enthusiast and wellness coach',
        city: 'Barcelona',
        country: 'Spain',
        interests: ['meditation', 'yoga', 'mindfulness', 'wellness'],
        isProfilePublic: true,
        userSettings: { create: {} },
      },
    }),
    ...Array.from({ length: 29 }, (_, i) => {
      const firstNames = ['Alex', 'Sam', 'Jordan', 'Taylor', 'Morgan', 'Casey', 'Riley', 'Avery', 'Quinn', 'Blake'];
      const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'];
      const cities = ['Barcelona', 'Madrid', 'Paris', 'London', 'Berlin', 'Rome', 'Amsterdam', 'Lisbon', 'Vienna', 'Prague'];
      
      return prisma.user.create({
        data: {
          email: `user${i + 1}@wizard.app`,
          password: hashedPassword,
          firstName: firstNames[i % firstNames.length],
          lastName: lastNames[i % lastNames.length],
          bio: `Passionate about meditation and personal growth`,
          city: cities[i % cities.length],
          country: 'Europe',
          interests: ['meditation', 'wellness', 'mindfulness'].slice(0, Math.floor(Math.random() * 3) + 1),
          isProfilePublic: true,
          userSettings: { create: {} },
        },
      });
    }),
  ]);

  console.log(`✅ Created ${users.length} users`);

  // Create meditation tracks
  const meditationArtists = ['@monocorde', '@thewizard', '@innerpeace', '@calmvoice', '@zenmaster'];
  const meditationTitles = [
    'Morning Meditation', 'Deep Sleep Journey', 'Stress Relief', 'Focus & Clarity',
    'Inner Peace', 'Breath Awareness', 'Body Scan', 'Loving Kindness',
    'Chakra Healing', 'Mindful Walking', 'Gratitude Practice', 'Sleep Sounds',
    'Ocean Waves', 'Forest Ambience', 'Rain Meditation', 'Tibetan Bowls',
  ];

  const tracks = await Promise.all(
    Array.from({ length: 50 }, (_, i) => {
      const categories = ['AUDIO', 'MUSIC', 'SLEEP'] as const;
      return prisma.meditationTrack.create({
        data: {
          title: meditationTitles[i % meditationTitles.length] + ` ${Math.floor(i / meditationTitles.length) + 1}`,
          artist: meditationArtists[i % meditationArtists.length],
          description: 'A peaceful meditation session to calm your mind and body',
          category: categories[i % 3],
          duration: 180 + Math.floor(Math.random() * 420), // 3-10 minutes
          audioUrl: `https://storage.wizard.app/meditation/track_${i + 1}.mp3`,
          imageUrl: `https://storage.wizard.app/meditation/cover_${i + 1}.jpg`,
          isPremium: i % 5 === 0,
          playCount: Math.floor(Math.random() * 1000),
          favoriteCount: Math.floor(Math.random() * 200),
          sortOrder: i,
        },
      });
    })
  );

  console.log(`✅ Created ${tracks.length} meditation tracks`);

  // Create power categories
  const powerCategories = await Promise.all([
    prisma.powerCategory.create({
      data: {
        name: 'Inner Peace',
        description: 'Find calm and balance in your daily life',
        icon: '🧘',
        sortOrder: 1,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Personal Growth',
        description: 'Develop your potential and achieve your goals',
        icon: '🌱',
        sortOrder: 2,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Relationships',
        description: 'Build meaningful connections with others',
        icon: '💝',
        sortOrder: 3,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Health & Wellness',
        description: 'Nurture your body, mind, and spirit',
        icon: '💪',
        sortOrder: 4,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Creativity',
        description: 'Express yourself and explore your creative side',
        icon: '🎨',
        sortOrder: 5,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Abundance',
        description: 'Cultivate prosperity and gratitude',
        icon: '✨',
        sortOrder: 6,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Wisdom',
        description: 'Deepen your understanding and intuition',
        icon: '🔮',
        sortOrder: 7,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Joy & Happiness',
        description: 'Embrace positivity and celebrate life',
        icon: '😊',
        sortOrder: 8,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Courage',
        description: 'Face challenges with strength and confidence',
        icon: '🦁',
        sortOrder: 9,
      },
    }),
    prisma.powerCategory.create({
      data: {
        name: 'Spirituality',
        description: 'Connect with your higher self',
        icon: '🙏',
        sortOrder: 10,
      },
    }),
  ]);

  console.log(`✅ Created ${powerCategories.length} power categories`);

  // Create videos
  const videoTitles = [
    'Introduction to Meditation', 'Breathing Techniques', 'Yoga for Beginners',
    'Mindfulness in Daily Life', 'Managing Stress', 'Better Sleep Tips',
    'Morning Routines', 'Evening Wind Down', 'Chakra Healing', 'Sound Bath Experience',
  ];

  const videos = await Promise.all(
    Array.from({ length: 20 }, (_, i) => {
      return prisma.video.create({
        data: {
          title: videoTitles[i % videoTitles.length] + (i >= 10 ? ' Part 2' : ''),
          description: 'Learn powerful techniques to improve your wellbeing',
          thumbnailUrl: `https://storage.wizard.app/videos/thumb_${i + 1}.jpg`,
          videoUrl: `https://storage.wizard.app/videos/video_${i + 1}.mp4`,
          duration: 300 + Math.floor(Math.random() * 900), // 5-20 minutes
          category: ['tutorial', 'practice', 'workshop'][i % 3],
          viewCount: Math.floor(Math.random() * 5000),
        },
      });
    })
  );

  console.log(`✅ Created ${videos.length} videos`);

  // Create affirmations
  const affirmationContents = [
    'I am at peace with myself and the world',
    'I trust in my journey and embrace change',
    'I am worthy of love, joy, and abundance',
    'I choose to see the good in every situation',
    'I am grateful for all that I have',
    'I release what no longer serves me',
    'I am strong, capable, and resilient',
    'I attract positive energy and people',
    'I honor my intuition and inner wisdom',
    'I am creating the life I desire',
  ];

  const affirmations = await Promise.all(
    Array.from({ length: 30 }, (_, i) => {
      return prisma.affirmation.create({
        data: {
          title: `Daily Affirmation ${i + 1}`,
          content: affirmationContents[i % affirmationContents.length],
          category: ['love', 'abundance', 'peace', 'strength'][i % 4],
          imageUrl: `https://storage.wizard.app/affirmations/img_${i + 1}.jpg`,
        },
      });
    })
  );

  console.log(`✅ Created ${affirmations.length} affirmations`);

  // Create messages of the day for next 7 days
  const cardTypes = ['The Sun', 'The Moon', 'The Star', 'The World', 'The Magician', 'The Empress', 'The Hermit'];
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const messages = await Promise.all(
    Array.from({ length: 7 }, (_, i) => {
      const date = new Date(today);
      date.setDate(date.getDate() + i);
      
      return prisma.messageOfDay.create({
        data: {
          date,
          title: 'Your Daily Message',
          cardType: cardTypes[i % cardTypes.length],
          shortMessage: 'You will meet your destiny very soon and unexpectedly',
          fullMessage: 'The universe is aligning in your favor. Trust in the journey and remain open to new opportunities. Your path is illuminated by inner wisdom and courage.',
          imageUrl: `https://storage.wizard.app/cards/${cardTypes[i % cardTypes.length].toLowerCase().replace(' ', '_')}.jpg`,
        },
      });
    })
  );

  console.log(`✅ Created ${messages.length} messages of the day`);

  // Create live streams
  const streams = await Promise.all([
    prisma.liveStream.create({
      data: {
        title: 'Morning Meditation Session',
        description: 'Start your day with guided meditation',
        hostId: users[0].id,
        thumbnailUrl: 'https://storage.wizard.app/streams/morning.jpg',
        status: 'SCHEDULED',
        scheduledAt: new Date(Date.now() + 86400000), // Tomorrow
      },
    }),
    prisma.liveStream.create({
      data: {
        title: 'Q&A: Your Wellness Questions',
        description: 'Answering your questions directly in the app',
        hostId: users[0].id,
        thumbnailUrl: 'https://storage.wizard.app/streams/qa.jpg',
        status: 'LIVE',
        viewerCount: 127,
        startedAt: new Date(),
        scheduledAt: new Date(),
      },
    }),
  ]);

  console.log(`✅ Created ${streams.length} live streams`);

  // Create challenges with rituals
  const meditationTracks = await prisma.meditationTrack.findMany();
  
  // Challenge 1: 21 Days of Self-Belief
  const challenge1 = await prisma.challenge.create({
    data: {
      title: '21 Days of Self-Belief',
      subtitle: 'A daily journey to rebuild your confidence step by step',
      description: 'Transform your relationship with yourself through daily confidence-building rituals and empowering practices.',
      duration: 21,
      category: 'CONFIDENCE',
      goals: [
        'Build unshakable self-confidence in everyday life',
        'Silence self-doubt and replace it with empowering thoughts',
        'Step into any situation with presence and certainty'
      ],
      colorTheme: 'purple',
      icon: 'sparkles',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Mirror Affirmations',
            description: 'Powerful self-affirmation practice',
            type: 'TEXT',
            duration: 75, // 1 min 15 sec
            textContent: 'Stand in front of the mirror and say out loud: "I choose myself." Repeat it three times with eye contact, even if it feels uncomfortable.',
          },
        ],
      },
    },
  });

  // Challenge 2: Heartbreak Healing Journey
  const challenge2 = await prisma.challenge.create({
    data: {
      title: 'Heartbreak Healing Journey',
      subtitle: '14 days to heal your heart and rediscover your strength',
      description: 'A guided journey through the stages of healing from heartbreak with daily meditations, journaling, and self-care rituals.',
      duration: 14,
      category: 'HEALING',
      goals: [
        'Release emotional pain and move forward',
        'Rediscover your inner strength and worth',
        'Open your heart to new possibilities'
      ],
      colorTheme: 'pink',
      icon: 'heart',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Healing Breathwork',
            description: 'Release tension and emotional weight',
            type: 'AUDIO',
            duration: 600, // 10 min
            audioUrl: 'https://storage.wizard.app/challenges/healing_breathwork_1.mp3',
          },
        ],
      },
    },
  });

  // Challenge 3: Magnetic Morning Routine
  const challenge3 = await prisma.challenge.create({
    data: {
      title: 'Magnetic Morning Routine',
      subtitle: '7 days to build powerful morning habits',
      description: 'Create an invigorating morning routine that sets the tone for a productive, positive, and empowered day.',
      duration: 7,
      category: 'MORNING_ROUTINE',
      goals: [
        'Establish a consistent morning practice',
        'Increase daily energy and motivation',
        'Start each day with intention and clarity'
      ],
      colorTheme: 'orange',
      icon: 'sunrise',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Gratitude Practice',
            description: 'Begin your day with gratitude',
            type: 'TEXT',
            duration: 300, // 5 min
            textContent: 'Write down three things you\'re grateful for today. Feel the emotion of gratitude as you write each one.',
          },
        ],
      },
    },
  });

  // Challenge 4: Stop Overthinking Challenge
  const challenge4 = await prisma.challenge.create({
    data: {
      title: 'Stop Overthinking Challenge',
      subtitle: '10 days of mental clarity practices',
      description: 'Break free from the cycle of overthinking with practical exercises, mindfulness techniques, and cognitive reframing strategies.',
      duration: 10,
      category: 'MINDFULNESS',
      goals: [
        'Quiet your racing thoughts',
        'Practice mental clarity and presence',
        'Reduce anxiety and decision paralysis'
      ],
      colorTheme: 'beige',
      icon: 'brain',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Mindful Observation',
            description: 'Practice observing without judgment',
            type: 'TEXT',
            duration: 180, // 3 min
            textContent: 'Spend 3 minutes observing a single object in your environment. Notice every detail without forming any thoughts or judgments. Just observe.',
          },
        ],
      },
    },
  });

  // Challenge 5: Attract New Love
  const challenge5 = await prisma.challenge.create({
    data: {
      title: 'Attract New Love',
      subtitle: '21 days of love manifestation rituals',
      description: 'Prepare yourself mentally, emotionally, and energetically to attract meaningful, authentic love into your life.',
      duration: 21,
      category: 'MANIFESTATION',
      goals: [
        'Cultivate self-love as the foundation',
        'Clear blocks to receiving love',
        'Align your energy with loving relationships'
      ],
      colorTheme: 'rose',
      icon: 'hearts',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Self-Love Affirmations',
            description: 'Begin with loving yourself first',
            type: 'TEXT',
            duration: 240, // 4 min
            textContent: 'Stand in front of the mirror and say: "I am worthy of love. I attract healthy, fulfilling relationships. I am ready to receive love."',
          },
        ],
      },
    },
  });

  // Challenge 6: Build Your Foundation
  const challenge6 = await prisma.challenge.create({
    data: {
      title: 'Build Your Foundation',
      subtitle: '30 days of core self-improvement',
      description: 'Build lasting habits and mindset shifts that create a solid foundation for personal growth and transformation.',
      duration: 30,
      category: 'SELF_LOVE',
      goals: [
        'Establish core habits for success',
        'Develop emotional resilience',
        'Build a strong personal foundation'
      ],
      colorTheme: 'blue',
      icon: 'foundation',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Foundation Setting',
            description: 'Set your intention for transformation',
            type: 'TEXT',
            duration: 600, // 10 min
            textContent: 'Write a letter to your future self describing the foundation you want to build over these 30 days. What habits, mindset, and values do you want to establish?',
          },
        ],
      },
    },
  });

  // Challenge 7: Inner Peace Quest
  const challenge7 = await prisma.challenge.create({
    data: {
      title: 'Inner Peace Quest',
      subtitle: '14 days of meditation and mindfulness',
      description: 'Discover lasting inner peace through guided meditation practices, mindfulness techniques, and peace cultivation exercises.',
      duration: 14,
      category: 'MINDFULNESS',
      goals: [
        'Develop a consistent meditation practice',
        'Cultivate inner calm and tranquility',
        'Reduce stress and overwhelm in daily life'
      ],
      colorTheme: 'teal',
      icon: 'lotus',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Breath Awareness Meditation',
            description: 'Begin with the breath',
            type: 'MEDITATION',
            duration: 900, // 15 min
            meditationTrackId: meditationTracks[0]?.id,
          },
        ],
      },
    },
  });

  // Challenge 8: Queen Energy Activation
  const challenge8 = await prisma.challenge.create({
    data: {
      title: 'Queen Energy Activation',
      subtitle: '7 days of feminine power practices',
      description: 'Awaken and activate your divine feminine power through daily rituals, affirmations, and embodied practices.',
      duration: 7,
      category: 'SELF_LOVE',
      goals: [
        'Embrace and embody your feminine power',
        'Release limiting beliefs about power',
        'Stand confidently in your queen energy'
      ],
      colorTheme: 'gold',
      icon: 'crown',
      rituals: {
        create: [
          {
            dayNumber: 1,
            title: 'Crown Activation',
            description: 'Activate your inner queen',
            type: 'TEXT',
            duration: 360, // 6 min
            textContent: 'Place your hands on top of your head (crown chakra). Close your eyes and visualize a golden crown on your head, radiating powerful, confident energy throughout your entire body.',
          },
        ],
      },
    },
  });

  console.log(`✅ Created 8 challenges with rituals`);

  console.log('🎉 Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });


