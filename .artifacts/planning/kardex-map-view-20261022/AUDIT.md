# Audit — Kardex event map view

- Implemented: 2026-10-22.
- Reviewed task.diff against captured working files; existing AssetItemView content before/after kardexEventView is byte-for-byte preserved. Its existing background edit remains intact. The only incidental cleanup is trailing whitespace on the touched method declaration.
- Confirmed shared event latitude/longitude fields are Double? and the new initializer takes Double values without reordering them. Missing, non-finite or out-of-range values show no Kardex action; direct invalid MapView inputs show a fallback. Zero coordinates are accepted.
- Reviewed native-button keyboard accessibility, top-right header flex layout, removal of both coordinate cells, and preservation of event metadata/evidence. Existing map SVG is reused.
- Reviewed existing createSubCustomerLocationMap signature and returned independent MapKit object; the new view relabels its marker, retains the object and calls destroy on removal. Existing JavaScript helpers/resources remain untouched.
- Reviewed API.v1.jwt callback, mounted-view/session/request guards, close/remount invalidation, loading/error messages and read-only marker. The map container fills the existing viewport-bounded VPopUp body.
- Checked all MapView definitions/references, import providing callKey, inherited native-button DOM initializer, and source/module/architecture/memory/task documentation.
- git diff --check for tracked task paths: exit 0, no diagnostics. New-file no-index whitespace review: no diagnostics (exit 1 indicates the new-file difference); direct whitespace scan found zero trailing-whitespace lines.
- Git status reviewed: task adds only MapView.swift and its plan/evidence directory; edits stay within the scoped existing source/docs. Other pre-existing changes remain present.
- No build, test, browser session, JWT request, map-network execution, commit or deployment ran. Build and live rendering remain unverified under the repository confirmation rule.
