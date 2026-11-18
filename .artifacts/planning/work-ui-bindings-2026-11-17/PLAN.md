# Work UI binding repair

## Observed comparison

Chrome is authenticated at localhost:7701/work and control.tierracero.com/work. Production shows order counts 0/4/0/2, full toolbar and create actions; localhost shows 0/0/0/0 and missing actions. Both have the same listed orders. Production order fobo01-5003 renders details/notes/charges, while the local order modal renders only its header. Production fiscal history switches to date/search/history lists and opens existing invoice 1014; localhost remains on its new-invoice pane after selecting history. No business record was modified.

Source confirms these paths use temporary map states passed to text, hidden attributes, classes and CSS properties. State.map holds derived state weakly; most consumers do not retain mapped input. This is the same lifetime defect as the earlier stylesheet binding, across other consumer types.

## Scope and ownership

PWASkyline: SWWEB-001/002/003; supporting PWA-001/003 and API-003 for read-only fiscal validation. No App business logic or backend contract changes.

web: WebFoundation owns reusable state-listener ownership; DOM owns text/attribute consumers; CSS owns typed properties and their DOM/rule bindings. Preserve all mapping expressions, initial values, order, arithmetic, event handlers and serialization.

## Reviewed implementation plan

1. Reproduce text, hidden and typed CSS display bindings with temporary mapped states in a native fixture.
2. Strengthen explicit StateListener.hold(in:) ownership: a holder keeps its source state alive until cancel/release; skip self-holds to avoid self-cycles. Cleanup removes both listener and retained-source entries. Do not change map/merge transforms or notification ordering.
3. Add a weak-owner listener convenience plus a DOM binding holder stored with each element. Convert text, attributes, element-value bindings to own their input for the element lifetime, preserving callback body behavior. Shutdown/deallocation releases the bindings.
4. CSS property content owns its mapped inputs; mechanical conversion of generated property listeners uses weak property owners. DOM/CSSRule retain property objects while bound, using weak callbacks to avoid new owner/property cycles. Numeric/color helpers retain their state listeners similarly where relevant.
5. Verify retention, live changes, cancellation/shutdown and object release in the fixture; build web. Publish only the package changes authorized by the user, resolve the project and run debug packaging.
6. Repeat the exact Chrome comparisons: dashboard counts/actions, order 5003, fiscal history and existing fiscal details. No issuance, payment, cancellation, save or message action. Validate release/build artifacts as warranted, update report and final diff/status audit.

## Audit and stop conditions

Consumer ownership, not strong global map cycles, is the repair. Verify owner/state/property capture graphs and cleanup. Generated-listener conversion must preserve argument arity and every callback statement. Stop/replan if a consumer is not covered by the stated ownership or introduces non-UI side effects. Preserve existing PWASkyline work and local package governance. Package push authorized; no PWASkyline commit authorized.
