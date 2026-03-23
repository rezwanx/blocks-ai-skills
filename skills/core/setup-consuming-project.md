# Setup Consuming Project

How to configure a new project to use Blocks AI Skills remotely.

**Never clone or copy the blocks-ai-skills repository into the consuming project.**
All skills are fetched on demand via WebFetch from the raw GitHub URL.

---

## When to Run This

Run this once when setting up a new project that will use Blocks AI Skills.

Trigger phrases:
> "set up this project to use blocks-ai-skills"
> "configure claude for this project"
> "initialise blocks skills in this project"

---

## What to Create

Generate two files in the consuming project root:

1. `CLAUDE.md` — instructs Claude to always fetch skills remotely
2. `PROJECT.md` — project context file (empty template, populated as features are built)

---

## Step 1 — Generate CLAUDE.md

Create `CLAUDE.md` in the consuming project root with this exact content:

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
- All file paths referenced inside the fetched CLAUDE.md (e.g. `skills/identity-access/actions/get-token.md`) are relative to the base URL above — resolve them with WebFetch, not as local files.
```

---

## Step 2 — Generate PROJECT.md

Create an empty `PROJECT.md` from the template in `skills/core/context.md`. Leave all values blank — they will be filled in as features are built.

---

## Step 3 — Confirm

Tell the developer:

> **Setup complete.**
>
> - `CLAUDE.md` created — Claude will fetch all Blocks AI Skills remotely on each session start.
> - `PROJECT.md` created — will be populated as features are built.
>
> Next step: fill in your `.env` values and run `claude` to start building.

---

## What NOT to Do

- Do not copy any files from `blocks-ai-skills` into this project
- Do not add `blocks-ai-skills` as a git submodule
- Do not clone `blocks-ai-skills` into a subfolder of this project
- Do not cache skill files locally — always fetch fresh from GitHub
