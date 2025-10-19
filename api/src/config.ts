import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

interface Config {
  env: string;
  port: number;
  databaseUrl: string;
  jwt: {
    secret: string;
    refreshSecret: string;
    expiresIn: string;
    refreshExpiresIn: string;
  };
  gcs: {
    bucketName: string;
    projectId: string;
    credentialsPath?: string;
  };
  email: {
    service: string;
    from: string;
    apiKey?: string;
  };
  cors: {
    origin: string[];
  };
  rateLimit: {
    windowMs: number;
    maxRequests: number;
  };
  fileUpload: {
    maxSize: number;
  };
}

const config: Config = {
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '8080', 10),
  databaseUrl: process.env.DATABASE_URL || '',
  jwt: {
    secret: process.env.JWT_SECRET || 'your-jwt-secret-change-in-production',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-change-in-production',
    expiresIn: process.env.JWT_EXPIRES_IN || '15m',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d',
  },
  gcs: {
    bucketName: process.env.GCS_BUCKET_NAME || 'wizard-media',
    projectId: process.env.GCS_PROJECT_ID || '',
    credentialsPath: process.env.GOOGLE_APPLICATION_CREDENTIALS,
  },
  email: {
    service: process.env.EMAIL_SERVICE || 'sendgrid',
    from: process.env.EMAIL_FROM || 'noreply@wizard.app',
    apiKey: process.env.EMAIL_API_KEY,
  },
  cors: {
    origin: process.env.CORS_ORIGIN 
      ? process.env.CORS_ORIGIN.split(',') 
      : ['http://localhost:3000', 'http://localhost:8081'],
  },
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10),
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100', 10),
  },
  fileUpload: {
    maxSize: parseInt(process.env.MAX_FILE_SIZE || '10485760', 10), // 10MB default
  },
};

// Validate required configuration
if (!config.databaseUrl) {
  throw new Error('DATABASE_URL environment variable is required');
}

if (config.env === 'production') {
  if (config.jwt.secret === 'your-jwt-secret-change-in-production') {
    throw new Error('JWT_SECRET must be changed in production');
  }
  if (config.jwt.refreshSecret === 'your-refresh-secret-change-in-production') {
    throw new Error('JWT_REFRESH_SECRET must be changed in production');
  }
}

export default config;

