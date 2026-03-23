# Action: get-mock-data

## Purpose

Retrieve test / mock data that has been seeded for a project. Use this during development to inspect or verify auto-generated test records.

---

## Endpoint

```
GET $VITE_API_BASE_URL/uds/v1/data-manage/{projectKey}/mock-data
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/uds/v1/data-manage/$VITE_PROJECT_SLUG/mock-data" \
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
    "schemas": [
      {
        "schemaName": "Product",
        "records": [
          {
            "_id": "mock-id-1",
            "title": "Sample Product 1",
            "price": 29.99
          },
          {
            "_id": "mock-id-2",
            "title": "Sample Product 2",
            "price": 49.99
          }
        ]
      }
    ]
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
| 404 | No mock data exists for this project | Seed mock data through the Cloud Portal or schema setup |
