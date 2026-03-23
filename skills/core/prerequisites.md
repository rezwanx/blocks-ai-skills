# Prerequisites

## Overview

Before using Blocks AI Skills, the following steps **must be completed manually** in the SELISE Blocks Cloud Portal.

These cannot be automated. Claude cannot perform them. They are one-time setup steps per project.

Cloud Portal: https://cloud.seliseblocks.com

---

## Required Role

The user account used for all operations must have the **`cloudadmin`** role.

> **Error:** If any API call returns `403 Forbidden`, the most likely cause is a missing `cloudadmin` role.
>
> **Fix:** Ask your SELISE Blocks administrator to assign the `cloudadmin` role to your account via the cloud portal before proceeding.

---

## Step 1 — Project Creation

**Where:** Cloud Portal → Projects → Create Project

**What to do:**
1. Log in to https://cloud.seliseblocks.com
2. Navigate to Projects
3. Create a new project with a name and slug
4. Copy the project slug → this becomes `VITE_PROJECT_SLUG` in your `.env`
5. Copy the Blocks Key → this becomes `VITE_X_BLOCKS_KEY` in your `.env`

**Error Guidance:**

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Cannot create project | Insufficient permissions | Ensure your account has `cloudadmin` role |
| `VITE_X_BLOCKS_KEY` not working | Wrong key copied | Re-copy the Blocks Key from the project settings page |
| 401 on all API calls | Project not active | Verify project status is Active in the portal |

---

## Step 2 — Environment Creation

**Where:** Cloud Portal → Projects → [Your Project] → Environments → Create Environment

**What to do:**
1. Open your project in the portal
2. Create an environment (e.g. `dev`, `staging`, `production`)
3. Note the environment URL → this becomes `VITE_API_BASE_URL` in your `.env`

**Error Guidance:**

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| API calls return `404` | Wrong environment URL | Re-check `VITE_API_BASE_URL` matches the environment |
| Environment not visible | Not yet created | Complete this step in the cloud portal first |

---

## Step 3 — People Creation

**Where:** Cloud Portal → Projects → [Your Project] → People → Add Member

**What to do:**
1. Navigate to People in your project
2. Add the developer/user account that will be used for operations
3. Assign the **`cloudadmin`** role to this account
4. The email and password of this account become `USERNAME` and `PASSWORD` in your `.env`

**Error Guidance:**

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `401 Unauthorized` on get-token | Wrong credentials | Verify USERNAME and PASSWORD match the portal account |
| `403 Forbidden` on any action | Missing `cloudadmin` role | Assign `cloudadmin` role to the account in People settings |
| Account not found | User not added to project | Add the user to the project in the People section |
| Login succeeds but actions fail | Role not applied | Re-assign the role and wait a few minutes for propagation |

---

## Step 4 — Repository Attachment

**Where:** Cloud Portal → Projects → [Your Project] → Repositories → Attach

**What to do:**
1. Navigate to Repositories in your project
2. Attach your application repository (GitHub/GitLab)
3. This links your codebase to the SELISE Blocks project for CI/CD and deployment

**Error Guidance:**

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Deployment not working | Repository not attached | Complete this step in the portal |
| Wrong repo attached | Incorrect selection | Detach and re-attach the correct repository |

---

## Checklist

Before starting any development, confirm all items are complete:

- [ ] Account has `cloudadmin` role in the project
- [ ] Project created in cloud portal
- [ ] `VITE_PROJECT_SLUG` and `VITE_X_BLOCKS_KEY` copied from portal
- [ ] Environment created and `VITE_API_BASE_URL` confirmed
- [ ] User account added to project with `cloudadmin` role
- [ ] `USERNAME` and `PASSWORD` set in `.env`
- [ ] Repository attached to the project in the portal
- [ ] `get-token` runs successfully (validates all of the above)

---

## Quick Validation

Run this to confirm your credentials and role are correct:

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Authentication/Token" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "username=$USERNAME" \
  --data-urlencode "password=$PASSWORD" \
  --data-urlencode "client_id=$VITE_BLOCKS_OIDC_CLIENT_ID"
```

| Response | Meaning |
|----------|---------|
| `200` with `access_token` | All prerequisites met — ready to proceed |
| `400` | Wrong `grant_type`, `client_id`, or malformed request |
| `401` | Wrong `USERNAME`, `PASSWORD`, or `VITE_X_BLOCKS_KEY` |
| `403` | Account missing `cloudadmin` role |
| `404` | Wrong `VITE_API_BASE_URL` or environment not created |
