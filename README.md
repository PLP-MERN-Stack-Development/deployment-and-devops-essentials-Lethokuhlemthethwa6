# MERN Stack Application - Week 7: Deployment and DevOps

A full-stack MERN (MongoDB, Express, React, Node.js) application with production-ready deployment configuration, CI/CD pipelines, and monitoring setup.

## 🚀 Live Application

- **Frontend URL**: [To be updated after deployment]
- **Backend API URL**: [To be updated after deployment]

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring](#monitoring)
- [Maintenance](#maintenance)

## ✨ Features

- ✅ Production-ready Express.js backend with error handling
- ✅ Optimized React frontend with code splitting
- ✅ MongoDB Atlas integration with connection pooling
- ✅ CI/CD pipelines with GitHub Actions
- ✅ Automated testing and linting
- ✅ Health check endpoints
- ✅ Error tracking with Sentry (optional)
- ✅ Comprehensive logging with Winston
- ✅ Security headers with Helmet
- ✅ CORS configuration
- ✅ Environment-based configuration

## 🛠 Tech Stack

### Backend
- **Node.js** (v18+)
- **Express.js** - Web framework
- **MongoDB** / **MongoDB Atlas** - Database
- **Mongoose** - ODM
- **Winston** - Logging
- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing
- **Sentry** - Error tracking (optional)

### Frontend
- **React 19** - UI library
- **Vite** - Build tool
- **Axios** - HTTP client
- **Tailwind CSS** - Styling
- **React Router** - Routing

### DevOps
- **GitHub Actions** - CI/CD
- **Render/Railway/Heroku** - Backend hosting
- **Vercel/Netlify** - Frontend hosting
- **MongoDB Atlas** - Database hosting

## 📁 Project Structure

```
.
├── backend/
│   ├── index.js              # Main server file
│   ├── package.json          # Backend dependencies
│   ├── .env.example          # Environment variables template
│   └── tests/                # Test files
│       ├── sample.test.js
│       └── api.test.js
├── frontend/
│   ├── src/
│   │   ├── components/       # React components
│   │   ├── config/           # Configuration files
│   │   ├── utils/            # Utility functions
│   │   ├── App.jsx           # Main App component
│   │   └── main.jsx          # Entry point
│   ├── package.json          # Frontend dependencies
│   ├── vite.config.js        # Vite configuration
│   └── .env.example          # Environment variables template
├── .github/
│   └── workflows/            # GitHub Actions workflows
│       ├── backend-ci.yml    # Backend CI/CD
│       ├── frontend-ci.yml   # Frontend CI/CD
│       └── deploy.yml        # Deployment workflow
├── render.yaml               # Render deployment config
├── vercel.json               # Vercel deployment config
├── netlify.toml              # Netlify deployment config
├── railway.json              # Railway deployment config
└── README.md                 # This file
```

## 📦 Prerequisites

- **Node.js** (v18 or higher)
- **npm** (v9 or higher)
- **MongoDB Atlas** account (or local MongoDB)
- **Git** and **GitHub** account
- Accounts on deployment platforms:
  - Render/Railway/Heroku (for backend)
  - Vercel/Netlify (for frontend)
- **Sentry** account (optional, for error tracking)

## 🏃 Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### 2. Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

The backend will run on `http://localhost:5000`

### 3. Frontend Setup

```bash
cd frontend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

The frontend will run on `http://localhost:3000`

## 🔐 Environment Variables

### Backend (.env)

```env
NODE_ENV=development
PORT=5000
MONGO_URI=mongodb://localhost:27017/plp_week7
MONGO_POOL_SIZE=10
MONGO_MIN_POOL_SIZE=2
FRONTEND_URL=http://localhost:3000
LOG_LEVEL=info
SENTRY_DSN=your-sentry-dsn-here
```

### Frontend (.env)

```env
VITE_API_URL=http://localhost:5000
VITE_ENV=development
```

### Production Environment Variables

Set these in your deployment platform:

**Backend:**
- `NODE_ENV=production`
- `MONGO_URI` - Your MongoDB Atlas connection string
- `FRONTEND_URL` - Your deployed frontend URL
- `SENTRY_DSN` - Your Sentry DSN (optional)

**Frontend:**
- `VITE_API_URL` - Your deployed backend URL

## 🚢 Deployment

### Backend Deployment (Render)

1. **Create a Render Account**
   - Go to [render.com](https://render.com)
   - Sign up or log in

2. **Create a New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select the repository and branch

3. **Configure the Service**
   - **Name**: `mern-backend`
   - **Environment**: `Node`
   - **Build Command**: `cd backend && npm install`
   - **Start Command**: `cd backend && npm start`
   - **Root Directory**: Leave empty (or set to `backend`)

4. **Set Environment Variables**
   - `NODE_ENV=production`
   - `MONGO_URI` - Your MongoDB Atlas connection string
   - `FRONTEND_URL` - Your frontend URL
   - `SENTRY_DSN` - Optional
   - `LOG_LEVEL=info`

5. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment to complete
   - Copy the service URL

### Frontend Deployment (Vercel)

1. **Create a Vercel Account**
   - Go to [vercel.com](https://vercel.com)
   - Sign up with GitHub

2. **Import Project**
   - Click "Add New..." → "Project"
   - Import your GitHub repository

3. **Configure Project**
   - **Framework Preset**: Vite
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

4. **Set Environment Variables**
   - `VITE_API_URL` - Your deployed backend URL

5. **Deploy**
   - Click "Deploy"
   - Wait for deployment
   - Copy the deployment URL

### Alternative: Netlify Deployment

1. Go to [netlify.com](https://netlify.com)
2. Connect your GitHub repository
3. Configure:
   - **Base directory**: `frontend`
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
4. Set environment variables
5. Deploy

### MongoDB Atlas Setup

1. **Create a Cluster**
   - Go to [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
   - Create a free cluster

2. **Create Database User**
   - Go to "Database Access"
   - Create a new user with read/write permissions

3. **Whitelist IP Addresses**
   - Go to "Network Access"
   - Add `0.0.0.0/0` for all IPs (or specific IPs)

4. **Get Connection String**
   - Go to "Database" → "Connect"
   - Choose "Connect your application"
   - Copy the connection string
   - Replace `<password>` with your user password

## 🔄 CI/CD Pipeline

The project includes GitHub Actions workflows for:

### Backend CI/CD (`.github/workflows/backend-ci.yml`)
- Runs tests on push/PR
- Lints code
- Tests on multiple Node.js versions
- Generates coverage reports

### Frontend CI/CD (`.github/workflows/frontend-ci.yml`)
- Runs linter
- Builds application
- Creates preview builds for PRs

### Deployment (`.github/workflows/deploy.yml`)
- Automatically deploys on push to `main`
- Supports manual deployment via workflow_dispatch

### Setting Up GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions

Add the following secrets:
- `RENDER_SERVICE_ID` - Your Render service ID
- `RENDER_API_KEY` - Your Render API key
- `VERCEL_TOKEN` - Your Vercel token
- `VERCEL_ORG_ID` - Your Vercel organization ID
- `VERCEL_PROJECT_ID` - Your Vercel project ID
- `VITE_API_URL` - Your production API URL

## 📊 Monitoring

### Health Check Endpoints

- **Backend Health**: `GET /health`
  - Returns server status, uptime, database connection, and memory usage

- **API Status**: `GET /api/status`
  - Returns API operational status

### Error Tracking (Sentry)

1. **Create a Sentry Account**
   - Go to [sentry.io](https://sentry.io)
   - Create a new project (Node.js)

2. **Get DSN**
   - Copy your DSN from project settings

3. **Configure**
   - Add `SENTRY_DSN` to your environment variables
   - Errors will automatically be tracked

### Logging

- **Development**: Logs to console with colors
- **Production**: Logs to console and files (`error.log`, `combined.log`)
- Uses Winston for structured logging

## 🔧 Maintenance

### Regular Updates

1. **Dependencies**
   ```bash
   cd backend && npm update
   cd ../frontend && npm update
   ```

2. **Security Audits**
   ```bash
   npm audit
   npm audit fix
   ```

### Database Backups

MongoDB Atlas provides automatic backups. For manual backups:

1. Use MongoDB Atlas backup feature
2. Or use `mongodump`:
   ```bash
   mongodump --uri="your-connection-string"
   ```

### Rollback Procedures

#### Backend Rollback (Render)
1. Go to Render dashboard
2. Navigate to your service
3. Go to "Events" tab
4. Find the previous successful deployment
5. Click "Rollback"

#### Frontend Rollback (Vercel)
1. Go to Vercel dashboard
2. Select your project
3. Go to "Deployments"
4. Find the previous deployment
5. Click "..." → "Promote to Production"

### Performance Monitoring

- Monitor API response times
- Check database query performance
- Monitor memory and CPU usage
- Set up uptime monitoring (e.g., UptimeRobot)

## 🧪 Testing

### Backend Tests

```bash
cd backend
npm test
```

### Frontend Tests

```bash
cd frontend
npm run lint
npm run build
```

## 📝 Scripts

### Backend Scripts
- `npm start` - Start production server
- `npm run dev` - Start development server with nodemon
- `npm test` - Run tests
- `npm run lint` - Run linter

### Frontend Scripts
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run linter

## 🐛 Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   - Check your connection string
   - Verify IP whitelist in MongoDB Atlas
   - Check database user permissions

2. **CORS Errors**
   - Verify `FRONTEND_URL` in backend environment
   - Check frontend `VITE_API_URL`

3. **Build Failures**
   - Check Node.js version (should be 18+)
   - Verify all environment variables are set
   - Check build logs for specific errors

4. **Deployment Issues**
   - Verify build commands are correct
   - Check environment variables in deployment platform
   - Review deployment logs

## 📚 Additional Resources

- [Express.js Documentation](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Vite Documentation](https://vite.dev/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 📄 License

This project is part of the PLP Africa Week 7 assignment.

## 👥 Contributors

Lethokuhle Mthethwa


---

**Note**: Remember to update the frontend and backend URLs in this README after deployment!

