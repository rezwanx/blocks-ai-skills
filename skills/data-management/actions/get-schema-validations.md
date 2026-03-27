# Action: get-schema-validations

## Purpose

Get all validation rules defined for a specific schema. Returns validations for every field that has validation configured.

---

## Endpoint

```
GET $API_BASE_URL/uds/v1/data-validations/by-schema-id
```

---

## curl

```bash
curl --location "$API_BASE_URL/uds/v1/data-validations/by-schema-id?schemaId=$SCHEMA_ID&projectKey=$PROJECT_SLUG" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Parameter | Type | Required | Notes |
|-----------|------|----------|-------|
| schemaId | string | yes | Schema ID from define-schema or get-schemas |
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
      "id": "validation-id-1",
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
          "errorMessage": "Must be a valid email"
        }
      ]
    },
    {
      "id": "validation-id-2",
      "schemaId": "schema-id-1",
      "fieldName": "username",
      "validations": [
        {
          "type": "Required",
          "value": null,
          "errorMessage": "Username is required"
        },
        {
          "type": "MinLength",
          "value": "3",
          "errorMessage": "Minimum 3 characters"
        }
      ]
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
| 404 | Schema not found | Verify schemaId from get-schemas |
