"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const password_1 = require("../src/lib/password");
const prisma = new client_1.PrismaClient();
async function main() {
    console.log('🌱 Starting seed...');
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
    const hashedPassword = await (0, password_1.hashPassword)('password123');
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
    const meditationArtists = ['@monocorde', '@thewizard', '@innerpeace', '@calmvoice', '@zenmaster'];
    const meditationTitles = [
        'Morning Meditation', 'Deep Sleep Journey', 'Stress Relief', 'Focus & Clarity',
        'Inner Peace', 'Breath Awareness', 'Body Scan', 'Loving Kindness',
        'Chakra Healing', 'Mindful Walking', 'Gratitude Practice', 'Sleep Sounds',
        'Ocean Waves', 'Forest Ambience', 'Rain Meditation', 'Tibetan Bowls',
    ];
    const tracks = await Promise.all(Array.from({ length: 50 }, (_, i) => {
        const categories = ['AUDIO', 'MUSIC', 'SLEEP'];
        return prisma.meditationTrack.create({
            data: {
                title: meditationTitles[i % meditationTitles.length] + ` ${Math.floor(i / meditationTitles.length) + 1}`,
                artist: meditationArtists[i % meditationArtists.length],
                description: 'A peaceful meditation session to calm your mind and body',
                category: categories[i % 3],
                duration: 180 + Math.floor(Math.random() * 420),
                audioUrl: `https://storage.wizard.app/meditation/track_${i + 1}.mp3`,
                imageUrl: `https://storage.wizard.app/meditation/cover_${i + 1}.jpg`,
                isPremium: i % 5 === 0,
                playCount: Math.floor(Math.random() * 1000),
                favoriteCount: Math.floor(Math.random() * 200),
                sortOrder: i,
            },
        });
    }));
    console.log(`✅ Created ${tracks.length} meditation tracks`);
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
    const videoTitles = [
        'Introduction to Meditation', 'Breathing Techniques', 'Yoga for Beginners',
        'Mindfulness in Daily Life', 'Managing Stress', 'Better Sleep Tips',
        'Morning Routines', 'Evening Wind Down', 'Chakra Healing', 'Sound Bath Experience',
    ];
    const videos = await Promise.all(Array.from({ length: 20 }, (_, i) => {
        return prisma.video.create({
            data: {
                title: videoTitles[i % videoTitles.length] + (i >= 10 ? ' Part 2' : ''),
                description: 'Learn powerful techniques to improve your wellbeing',
                thumbnailUrl: `https://storage.wizard.app/videos/thumb_${i + 1}.jpg`,
                videoUrl: `https://storage.wizard.app/videos/video_${i + 1}.mp4`,
                duration: 300 + Math.floor(Math.random() * 900),
                category: ['tutorial', 'practice', 'workshop'][i % 3],
                viewCount: Math.floor(Math.random() * 5000),
            },
        });
    }));
    console.log(`✅ Created ${videos.length} videos`);
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
    const affirmations = await Promise.all(Array.from({ length: 30 }, (_, i) => {
        return prisma.affirmation.create({
            data: {
                title: `Daily Affirmation ${i + 1}`,
                content: affirmationContents[i % affirmationContents.length],
                category: ['love', 'abundance', 'peace', 'strength'][i % 4],
                imageUrl: `https://storage.wizard.app/affirmations/img_${i + 1}.jpg`,
            },
        });
    }));
    console.log(`✅ Created ${affirmations.length} affirmations`);
    const cardTypes = ['The Sun', 'The Moon', 'The Star', 'The World', 'The Magician', 'The Empress', 'The Hermit'];
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const messages = await Promise.all(Array.from({ length: 7 }, (_, i) => {
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
    }));
    console.log(`✅ Created ${messages.length} messages of the day`);
    const streams = await Promise.all([
        prisma.liveStream.create({
            data: {
                title: 'Morning Meditation Session',
                description: 'Start your day with guided meditation',
                hostId: users[0].id,
                thumbnailUrl: 'https://storage.wizard.app/streams/morning.jpg',
                status: 'SCHEDULED',
                scheduledAt: new Date(Date.now() + 86400000),
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
//# sourceMappingURL=seed.js.map