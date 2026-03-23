# Runtime Instructions (Claude Code)

## Execution Model

1. Read `core/decision.md` — route the request to the correct skill domain
2. Check `flows/` in the matched skill — if a flow covers the request, follow it completely
3. If no flow matches, use the intent mapping in `skill.md` to select the right action
4. Read `contracts.md` for request/response schemas before constructing any request body
5. Follow the action file exactly — do not skip steps or reorder them
6. Execute API calls using curl

---

## Environment Variables

The following variables must be available:

* VITE_API_BASE_URL
* VITE_X_BLOCKS_KEY
* VITE_PROJECT_SLUG
* VITE_BLOCKS_OIDC_CLIENT_ID
* USERNAME
* PASSWORD
* ACCESS_TOKEN (populated after authentication)
* REFRESH_TOKEN (populated after authentication)

---

## Authentication Flow

Authentication is a two-step runtime process:

### Step 1 — Get Token
Before calling any API, obtain an access token using the get-token action:

```
curl --location "$VITE_API_BASE_URL/idp/v1/Authentication/Token" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "username=$USERNAME" \
  --data-urlencode "password=$PASSWORD" \
  --data-urlencode "client_id=$VITE_BLOCKS_OIDC_CLIENT_ID"
```

Store the returned `access_token` as `$ACCESS_TOKEN` and `refresh_token` as `$REFRESH_TOKEN`.

### Step 2 — Use Access Token
All subsequent API calls use:

```
Authorization: Bearer $ACCESS_TOKEN
```

### Step 3 — Handle Token Expiry
If any API returns 401, refresh the access token using the refresh-token action, then retry the original request.

### Token Expiry in Multi-Step Flows

Long-running flows (e.g. bulk KB ingestion, schema creation with many fields) may span several minutes. The `access_token` expires after `expires_in` seconds (typically 8000s ≈ 2 hours). To prevent mid-flow failures:

1. Before starting a multi-step flow, note the token's issue time
2. If a step returns 401, immediately refresh — do not abort the flow
3. Retry only the failed step with the new token; all previous steps stay completed

```bash
# Refresh pattern (run on any 401):
RESPONSE=$(curl --silent "$VITE_API_BASE_URL/idp/v1/Authentication/Token" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "grant_type=refresh_token" \
  --data-urlencode "refresh_token=$REFRESH_TOKEN" \
  --data-urlencode "client_id=$VITE_BLOCKS_OIDC_CLIENT_ID")

export ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')
export REFRESH_TOKEN=$(echo $RESPONSE | jq -r '.refresh_token')
# Then retry the failed step
```

If the refresh also returns 401 → both tokens are expired. Re-authenticate from Step 1 using `USERNAME` and `PASSWORD`.

---

## API Execution Rules

* Use curl for all backend API calls
* Use "$VITE_API_BASE_URL" as prefix for all endpoints
* Include "Content-Type: application/json" for POST/PUT requests
* Always include "Authorization: Bearer $ACCESS_TOKEN"
* **GraphQL endpoint:** `POST $VITE_API_BASE_URL/uds/v1/$VITE_PROJECT_SLUG/graphql` — the project slug goes in the URL **path**, not as a query parameter. The `x-blocks-key` header is also required on every request.

---

## Validation

* Check HTTP response status
* On 401 — refresh token and retry
* Validate response structure before proceeding
* Handle errors gracefully

---

## Security Rules

* Never hardcode tokens
* Never expose ACCESS_TOKEN or REFRESH_TOKEN in frontend code
* Never log sensitive data

---

## Behavior

* Prefer simple and correct actions over complex ones
* Do not guess missing fields — refer to contracts.md
* Always authenticate before executing domain actions
