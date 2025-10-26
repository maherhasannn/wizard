#!/bin/bash

# Wizard API GCP Deployment Script
# This script automates the deployment of the Wizard API to Google Cloud Platform

set -e  # Exit on any error

# Configuration
PROJECT_ID="wizard-prod-$(date +%s)"
REGION="us-central1"
DB_INSTANCE="wizard-db"
DB_NAME="wizard_prod"
DB_USER="wizard_user"
SERVICE_ACCOUNT_NAME="wizard-storage-sa"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v gcloud &> /dev/null; then
        log_error "gcloud CLI is not installed. Please install it first."
        exit 1
    fi
    
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js 20+ first."
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Create GCP project
create_project() {
    log_info "Creating GCP project: $PROJECT_ID"
    
    if gcloud projects create $PROJECT_ID --name="Wizard Production" 2>/dev/null; then
        log_success "Project created successfully"
    else
        log_warning "Project might already exist or creation failed"
    fi
    
    gcloud config set project $PROJECT_ID
    log_success "Project set as active: $PROJECT_ID"
}

# Enable required APIs
enable_apis() {
    log_info "Enabling required APIs..."
    
    local apis=(
        "sqladmin.googleapis.com"
        "appengine.googleapis.com"
        "storage.googleapis.com"
        "secretmanager.googleapis.com"
        "monitoring.googleapis.com"
    )
    
    for api in "${apis[@]}"; do
        log_info "Enabling $api..."
        gcloud services enable $api
    done
    
    log_success "All APIs enabled"
}

# Create Cloud SQL instance
create_database() {
    log_info "Creating Cloud SQL PostgreSQL instance..."
    
    # Generate secure password
    DB_PASSWORD=$(openssl rand -base64 32)
    
    # Create instance
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
    
    log_success "Cloud SQL instance created"
    
    # Create database
    log_info "Creating database: $DB_NAME"
    gcloud sql databases create $DB_NAME --instance=$DB_INSTANCE
    
    # Create user
    log_info "Creating database user: $DB_USER"
    gcloud sql users create $DB_USER --instance=$DB_INSTANCE --password=$DB_PASSWORD
    
    log_success "Database and user created"
    
    # Store password in Secret Manager
    log_info "Storing database password in Secret Manager..."
    echo -n "$DB_PASSWORD" | gcloud secrets create DATABASE_PASSWORD --data-file=-
    
    log_success "Database setup complete"
}

# Create Cloud Storage bucket
create_storage() {
    log_info "Creating Cloud Storage bucket..."
    
    BUCKET_NAME="wizard-prod-media-$(date +%s)"
    
    # Create bucket
    gsutil mb gs://$BUCKET_NAME
    
    # Make bucket publicly readable for profile photos
    gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME
    
    log_success "Storage bucket created: $BUCKET_NAME"
    
    # Create service account for storage
    log_info "Creating storage service account..."
    
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
        --display-name="Wizard Storage Service Account"
    
    # Grant permissions
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
        --role="roles/storage.objectAdmin"
    
    # Create and download service account key
    gcloud iam service-accounts keys create wizard-storage-key.json \
        --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com
    
    log_success "Storage service account created"
}

# Store secrets
store_secrets() {
    log_info "Storing secrets in Secret Manager..."
    
    # Generate JWT secrets
    JWT_SECRET="jwt-secret-$(openssl rand -base64 32)"
    JWT_REFRESH_SECRET="refresh-secret-$(openssl rand -base64 32)"
    
    # Store secrets
    echo -n "$JWT_SECRET" | gcloud secrets create JWT_SECRET --data-file=-
    echo -n "$JWT_REFRESH_SECRET" | gcloud secrets create JWT_REFRESH_SECRET --data-file=-
    
    # Create placeholder for email API key
    echo -n "your-sendgrid-api-key" | gcloud secrets create EMAIL_API_KEY --data-file=-
    
    log_success "Secrets stored in Secret Manager"
}

# Create DATABASE_URL secret
create_database_url_secret() {
    log_info "Creating DATABASE_URL secret..."
    
    # Get connection name
    CONNECTION_NAME=$(gcloud sql instances describe $DB_INSTANCE --format="value(connectionName)")
    
    # Create DATABASE_URL
    DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@/$DB_NAME?host=/cloudsql/$CONNECTION_NAME"
    
    # Store in Secret Manager
    echo -n "$DATABASE_URL" | gcloud secrets create DATABASE_URL --data-file=-
    
    log_success "DATABASE_URL secret created"
}

# Initialize App Engine
initialize_app_engine() {
    log_info "Initializing App Engine..."
    
    gcloud app create --region=$REGION
    
    log_success "App Engine initialized"
}

# Deploy application
deploy_application() {
    log_info "Deploying application to App Engine..."
    
    # Navigate to API directory
    cd api
    
    # Install dependencies
    log_info "Installing dependencies..."
    npm ci
    
    # Generate Prisma client
    log_info "Generating Prisma client..."
    npm run prisma:generate
    
    # Build application
    log_info "Building application..."
    npm run build
    
    # Deploy to App Engine
    log_info "Deploying to App Engine..."
    gcloud app deploy --quiet
    
    log_success "Application deployed successfully"
    
    # Get service URL
    SERVICE_URL=$(gcloud app browse --no-launch-browser)
    log_success "Service URL: $SERVICE_URL"
}

# Run database migrations
run_migrations() {
    log_info "Running database migrations..."
    
    # Get DATABASE_URL from Secret Manager
    DATABASE_URL=$(gcloud secrets versions access latest --secret="DATABASE_URL")
    
    # Set environment variable and run migrations
    DATABASE_URL="$DATABASE_URL" npm run migrate:deploy
    
    log_success "Database migrations completed"
}

# Create monitoring
setup_monitoring() {
    log_info "Setting up monitoring..."
    
    # Create uptime check
    gcloud monitoring uptime create wizard-api-check \
        --hostname $(gcloud app browse --no-launch-browser | sed 's|https://||') \
        --path "/health" || log_warning "Uptime check creation failed"
    
    log_success "Monitoring setup complete"
}

# Main deployment function
main() {
    echo "🚀 Starting Wizard API deployment to GCP..."
    echo "📊 Project ID: $PROJECT_ID"
    echo "🌍 Region: $REGION"
    echo ""
    
    check_prerequisites
    create_project
    enable_apis
    create_database
    create_storage
    store_secrets
    create_database_url_secret
    initialize_app_engine
    deploy_application
    run_migrations
    setup_monitoring
    
    echo ""
    log_success "🎉 Deployment completed successfully!"
    echo ""
    echo "📋 Deployment Summary:"
    echo "   Project ID: $PROJECT_ID"
    echo "   Database: $DB_INSTANCE"
    echo "   Storage: $BUCKET_NAME"
    echo "   Service URL: $(gcloud app browse --no-launch-browser)"
    echo ""
    echo "🔧 Next Steps:"
    echo "   1. Update your app.yaml with the correct GCS_BUCKET_NAME: $BUCKET_NAME"
    echo "   2. Update your app.yaml with the correct GCS_PROJECT_ID: $PROJECT_ID"
    echo "   3. Add your SendGrid API key to Secret Manager"
    echo "   4. Test your API endpoints"
    echo "   5. Set up custom domain (optional)"
    echo ""
    echo "📚 Documentation: GCP_PRODUCTION_SETUP_NO_DOCKER.md"
}

# Run main function
main "$@"
