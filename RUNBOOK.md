# Operations Runbook

## Table of Contents
1. [Deployment Procedures](#deployment-procedures)
2. [Monitoring](#monitoring)
3. [Troubleshooting](#troubleshooting)
4. [Rollback Procedures](#rollback-procedures)
5. [Emergency Contacts](#emergency-contacts)

## Deployment Procedures

### Manual Deployment

#### Frontend Deployment
```bash
cd Client
npm install
npm run build
aws s3 sync dist/ s3://starttech-frontend-production --delete
```

#### Backend Deployment
```bash
cd Server/MuchToDo
docker build -t muchtodo-backend:latest .
docker tag muchtodo-backend:latest 692653576807.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 692653576807.dkr.ecr.us-east-1.amazonaws.com
docker push 692653576807.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
```

#### Deploy to EC2
```bash
# SSH to EC2 instance
ssh -i your-key.pem ec2-user@3.238.39.224

# Pull and run latest image
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 692653576807.dkr.ecr.us-east-1.amazonaws.com
docker pull 692653576807.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
docker stop muchtodo-backend || true
docker rm muchtodo-backend || true
docker run -d --name muchtodo-backend -p 8080:8080 \
  -e MONGODB_URI=$MONGODB_URI \
  -e REDIS_URL=$REDIS_URL \
  692653576807.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
```

### Automated Deployment (GitHub Actions)

Deployments trigger automatically when code is pushed to `feature/full-stack` branch:
- Frontend: Changes to `Client/**`
- Backend: Changes to `Server/**`

## Monitoring

### Health Checks

**Backend Health Check:**
```bash
curl http://3.238.39.224:8080/health
```

Expected response:
```json
{"status": "healthy"}
```

### CloudWatch Logs

**View Backend Logs:**
```bash
aws logs tail /aws/ec2/starttech-backend --follow
```

**View Application Logs:**
```bash
aws logs tail /application/starttech --follow
```

### CloudWatch Alarms

Monitor these alarms in AWS Console:
- `starttech-high-cpu` - CPU > 80%

## Troubleshooting

### Frontend Issues

**Problem:** Website not loading
```bash
# Check S3 bucket
aws s3 ls s3://starttech-frontend-production/

# Verify bucket policy
aws s3api get-bucket-policy --bucket starttech-frontend-production

# Re-deploy
cd Client && npm run build && aws s3 sync dist/ s3://starttech-frontend-production --delete
```

### Backend Issues

**Problem:** API not responding
```bash
# Check if container is running
ssh ec2-user@3.238.39.224
docker ps

# Check container logs
docker logs muchtodo-backend

# Restart container
docker restart muchtodo-backend
```

**Problem:** High CPU usage
```bash
# Check CloudWatch metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-04fa31a40b6f23c20 \
  --start-time 2026-01-18T00:00:00Z \
  --end-time 2026-01-18T23:59:59Z \
  --period 3600 \
  --statistics Average

# If needed, restart instance
aws ec2 reboot-instances --instance-ids i-04fa31a40b6f23c20
```

### Database Issues

**Problem:** Cannot connect to MongoDB
```bash
# Verify MongoDB Atlas connection string
# Check IP whitelist in MongoDB Atlas
# Test connection
mongo "your-connection-string"
```

## Rollback Procedures

### Frontend Rollback
```bash
# List previous S3 versions (if versioning enabled)
aws s3api list-object-versions --bucket starttech-frontend-production

# Or re-deploy previous commit
git checkout <previous-commit>
cd Client && npm run build && aws s3 sync dist/ s3://starttech-frontend-production --delete
```

### Backend Rollback
```bash
# List ECR images
aws ecr describe-images --repository-name starttech-backend --query 'imageDetails[*].[imageTags[0],imagePushedAt]' --output table

# Deploy specific version
ssh ec2-user@3.238.39.224
docker pull 692653576807.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:<previous-tag>
docker stop muchtodo-backend
docker rm muchtodo-backend
docker run -d --name muchtodo-backend -p 8080:8080 <image-with-tag>
```

## Infrastructure Management

### View Infrastructure State
```bash
cd StartTech-infra-Abdulsamad-1174/terraform
terraform show
```

### Update Infrastructure
```bash
terraform plan
terraform apply
```

### Destroy Infrastructure (DANGER)
```bash
terraform destroy
```

## Common Commands Reference

### AWS CLI
```bash
# Get instance details
aws ec2 describe-instances --instance-ids i-04fa31a40b6f23c20

# Get S3 bucket info
aws s3 ls s3://starttech-frontend-production/

# View CloudWatch logs
aws logs describe-log-groups
```

### Docker
```bash
# View running containers
docker ps

# View logs
docker logs <container-id>

# Execute command in container
docker exec -it <container-id> sh
```

## Emergency Contacts

- **Student:** Abdulsamad
- **Student ID:** 1174
- **GitHub:** probaby01
- **Email:** asomad4islam@gmail.com

## Emergency Procedures

### Complete System Outage
1. Check AWS Service Health Dashboard
2. Verify EC2 instance status
3. Check S3 bucket accessibility
4. Review CloudWatch alarms
5. Contact AWS Support if needed

### Data Loss Prevention
- MongoDB Atlas: Automatic backups enabled
- S3: Enable versioning for disaster recovery
- ECR: Multiple image tags for rollback options