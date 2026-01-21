# StartTech CI/CD Application

A full-stack Todo application with automated CI/CD pipeline deployment to AWS.

## 🏗️ Architecture

- **Frontend:** React + TypeScript + Vite
- **Backend:** Golang REST API
- **Database:** MongoDB Atlas
- **Cache:** Redis (ElastiCache)
- **Infrastructure:** AWS (EC2, S3, CloudWatch)
- **CI/CD:** GitHub Actions
- **IaC:** Terraform

## 📁 Project Structure

\\\
StartTech-Abdulsamad-1174/
├── Client/                 # React frontend application
├── Server/MuchToDo/       # Golang backend API
├── .github/workflows/     # GitHub Actions CI/CD pipelines
└── scripts/               # Deployment scripts
\\\

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- Go 1.21+
- Docker
- AWS CLI configured
- MongoDB Atlas account

### Local Development

**Frontend:**
Bash
cd Client
npm install
npm run dev


**Backend:**
Bash
cd Server/MuchToDo
go mod download
go run cmd/api/main.go


## 🔧 Deployment

The application uses automated CI/CD pipelines:

- **Frontend:** Builds and deploys to S3 on push to \feature/full-stack
- **Backend:** Builds Docker image, pushes to ECR on push to \feature/full-stack

### AWS Resources

- **S3 Bucket:** starttech-frontend-production
- **S3 Website:** http://starttech-frontend-production.s3-website-us-east-1.amazonaws.com
- **EC2 Instance:** t3.micro (Backend at 3.238.39.224:8080)
- **ECR Repository:** starttech-backend
- **Redis:** ElastiCache cluster
- **MongoDB:** Atlas cluster
- **CloudWatch:** Log groups for monitoring

## 📊 Monitoring

- **CloudWatch Logs:** /aws/ec2/starttech-backend, /application/starttech
- **CloudWatch Alarms:** High CPU utilization monitoring
- **Health Endpoint:** http://3.238.39.224:8080/health

## 🔐 Environment Variables

Required GitHub Secrets:
- \AWS_ACCESS_KEY_ID\
- \AWS_SECRET_ACCESS_KEY\
- \S3_BUCKET_NAME\
- \BACKEND_PUBLIC_IP\
- \ECR_REGISTRY\
- \MONGODB_URI\
- \REDIS_URL\
- \JWT_SECRET\

See \Server/MuchToDo/.env.example\ for backend configuration template.

## 📝 Documentation

- [Architecture Documentation](ARCHITECTURE.md) - System architecture details
- [Operations Runbook](RUNBOOK.md) - Operations and troubleshooting guide

## 🔗 Related Repository

Infrastructure as Code: [StartTech-infra-Abdulsamad-1174](https://github.com/probaby01/StartTech-infra-Abdulsamad-1174)

## 🚦 CI/CD Status

- Frontend Pipeline: ✅ Passing
- Backend Pipeline: ✅ Passing

## 📦 Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend | React 18 + TypeScript + Vite |
| Backend | Golang 1.21 |
| Database | MongoDB Atlas |
| Cache | Redis (ElastiCache) |
| Container | Docker |
| Cloud | AWS (EC2, S3, CloudWatch) |
| CI/CD | GitHub Actions |
| IaC | Terraform |

## 👥 Team

- **Student:** Abdulsamad
- **Student ID:** 1174
- **Project:** StartTech Month 3 Assessment

## 📄 License

MIT License
