# Data Management Frontend

## Module Location

All data management UI lives in `src/modules/data-management/`.

---

## Module Structure

```
src/modules/data-management/
├── components/
│   ├── schema-builder/         ← visual field definition UI
│   │   ├── schema-builder.tsx
│   │   ├── field-row.tsx
│   │   └── field-type-select.tsx
│   ├── file-upload/            ← drag-drop upload with progress
│   │   ├── file-upload.tsx
│   │   ├── upload-progress.tsx
│   │   └── file-drop-zone.tsx
│   └── file-browser/           ← DMS folder/file tree view
│       ├── file-browser.tsx
│       ├── folder-tree.tsx
│       └── file-list.tsx
├── pages/
│   ├── schemas/
│   │   └── schemas-page.tsx    ← schema list
│   ├── schema-detail/
│   │   └── schema-detail-page.tsx  ← fields view, validations
│   └── files/
│       └── files-page.tsx      ← file manager (DMS + S3)
├── hooks/
│   └── use-data-management.tsx ← all data management hooks
├── services/
│   └── data-management.service.ts
├── types/
│   └── data-management.type.ts
└── index.ts
```

---

## Service Layer

### `data-management.service.ts`

Use the shared `https` client from `src/lib/https.ts` (see `core/app-scaffold.md`). No manual token handling needed.

```ts
import https from '@/lib/https'
import axios from 'axios'

const BASE = '/uds/v1'

// Schema
export const getSchemas = (params) => https.get(`${BASE}/schemas`, { params })
export const defineSchema = (payload) => https.post(`${BASE}/schemas/define`, payload)
export const saveSchemaInfo = (payload) => https.post(`${BASE}/schemas/save-info`, payload)
export const saveSchemaFields = (payload) => https.post(`${BASE}/schemas/save-fields`, payload)
export const reloadConfiguration = (projectKey: string) =>
  https.post(`${BASE}/configurations/${projectKey}/reload`)

// DataSource
export const addDataSource = (payload) => https.post(`${BASE}/data-source/add`, payload)
export const updateDataSource = (payload) => https.put(`${BASE}/data-source/update`, payload)

// DataAccess
export const changeSecurity = (payload) => https.post(`${BASE}/schemas/change-security`, payload)
export const createAccessPolicy = (payload) => https.post(`${BASE}/access-policies`, payload)

// DataValidation
export const createValidation = (payload) => https.post(`${BASE}/validations`, payload)
export const getSchemaValidations = (schemaId: string) =>
  https.get(`${BASE}/validations/schema/${schemaId}`)

// Files — S3 pre-signed upload (two-step)
export const getPreSignedUploadUrl = (payload) =>
  https.post(`${BASE}/Files/GetPreSignedUploadUrl`, payload)
export const uploadToS3 = (url: string, file: File) =>
  axios.put(url, file, { headers: { 'Content-Type': file.type } })  // direct S3 — no auth header
export const updateFileInfo = (payload) => https.put(`${BASE}/Files/UpdateFileInfo`, payload)

// Files — DMS upload
export const uploadToDms = (formData: FormData) =>
  https.post(`${BASE}/Files/UploadFile`, formData)  // axios auto-sets multipart Content-Type
export const getDmsFiles = (payload) => https.post(`${BASE}/Files/GetFiles`, payload)
export const createFolder = (payload) => https.post(`${BASE}/Files/CreateFolder`, payload)
export const deleteFile = (payload) => https.delete(`${BASE}/Files/Delete`, { data: payload })
```

---

## Types

### `data-management.type.ts`

```ts
export type SchemaType = 'Collection' | 'SingleObject'
export type FieldType = 'String' | 'Number' | 'Boolean' | 'Date' | 'ObjectId' | 'Object' | 'Array'
export type SecurityType = 'Public' | 'Private' | 'RoleBased'
export type Operation = 'Read' | 'Create' | 'Update' | 'Delete'
export type AccessModifier = 'Public' | 'Private'
export type ValidationType = 'Required' | 'MinLength' | 'MaxLength' | 'Regex' | 'Min' | 'Max' | 'Email' | 'Unique'

export interface SchemaField {
  Name: string
  Type: FieldType
  IsArray: boolean
  IsRequired: boolean
  Description?: string
  DefaultValue?: string
}

export interface Schema {
  id: string
  schemaName: string
  collectionName: string
  schemaType: SchemaType
  description?: string
  fields?: SchemaField[]
  projectKey: string
  createdAt: string
  updatedAt: string
}

export interface DefineSchemaPayload {
  CollectionName: string
  SchemaName: string
  ProjectKey: string
  SchemaType: SchemaType
  Description?: string
}

export interface SaveSchemaInfoPayload {
  SchemaId: string
  Fields: SchemaField[]
  ProjectKey: string
}

export interface AccessPolicy {
  itemId: string
  schemaName: string
  policyName: string
  allowedRoles: string[]
  operations: Operation[]
  projectKey: string
}

export interface ValidationRule {
  Type: ValidationType
  Value?: string
  ErrorMessage: string
}

export interface DmsFile {
  id: string
  name: string
  isFolder: boolean
  parentDirectoryId?: string
  size?: number
  contentType?: string
  accessModifier: AccessModifier
  createdAt: string
  tags?: string[]
}

export interface UploadProgress {
  fileName: string
  progress: number
  status: 'idle' | 'uploading' | 'success' | 'error'
  error?: string
}
```

---

## Hooks

### `use-data-management.tsx`

