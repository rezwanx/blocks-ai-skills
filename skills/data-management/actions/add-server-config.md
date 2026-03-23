# Action: add-server-config

## Purpose

Register a server configuration for the UDS service. Use this to register a backend server that UDS should communicate with for schema-linked business logic or GraphQL federation.

---

## Endpoint

```
POST $VITE_API_BASE_URL/uds/v1/configurations/add/server
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/uds/v1/configurations/add/server" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "ServerName": "product-service",
    "ServerUrl": "https://api.myapp.com/product-service",
    "ProjectKey": "$VITE_PROJECT_SLUG"
  }'
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| ServerName | string | yes | Unique name for this server config — use kebab-case |
| ServerUrl | string | yes | Full URL of the server to register |
| ProjectKey | string | yes | `$VITE_PROJECT_SLUG` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Server configuration added successfully",
  "httpStatusCode": 200,
  "data": null,
  "errors": {}
}
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 400 | Duplicate ServerName or missing required fields | Ensure ServerName is unique for the project |
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |
