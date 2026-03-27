# Action: delete-language

## Purpose

Delete a language from a project by its ID.

---

## Endpoint

```
DELETE $API_BASE_URL/uilm/v1/Language/Delete?itemId=<id>&projectKey=$X_BLOCKS_KEY
```

---

## curl

```bash
curl --location --request DELETE \
  "$API_BASE_URL/uilm/v1/Language/Delete?itemId=<LANGUAGE_ID>&projectKey=$X_BLOCKS_KEY" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| itemId | string | yes | ID of the language to delete |
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

* 400 — cannot delete the default language; set a new default first
* 401 — run refresh-token then retry
* 404 — language not found
