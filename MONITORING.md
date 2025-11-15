# Monitoring and Maintenance Guide

This document outlines the monitoring setup and maintenance procedures for the MERN stack application.

## Health Check Endpoints

### Backend Health Check

**Endpoint**: `GET /health`

**Response**:
```json
{
  "status": "ok",
  "uptime": 12345.67,
  "timestamp": "2024-01-15T10:30:00.000Z",
  "environment": "production",
  "database": "connected",
  "memory": {
    "rss": 12345678,
    "heapTotal": 8765432,
    "heapUsed": 4321098,
    "external": 123456
  }
}
```

**Status Codes**:
- `200` - Healthy (database connected)
- `503` - Unhealthy (database disconnected)

### API Status

**Endpoint**: `GET /api/status`

**Response**:
```json
{
  "status": "operational",
  "database": "connected",
  "uptime": 12345.67,
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## Error Tracking with Sentry

### Setup

1. **Create Sentry Account**
   - Go to [sentry.io](https://sentry.io)
   - Sign up and create a new project
   - Select "Node.js" as the platform

2. **Get DSN**
   - Copy your DSN from project settings
   - Format: `https://xxxxx@xxxxx.ingest.sentry.io/xxxxx`

3. **Configure Backend**
   - Add `SENTRY_DSN` to your backend environment variables
   - Redeploy the backend

### What Gets Tracked

- Unhandled exceptions
- API errors
- Database connection errors
- Performance issues

### Accessing Sentry Dashboard

