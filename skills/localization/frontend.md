# Localization — Frontend Guide

This file extends `core/frontend.md` with localization-specific patterns for the localization skill.
Always read `core/frontend.md` first, then apply the overrides and additions here.

---

## Module Structure

All localization UI lives inside `src/modules/localization/`:

```
modules/localization/
├── components/
│   ├── language-list/           ← table of languages with default badge and delete
│   ├── language-form/           ← add/edit language form
│   ├── module-list/             ← list of translation modules
│   ├── module-form/             ← add/edit module form
│   ├── key-list/                ← paginated, filterable key table
│   ├── key-form/                ← create/edit key with per-language translation inputs
│   ├── key-timeline/            ← version history drawer/modal for a key
│   ├── translate-progress/      ← progress indicator for AI translate-all
│   └── import-export/           ← file upload and export controls
├── pages/
│   ├── languages/               ← language management page
│   ├── modules/                 ← module management page
│   ├── keys/                    ← key management page (main localization editor)
│   └── settings/                ← webhook and project-level config
├── hooks/
│   └── use-localization.tsx     ← all localization mutations and queries
├── services/
│   └── localization.service.ts  ← raw API calls (no state logic)
└── types/
    └── localization.type.ts     ← TypeScript types for all payloads and responses
```

---

## State Management

Use **Zustand** for localization UI state (selected module, active language filter). No persistence needed.

```typescript
// src/state/store/localization/index.tsx
interface LocalizationState {
  selectedModuleId: string | null
  activeLanguageCode: string | null
  setSelectedModule: (moduleId: string | null) => void
  setActiveLanguage: (code: string | null) => void
}
```

Server state (languages, modules, keys) is managed via React Query — no duplication in Zustand.

---

## HTTP Client

Use the shared `https.ts` client from `src/lib/https.ts`. Localization endpoints require the same authenticated headers:

```typescript
headers: {
  'Authorization': `Bearer ${accessToken}`,  // from Zustand auth store
  'x-blocks-key': import.meta.env.VITE_X_BLOCKS_KEY,
  'Content-Type': 'application/json',
}
```

For file import (multipart), set `Content-Type` to `multipart/form-data` and pass a `FormData` object.

---

## Key List Component

The key list is the central UI. It must support:
- Pagination (page number + page size controls)
- Search by key name
- Filter by language code (dropdown)
- Toggle "untranslated only" checkbox
- Inline editing of translation values per language column
- Actions column: edit (opens key-form), delete (confirmation dialog), view history

```tsx
<KeyList
  projectKey={projectKey}
  moduleId={selectedModuleId}
  languages={languages}
/>
```

---

## Language Selector

The active language filter is a `<Select>` populated from `useGetLanguages`. Show language name + code badge.

---

## AI Translation

When `translate-all` is triggered:
- Show a loading state on the "Translate All" button
- Poll or use optimistic update to refresh the key list after completion
- Show a success toast with count of keys translated

When `translate-key` is triggered:
- Show inline loading on the specific key row
- Update the key's translation value in-place on success

---

## File Import

Use a drag-and-drop file input or a `<input type="file" accept=".json">`.

Before uploading:
1. Validate the file is `.json`
2. Show a preview of key count from the parsed file
3. Require the user to select a module and language before upload

After upload: invalidate the keys query and refresh the list.

---

## File Export / Download

Export triggers a POST to `export-uilm`, then download the resulting file.
GetUilmFile returns raw JSON — trigger a browser download using `URL.createObjectURL`.

---

## Hooks Pattern

All localization data operations use React Query. Centralize in `use-localization.tsx`:

```typescript
export const useGetLanguages = (projectKey: string) => useQuery({
  queryKey: ['languages', projectKey],
  queryFn: () => localizationService.getLanguages(projectKey),
})

export const useSaveLanguageMutation = () => useMutation({
  mutationFn: (payload: SaveLanguagePayload) => localizationService.saveLanguage(payload),
})

export const useGetKeys = (params: GetKeysParams) => useQuery({
  queryKey: ['keys', params],
  queryFn: () => localizationService.getKeys(params),
})

export const useTranslateAllMutation = () => useMutation({
  mutationFn: (payload: TranslateAllPayload) => localizationService.translateAll(payload),
})
```

Rules:
- One hook per API operation
- Service functions are pure (no state)
- Invalidate related queries on successful mutations (`languages`, `modules`, `keys`)
- Always handle `onError` to show user-facing error messages

---

## TypeScript Types

Define all payload and response types in `localization.type.ts`:

```typescript
// Language
export interface SaveLanguagePayload { id?: string; name: string; code: string; projectKey: string }
export interface Language { id: string; name: string; code: string; isDefault: boolean; projectKey: string }

// Module
export interface SaveModulePayload { id?: string; name: string; projectKey: string }
export interface TranslationModule { id: string; name: string; projectKey: string }

// Key
export interface Translation { languageCode: string; value: string }
export interface SaveKeyPayload { id?: string; keyName: string; moduleId: string; projectKey: string; translations: Translation[] }
export interface SaveKeysPayload { projectKey: string; moduleId: string; keys: Array<{ keyName: string; translations: Translation[] }> }
export interface TranslationKey { id: string; keyName: string; moduleId: string; projectKey: string; translations: Translation[] }

// Filters
export interface GetKeysParams {
  projectKey: string
  moduleId: string
  pageNumber: number
  pageSize: number
  filter?: { search?: string; languageCode?: string; untranslatedOnly?: boolean }
}

// Translate
export interface TranslateAllPayload { projectKey: string; moduleId: string }
export interface TranslateKeyPayload { keyId: string; projectKey: string; languageCode: string }

// Import / Export
export interface ExportUilmPayload { projectKey: string; moduleIds: string[] }
export interface RollbackKeyPayload { keyId: string; timelineId: string; projectKey: string }
```

---

## Route Definitions

```typescript
// src/routes/localization.route.tsx
const localizationRoutes = [
  { path: '/localization/languages',  element: <LanguagesPage /> },
  { path: '/localization/modules',    element: <ModulesPage /> },
  { path: '/localization/keys',       element: <KeysPage /> },
  { path: '/localization/settings',   element: <LocalizationSettingsPage /> },
]
```

All localization routes are protected — wrap with `<ProtectedRoute>`.

---

## Error Handling

```typescript
const LOCALIZATION_ERROR_MAP = {
  LANGUAGE_ALREADY_EXISTS: 'A language with this code already exists',
  MODULE_ALREADY_EXISTS: 'A module with this name already exists',
  KEY_ALREADY_EXISTS: 'A key with this name already exists in this module',
  TRANSLATION_FAILED: 'AI translation failed. Please try again.',
}
```

Rules:
- Show validation errors inline below the relevant field
- Show API-level errors in an `<ErrorAlert />` component
- Never expose raw error codes to the user
