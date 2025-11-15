#!/bin/bash

# Frontend Deployment Script
# This script helps prepare and deploy the frontend

set -e

echo "🚀 Starting frontend deployment preparation..."

# Check if .env exists
if [ ! -f "frontend/.env" ]; then
    echo "⚠️  Warning: frontend/.env not found. Creating from .env.example..."
    cp frontend/.env.example frontend/.env
    echo "📝 Please update frontend/.env with your configuration"
fi

# Install dependencies
echo "📦 Installing dependencies..."
cd frontend
npm install

# Run linter
echo "🔍 Running linter..."
npm run lint || echo "⚠️  Linter warnings found"

# Build for production
echo "🏗️  Building for production..."
npm run build

# Check build output
if [ -d "dist" ]; then
    echo "✅ Build successful! Output in frontend/dist/"
    echo "📋 Next steps:"
    echo "   1. Update frontend/.env with production API URL"
    echo "   2. Push to GitHub"
    echo "   3. Deploy on Vercel/Netlify"
else
    echo "❌ Build failed!"
    exit 1
fi

cd ..

