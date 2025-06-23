# Deployment Guide

## Docker Deployment

### Updated Dockerfile Features

✅ **Multi-stage optimized build**  
✅ **Alpine Linux for smaller image size**  
✅ **Non-root user for security**  
✅ **Health checks included**  
✅ **Proper signal handling with dumb-init**  
✅ **Production optimizations**  

### Build Commands

```bash
# Build the image
docker build -t vendure-younique:latest .

# Run locally for testing
docker run -p 3000:3000 --env-file .env.production vendure-younique:latest

# Run with docker-compose for production
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Setup

1. Copy the production environment template:
   ```bash
   cp .env.production.example .env.production
   ```

2. Update the values in `.env.production`:
   - Change `SUPERADMIN_PASSWORD` to a secure password
   - Update `COOKIE_SECRET` with a random string
   - Set `ASSET_URL_PREFIX` to your domain

### Deployment Platforms

#### Render.com
- Use the `render.yaml` configuration file
- Set environment variables in Render dashboard
- Connect your GitHub repository

#### Railway
- Connect your GitHub repository
- Set environment variables in Railway dashboard
- Use the Dockerfile for deployment

#### DigitalOcean App Platform
- Use the Docker deployment option
- Set environment variables in the app settings

#### AWS/Azure/GCP
- Push image to container registry
- Deploy using container services (ECS, Container Instances, Cloud Run)

### Security Considerations

- ✅ Non-root user in container
- ✅ Minimal Alpine base image
- ✅ Health checks for monitoring
- ✅ Environment variables for secrets
- ✅ SSL database connection

### Monitoring

The container includes health checks accessible at:
- `GET /health` - Application health status

### Volumes

For persistent data, mount these directories:
- `/usr/src/app/static/assets` - Uploaded files
- `/usr/src/app/static/email/test-emails` - Email templates
