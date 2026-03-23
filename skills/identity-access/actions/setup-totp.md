# Action: setup-totp

## Purpose

Setup a TOTP authenticator app (Google Authenticator, Microsoft Authenticator) for the current user. Returns a QR code or secret to scan.

---

## Endpoint

```
GET $VITE_API_BASE_URL/idp/v1/Mfa/SetUpTotp
```

---

## curl

```bash
curl --location "$VITE_API_BASE_URL/idp/v1/Mfa/SetUpTotp" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Request Body

None.

---

## On Success (200)

Returns TOTP setup data including QR code URI and secret key for the authenticator app.

---

## On Failure

* 401 — run refresh-token then retry
