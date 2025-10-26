# Google Cloud Platform Production Setup Guide (No Docker)

This guide will help you deploy the Wizard API to Google Cloud Platform with a production PostgreSQL database using Google App Engine (no Docker required).

## Prerequisites

1. Google Cloud Platform account with billing enabled
2. Google Cloud CLI installed (`gcloud`)
3. Node.js 20+ installed locally

## Step 1: Create GCP Project and Enable APIs

### 1.1 Create a new GCP project
```bash
# Create a new project (replace with your desired project ID)
gcloud projects create wizard-prod-$(date +%s) --name="Wizard Production"

# Set the project as active
gcloud config set project wizard-prod-$(date +%s)
```

### 1.2 Enable required APIs
```bash
# Enable Cloud SQL API for PostgreSQL
gcloud services enable sqladmin.googleapis.com

# Enable App Engine API for direct Node.js deployment
gcloud services enable appengine.googleapis.com

# Enable Cloud Storage API for file uploads
gcloud services enable storage.googleapis.com

# Enable Secret Manager API for secure configuration
gcloud services enable secretmanager.googleapis.com
```

## Step 2: Set up Cloud SQL PostgreSQL Database

### 2.1 Create Cloud SQL instance
```bash
# Create a PostgreSQL instance
gcloud sql instances create wizard-db \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --storage-type=SSD \
  --storage-size=10GB \
  --storage-auto-increase \
  --backup \
  --enable-ip-alias \
  --authorized-networks=0.0.0.0/0
```

### 2.2 Create database and user
```bash
# Create the database
gcloud sql databases create wizard_prod --instance=wizard-db

# Create a database user
gcloud sql users create wizard_user \
  --instance=wizard-db \
  --password=$(openssl rand -base64 32)
```

### 2.3 Get connection details
```bash
# Get the connection name
CONNECTION_NAME=$(gcloud sql instances describe wizard-db --format="value(connectionName)")
echo "Connection Name: $CONNECTION_NAME"

# Get the public IP
DB_IP=$(gcloud sql instances describe wizard-db --format="value(ipAddresses[0].ipAddress)")
echo "Database IP: $DB_IP"
```

## Step 3: Set up Cloud Storage Bucket

### 3.1 Create storage bucket
```bash
# Create a bucket for file uploads
BUCKET_NAME="wizard-prod-media-$(date +%s)"
gsutil mb gs://$BUCKET_NAME

# Make bucket publicly readable for profile photos
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

echo "Bucket created: $BUCKET_NAME"
```

### 3.2 Create service account for Cloud Storage
```bash
# Create service account
gcloud iam service-accounts create wizard-storage-sa \
  --display-name="Wizard Storage Service Account"

# Grant storage permissions
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member="serviceAccount:wizard-storage-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

# Create and download service account key
gcloud iam service-accounts keys create wizard-storage-key.json \
  --iam-account=wizard-storage-sa@$(gcloud config get-value project).iam.gserviceaccount.com
```

## Step 4: Set up Secret Manager

### 4.1 Store sensitive configuration
```bash
# Store database password
echo -n "your-database-password" | gcloud secrets create DATABASE_PASSWORD --data-file=-

# Store JWT secrets
echo -n "your-super-secure-jwt-secret-$(openssl rand -base64 32)" | gcloud secrets create JWT_SECRET --data-file=-
echo -n "your-super-secure-refresh-secret-$(openssl rand -base64 32)" | gcloud secrets create JWT_REFRESH_SECRET --data-file=-

# Store email API key (if using SendGrid)
echo -n "your-sendgrid-api-key" | gcloud secrets create EMAIL_API_KEY --data-file=-
```

## Step 5: Create App Engine Configuration

### 5.1 Create app.yaml
Create an `app.yaml` file in the `api/` directory:

