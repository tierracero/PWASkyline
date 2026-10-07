# CustSubAcct browser endpoint integration

Reviewed plan — 2026-10-02

Primary skill: API endpoint checklist. Primary architecture API_AND_BACKEND, supporting SECURITY_AND_STATE. IDs API-001/API-002/API-003/SEC-001. Existing boundary rules remain unchanged.

## Evidence and scope

Reviewed TCFireSignal cd0b774, 7840b75, d4f63d6 and TCFundamentals a733e77, e8848ef, 49f3bfe. Also checked the matching local SkylineServer CustSubAcctEndpoint handlers. Create/load return generic response envelopes, update APIResponse, search GET a raw [CustSubAcct]. Shared CreateRequest/UpdateRequest preserve the wire key `longitud`, and load uses HybridIdentifier. CustSubAcct now conforms to Payloadable.

The app already carries latitude/longitude through commercial-trip locations, saved-location endpoints, and their editors/adapters. New deliveredAt fields are optional with initializer defaults; the app has no local CustOrderProtocolable/CustFolioObjectsProtocolable conformers or direct CustFolio/CustFolioObjects rebuilding constructors to migrate.

## Implementation

- Add Sources/App/API/CustSubAcctEndpoint/CustSubAcctEndpoint.swift: .custSubAcct route, .v1 version on shared CustSubAcctComponents.
- Add CustSubAcct+Create.swift and CustSubAcct+Update.swift with shared request payload arguments plus completion callbacks, sent via the centralized authenticated POST transport. No duplicate local request models or omitted fields.
- Add CustSubAcct+Load.swift using HybridIdentifier and the shared request/response types.
- Add CustSubAcct+Search.swift using authenticated GET query fields custAcct, term, token, user, key. Reuse baseAPIUrl for the established authentication query, strictly percent-encode custAcct/term, use the existing development-mode server selection and application/WSId headers, register event handlers before sending, and distinguish failure (nil) from a valid empty list. Preserve the searched term in the callback. Do not print URLs, credentials, or response data.
- Register API.custSubAcctV1 in Sources/App/API/API.swift and .custSubAcct in Sources/App/Enums/ServerRouts.swift.
- Update .agent/architecture/API_AND_BACKEND.md, .agent/SOURCE_MAP.md, and .agent/MODULES.md to reflect the new domain.
- Keep subaccount/customer UI workflows pending; this request implements the new API capabilities without inventing additional UI behavior.

## Plan review and completion

Request and response shapes are verified against shared packages and server source. Payload-based create/update methods mirror the package signatures and preserve all current/future request fields. Search must remain GET rather than using the POST-only helper. Focused wrappers avoid unrelated transport refactors. Review all new sources and task-only diffs, verify registrations and contract field coverage, and inspect git status. No builds/tests without explicit user confirmation.

## Audit result

- Reviewed the last three commits of each dependency and the SkylineServer route registration: POST create/update/load and GET search under custSubAcct/v1 match the new wrappers.
- Reviewed all five new source files and the task-only diff (cust-subaccount-endpoints.diff). Only API alias/route registration, the new endpoint directory, and the three scoped documentation entries were changed by this task.
- Create/update forward shared request objects unchanged, including optional latitude and the exact `longitud` wire key; create/load preserve generic envelopes and update decodes APIResponse. Load constructs the shared HybridIdentifier request.
- Search sends the required parent-account ID and term through GET, with the established baseAPIUrl session query and application/WSId headers. Strict query encoding handles delimiter characters and UTF-8 in the term. Development-mode hosts match the authenticated POST transport. No URL, token, or response-body logging was added.
- Reviewed GET failure handling: non-2xx status, missing body, decode errors, network errors, timeout, and abort all return nil; successful [] stays distinct. Event handlers are installed before sending, and a completion gate prevents duplicate callbacks.
- Trip/saved-location coordinate arguments are already present in wrappers, editors, and local adapters; no migration was necessary. New deliveredAt fields have compatible optional defaults, and no app conformers/constructors require updates. CustSubAcct Payloadable conformance is supplied by the dependency.
- git diff --check passed for scoped tracked files. New-file no-index whitespace checks produced no diagnostics (exit 1 represents new-file differences). Git status showed only the planned registrations/new endpoint directory and task artifacts added to the existing modified/untracked set.
- Builds, tests, and live endpoint calls were not run because the repository requires explicit build/test confirmation; compilation and runtime requests remain unverified.
