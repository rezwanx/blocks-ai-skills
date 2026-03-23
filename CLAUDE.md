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

### Step 2 — Check Environment Variables

Only **4 values** are required from the user. Everything else is auto-set or discovered.

> All four must come from the same SELISE Blocks project:
> `VITE_X_BLOCKS_KEY` and `VITE_BLOCKS_OIDC_CLIENT_ID` from Cloud Portal → Project settings.
> `USERNAME` and `PASSWORD` from a user added to that project with the `cloudadmin` role.

Ask for only these if missing or empty:

| Variable | Where to find it |
|----------|-----------------|
| `VITE_X_BLOCKS_KEY` | Cloud Portal → Project settings |
| `VITE_BLOCKS_OIDC_CLIENT_ID` | Cloud Portal → Project → Auth settings |
| `USERNAME` | Cloud Portal → People (must have `cloudadmin` role) |
| `PASSWORD` | Same account as USERNAME |

**Auto-set without asking:**

| Variable | Value | Reason |
|----------|-------|--------|
| `VITE_API_BASE_URL` | `https://api.seliseblocks.com` | Always the same |
| `VITE_BLOCKS_OIDC_REDIRECT_URI` | `http://localhost:5173/auth/callback` | Standard local dev default |
| `VITE_PRIMARY_COLOR` | `#15969B` | Default theme — user can change later |
| `VITE_SECONDARY_COLOR` | `#5194B8` | Default theme — user can change later |
| `GENERATE_SOURCEMAP` | `false` | Always false for production builds |

**Discovered after authentication (Step 3):**

After getting a token, attempt to discover `VITE_PROJECT_SLUG` by calling `GET $VITE_API_BASE_URL/idp/v1/User/GetInfo` with the access token. If the response contains a project identifier, extract and store it. If not, ask the user: "What is your project slug?" (Cloud Portal → Project settings).

**Conditional — ask only if needed:**

| Variable | When to ask |
|----------|------------|
| `VITE_CAPTCHA_SITE_KEY` | Only if captcha is enabled (confirmed by user or detected during login) |
| `VITE_CAPTCHA_TYPE` | Same — `reCaptcha` or `hCaptcha` |

Write the `.env` with all known values immediately. Leave captcha blank until confirmed:

```
# Vite environment variables
VITE_API_BASE_URL=https://api.seliseblocks.com
VITE_X_BLOCKS_KEY=<value>
VITE_PROJECT_SLUG=<discovered or leave blank>

VITE_CAPTCHA_SITE_KEY=
VITE_CAPTCHA_TYPE=

VITE_BLOCKS_OIDC_CLIENT_ID=<value>
VITE_BLOCKS_OIDC_REDIRECT_URI=http://localhost:5173/auth/callback

# Build configuration
GENERATE_SOURCEMAP=false

# Theme Colors - Can be in hex or hsl format (e.g., #1B9A8B or hsl(174, 69%, 41%))
VITE_PRIMARY_COLOR=#15969B
VITE_SECONDARY_COLOR=#5194B8

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
| `200` ✅ | Success | Store tokens and proceed |
| `400` | Malformed request or wrong `client_id` | Check `VITE_BLOCKS_OIDC_CLIENT_ID` and `VITE_X_BLOCKS_KEY` |
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

## Project Context

This is the **Blocks AI Skills** system — a modular AI execution framework for SELISE Blocks.

Before taking any action, read:
- `skills/core/context.md` — how to read, create, and update PROJECT.md (project memory)
- `skills/core/clarification.md` — when to ask, what to ask, and how to handle ambiguity
- `skills/core/decision.md` — domain routing and pre-flight question rules
- `skills/core/runtime.md` — execution rules and flow-first selection
- `skills/core/conventions.md` — naming, structure, and flow file standards
- `skills/core/frontend.md` — frontend code generation rules
- `skills/core/security.md` — SAST-compliant coding rules for all generated code
- `skills/core/prerequisites.md` — cloud portal setup requirements and error guidance
- `skills/core/app-scaffold.md` — new project setup: deps, http client, providers, router
- `skills/core/app-layout.md` — app shell: sidebar, header, permissions, OIDC callback

Then read the `skill.md` for the matched domain:
- `skills/identity-access/skill.md` — auth, users, roles, permissions, MFA, organizations
- `skills/communication/skill.md` — email, notifications, templates
- `skills/data-management/skill.md` — schemas, data sources, files, access policies
- `skills/localization/skill.md` — languages, translation keys, import/export
- `skills/ai-services/skill.md` — AI agents, knowledge base, models, tools, chat
- `skills/lmt/skill.md` — logs, traces, performance analytics
