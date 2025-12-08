# OWASP ZAP Full Scan Script
# Performs comprehensive active security testing (~30-60 minutes)
# Usage: .\zap-full-scan.ps1 -target https://cyberguardng.ca

param(
    [Parameter(Mandatory=$true)]
    [string]$target,
    
    [Parameter(Mandatory=$false)]
    [string]$reportDir = "reports"
)

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    OWASP ZAP Full Security Scan" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠ WARNING: This is an ACTIVE penetration test!" -ForegroundColor Red
Write-Host "Only run this against systems you own or have explicit permission to test." -ForegroundColor Red
Write-Host ""
Write-Host "Target: $target" -ForegroundColor Yellow
Write-Host "Scan Type: Full (Active)" -ForegroundColor Yellow
Write-Host "Expected Duration: ~30-60 minutes" -ForegroundColor Yellow
Write-Host ""

# Confirmation prompt
$confirmation = Read-Host "Do you have authorization to test this target? (yes/no)"
if ($confirmation -ne "yes") {
    Write-Host "Scan cancelled." -ForegroundColor Red
    exit 1
}

# Create reports directory if it doesn't exist
if (!(Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
    Write-Host "✓ Created reports directory" -ForegroundColor Green
}

# Generate timestamp for report filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$reportFile = "$reportDir\full-scan-$timestamp.html"

Write-Host "Pulling latest OWASP ZAP Docker image..." -ForegroundColor Cyan
docker pull zaproxy/zap-stable

Write-Host ""
Write-Host "Starting full scan..." -ForegroundColor Cyan
Write-Host "This will:" -ForegroundColor White
Write-Host "  - Spider the entire site" -ForegroundColor White
Write-Host "  - Perform active vulnerability scanning" -ForegroundColor White
Write-Host "  - Test for all OWASP Top 10 vulnerabilities" -ForegroundColor White
Write-Host "  - Attempt SQL injection, XSS, CSRF, etc." -ForegroundColor White
Write-Host "  - Generate comprehensive HTML report" -ForegroundColor White
Write-Host ""
Write-Host "Please be patient - this may take 30-60 minutes..." -ForegroundColor Yellow
Write-Host ""

# Run ZAP full scan
docker run --rm `
    -v "${PWD}/${reportDir}:/zap/wrk/:rw" `
    zaproxy/zap-stable zap-full-scan.py `
    -t $target `
    -r "full-scan-$timestamp.html" `
    -I

$exitCode = $LASTEXITCODE

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host "✓ Scan completed successfully!" -ForegroundColor Green
    Write-Host "No high-risk vulnerabilities found." -ForegroundColor Green
} elseif ($exitCode -eq 1) {
    Write-Host "⚠ Scan completed with warnings" -ForegroundColor Yellow
    Write-Host "Medium-risk vulnerabilities detected." -ForegroundColor Yellow
} elseif ($exitCode -eq 2) {
    Write-Host "✗ High-risk vulnerabilities found!" -ForegroundColor Red
    Write-Host "Immediate remediation recommended." -ForegroundColor Red
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
Write-Host "1. Review the comprehensive HTML report" -ForegroundColor White
Write-Host "2. Categorize findings by OWASP Top 10 category" -ForegroundColor White
Write-Host "3. Document each finding in findings/ directory" -ForegroundColor White
Write-Host "4. Prioritize remediation by risk level" -ForegroundColor White
Write-Host "5. Re-scan after fixes to verify remediation" -ForegroundColor White
Write-Host "==================================================" -ForegroundColor Cyan
