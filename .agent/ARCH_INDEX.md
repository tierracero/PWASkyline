# Architecture Index

Authoritative routing and ownership index for PWASkyline architecture chunks.

## Architecture ID Namespace

Each architecture boundary rule has a unique ID owned by exactly one chunk. Routers may cite IDs but must not restate their full rule text as alternate authority.

## Current ID Ownership

| ID | Owning Chunk | Rule Summary |
|---|---|---|
| `APP-001` | `architecture/APP_AND_PLATFORM.md` | PWASkyline is a Swift Web PWA, not a native app package. |
| `APP-002` | `architecture/APP_AND_PLATFORM.md` | Two Swift executable targets: `App` and `Service`. |
| `APP-003` | `architecture/APP_AND_PLATFORM.md` | Verified facts and planned work must remain separate. |
| `SWWEB-001` | `architecture/SWIFWEB_APP_ARCHITECTURE.md` | Browser UI is owned by the `App` target. |
| `SWWEB-002` | `architecture/SWIFWEB_APP_ARCHITECTURE.md` | Route and theme changes must preserve existing Swift Web lifecycle. |
| `SWWEB-003` | `architecture/SWIFWEB_APP_ARCHITECTURE.md` | UI state cannot become hidden server-data authority. |
| `API-001` | `architecture/API_AND_BACKEND.md` | API wrappers own client-side request/response contracts. |
| `API-002` | `architecture/API_AND_BACKEND.md` | Backend contract drift requires explicit review. |
| `API-003` | `architecture/API_AND_BACKEND.md` | Fiscal/payment flows require focused verification. |
| `WS-001` | `architecture/WEBSOCKET_AND_REALTIME.md` | WebSocket handlers are ordered event processors. |
| `WS-002` | `architecture/WEBSOCKET_AND_REALTIME.md` | Duplicate or replayed real-time messages must be safe. |
| `PWA-001` | `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md` | `Service` target owns service worker and manifest behavior. |
| `PWA-002` | `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md` | `DevPublic` and `DistPublic` are output/deployable trees. |
| `PWA-003` | `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md` | Resource path changes must preserve service-worker and deep-link behavior. |
| `SEC-001` | `architecture/SECURITY_AND_STATE.md` | Tokens, sessions, and permissions require explicit handling. |
| `SEC-002` | `architecture/SECURITY_AND_STATE.md` | Browser storage must not leak secrets or stale authority. |
| `STATE-001` | `architecture/SECURITY_AND_STATE.md` | Global caches must have clear ownership and invalidation. |

## Task-Type-to-Chunk Routing

| Task Type | Primary Chunk | Supporting Chunks |
|---|---|---|
| Product identity or target layout | `APP_AND_PLATFORM` | `PRODUCT_SCOPE`, `MODULES` |
| Swift Web UI / route / theme | `SWIFWEB_APP_ARCHITECTURE` | `SECURITY_AND_STATE`, `PWA_ASSETS_AND_SERVICE_WORKER` |
| API endpoint wrapper | `API_AND_BACKEND` | `SECURITY_AND_STATE` |
| Fiscal, payment, Carta Porte | `API_AND_BACKEND` | `SECURITY_AND_STATE` |
| WebSocket event flow | `WEBSOCKET_AND_REALTIME` | `API_AND_BACKEND`, `SECURITY_AND_STATE` |
| Service worker / manifest / static assets | `PWA_ASSETS_AND_SERVICE_WORKER` | `APP_AND_PLATFORM` |
| Session, tokens, browser storage, permissions | `SECURITY_AND_STATE` | `API_AND_BACKEND`, `WEBSOCKET_AND_REALTIME` |

## Architecture Change Rule

Any change that alters a boundary rule must update the owning chunk and this index in the same task.

