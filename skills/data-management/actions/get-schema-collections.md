# Action: get-schema-collections

## Purpose

Retrieve a list of all Entity-type schema collections with basic info. Use this when you need a lightweight listing of collection names without full field definitions.

---

## Endpoint

```
GET $API_BASE_URL/uds/v1/schemas/info
```

---

## curl

```bash
curl --location "$API_BASE_URL/uds/v1/schemas/info?projectKey=$PROJECT_SLUG" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| projectKey | string | yes | `$PROJECT_SLUG` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "message": "Success",
  "httpStatusCode": 200,
  "data": {
    "collections": [
      {
        "name": "Product",
        "collectionName": "products"
      },
      {
        "name": "Order",
        "collectionName": "orders"
      }
    ]
  },
  "errors": []
}
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | Missing `cloudadmin` role | Check user role in Cloud Portal → People |
