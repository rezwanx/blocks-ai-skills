# Blocks AI Skills

**Blocks AI Skills** is a modular AI skill system that enables **Claude Code** to build full-stack applications on **SELISE Blocks** — automatically calling the right APIs, generating production-ready frontend code, and following consistent architecture across every project.

Instead of writing boilerplate integration code, you describe what you want to build. Claude reads the skills, selects the correct flow or action, executes the backend requests, and generates the frontend — all grounded in real API contracts.

---

## About SELISE Blocks

SELISE Blocks is a cloud platform that provides backend services as a unified environment:

| Service | What it does |
|---------|-------------|
| IDP | Authentication, MFA, users, roles, permissions, organizations |
| UDS | Data schemas, GraphQL access, files, access policies |
| blocksai-api | AI agents, knowledge bases, models, tools, streaming chat |
| communication | Email, in-app notifications, templates |
| uilm | Localization, translation keys, import/export |
| lmt | Logs, distributed traces, performance analytics |

- Cloud Portal: https://cloud.seliseblocks.com
- Documentation: https://docs.seliseblocks.com/cloud/
- GitHub: https://github.com/SELISEdigitalplatforms

---

## How It Works — 3-Layer Decision Model

When you describe a feature, Claude follows a fixed decision chain:

```
User request
    │
    ▼
core/decision.md          ← Which domain? (identity-access, data-management, ai-services, …)
    │
    ▼
flows/*.md                ← Is there a multi-step flow for this? (login-flow, define-schema-flow, …)
    │
    ▼
skill.md intent map       ← Which single action handles this?
    │
    ▼
actions/*.md              ← Exact curl, request body, response shape, error handling
    │
    ▼
contracts.md              ← TypeScript types for frontend
    │
    ▼
frontend.md               ← React components, hooks, Zod schemas, routing
```

**Flows are the key layer.** A flow bundles multiple actions into a correct sequence — for example, the login flow covers: get login options → handle CAPTCHA → call get-token → branch on MFA → store tokens → redirect. Without flows, each action would need to be manually ordered every time.

---

## Skill Domain Structure

Each domain follows this layout:

```
skills/
└── domain-name/
    ├── skill.md        ← intent map: "user wants X → use action Y or flow Z"
    ├── contracts.md    ← all request/response TypeScript types for this domain
    ├── frontend.md     ← React module structure, hooks, component patterns
    ├── flows/          ← multi-step workflows (login, schema creation, KB setup, …)
    │   └── *.md
    └── actions/        ← single API operations with exact curl and error handling
        └── *.md
```

---

## Implemented Domains

```
skills/
├── core/              ✅  routing rules, runtime, conventions, frontend design system
├── identity-access/   ✅  auth, MFA, CAPTCHA, users, roles, permissions, orgs, sessions
├── communication/     ✅  email, in-app notifications, templates
├── data-management/   ✅  schemas, GraphQL data access, files, access policies, validation
├── localization/      ✅  languages, translation keys, auto-translate, import/export
├── ai-services/       ✅  AI agents, knowledge bases, models, tools, streaming chat, LLM queries
├── lmt/               ✅  logs, distributed traces, performance analytics, live log streaming
└── devsecops/         🔜  CI/CD, security scanning (planned)
```

---

## Frontend Stack

