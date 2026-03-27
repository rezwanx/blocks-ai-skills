# Action: get-generation-history

## Purpose

View the file generation history for a project. Each entry records when a compiled translation file was last generated and by whom.

---

## Endpoint

```
GET $API_BASE_URL/uilm/v1/Key/GetLanguageFileGenerationHistory?projectKey=$X_BLOCKS_KEY&pageNumber=1&pageSize=20
```

---

## curl

```bash
curl --location \
  "$API_BASE_URL/uilm/v1/Key/GetLanguageFileGenerationHistory?projectKey=$X_BLOCKS_KEY&pageNumber=1&pageSize=20" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| projectKey | string | yes | Use $X_BLOCKS_KEY |
| pageNumber | integer | yes | Starts at 1 |
| pageSize | integer | yes | Number of entries per page |

---

## On Success (200)

```json
{
  "data": [
    {
      "id": "string",
      "moduleId": "string",
      "moduleName": "string",
      "languageCode": "en",
      "generatedAt": "2024-01-01T00:00:00Z",
      "generatedBy": "user@example.com"
    }
  ],
  "totalCount": 20,
  "success": true,
  "errorMessage": null,
  "validationErrors": []
}
```

---

## On Failure

* 401 — run refresh-token then retry
