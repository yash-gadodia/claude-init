---
description: API conventions for route handlers and endpoints
paths:
  - "src/api/**"
  - "app/api/**"
  - "routes/**"
  - "src/routes/**"
  - "src/server/**"
---

# API Rules

- All endpoints return a consistent response shape (e.g., `{ data, error }` or the framework's convention)
- Use proper HTTP status codes: 200 success, 201 created, 400 bad input, 401 unauthenticated, 403 forbidden, 404 not found, 500 server error
- Validate all request input at the boundary (zod, joi, class-validator, etc.) — never trust client data
- Paginate list endpoints by default — never return unbounded results
- Use meaningful error messages that help the caller fix the problem
- Log errors server-side with request context (request ID, user ID, endpoint)
- Rate limit public endpoints
- Version APIs if they're consumed externally (`/api/v1/...`)
- Document breaking changes before making them
