# Quick Start Guide

Get your MERN stack application up and running quickly!

## 🚀 Quick Setup (5 minutes)

### 1. Clone and Install

```bash
# Clone the repository
git clone <your-repo-url>
cd <your-repo-name>

# Install backend dependencies
cd backend
npm install
cp .env.example .env
# Edit .env with your settings

# Install frontend dependencies
cd ../frontend
npm install
cp .env.example .env
# Edit .env with your settings
```

### 2. Start Development Servers

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```
Backend runs on `http://localhost:5000`

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```
Frontend runs on `http://localhost:3000`

### 3. Verify Setup

- Open `http://localhost:3000` in your browser
- Click "Check API Status" button
- Should see backend status information

## 📋 Environment Variables Quick Reference

### Backend (.env)
```env
NODE_ENV=development
PORT=5000
MONGO_URI=mongodb://localhost:27017/plp_week7
FRONTEND_URL=http://localhost:3000
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:5000
```

## 🧪 Quick Test

```bash
# Backend tests
cd backend
npm test

# Frontend lint
cd ../frontend
npm run lint
```

## 🚢 Quick Deploy

### Backend (Render)
1. Push code to GitHub
2. Go to render.com
3. New Web Service → Connect GitHub
4. Set build: `cd backend && npm install`
5. Set start: `cd backend && npm start`
6. Add environment variables
7. Deploy!

### Frontend (Vercel)
1. Push code to GitHub
2. Go to vercel.com
3. Import project
4. Set root: `frontend`
5. Add `VITE_API_URL` env var
6. Deploy!

## 📚 Full Documentation

- **README.md** - Complete documentation
- **DEPLOYMENT.md** - Detailed deployment guide
- **MONITORING.md** - Monitoring and maintenance

## 🆘 Need Help?

1. Check the main README.md
2. Review DEPLOYMENT.md for deployment issues
3. Check MONITORING.md for monitoring setup
4. Open an issue in the repository

---

**Happy Coding! 🎉**

