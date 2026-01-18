# System Architecture Documentation

## Overview

StartTech application is a full-stack todo management system deployed on AWS with automated CI/CD pipelines.

## Architecture Diagram
```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│   GitHub    │────────▶│GitHub Actions│────────▶│     AWS     │
│ Repository  │         │   CI/CD      │         │   Services  │
└─────────────┘         └──────────────┘         └─────────────┘
                                                         │
                        ┌────────────────────────────────┼──────────────┐
                        │                                │              │
                   ┌────▼─────┐                    ┌────▼────┐   ┌─────▼──────┐
                   │    S3    │                    │   EC2   │   │ CloudWatch │
                   │ Frontend │                    │ Backend │   │    Logs    │
                   └──────────┘                    └────┬────┘   └────────────┘
                                                        │
                                            ┌───────────┴───────────┐
                                            │                       │
                                       ┌────▼─────┐          ┌─────▼──────┐
                                       │ MongoDB  │          │   Redis    │
                                       │  Atlas   │          │ ElastiCache│
                                       └──────────┘          └────────────┘
```

## Components

### Frontend (Client)
- **Technology:** React 18 + TypeScript + Vite
- **Hosting:** AWS S3 (Static Website)
- **Deployment:** Automated via GitHub Actions
- **Build Output:** Optimized production bundle in `dist/`

### Backend (Server)
- **Technology:** Golang 1.21
- **Runtime:** Docker container on EC2
- **Instance Type:** t3.micro
- **API Port:** 8080
- **Health Endpoint:** `/health`

### Database Layer
- **Primary Database:** MongoDB Atlas
- **Cache:** Redis (ElastiCache or self-hosted)
- **Connection:** Secure connection via environment variables

### Infrastructure
- **VPC:** Custom VPC (10.0.0.0/16)
- **Subnets:** 
  - Public: 10.0.1.0/24, 10.0.2.0/24
  - Private: 10.0.11.0/24, 10.0.12.0/24
- **Security Groups:**
  - Frontend: Public S3 bucket
  - Backend: Port 8080 (HTTP), Port 22 (SSH)

## CI/CD Pipeline

### Frontend Pipeline
1. **Trigger:** Push to `Client/**` files
2. **Build:** npm install → npm run build
3. **Test:** Security audit
4. **Deploy:** Sync to S3 bucket

### Backend Pipeline
1. **Trigger:** Push to `Server/**` files
2. **Test:** Run Go tests
3. **Build:** Docker image creation
4. **Scan:** Trivy security scan
5. **Push:** Upload to ECR
6. **Deploy:** Manual pull on EC2

## Monitoring & Logging

### CloudWatch Integration
- **Log Groups:**
  - `/aws/ec2/starttech-backend` - Backend logs
  - `/application/starttech` - Application logs
- **Alarms:**
  - High CPU utilization (>80%)
  - Unhealthy instance detection

## Security

### Access Control
- IAM roles for EC2 with least-privilege policies
- Security groups restricting inbound traffic
- Secrets managed via GitHub Secrets

### Data Protection
- MongoDB Atlas encryption at rest
- SSL/TLS for data in transit
- Environment variables for sensitive data

## Scalability Considerations

### Current Setup
- Single EC2 instance (t3.micro)
- Static frontend on S3

### Future Improvements
- Auto Scaling Group for backend
- Application Load Balancer
- CloudFront CDN for frontend
- Multi-AZ deployment
- Database read replicas

## Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | React + Vite | 18.x |
| Language | TypeScript | 5.x |
| Backend | Golang | 1.21 |
| Database | MongoDB | Atlas |
| Cache | Redis | Latest |
| Container | Docker | Latest |
| IaC | Terraform | 1.10+ |
| CI/CD | GitHub Actions | - |