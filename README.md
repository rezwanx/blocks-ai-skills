# 🚀 Blocks AI Skills

**Blocks AI Skills** is a modular AI skill system designed to accelerate application development using **SELISE Blocks** and **Claude Code**.

It provides a structured way to define reusable **skills, actions, and execution rules** that allow AI to interact with backend APIs, generate frontend code, and maintain a consistent architecture across projects.

This repository acts as an **AI execution layer** that connects your application with backend services through secure and repeatable workflows.

---

## 🌐 About SELISE Blocks

SELISE Blocks is a cloud-based platform that provides backend services, AI capabilities, and DevSecOps tooling in a unified environment.

* Website: https://seliseblocks.com
* Repositories: https://github.com/SELISEdigitalplatforms
* Cloud Platform: https://cloud.seliseblocks.com
* Official Documentation: https://docs.seliseblocks.com/cloud/

Blocks AI Skills is designed specifically to integrate with these services and make them **AI-operable**.

---

## 🖥️ Frontend Stack

The default frontend stack is:

| Layer | Technology |
|-------|-----------|
| Framework | React 19 + TypeScript |
| Build tool | Vite |
| Styling | Tailwind CSS 3.4 |
| Components | Radix UI + shadcn/ui |
| Icons | Lucide React |
| Forms | React Hook Form + Zod |
| Font | Nunito Sans |

