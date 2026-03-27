# Action: get-access-policies

## Purpose

Get all data access policies defined for a specific schema. Use this to review which roles have access and what operations they are permitted to perform.

---

## Endpoint

```
GET $API_BASE_URL/uds/v1/data-access/policy/get
```

---

## curl

```bash
curl --location "$API_BASE_URL/uds/v1/data-access/policy/get?schemaName=$SCHEMA_NAME&projectKey=$PROJECT_SLUG" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Parameter | Type | Required | Notes |
|-----------|------|----------|-------|
| schemaName | string | yes | The schema's `SchemaName` (not ID) |
| projectKey | string | yes | `$PROJECT_SLUG` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Success",
  "httpStatusCode": 200,
  "data": [
    {
      "itemId": "policy-id-abc123",
      "schemaName": "Product",
      "policyName": "admin-full-access",
      "allowedRoles": ["admin", "superadmin"],
      "operations": ["Read", "Create", "Update", "Delete"],
      "projectKey": "my-project"
    },
    {
      "itemId": "policy-id-def456",
      "schemaName": "Product",
      "policyName": "viewer-read-only",
      "allowedRoles": ["viewer"],
      "operations": ["Read"],
      "projectKey": "my-project"
    }
  ],
  "errors": {}
}
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |
| 404 | Schema not found | Verify schemaName |
