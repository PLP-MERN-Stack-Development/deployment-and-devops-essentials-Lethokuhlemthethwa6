# Test Connection Between Frontend and Backend
# This script validates the connection and configuration

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Connection Test" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$allTestsPassed = $true

# Test 1: Backend Health Endpoint
Write-Host "Test 1: Backend Health Check" -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ Backend is responding" -ForegroundColor Green
    Write-Host "  Status: $($health.status)" -ForegroundColor White
    Write-Host "  Database: $($health.database)" -ForegroundColor White
    Write-Host "  Environment: $($health.environment)" -ForegroundColor White
    Write-Host "  Uptime: $([math]::Round($health.uptime, 2)) seconds" -ForegroundColor White
} catch {
    Write-Host "✗ Backend health check failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Is the backend server running? Start it with: cd backend; npm run dev" -ForegroundColor Yellow
    $allTestsPassed = $false
}

Write-Host ""

# Test 2: Backend API Endpoint
Write-Host "Test 2: Backend API Endpoint" -ForegroundColor Yellow
try {
    $api = Invoke-RestMethod -Uri "http://localhost:5000/api" -Method Get -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ API endpoint is responding" -ForegroundColor Green
    Write-Host "  Message: $($api.message)" -ForegroundColor White
    Write-Host "  Version: $($api.version)" -ForegroundColor White
} catch {
    Write-Host "✗ API endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    $allTestsPassed = $false
}

Write-Host ""

# Test 3: Backend Status Endpoint
Write-Host "Test 3: Backend Status Endpoint" -ForegroundColor Yellow
try {
    $status = Invoke-RestMethod -Uri "http://localhost:5000/api/status" -Method Get -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ Status endpoint is responding" -ForegroundColor Green
    Write-Host "  Status: $($status.status)" -ForegroundColor White
    Write-Host "  Database: $($status.database)" -ForegroundColor White
    
    if ($status.database -eq "connected") {
        Write-Host "  ✓ MongoDB connection successful" -ForegroundColor Green
    } else {
        Write-Host "  ✗ MongoDB not connected" -ForegroundColor Red
        Write-Host "    Check MONGO_URI in backend\.env" -ForegroundColor Yellow
        $allTestsPassed = $false
    }
} catch {
    Write-Host "✗ Status endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    $allTestsPassed = $false
}

Write-Host ""

# Test 4: CORS Configuration
Write-Host "Test 4: CORS Configuration" -ForegroundColor Yellow
try {
    $headers = @{
        "Origin" = "http://localhost:3000"
    }
    $response = Invoke-WebRequest -Uri "http://localhost:5000/api" -Method Get -Headers $headers -TimeoutSec 5 -ErrorAction Stop
    
    $corsHeader = $response.Headers['Access-Control-Allow-Origin']
    if ($corsHeader) {
        Write-Host "✓ CORS is configured" -ForegroundColor Green
        Write-Host "  Allowed Origin: $corsHeader" -ForegroundColor White
    } else {
        Write-Host "⚠ CORS header not found (might still work)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "✗ CORS test failed: $($_.Exception.Message)" -ForegroundColor Red
    $allTestsPassed = $false
}

Write-Host ""

# Test 5: Frontend Configuration
Write-Host "Test 5: Frontend Configuration" -ForegroundColor Yellow
if (Test-Path "frontend\.env") {
    $envContent = Get-Content "frontend\.env" -Raw
    if ($envContent -match 'VITE_API_URL\s*=\s*(.+)') {
        $apiUrl = $matches[1].Trim()
        Write-Host "✓ Frontend API URL configured" -ForegroundColor Green
        Write-Host "  VITE_API_URL: $apiUrl" -ForegroundColor White
        
        if ($apiUrl -eq "http://localhost:5000") {
            Write-Host "  ✓ Correctly pointing to local backend" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ Not pointing to local backend" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ VITE_API_URL not found in frontend\.env" -ForegroundColor Red
        $allTestsPassed = $false
    }
} else {
    Write-Host "✗ frontend\.env not found" -ForegroundColor Red
    $allTestsPassed = $false
}

Write-Host ""

# Test 6: Check if frontend is running
Write-Host "Test 6: Frontend Server" -ForegroundColor Yellow
try {
    $null = Invoke-WebRequest -Uri "http://localhost:3000" -Method Get -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✓ Frontend is running and accessible" -ForegroundColor Green
} catch {
    Write-Host "✗ Frontend not accessible: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Is the frontend server running? Start it with: cd frontend; npm run dev" -ForegroundColor Yellow
    $allTestsPassed = $false
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan

if ($allTestsPassed) {
    Write-Host "All tests passed! ✓" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your application is ready:" -ForegroundColor Green
    Write-Host "  Frontend: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "  Backend:  http://localhost:5000" -ForegroundColor Cyan
} else {
    Write-Host "Some tests failed ✗" -ForegroundColor Red
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please check the errors above and:" -ForegroundColor Yellow
    Write-Host "  1. Ensure both servers are running" -ForegroundColor White
    Write-Host "  2. Check environment variables in .env files" -ForegroundColor White
    Write-Host "  3. Verify MongoDB connection" -ForegroundColor White
}

Write-Host ""
