# Action: mark-all-notifications-read

## Purpose

Mark all notifications as read for the current user, scoped to a specific subscription filter. Use this when the user clicks "Mark all as read" in the notification panel.

---

## Endpoint

```
POST $API_BASE_URL/communication/v1/Notifier/MarkAllNotificationAsRead
```

---

## curl

```bash
curl --location "$API_BASE_URL/communication/v1/Notifier/MarkAllNotificationAsRead" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "subscriptionFilter": "order-updates",
    "projectKey": "'"$PROJECT_SLUG"'"
  }'
```

---

## Request Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| subscriptionFilter | string | yes | Scope to notifications matching this filter |
| projectKey | string | yes | Use `$PROJECT_SLUG` |

---

## On Success (200)

```json
{
  "isSuccess": true,
  "errors": {}
}
```

All unread notifications matching the `subscriptionFilter` are now marked as read.

---

## On Failure

```json
{
  "isSuccess": false,
  "errors": {
    "subscriptionFilter": "Subscription filter is required"
  }
}
```

| HTTP Status | Cause | Action |
|-------------|-------|--------|
| 200 with `isSuccess: false` | Missing `subscriptionFilter` or `projectKey` | Inspect `errors` |
| 401 | Missing or expired `ACCESS_TOKEN` | Re-run `get-token` |
| 403 | Account lacks permission | Verify `cloudadmin` role in Cloud Portal |
| 404 | Wrong `API_BASE_URL` | Check environment URL in Cloud Portal |

---

## Notes

- After calling this action, re-fetch `get-unread-notifications` to update the badge count to 0.
- In React Query, invalidate the `['notifications']` query key after a successful mutation.