The default stack follows the reference implementation at [blocks-construct-react](https://github.com/SELISEdigitalplatforms/blocks-construct-react):

| Layer | Technology |
|-------|-----------|
| Framework | React 19 + TypeScript |
| Build tool | Vite |
| Styling | Tailwind CSS 3.4 |
| Components | Radix UI + shadcn/ui |
| Icons | Lucide React |
| Forms | React Hook Form + Zod |
| State | Zustand (persisted) |
| Data fetching | TanStack Query |
| Font | Nunito Sans |

**shadcn/ui MCP** — configure the shadcn/ui MCP server in Claude Code for real-time component API lookups during code generation. Setup: `https://ui.shadcn.com/docs/mcp`

### Changing the stack

The skills system is not tied to any specific framework. To use a different stack, edit `skills/core/frontend.md` — all generated code will follow whatever is defined there.

---

## Prerequisites — Cloud Portal Setup

Four steps must be completed manually in the [SELISE Blocks Cloud Portal](https://cloud.seliseblocks.com) before any API call will work. Claude cannot do these.

### 1. Create a Project
Cloud Portal → Projects → Create Project

Copy the **Project Slug** → `VITE_PROJECT_SLUG`
Copy the **Blocks Key** → `VITE_X_BLOCKS_KEY`

> `VITE_X_BLOCKS_KEY`, `VITE_PROJECT_SLUG`, `USERNAME`, and `PASSWORD` must all come from this same project. Mixing values from different projects will cause authentication failures.

### 2. Create an Environment
Cloud Portal → Projects → [Your Project] → Environments → Create

The API base URL is always `https://api.seliseblocks.com` — you do not need to copy it. The environment must exist for your project to be active.

### 3. Add a Developer Account with `cloudadmin` role
Cloud Portal → Projects → [Your Project] → People → Add Member

Add the account to **the same project**. Assign the `cloudadmin` role. This account's credentials become `USERNAME` and `PASSWORD` in `.env`. Without `cloudadmin`, all API calls return `403`.

### 4. Attach a Repository
Cloud Portal → Projects → [Your Project] → Repositories → Attach

### Error Reference

| HTTP Status | Likely Cause | Fix |
|-------------|-------------|-----|
| `401` | Wrong credentials | Check `USERNAME` / `PASSWORD` in Cloud Portal → People |
| `403` | Missing `cloudadmin` role | Assign role in Cloud Portal → People |
| `404` | Wrong API URL | Re-check `VITE_API_BASE_URL` from Environments |
| All APIs fail | Project not set up | Complete all 4 portal steps above |

---

## Environment Variables

Create a `.env` file in your project root:

```bash
# Vite environment variables
VITE_API_BASE_URL=https://api.seliseblocks.com
VITE_X_BLOCKS_KEY=your_blocks_key        # Cloud Portal → Project settings
VITE_PROJECT_SLUG=your_project_slug      # Cloud Portal → Project settings (same project)

VITE_CAPTCHA_SITE_KEY=your_captcha_site_key
VITE_CAPTCHA_TYPE=reCaptcha

VITE_BLOCKS_OIDC_CLIENT_ID=your_oidc_client_id
VITE_BLOCKS_OIDC_REDIRECT_URI=http://localhost:5173/auth/callback

# Build configuration
GENERATE_SOURCEMAP=false

# Theme Colors — hex or hsl format
VITE_PRIMARY_COLOR=#15969B
VITE_SECONDARY_COLOR=#5194B8

# CLI/Claude credentials — for direct API operations only
# The frontend gets these from the login form, not from here
# Must be a user added to the SAME project as VITE_X_BLOCKS_KEY / VITE_PROJECT_SLUG
USERNAME=your_cloudadmin_email
PASSWORD=your_cloudadmin_password

# Populated at runtime after authentication
ACCESS_TOKEN=
REFRESH_TOKEN=
```

`.env` is gitignored. The `ACCESS_TOKEN` and `REFRESH_TOKEN` fields are left empty — Claude writes these at runtime after authentication.

---

## Getting Started

There are two ways to use this repository.

---

### Option A — Use directly (recommended for new Blocks projects)

Clone this repo as the working directory for your Blocks project. Claude Code reads the `CLAUDE.md` automatically and loads all skills.

#### 1. Clone the repository

```bash
git clone https://github.com/rezwanx/blocks-ai-skills.git my-project
cd my-project
```

#### 2. Set up your environment

Create a `.env` file using the template in the [Environment Variables](#environment-variables) section. Fill in values from your Cloud Portal project.

#### 3. Start Claude Code

```bash
claude
```

At session start, Claude will automatically:
1. Check that the Cloud Portal prerequisites are complete
2. Verify your `.env` variables
3. Authenticate and store `ACCESS_TOKEN`
4. Confirm ready

---

### Option B — Add to an existing project

If you already have a project, create a `CLAUDE.md` in its root with the following content. Claude will fetch all skills remotely on every session start — nothing is cloned or copied locally.

```markdown
# Blocks AI Skills

At the start of every session, you MUST fetch and follow the skills from the remote repository:

**Repository:** https://github.com/rezwanx/blocks-ai-skills

## Startup Procedure

1. Fetch the CLAUDE.md from `https://raw.githubusercontent.com/rezwanx/blocks-ai-skills/main/CLAUDE.md` and follow its instructions.
2. Fetch the skill index from `https://raw.githubusercontent.com/rezwanx/blocks-ai-skills/main/skills/index.md` to understand available domains and skills.
3. Fetch individual skill files on-demand as needed based on the user's request (e.g., `https://raw.githubusercontent.com/rezwanx/blocks-ai-skills/main/skills/<domain>/skill.md`).

## Rules

- ALWAYS use WebFetch to read skill files from the repository above — never skip this step.
- Follow the instructions in the fetched CLAUDE.md as if they were defined locally.
- When a user request maps to a specific domain/skill, fetch the relevant skill files before proceeding.
- Cache awareness: WebFetch has a 15-minute cache, so re-fetching within a session is cheap.
- All file paths referenced inside the fetched CLAUDE.md (e.g. `skills/identity-access/actions/get-token.md`) are relative to `https://raw.githubusercontent.com/rezwanx/blocks-ai-skills/main/` — resolve them with WebFetch, not as local files.
```

That's it. Run `claude` in your project — it will load all skills from GitHub automatically.

---

### Build features with natural prompts

```
Build a login page with email/password and MFA support
```

```
Create a data schema for a products collection with name, price, and category fields
```

```
Set up a knowledge base for my AI agent with these PDF files
```

```
Add email notification when a user registers
```

---

## Example Use Cases

### Authentication & Access Control
Login, registration, MFA (email OTP + TOTP), password recovery, role and permission management, session management, SSO/OIDC

### Data Management
Schema definition, GraphQL-based CRUD, file upload (S3 / DMS), access policies, field validation, schema migration

### AI-Powered Features
AI agent creation and configuration, Retrieval-Augmented Generation (RAG) with knowledge bases, direct LLM queries, streaming chat, model management

### Communication
Transactional email, in-app notifications, email template management

### Localization
Multi-language setup, translation key management, auto-translation, UILM file import/export

### Observability
Service log viewing, distributed trace analysis, API performance analytics, live log streaming

---

## Providing Feedback from Real Implementations

The skills are grounded in Swagger docs and the reference repo, but real project behavior is the highest-fidelity source. If something is wrong or incomplete, the fastest ways to fix it:

- **Paste a working curl** — copy from your browser network tab or Postman (mask the token, keep the URL and body)
- **Paste an API response** — real JSON response lets contracts be fixed immediately
- **Share a private repo** — provide a GitHub link with working service calls
- **Describe what failed** — "calling X with Y returned Z" is enough to diagnose most issues

---

## Contributing

Contributions welcome. The most valuable additions:

- New action files grounded in real Swagger endpoints
- Flow files for common multi-step patterns not yet covered
- Corrections to contracts.md based on real API responses
- New domain skill sets (devsecops is next)

Repository: https://github.com/rezwanx/blocks-ai-skills

---

## License

MIT License
