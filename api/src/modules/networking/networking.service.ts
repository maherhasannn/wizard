import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';
import { ConnectionStatus, SwipeDirection } from '@prisma/client';
import { Storage } from '@google-cloud/storage';
import path from 'path';
import { v4 as uuidv4 } from 'uuid';

class NetworkingService {
  private storage: Storage;

  constructor() {
    this.storage = new Storage({
      projectId: process.env.GOOGLE_CLOUD_PROJECT_ID,
      keyFilename: process.env.GOOGLE_CLOUD_KEY_FILE,
    });
  }

  async updateProfile(userId: number, data: any) {
    const profile = await prisma.networkProfile.upsert({
      where: { userId },
      create: { userId, ...data },
      update: data,
    });
    return profile;
  }

  async createOrUpdateProfile(userId: number, profileData: any) {
    const {
      firstName,
      lastName,
      birthday,
      gender,
      country,
      city,
      instagramHandle,
      interests,
      isProfilePublic
    } = profileData;

    // Update user basic info
    const user = await prisma.user.update({
      where: { id: userId },
      data: {
        firstName,
        lastName,
        birthday: new Date(birthday),
        gender,
        country,
        city,
        instagramHandle,
        interests,
        isProfilePublic: isProfilePublic ?? true,
      },
    });

    // Create or update network profile
    const networkProfile = await prisma.networkProfile.upsert({
      where: { userId },
      create: {
        userId,
        visibility: isProfilePublic ? 'PUBLIC' : 'PRIVATE',
        lookingFor: 'FRIENDS',
        bio: '',
        interests,
      },
      update: {
        visibility: isProfilePublic ? 'PUBLIC' : 'PRIVATE',
        interests,
      },
    });

    return {
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        birthday: user.birthday,
        gender: user.gender,
        country: user.country,
        city: user.city,
        instagramHandle: user.instagramHandle,
        interests: user.interests,
        isProfilePublic: user.isProfilePublic,
        profilePhoto: user.profilePhoto,
      },
      networkProfile,
    };
  }

  async uploadProfilePhoto(userId: number, file: any) {
    try {
      const bucketName = process.env.GOOGLE_CLOUD_STORAGE_BUCKET || 'wizard-media';
      const fileName = `profile-photos/${userId}/${uuidv4()}${path.extname(file.originalname)}`;
      
      const bucket = this.storage.bucket(bucketName);
      const fileUpload = bucket.file(fileName);

      const stream = fileUpload.createWriteStream({
        metadata: {
          contentType: file.mimetype,
        },
        resumable: false,
      });

      return new Promise((resolve, reject) => {
        stream.on('error', (err) => {
          console.error('❌ [GCS] Upload error:', err);
          reject(new AppError('Failed to upload photo', 500));
        });

        stream.on('finish', async () => {
          try {
            // Make the file public
            await fileUpload.makePublic();
            
            const publicUrl = `https://storage.googleapis.com/${bucketName}/${fileName}`;
            
            // Update user's profile photo URL
            await prisma.user.update({
              where: { id: userId },
              data: { profilePhoto: publicUrl },
            });

            console.log('✅ [GCS] Photo uploaded successfully:', publicUrl);
            resolve({ photoUrl: publicUrl });
          } catch (err) {
            console.error('❌ [GCS] Error updating database:', err);
            reject(new AppError('Failed to save photo URL', 500));
          }
        });

        stream.end(file.buffer);
      });
    } catch (error) {
      console.error('❌ [GCS] Upload error:', error);
      throw new AppError('Failed to upload photo', 500);
    }
  }

  async getMyProfile(userId: number) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        birthday: true,
        gender: true,
        country: true,
        city: true,
        instagramHandle: true,
        interests: true,
        isProfilePublic: true,
        profilePhoto: true,
        networkProfile: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return user;
  }

  async discover(userId: number, limit: number = 20) {
    const swipedUserIds = await prisma.userSwipe.findMany({
      where: { swiperId: userId },
      select: { swipedUserId: true },
    });
    const swipedIds = swipedUserIds.map(s => s.swipedUserId);

    const users = await prisma.user.findMany({
      where: {
        id: { notIn: [...swipedIds, userId] },
        isProfilePublic: true,
      },
      take: limit,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        bio: true,
        city: true,
        country: true,
        interests: true,
        networkProfile: true,
      },
    });

    return users;
  }

  async recordSwipe(userId: number, swipedUserId: number, direction: SwipeDirection) {
    await prisma.userSwipe.create({
      data: {
        swiperId: userId,
        swipedUserId,
        direction,
      },
    });

    // If right swipe, check for match
    if (direction === 'RIGHT') {
      const reciprocalSwipe = await prisma.userSwipe.findUnique({
        where: {
          swiperId_swipedUserId: {
            swiperId: swipedUserId,
            swipedUserId: userId,
          },
        },
      });

      if (reciprocalSwipe && reciprocalSwipe.direction === 'RIGHT') {
        // Create connection
        await prisma.connection.create({
          data: {
            requesterId: userId,
            receiverId: swipedUserId,
            status: 'ACCEPTED',
            acceptedAt: new Date(),
          },
        });
        return { matched: true };
      }
    }

    return { matched: false };
  }

  async getConnections(userId: number, status?: ConnectionStatus) {
    const where: any = {
      OR: [{ requesterId: userId }, { receiverId: userId }],
    };

    if (status) {
      where.status = status;
    }

    const connections = await prisma.connection.findMany({
      where,
      include: {
        requester: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
            city: true,
            country: true,
          },
        },
        receiver: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            profilePhoto: true,
            city: true,
            country: true,
          },
        },
      },
    });

    return connections.map(conn => ({
      ...conn,
      user: conn.requesterId === userId ? conn.receiver : conn.requester,
    }));
  }

  async sendConnectionRequest(userId: number, targetUserId: number) {
    const connection = await prisma.connection.create({
      data: {
        requesterId: userId,
        receiverId: targetUserId,
        status: 'PENDING',
      },
    });
    return connection;
  }

  async acceptConnection(userId: number, connectionId: number) {
    const connection = await prisma.connection.findUnique({
      where: { id: connectionId },
    });

    if (!connection || connection.receiverId !== userId) {
      throw new AppError('Connection not found', 404);
    }

    return prisma.connection.update({
      where: { id: connectionId },
      data: { status: 'ACCEPTED', acceptedAt: new Date() },
    });
  }

  async rejectConnection(userId: number, connectionId: number) {
    const connection = await prisma.connection.findUnique({
      where: { id: connectionId },
    });

    if (!connection || connection.receiverId !== userId) {
      throw new AppError('Connection not found', 404);
    }

    return prisma.connection.update({
      where: { id: connectionId },
      data: { status: 'REJECTED' },
    });
  }

  async searchUsers(query: string, limit: number = 20) {
    const users = await prisma.user.findMany({
      where: {
        isProfilePublic: true,
        OR: [
          { firstName: { contains: query, mode: 'insensitive' } },
          { lastName: { contains: query, mode: 'insensitive' } },
          { city: { contains: query, mode: 'insensitive' } },
        ],
      },
      take: limit,
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        city: true,
        country: true,
        bio: true,
      },
    });

    return users;
  }

  async getUserProfile(userId: number, targetUserId: number) {
    const user = await prisma.user.findUnique({
      where: { id: targetUserId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        bio: true,
        city: true,
        country: true,
        interests: true,
        instagramHandle: true,
        networkProfile: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    // Record view
    await prisma.userView.create({
      data: {
        viewerId: userId,
        viewedUserId: targetUserId,
      },
    }).catch(() => {}); // Ignore if already viewed

    return user;
  }

  async updateLocation(userId: number, latitude: number, longitude: number) {
    await prisma.networkProfile.upsert({
      where: { userId },
      create: {
        userId,
        latitude,
        longitude,
        lastLocationUpdate: new Date(),
      },
      update: {
        latitude,
        longitude,
        lastLocationUpdate: new Date(),
      },
    });

    return { message: 'Location updated' };
  }
}

export default new NetworkingService();


