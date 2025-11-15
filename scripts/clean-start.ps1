# Clean Start Script - Stops all servers and starts fresh

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Clean Restart MERN Stack" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Stop all Node.js processes
Write-Host "Stopping all Node.js processes..." -ForegroundColor Yellow
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "✓ All Node processes stopped" -ForegroundColor Green
Write-Host ""

# Start Backend
Write-Host "Starting Backend Server..." -ForegroundColor Yellow
$backendScript = @"
Set-Location '$PWD\backend'
Write-Host ''
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host '  Backend Server' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Starting on http://localhost:5000' -ForegroundColor Green
Write-Host ''
node index.js
"@

Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript

Write-Host "Waiting for backend to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 4

# Test backend
try {
    $health = Invoke-RestMethod "http://localhost:5000/health" -ErrorAction Stop
    Write-Host "✓ Backend is running" -ForegroundColor Green
    Write-Host "  Status: $($health.status)" -ForegroundColor Cyan
    Write-Host "  Database: $($health.database)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ Backend failed to start" -ForegroundColor Red
    Write-Host "  Check the backend terminal for errors" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Start Frontend
Write-Host "Starting Frontend Server..." -ForegroundColor Yellow
$frontendScript = @"
Set-Location '$PWD\frontend'
Write-Host ''
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host '  Frontend Server' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Starting Vite development server...' -ForegroundColor Green
Write-Host ''
npm run dev
"@

Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript

Write-Host "Waiting for frontend to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Servers Started!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend:  http://localhost:5000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:3000 (or next available port)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Endpoints:" -ForegroundColor Yellow
Write-Host "  Health:  http://localhost:5000/health" -ForegroundColor White
Write-Host "  API:     http://localhost:5000/api" -ForegroundColor White
Write-Host "  Status:  http://localhost:5000/api/status" -ForegroundColor White
Write-Host ""
Write-Host "Check the server windows for any errors" -ForegroundColor Yellow
Write-Host "Press any key to test the connection..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Test connection
Write-Host ""
Write-Host "Testing full stack connection..." -ForegroundColor Yellow
Write-Host ""

try {
    $health = Invoke-RestMethod "http://localhost:5000/health"
    Write-Host "✓ Backend Health: $($health.status)" -ForegroundColor Green
    
    $status = Invoke-RestMethod "http://localhost:5000/api/status"
    Write-Host "✓ API Status: $($status.status)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "  All Systems Operational! ✓" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Open your browser and visit:" -ForegroundColor Yellow
    Write-Host "http://localhost:3000" -ForegroundColor Cyan
    Write-Host ""
} catch {
    Write-Host "✗ Connection test failed" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
