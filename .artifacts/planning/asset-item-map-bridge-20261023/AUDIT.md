# Asset item map bridge — audit, 2026-10-23

## Findings

- Parsed the supplied API response and single-row CSV: both identify asAu-5171 / xx-456 and contain valid numeric in-range coordinates. The screenshot's message is from the map-creation guard, not the missing-coordinate branch.
- Read-only live browser DOM on the reported workspace confirmed the item and failure message, a mounted asset map element with positive width/height, and main.js/MapKit script tags. No asset edits, saves, reloads or server mutations were performed.
- Direct public JavaScript reads returned HTTP 200 and 105642 characters both with the plain URL and a fresh cache query. Both contain createSubCustomerLocationMap and neither contains createAssetItemLocationMap. Local source and generated public copies do contain the new helper; generated copies were only inspected, not edited.
- Read-only browser evaluation uses a DOM facade: even native Object/alert were undefined. Its reported runtime-global absence was therefore excluded as evidence. No token or authentication data was inspected/retained.

## Source review

- The new Swift raw-string Script contains exactly the prior asset map controller; remaining source main.js equals its snapshot minus only that helper. Existing print/map/resource user edits are preserved.
- AssetItemView installs the bridge on its mounted root before requesting the token/factory. Web's Script initializer writes innerText as text content; appendChild appends the actual script node synchronously, allowing the constant factory to register before the asynchronous JWT callback. No dynamic user data is interpolated into script source and no eval API is used.
- Existing valid-coordinate, mount/session/editor/request/item guards remain. Controller setHistory/destroy, default current marker, nine unique older coordinates, gray fading markers, black text/3px border and 4px orange line remain byte-for-byte unchanged. Script removal with the host does not destroy live controllers; existing view map cleanup still owns destruction.
- Existing standalone MapView/subcustomer/legacy map helpers remain untouched. Folder/module paths were synchronized in source map and module docs; UI/PWA facts, memory and task archive reflect App ownership. No boundary rules changed.
- node --check passed for bridge.js and remaining source main.js, with exit 0/no diagnostics. All task-relative git diff --no-index --check calls report file differences (exit 1) with no whitespace diagnostics. See task.diff, whitespace-check.txt and before/after status.
- Only intended existing files and the new App bridge/evidence paths changed. No staging/commit, deployment or generated resource edits.

## Limits

No build/test commands were authorized or run. Live browser inspection diagnosed the existing failure; it did not validate rebuilt code. Apply the updated App build to include this fix; no separate main.js map-helper deployment is required by the updated view. Corrected live MapKit rendering remains unverified.
