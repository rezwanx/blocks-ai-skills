# Action: check-email-available

## Purpose

Check if an email address is available (not already registered).

---

## Endpoint

```
GET $VITE_API_BASE_URL/idp/v1/Iam/IsEmailAvaiable
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Iam/IsEmailAvaiable?email=user@example.com" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required |
|-------|------|----------|
| email | string | yes |

---

## On Success (200)

Returns boolean — `true` if available, `false` if already taken.
