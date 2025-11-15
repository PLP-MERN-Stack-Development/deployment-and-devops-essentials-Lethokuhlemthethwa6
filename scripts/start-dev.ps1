# Start Development Servers
# This script starts both backend and frontend servers

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Starting MERN Stack Development" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env files exist
if (-not (Test-Path "backend\.env")) {
    Write-Host "✗ backend\.env not found. Run .\scripts\setup.ps1 first" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "frontend\.env")) {
    Write-Host "✗ frontend\.env not found. Run .\scripts\setup.ps1 first" -ForegroundColor Red
    exit 1
}

# Check if node_modules exist
if (-not (Test-Path "backend\node_modules")) {
    Write-Host "✗ Backend dependencies not installed. Run .\scripts\setup.ps1 first" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "frontend\node_modules")) {
    Write-Host "✗ Frontend dependencies not installed. Run .\scripts\setup.ps1 first" -ForegroundColor Red
    exit 1
}

Write-Host "Starting Backend Server..." -ForegroundColor Yellow
Write-Host "Backend will run on: http://localhost:5000" -ForegroundColor Cyan
Write-Host ""

# Start backend in new PowerShell window
$backendScript = @"
Set-Location '$PWD\backend'
Write-Host 'Backend Server Starting...' -ForegroundColor Green
npm run dev
"@

Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript

# Wait a bit for backend to start
Write-Host "Waiting for backend to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "Starting Frontend Server..." -ForegroundColor Yellow
Write-Host "Frontend will run on: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""

# Start frontend in new PowerShell window
$frontendScript = @"
Set-Location '$PWD\frontend'
Write-Host 'Frontend Server Starting...' -ForegroundColor Green
npm run dev
"@

Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Both servers are starting!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend:  http://localhost:5000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend Health: http://localhost:5000/health" -ForegroundColor Yellow
Write-Host "Backend API:    http://localhost:5000/api" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to test the connection..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Test connection
Write-Host ""
Write-Host "Testing connection..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -ErrorAction Stop
    Write-Host "✓ Backend Health Check: OK" -ForegroundColor Green
    Write-Host "  Status: $($healthResponse.status)" -ForegroundColor White
    Write-Host "  Database: $($healthResponse.database)" -ForegroundColor White
} catch {
    Write-Host "✗ Backend not responding yet. It may still be starting..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Servers are running in separate windows." -ForegroundColor Green
Write-Host "Close those windows or press Ctrl+C to stop the servers." -ForegroundColor Yellow
