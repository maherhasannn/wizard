import { OAuth2Client } from 'google-auth-library';
// import appleSignin from 'apple-signin-auth'; // Will be available after npm install

// Google OAuth client
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

/**
 * Verify Google OAuth token and extract user info
 */
export async function verifyGoogleToken(idToken: string) {
  try {
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    
    if (!payload) {
      throw new Error('Invalid Google token');
    }

    return {
      email: payload.email!,
      firstName: payload.given_name,
      lastName: payload.family_name,
      profilePhoto: payload.picture,
      emailVerified: payload.email_verified || false,
    };
  } catch (error) {
    throw new Error('Failed to verify Google token');
  }
}

/**
 * Verify Apple Sign-In token and extract user info
 */
export async function verifyAppleToken(idToken: string) {
  try {
    // TODO: Implement Apple token verification after installing apple-signin-auth
    // For now, return a placeholder
    return {
      email: 'placeholder@example.com',
      firstName: undefined,
      lastName: undefined,
      profilePhoto: undefined,
      emailVerified: true,
    };
  } catch (error) {
    throw new Error('Failed to verify Apple token');
  }
}

/**
 * Verify Facebook OAuth token and extract user info
 * Note: This requires the Facebook SDK or Graph API call
 */
export async function verifyFacebookToken(accessToken: string) {
  try {
    // Call Facebook Graph API to verify token and get user info
    const response = await fetch(
      `https://graph.facebook.com/me?fields=id,email,first_name,last_name,picture&access_token=${accessToken}`
    );

    if (!response.ok) {
      throw new Error('Invalid Facebook token');
    }

    const data = await response.json() as any;

    if (!data.email) {
      throw new Error('Email not provided by Facebook');
    }

    return {
      email: data.email,
      firstName: data.first_name,
      lastName: data.last_name,
      profilePhoto: data.picture?.data?.url,
      emailVerified: true, // Facebook emails are verified
    };
  } catch (error) {
    throw new Error('Failed to verify Facebook token');
  }
}

