import app from './app';
import config from './config';
import prisma from './lib/prismaClient';

const PORT = config.port;

// Graceful shutdown handler
const gracefulShutdown = async (signal: string) => {
  console.log(`\n${signal} received. Shutting down gracefully...`);

  try {
    // Disconnect Prisma
    await prisma.$disconnect();
    console.log('Database connection closed');

    process.exit(0);
  } catch (error) {
    console.error('Error during shutdown:', error);
    process.exit(1);
  }
};

// Handle shutdown signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught errors
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  gracefulShutdown('UNCAUGHT_EXCEPTION');
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  gracefulShutdown('UNHANDLED_REJECTION');
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Wizard API server running on http://localhost:${PORT}`);
  console.log(`📊 Environment: ${config.env}`);
  console.log(`💾 Database: Connected`);
  console.log(`☁️  GCS Bucket: ${config.gcs.bucketName}`);
});

