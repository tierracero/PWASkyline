# Dedicated Trip location picker

Date: 2026-10-01

## PLAN — reviewed against current source

- Source scope: the user-owned new `TripControler+AddLocation.swift` and only `CreateTripView.selectLocation` in the already modified `TripControler+CreateTripView.swift`.
- Documentation scope: a verified implementation note in `.agent/architecture/SWIFWEB_APP_ARCHITECTURE.md` and a file-ownership entry in `.agent/SOURCE_MAP.md`.
- Architecture IDs: SWWEB-001, SWWEB-002, SWWEB-003; API-003 supports focused review of the existing fiscal-location selection. No architecture boundary, payload, or API contract changes.
- Store `viewType` on `TripControlerAddLocation`; derive the origin/destination icon and Spanish selection title from it. Move the copied ViewType enum onto this dedicated class.
- Specialize mutable `items` and every item-related closure/initializer parameter to `FiscalLocationBase`. Retain configurable row formatting and optional avatars for future location-specific properties.
- Route origin/destination selection to the dedicated picker using the existing origin/destination arrays. Preserve callbacks to `configureLocation` and `manageDestination`.
- Preserve theme order (Trip beta then crystal trip), selection/creation/close behavior, and all unrelated pending work including the generic picker and tabs container.
- Completion: source and caller review, comparison with pre-edit copies, whitespace/diff review, and git status. No builds/tests without user confirmation.

## Review

The dedicated class currently contains unresolved generic `Item` references, uninitialized icon/title assignments, and an enum extension attached to the generic picker. Specializing these resolves the incomplete extraction without changing fiscal data or adding speculative special attributes.

## AUDIT — source/diff review

- Compared both source files against pre-edit copies. AddLocation changes are limited to concrete location typing, viewType-owned presentation, and removal of the obsolete copied caller comment. CreateTripView changes only the picker class and header arguments inside `selectLocation`.
- Reviewed `.origin`/`.destination` title and icon switches and verified both referenced PNG assets exist under `Sources/Service/skyline/media`.
- Reviewed selection and creation callbacks: existing location configuration and creation paths remain unchanged. Theme application remains Trip beta first, crystal `.trip` second.
- Scoped tracked-file `git diff --check` passed; untracked AddLocation comparison reported no whitespace errors. `git diff --no-index` returns 1 because files differ.
- Updated source ownership and the UI architecture's verified facts. No architecture boundary rule changes, backend changes, new dependencies, or public outputs.
- Git status matches the initial pending work plus the source-map update and this artifact. AddLocation remains user-owned/untracked; pre-existing changes in CreateTripView and UI architecture docs were preserved. Generic AddElement and the pending tabs container were untouched.
- Builds/tests and browser validation were not run; no build/test permission was provided. Compilation and runtime presentation remain unverified.
