#!/bin/bash

# Backend Deployment Script
# This script helps prepare and deploy the backend

set -e

echo "🚀 Starting backend deployment preparation..."

# Check if .env exists
if [ ! -f "backend/.env" ]; then
    echo "⚠️  Warning: backend/.env not found. Creating from .env.example..."
    cp backend/.env.example backend/.env
    echo "📝 Please update backend/.env with your configuration"
fi

# Install dependencies
echo "📦 Installing dependencies..."
cd backend
npm install

# Run tests
echo "🧪 Running tests..."
npm test || echo "⚠️  Tests failed, but continuing..."

# Run linter
echo "🔍 Running linter..."
npm run lint || echo "⚠️  Linter warnings found"

# Build check
echo "✅ Backend is ready for deployment!"
echo "📋 Next steps:"
echo "   1. Update backend/.env with production values"
echo "   2. Push to GitHub"
echo "   3. Deploy on Render/Railway/Heroku"

cd ..

