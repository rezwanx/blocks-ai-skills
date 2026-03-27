# Action: delete-key

## Purpose

Delete a translation key and all its translations by ID.

---

## Endpoint

```
DELETE $API_BASE_URL/uilm/v1/Key/Delete?itemId=<KEY_ID>&projectKey=$X_BLOCKS_KEY
```

---

## curl

```bash
curl --location --request DELETE \
  "$API_BASE_URL/uilm/v1/Key/Delete?itemId=<KEY_ID>&projectKey=$X_BLOCKS_KEY" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| itemId | string | yes | ID of the key to delete |
| projectKey | string | yes | Use $X_BLOCKS_KEY |

---

## On Success (200)

```json
{
  "success": true,
  "errorMessage": null,
  "validationErrors": []
}
```

---

## On Failure

* 401 — run refresh-token then retry
* 404 — key not found
