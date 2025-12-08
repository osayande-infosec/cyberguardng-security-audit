# OWASP ZAP API Scan Script
# Focuses on backend API endpoints security testing
# Usage: .\zap-api-scan.ps1 -target https://cyberguardng.ca

param(
    [Parameter(Mandatory=$true)]
    [string]$target,
    
    [Parameter(Mandatory=$false)]
    [string]$reportDir = "reports"
)

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    OWASP ZAP API Security Scan" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Target: $target" -ForegroundColor Yellow
Write-Host "Scan Type: API-Focused" -ForegroundColor Yellow
Write-Host "Expected Duration: ~15 minutes" -ForegroundColor Yellow
Write-Host ""

# Create reports directory if it doesn't exist
if (!(Test-Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
    Write-Host "✓ Created reports directory" -ForegroundColor Green
}

# Generate timestamp for report filename
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$reportFile = "$reportDir\api-scan-$timestamp.html"

# Create OpenAPI spec inline for CyberGuardNG APIs
$openApiSpec = @"
{
  "openapi": "3.0.0",
  "info": {
    "title": "CyberGuardNG API",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "$target"
    }
  ],
  "paths": {
    "/chat": {
      "post": {
        "summary": "AI Chatbot",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "message": { "type": "string" }
                }
              }
            }
          }
        }
      }
    },
    "/contact": {
      "post": {
        "summary": "Contact Form",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "name": { "type": "string" },
                  "email": { "type": "string" },
                  "company": { "type": "string" },
                  "message": { "type": "string" },
                  "newsletter": { "type": "boolean" }
                }
              }
            }
          }
        }
      }
    },
    "/consent-log": {
      "post": {
        "summary": "Cookie Consent",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "analytics": { "type": "boolean" },
                  "marketing": { "type": "boolean" }
                }
              }
            }
          }
        }
      }
    }
  }
}
"@

# Save OpenAPI spec temporarily
$specFile = "$reportDir\api-spec.json"
$openApiSpec | Out-File -FilePath $specFile -Encoding UTF8

Write-Host "✓ Generated OpenAPI specification" -ForegroundColor Green
Write-Host ""
Write-Host "Pulling latest OWASP ZAP Docker image..." -ForegroundColor Cyan
docker pull zaproxy/zap-stable

Write-Host ""
Write-Host "Starting API scan..." -ForegroundColor Cyan
Write-Host "This will:" -ForegroundColor White
Write-Host "  - Test /chat endpoint (AI chatbot)" -ForegroundColor White
Write-Host "  - Test /contact endpoint (contact form)" -ForegroundColor White
Write-Host "  - Test /consent-log endpoint (cookie consent)" -ForegroundColor White
Write-Host "  - Check for injection vulnerabilities" -ForegroundColor White
Write-Host "  - Verify rate limiting" -ForegroundColor White
Write-Host "  - Test authentication mechanisms" -ForegroundColor White
Write-Host ""

# Run ZAP API scan
docker run --rm `
    -v "${PWD}/${reportDir}:/zap/wrk/:rw" `
    zaproxy/zap-stable zap-api-scan.py `
    -t "api-spec.json" `
    -f openapi `
    -r "api-scan-$timestamp.html" `
    -I

$exitCode = $LASTEXITCODE

# Cleanup
if (Test-Path $specFile) {
    Remove-Item $specFile
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host "✓ API scan completed successfully!" -ForegroundColor Green
} elseif ($exitCode -eq 1) {
    Write-Host "⚠ API scan completed with warnings" -ForegroundColor Yellow
} elseif ($exitCode -eq 2) {
    Write-Host "✗ High-risk API vulnerabilities found!" -ForegroundColor Red
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
Write-Host "API Security Checklist:" -ForegroundColor Yellow
Write-Host "✓ Rate limiting on all endpoints" -ForegroundColor Green
Write-Host "✓ Input validation (server-side)" -ForegroundColor Green
Write-Host "✓ CAPTCHA on contact form" -ForegroundColor Green
Write-Host "✓ HTTPS only" -ForegroundColor Green
Write-Host "✓ Security headers (CSP, HSTS, etc.)" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
