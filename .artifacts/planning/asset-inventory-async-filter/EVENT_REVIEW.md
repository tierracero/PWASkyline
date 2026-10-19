# Progressive asset inventory rendering and filtering source review

Static review of actual code; no browser performance or server session was run.

| Scenario | Source behavior |
|---|---|
| Large initial inventory | Mount schedules the render; plain list has no ForEach over items. Each append timer constructs one AssetInventoryItemController and schedules the next at the existing order-row interval. |
| Empty inventory | Uses the existing No hay unidades registradas message; no row timers start. |
| Filter by folio/name/serial | Case/accent-normalized query matches the shared item folio, optional serial or name. Serial nil becomes an empty string. Parent source items/count stay intact. |
| Whitespace/case/accent differences | Query uses purgeSpaces and pseudo, consistent with existing asset search conventions. All-space input becomes an empty query. |
| Multiword name | Internal single spaces are preserved; name matches are substring searches against joined field text. |
| Rapid typing | Each search-state change immediately replaces the render UUID. Only the latest debounced search may render; old row timers fail the UUID check. |
| Clear search | Latest render includes all source items in original order. |
| No matches | Uses No hay unidades que coincidan con la búsqueda; no row timers start. |
| Replace or append items mid-render | Shared item listener changes the generation and schedules a new snapshot render. Old row callbacks cannot append their stale payload. addItems still mutates the full shared items state. |
| Inventory creation reload | Existing callback reloads the asset/API payload. Parent reuses its same search field/controller, preserving query and one set of weak child subscriptions. Old removal invalidates scheduled work; reattachment rebuilds the same inventory wrapper when list.superview is nil, restoring ownership cleared by Web recursive removal, and starts from current data/query. |
| Header count while filtered/rendering | Continues to show the full inventory count from parent items; filtering never writes matched rows back into business data. |
| Close or render an error while rows are pending | Web's recursive innerHTML child removal triggers removal; generation invalidation plus isInDOM/weak-self guards suppress timers. |
| Shared listener ownership | Child does not remove parent-owned item/search listeners. Parent cleanup removes its own listeners on close, including header mappings and weak child subscriptions. |
| Click a streamed row | Existing AssetInventoryItemController and its AssetItemView opening behavior are reused unchanged. |

This moves expensive row/DOM construction across browser event-loop turns. Filtering/snapshot selection and clearing existing DOM are still synchronous work; no background thread or viewport virtualization is introduced. Actual pause duration, rendering throughput and header wrapping must be verified in the running browser.
