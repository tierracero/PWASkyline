# Kardex event map view

- Date: 2026-10-22
- Architecture: SWWEB-001, SWWEB-002, SWWEB-003.
- Scope: Kardex event header in AssetItemView, new reusable Snippits/MapView.swift, affected source/module/architecture/memory/task documentation.
- Reviewed design: replace latitude/longitude cells with an accessible map icon in the event header; show it for finite in-range coordinate pairs. MapView(latitude: Double, longitude: Double) uses the existing independently owned MapKit preview, with a generic marker title, modal bounds, mount/session/request guards, and explicit map destruction.
- Preserve: current asset edits, event metadata/evidence, parent map and existing JS helpers. No shared/API contract, resource, or package changes.
- Completion: inspect both coordinate-present and coordinate-absent paths; audit map load/close/error and ownership paths, all MapView references, focused diff/whitespace and git status. Builds/tests require user confirmation and are not part of this run.
