# Action: get-validation

## Purpose

Get a single validation rule set by its ID.

---

## Endpoint

```
GET $VITE_API_BASE_URL/uds/v1/data-validations/{id}
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/uds/v1/data-validations/$VALIDATION_ID" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Path Parameters

| Parameter | Type | Required | Notes |
|-----------|------|----------|-------|
| id | string | yes | Validation ID returned from `create-validation` or `get-validations` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Success",
  "httpStatusCode": 200,
  "data": {
    "id": "validation-id-abc123",
    "schemaId": "schema-id-1",
    "fieldName": "email",
    "validations": [
      {
        "type": "Required",
        "value": null,
        "errorMessage": "Email is required"
      },
      {
        "type": "Email",
        "value": null,
        "errorMessage": "Must be a valid email address"
      }
    ],
    "projectKey": "my-project"
  },
  "errors": {}
}
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |
| 404 | Validation not found | Verify ID from get-validations |
