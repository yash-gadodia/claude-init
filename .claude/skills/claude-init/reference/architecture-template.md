# ARCHITECTURE.md Template

Detail for Step 1.75 of `/claude-init`. Use this structure when generating ARCHITECTURE.md.

```markdown
# [Project Name] — Architecture

## Overview
<What this system does, who uses it, in 2-3 sentences>

## System Map
<ASCII diagram or structured list showing major modules/services and how they connect>

## Directory Structure
<Top-level directories with one-line descriptions of responsibility>
<Only include directories that matter — skip node_modules, .git, etc.>

## Data Flow
<How a typical request/action moves through the system>
<From entry point (HTTP request, CLI command, event) to response/output>

## Key Design Decisions
<Why the stack was chosen — inferred from package files, framework, and patterns>
<Major architectural patterns in use (MVC, hexagonal, microservices, monolith, etc.)>
<Any non-obvious choices visible in the code (why X over Y)>

## Module Boundaries
<Which modules own what responsibility>
<How modules communicate (imports, events, APIs, shared DB, message queue)>

## External Dependencies
<Third-party services, APIs, databases the system talks to>
<How they're configured (env vars, config files)>

## Entry Points
<Main entry points into the codebase — where to start reading>
<CLI: main.ts/app.py, Web: route definitions, Library: public API surface>
```
