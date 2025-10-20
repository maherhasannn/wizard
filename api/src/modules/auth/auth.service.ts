import prisma from '../../lib/prismaClient';
import { hashPassword, verifyPassword } from '../../lib/password';
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  generateRandomToken,
  getTokenExpiry,
} from '../../lib/jwt';
import { AppError } from '../../middleware/errorHandler';

interface RegisterData {
  email: string;
  password: string;
  firstName?: string;
  lastName?: string;
}

interface LoginData {
  email: string;
  password: string;
}

class AuthService {
  /**
   * Register a new user
   */
  async register(data: RegisterData) {
    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email: data.email.toLowerCase() },
    });

    if (existingUser) {
      throw new AppError('User with this email already exists', 409);
    }

    // Hash password
    const hashedPassword = await hashPassword(data.password);

    // Generate tokens
    const tempUserId = 0; // Temporary, will be replaced after user creation
    const refreshToken = generateRefreshToken({ userId: tempUserId, email: data.email.toLowerCase() });

    // Create user with refresh token
    const user = await prisma.user.create({
      data: {
        email: data.email.toLowerCase(),
        password: hashedPassword,
        firstName: data.firstName,
        lastName: data.lastName,
        refreshToken,
        refreshTokenExpiry: getTokenExpiry(30 * 24), // 30 days
        userSettings: {
          create: {},
        },
      },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        createdAt: true,
      },
    });

    // Generate access token with actual user ID
    const accessToken = generateAccessToken({ userId: user.id, email: user.email });

    return {
      user,
      token: accessToken,
      refreshToken,
    };
  }

  /**
   * Login user
   */
  async login(data: LoginData) {
    // Find user
    const user = await prisma.user.findUnique({
      where: { email: data.email.toLowerCase() },
      select: {
        id: true,
        email: true,
        password: true,
        firstName: true,
        lastName: true,
      },
    });

    if (!user) {
      throw new AppError('Invalid email or password', 401);
    }

    // Verify password
    const isValidPassword = await verifyPassword(user.password, data.password);

    if (!isValidPassword) {
      throw new AppError('Invalid email or password', 401);
    }

    // Generate new tokens
    const accessToken = generateAccessToken({ userId: user.id, email: user.email });
    const refreshToken = generateRefreshToken({ userId: user.id, email: user.email });

    // Update refresh token
    await prisma.user.update({
      where: { id: user.id },
      data: {
        refreshToken,
        refreshTokenExpiry: getTokenExpiry(30 * 24), // 30 days
      },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
      },
      token: accessToken,
      refreshToken,
    };
  }

  /**
   * Refresh access token
   */
  async refreshToken(refreshTokenString: string) {
    try {
      // Verify refresh token
      const decoded = verifyRefreshToken(refreshTokenString);

      // Check if refresh token exists in database
      const user = await prisma.user.findFirst({
        where: {
          id: decoded.userId,
          refreshToken: refreshTokenString,
        },
        select: {
          id: true,
          email: true,
          refreshTokenExpiry: true,
        },
      });

      if (!user) {
        throw new AppError('Invalid refresh token', 401);
      }

      // Check if refresh token is expired
      if (user.refreshTokenExpiry && new Date() > user.refreshTokenExpiry) {
        throw new AppError('Refresh token expired', 401);
      }

      // Generate new tokens
      const accessToken = generateAccessToken({
        userId: user.id,
        email: user.email,
      });
      const newRefreshToken = generateRefreshToken({
        userId: user.id,
        email: user.email,
      });

      // Update tokens in database
      await prisma.user.update({
        where: { id: user.id },
        data: {
          refreshToken: newRefreshToken,
          refreshTokenExpiry: getTokenExpiry(30 * 24),
        },
      });

      return {
        token: accessToken,
        refreshToken: newRefreshToken,
      };
    } catch (error) {
      throw new AppError('Invalid refresh token', 401);
    }
  }

  /**
   * Request password reset
   */
  async requestPasswordReset(email: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!user) {
      // Don't reveal if user exists
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // Generate reset token
    const resetToken = generateRandomToken();
    const resetTokenExpiry = getTokenExpiry(1); // 1 hour

    // Store reset token
    await prisma.user.update({
      where: { id: user.id },
      data: {
        resetToken,
        resetTokenExpiry,
      },
    });

    // TODO: Send password reset email

    return {
      message: 'If the email exists, a reset link has been sent',
      resetToken, // For development/testing
    };
  }

  /**
   * Reset password
   */
  async resetPassword(token: string, newPassword: string) {
    const user = await prisma.user.findFirst({
      where: {
        resetToken: token,
      },
    });

    if (!user) {
      throw new AppError('Invalid reset token', 400);
    }

    if (user.resetTokenExpiry && new Date() > user.resetTokenExpiry) {
      throw new AppError('Reset token expired', 400);
    }

    // Hash new password
    const hashedPassword = await hashPassword(newPassword);

    // Update password and clear reset token
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        resetToken: null,
        resetTokenExpiry: null,
      },
    });

    return { message: 'Password reset successfully' };
  }

  /**
   * Get current user
   */
  async getCurrentUser(userId: number) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        profilePhoto: true,
        bio: true,
        createdAt: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return user;
  }
}

export default new AuthService();


