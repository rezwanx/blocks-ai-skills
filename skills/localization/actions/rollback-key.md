# Action: rollback-key

## Purpose

Rollback a translation key to a specific previous version from its timeline history. Use `get-key-timeline` first to identify the target `timelineId`.

---

## Endpoint

```
POST $API_BASE_URL/uilm/v1/Key/RollBack
```

---

## curl

```bash
curl --location "$API_BASE_URL/uilm/v1/Key/RollBack" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "keyId": "<KEY_ID>",
    "timelineId": "<TIMELINE_ENTRY_ID>",
    "projectKey": "'$X_BLOCKS_KEY'"
  }'
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| keyId | string | yes | ID of the key to roll back |
| timelineId | string | yes | ID of the timeline entry to restore |
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

After success, call `get-key` to verify the restored translation value.

---

## On Failure

* 400 — invalid keyId or timelineId not found
* 401 — run refresh-token then retry
