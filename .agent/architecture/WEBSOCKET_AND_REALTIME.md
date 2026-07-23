# WebSocket and Realtime Boundaries

Authoritative rules: `WS-*`.

## Verified Facts

- WebSocket handlers live under `Sources/App/Websocket/**`.
- WebSocket API endpoint helpers also exist under `Sources/App/API/WSEndpoint/**`.
- Message areas include chat, task authorization, social profile/page notifications, mobile camera/scanner/OCR, async file/image processing, and order/status updates.

## Rules

### WS-001 — Ordered Event Processing

WebSocket handlers are event processors. Changes must preserve message ordering assumptions and avoid race conditions with API-loaded state and UI caches.

### WS-002 — Duplicate-Safe Handling

Handlers should be safe when the same event is delivered twice or arrives after stale UI/API state. If idempotency is unclear, record an open decision before broad changes.

## Implementation Guidance

- Keep handler files focused by message type.
- Update UI only after validating token/account/order/chat context.
- Prefer idempotent updates keyed by server identifiers, UUIDs, room tokens, message IDs, or task IDs.
- Do not assume a global cache is populated unless the code path verifies it.

