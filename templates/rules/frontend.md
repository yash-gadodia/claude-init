---
description: Frontend component and UI rules
paths:
  - "src/components/**"
  - "src/app/**"
  - "app/**"
  - "pages/**"
  - "src/pages/**"
  - "src/views/**"
---

# Frontend Rules

- Components should do one thing. If a component has business logic AND rendering, split them.
- No inline styles — use the project's styling solution (Tailwind, CSS modules, styled-components)
- All interactive elements need keyboard support and ARIA attributes
- Images need alt text. Decorative images get `alt=""`
- No business logic in components — extract to hooks, utils, or server-side
- Forms need client-side validation AND server-side validation
- Handle loading, error, and empty states for every data-fetching component
- Memoize expensive computations, don't memoize everything
- No `console.log` in committed code — use the project's logging solution
- Test user-visible behavior (click, type, see result) not implementation details
