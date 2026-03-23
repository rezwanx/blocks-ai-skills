# Frontend Skill

## Stack

| Layer | Technology |
|-------|-----------|
| Framework | React 19 + TypeScript |
| Build tool | Vite |
| Styling | Tailwind CSS 3.4 |
| Component primitives | Radix UI |
| Component system | shadcn/ui style |
| Icons | Lucide React |
| Forms | React Hook Form + Zod |
| Font | Nunito Sans |

---

## Reference Implementation

**Always check the reference repo before generating any frontend code:**

```
https://github.com/SELISEdigitalplatforms/blocks-construct-react
```

Use it to verify:
- Exact component names and import paths used in production
- Auth flow shape (Zustand store, HTTP interceptor, token handling)
- Module folder structure and naming conventions
- How existing patterns are composed (form layouts, table pages, modal dialogs)

When in doubt about a UI pattern, read the reference first — do not invent structure.

---

## shadcn/ui MCP

A Model Context Protocol server is available for shadcn/ui component lookups:

```
https://ui.shadcn.com/docs/mcp
```

Use it to:
- Fetch the exact installation command for any shadcn/ui component
- Look up component API (props, variants, composition patterns)
- Check which Radix UI primitive a component wraps

**When to use it:** Any time you generate code that uses a shadcn/ui component (`Button`, `Dialog`, `Table`, `Form`, `Select`, etc.) — use the MCP to confirm the correct import path and props before writing the component.

---

## Project Structure

```
src/
├── assets/           ← static images and icons
├── components/
│   ├── ui-kit/       ← base reusable components (shadcn style)
│   └── core/         ← feature-specific composite components
├── constant/         ← app-wide constants
├── hooks/            ← custom React hooks
├── i18n/             ← translations
├── layout/           ← page layout components
├── lib/              ← utilities (cn, etc.)
├── models/           ← TypeScript interfaces and types
├── modules/          ← feature modules (one folder per domain)
├── routes/           ← route definitions
├── state/            ← global state management
├── styles/           ← global CSS and theme
└── types/            ← shared TypeScript types
```

---

## Component Layers

### ui-kit/ — Base Components
Unstyled Radix UI primitives wrapped with Tailwind. Never contain business logic.

Examples: `button`, `input`, `dialog`, `table`, `card`, `badge`, `avatar`, `tabs`, `toast`, `select`, `dropdown-menu`, `form`, `skeleton`

### core/ — Feature Components
Composite components built from ui-kit. May contain domain logic.

Examples: `data-table`, `confirmation-modal`, `otp-input`, `captcha`, `app-sidebar`, `profile-menu`, `error-alert`, `loading-overlay`

**Rule:** Always build from ui-kit components. Never use raw HTML elements where a ui-kit component exists.

---

## Theming

Colors are driven by two env variables:

```
VITE_PRIMARY_COLOR=#15969B
VITE_SECONDARY_COLOR=#5194B8
```

These are resolved to HSL CSS custom properties at runtime via `src/styles/theme/`:

```css
:root {
  --primary: <hsl from VITE_PRIMARY_COLOR>;
  --secondary: <hsl from VITE_SECONDARY_COLOR>;
}
```

Use Tailwind semantic tokens in all components — never hardcode hex values:

```tsx
// ✅ correct
<Button className="bg-primary text-primary-foreground" />

// ❌ wrong
<Button className="bg-[#15969B]" />
```

Supports light / dark / system modes via `theme-provider.tsx`.

---

## Utility Function

Always use `cn()` from `src/lib/` for conditional classnames:

```tsx
import { cn } from '@/lib/utils'

<div className={cn('base-class', condition && 'conditional-class')} />
```

---

## Forms

All forms use React Hook Form + Zod:

```tsx
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

const form = useForm<z.infer<typeof schema>>({
  resolver: zodResolver(schema),
})
```

Always wrap with shadcn `<Form>`, `<FormField>`, `<FormItem>`, `<FormLabel>`, `<FormControl>`, `<FormMessage>`.

---

## Feature Module Structure

Each domain feature follows this structure inside `src/modules/`:

```
modules/
└── feature-name/
    ├── components/     ← feature-specific UI components
    ├── hooks/          ← feature-specific hooks
    ├── pages/          ← routed page components
    └── index.ts        ← public exports
```

---

## Rules

* Use TypeScript for all components — no plain `.jsx` files
* Use `shadcn/ui` patterns for all new ui-kit components
* Use Zod schemas for all form validation
* Use Tailwind semantic color tokens — never hardcode colors
* Handle loading state with `<Skeleton />` components
* Handle error state with `<ErrorAlert />` or inline error messages
* All pages must handle loading, error, and empty states
