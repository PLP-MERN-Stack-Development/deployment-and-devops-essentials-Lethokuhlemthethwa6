require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const mongoose = require('mongoose');
const winston = require('winston');
const Sentry = require('@sentry/node');
const path = require('path');

// Initialize Sentry only if DSN is provided
if (process.env.SENTRY_DSN) {
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV || 'development',
    tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
  });
}

const app = express();

// Sentry request handler (only if Sentry is initialized)
if (process.env.SENTRY_DSN) {
  app.use(Sentry.Handlers.requestHandler());
  app.use(Sentry.Handlers.tracingHandler());
}

// Enhanced Logger (winston) with file transport for production
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || (process.env.NODE_ENV === 'production' ? 'info' : 'debug'),
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'mern-backend' },
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    })
  ],
});

// Add file transport in production
if (process.env.NODE_ENV === 'production') {
  logger.add(new winston.transports.File({ 
    filename: 'error.log', 
    level: 'error' 
  }));
  logger.add(new winston.transports.File({ 
    filename: 'combined.log' 
  }));
}

// Security middleware with enhanced configuration
app.use(helmet({
  contentSecurityPolicy: process.env.NODE_ENV === 'production' ? undefined : false,
  crossOriginEmbedderPolicy: false,
}));

// CORS configuration - Support multiple origins
const getAllowedOrigins = () => {
  if (process.env.FRONTEND_URL) {
    // Support comma-separated multiple origins
    return process.env.FRONTEND_URL.split(',').map(url => url.trim());
  }
  // Default origins for production if FRONTEND_URL not set
  if (process.env.NODE_ENV === 'production') {
    return []; // Will be checked in origin function
  }
  // Allow all in development
  return '*';
};

const corsOptions = {
  origin: (origin, callback) => {
    const allowedOrigins = getAllowedOrigins();
    
    // Allow requests with no origin (mobile apps, Postman, etc.)
    if (!origin) {
      return callback(null, true);
    }
    
    // Allow all origins in development
    if (allowedOrigins === '*') {
      return callback(null, true);
    }
    
    // Check if origin is in allowed list
    if (allowedOrigins.length === 0) {
      // Production without FRONTEND_URL set - reject
      logger.warn(`Rejected request from unauthorized origin: ${origin}`);
      return callback(new Error('Not allowed by CORS'), false);
    }
    
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    
    logger.warn(`Rejected request from unauthorized origin: ${origin}`);
    callback(new Error('Not allowed by CORS'), false);
  },
  credentials: true,
  optionsSuccessStatus: 200
};
app.use(cors(corsOptions));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging middleware
if (process.env.NODE_ENV === 'production') {
  app.use(morgan('combined', { stream: { write: msg => logger.info(msg.trim()) } }));
} else {
  app.use(morgan('dev'));
}

// MongoDB Atlas connection with enhanced pooling and error handling
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/plp_week7';

const mongooseOptions = {
  maxPoolSize: Number(process.env.MONGO_POOL_SIZE || 10),
  minPoolSize: Number(process.env.MONGO_MIN_POOL_SIZE || 2),
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
  family: 4, // Use IPv4, skip trying IPv6
};

mongoose.connect(MONGO_URI, mongooseOptions)
  .then(() => {
    logger.info('MongoDB connected successfully');
    logger.info(`Database: ${mongoose.connection.name}`);
  })
  .catch(err => {
    logger.error('MongoDB connection error:', err);
    // Don't exit in production, let the app try to reconnect
    if (process.env.NODE_ENV !== 'production') {
      process.exit(1);
    }
  });

// MongoDB connection event handlers
mongoose.connection.on('disconnected', () => {
  logger.warn('MongoDB disconnected');
});

mongoose.connection.on('error', (err) => {
  logger.error('MongoDB error:', err);
});

// Enhanced Health check endpoint
app.get('/health', async (req, res) => {
  const healthCheck = {
    status: 'ok',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    database: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected',
    memory: process.memoryUsage(),
  };

  const statusCode = healthCheck.database === 'connected' ? 200 : 503;
  res.status(statusCode).json(healthCheck);
});

// API Routes
app.get('/api', (req, res) => {
  res.json({ 
    message: 'PLP Week 7: MERN Stack Backend API',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    endpoints: {
      health: '/health',
      api: '/api',
      status: '/api/status'
    }
  });
});

app.get('/api/status', (req, res) => {
  res.json({
    status: 'operational',
    database: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// API route handler (example)
const router = express.Router();

router.get('/test', (req, res) => {
  res.json({ message: 'API test endpoint working!' });
});

app.use('/api', router);

// Serve frontend static files in production
if (process.env.NODE_ENV === 'production') {
  const frontendPath = path.join(__dirname, '../frontend/dist');
  app.use(express.static(frontendPath));
  
  app.get('*', (req, res) => {
    res.sendFile(path.join(frontendPath, 'index.html'));
  });
}

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Cannot ${req.method} ${req.path}`,
    statusCode: 404
  });
});

// Global error handler
app.use((err, req, res, next) => {
  logger.error('Error:', {
    error: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method
  });

  // Send error to Sentry if configured
  if (process.env.SENTRY_DSN) {
    Sentry.captureException(err);
  }

  const statusCode = err.statusCode || 500;
  const message = process.env.NODE_ENV === 'production' 
    ? 'Internal Server Error' 
    : err.message;

  res.status(statusCode).json({
    error: message,
    statusCode,
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
  });
});

// Sentry error handler (must be last, after all other middleware)
if (process.env.SENTRY_DSN) {
  app.use(Sentry.Handlers.errorHandler());
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  try {
    await mongoose.connection.close();
    logger.info('MongoDB connection closed');
    process.exit(0);
  } catch (err) {
    logger.error('Error during shutdown:', err);
    process.exit(1);
  }
});

process.on('SIGINT', async () => {
  logger.info('SIGINT signal received: closing HTTP server');
  try {
    await mongoose.connection.close();
    logger.info('MongoDB connection closed');
    process.exit(0);
  } catch (err) {
    logger.error('Error during shutdown:', err);
    process.exit(1);
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  logger.info(`Server listening on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
