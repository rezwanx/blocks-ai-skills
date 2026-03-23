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

Check if a `.env` file exists in the project root and all required variables are present and non-empty.

> **Important — these four values must all come from the same SELISE Blocks project:**
> `VITE_X_BLOCKS_KEY`, `VITE_PROJECT_SLUG`, `USERNAME`, and `PASSWORD`.
> `VITE_X_BLOCKS_KEY` and `VITE_PROJECT_SLUG` come from Cloud Portal → Project settings.
> `USERNAME` and `PASSWORD` are the credentials of a user added to that same project with the `cloudadmin` role.

`VITE_API_BASE_URL` is always `https://api.seliseblocks.com` — do not ask for it.

Prompt the user for each of the following if missing or empty:

| Variable | Description | Where to find it |
|----------|-------------|-----------------|
| `VITE_X_BLOCKS_KEY` | Blocks API key | Cloud Portal → Project settings |
| `VITE_PROJECT_SLUG` | Project identifier slug | Cloud Portal → Project settings (same project as above) |
| `VITE_CAPTCHA_SITE_KEY` | reCAPTCHA site key | Google reCAPTCHA admin |
| `VITE_CAPTCHA_TYPE` | Captcha provider type | e.g. `reCaptcha` |
| `VITE_BLOCKS_OIDC_CLIENT_ID` | OIDC client ID | Cloud Portal → Project → Auth settings |
| `VITE_BLOCKS_OIDC_REDIRECT_URI` | OIDC redirect URI | Your app's callback URL |
| `USERNAME` | Developer account email | Account added to the same project in Cloud Portal → People (must have `cloudadmin` role) |
| `PASSWORD` | Developer account password | Same account as USERNAME |

Write the completed `.env` file in this exact format:

```
# Vite environment variables
VITE_API_BASE_URL=https://api.seliseblocks.com
VITE_X_BLOCKS_KEY=<value>
VITE_PROJECT_SLUG=<value>

VITE_CAPTCHA_SITE_KEY=<value>
VITE_CAPTCHA_TYPE=<value>

VITE_BLOCKS_OIDC_CLIENT_ID=<value>
VITE_BLOCKS_OIDC_REDIRECT_URI=<value>

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

Then read the `skill.md` for the matched domain:
- `skills/identity-access/skill.md` — auth, users, roles, permissions, MFA, organizations
- `skills/communication/skill.md` — email, notifications, templates
- `skills/data-management/skill.md` — schemas, data sources, files, access policies
- `skills/localization/skill.md` — languages, translation keys, import/export
- `skills/ai-services/skill.md` — AI agents, knowledge base, models, tools, chat
- `skills/lmt/skill.md` — logs, traces, performance analytics
