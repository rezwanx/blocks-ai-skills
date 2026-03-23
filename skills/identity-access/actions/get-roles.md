# Action: get-roles

## Purpose

List roles with pagination, sorting, and filtering.

---

## Endpoint

```
POST $VITE_API_BASE_URL/idp/v1/Iam/GetRoles
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Iam/GetRoles" \
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
    "filter": {
      "search": ""
    },
    "projectKey": "'$VITE_X_BLOCKS_KEY'"
  }'
```

---

## Request Body

| Field | Type | Required |
|-------|------|----------|
| page | integer | yes |
| pageSize | integer | yes |
| sort.field | string | no |
| sort.order | string | no |
| filter.search | string | no |
| projectKey | string | yes |

---

## On Success (200)

Returns paginated list of roles.

---

## On Failure

* 401 — run refresh-token then retry
