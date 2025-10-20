import jwt from 'jsonwebtoken';
import config from '../config';
import crypto from 'crypto';

export interface TokenPayload {
  userId: number;
  email: string;
}

export interface DecodedToken extends TokenPayload {
  iat: number;
  exp: number;
}

/**
 * Generate an access token
 */
export function generateAccessToken(payload: TokenPayload): string {
  return jwt.sign(payload, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
  });
}

/**
 * Generate a refresh token
 */
export function generateRefreshToken(payload: TokenPayload): string {
  return jwt.sign(payload, config.jwt.refreshSecret, {
    expiresIn: config.jwt.refreshExpiresIn,
  });
}

/**
 * Verify an access token
 */
export function verifyAccessToken(token: string): DecodedToken {
  return jwt.verify(token, config.jwt.secret) as DecodedToken;
}

/**
 * Verify a refresh token
 */
export function verifyRefreshToken(token: string): DecodedToken {
  return jwt.verify(token, config.jwt.refreshSecret) as DecodedToken;
}

/**
 * Generate a random token for email verification, password reset, etc.
 */
export function generateRandomToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

/**
 * Calculate token expiry date
 */
export function getTokenExpiry(hours: number = 24): Date {
  return new Date(Date.now() + hours * 60 * 60 * 1000);
}


