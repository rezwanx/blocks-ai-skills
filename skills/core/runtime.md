# Runtime Instructions (Claude Code)

## Execution Model

* Read relevant skill and action files before executing
* Select the most appropriate action based on user intent
* Execute API calls using curl

---

## Environment Variables

The following variables must be available:

* VITE_API_BASE_URL
* VITE_X_BLOCKS_KEY
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

---

## API Execution Rules

* Use curl for all backend API calls
* Use "$VITE_API_BASE_URL" as prefix for all endpoints
* Include "Content-Type: application/json" for POST/PUT requests
* Always include "Authorization: Bearer $ACCESS_TOKEN"

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
