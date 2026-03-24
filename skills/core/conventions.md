# Conventions

## Naming

* Use kebab-case for folders and files
* Use descriptive names (no abbreviations unless standard)

Examples:

* access-control
* vector-database
* create-record

---

## Folder Naming

* Use nouns for features (authentication, storage)
* Use plural for collections (notifications)
* Use singular for concepts (email, storage)

---

## Action Naming

* Format: verb-resource

Examples:

* create-record
* get-records
* update-user
* delete-item

---

## API Naming Conventions by Domain

Each SELISE Blocks service uses a different naming convention. **Always match the exact convention for the domain you're calling.**

| Domain | Service | Request/Response Fields | Example |
|--------|---------|------------------------|---------|
| identity-access | IDP | camelCase | `userName`, `isActive`, `roleId` |
| data-management | UDS | **PascalCase** | `ProjectKey`, `SchemaId`, `CollectionName` |
| ai-services | blocksai-api | **snake_case** | `project_key`, `agent_id`, `kb_ids` |
| communication | communication | camelCase | `templateId`, `mailTo`, `subject` |
| localization | uilm | camelCase | `languageCode`, `keyName`, `moduleName` |
| lmt | lmt | camelCase | `serviceName`, `dateFrom`, `dateTo` |

> **Critical:** Never mix conventions. Sending `projectKey` (camelCase) to UDS will fail — it expects `ProjectKey` (PascalCase). Sending `ProjectKey` to blocksai-api will fail — it expects `project_key` (snake_case). When in doubt, read the domain's `contracts.md`.

---

## API Conventions

* Use REST-style endpoints
* Use JSON for request/response (except token endpoint which uses form-encoded)
* Use consistent headers

---

## Headers

### For skill repo operations (Claude executing API calls):

```
Authorization: Bearer $ACCESS_TOKEN
x-blocks-key: $VITE_X_BLOCKS_KEY
Content-Type: application/json
```

### For generated app code (frontend/backend):

```
Authorization: Bearer ${accessToken}      ← from app state/storage
x-blocks-key: ${import.meta.env.VITE_X_BLOCKS_KEY}
Content-Type: application/json
```

---

## Environment Variables

| Context | Source | How to access |
|---------|--------|---------------|
| Claude operations (curl) | `.env` in project root | `$VITE_X_BLOCKS_KEY` |
| Generated Vite app code | `.env` in project root | `import.meta.env.VITE_X_BLOCKS_KEY` |

Never mix contexts. Never hardcode values from one context into the other.

---

## File Structure

Each feature must follow:

```
feature/
├── SKILL.md
├── contracts.md
├── frontend.md      (optional)
├── actions/
│   └── verb-resource.md
└── flows/
    └── flow-name.md
```

---

## Flow File Template

Every flow file must contain these sections in order:

```markdown
# Flow: flow-name

## Trigger
What user request activates this flow. Include example phrases.

## Pre-flight Questions
What Claude must ask the developer before starting.

## Flow Steps
Ordered steps. Each step includes:
- Which action to call
- Exact input fields
- Output / what to do next
- Branch conditions (if any)

## Error Handling
Table of errors per step: error | cause | action

## Frontend Output
Table of files to generate: file path | purpose
```

Rules:
- One flow = one complete user-facing scenario
- Steps must be in execution order — never reorder
- Every branch must be documented (success and failure)
- Frontend output must follow `core/frontend.md` conventions

---

## Consistency Rule

If a pattern is used once, it must be used everywhere.
