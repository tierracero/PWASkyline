# API and Backend Boundaries

Authoritative rules: `API-*`.

## Verified Facts

- Client API wrappers live under `Sources/App/API/**`.
- Endpoint files are grouped by domain and often named `Domain+Action.swift`.
- The app depends on multiple Tierra Cero core packages that likely define shared payloads and contracts.
- The three public `sendPost` overloads share one internal XMLHttpRequest transport that preserves response-body callback compatibility while recording transport failures.
- First-party TierraCero and IntarTC `XMLHttpRequest` transports send the current `custCatchChatConnID` in the `WSId` header so backend work can correlate asynchronous WebSocket updates with the originating browser connection.
- API wrapper decoding is routed through `decodeAPIResponse`, except the recursion-protected error-reporting endpoint response.
- `API.v1.reportError` uses the shared `ReportErrorRequest` contract and a reporting-disabled transport policy.

## Rules

### API-001 — Client Contract Ownership

API wrapper files own client-side request construction, response decoding, callbacks, and error propagation for their domain.

### API-002 — Backend Contract Drift Requires Review

Any change to endpoint paths, payload shape, auth headers, fiscal fields, payment fields, or expected response models must be treated as a backend contract change unless verified against backend/shared package definitions.

### API-003 — Fiscal and Payment Focus

Fiscal, CFDI, Carta Porte, payment, credit, and account-balance flows require especially small diffs and focused verification because mistakes can affect legal/accounting behavior.

## Implementation Guidance

- Preserve exact serialized keys and backend naming conventions.
- Add new endpoints in the matching endpoint folder.
- Avoid introducing generic request abstractions in a feature bugfix unless the task is explicitly an API architecture task.
- For new payloads, verify whether the type already exists in a private package before duplicating it locally.
- Error-report delivery succeeds only after a successful HTTP status, decodable response, and backend `.ok` status; delivery failures update the original persisted record and never create a recursive report.
- Diagnostics use `TCFundamentals.ErrorReportingPriorty` directly (`zero`, `low`, `med`, and `high`) for persistence, queue ordering, and backend delivery.
