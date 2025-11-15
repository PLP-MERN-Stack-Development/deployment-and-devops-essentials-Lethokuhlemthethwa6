# Deployment Guide

This document provides detailed step-by-step instructions for deploying the MERN stack application.

## Prerequisites Checklist

- [ ] GitHub repository created and code pushed
- [ ] MongoDB Atlas account created
- [ ] Render/Railway/Heroku account (for backend)
- [ ] Vercel/Netlify account (for frontend)
- [ ] Sentry account (optional, for error tracking)

## Step 1: MongoDB Atlas Setup

### 1.1 Create Cluster
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Sign up or log in
3. Click "Build a Database"
4. Choose "FREE" (M0) tier
5. Select a cloud provider and region
6. Click "Create"

### 1.2 Create Database User
1. Go to "Database Access" in the left sidebar
2. Click "Add New Database User"
3. Choose "Password" authentication
4. Enter username and password (save these!)
5. Set user privileges to "Read and write to any database"
6. Click "Add User"

### 1.3 Configure Network Access
1. Go to "Network Access" in the left sidebar
2. Click "Add IP Address"
3. Click "Allow Access from Anywhere" (or add specific IPs)
4. Click "Confirm"

### 1.4 Get Connection String
1. Go to "Database" → "Connect"
2. Click "Connect your application"
3. Choose "Node.js" and version "5.5 or later"
4. Copy the connection string
5. Replace `<password>` with your database user password
6. Replace `<dbname>` with your database name (e.g., `plp_week7`)

Example:
```
mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/plp_week7?retryWrites=true&w=majority
```

## Step 2: Backend Deployment (Render)

