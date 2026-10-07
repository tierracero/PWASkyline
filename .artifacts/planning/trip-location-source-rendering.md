# Trip location source rendering

Reviewed plan — 2026-10-02

Primary skill: api_endpoint_skill.md; supporting Swift Web UI checklist. Architecture IDs API-001/API-002/API-003, SWWEB-001/SWWEB-002, STATE-001. No rule changes.

Scope: TripControler/TripControler+AddLocation.swift, plus verified architecture facts in API_AND_BACKEND.md and SWIFWEB_APP_ARCHITECTURE.md. Preserve existing user edits, including geolocation additions and account injection.

1. Wire the prepared SelectStore callback to renderLocation(store) and mount it with addToDom. Customer search remains pending.
2. Store rendering creates a .store TripLocation with storePrefix + final UUID segment, store address/name, parsed lat/lon, and placement type from viewType. Store profiles are selected by store.fiscal; missing preferred profiles are fetched with the existing general getProfile API, then fall back to the .account main profile. No global cache mutation. If no profile is available, report exactly `Porfavor  configure el perfil fiscal de la cuenta `.
3. Subaccount rendering creates a .subaccount TripLocation with `sa` + final UUID segment; fiscal identity comes from the injected account, address and latitude/longitud from the subaccount. Reject mismatched parent account IDs.
4. Models lack separate number/reference fields: keep full street, leave number/reference empty. Set uts = getNow(), distance = nil for the existing editor to configure. Match address states against raw enum values, codes, and descriptions with normalized case/spaces/accents; unknown states produce a focused error.
5. Successful rendering invokes the existing callback and dismisses this picker. Profile lookup failures use a cached main profile when available; otherwise emit the requested error and keep the picker available.

Review: getProfile(.general, nil) is the established authenticated profile-list contract; .account explicitly denotes the main profile. Do not use customer-account fiscalProfile as the store issuer profile. Coordinate field names were verified in current shared package sources.

Audit: review task-only diff, full snapshot field mappings, fallback and source-account paths, and git status. No builds or tests without user confirmation.

## Audit result

- Reviewed the task-only diff saved as trip-location-source-rendering.diff. Source changes are confined to the SelectStore wiring and the two render methods plus their profile/state helpers; existing picker callbacks, icons, base-location selection, and user geolocation changes are preserved.
- Verified all 19 TripLocation constructor fields against current TCFireSignal source. Store lat/lon parse into optional Doubles; subaccount.latitude/longitud map directly to latitude/longitude. Store and subaccount source types/linked IDs remain intact.
- Reviewed profile resolution paths: cached linked profile; cached main when no store profile ID; refreshed linked profile; refreshed main; cached main after refresh failure or an unresolved preferred profile; requested error with no result. No global cache writes are introduced.
- Verified FIAccountsType.account denotes Perfil Principal. getProfile(.general, nil) request/response and authentication transport are unchanged.
- Reviewed address-state handling for enum raw values, SAT codes, and display names (case/spaces/diacritics normalized). Unknown values report an error rather than assigning a different state.
- Verified subaccount fiscal fields come from the injected parent account, and address/coordinates come from the selected subaccount. Parent-account mismatch returns before invoking the callback.
- git diff --check passed for edited tracked architecture documents; inspected the untracked source's focused diff and found no introduced trailing whitespace. Git status retained all pre-existing source changes and added only task planning/audit artifacts.
- Builds, tests, and browser execution were not run because repository rules require explicit user confirmation. Compilation/runtime behavior remains unverified.
