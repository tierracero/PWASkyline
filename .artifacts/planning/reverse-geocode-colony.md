# Reverse-geocode colony propagation — reviewed plan

Scope: `Sources/App/Snippits/ManualAddressSearch.swift` and its existing owning fact in `SWIFWEB_APP_ARCHITECTURE.md`; SWWEB-001/002/003. Preserve unrelated user modifications and generated resources.

Finding: `normalizeMapkitReversePlace` already sends subLocality/dependentLocalities as colony; ReverseGeocodedAddress decodes that key. The single-result branch copies colony into settlement, then sets city/state, whose listeners call getSettlements/getCities and clear settlement. The parent manager correctly assigns coordinateResult.settlement to its colony state/input. The bug lies between decoding and callback, not in JS normalization.

Implementation: build an immutable CoordinateResult directly from each decoded ReverseGeocodedAddress, retaining requested coordinates and existing street/country fallbacks. Use the same conversion in single and multiple selection paths. Do not copy geocoder values into postal lookup state. Label multiple-result choices with printableAddress and reveal their existing overlay so users can actually select them.

Completion: review user sample mapping colony -> settlement -> parent colony -> bound UTextField and persisted request. Review single/multiple result paths and postal-only behavior. Focused snapshot diff whitespace checks, staged diff hash and git status; source-only changes. The user's static-only preference persists: no build, tests or runtime/browser verification.

Review: direct-snapshot conversion removes the observed listener reset and avoids relying on assignment order or mutable UI state. Scope is approved by self-review within the requested reverse-geocode-to-UI fix.

## Audit

- User-supplied sample contains colony `Luis Echeverría Álvarez`. Source trace: JS normalizeMapkitReversePlace line 2255 -> ReverseGeocodedAddress.colony -> shared coordinateResult settlement -> ManageSubCustomerAccountView.applyAddress colony -> UTextField($colony); update/create requests submit colony.purgeSpaces. No parent colony-reset listener exists. JavaScript normalization and decoding already agree; neither needed changing.
- Single and multiple branches now return the same immutable decoded address conversion. They do not assign city/state/settlement postal-search state, so neither getSettlements nor getCities can clear returned colony. Postal-only lookup and its listeners remain unchanged. Street fallback and requested coordinates are preserved.
- Multiple matches show printable labels and reveal the existing overlay before selection; each closure captures its own converted result and a weak view reference.
- Reviewed the task-only diff. Both files pass focused git diff --no-index --check with no diagnostics (exit 1 signifies differences). Staged diff hash is unchanged and git status adds only this task's evidence files; other user edits are preserved.
- Static checks only, per the user's retained preference. No builds, tests, browser execution or generated output refresh. Runtime rendering remains unverified; rebuild the app through the normal workflow to publish the Swift change.

Concurrent-edit note: the snapshot diff also shows a loadingView.hide() addition in the reverse-geocoder closure made outside this task patch while work was ongoing. It is preserved as user work; this task only changed the address-to-result conversion, multiple-result choices, and the owning documentation fact.
