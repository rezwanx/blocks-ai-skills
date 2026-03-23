# Environment Configuration

## Variables

| Variable | Type | Description |
|----------|------|-------------|
| VITE_API_BASE_URL | fixed | Base URL of SELISE Blocks API |
| VITE_X_BLOCKS_KEY | fixed | Blocks API key (x-blocks-key header) |
| VITE_BLOCKS_OIDC_CLIENT_ID | fixed | OIDC client ID for authentication |
| VITE_BLOCKS_OIDC_REDIRECT_URI | fixed | OIDC redirect URI after login |
| VITE_PROJECT_SLUG | fixed | Project identifier slug |
| VITE_CAPTCHA_SITE_KEY | fixed | reCAPTCHA site key |
| VITE_CAPTCHA_TYPE | fixed | Captcha type (e.g. reCaptcha) |
| VITE_PRIMARY_COLOR | fixed | Primary theme color (hex or hsl) |
| VITE_SECONDARY_COLOR | fixed | Secondary theme color (hex or hsl) |
| GENERATE_SOURCEMAP | fixed | Build config — set to false in production |
| USERNAME | cli-only | Developer username — for CLI/Claude direct API calls only |
| PASSWORD | cli-only | Developer password — for CLI/Claude direct API calls only |
| ACCESS_TOKEN | runtime | Obtained after authentication — use as Bearer token |
| REFRESH_TOKEN | runtime | Obtained after authentication — use to renew access token |

---

## Example .env

```
# Vite environment variables
VITE_API_BASE_URL=https://dev-api.seliseblocks.com
VITE_X_BLOCKS_KEY=your_blocks_key
VITE_CAPTCHA_SITE_KEY=your_captcha_site_key
VITE_CAPTCHA_TYPE=reCaptcha
VITE_PROJECT_SLUG=your_project_slug

VITE_BLOCKS_OIDC_CLIENT_ID=your_oidc_client_id
VITE_BLOCKS_OIDC_REDIRECT_URI=your_redirect_uri

# Build configuration
GENERATE_SOURCEMAP=false

# Theme Colors
VITE_PRIMARY_COLOR=#15969B
VITE_SECONDARY_COLOR=#5194B8

# Credentials for authentication
USERNAME=your_username
PASSWORD=your_password

# Populated at runtime after authentication
ACCESS_TOKEN=
REFRESH_TOKEN=
```

---

## Usage

All API calls use ACCESS_TOKEN as bearer and VITE_X_BLOCKS_KEY as tenant header:

```bash
curl -X GET "$VITE_API_BASE_URL/api/resource" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-blocks-key: $VITE_X_BLOCKS_KEY"
```

---

## Rules

* Store all values in .env file
* Do not commit .env to version control
* Never expose ACCESS_TOKEN or REFRESH_TOKEN in frontend code
* VITE_X_BLOCKS_KEY and VITE_BLOCKS_OIDC_CLIENT_ID are fixed — do not change per request
* USERNAME and PASSWORD are for CLI/Claude operations only — never used by the frontend
* Frontend always gets credentials from user input (login form), never from env vars
* Variables without VITE_ prefix are not exposed to the browser by Vite
* ACCESS_TOKEN and REFRESH_TOKEN are populated at runtime by the get-token action
