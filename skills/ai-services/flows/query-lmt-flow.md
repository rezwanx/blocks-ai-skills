# Flow: query-lmt-flow

## Trigger

User wants to send a prompt to an LLM directly without setting up an agent — one-shot queries, testing prompts, or building custom LLM integrations.

> "send a prompt to GPT"
> "query the language model directly"
> "test a prompt without an agent"
> "call the LLM with a system prompt"
> "stream a response from the model"

---

## Pre-flight Questions

1. Which model should handle the query? (must be a configured model — see `get-models`)
2. Is streaming required? (streaming returns tokens as they're generated; non-streaming waits for the full response)
3. Is there a system prompt to include?
4. Should conversation history be included?

---

## Flow Steps

### Step 1 — Confirm a Model Is Configured

List available models for the project.

```
Action: get-models
Input:  project_key = $VITE_X_BLOCKS_KEY
```

If no models exist → run `manage-models` flow first to configure one.
Store the `model_id` of the target model.

---

### Step 2A — Non-Streaming Query

Send a single prompt and wait for the full response.

```
Action: query-lmt
Input:
  model_id   = model_id from Step 1
  messages   = [
    { "role": "system", "content": "You are a helpful assistant." },
    { "role": "user",   "content": "What is the capital of France?" }
  ]
  project_key = $VITE_X_BLOCKS_KEY

Output:
  response.content → the model's reply
  response.usage   → token counts (prompt_tokens, completion_tokens)
```

```bash
curl --location "$VITE_API_BASE_URL/blocksai-api/v1/ai-agent/query-lmt" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --data '{
    "model_id": "'"$MODEL_ID"'",
    "messages": [
      { "role": "system", "content": "You are a helpful assistant." },
      { "role": "user", "content": "What is the capital of France?" }
    ],
    "project_key": "'"$VITE_X_BLOCKS_KEY"'"
  }'
```

---

### Step 2B — Streaming Query (alternative)

Returns tokens as they are generated using Server-Sent Events.

```
Action: stream-query-lmt
Endpoint: POST /ai-agent/query-lmt/stream
```

```bash
curl --location --no-buffer \
  "$VITE_API_BASE_URL/blocksai-api/v1/ai-agent/query-lmt/stream" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "x-blocks-key: $VITE_X_BLOCKS_KEY" \
  --header "Content-Type: application/json" \
  --header "Accept: text/event-stream" \
  --data '{
    "model_id": "'"$MODEL_ID"'",
    "messages": [
      { "role": "system", "content": "You are a helpful assistant." },
      { "role": "user", "content": "Write a short poem about the ocean." }
    ],
    "project_key": "'"$VITE_X_BLOCKS_KEY"'"
  }'
```

Each SSE event contains a token chunk:
```
data: {"delta": "The", "done": false}
data: {"delta": " ocean", "done": false}
data: {"delta": " roars", "done": false}
data: {"delta": "", "done": true, "usage": {"prompt_tokens": 20, "completion_tokens": 15}}
```

Stop when `done: true`.

---

### Step 3 — Handle Multi-Turn Conversation

To maintain conversation history, accumulate messages and include them in each subsequent call:

```json
{
  "messages": [
    { "role": "system",    "content": "You are a helpful assistant." },
    { "role": "user",      "content": "What is 2+2?" },
    { "role": "assistant", "content": "4" },
    { "role": "user",      "content": "Multiply that by 3." }
  ]
}
```

> For persistent conversation sessions with full session management (save history, retrieve sessions, delete sessions), use `chat-flow` instead. This flow is for stateless or custom-managed conversations.

---

## Error Handling

| Error | Cause | Action |
|-------|-------|--------|
| `404` on query | `model_id` not found | Verify model exists with `get-models` |
| `400` | Missing `messages` or empty array | Include at least one user message |
| `429` | Rate limit exceeded | Wait and retry with exponential backoff |
| `500` | Upstream LLM API error | Check model API key is valid with `validate-model` |
| Stream drops mid-response | Network interruption | Reconnect and resume from last received token |
| Empty `delta` stream events | Model warming up | Normal — wait for first content token |

---

## Frontend Output

| File | Purpose |
|------|---------|
| `modules/ai/components/prompt-playground/prompt-playground.tsx` | Developer tool: system prompt + user message + run button |
| `modules/ai/components/prompt-playground/streaming-output.tsx` | Renders tokens as they stream in |
| `modules/ai/hooks/use-ai.tsx` | `useQueryLmt`, `useStreamQueryLmt` hooks |
| `modules/ai/services/ai.service.ts` | `queryLmt()`, `streamQueryLmt()` implementations |