```yaml
runtime: nodejs20

env_variables:
  NODE_ENV: production
  PORT: 8080
  GCS_PROJECT_ID: your-project-id
  GCS_BUCKET_NAME: wizard-prod-media-your-unique-id
  EMAIL_SERVICE: sendgrid
  EMAIL_FROM: noreply@yourdomain.com
  CORS_ORIGIN: https://yourdomain.com,https://www.yourdomain.com
  RATE_LIMIT_WINDOW_MS: "900000"
  RATE_LIMIT_MAX_REQUESTS: "100"
  MAX_FILE_SIZE: "10485760"
  JWT_EXPIRES_IN: 15m
  JWT_REFRESH_EXPIRES_IN: 30d

# Use Secret Manager for sensitive data
secret_environment_variables:
  - key: DATABASE_URL
    secret: DATABASE_URL
  - key: JWT_SECRET
    secret: JWT_SECRET
  - key: JWT_REFRESH_SECRET
    secret: JWT_REFRESH_SECRET
  - key: EMAIL_API_KEY
    secret: EMAIL_API_KEY

# Automatic scaling configuration
automatic_scaling:
  min_instances: 1
  max_instances: 10
  target_cpu_utilization: 0.6
  target_throughput_utilization: 0.6

# Instance configuration
instance_class: F2

# Health check configuration
readiness_check:
  path: "/health"
  check_interval_sec: 5
  timeout_sec: 4
  failure_threshold: 2
  success_threshold: 2

liveness_check:
  path: "/health"
  check_interval_sec: 30
  timeout_sec: 4
  failure_threshold: 4
  success_threshold: 2

# Skip files to reduce deployment size
skip_files:
  - ^(.*/)?#.*#$
  - ^(.*/)?.*~$
  - ^(.*/)?.*\.py[co]$
  - ^(.*/)?.*/RCS/.*$
  - ^(.*/)?\..*$
  - ^(.*/)?node_modules/.*$
  - ^(.*/)?\.git/.*$
  - ^(.*/)?\.env$
  - ^(.*/)?\.env\.*
  - ^(.*/)?test/.*$
  - ^(.*/)?tests/.*$
  - ^(.*/)?\.nyc_output/.*$
  - ^(.*/)?coverage/.*$
  - ^(.*/)?\.coverage/.*$
  - ^(.*/)?dist/.*$
  - ^(.*/)?build/.*$
  - ^(.*/)?*.log$
```

### 5.2 Create production .env template
Create a `.env.production` file in the `api/` directory:

```env
# Environment
NODE_ENV=production
PORT=8080

# Database (replace with your actual values)
DATABASE_URL=postgresql://wizard_user:your-password@your-db-ip:5432/wizard_prod?schema=public

# JWT Configuration
JWT_SECRET=your-super-secure-jwt-secret
JWT_REFRESH_SECRET=your-super-secure-refresh-secret
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=30d

# Google Cloud Storage
GCS_BUCKET_NAME=wizard-prod-media-your-unique-id
GCS_PROJECT_ID=your-project-id
GOOGLE_APPLICATION_CREDENTIALS=/app/wizard-storage-key.json

# Email Configuration
EMAIL_SERVICE=sendgrid
EMAIL_FROM=noreply@yourdomain.com
EMAIL_API_KEY=your-sendgrid-api-key

# CORS Configuration
CORS_ORIGIN=https://yourdomain.com,https://www.yourdomain.com

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# File Upload
MAX_FILE_SIZE=10485760
```

## Step 6: Update package.json for Production

### 6.1 Update scripts
Update the `scripts` section in `api/package.json`:

```json
{
  "scripts": {
    "dev": "cross-env NODE_ENV=development nodemon -r tsconfig-paths/register src/index.ts",
    "start": "cross-env NODE_ENV=production node -r tsconfig-paths/register dist/index.js",
    "build": "tsc",
    "migrate:dev": "prisma migrate dev",
    "migrate:deploy": "prisma migrate deploy",
    "migrate:reset": "prisma migrate reset",
    "db:push": "prisma db push",
    "db:seed": "ts-node -r tsconfig-paths/register prisma/seed.ts",
    "prisma:generate": "prisma generate",
    "prisma:studio": "prisma studio",
    "gcp-build": "npm run prisma:generate && npm run build"
  }
}
```

## Step 7: Deploy to App Engine

### 7.1 Initialize App Engine
```bash
# Navigate to API directory
cd api

# Initialize App Engine (if not already done)
gcloud app create --region=us-central1
```

### 7.2 Deploy the application
```bash
# Deploy to App Engine
gcloud app deploy

# Get the service URL
gcloud app browse
```

## Step 8: Database Migration and Seeding

### 8.1 Run database migrations locally
```bash
# Set up local environment with production database
export DATABASE_URL="postgresql://wizard_user:password@your-db-ip:5432/wizard_prod"

# Run migrations
npm run migrate:deploy

# Seed the database
npm run db:seed
```

### 8.2 Alternative: Run migrations via App Engine
Create a migration script that runs on deployment:

