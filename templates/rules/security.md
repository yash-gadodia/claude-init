---
description: Security rules applied to all code
---

# Security Rules

- Never commit secrets, API keys, or credentials. Use environment variables.
- Validate and sanitize all user input at system boundaries.
- Use parameterized queries — never string-concatenate SQL.
- Escape output to prevent XSS in web contexts.
- Check authentication and authorization on every protected route.
- Never log PII (emails, passwords, tokens) — redact or omit.
- Use HTTPS for all external requests.
- Set appropriate CORS headers — never use `*` in production.
- Never disable SSL certificate verification.
- Dependencies: check for known vulnerabilities before adding new ones.
