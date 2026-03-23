# Identity & Access Skill

## Purpose

Handles all authentication, user management, role/permission management, MFA, and organization operations for SELISE Blocks via the IDP v1 API.

Must run get-token before any other action in a session.

---

## Base Path

All endpoints are prefixed with: `$VITE_API_BASE_URL/idp/v1`

---

## Action Index

### Authentication
| Action | File | Description |
|--------|------|-------------|
| get-token | actions/get-token.md | Exchange user_code for access + refresh tokens |
| refresh-token | actions/refresh-token.md | Renew access token using refresh token |
| logout | actions/logout.md | Logout current session |
| logout-all | actions/logout-all.md | Logout all active sessions |
| get-user-info | actions/get-user-info.md | Get authenticated user's info |
| generate-user-code | actions/generate-user-code.md | Generate a new user code |
| get-user-codes | actions/get-user-codes.md | List all user codes |

### Users
| Action | File | Description |
|--------|------|-------------|
| create-user | actions/create-user.md | Create a new user |
| update-user | actions/update-user.md | Update user details |
| get-users | actions/get-users.md | List users with pagination and filters |
| get-user | actions/get-user.md | Get a specific user by ID |
| activate-user | actions/activate-user.md | Activate a user account |
| deactivate-user | actions/deactivate-user.md | Deactivate a user account |
| change-password | actions/change-password.md | Change user password |
| recover-user | actions/recover-user.md | Initiate password recovery |
| reset-password | actions/reset-password.md | Reset password using recovery code |
| resend-activation | actions/resend-activation.md | Resend activation email |
| check-email-available | actions/check-email-available.md | Check if email is already taken |
| get-user-roles | actions/get-user-roles.md | Get roles assigned to a user |
| get-user-permissions | actions/get-user-permissions.md | Get permissions assigned to a user |
| get-sessions | actions/get-sessions.md | Get active sessions for a user |
| get-histories | actions/get-histories.md | Get audit history for a user |

### Roles
| Action | File | Description |
|--------|------|-------------|
| create-role | actions/create-role.md | Create a new role |
| update-role | actions/update-role.md | Update an existing role |
| get-roles | actions/get-roles.md | List roles with pagination |
| get-role | actions/get-role.md | Get a specific role |
| set-roles | actions/set-roles.md | Assign roles to a user |

### Permissions
| Action | File | Description |
|--------|------|-------------|
| create-permission | actions/create-permission.md | Create a new permission |
| update-permission | actions/update-permission.md | Update an existing permission |
| get-permissions | actions/get-permissions.md | List permissions with pagination |
| get-permission | actions/get-permission.md | Get a specific permission |
| save-roles-and-permissions | actions/save-roles-and-permissions.md | Bulk assign roles and permissions |
| get-resource-groups | actions/get-resource-groups.md | List all resource groups |

### Organizations
| Action | File | Description |
|--------|------|-------------|
| save-organization | actions/save-organization.md | Create or update an organization |
| get-organizations | actions/get-organizations.md | List all organizations |
| get-organization | actions/get-organization.md | Get a specific organization |

### MFA
| Action | File | Description |
|--------|------|-------------|
| generate-otp | actions/generate-otp.md | Generate an OTP for MFA |
| verify-otp | actions/verify-otp.md | Verify an OTP |
| setup-totp | actions/setup-totp.md | Setup TOTP authenticator app |
| disable-user-mfa | actions/disable-user-mfa.md | Disable MFA for a user |
| resend-otp | actions/resend-otp.md | Resend OTP |

### Captcha
| Action | File | Description |
|--------|------|-------------|
| create-captcha | actions/create-captcha.md | Create a CAPTCHA challenge |
| verify-captcha | actions/verify-captcha.md | Verify a CAPTCHA response |
