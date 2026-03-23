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
  All backend operations use a Private Access Token (PAT) stored securely in environment variables.

* **Frontend and Backend Alignment**
  Designed to work seamlessly with React (Vite) and modern UI systems like shadcn/ui.

* **Reusable Across Multiple Projects**
  This repository is independent of any single application and can be reused across different systems.

---

## 🏗️ Project Structure

```bash id="m7hrpq"
/skills
  ├── core/
  ├── identity-access/
  ├── communication/
  ├── data-management/
  ├── localization/
  ├── ai-services/
  ├── devsecops/
  ├── utilities/
```

### Structure Breakdown

* **core/**
  Contains runtime instructions, environment setup, and global rules that guide execution.

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
curl -X POST "$BASE_URL/api/data" \
  -H "Authorization: Bearer $PAT" \
  -H "Content-Type: application/json"
```

All requests use secure environment variables and follow consistent patterns.

---

## 🔐 Environment Setup

Create a `.env` file in your local environment:

```bash id="j1h9tx"
BASE_URL=https://api.seliseblocks.com
PAT=your_private_access_token
```

### Security Guidelines

* Never commit `.env` files
* Never expose the PAT in frontend code
* Always use environment variables in action definitions

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
Action Execution (with PAT)
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
