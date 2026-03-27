# Action: update-data-source

## Purpose

Update an existing database connection — change the connection string, database name, or active status.

---

## Endpoint

```
PUT $API_BASE_URL/uds/v1/data-sources/update
```

---

## curl

```bash
curl --location --request PUT "$API_BASE_URL/uds/v1/data-sources/update" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "ItemId": "my-project-db",
    "ConnectionString": "mongodb+srv://newuser:newpassword@cluster.mongodb.net",
    "DatabaseName": "my_database_v2",
    "ProjectKey": "$PROJECT_SLUG",
    "IsActive": true
  }'
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| ItemId | string | yes | ID of the existing connection to update |
| ConnectionString | string | yes | Updated MongoDB connection string |
| DatabaseName | string | yes | Updated database name |
| ProjectKey | string | yes | `$PROJECT_SLUG` |
| IsActive | boolean | yes | Set to `false` to disable the connection without deleting it |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Data source updated successfully",
  "httpStatusCode": 200,
  "data": null,
  "errors": {}
}
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 400 | ItemId not found or invalid fields | Verify ItemId from get-data-source |
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |

---

## Next Steps

After updating, call `reload-configuration` to reconnect with the new database settings.
