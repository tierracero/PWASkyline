# Source flow review

Date: 2026-10-15. This is a source walkthrough, not runtime test evidence.

| Path | Source result |
|---|---|
| Origin or first destination missing | Add button hidden/display:none; original two placeholders/columns retained. |
| First two selected | Right-side Agregar Destino is inline-flex; each existing card remains removable. |
| Third/further stop | Destination picker forwards explicit append intent; appends only destination snapshots after the first pair. Existing primary state remains intact. Grid becomes one column with display:contents wrappers for extra rows. |
| Picker alternatives | Saved location, store and subaccount snapshots flow through the same append-aware item editor; base creation passes append intent and current route count. |
| Primary removal with extras | Rebuilt cards hide removal; clearLocation also guards extras.isEmpty. The editor's live allowsDeletion policy hides Eliminar and checks both deleteItem entry and the confirmed callback before any delete API. |
| Extra remove | Removes only the matched extra, invalidates pending asset picker/editor work, reconciles item references and restores two columns/unlocks primary removal after the last extra. |
| Extra edit/base update | Finds the existing extra by source identity; updates its array index, preserves snapshot fields/position and remaps merchandise references if the placement ID changes. Stale nonmatching editors cannot append a removed stop. |
| Duplicate/reference guard | Appends/extra-mode edits reject selected sources and normalized duplicate/empty placement references. Create also checks nonempty/unique normalized references for all stops. |
| Per-item destination | Existing editor receives every selected destination for regular merchandise and every eligible linked destination for assets. Synchronization retains each valid chosen destination instead of resetting every item to the first. Removed references fall back to an eligible remaining destination; asset route validation blocks unsupported results before submission. |
| Submission | selectedLocations = origin + first destination + ordered extras. Existing wrapper/shared request forwards that one array; server enumeration assigns positions. No extra trip/API call or contract change. |
| Beta view/refresh | Existing renderRoute sorts persisted positions, sets grid for <=2 or one column for >2 on every render, and retains the same route cards. No new saved-trip editing action. |
| Lifecycle | New state listener is removed with the parent; new picker/editor/base callbacks use weak/mount guards. Existing origin-change asset invalidation is preserved. |

Both UI roots retain TCTripBetaTheme then TCCrystalSurfaceTheme(.trip); new prominent action reuses the shared goodButton class. No new color rules or dependencies.
