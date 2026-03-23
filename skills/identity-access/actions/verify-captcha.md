# Action: verify-captcha

## Purpose

Verify a user's CAPTCHA response before proceeding with a protected action.

---

## Endpoint

```
GET $VITE_API_BASE_URL/idp/v1/Captcha/Verify
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Captcha/Verify?VerificationCode=USER_CAPTCHA_CODE&ConfigurationName=default" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Query Parameters

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| VerificationCode | string | yes | Code entered by the user |
| ConfigurationName | string | yes | Must match the one used in create-captcha |

---

## On Success (200)

Returns `{ "isValid": true }`. Proceed with the protected action.

---

## On Failure

* 200 with `{ "isValid": false }` — wrong answer, show new CAPTCHA
