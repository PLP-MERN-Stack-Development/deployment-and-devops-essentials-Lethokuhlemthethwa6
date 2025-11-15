# Deployment Checklist for MERN Stack Application

## ✅ Pre-Deployment Checklist

### Backend (Render)
- [x] `render.yaml` configuration file present
- [x] `package.json` with correct scripts (`start`, `dev`, `test`)
- [x] `.gitignore` configured (excludes node_modules, .env)
- [x] Health check endpoint (`/health`) implemented
- [x] CORS properly configured for production
- [x] Environment variables ready (.env.example provided)
- [x] Error handling and logging implemented
- [x] MongoDB connection with proper error handling
- [x] Graceful shutdown handlers
- [ ] Git repository initialized and pushed to GitHub

**Required Environment Variables for Render:**
```
NODE_ENV=production
PORT=5000
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/dbname
FRONTEND_URL=https://your-app.vercel.app
LOG_LEVEL=info
SENTRY_DSN=optional
```

### Frontend (Vercel)
- [x] `vercel.json` configuration file present
- [x] `package.json` with build script
- [x] `.gitignore` configured
- [x] React Router configured with proper rewrites
- [x] Environment variables configured (.env.example provided)
- [x] Build optimization (Vite)
- [x] Code splitting and lazy loading
- [x] API integration with backend
- [ ] Git repository initialized and pushed to GitHub

**Required Environment Variables for Vercel:**
```
VITE_API_URL=https://your-backend.onrender.com
```

---

## 🚀 Deployment Steps

### Step 1: MongoDB Atlas Setup
1. Create MongoDB Atlas account at https://www.mongodb.com/cloud/atlas
2. Create a new cluster (FREE tier available)
3. Create database user with password
4. Whitelist all IP addresses (0.0.0.0/0) for Render
5. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/dbname?retryWrites=true&w=majority
   ```

### Step 2: Backend Deployment (Render)
1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/your-repo.git
   git push -u origin main
   ```

2. **Deploy on Render:**
   - Go to https://render.com
   - Sign up/Login with GitHub
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Render will auto-detect `render.yaml`
   
3. **Configure Environment Variables:**
   - In Render dashboard, go to "Environment"
   - Add all required variables:
     * `NODE_ENV` = `production`
     * `MONGO_URI` = Your MongoDB Atlas connection string
     * `FRONTEND_URL` = (will add after frontend deployment)
     * `LOG_LEVEL` = `info`

4. **Deploy:**
   - Click "Create Web Service"
   - Wait for deployment (5-10 minutes)
   - Copy your backend URL: `https://your-app-name.onrender.com`

5. **Verify:**
   - Visit: `https://your-app-name.onrender.com/health`
   - Should return: `{"status":"ok","database":"connected",...}`

### Step 3: Frontend Deployment (Vercel)
1. **Update Backend URL in Vercel:**
   - Before deploying, you need the Render backend URL

2. **Deploy on Vercel:**
   - Go to https://vercel.com
   - Sign up/Login with GitHub
   - Click "Add New..." → "Project"
   - Import your GitHub repository
   - Vercel will auto-detect Vite

3. **Configure Build Settings:**
   - Framework Preset: `Vite`
   - Build Command: `cd frontend && npm install && npm run build`
   - Output Directory: `frontend/dist`
   - Install Command: `cd frontend && npm install`

4. **Configure Environment Variables:**
   - In Vercel dashboard, go to "Settings" → "Environment Variables"
   - Add:
     * `VITE_API_URL` = Your Render backend URL (e.g., `https://your-app-name.onrender.com`)

5. **Deploy:**
   - Click "Deploy"
   - Wait for deployment (2-3 minutes)
   - Copy your frontend URL: `https://your-app.vercel.app`

### Step 4: Update Backend CORS
1. Go back to Render dashboard
2. Update `FRONTEND_URL` environment variable
3. Set to your Vercel URL: `https://your-app.vercel.app`
4. Render will automatically redeploy

### Step 5: Test Full Stack
1. Visit your Vercel app: `https://your-app.vercel.app`
2. Check all pages:
   - Home - Should show backend status
   - Dashboard - Should show real-time data
   - About - Static page
   - Contact - Form page
3. Verify API connection in Dashboard

---

## 🔍 Deployment Checklist Status

### ✅ Ready to Deploy
- [x] Backend code is production-ready
- [x] Frontend code is production-ready
- [x] Configuration files present
- [x] Environment variables documented
- [x] Error handling implemented
- [x] Logging configured
- [x] CORS configured
- [x] Health checks available

### ⏳ Needed Before Deployment
- [ ] MongoDB Atlas cluster created
- [ ] Git repository created and pushed
- [ ] Render account created
- [ ] Vercel account created

### 📋 Post-Deployment Tasks
- [ ] Update `FRONTEND_URL` in Render after frontend deployment
- [ ] Test all API endpoints in production
- [ ] Monitor logs for errors
- [ ] Set up custom domain (optional)
- [ ] Configure environment-specific settings

---

## 🛠️ Troubleshooting

### Backend Issues
**Problem:** Backend won't start
- Check Render logs
- Verify MONGO_URI is correct
- Ensure all dependencies in package.json

**Problem:** Database connection failed
- Verify MongoDB Atlas IP whitelist
- Check connection string format
- Ensure database user has permissions

**Problem:** CORS errors
- Update FRONTEND_URL in Render
- Check CORS configuration in backend/index.js
- Redeploy backend after changes

### Frontend Issues
**Problem:** Frontend shows blank page
- Check Vercel build logs
- Verify build command is correct
- Check for console errors in browser

**Problem:** Can't connect to backend
- Verify VITE_API_URL is set correctly
- Check backend is running: visit /health endpoint
- Look for CORS errors in browser console

**Problem:** Routing not working
- Ensure vercel.json has correct rewrites
- Check React Router configuration

---

## 📊 Monitoring

### Backend Health Check
- URL: `https://your-backend.onrender.com/health`
- Returns: System status, database connection, uptime

### Frontend Status
- Connection troubleshooter built-in
- Auto-diagnostics on connection failure
- Dashboard shows real-time backend status

---

## 🎉 Your Application is Deployment-Ready!

All necessary files and configurations are in place. Follow the deployment steps above to deploy your MERN stack application to Render and Vercel.

**Estimated Deployment Time:** 20-30 minutes

For detailed deployment guides, see:
- `DEPLOYMENT.md` - Full deployment guide
- `MONITORING.md` - Monitoring setup
- `backend/.env.example` - Backend environment variables
- `frontend/.env.example` - Frontend environment variables
