# OWASP ZAP Baseline Scan Script
# Performs quick passive reconnaissance scan (~5 minutes)
# Usage: .\zap-baseline-scan.ps1 -target https://cyberguardng.ca

param(
    [Parameter(Mandatory=$true)]
    [string]$target,
    
    [Parameter(Mandatory=$false)]
    [string]$reportDir = "reports"
)

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    OWASP ZAP Baseline Security Scan" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Target: $target" -ForegroundColor Yellow
Write-Host "Scan Type: Baseline (Passive)" -ForegroundColor Yellow
Write-Host "Expected Duration: ~5 minutes" -ForegroundColor Yellow
Write-Host ""

# Create reports directory if it doesn't exist
if (!(Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
    Write-Host "✓ Created reports directory" -ForegroundColor Green
}

# Generate timestamp for report filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$reportFile = "$reportDir\baseline-$timestamp.html"

Write-Host "Pulling latest OWASP ZAP Docker image..." -ForegroundColor Cyan
docker pull zaproxy/zap-stable

Write-Host ""
Write-Host "Starting baseline scan..." -ForegroundColor Cyan
Write-Host "This will:" -ForegroundColor White
Write-Host "  - Spider the target site" -ForegroundColor White
Write-Host "  - Perform passive vulnerability detection" -ForegroundColor White
Write-Host "  - Generate HTML report" -ForegroundColor White
Write-Host ""

# Run ZAP baseline scan
docker run --rm `
    -v "${PWD}/${reportDir}:/zap/wrk/:rw" `
    zaproxy/zap-stable zap-baseline.py `
    -t $target `
    -r "baseline-$timestamp.html" `
    -I

$exitCode = $LASTEXITCODE

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host "✓ Scan completed successfully!" -ForegroundColor Green
} elseif ($exitCode -eq 1) {
    Write-Host "⚠ Scan completed with warnings" -ForegroundColor Yellow
} elseif ($exitCode -eq 2) {
    Write-Host "✗ Scan found high-risk vulnerabilities" -ForegroundColor Red
} else {
    Write-Host "✗ Scan failed with error code: $exitCode" -ForegroundColor Red
}

Write-Host ""
Write-Host "Report saved to: $reportFile" -ForegroundColor Cyan
Write-Host ""

# Open report in browser
if (Test-Path $reportFile) {
    Write-Host "Opening report in browser..." -ForegroundColor Cyan
    Start-Process $reportFile
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Review the HTML report for findings" -ForegroundColor White
Write-Host "2. Document any vulnerabilities in findings/ directory" -ForegroundColor White
Write-Host "3. Run full scan for deeper analysis: .\zap-full-scan.ps1" -ForegroundColor White
Write-Host "==================================================" -ForegroundColor Cyan