```typescript
// src/migrate.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function migrate() {
  try {
    console.log('Running database migrations...');
    // Add your migration logic here
    console.log('Migrations completed successfully');
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

if (process.env.RUN_MIGRATIONS === 'true') {
  migrate();
}
```

## Step 9: Set up Custom Domain (Optional)

### 9.1 Configure custom domain
```bash
# Map custom domain to App Engine
gcloud app domain-mappings create api.yourdomain.com
```

### 9.2 Update DNS records
Add a CNAME record in your DNS provider pointing `api.yourdomain.com` to `ghs.googlehosted.com`.

## Step 10: Set up Monitoring and Logging

### 10.1 Enable Cloud Monitoring
```bash
# Enable monitoring API
gcloud services enable monitoring.googleapis.com

# Create uptime check
gcloud monitoring uptime create wizard-api-check \
  --hostname api.yourdomain.com \
  --path /health
```

### 10.2 Set up log-based metrics
```bash
# Create log-based metric for error rate
gcloud logging metrics create wizard_error_rate \
  --description="Error rate for Wizard API" \
  --log-filter='resource.type="gae_app" AND resource.labels.module_id="default" AND severity>=ERROR'
```

## Step 11: Set up CI/CD Pipeline

### 11.1 Create cloudbuild.yaml
Create a `cloudbuild.yaml` file in the project root:

```yaml
steps:
  # Install dependencies and build
  - name: 'node:20'
    entrypoint: 'npm'
    args: ['ci']
    dir: 'api'

  # Generate Prisma client
  - name: 'node:20'
    entrypoint: 'npm'
    args: ['run', 'prisma:generate']
    dir: 'api'

  # Build the application
  - name: 'node:20'
    entrypoint: 'npm'
    args: ['run', 'build']
    dir: 'api'

  # Deploy to App Engine
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'app'
      - 'deploy'
      - 'api/app.yaml'
      - '--quiet'
```

### 11.2 Set up GitHub integration
```bash
# Connect GitHub repository to Cloud Build
gcloud builds triggers create github \
  --repo-name=wizard \
  --repo-owner=your-github-username \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

## Step 12: Security Hardening

### 12.1 Set up Cloud Armor (Optional)
```bash
# Create security policy
gcloud compute security-policies create wizard-security-policy \
  --description "Security policy for Wizard API"

# Add rate limiting rule
gcloud compute security-policies rules create 1000 \
  --security-policy wizard-security-policy \
  --expression "true" \
  --action "rate-based-ban" \
  --rate-limit-threshold-count 100 \
  --rate-limit-threshold-interval-sec 60
```

## Step 13: Backup and Disaster Recovery

### 13.1 Set up automated backups
```bash
# Configure automated backups for Cloud SQL
gcloud sql instances patch wizard-db \
  --backup-start-time 03:00 \
  --enable-bin-log \
  --retained-backups-count 7
```

## Step 14: Performance Optimization

### 14.1 Enable Cloud CDN
```bash
# Create backend bucket for static assets
gcloud compute backend-buckets create wizard-static-backend \
  --gcs-bucket-name wizard-prod-media-your-unique-id

# Create URL map
gcloud compute url-maps create wizard-url-map \
  --default-backend-bucket wizard-static-backend
```

### 14.2 Configure App Engine scaling
Update your `app.yaml` with optimized scaling:

```yaml
automatic_scaling:
  min_instances: 1
  max_instances: 20
  target_cpu_utilization: 0.6
  target_throughput_utilization: 0.6
  min_pending_latency: 30ms
  max_pending_latency: automatic
```

## Step 15: Testing Production Deployment

### 15.1 Health check endpoint
Ensure your API has a health check endpoint at `/health`:

```typescript
// Add to your Express app
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});
```

### 15.2 Test the deployment
```bash
# Get the service URL
SERVICE_URL=$(gcloud app browse --no-launch-browser)

# Test health endpoint
curl $SERVICE_URL/health

# Test API endpoints
curl $SERVICE_URL/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"testpass123"}'
```

## Step 16: Monitoring and Maintenance

### 16.1 Set up alerts
```bash
# Create alerting policy for high error rate
gcloud alpha monitoring policies create \
  --policy-from-file=alert-policy.yaml
```

### 16.2 Regular maintenance tasks
```bash
# Update dependencies
npm audit fix

