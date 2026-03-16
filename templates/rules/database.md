---
description: Database and migration rules
paths:
  - "prisma/**"
  - "drizzle/**"
  - "migrations/**"
  - "src/db/**"
  - "src/models/**"
  - "db/**"
---

# Database Rules

- Always create a migration for schema changes — never modify the database directly
- Never edit an existing migration that has been applied — create a new one
- Every migration must be reversible (include a rollback/down step)
- Add indexes for columns used in WHERE, JOIN, and ORDER BY clauses
- Add indexes for all foreign key columns
- Use transactions for operations that modify multiple tables
- Never use `SELECT *` — specify columns explicitly
- Watch for N+1 queries — use eager loading or joins where appropriate
- Set appropriate column constraints (NOT NULL, UNIQUE, CHECK) at the database level
- Test migrations against a copy of production data, not just empty databases
- Back up the database before running migrations in production
