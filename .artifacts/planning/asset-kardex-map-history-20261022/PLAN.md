# Asset Kardex map history

- Date: 2026-10-22. IDs: SWWEB-001/002/003 and PWA-001/002/003.
- User clarified: 10 total locations including the current location.
- Reviewed scope: AssetItemView map/Kardex lifecycle, a dedicated helper in Sources/Service/skyline/js/main.js, relevant UI/PWA/module/source/memory/task documentation. Preserve existing asset notes, map dialog, Kardex event cards and print-resource edits.
- Server source reviewed read-only: CustCommercialAssetsItemTransitionService.loadKardex orders createdAt/id ascending; the typed response exposes page/hasMore. To obtain the newest unique positions, read all pages and keep only the nine newest valid distinct coordinates, excluding the current position. Use the first fetched page for the existing Kardex tab instead of a separate request.
- Draw current location with the existing default highlighted marker, at the saved asset coordinate. Add gray numbered historical points in chronological order; opacity interpolates 0.50 oldest to 0.90 newest (single history point: 0.90). Draw a light gray polyline from oldest through the newer points to current and fit the route.
- Own/destroy the map; ignore stale map tokens and history responses by session, asset, editor generation and request identity. Keep current location when history is missing or fails, and only apply complete history. Invalid coordinates and repeated pages are rejected.
- Verification: source/contract/API-reference review, JS syntax lint, task-relative diff/whitespace and status. Builds/tests/browser execution need user confirmation; public outputs are not regenerated.
