# Action: get-data-source

## Purpose

Get the database connection configuration (data source) registered for a project.

---

## Endpoint

```
GET $VITE_API_BASE_URL/uds/v1/data-sources/{projectKey}/get
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/uds/v1/data-sources/$VITE_PROJECT_SLUG/get" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Path Parameters

| Parameter | Type | Required | Notes |
|-----------|------|----------|-------|
| projectKey | string | yes | `$VITE_PROJECT_SLUG` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Success",
  "httpStatusCode": 200,
  "data": {
    "itemId": "my-project-db",
    "databaseName": "my_database",
    "projectKey": "my-project",
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00Z"
  },
  "errors": {}
}
```

> The `ConnectionString` is never returned in the response for security reasons.

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |
| 404 | No data source registered for this project | Call `add-data-source` to register one |
