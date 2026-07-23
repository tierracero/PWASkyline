# WebSocket Skill

Checklist for tasks involving WebSocket connection logic and real-time handlers.

## When to Use

Use before changing files under:

- `Sources/App/Websocket/**`
- `Sources/App/API/WSEndpoint/**`
- UI code that reacts to WebSocket-delivered events

## Checklist

1. Read `architecture/WEBSOCKET_AND_REALTIME.md`.
2. If tokens/session/context are touched, read `architecture/SECURITY_AND_STATE.md`.
3. Identify the message type, handler file, and affected UI/cache state.
4. Check whether the event can arrive duplicated, delayed, or before a cache is loaded.
5. Prefer idempotent updates keyed by stable identifiers.
6. Avoid printing sensitive payload details.
7. Validate with the smallest feasible event-flow test or manual scenario.

## Review Questions

- What happens if the event arrives twice?
- What happens if the user is logged out or context changed?
- Does this handler mutate a global cache? Who owns invalidation?
- Does UI update ordering depend on an API request finishing first?

