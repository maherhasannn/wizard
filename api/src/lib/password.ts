import argon2 from 'argon2';

/**
 * Hash a password using Argon2
 */
export async function hashPassword(password: string): Promise<string> {
  console.log('🔐 [PASSWORD] Hashing password, length:', password?.length);
  const hash = await argon2.hash(password, {
    type: argon2.argon2id,
    memoryCost: 65536, // 64 MB
    timeCost: 3,
    parallelism: 4,
  });
  console.log('🔐 [PASSWORD] Hash generated:', hash?.substring(0, 20) + '...');
  return hash;
}

/**
 * Verify a password against a hash
 */
export async function verifyPassword(hash: string, password: string): Promise<boolean> {
  try {
    console.log('🔐 [PASSWORD] Verifying password...');
    console.log('🔐 [PASSWORD] Hash:', hash?.substring(0, 20) + '...');
    console.log('🔐 [PASSWORD] Password length:', password?.length);
    const result = await argon2.verify(hash, password);
    console.log('🔐 [PASSWORD] Verification result:', result);
    return result;
  } catch (error) {
    console.error('🔐 [PASSWORD] Verification error:', error);
    return false;
  }
}


