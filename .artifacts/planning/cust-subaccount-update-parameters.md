# CustSubAcct update parameter convention

Reviewed plan — 2026-10-03

Primary skill: `.agent/skills/api_endpoint_skill.md`. Architecture owner: API_AND_BACKEND; affected IDs API-001/API-002. No boundary change.

## PLAN

- Change only `CustSubAcct+Update.swift` to expose labeled fields in the shared UpdateRequest initializer order, matching the current create wrapper convention, and construct the shared request inside sendPost.
- Preserve field types, the `longitud` wire key, POST routing, callback signature, and decoding/failure behavior. No update callers exist in Sources/App.
- Correct the existing API architecture statement about create/update accepting request objects directly, preserving surrounding user edits.
- Review field coverage against the local TCFireSignal UpdateRequest, focused diffs, whitespace, and git status. Do not run builds or tests without user confirmation.

## Plan review

The shared UpdateRequest contains id, the create-style data fields, optional coordinates, and status. Explicit forwarding preserves the backend contract and follows the user's current create convention. Completion requires all 21 fields forwarded by matching names/types, no unrelated source edits, and a documented verification limitation.

## AUDIT

- Reviewed the update source against the local TCFireSignal UpdateRequest: all 21 fields have matching labels, types, order, and forwarding values. Optional coordinates follow the create wrapper's required optional-argument convention.
- Response decoding, nil failure handling, route/version, and update POST action remain unchanged. No update call sites require migration.
- Scoped tracked documentation whitespace check passed; the untracked update file's no-index whitespace check produced no diagnostics. The broader working tree has existing whitespace issues in unrelated user-edited files; these were preserved.
- Reviewed the documentation diff and final git status against the initial status: task changes are confined to update source, the existing subaccount documentation statement, and this plan/audit artifact.
- Builds and tests were not run because explicit user confirmation was not provided. Compilation and runtime behavior remain unverified.
