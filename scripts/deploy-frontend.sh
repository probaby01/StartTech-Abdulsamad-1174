#!/bin/bash
set -e

echo "Building React application..."
cd Client
npm install
npm run build

echo "Deploying to S3..."
aws s3 sync dist/ s3://$S3_BUCKET_NAME --delete

echo "Frontend deployment complete!"