The reference implementation follows the design system and structure from [blocks-construct-react](https://github.com/SELISEdigitalplatforms/blocks-construct-react).

### Changing the Frontend Stack

This skills system is **not tied to any specific frontend framework**. To use a different stack:

1. Edit `skills/core/frontend.md` — replace the stack, component conventions, and folder structure
2. Claude will generate all frontend code according to whatever is defined there

For example, to switch to Next.js + Chakra UI, update `frontend.md` with those conventions and all generated UI code will follow them automatically.

---

## 🧠 Overview

Modern development often involves repetitive API integration, inconsistent patterns, and manual workflows. Blocks AI Skills solves this by introducing a **skill-based architecture** where each capability is clearly defined and executable.

With this approach, AI can:

* Understand your system structure
* Select the correct operation
* Execute backend requests securely
* Generate production-ready frontend code

---

## 🎯 Key Capabilities

* **Executable API Actions**
  Each action is defined with real API calls, enabling direct execution using environment variables and secure tokens.

* **Modular Skill Architecture**
  Features are organized into domains such as identity, communication, data management, AI services, and DevSecOps.

* **Secure Token-Based Execution**
  Authentication uses username and password to obtain an ACCESS_TOKEN via the IDP. All backend operations use the ACCESS_TOKEN stored securely in environment variables.

* **Frontend and Backend Alignment**
  Designed to work seamlessly with React (Vite) and modern UI systems like shadcn/ui.

* **Reusable Across Multiple Projects**
  This repository is independent of any single application and can be reused across different systems.

---

## 🏗️ Project Structure

```bash id="m7hrpq"
/skills
  ├── core/              ✅ implemented
  ├── identity-access/   ✅ implemented
  ├── communication/     ✅ implemented
  ├── data-management/   ✅ implemented
  ├── localization/      ✅ implemented
  ├── ai-services/       ✅ implemented
  ├── lmt/               ✅ implemented
  ├── devsecops/         🔜 planned
```

### Structure Breakdown

* **core/**
  Contains runtime instructions, environment setup, global rules, and the frontend design system reference that guide all code generation.

* **identity-access/**
  Handles authentication, authorization, MFA, and CAPTCHA.

* **communication/**
  Manages email, messaging, and notification systems.

* **data-management/**
  Covers data services, CRUD operations, and storage.

* **localization/**
  Provides language and localization support.

* **ai-services/**
  Includes advanced capabilities such as RAG, vector databases, and AI model orchestration.

* **devsecops/**
  Focuses on CI/CD, monitoring, observability, and security testing.

---

## ⚙️ How It Works

### 1. Define Skills

Each feature follows a consistent structure:

```bash id="ewdxm7"
feature/
  ├── skill.md
  ├── frontend.md
  ├── contracts.md
  ├── actions/
```

* `skill.md` → defines responsibilities and scope
* `frontend.md` → describes UI integration
* `contracts.md` → defines request and response formats
* `actions/` → contains executable API calls

---

### 2. AI Reads and Understands

When using Claude Code, the system:

* Identifies the correct domain
* Reads the relevant skill
* Selects the appropriate action

---

### 3. Execute Backend Actions

Example API execution:

```bash id="cznvya"
curl -X POST "$VITE_API_BASE_URL/api/data" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  -H "Content-Type: application/json"
```

All requests use secure environment variables and follow consistent patterns.

---

## 🔐 Environment Setup

Create a `.env` file in your local environment:

```bash id="j1h9tx"
# Vite environment variables
VITE_API_BASE_URL=https://dev-api.seliseblocks.com
VITE_X_BLOCKS_KEY=your_blocks_key
VITE_CAPTCHA_SITE_KEY=your_captcha_site_key
VITE_CAPTCHA_TYPE=reCaptcha
VITE_PROJECT_SLUG=your_project_slug

VITE_BLOCKS_OIDC_CLIENT_ID=your_oidc_client_id
VITE_BLOCKS_OIDC_REDIRECT_URI=your_redirect_uri

# Build configuration
GENERATE_SOURCEMAP=false

# Theme Colors
VITE_PRIMARY_COLOR=#15969B
VITE_SECONDARY_COLOR=#5194B8

# Credentials for authentication
USERNAME=your_username
PASSWORD=your_password

# Populated at runtime after authentication
ACCESS_TOKEN=
REFRESH_TOKEN=
```

### Security Guidelines

* Never commit `.env` files
* Never expose credentials or tokens in frontend code
* Always use environment variables in action definitions

---

## ⚠️ Prerequisites — Cloud Portal Setup

Before using this system, four steps **must be completed manually** in the [SELISE Blocks Cloud Portal](https://cloud.seliseblocks.com). Claude cannot do these. They are one-time setup steps per project.

> Your account must have the **`cloudadmin`** role. Without it, all API calls will return `403 Forbidden`.

### 1. Create a Project
Cloud Portal → Projects → Create Project

Copy the **Project Slug** → `VITE_PROJECT_SLUG`
Copy the **Blocks Key** → `VITE_X_BLOCKS_KEY`

### 2. Create an Environment
Cloud Portal → Projects → [Your Project] → Environments → Create

Copy the **Environment URL** → `VITE_API_BASE_URL`

### 3. Add People (with cloudadmin role)
Cloud Portal → Projects → [Your Project] → People → Add Member

- Add the developer account that will be used for operations
- Assign the `cloudadmin` role to this account
- This account's email and password become `USERNAME` and `PASSWORD` in `.env`

### 4. Attach Repository
Cloud Portal → Projects → [Your Project] → Repositories → Attach

Link your application repository for CI/CD and deployment.

---

### Error Reference

| Error | Likely Cause | Fix |
|-------|-------------|-----|
| `401 Unauthorized` | Wrong credentials | Check `USERNAME` / `PASSWORD` match the portal account |
| `403 Forbidden` | Missing `cloudadmin` role | Assign role in Cloud Portal → People |
| `404 Not Found` | Wrong API URL | Re-check `VITE_API_BASE_URL` from Environments |
| All APIs fail | Project/environment not set up | Complete all 4 portal steps above |

See `skills/core/prerequisites.md` for detailed per-step error guidance.

---

## 🚀 Getting Started

### 1. Clone the repository

```bash id="t1m5i4"
git clone https://github.com/your-org/blocks-ai-skills.git
```

---

### 2. Configure environment variables

```bash id="d5c9yw"
cp .env.example .env
```

---

### 3. Start using with Claude Code

Run Claude in your project:

```bash id="0xxa3j"
claude
```

Then use natural prompts such as:

```id="d93um4"
Use the data-management skill to create a new record
```

---

## 🧩 Example Use Cases

### Authentication and Access Control

* User login and signup
* Multi-factor authentication
* Role and permission management

### Data Management

* Create, update, and retrieve records
* Integrate with backend APIs
* Manage structured data

### AI-Powered Features

* Retrieve augmented generation (RAG) queries
* Vector database operations
* Multi-model AI workflows

### Communication Systems

* Send emails
* Trigger notifications
* Handle messaging workflows

---

## 🧠 Best Practices

* Keep each action focused on a single API operation
* Use descriptive and consistent naming conventions
* Define clear request and response contracts
* Separate frontend logic from backend execution
* Validate API responses before proceeding

---

## ❌ Common Mistakes to Avoid

* Hardcoding tokens or secrets
* Combining multiple responsibilities in one action
* Skipping contract definitions
* Using inconsistent naming patterns

---

## 🔄 Development Workflow

```text id="t1y7f6"
User Request → Claude Code
        ↓
Skill Selection
        ↓
Action Execution (with ACCESS_TOKEN)
        ↓
API Response
        ↓
Frontend or Output Generation
```

---

## 🤝 Contributing

Contributions are welcome. You can help by:

* Adding new skills or actions
* Improving existing definitions
* Enhancing documentation and structure

---

## 📄 License

MIT License

---

## ⭐ Final Thoughts

Blocks AI Skills provides a structured foundation for building applications with AI-assisted workflows. By combining modular skills, secure execution, and consistent architecture, it enables faster development and more reliable systems.

It is designed to scale with your projects while keeping complexity under control.
