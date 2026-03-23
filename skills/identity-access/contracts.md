# Identity & Access Contracts

## Common Headers (all authenticated requests)

```
Authorization: Bearer $ACCESS_TOKEN
x-blocks-key: $VITE_X_BLOCKS_KEY
Content-Type: application/json
```

---

## Common Response: BaseResponse

```json
{
  "errors": ["string"],
  "isSuccess": true
}
```

---

## Authentication

### get-token Request (form-encoded)

| Field | Type | Fixed/Dynamic | Value |
|-------|------|---------------|-------|
| grant_type | string | fixed | `password` |
| client_id | string | fixed | $VITE_BLOCKS_OIDC_CLIENT_ID |
| username | string | dynamic | $USERNAME |
| password | string | dynamic | $PASSWORD |

### refresh-token Request (form-encoded)

| Field | Type | Fixed/Dynamic | Value |
|-------|------|---------------|-------|
| grant_type | string | fixed | `refresh_token` |
| client_id | string | fixed | $VITE_BLOCKS_OIDC_CLIENT_ID |
| refresh_token | string | runtime | $REFRESH_TOKEN |

### Token Response

```json
{
  "access_token": "eyJhbGci...",
  "token_type": "Bearer",
  "expires_in": 8000,
  "refresh_token": "538b8ede...",
  "id_token": null
}
```

### LogoutRequest

```json
{
  "refreshToken": "string"
}
```

### GenerateUserCodeRequest

```json
{
  "clientId": "string",
  "codeTtlInMinute": 0,
  "note": "string"
}
```

---

## Users

### CreateUserRequest

```json
{
  "email": "string",
  "userName": "string",
  "password": "string",
  "firstName": "string",
  "lastName": "string",
  "phoneNumber": "string",
  "language": "string",
  "salutation": "string",
  "mailPurpose": "string",
  "userPassType": "Plain | Hashed",
  "userCreationType": "string",
  "varifiedType": "string",
  "platform": "string",
  "profileImageUrl": "string",
  "profileImageId": "string",
  "userMfaType": "Email | Phone | Authenticator",
  "mfaEnabled": false,
  "allowedLogInType": ["Email", "UserName", "Phone", "SocialLogin"],
  "memberships": [],
  "tags": ["string"],
  "projectKey": "string",
  "organizationId": "string"
}
```

### GetUsersRequest

```json
{
  "page": 1,
  "pageSize": 20,
  "sort": {
    "field": "string",
    "order": "asc | desc"
  },
  "filter": {
    "search": "string",
    "isActive": true
  },
  "projectKey": "string"
}
```

### ActivateUserRequest

```json
{
  "code": "string",
  "password": "string",
  "projectKey": "string",
  "mailPurpose": "string",
  "captchaCode": "string",
  "preventPostEvent": false
}
```

### DeactivateUserRequest

```json
{
  "userId": "string",
  "projectKey": "string"
}
```

### ChangePasswordRequest

```json
{
  "oldPassword": "string",
  "newPassword": "string",
  "projectKey": "string"
}
```

---

## Roles

### CreateRoleRequest

```json
{
  "name": "string",
  "description": "string",
  "slug": "string",
  "projectKey": "string"
}
```

### GetRolesRequest

```json
{
  "page": 1,
  "pageSize": 20,
  "sort": {
    "field": "string",
    "order": "asc | desc"
  },
  "filter": {
    "search": "string"
  },
  "projectKey": "string"
}
```

### SetRolesRequest

```json
{
  "userId": "string",
  "roles": ["string"],
  "projectKey": "string"
}
```

---

## Permissions

### CreatePermissionRequest

```json
{
  "name": "string",
  "description": "string",
  "resource": "string",
  "resourceGroup": "string",
  "type": "string",
  "tags": ["string"],
  "dependentPermissions": ["string"],
  "isBuiltIn": false,
  "projectKey": "string"
}
```

### GetPermissionsRequest

```json
{
  "page": 1,
  "pageSize": 20,
  "sort": {
    "field": "string",
    "order": "asc | desc"
  },
  "filter": {},
  "projectKey": "string"
}
```

---

## MFA

### OtpGenerationRequest

```json
{
  "userId": "string",
  "projectKey": "string",
  "mfaType": "Email | Phone | Authenticator",
  "sendPhoneNumberAsEmailDomain": "string"
}
```

### VerifyOtpRequest

```json
{
  "userId": "string",
  "otp": "string",
  "projectKey": "string"
}
```

### DisableUserMfaRequest

```json
{
  "userId": "string",
  "projectKey": "string"
}
```

---

## Captcha

### CreateCaptchaRequest

```json
{
  "configurationName": "string"
}
```

### VerifyCaptchaRequest (query params)

| Param | Type | Required |
|-------|------|----------|
| VerificationCode | string | yes |
| ConfigurationName | string | yes |

---

## Enumerations

| Enum | Values |
|------|--------|
| UserMfaType | Email, Phone, Authenticator, GoogleAuthenticator, MicrosoftAuthenticator |
| UserPassType | Plain, Hashed |
| UserLogInType | Email, UserName, Phone, SocialLogin |
| UserCreationType | Self, Admin, System |
