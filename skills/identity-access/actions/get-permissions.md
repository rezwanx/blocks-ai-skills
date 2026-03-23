# Action: get-permissions

## Purpose

List permissions with pagination.

---

## Endpoint

```
POST $VITE_API_BASE_URL/idp/v1/Iam/GetPermissions
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Iam/GetPermissions" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "page": 1,
    "pageSize": 20,
    "sort": {
      "field": "name",
      "order": "asc"
    },
    "filter": {},
    "projectKey": "'$VITE_X_BLOCKS_KEY'"
  }'
```

---

## Request Body

| Field | Type | Required |
|-------|------|----------|
| page | integer | yes |
| pageSize | integer | yes |
| sort | object | no |
| filter | object | no |
| projectKey | string | yes |

---

## On Success (200)

Returns paginated list of permissions.

---

## On Failure

* 401 — run refresh-token then retry
