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
import { sendEmail, createVerificationEmail, createPasswordResetEmail, generateVerificationCode } from '../../lib/emailService';

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
      throw new AppError('Email already exists', 409);
    }

    // Generate verification code
    const verificationCode = generateVerificationCode();
    const verificationCodeExpiry = getTokenExpiry(10); // 10 minutes

    // Create user account immediately with email verification required
    const user = await prisma.user.create({
      data: {
        email: data.email.toLowerCase(),
        password: data.password, // Will be set after verification
        firstName: data.firstName,
        lastName: data.lastName,
        isEmailVerified: false,
        verificationCode,
        verificationCodeExpiry,
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

    // Send verification email
    const emailTemplate = createVerificationEmail(verificationCode);
    await sendEmail(user.email, emailTemplate);

    return {
      user,
      message: 'Registration successful. Please check your email for verification code.',
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
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Incorrect password', 401);
    }

    // Check if email is verified
    if (!user.isEmailVerified) {
      throw new AppError('Please verify your email before logging in', 401);
    }

    // Verify password
    const isValidPassword = await verifyPassword(user.password, data.password);

    if (!isValidPassword) {
      throw new AppError('Incorrect password', 401);
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

  /**
   * Verify email with 6-digit code
   */
  async verifyEmail(email: string, code: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        verificationCode: true,
        verificationCodeExpiry: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Incorrect code', 400);
    }

    if (user.isEmailVerified) {
      throw new AppError('Email already verified', 400);
    }

    if (!user.verificationCode || !user.verificationCodeExpiry) {
      throw new AppError('No verification code found', 400);
    }

    if (user.verificationCode !== code) {
      throw new AppError('Incorrect code', 400);
    }

    if (new Date() > user.verificationCodeExpiry) {
      throw new AppError('Code expired - please request a new one', 400);
    }

    // Mark email as verified and clear verification code
    await prisma.user.update({
      where: { id: user.id },
      data: {
        isEmailVerified: true,
        verificationCode: null,
        verificationCodeExpiry: null,
      },
    });

    // Generate tokens for immediate login
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
      },
      token: accessToken,
      refreshToken,
    };
  }

  /**
   * Resend verification code
   */
  async resendVerificationCode(email: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Email address is not valid', 400);
    }

    if (user.isEmailVerified) {
      throw new AppError('Email already verified', 400);
    }

    // Generate new verification code
    const verificationCode = generateVerificationCode();
    const verificationCodeExpiry = getTokenExpiry(10); // 10 minutes

    // Update verification code
    await prisma.user.update({
      where: { id: user.id },
      data: {
        verificationCode,
        verificationCodeExpiry,
      },
    });

    // Send verification email
    const emailTemplate = createVerificationEmail(verificationCode);
    await sendEmail(user.email, emailTemplate);

    return { message: 'Verification code sent successfully' };
  }

  /**
   * Forgot password - send reset code
   */
  async forgotPassword(email: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Email address is not valid', 400);
    }

    if (!user.isEmailVerified) {
      throw new AppError('Please verify your email first', 400);
    }

    // Generate reset code
    const resetCode = generateVerificationCode();
    const resetCodeExpiry = getTokenExpiry(10); // 10 minutes

    // Store reset code (using verification code fields for password reset)
    await prisma.user.update({
      where: { id: user.id },
      data: {
        verificationCode: resetCode,
        verificationCodeExpiry: resetCodeExpiry,
      },
    });

    // Send reset email
    const emailTemplate = createPasswordResetEmail(resetCode);
    await sendEmail(user.email, emailTemplate);

    return { message: 'Password reset code sent successfully' };
  }

  /**
   * Verify reset code
   */
  async verifyResetCode(email: string, code: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        verificationCode: true,
        verificationCodeExpiry: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Incorrect code', 400);
    }

    if (!user.isEmailVerified) {
      throw new AppError('Please verify your email first', 400);
    }

    if (!user.verificationCode || !user.verificationCodeExpiry) {
      throw new AppError('No reset code found', 400);
    }

    if (user.verificationCode !== code) {
      throw new AppError('Incorrect code', 400);
    }

    if (new Date() > user.verificationCodeExpiry) {
      throw new AppError('Code expired - please request a new one', 400);
    }

    return { message: 'Reset code verified successfully' };
  }

  /**
   * Reset password with code
   */
  async resetPasswordWithCode(email: string, code: string, newPassword: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        verificationCode: true,
        verificationCodeExpiry: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('Incorrect code', 400);
    }

    if (!user.isEmailVerified) {
      throw new AppError('Please verify your email first', 400);
    }

    if (!user.verificationCode || !user.verificationCodeExpiry) {
      throw new AppError('No reset code found', 400);
    }

    if (user.verificationCode !== code) {
      throw new AppError('Incorrect code', 400);
    }

    if (new Date() > user.verificationCodeExpiry) {
      throw new AppError('Code expired - please request a new one', 400);
    }

    // Hash new password
    const hashedPassword = await hashPassword(newPassword);

    // Update password and clear reset code
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        verificationCode: null,
        verificationCodeExpiry: null,
      },
    });

    return { message: 'Password reset successfully' };
  }

  /**
   * Set password after email verification
   */
  async setPassword(email: string, password: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: {
        id: true,
        email: true,
        isEmailVerified: true,
      },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    if (!user.isEmailVerified) {
      throw new AppError('Email not verified', 400);
    }

    // Hash password
    const hashedPassword = await hashPassword(password);

    // Update password
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
      },
    });

    // Generate tokens for immediate login
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
      },
      token: accessToken,
      refreshToken,
    };
  }
}

export default new AuthService();


