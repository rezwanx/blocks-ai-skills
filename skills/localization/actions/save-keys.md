# Action: save-keys

## Purpose

Batch create or update multiple translation keys in a single request. Use this when importing many keys at once or seeding initial translations.

---

## Endpoint

```
POST $API_BASE_URL/uilm/v1/Key/SaveKeys
```

---

## curl

```bash
curl --location "$API_BASE_URL/uilm/v1/Key/SaveKeys" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "projectKey": "'$X_BLOCKS_KEY'",
    "moduleId": "<MODULE_ID>",
    "keys": [
      {
        "keyName": "login.title",
        "translations": [
          { "languageCode": "en", "value": "Welcome Back" },
          { "languageCode": "de", "value": "Willkommen zurück" }
        ]
      },
      {
        "keyName": "login.button.submit",
        "translations": [
          { "languageCode": "en", "value": "Sign In" }
        ]
      }
    ]
  }'
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| projectKey | string | yes | Use $X_BLOCKS_KEY |
| moduleId | string | yes | ID of the target module |
| keys | array | yes | Array of key objects |
| keys[].keyName | string | yes | Dot-notation key name |
| keys[].translations | array | yes | Array of `{ languageCode, value }` |

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

* 400 — duplicate key names in batch, or invalid moduleId
* 401 — run refresh-token then retry
