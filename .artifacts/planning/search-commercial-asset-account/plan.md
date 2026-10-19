# SearchComertialAsset account projection

## Reviewed plan

Scope: replace the incomplete CustAcct initializer in SearchComertialAsset.createAsset with a projection of self.account (CustAcctSearch). Preserve the user-added account dependency, + Activo action, architecture request, physical store, departments/locations/subLocations, callback and existing selection flow. No endpoint, package, target or path changes. Owning IDs SWWEB-001/002/003.

Inspected current TCFundamentals CustAcct/CustAcctSearch constructors and TCFireSignal InitiateAssetItemViewType.account. The account branch requires a CustAcct; the search result includes 28 matching identity, pricing/type, contact/address, payment-reference, fiscal, card/reward/credit and concessionaire fields. Copy all matching fields explicitly, supply empty/nil required missing fields, and retain initializer defaults for other unavailable fields. This object is presentation/asset-context data, not an account update. Do not add an account-load API or invent credentials/address data.

Completion: no typed placeholders remain; initializer labels/order and supplied value types match the checked declaration; mapping includes every matching search property; surrounding user work unchanged. Update the owning UI fact to reflect the user-added asset-creation branch (it now loads architecture, not inventory). Review snapshot diff, whitespace, status and staged hash. Static checks only; no builds/tests/browser execution.

Review: plan matches the requested account initializer completion and preserves the existing store/account separation.

## Audit

- Unknown constructor labels: []
- Missing required constructor arguments: []
- Constructor argument order matches: True
- Mapped shared account properties: 28
- Unmapped shared account properties: []
- Mapped property type mismatches: []
- Existing flow outside initializer preserved: True
- Task-only whitespace diagnostics: none
- Unexpected status additions: []
- Removed user status paths: []
- Staged diff unchanged: True
- Owning UI fact corrected for the user-added architecture load and account creation context. Full git diff --check flags pre-existing user whitespace in createAsset; task snapshot has no introduced whitespace diagnostics. No source paths, boundary ownership or endpoint contracts changed.
- Builds/tests and browser validation not run under the existing static-only preference. Constructor contract was reviewed statically, not compiled.
