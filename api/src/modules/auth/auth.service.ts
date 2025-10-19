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

    // Generate email verification token
    const verificationToken = generateRandomToken();
    const verificationExpiry = getTokenExpiry(24); // 24 hours

    // Create user and auth record in a transaction
    const user = await prisma.user.create({
      data: {
        email: data.email.toLowerCase(),
        password: hashedPassword,
        firstName: data.firstName,
        lastName: data.lastName,
        userAuth: {
          create: {
            emailVerificationToken: verificationToken,
            verificationExpiry,
          },
        },
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

    // Generate tokens
    const accessToken = generateAccessToken({ userId: user.id, email: user.email });
    const refreshToken = generateRefreshToken({ userId: user.id, email: user.email });

    // Store refresh token
    await prisma.userAuth.update({
      where: { userId: user.id },
      data: {
        refreshToken,
        refreshTokenExpiry: getTokenExpiry(30 * 24), // 30 days
      },
    });

    // TODO: Send verification email

    return {
      user,
      accessToken,
      refreshToken,
      verificationToken, // For development/testing
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
        userAuth: true,
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
    await prisma.userAuth.update({
      where: { userId: user.id },
      data: {
        refreshToken,
        refreshTokenExpiry: getTokenExpiry(30 * 24), // 30 days
        authToken: accessToken,
        tokenExpiry: getTokenExpiry(1), // 1 hour (longer than JWT for leeway)
      },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
      },
      accessToken,
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
      const userAuth = await prisma.userAuth.findFirst({
        where: {
          userId: decoded.userId,
          refreshToken: refreshTokenString,
        },
        include: {
          user: {
            select: {
              id: true,
              email: true,
            },
          },
        },
      });

      if (!userAuth || !userAuth.user) {
        throw new AppError('Invalid refresh token', 401);
      }

      // Check if refresh token is expired
      if (userAuth.refreshTokenExpiry && new Date() > userAuth.refreshTokenExpiry) {
        throw new AppError('Refresh token expired', 401);
      }

      // Generate new tokens
      const accessToken = generateAccessToken({
        userId: userAuth.user.id,
        email: userAuth.user.email,
      });
      const newRefreshToken = generateRefreshToken({
        userId: userAuth.user.id,
        email: userAuth.user.email,
      });

      // Update tokens in database
      await prisma.userAuth.update({
        where: { userId: userAuth.userId },
        data: {
          refreshToken: newRefreshToken,
          refreshTokenExpiry: getTokenExpiry(30 * 24),
          authToken: accessToken,
          tokenExpiry: getTokenExpiry(1),
        },
      });

      return {
        accessToken,
        refreshToken: newRefreshToken,
      };
    } catch (error) {
      throw new AppError('Invalid refresh token', 401);
    }
  }

  /**
   * Verify email
   */
  async verifyEmail(token: string) {
    const userAuth = await prisma.userAuth.findFirst({
      where: {
        emailVerificationToken: token,
      },
    });

    if (!userAuth) {
      throw new AppError('Invalid verification token', 400);
    }

    if (userAuth.verificationExpiry && new Date() > userAuth.verificationExpiry) {
      throw new AppError('Verification token expired', 400);
    }

    // Mark email as verified
    await prisma.userAuth.update({
      where: { userId: userAuth.userId },
      data: {
        isEmailVerified: true,
        emailVerificationToken: null,
        verificationExpiry: null,
      },
    });

    return { message: 'Email verified successfully' };
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
    await prisma.userAuth.update({
      where: { userId: user.id },
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
    const userAuth = await prisma.userAuth.findFirst({
      where: {
        resetToken: token,
      },
    });

    if (!userAuth) {
      throw new AppError('Invalid reset token', 400);
    }

    if (userAuth.resetTokenExpiry && new Date() > userAuth.resetTokenExpiry) {
      throw new AppError('Reset token expired', 400);
    }

    // Hash new password
    const hashedPassword = await hashPassword(newPassword);

    // Update password and clear reset token
    await prisma.$transaction([
      prisma.user.update({
        where: { id: userAuth.userId },
        data: { password: hashedPassword },
      }),
      prisma.userAuth.update({
        where: { userId: userAuth.userId },
        data: {
          resetToken: null,
          resetTokenExpiry: null,
        },
      }),
    ]);

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
        userAuth: {
          select: {
            isEmailVerified: true,
          },
        },
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return user;
  }
}

export default new AuthService();