```tsx
// Schema hooks
export const useGetSchemas = (params) => { ... }
export const useDefineSchema = () => { ... }
export const useSaveSchemaInfo = () => { ... }

// File hooks
export const useUploadFile = () => {
  // Returns { upload, progress, status }
  // Chooses S3 pre-signed or DMS path based on config
}
export const useGetDmsFiles = (parentId?: string) => { ... }
export const useCreateFolder = () => { ... }

// Access policy hooks
export const useChangeSecurity = () => { ... }
export const useCreateAccessPolicy = () => { ... }
export const useGetAccessPolicies = (schemaName: string) => { ... }

// Validation hooks
export const useCreateValidation = () => { ... }
export const useGetSchemaValidations = (schemaId: string) => { ... }
```

---

## Component Patterns

### Schema Builder

The `schema-builder` component renders a dynamic list of field rows. Each row lets the developer define:
- Field name (text input)
- Field type (select from `FieldType` enum)
- IsArray toggle
- IsRequired toggle
- Description (optional)

Use React Hook Form with a `useFieldArray` for managing rows. Validate with Zod — field names must be non-empty and unique.

```tsx
// Example field row structure
const fieldSchema = z.object({
  Name: z.string().min(1, 'Field name is required'),
  Type: z.enum(['String', 'Number', 'Boolean', 'Date', 'ObjectId', 'Object', 'Array']),
  IsArray: z.boolean().default(false),
  IsRequired: z.boolean().default(false),
  Description: z.string().optional(),
})
```

### File Upload

The `file-upload` component supports two upload modes:

**S3 Pre-signed URL flow (preferred for large files):**
1. Call `getPreSignedUploadUrl` → receive `{ url, fileId }`
2. PUT the file binary directly to the S3 URL
3. Track progress via `XMLHttpRequest` `upload.onprogress` event
4. On completion, call `updateFileInfo` with `fileId` and metadata

**Direct DMS upload (for smaller files or DMS-managed storage):**
1. Build `FormData` with File, Name, AccessModifier, ProjectKey
2. POST to `/uds/v1/Files/UploadFile`
3. Track progress via `XMLHttpRequest` `upload.onprogress` event

Always show `<upload-progress>` component during upload. Never block UI during upload.

```tsx
// Progress tracking pattern
const xhr = new XMLHttpRequest()
xhr.upload.onprogress = (e) => {
  if (e.lengthComputable) {
    setProgress(Math.round((e.loaded / e.total) * 100))
  }
}
```

### File Browser

The `file-browser` component renders a split-pane view:
- Left: `folder-tree` — recursive DMS folder hierarchy
- Right: `file-list` — files in selected folder

Load root files on mount (ParentDirectoryId: null). On folder click, load children.
Use skeleton loaders while fetching. Handle empty state with an empty folder message.

---

## Page Patterns

### Schemas Page (`schemas-page.tsx`)

- Load schemas on mount with `useGetSchemas`
- Show `<Skeleton>` while loading
- Render schemas in a `<data-table>` with columns: Name, Collection, Type, Created
- "New Schema" button opens a dialog/drawer with the schema creation form
- Row click navigates to `/data-management/schemas/:id`

### Schema Detail Page (`schema-detail-page.tsx`)

Tabs:
1. **Fields** — renders `schema-builder` populated with existing fields. Save triggers `save-schema-info`.
2. **Validations** — shows validation rules per field. Add/edit opens a form using `create-validation`.
3. **Access Control** — shows current security type and policies. Uses `change-security` and `create-access-policy`.

After any save, call `reload-configuration` to apply GraphQL changes.

### Files Page (`files-page.tsx`)

- Full-page `file-browser` with toolbar
- Toolbar actions: Upload, New Folder, Delete
- Upload opens `file-upload` component
- Delete calls `delete-file` with confirmation dialog

---

## File Upload Flow (Frontend)

```
User selects file
    │
    ▼
getPreSignedUploadUrl({ FileName, ContentType, FolderPath, ProjectKey })
    │
    ▼ returns { url, fileId }
    │
    ▼
PUT file binary to url (with progress tracking)
    │
    ▼
updateFileInfo({ FileId: fileId, Name, Tags, AccessModifier, ProjectKey })
    │
    ▼
Show success toast
```

**Alternative — DMS Upload:**

```
User selects file
    │
    ▼
Build FormData { File, Name, AccessModifier, ProjectKey, ParentDirectoryId? }
    │
    ▼
POST /uds/v1/Files/UploadFile (with progress tracking)
    │
    ▼
Refresh file list (useGetDmsFiles)
    │
    ▼
Show success toast
```

---

## After Schema Changes

Always call `reload-configuration` after:
- `define-schema`
- `save-schema-info`
- `update-schema-info`
- `save-schema-fields`
- `delete-schema`

This applies GraphQL schema changes. Without it, the API will serve stale schema data.

Show a loading indicator while reload is in progress. Block further schema edits until complete.

---

## Error Handling

| Scenario | UI Pattern |
|----------|-----------|
| API 400 | Show field-level errors from `errors` response key |
| API 401 | Trigger token refresh, retry request |
| API 403 | Show "You do not have permission" inline error |
| API 404 | Show "Not found" empty state |
| API 500 | Show `<ErrorAlert>` with retry button |
| Upload failure | Show error in upload-progress with retry |
| Network offline | Show toast "Check your internet connection" |

---

## Route Definitions

```tsx
// routes/data-management.route.tsx
{
  path: '/data-management',
  children: [
    { path: 'schemas', element: <SchemasPage /> },
    { path: 'schemas/:id', element: <SchemaDetailPage /> },
    { path: 'files', element: <FilesPage /> },
  ]
}
```
