# Google Cloud Platform Production Setup Guide

This guide will help you deploy the Wizard API to Google Cloud Platform with a production PostgreSQL database.

## Prerequisites

1. Google Cloud Platform account with billing enabled
2. Google Cloud CLI installed (`gcloud`)
3. Docker installed (for containerized deployment)
4. Node.js 20+ installed locally

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

# Enable Cloud Run API for containerized deployment
gcloud services enable run.googleapis.com

# Enable Cloud Storage API for file uploads
gcloud services enable storage.googleapis.com

# Enable Secret Manager API for secure configuration
gcloud services enable secretmanager.googleapis.com

# Enable Cloud Build API for CI/CD
gcloud services enable cloudbuild.googleapis.com
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
gcloud sql instances describe wizard-db --format="value(connectionName)"

# Get the public IP
gcloud sql instances describe wizard-db --format="value(ipAddresses[0].ipAddress)"
```

## Step 3: Set up Cloud Storage Bucket

### 3.1 Create storage bucket
```bash
# Create a bucket for file uploads
gsutil mb gs://wizard-prod-media-$(date +%s)

# Make bucket publicly readable for profile photos
gsutil iam ch allUsers:objectViewer gs://wizard-prod-media-$(date +%s)
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

## Step 5: Create Production Environment Configuration

### 5.1 Create production .env template
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

## Step 6: Create Docker Configuration

### 6.1 Create Dockerfile
Create a `Dockerfile` in the `api/` directory:

```dockerfile
# Use Node.js 20 Alpine for smaller image size
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Copy service account key
COPY wizard-storage-key.json /app/wizard-storage-key.json

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Change ownership of the app directory
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["npm", "start"]
```

### 6.2 Create .dockerignore
Create a `.dockerignore` file in the `api/` directory:

```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.env.local
.env.development
.env.test
.env.production
.nyc_output
coverage
.nyc_output
.coverage
dist
build
*.log
```

## Step 7: Deploy to Cloud Run

### 7.1 Build and deploy
```bash
# Navigate to API directory
cd api

# Build and push to Google Container Registry
gcloud builds submit --tag gcr.io/$(gcloud config get-value project)/wizard-api

# Deploy to Cloud Run
gcloud run deploy wizard-api \
  --image gcr.io/$(gcloud config get-value project)/wizard-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080 \
  --memory 1Gi \
  --cpu 1 \
  --max-instances 10 \
  --set-env-vars NODE_ENV=production \
  --set-env-vars PORT=8080 \
  --set-env-vars GCS_PROJECT_ID=$(gcloud config get-value project) \
  --set-secrets DATABASE_URL=projects/$(gcloud config get-value project)/secrets/DATABASE_URL:latest \
  --set-secrets JWT_SECRET=projects/$(gcloud config get-value project)/secrets/JWT_SECRET:latest \
  --set-secrets JWT_REFRESH_SECRET=projects/$(gcloud config get-value project)/secrets/JWT_REFRESH_SECRET:latest \
  --set-secrets EMAIL_API_KEY=projects/$(gcloud config get-value project)/secrets/EMAIL_API_KEY:latest
```

## Step 8: Database Migration and Seeding

### 8.1 Run database migrations
```bash
# Connect to Cloud Run service and run migrations
gcloud run services update wizard-api \
  --region us-central1 \
  --set-env-vars RUN_MIGRATIONS=true

# Or run migrations locally with production database
cd api
DATABASE_URL="postgresql://wizard_user:password@your-db-ip:5432/wizard_prod" npm run migrate:deploy
```

### 8.2 Seed the database
```bash
# Run database seeding
DATABASE_URL="postgresql://wizard_user:password@your-db-ip:5432/wizard_prod" npm run db:seed
```

## Step 9: Set up Custom Domain (Optional)

### 9.1 Configure custom domain
```bash
# Map custom domain to Cloud Run service
gcloud run domain-mappings create \
  --service wizard-api \
  --domain api.yourdomain.com \
  --region us-central1
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
  --log-filter='resource.type="cloud_run_revision" AND resource.labels.service_name="wizard-api" AND severity>=ERROR'
```

## Step 11: Set up CI/CD Pipeline

### 11.1 Create cloudbuild.yaml
Create a `cloudbuild.yaml` file in the project root:

```yaml
steps:
  # Build the container image
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/wizard-api', './api']

  # Push the container image to Container Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/wizard-api']

  # Deploy container image to Cloud Run
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'run'
      - 'deploy'
      - 'wizard-api'
      - '--image'
      - 'gcr.io/$PROJECT_ID/wizard-api'
      - '--region'
      - 'us-central1'
      - '--platform'
      - 'managed'
      - '--allow-unauthenticated'

# Store images in Container Registry
images:
  - 'gcr.io/$PROJECT_ID/wizard-api'
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

### 12.2 Configure VPC (Optional)
```bash
# Create VPC network
gcloud compute networks create wizard-vpc \
  --subnet-mode custom

# Create subnet
gcloud compute networks subnets create wizard-subnet \
  --network wizard-vpc \
  --range 10.0.0.0/24 \
  --region us-central1
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

### 13.2 Set up cross-region backup
```bash
# Create backup in different region
gcloud sql backups create \
  --instance wizard-db \
  --description "Cross-region backup"
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

### 14.2 Configure Cloud Run scaling
```bash
# Update Cloud Run service with optimized scaling
gcloud run services update wizard-api \
  --region us-central1 \
  --min-instances 1 \
  --max-instances 20 \
  --concurrency 100 \
  --cpu-throttling
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
SERVICE_URL=$(gcloud run services describe wizard-api --region us-central1 --format 'value(status.url)')

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
- **Cloud Run**: ~$5-20 (based on usage)
- **Cloud Storage**: ~$1-5 (based on storage)
- **Cloud Build**: ~$2-10 (based on builds)
- **Total**: ~$15-50/month

### Cost Optimization Tips:
1. Use `db-f1-micro` for development, upgrade to `db-g1-small` for production
2. Set up Cloud Run min-instances to 0 to save costs during low usage
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

2. **Cloud Run Deployment Issues**:
   ```bash
   # Check service logs
   gcloud logs read --service=wizard-api --limit=50
   
   # Check service status
   gcloud run services describe wizard-api --region us-central1
   ```

3. **Storage Permission Issues**:
   ```bash
   # Check service account permissions
   gcloud projects get-iam-policy $(gcloud config get-value project)
   
   # Test storage access
   gsutil ls gs://your-bucket-name
   ```

## Next Steps

1. Set up monitoring dashboards in Cloud Console
2. Configure SSL certificates for custom domains
3. Implement automated testing in CI/CD pipeline
4. Set up staging environment for testing
5. Configure log aggregation and analysis
6. Implement API versioning strategy
7. Set up automated security scanning

This setup provides a production-ready, scalable, and secure deployment of your Wizard API on Google Cloud Platform.
