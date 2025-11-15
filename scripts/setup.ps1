# Deployment Setup and Testing Script
# This script helps validate environment configuration and test connections

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  MERN Stack Deployment Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
$prerequisites = @{
    "node" = "Node.js"
    "npm" = "npm"
    "git" = "Git"
}

$allPrereqsMet = $true
foreach ($cmd in $prerequisites.Keys) {
    if (Test-Command $cmd) {
        $version = & $cmd --version 2>&1
        Write-Host "✓ $($prerequisites[$cmd]): $version" -ForegroundColor Green
    } else {
        Write-Host "✗ $($prerequisites[$cmd]) not found" -ForegroundColor Red
        $allPrereqsMet = $false
    }
}

if (-not $allPrereqsMet) {
    Write-Host "`nPlease install missing prerequisites before continuing." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check environment files
Write-Host "Checking environment files..." -ForegroundColor Yellow

$backendEnv = Test-Path "backend\.env"
$frontendEnv = Test-Path "frontend\.env"

if ($backendEnv) {
    Write-Host "✓ backend\.env exists" -ForegroundColor Green
} else {
    Write-Host "✗ backend\.env missing" -ForegroundColor Red
    Write-Host "  Creating from backend\.env.example..." -ForegroundColor Yellow
    if (Test-Path "backend\.env.example") {
        Copy-Item "backend\.env.example" "backend\.env"
        Write-Host "  ✓ Created backend\.env - Please configure it" -ForegroundColor Green
    }
}

if ($frontendEnv) {
    Write-Host "✓ frontend\.env exists" -ForegroundColor Green
} else {
    Write-Host "✗ frontend\.env missing" -ForegroundColor Red
    Write-Host "  Creating from frontend\.env.example..." -ForegroundColor Yellow
    if (Test-Path "frontend\.env.example") {
        Copy-Item "frontend\.env.example" "frontend\.env"
        Write-Host "  ✓ Created frontend\.env - Please configure it" -ForegroundColor Green
    }
}

Write-Host ""

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow

Write-Host "Backend dependencies..." -ForegroundColor Cyan
Set-Location backend
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Backend dependency installation failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Write-Host "✓ Backend dependencies installed" -ForegroundColor Green
Set-Location ..

Write-Host "Frontend dependencies..." -ForegroundColor Cyan
Set-Location frontend
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Frontend dependency installation failed" -ForegroundColor Red
    Set-Location ..
    exit 1
}
Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
Set-Location ..

Write-Host ""

# Display environment configuration
Write-Host "Current Configuration:" -ForegroundColor Yellow
Write-Host "----------------------" -ForegroundColor Yellow

if (Test-Path "backend\.env") {
    Write-Host "Backend (.env):" -ForegroundColor Cyan
    $backendContent = Get-Content "backend\.env" | Where-Object { $_ -notmatch '^\s*#' -and $_ -match '\S' }
    foreach ($line in $backendContent) {
        if ($line -match '(.*?)=(.*)') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            # Mask sensitive values
            if ($key -match '(URI|DSN|PASSWORD|SECRET|KEY)') {
                $value = "***hidden***"
            }
            Write-Host "  $key = $value" -ForegroundColor White
        }
    }
}

Write-Host ""

if (Test-Path "frontend\.env") {
    Write-Host "Frontend (.env):" -ForegroundColor Cyan
    $frontendContent = Get-Content "frontend\.env" | Where-Object { $_ -notmatch '^\s*#' -and $_ -match '\S' }
    foreach ($line in $frontendContent) {
        if ($line -match '(.*?)=(.*)') {
            Write-Host "  $($matches[1].Trim()) = $($matches[2].Trim())" -ForegroundColor White
        }
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review and update environment variables in .env files" -ForegroundColor White
Write-Host "2. Start MongoDB (if using local database)" -ForegroundColor White
Write-Host "3. Run: .\scripts\test-connection.ps1 to test the connection" -ForegroundColor White
Write-Host "4. Run: .\scripts\start-dev.ps1 to start both servers" -ForegroundColor White
Write-Host ""
