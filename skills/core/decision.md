# Decision Guide (Claude Code)

This is the first file to read when receiving a user request.
It routes the request to the correct skill domain and defines what to clarify before starting.

---

## Step 1 — Route to Skill Domain

| If the user wants to... | Use skill |
|-------------------------|-----------|
| Login, register, activate account, reset password, MFA, roles, permissions, users, organizations, sessions, CAPTCHA | `identity-access` |
| Send email, push notification, SMS, messaging | `communication` *(planned)* |
| Create, read, update, delete records, query data, storage | `data-management` *(planned)* |
| Translate content, manage languages, locale settings | `localization` *(planned)* |
| AI chat, RAG, vector search, embeddings, model orchestration | `ai-services` *(planned)* |
| CI/CD, monitoring, observability, security scanning | `devsecops` *(planned)* |
| Utility operations (file upload, image resize, export) | `utilities` *(planned)* |

If the request spans multiple domains, handle one domain at a time starting with `identity-access` (authentication must always come first).

---

## Step 2 — Check for a Flow

Before picking individual actions, check if the request maps to an existing flow in the skill's `flows/` folder.

| If the user wants to build... | Use flow |
|-------------------------------|----------|
| Login page | `identity-access/flows/login-flow.md` |
| Registration / signup page | `identity-access/flows/user-registration.md` |
| Forgot password / reset password | `identity-access/flows/password-recovery.md` |
| MFA setup page | `identity-access/flows/mfa-setup.md` |
| Admin user creation + role assignment | `identity-access/flows/user-onboarding.md` |
| Session management / logout UI | `identity-access/flows/session-management.md` |
| Role and permission configuration | `identity-access/flows/role-permission-setup.md` |

If no flow matches, fall back to the intent mapping table in `skill.md`.

---

## Step 3 — Ask Pre-flight Questions

Before generating any code or calling any API, ask the developer:

### Always ask:
1. **What is the feature name / module name?** *(used for folder and file naming)*
2. **Is this a new page or an addition to an existing page?**

### Ask for auth-related features:
3. **Which login methods are enabled?** `email/password`, `social login`, `OIDC`, or multiple?
4. **Is MFA required?** If yes, which type — `email OTP`, `authenticator app (TOTP)`, or both?
5. **Is CAPTCHA enabled?** If yes, which provider — `reCaptcha` or `hCaptcha`?
6. **Is this self-registration (user signs up themselves) or admin-created (admin creates users)?**

### Ask for user management features:
7. **Which roles exist in this project?** *(needed for set-roles calls)*
8. **Are organizations used?** If yes, should users be assigned to one on creation?

Do not proceed until these questions are answered. The answers determine which flow branches to follow.

---

## Step 4 — Define Output

Every request must produce both:

| Output | What it means |
|--------|---------------|
| **Backend** | API calls (curl via action files), token handling, error responses |
| **Frontend** | React pages, components, hooks, Zod schemas, routing — following `core/frontend.md` |

If the user only wants backend or only wants frontend, confirm before limiting scope.

---

## Step 5 — Follow Execution Order

1. Read `core/runtime.md` — execution rules and token flow
2. Read `core/conventions.md` — naming conventions and flow file template format
3. Read the matched flow file in full
4. Read the action files referenced by the flow
5. Read `contracts.md` for request/response schemas
6. Execute or generate in the order defined by the flow
7. Never skip steps or reorder them — the flow defines the correct sequence
