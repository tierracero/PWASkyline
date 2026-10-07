# Manage subcustomer account

Reviewed plan — 2026-10-05

Primary skill: Swift Web UI; supporting API endpoint checklist. IDs SWWEB-001/SWWEB-003/API-001/API-002. No architecture boundary changes.

Scope: rename CreateNewSubCustomerDataView.swift/class to ManageSubCustomerAccountView; update SearchSubCustomerView, TripControler+AddLocation's search call, addToDom glass registration, SOURCE_MAP/MODULES and owning UI/API architecture facts.

Implementation:
1. Preserve creation initializer with a stored requierFullAddress flag; add the requested edit initializer receiving parent, existing CustSubAcct, flag and callback. Prefill every submitted field and preserve status. Update labels for create/edit modes.
2. Use existing create endpoint for new accounts. Edit uses update with the source UUID and status, then load(.id) for the authoritative returned CustSubAcct; validate parent/identity and required address before completion. Keep failure retry available and callbacks guarded against removed forms.
3. Centralize the complete-subaccount predicate in the manager: nonblank street/colony/city/state/country/zip, finite latitude/longitud within geographic bounds. Save validates the same requirements. Required address lookup uses ManualAddressSearch's existing coordinate entry/reverse-geocoder flow and accepts coordinate results, rejecting postal-only results. Preserve optional-address mode and coordinate search-term prefills.
4. Search initializer accepts requierFullAddress (default false), passes it through create/edit forms, and checks selected items. Incomplete required items show a Spanish alert and open the prefilled editor; return only after successful validated save. Remove premature search removal in single/empty result branches so asynchronous child callbacks can complete and cancellation can return to search. Avoid duplicate editor presentation while one is open.
5. Trip location search explicitly requires complete address/coordinates. Keep the manager on the crystal glass host and synchronize stable docs after implementation.

Plan review: update returns APIResponse only, while load returns CustSubAcct; do not invent an update response object. Shared wire longitude remains longitud. The current search's explicit remove calls invalidate both its own creation and deferred edit callbacks and must be removed. Existing user changes in the creation form (hidden username/title, disabled coordinate inputs, coordinate term lookup) remain preserved.

Completion: reviewed task-only diff, request/response and parent/ID validation, create/edit/search callback and cancellation paths, flag/address/coordinate checks, obsolete-name scan, focused whitespace checks, status and staged-index preservation. Builds/tests need explicit user confirmation and remain unauthorized.

Audit refinement reviewed before mutation: when create succeeds but its returned record fails required-address validation, retain that record's identity so retrying saves updates the existing subaccount rather than creating a duplicate. Mode labels should reflect the retained record. No new endpoint or scope is required.

## Audit result

- Reviewed the task-only before/after diff, including the renamed form. No references to CreateNewSubCustomerDataView remain in Sources or stable .agent docs. The original source was untracked; its bytes were backed up before the authorized rename. Standard addToDom still gives the manager its glass host.
- Both initializers store the parent and required-address flag. The edit initializer prefills all shared update fields and coordinates; the update request retains the source ID/status and guards parent identity. Successful update is followed by load(.id); completion requires matching ID/parent and, when requested, full address/coordinates. API failures clear saving state and do not fire completion. Create retains its outer/inner status and parent checks. A successful create record is retained before required-address validation so retry saves can update it rather than create another account.
- Reviewed required vs optional address behavior. One predicate requires all six nonblank address strings, finite latitude in [-90,90], and longitude in [-180,180]; valid zero coordinates are accepted. Save and server-return validation share this predicate with search. Required lookup reverse-geocodes existing valid coordinates or opens coordinate entry, rejects postal-only callback data, and exposes required coordinate labels. Optional lookup keeps postal selection and clears old coordinates. Coordinate search-term loading runs after attachment and rejects invalid numeric/range input.
- Traced all search paths: zero results -> type chooser -> create manager with propagated flag -> selection; one/multiple results -> selection -> complete if valid or Spanish alert/edit manager if incomplete -> validated updated selection. Premature search removal is gone; only successful final selection marks completion/removes search. Editor callbacks clear the weak editor reference before reselecting; live-editor checks prevent duplicate editing. Cancellation allows search to remain available, and removed-search callbacks are guarded.
- TripControlerAddLocation now requests full address/coordinates. UI/API/source-map/module facts reflect the manager name and behavior. No endpoint or theme implementations were changed.
- All eight task-only source/document no-index whitespace comparisons emitted no diagnostics (exit 1 means files differ). The cached binary diff SHA-256 is unchanged. Git-status comparison shows only this task's artifacts and authorized untracked form rename added/removed; pre-existing staged and unrelated source edits remain intact.
- No builds, tests, or live browser/API validation were run because repository rules require explicit user confirmation. Compilation and runtime rendering/API behavior remain unverified.