- Go to [sentry.io](https://sentry.io)
- Navigate to your project
- View errors, performance metrics, and releases

## Logging

### Log Levels

- **Development**: `debug` - Detailed logs
- **Production**: `info` - Important events only

### Log Outputs

**Development**:
- Console (colored, formatted)

**Production**:
- Console (JSON format)
- `error.log` - Error-level logs only
- `combined.log` - All logs

### Log Format

```json
{
  "level": "info",
  "message": "MongoDB connected successfully",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "service": "mern-backend"
}
```

## Uptime Monitoring

### Recommended Services

1. **UptimeRobot** (Free)
   - URL: [uptimerobot.com](https://uptimerobot.com)
   - Free tier: 50 monitors, 5-minute intervals
   - Setup:
     - Create account
     - Add monitor: HTTP(s)
     - URL: `https://your-backend-url.onrender.com/health`
     - Interval: 5 minutes
     - Alert contacts: Email

2. **Pingdom** (Paid)
   - More features, paid service

3. **StatusCake** (Free tier available)
   - Free tier with limitations

### Monitoring Checklist

- [ ] Backend health endpoint monitored
- [ ] Frontend URL monitored
- [ ] Email alerts configured
- [ ] SMS alerts configured (optional)
- [ ] Slack/Discord webhooks (optional)

## Performance Monitoring

### Backend Performance

**Render Dashboard**:
- CPU usage
- Memory usage
- Request metrics
- Response times

**MongoDB Atlas**:
- Database performance metrics
- Query performance
- Connection pool usage
- Index usage

### Frontend Performance

**Vercel Analytics**:
- Page load times
- Core Web Vitals
- Real User Monitoring (RUM)

**Browser DevTools**:
- Network tab
- Performance tab
- Lighthouse audits

### Key Metrics to Monitor

1. **Response Time**
   - Target: < 200ms for API endpoints
   - Alert if: > 1s consistently

2. **Error Rate**
   - Target: < 1% of requests
   - Alert if: > 5%

3. **Database Connection**
   - Monitor connection pool usage
   - Alert if: > 80% pool usage

4. **Memory Usage**
   - Alert if: > 80% of available memory

5. **CPU Usage**
   - Alert if: > 80% consistently

## Database Monitoring

### MongoDB Atlas Monitoring

1. **Performance Advisor**
   - Identifies slow queries
   - Suggests index improvements

2. **Real-Time Performance Panel**
   - Active operations
   - Connection metrics
   - Query patterns

3. **Alerts**
   - Set up alerts for:
     - High CPU usage
     - High memory usage
     - Connection pool exhaustion
     - Replication lag

### Database Backups

**MongoDB Atlas**:
- Automatic backups enabled by default
- Point-in-time recovery available
- Manual backup via Atlas UI

**Manual Backup**:
```bash
mongodump --uri="your-connection-string" --out=./backup
```

**Restore**:
```bash
mongorestore --uri="your-connection-string" ./backup
```

## Maintenance Schedule

### Daily
- [ ] Check error logs in Sentry
- [ ] Review uptime monitoring alerts
- [ ] Check application health endpoints

### Weekly
- [ ] Review performance metrics
- [ ] Check database performance
- [ ] Review and update dependencies
- [ ] Check security advisories

### Monthly
- [ ] Update dependencies
- [ ] Review and optimize database queries
- [ ] Review and clean up logs
- [ ] Performance audit
- [ ] Security audit

### Quarterly
- [ ] Full security review
- [ ] Performance optimization
- [ ] Database optimization
- [ ] Documentation updates
- [ ] Disaster recovery test

## Alerting Configuration

### Critical Alerts (Immediate Action Required)

- Application down (health check fails)
- Database connection lost
- Error rate > 10%
- Memory usage > 90%

### Warning Alerts (Monitor Closely)

- Response time > 1s
- Error rate > 5%
- Memory usage > 80%
- CPU usage > 80%
- Database connection pool > 80%

### Info Alerts (For Awareness)

- Deployment completed
- High traffic spike
- New error patterns

## Rollback Procedures

### Backend Rollback (Render)

1. Go to Render dashboard
2. Navigate to your service
3. Click "Events" tab
4. Find previous successful deployment
5. Click "Rollback" button
6. Confirm rollback

**Time to Rollback**: ~2-5 minutes

### Frontend Rollback (Vercel)

1. Go to Vercel dashboard
2. Select your project
3. Go to "Deployments"
4. Find previous deployment
5. Click "..." → "Promote to Production"

**Time to Rollback**: ~1-2 minutes

### Database Rollback

1. Go to MongoDB Atlas
2. Navigate to "Backups"
3. Select point-in-time restore
4. Choose restore point
5. Create new cluster or restore to existing

**Time to Rollback**: ~10-30 minutes

## Performance Optimization

### Backend Optimization

1. **Database Indexing**
   - Review slow queries
   - Add appropriate indexes
   - Monitor index usage

2. **Connection Pooling**
   - Monitor pool usage
   - Adjust `MONGO_POOL_SIZE` if needed

3. **Caching**
   - Implement Redis for frequently accessed data
   - Cache API responses where appropriate

4. **Code Optimization**
   - Profile application
   - Optimize slow endpoints
   - Reduce database queries

### Frontend Optimization

1. **Code Splitting**
   - Already implemented with lazy loading
   - Monitor bundle sizes

2. **Asset Optimization**
   - Compress images
   - Use CDN for static assets
   - Enable gzip compression

3. **Caching**
   - Configure cache headers
   - Use service workers (optional)

## Security Monitoring

### Regular Security Checks

1. **Dependency Vulnerabilities**
   ```bash
   npm audit
   npm audit fix
   ```

2. **Security Headers**
   - Verify Helmet is configured
   - Check security headers in response

3. **Authentication/Authorization**
   - Review access logs
   - Monitor failed login attempts

4. **API Security**
   - Rate limiting (implement if needed)
   - Input validation
   - SQL injection prevention (N/A for MongoDB, but validate inputs)

## Troubleshooting Common Issues

### High Memory Usage

1. Check for memory leaks
2. Review application logs
3. Restart service if needed
4. Consider upgrading service tier

### Slow Response Times

1. Check database query performance
2. Review API endpoint code
3. Check external API dependencies
4. Review connection pool usage

### Database Connection Issues

1. Check MongoDB Atlas status
2. Verify IP whitelist
3. Check connection string
4. Review connection pool settings

### High Error Rate

1. Check Sentry for error details
2. Review application logs
3. Check database status
4. Review recent deployments

## Maintenance Log Template

```
Date: YYYY-MM-DD
Maintenance Type: [Update/Backup/Security/Performance]
Description: Brief description
Actions Taken: List of actions
Results: Outcome
Next Steps: Follow-up actions
```

---

**Remember**: Regular monitoring and maintenance are crucial for a healthy production application!

