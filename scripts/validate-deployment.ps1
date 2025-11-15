# Validate Deployment Configuration
# Checks if all required environment variables are set for deployment

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Deployment Configuration Validator" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$deploymentReady = $true

# Check Backend Configuration
Write-Host "Backend Configuration:" -ForegroundColor Yellow
Write-Host "----------------------" -ForegroundColor Yellow

$requiredBackendVars = @{
    "NODE_ENV" = "Should be 'production' for deployment"
    "MONGO_URI" = "MongoDB connection string (Atlas recommended)"
    "FRONTEND_URL" = "Frontend URL(s) for CORS (comma-separated if multiple)"
    "PORT" = "Server port (usually 5000 or assigned by platform)"
}

if (Test-Path "backend\.env.example") {
    Write-Host ""
    foreach ($var in $requiredBackendVars.Keys) {
        Write-Host "  $var" -ForegroundColor Cyan
        Write-Host "    $($requiredBackendVars[$var])" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "Optional Backend Variables:" -ForegroundColor Yellow
Write-Host "  SENTRY_DSN - Error tracking" -ForegroundColor White
Write-Host "  LOG_LEVEL - Logging level (info recommended)" -ForegroundColor White

Write-Host ""
Write-Host "Frontend Configuration:" -ForegroundColor Yellow
Write-Host "----------------------" -ForegroundColor Yellow

Write-Host ""
Write-Host "  VITE_API_URL" -ForegroundColor Cyan
Write-Host "    Your deployed backend URL" -ForegroundColor White
Write-Host "    Example: https://your-backend.onrender.com" -ForegroundColor Gray

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Deployment Platforms Configured:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check deployment configurations
$deploymentConfigs = @(
    @{File="render.yaml"; Platform="Render"; Type="Backend"},
    @{File="railway.json"; Platform="Railway"; Type="Backend"},
    @{File="vercel.json"; Platform="Vercel"; Type="Frontend"},
    @{File="netlify.toml"; Platform="Netlify"; Type="Frontend"}
)

foreach ($config in $deploymentConfigs) {
    if (Test-Path $config.File) {
        Write-Host "✓ $($config.Platform) ($($config.Type))" -ForegroundColor Green
        Write-Host "  Config file: $($config.File)" -ForegroundColor Gray
    } else {
        Write-Host "✗ $($config.Platform) config not found" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Pre-Deployment Checklist:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$checklist = @(
    "MongoDB Atlas cluster created and connection string obtained",
    "Backend deployed to Render/Railway/Heroku",
    "Backend environment variables configured on hosting platform",
    "Backend health endpoint accessible (/health)",
    "Frontend environment variable VITE_API_URL set during build",
    "Frontend deployed to Vercel/Netlify",
    "CORS configured with production frontend URL",
    "Database connection tested in production",
    "Error tracking configured (Sentry - optional)"
)

foreach ($item in $checklist) {
    Write-Host "  ☐ $item" -ForegroundColor White
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Backend Deployment:" -ForegroundColor Cyan
Write-Host "   - Choose platform: Render, Railway, or Heroku" -ForegroundColor White
Write-Host "   - Connect GitHub repository" -ForegroundColor White
Write-Host "   - Set environment variables" -ForegroundColor White
Write-Host "   - Deploy and test /health endpoint" -ForegroundColor White
Write-Host ""
Write-Host "2. Frontend Deployment:" -ForegroundColor Cyan
Write-Host "   - Choose platform: Vercel or Netlify" -ForegroundColor White
Write-Host "   - Connect GitHub repository" -ForegroundColor White
Write-Host "   - Set VITE_API_URL environment variable" -ForegroundColor White
Write-Host "   - Deploy and test connection" -ForegroundColor White
Write-Host ""
Write-Host "3. Final Steps:" -ForegroundColor Cyan
Write-Host "   - Update backend FRONTEND_URL with deployed frontend URL" -ForegroundColor White
Write-Host "   - Test full stack connection" -ForegroundColor White
Write-Host "   - Monitor logs and errors" -ForegroundColor White
Write-Host ""

Write-Host "For detailed instructions, see DEPLOYMENT.md" -ForegroundColor Yellow
Write-Host ""
