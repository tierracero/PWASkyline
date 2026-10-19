# Latest shared package contract review

Date: 2026-10-15

## Reviewed revisions

- TCFireSignal 0ac424bad97d6c7d6cda4b5fcfb88acec66e529a; previous checkout 08967c8621117ae18d2298ff46f71cb50942ca90. Intervening changes add GetAssetsSection and DeliverAssetItem.
- TCFundamentals 6a9d6badaa85c1e5081c43dd9fd47fc4bfea5c45; previous checkout 48b0bdebb49b40201b50249e08942dfe49874b7d. Intervening changes add deliverd, BillingType.adjustment, billingType fields/labels and legacy decoding.
- Both local source repositories were clean. Existing Package.resolved already pinned these exact heads. Resolution synchronized only the outdated SwiftPM working copies; no new pin choices were made.

## App consumers

- Existing GetAssetsSection wrapper constructs the exact shared request and decodes GetAssetsSectionResponse.
- DeliverAssetItem wrapper forwards tripId/assetItemId/comment/files/destinationSectionId/destinationSubSectionId; typed response matches the shared response. TripViewBeta uses snapshot IDs separately from linked asset IDs, persists a confirmed deliverd marker and adopts returned tripStatus/auto-completion. No changes to the delivery contract were needed.
- FiscalMercanciaItem.deliverd is read directly by the trip row and delivery validation; default/legacy decoding remains owned by TCFundamentals.
- AddChargeFormView, AddServiceFormView, BudgetSOCView and StartServiceOrder already pass billingType when constructing ChargeObject. Their distinct ChargeType values (manual/service/product) remain in type; no blind chargeType rename is appropriate.
- OrderView and TripViewBeta already provide billingType for appended CustOrderLoadFolioCharges. OrderView charge edits preserve obj.billingType. Approved budget conversion reads the distinct SOC projection's type: BillingType and maps adjustment/charge as before.
- CustAcctCharges/CustAcctChargesQuick are consumed directly; observed AccountView .type usages belong to customer account or note types, not removed charge fields. ToolFiscal .type usages belong to fiscal line items/profiles. No incompatible BillingType exhaustive switches were found.
- Shared source remains authoritative; no local decoding/model compatibility shim or unrelated source refactor was introduced.

Build validation is recorded separately in build.log and audit.md. No shared package tests or browser/server operations are included.
