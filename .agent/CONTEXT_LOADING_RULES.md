# Context Loading Rules

Progressive context-loading strategy for PWASkyline.

## Default Loading Sequence

Load context in this order, escalating only as needed:

1. Root `AGENTS.md`.
2. `.agent/SKILL_INDEX.md`.
3. `.agent/ARCH_INDEX.md`.
4. One primary architecture chunk.
5. At most two supporting architecture chunks.
6. `.agent/SOURCE_MAP.md` before touching source, resources, or build config.
7. Target files only.

## Budget Discipline

- Do not bulk-load all API endpoint files.
- Do not bulk-load all snippet/view files.
- Do not inspect `node_modules`, `.build`, or generated public outputs unless the task specifically requires them.
- Prefer focused search by endpoint name, route, WebSocket message, view class, CSS class, or asset path.

## Task Routing Hints

- UI / Swift Web view task: load `architecture/SWIFWEB_APP_ARCHITECTURE.md` and `skills/swifweb_ui_skill.md`.
- API wrapper task: load `architecture/API_AND_BACKEND.md` and `skills/api_endpoint_skill.md`.
- WebSocket task: load `architecture/WEBSOCKET_AND_REALTIME.md` and `skills/websocket_skill.md`.
- PWA / service worker / public output task: load `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md` and `skills/pwa_build_skill.md`.
- Security, session, token, payment, fiscal, or browser-storage task: load `architecture/SECURITY_AND_STATE.md`.

## Reference Projects

Reference projects are optional and task-specific. Load them only when a task asks for patterns, parity, or dependency behavior. See `.agent/REFERENCE_PROJECTS.md`.

