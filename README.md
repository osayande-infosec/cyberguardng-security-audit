# CyberGuardNG Security Audit - OWASP Top 10 Assessment

## 🎯 Project Overview

This repository documents a comprehensive security assessment of **cyberguardng.ca**, a production cybersecurity consulting website. The audit systematically tests for all OWASP Top 10 vulnerabilities using industry-standard tools and methodologies.

**Target Application:** https://cyberguardng.ca
**Technology Stack:** React 19.2.1, Cloudflare Pages, Cloudflare Functions
**Assessment Date:** December 2025
**Auditor:** CyberGuardNG Security Team

---

## 🔎 Methodology

### Tools Used
- **OWASP ZAP** (Zed Attack Proxy) - Automated vulnerability scanner
- **npm audit** - Dependency vulnerability detection
- **Snyk** - Open source security platform
- **Lighthouse** - Performance and security auditing
- **Manual Testing** - Code review and penetration testing

### Scan Types
1. **Baseline Scan** - Quick passive reconnaissance (~5 minutes)
2. **Full Scan** - Active vulnerability testing (~30-60 minutes)
3. **API Scan** - Backend endpoint security testing
4. **Authentication Scan** - Session and auth mechanism testing

---

## 📊 OWASP Top 10 (2021) Coverage

| Risk | Category | Status | Severity | Findings |
|------|----------|--------|----------|----------|
| A01 | Broken Access Control | ✅ Tested | None | [Details](findings/A01-broken-access-control.md) |
| A02 | Cryptographic Failures | ✅ Tested | None | [Details](findings/A02-cryptographic-failures.md) |
| A03 | Injection | ✅ Tested | None | [Details](findings/A03-injection.md) |
| A04 | Insecure Design | ✅ Tested | None | [Details](findings/A04-insecure-design.md) |
| A05 | Security Misconfiguration | ✅ Tested | Low | [Details](findings/A05-security-misconfiguration.md) |
| A06 | Vulnerable Components | ✅ Tested | None | [Details](findings/A06-vulnerable-components.md) |
| A07 | Authentication Failures | ✅ Tested | None | [Details](findings/A07-authentication-failures.md) |
| A08 | Software/Data Integrity | ✅ Tested | None | [Details](findings/A08-software-data-integrity.md) |
| A09 | Logging & Monitoring | ✅ Tested | Medium | [Details](findings/A09-logging-monitoring.md) |
| A10 | SSRF | ✅ Tested | None | [Details](findings/A10-ssrf.md) |

**Overall Risk Rating:** 🟢 **LOW**

---

## 🚀 Quick Start

### Prerequisites
\\powershell
# Install Docker Desktop for Windows
# Download from: https://www.docker.com/products/docker-desktop/

# Verify installation
docker --version
\
### Running Scans

**1. Baseline Scan (Recommended First)**
\\powershell
.\zap-baseline-scan.ps1 -target https://cyberguardng.ca
\
**2. Full Penetration Test**
\\powershell
.\zap-full-scan.ps1 -target https://cyberguardng.ca
\
**3. API-Specific Scan**
\\powershell
.\zap-api-scan.ps1 -target https://cyberguardng.ca
\
### Reports Location
All scan reports are saved in eports/\ directory:
- \aseline-YYYY-MM-DD.html\ - Quick scan results
- \ull-scan-YYYY-MM-DD.html\ - Comprehensive findings
- \pi-scan-YYYY-MM-DD.html\ - Backend security assessment

---

## 🔒 Security Posture Summary

### ✅ Strengths
- **HTTPS Everywhere**: Strict-Transport-Security with 1-year max-age
- **Content Security Policy**: Comprehensive CSP headers blocking XSS
- **Rate Limiting**: KV-backed throttling on all endpoints (10-20 req/min)
- **Input Validation**: Server-side validation on all forms
- **CAPTCHA**: Cloudflare Turnstile on contact form
- **Dependency Management**: 0 known vulnerabilities (npm audit clean)
- **Modern Framework**: React 19.2.1 (patched against 2025 CVEs)
- **Secure Headers**: X-Frame-Options, X-Content-Type-Options, Referrer-Policy

### ⚠️ Areas for Improvement
- **Logging**: Limited structured logging for security events
- **Monitoring**: No real-time alerting for anomalous behavior
- **Session Management**: No user sessions implemented yet
- **API Documentation**: OpenAPI spec not published

### 🎯 Recommendations
1. Implement centralized logging (Cloudflare Logs or Datadog)
2. Add security event monitoring with alerting
3. Document API endpoints with OpenAPI 3.0 spec
4. Consider adding CSP reporting endpoint
5. Implement automated security scanning in CI/CD

---

## 📈 Scan Execution Timeline

\\mermaid
graph LR
    A[Pull ZAP Docker Image] --> B[Run Baseline Scan]
    B --> C[Review Findings]
    C --> D[Run Full Scan]
    D --> E[Manual Verification]
    E --> F[Document Results]
    F --> G[Remediation]
    G --> H[Re-scan Verification]
\
---

## 🛠️ Technical Details

### Application Architecture
- **Frontend**: React 19.2.1 SPA with Vite bundler
- **Backend**: Cloudflare Pages Functions (serverless)
- **Database**: Cloudflare D1 (SQLite)
- **CDN**: Cloudflare Pages with edge caching
- **APIs**: RESTful endpoints at \/chat\, \/contact\, \/consent-log
### Security Controls
- **Rate Limiting**: Cloudflare KV-backed sliding window
- **CAPTCHA**: Turnstile (site key: 0x4AAAAAACFV98o85pvOFYlJ)
- **CSP**: \default-src 'self'; script-src 'self' 'unsafe-inline'; connect-src 'self' https://api.openai.com https://api.web3forms.com- **HSTS**: \max-age=31536000; includeSubDomains; preload
### Attack Surface
- 3 public API endpoints (chat, contact, consent-log)
- 7 static pages (Home, Services, Resources, Contact, Blog, Case Studies, About)
- Contact form with email submission
- AI chatbot with OpenAI integration
- Cookie consent banner

---

## 📁 Findings Documentation

Each OWASP Top 10 category has a dedicated findings document.

---

## 🔄 Continuous Security

### GitHub Actions Workflow
Automated weekly security scans run every Monday at 00:00 UTC.

### Local Development Scanning
\\powershell
# Scan local dev server
.\zap-baseline-scan.ps1 -target http://localhost:5173
\
---

## 📚 References

- [OWASP Top 10 (2021)](https://owasp.org/Top10/)
- [OWASP ZAP Documentation](https://www.zaproxy.org/docs/)
- [Cloudflare Security Best Practices](https://developers.cloudflare.com/fundamentals/security/)
- [React Security Guidelines](https://react.dev/learn/security)

---

## 📧 Contact

For questions about this security audit:
- **Email**: security@cyberguardng.ca
- **GitHub**: [@osayande-infosec](https://github.com/osayande-infosec)
- **Website**: [cyberguardng.ca](https://cyberguardng.ca)

---

## 📄 License

This security assessment documentation is released under MIT License.

**Disclaimer**: This audit was performed on a live production system with proper authorization. Do not run these scans against systems you don't own or have explicit permission to test.
