# Action: get-files

## Purpose

Download multiple files in a single request. Returns a ZIP archive or batch of file binaries.

---

## Endpoint

```
POST $API_BASE_URL/uds/v1/Files/GetFiles
```

---

## curl

```bash
curl --location "$API_BASE_URL/uds/v1/Files/GetFiles" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "FileIds": ["file-id-1", "file-id-2", "file-id-3"],
    "ProjectKey": "$PROJECT_SLUG"
  }' \
  --output files.zip
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| FileIds | array | yes | Array of file IDs to download |
| ProjectKey | string | yes | `$PROJECT_SLUG` |

---

## On Success (200)

Returns a ZIP archive containing the requested files. Not a JSON response.

In frontend code:

```ts
const blob = await response.blob()
const url = URL.createObjectURL(blob)
const a = document.createElement('a')
a.href = url
a.download = 'files.zip'
a.click()
URL.revokeObjectURL(url)
```

---

## On Failure

| Status | Cause | Action |
|--------|-------|--------|
| 400 | Empty FileIds array | Provide at least one file ID |
| 401 | Invalid or expired token | Run get-token to refresh |
| 403 | One or more files are Private and requester lacks access | Check file access modifiers |
| 404 | One or more file IDs not found | Verify all FileIds |
