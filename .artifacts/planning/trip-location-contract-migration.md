# Trip location contract migration

Reviewed plan — 2026-10-02

## Scope and contract evidence

- Review the last three commits in local TCFireSignal (d4f63d6, 32d5718, 0f30242) and TCFundamentals (b0e79e6, 4184b86, 20f0724).
- Existing app asset code already uses Section/SubSection and the corrected status description. No asset edits are needed.
- Change only Sources/App/Snippits/TripControler/TripControler+CreateTripView.swift and TripControler+AddLocation.swift for the trip migration; synchronize architecture/API_AND_BACKEND.md and architecture/SWIFWEB_APP_ARCHITECTURE.md facts.
- Architecture IDs: API-001, API-002, API-003, SWWEB-001, SWWEB-003. No boundary-rule changes.

## Implementation

1. Store origin/destination and selected locations as CustCommercialTripsComponents.TripLocation and submit those snapshots directly.
2. Restore picker selection by constructing TripLocation from a saved FiscalLocationBase (.location, locationId = base.id).
3. Receive TripLocation directly in CreateTripView. Preserve arbitrary source types and nullable linked IDs through editor round trips.
4. Keep shared CartaPorteUbicacion, ManageLocationItem, and AddCartaPorteMerchendise unchanged by adapting only at their boundaries. Synthetic UUIDs for legacy UI objects are not source IDs and never enter submitted TripLocation payloads.
5. Match linked sources by source type plus linked ID; for unlinked stops match source type plus placement ID. Saved-base updates/deletes apply only to .location sources. Keep route metadata synchronization.
6. Preserve existing create behavior and empty store/customer callbacks.

## Reviewed completion criteria / audit

- Each snapshot field is retained between picker, editor, state, and create request.
- No FiscalLocationItem origin/destination state remains; FiscalLocationItem is limited to adapters for unchanged legacy consumers.
- No old asset type/status names remain in app source.
- Review task-only diff against pre-edit snapshots and git status; no unrelated source changes.
- No builds or tests without explicit user confirmation; perform source/diff inspection and report this limitation.

Plan review: direct payload ownership fits the new dependency contract, while localized legacy adapters honor the requested view-only migration. Optional source IDs must not be inferred from legacy UI UUIDs.

## Audit outcome

- Reviewed all six dependency diffs. App source has no remaining CustCommercialAssetsLocation/SubLocation (including protocol) or .desccription references; existing asset work already conforms.
- Reviewed task-only pre/post diff saved in trip-location-contract-migration.diff: only the two scoped Swift sources and two architecture fact paragraphs were edited.
- Picker snapshot mapping covers all 17 TripLocation fields; saved sources set .location/base.id, with distance initially nil as before.
- Editor adapter mapping covers all 17 fields in both directions. ManageLocationItem preserves locationType/locationId; a generated legacy item UUID cannot replace a nil source ID. The framework State<Value> has no Equatable requirement.
- Reviewed linked-source matching: same UUID from different source types remains distinct; different unlinked placement IDs remain distinct. Saved-base update/delete branches are guarded by .location source type.
- Reviewed merchandise boundary: AddCartaPorteMerchendise selects route stops by placementId and uses storeName, both preserved by the local adapter. Creation submits [origin, destination] directly using the existing [TripLocation] API wrapper.
- Empty store/customer methods, location creation callback, and shared legacy view sources are unchanged.
- git diff --check completed successfully for scoped tracked sources/docs. Picker-only diff inspection found no introduced whitespace issues. Git status review found the pre-existing modified/untracked set unchanged, plus this task's transient planning/audit artifacts.
- Builds, tests, and browser execution were not run: the user has not provided the repository-required confirmation for build/test commands. Compilation/runtime behavior remain unverified.
