# Action: get-user

## Purpose

Get a specific user by ID.

---

## Endpoint

```
GET $VITE_API_BASE_URL/idp/v1/Iam/GetUser
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Iam/GetUser?userId=USER_ID" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required |
|-------|------|----------|
| userId | string | yes |

---

## On Success (200)

Returns full user object including roles, permissions, and profile data.

---

## On Failure

* 401 — run refresh-token then retry
* 404 — user not found
