# Action: get-users

## Purpose

List users with pagination, sorting, and filtering.

---

## Endpoint

```
POST $VITE_API_BASE_URL/idp/v1/Iam/GetUsers
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Iam/GetUsers" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "page": 1,
    "pageSize": 20,
    "sort": {
      "field": "createdDate",
      "order": "desc"
    },
    "filter": {
      "search": "",
      "isActive": true
    },
    "projectKey": "'$VITE_X_BLOCKS_KEY'"
  }'
```

---

## Request Body

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| page | integer | yes | Starts at 1 |
| pageSize | integer | yes | Number of results per page |
| sort.field | string | no | Field to sort by |
| sort.order | string | no | asc \| desc |
| filter.search | string | no | Search by name or email |
| filter.isActive | boolean | no | Filter by active status |
| projectKey | string | yes | Use $VITE_X_BLOCKS_KEY |

---

## On Success (200)

Returns paginated list of users with total count.

---

## On Failure

* 401 — run refresh-token then retry
