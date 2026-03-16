---
description: Performance rules to prevent common bottlenecks
---

# Performance Rules

- No N+1 queries — use batch loading, joins, or eager loading
- Paginate all list endpoints and database queries — never fetch unbounded results
- Add database indexes for frequently queried columns (check EXPLAIN output)
- Lazy-load heavy components, images, and non-critical scripts
- Cache expensive computations and frequently-read data (with invalidation strategy)
- Use connection pooling for database connections
- Set timeouts on all external HTTP requests (default: 10s)
- Avoid synchronous I/O in request handlers
- Profile before optimizing — measure, don't guess
- Set up monitoring/alerting for p95 and p99 latency, not just averages
