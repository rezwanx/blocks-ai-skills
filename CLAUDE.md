# Blocks AI Skills — Claude Instructions

## On Session Start

At the beginning of every session, follow these steps in order:

---

### Step 1 — Check Cloud Portal Prerequisites

Before anything else, inform the user:

> **Important:** The following must be completed manually in the SELISE Blocks Cloud Portal (https://cloud.seliseblocks.com) before this system can work. Claude cannot do these for you.
>
> - [ ] **Project Created** — Cloud Portal → Projects → Create Project
> - [ ] **Environment Created** — Cloud Portal → Projects → [Project] → Environments
> - [ ] **User Added with `cloudadmin` role** — Cloud Portal → Projects → [Project] → People
> - [ ] **Repository Attached** — Cloud Portal → Projects → [Project] → Repositories
>
> If any of these are not done, API calls will fail. See `skills/core/prerequisites.md` for detailed guidance and error messages.

Ask the user: **"Have all four cloud portal steps been completed?"**

- If **No** → stop and direct them to `skills/core/prerequisites.md`. Do not proceed.
- If **Yes** → continue to Step 2.

---

### Step 1b — Choose Frontend Stack

Ask the user: **"Which frontend stack would you like to use — React, Blazor (MudBlazor), or Blazor (Tailwind CSS)?"**

| Choice | Variable value | Stack |
|--------|---------------|-------|
| React | `FRONTEND_STACK=react` | React 19 + TypeScript + Vite + Tailwind + shadcn/ui |
| Blazor (MudBlazor) | `FRONTEND_STACK=blazor` | .NET 10 Blazor WASM + MudBlazor |
| Blazor (Tailwind) | `FRONTEND_STACK=blazor-tailwind` | .NET 10 Blazor WASM + Tailwind CSS (no component library) |

Store this choice in `.env` as `FRONTEND_STACK`. This determines which frontend skill files are loaded for the rest of the session.

---

### Step 2 — Check Environment Variables

Only **5 values** are required from the user. Everything else is auto-set or conditional.

> All five must come from the same SELISE Blocks project:
> `API_BASE_URL`, `X_BLOCKS_KEY`, and `PROJECT_SLUG` from Cloud Portal → Project settings.
> `USERNAME` and `PASSWORD` from a user added to that project with the `cloudadmin` role.

Ask for only these if missing or empty:

| Variable | Where to find it |
|----------|-----------------|
| `API_BASE_URL` | Cloud Portal → Project settings (API endpoint) |
| `X_BLOCKS_KEY` | Cloud Portal → Project settings |
| `PROJECT_SLUG` | Cloud Portal → Project settings |
| `USERNAME` | Cloud Portal → People (must have `cloudadmin` role) |
| `PASSWORD` | Same account as USERNAME |

**Auto-set without asking:**

| Variable | Value | Reason |
|----------|-------|--------|
| `BLOCKS_OIDC_REDIRECT_URI` | `http://localhost:5173/auth/callback` | Standard local dev default |
| `PRIMARY_COLOR` | `#15969B` | Default theme — user can change later |
| `SECONDARY_COLOR` | `#5194B8` | Default theme — user can change later |
| `GENERATE_SOURCEMAP` | `false` | Always false for production builds |

**Conditional — ask only when a specific flow needs it:**

| Variable | When to ask |
|----------|------------|
| `BLOCKS_OIDC_CLIENT_ID` | Only when implementing a login/auth flow that requires it |
| `CAPTCHA_SITE_KEY` | Only if captcha is enabled (confirmed by user or detected during login) |
| `CAPTCHA_TYPE` | Same — `reCaptcha` or `hCaptcha` |

Write the `.env` with all known values immediately. Include `FRONTEND_STACK` from Step 1b. Leave conditional values blank until needed:

```
# Frontend stack selection — "react" or "blazor"
FRONTEND_STACK=<value from Step 1b>

# Environment variables
API_BASE_URL=<value>
X_BLOCKS_KEY=<value>
PROJECT_SLUG=<value>

CAPTCHA_SITE_KEY=
CAPTCHA_TYPE=

BLOCKS_OIDC_CLIENT_ID=
BLOCKS_OIDC_REDIRECT_URI=http://localhost:5173/auth/callback

# Build configuration
GENERATE_SOURCEMAP=false

# Theme Colors - Can be in hex or hsl format (e.g., #1B9A8B or hsl(174, 69%, 41%))
PRIMARY_COLOR=#15969B
SECONDARY_COLOR=#5194B8

# CLI/Claude credentials — for direct API operations only
# Frontend gets these from the login form, NOT from here
USERNAME=<value>
PASSWORD=<value>

# Populated at runtime after authentication
ACCESS_TOKEN=
REFRESH_TOKEN=
```

---

### Step 3 — Authenticate

Run the get-token action (`skills/identity-access/actions/get-token.md`) to obtain `ACCESS_TOKEN` and `REFRESH_TOKEN`.

**If get-token fails, diagnose using this table:**

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `200` ✅ | Success | Store tokens and proceed to Step 4 |
| `400` | Malformed request | Check `X_BLOCKS_KEY` |
| `401` | Wrong `USERNAME` or `PASSWORD` | Re-enter credentials — check the account in Cloud Portal → People |
| `403` | Account missing `cloudadmin` role | Ask admin to assign `cloudadmin` role in Cloud Portal → People |
| `404` | Environment not created or project not active | Verify the project and environment exist in the Cloud Portal |

Do **not** proceed with any task until get-token returns `200`.

---

### Step 4 — Load Project Context

Check if `PROJECT.md` exists in the project root.

- If it **exists** → read it and summarise loaded context: _"I can see this project uses [login methods], has roles: [roles], and [N] schemas defined."_ Skip any pre-flight questions already answered in the file.
- If it **does not exist** → note that it will be created after the first feature is built.

---

### Step 5 — Confirm Ready

Once authenticated and context loaded, confirm to the user:

> **Session ready.** Environment configured and authenticated successfully.
> You can now ask me to build features, call APIs, or generate frontend code.

---

## Skill File Paths

Skill files may be located in either `skills/` (if this repo is the project root) or `.claude/skills/` (if installed into another project via `install.sh`).

**Resolution order:** When this document references `skills/...`, check `.claude/skills/` first, then fall back to `skills/`. Inside SKILL.md files, all paths use `../core/` to reach core files — this works regardless of whether skills are in `skills/` or `.claude/skills/`.

---

## How to Use These Skills

**Skills are internal routing knowledge — never present them as a menu or list of options.**

When the user describes what they want to build, figure out what to do by reading the relevant skill files silently. Never enumerate available features, domains, or actions to the user. Never say "here's what I can build" — just build it.

---

### On Every User Request

When the user asks for something, follow this lookup chain — reading files only as needed:

**1. Read `skills/core/decision.md`**
Determines which domain the request belongs to and whether a flow exists for it. Read this file first on every new request.

**2. Read the matched flow or action**
Read only the specific flow file (e.g. `skills/identity-access/flows/login-flow.md`) or action file needed. Do not read the entire domain — read only what the request requires.

**3. Read supporting files only if the matched skill references them**
- `skills/core/context.md` — only when reading or updating PROJECT.md
- `skills/core/clarification.md` — only when unsure whether to ask or proceed
- `skills/core/runtime.md` — only when executing API calls
- `skills/core/conventions.md` — only when generating files or naming things
- `skills/core/frontend-{FRONTEND_STACK}.md` — only when generating frontend code (resolve `{FRONTEND_STACK}` from `.env`)
- `skills/core/security.md` — only when generating any code (quick checklist)
- `skills/core/app-scaffold-{FRONTEND_STACK}.md` — only when setting up a new project from scratch
- `skills/core/app-layout-{FRONTEND_STACK}.md` — only when building the app shell or layout
- `skills/{domain}/contracts.md` — only when constructing request/response types
- `skills/{domain}/frontend-{FRONTEND_STACK}.md` — only when generating domain-specific frontend code

> **Stack file resolution:** Replace `{FRONTEND_STACK}` with the value of `FRONTEND_STACK` from `.env` (either `react` or `blazor`). For example, if `FRONTEND_STACK=blazor`, read `skills/core/frontend-blazor.md` instead of `skills/core/frontend-react.md`.

**4. Read `skills/{domain}/SKILL.md` only if no flow matched**
The intent map in SKILL.md maps requests to individual actions. Use it as a fallback when no flow covers the request.

---

### What NOT to Do

- **Never read all skill files at session start** — load on demand only
- **Never list available skills, domains, or features to the user** — they are your internal knowledge
- **Never say "I have the following skills" or "here's what I can do"** — just respond to the request
- **Never ask "which skill do you want to use?"** — figure it out from the request and route internally
