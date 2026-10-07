# Search subcustomer view

Reviewed plan — 2026-10-03

Primary skill: Swift Web UI checklist; supporting API endpoint checklist. Architecture IDs SWWEB-001/SWWEB-002/SWWEB-003 and API-001/API-002. No boundary-rule changes.

## Scope

- Add Sources/App/Snippits/SearchSubCustomerView.swift, based on SearchCustomerView's search layout and validation.
- Update CreateNewSubCustomerDataView.swift initializer only to receive selected acctType (default .personal for existing callers) and seed business names appropriately for nonpersonal account types.
- Wire TripControler/TripControler+AddLocation.swift searchCustomer to the new view and its existing renderLocation(subaccount) method.
- Register SearchSubCustomerView with the existing glass modal host in Functions/addToDom.swift.
- Synchronize architecture/SWIFWEB_APP_ARCHITECTURE.md and SOURCE_MAP.md.

## Implementation

1. Search receives a CustAcctSearch parent and returns one selected/created CustSubAcct. Use API.custSubAcctV1.search(custAcct: parent.id, term: term).
2. Preserve minimum search validation (5 digits or 4 text characters), show local searching state, guard repeated submissions, and invalidate callbacks on removal. Failures remain distinct from successful empty results.
3. A single match completes selection; multiple matches render readable, keyboard-selectable result cards in the same modal. Verify results belong to the injected parent account before returning them.
4. Empty results open CreateNewCusomerView(.general) with the search term. Its callback passes acctType and searchTerm into CreateNewSubCustomerDataView using the same parent; its created CustSubAcct completes the search flow. Keep the search available under the creation flow so cancelling can return to it.
5. Apply the existing customerSearch crystal theme and prominent goodButton class; use the standard glass host. Preserve existing parent/customer workflows and user edits.

Plan review: the existing subaccount search distinguishes nil (request failure) from [] (no matches), and the creation form validates the returned parent ID and API statuses. Only a small initializer extension is needed to retain chooser data. No new request models or global caches are introduced.

Completion: inspect source/callback paths, parent account propagation, modal lifecycle and task-only diff; run whitespace checks and inspect git status. Builds/tests need explicit user confirmation and are not authorized.

## Audit result

- Reviewed the new search source and task-only diff in search-subcustomer-view.diff. Existing-source changes are limited to the selected-type initializer/prefill, the trip search action, one glass-host registration, and scoped architecture/source-map facts.
- Verified the API call uses the injected parent ID and handles nil separately from []: a request failure reports an error; [] opens the type chooser. One item completes selection; multiple items are rendered as selectable cards with Enter/Space support. Parent identity is validated for result arrays and completion.
- Traced the no-result callback chain: searched term -> CreateNewCusomerView -> chosen acctType/selectedTerm -> CreateNewSubCustomerDataView with the same CustAcctSearch -> server-created CustSubAcct -> search completion -> TripControlerAddLocation.renderLocation. The creation form retains its existing API/status/parent validation.
- Reviewed creation prefills: email terms seed email, numeric terms seed mobile, nonpersonal textual terms seed businessName, personal terms seed first/last name. Existing callers keep the .personal default.
- Reviewed repeated-submit/stale-response handling: local isSearching blocks duplicate requests; request ID and removed-view guards ignore callbacks after close; completion guard prevents duplicate selection. State listeners are removed on disposal. No global cache or loading-overlay state was added.
- The new view uses customerSearch crystal styling and goodButton; standard presentation is routed through the existing low-opacity glass host.
- Tracked-file git diff --check passed. New-source no-index whitespace inspection produced no diagnostics (exit 1 indicates the added-file diff). Git status retained the pre-existing source changes and added only this task's search source and transient artifacts.
- Builds, tests, and live browser/API calls were not run because repository rules require explicit build/test confirmation. Compilation/runtime behavior remains unverified.