# Run database maintenance
gcloud sql instances patch wizard-db --maintenance-window-day SUN --maintenance-window-hour 3
```

## Cost Optimization

### Estimated Monthly Costs (US Central):
- **Cloud SQL (db-f1-micro)**: ~$7-15
- **App Engine (F2 instances)**: ~$10-30 (based on usage)
- **Cloud Storage**: ~$1-5 (based on storage)
- **Cloud Build**: ~$2-10 (based on builds)
- **Total**: ~$20-60/month

### Cost Optimization Tips:
1. Use `db-f1-micro` for development, upgrade to `db-g1-small` for production
2. Set App Engine min-instances to 1 to save costs during low usage
3. Use Cloud Storage lifecycle policies to archive old files
4. Monitor usage with Cloud Billing alerts

## Troubleshooting

### Common Issues:

1. **Database Connection Issues**:
   ```bash
   # Check Cloud SQL instance status
   gcloud sql instances describe wizard-db
   
   # Test connection
   gcloud sql connect wizard-db --user=wizard_user --database=wizard_prod
   ```

2. **App Engine Deployment Issues**:
   ```bash
   # Check service logs
   gcloud app logs tail -s default
   
   # Check service status
   gcloud app services list
   ```

3. **Storage Permission Issues**:
   ```bash
   # Check service account permissions
   gcloud projects get-iam-policy $(gcloud config get-value project)
   
   # Test storage access
   gsutil ls gs://your-bucket-name
   ```

## Quick Start Script

Create a `deploy.sh` script to automate the deployment:

```bash
#!/bin/bash

# Set variables
PROJECT_ID="wizard-prod-$(date +%s)"
REGION="us-central1"
DB_INSTANCE="wizard-db"
DB_NAME="wizard_prod"
DB_USER="wizard_user"

echo "🚀 Starting Wizard API deployment to GCP..."

# Create project
echo "📁 Creating GCP project..."
gcloud projects create $PROJECT_ID --name="Wizard Production"
gcloud config set project $PROJECT_ID

# Enable APIs
echo "🔧 Enabling required APIs..."
gcloud services enable sqladmin.googleapis.com
gcloud services enable appengine.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable secretmanager.googleapis.com

# Create Cloud SQL instance
echo "🗄️ Creating Cloud SQL instance..."
gcloud sql instances create $DB_INSTANCE \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=$REGION \
  --storage-type=SSD \
  --storage-size=10GB \
  --storage-auto-increase \
  --backup \
  --enable-ip-alias \
  --authorized-networks=0.0.0.0/0

# Create database and user
echo "👤 Creating database and user..."
gcloud sql databases create $DB_NAME --instance=$DB_INSTANCE
DB_PASSWORD=$(openssl rand -base64 32)
gcloud sql users create $DB_USER --instance=$DB_INSTANCE --password=$DB_PASSWORD

# Create storage bucket
echo "📦 Creating storage bucket..."
BUCKET_NAME="wizard-prod-media-$(date +%s)"
gsutil mb gs://$BUCKET_NAME
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

# Create service account
echo "🔑 Creating service account..."
gcloud iam service-accounts create wizard-storage-sa \
  --display-name="Wizard Storage Service Account"
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:wizard-storage-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
gcloud iam service-accounts keys create wizard-storage-key.json \
  --iam-account=wizard-storage-sa@$PROJECT_ID.iam.gserviceaccount.com

# Store secrets
echo "🔐 Storing secrets..."
echo -n "$DB_PASSWORD" | gcloud secrets create DATABASE_PASSWORD --data-file=-
echo -n "jwt-secret-$(openssl rand -base64 32)" | gcloud secrets create JWT_SECRET --data-file=-
echo -n "refresh-secret-$(openssl rand -base64 32)" | gcloud secrets create JWT_REFRESH_SECRET --data-file=-

# Initialize App Engine
echo "🌐 Initializing App Engine..."
gcloud app create --region=$REGION

# Deploy application
echo "🚀 Deploying application..."
cd api
gcloud app deploy --quiet

echo "✅ Deployment complete!"
echo "🌍 Service URL: $(gcloud app browse --no-launch-browser)"
echo "📊 Project ID: $PROJECT_ID"
echo "🗄️ Database: $DB_INSTANCE"
echo "📦 Storage: $BUCKET_NAME"
```

Make it executable and run:
```bash
chmod +x deploy.sh
./deploy.sh
```

This approach gives you a production-ready deployment without Docker, using Google App Engine's native Node.js support.
