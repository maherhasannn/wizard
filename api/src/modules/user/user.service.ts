import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';

interface UpdateProfileData {
  firstName?: string;
  lastName?: string;
  phone?: string;
  bio?: string;
  birthday?: Date;
  gender?: string;
  country?: string;
  city?: string;
  instagramHandle?: string;
  interests?: string[];
  isProfilePublic?: boolean;
}

interface UpdateSettingsData {
  pushNotifications?: boolean;
  emailNotifications?: boolean;
  darkMode?: boolean;
  language?: string;
  timezone?: string;
}

class UserService {
  /**
   * Get user profile
   */
  async getProfile(userId: number) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        profilePhoto: true,
        bio: true,
        birthday: true,
        gender: true,
        country: true,
        city: true,
        instagramHandle: true,
        interests: true,
        isProfilePublic: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return user;
  }

  /**
   * Update user profile
   */
  async updateProfile(userId: number, data: UpdateProfileData) {
    const user = await prisma.user.update({
      where: { id: userId },
      data,
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        phone: true,
        profilePhoto: true,
        bio: true,
        birthday: true,
        gender: true,
        country: true,
        city: true,
        instagramHandle: true,
        interests: true,
        isProfilePublic: true,
        updatedAt: true,
      },
    });

    return user;
  }

  /**
   * Update profile photo
   */
  async updateProfilePhoto(userId: number, photoUrl: string) {
    const user = await prisma.user.update({
      where: { id: userId },
      data: { profilePhoto: photoUrl },
      select: {
        id: true,
        profilePhoto: true,
      },
    });

    return user;
  }

  /**
   * Get user settings
   */
  async getSettings(userId: number) {
    let settings = await prisma.userSettings.findUnique({
      where: { userId },
    });

    // Create settings if they don't exist
    if (!settings) {
      settings = await prisma.userSettings.create({
        data: { userId },
      });
    }

    return settings;
  }

  /**
   * Update user settings
   */
  async updateSettings(userId: number, data: UpdateSettingsData) {
    // Ensure settings exist
    await this.getSettings(userId);

    const settings = await prisma.userSettings.update({
      where: { userId },
      data,
    });

    return settings;
  }

  /**
   * Delete user account
   */
  async deleteAccount(userId: number) {
    // Delete user (cascade will handle related records)
    await prisma.user.delete({
      where: { id: userId },
    });

    return { message: 'Account deleted successfully' };
  }
}

export default new UserService();