### 2.1 Create Render Account
1. Go to [render.com](https://render.com)
2. Sign up with GitHub

### 2.2 Create Web Service
1. Click "New +" → "Web Service"
2. Connect your GitHub account if not already connected
3. Select your repository
4. Click "Connect"

### 2.3 Configure Service
- **Name**: `mern-backend` (or your preferred name)
- **Region**: Choose closest to your users
- **Branch**: `main` (or your default branch)
- **Root Directory**: Leave empty
- **Environment**: `Node`
- **Build Command**: `cd backend && npm install`
- **Start Command**: `cd backend && npm start`

### 2.4 Set Environment Variables
Click "Advanced" → "Add Environment Variable" and add:

```
NODE_ENV=production
MONGO_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/plp_week7?retryWrites=true&w=majority
FRONTEND_URL=https://your-frontend-url.vercel.app
LOG_LEVEL=info
SENTRY_DSN=your-sentry-dsn (optional)
```

### 2.5 Deploy
1. Click "Create Web Service"
2. Wait for deployment (5-10 minutes)
3. Copy the service URL (e.g., `https://mern-backend.onrender.com`)

### 2.6 Verify Deployment
1. Visit `https://your-backend-url.onrender.com/health`
2. Should return JSON with status "ok"

## Step 3: Frontend Deployment (Vercel)

### 3.1 Create Vercel Account
1. Go to [vercel.com](https://vercel.com)
2. Sign up with GitHub

### 3.2 Import Project
1. Click "Add New..." → "Project"
2. Import your GitHub repository
3. Click "Import"

### 3.3 Configure Project
- **Framework Preset**: Vite
- **Root Directory**: `frontend`
- **Build Command**: `npm run build` (auto-detected)
- **Output Directory**: `dist` (auto-detected)
- **Install Command**: `npm install` (auto-detected)

### 3.4 Set Environment Variables
Click "Environment Variables" and add:

```
VITE_API_URL=https://your-backend-url.onrender.com
```

### 3.5 Deploy
1. Click "Deploy"
2. Wait for deployment (2-5 minutes)
3. Copy the deployment URL (e.g., `https://your-app.vercel.app`)

### 3.6 Update Backend CORS
1. Go back to Render dashboard
2. Update `FRONTEND_URL` environment variable with your Vercel URL
3. Redeploy the backend service

## Step 4: Alternative Frontend Deployment (Netlify)

### 4.1 Create Netlify Account
1. Go to [netlify.com](https://netlify.com)
2. Sign up with GitHub

### 4.2 Deploy Site
1. Click "Add new site" → "Import an existing project"
2. Connect to GitHub
3. Select your repository

### 4.3 Configure Build Settings
- **Base directory**: `frontend`
- **Build command**: `npm run build`
- **Publish directory**: `frontend/dist`

### 4.4 Set Environment Variables
Go to "Site settings" → "Environment variables" and add:

```
VITE_API_URL=https://your-backend-url.onrender.com
```

### 4.5 Deploy
1. Click "Deploy site"
2. Wait for deployment
3. Copy the site URL

## Step 5: Set Up CI/CD

### 5.1 GitHub Secrets
Go to your repository → Settings → Secrets and variables → Actions

Add secrets:
- `RENDER_SERVICE_ID`: Found in Render dashboard → Settings
- `RENDER_API_KEY`: Render dashboard → Account Settings → API Keys
- `VERCEL_TOKEN`: Vercel dashboard → Settings → Tokens
- `VERCEL_ORG_ID`: Vercel dashboard → Settings
- `VERCEL_PROJECT_ID`: Vercel project settings
- `VITE_API_URL`: Your production backend URL

### 5.2 Enable Auto-Deploy
- **Render**: Already enabled by default when connected to GitHub
- **Vercel**: Already enabled by default
- **Netlify**: Already enabled by default

## Step 6: Set Up Monitoring

### 6.1 Sentry (Error Tracking)

1. Go to [sentry.io](https://sentry.io)
2. Create account and new project (Node.js)
3. Copy DSN
4. Add to backend environment variables:
   ```
   SENTRY_DSN=https://xxxxx@xxxxx.ingest.sentry.io/xxxxx
   ```
5. Redeploy backend

### 6.2 Uptime Monitoring

1. Go to [UptimeRobot](https://uptimerobot.com) (free)
2. Create account
3. Add new monitor:
   - **Type**: HTTP(s)
   - **URL**: Your backend health endpoint
   - **Interval**: 5 minutes
4. Add email alerts

### 6.3 Performance Monitoring

- **Render**: Built-in metrics in dashboard
- **Vercel**: Built-in analytics
- **MongoDB Atlas**: Built-in performance monitoring

## Step 7: Custom Domain (Optional)

### 7.1 Backend Custom Domain (Render)
1. Go to Render dashboard → Your service → Settings
2. Click "Custom Domains"
3. Add your domain
4. Follow DNS configuration instructions

### 7.2 Frontend Custom Domain (Vercel)
1. Go to Vercel dashboard → Your project → Settings
2. Click "Domains"
3. Add your domain
4. Follow DNS configuration instructions

## Step 8: SSL/HTTPS

Both Render and Vercel provide free SSL certificates automatically. No action needed!

## Troubleshooting

### Backend Won't Start
- Check build logs in Render dashboard
- Verify all environment variables are set
- Check MongoDB connection string format
- Ensure Node.js version is 18+

### Frontend Build Fails
- Check build logs in Vercel/Netlify
- Verify `VITE_API_URL` is set
- Check for TypeScript/ESLint errors
- Ensure all dependencies are in package.json

### CORS Errors
- Verify `FRONTEND_URL` in backend matches frontend URL exactly
- Check for trailing slashes
- Verify HTTPS/HTTP matches

### Database Connection Issues
- Verify MongoDB Atlas IP whitelist includes `0.0.0.0/0`
- Check connection string format
- Verify database user has correct permissions
- Check MongoDB Atlas cluster status

## Post-Deployment Checklist

- [ ] Backend health check returns 200
- [ ] Frontend loads correctly
- [ ] API calls from frontend work
- [ ] Environment variables are set correctly
- [ ] CI/CD pipelines are running
- [ ] Monitoring is set up
- [ ] Custom domain configured (if applicable)
- [ ] SSL certificates active
- [ ] README.md updated with live URLs

## Rollback Procedures

### Render Rollback
1. Go to Render dashboard
2. Select your service
3. Go to "Events" tab
4. Find previous successful deployment
5. Click "Rollback"

### Vercel Rollback
1. Go to Vercel dashboard
2. Select your project
3. Go to "Deployments"
4. Find previous deployment
5. Click "..." → "Promote to Production"

---

**Need Help?** Check the main README.md or open an issue in the repository.

