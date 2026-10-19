# Charge/counter-charge balance calculations

Date: 2026-10-15

## PLAN

Main checkout: /Users/victorcantu/Development/SwifWeb2.0/PWASkyline. Primary checklist: Swift Web UI; supporting API endpoint review because classification comes from shared charge models. Architecture IDs SWWEB-001/002/003 and API-001/002/003; security/state guidance read for financial data authority. Follow the user's corrected StartServiceOrder.calcBalance exactly: adjustment subtracts ((price * units) / 100), other billing types add it. Preserve that entire function unchanged.

Implement a small App-only BillingType.signedAmount(Int64) extension (adjustment negates amount, other types preserve amount). Preserve shared contracts and raw persisted prices; do not use ChargeType (service/manual/product/rental) as a billing sign.

Exact source scope:
- New Sources/App/Extentions/BillingType+SignedAmount.swift.
- OrderView/OrderView.swift: signed totals on initial load, calcBalance and approved-budget import (SOC projection uses type:BillingType); signed charge row prices, correct quantity in newly added rows, and edits update row state/quantity with signed price. Newly appended charge models/cache retain raw soc.price and effective billingType rather than a pre-negated price.
- TripControler/TripControler+TripViewBeta.swift: signed charge reduction and charge rows; newly added records retain raw price/effective billingType.
- StartServiceOrder.swift: only replace the pre-charge row's codeType-based sign with soc.billingType; preserve the user-fixed calcBalance byte-for-byte.
- AddChargeFormView.swift: ensure adjustment catalog codeType produces ChargeObject.billingType.adjustment, preserving explicit billingType otherwise. This is necessary for the existing StartServiceOrder rule to receive correct classification.
- OrderPrintEngine.swift, OrderPrintChargesEngine.swift, OrderPrintServiceLeterEngine.swift and PDVPrintEngine.swift: signed charge subtotal/unit-price display and totals, retaining product/payment/rental behavior. PDV subtotal uses multiply-before-divide like the reference.
- SalePoint/SalePoint+DetailView.swift: signed charge selling total/revenue contribution and read-only charge row price.
- SalePoint/SalePoint+HistoryView.swift: signed quantity-adjusted charge totals/display in screen and print summaries; preserve business costs/production times.
- Update UI/API architecture verified-source facts, project memory, task archive and source map for the new helper. No architecture-rule/module ownership or shared model changes.

## Review before source mutation

Self-reviewed the shared ChargeObject, CustOrderLoadFolioCharges, SOC projection and CustAcctChargesQuick definitions. BillingType.adjustment is the discriminator; the SOC projection names it type, while other charge models name it billingType. Existing order/trip append paths pre-negate a local model price; they must retain the raw amount to prevent double negation under the corrected totals. OldChargeTrRow already computes from its price state, so supplying signed display prices (without changing stored models) keeps row math consistent. Edit handlers must update actual row state rather than assigning an unscaled unsigned total string.

Scope is billing-aware balance/receipt/summary calculations in this PWA. Pure product/rental/cart/project and payment/change calculations do not receive a BillingType and must not infer one from ChargeType or descriptions. Aggregate order reports omit BillingType in their shared projection and cannot be reclassified in the client; fiscal concept/tax generation is separate from order-balance calculation. Do not change shared API/server/report/fiscal contracts or guess a sign where no discriminator exists. Preserve unrelated pending edits, including the user's original calcBalance and recent shared-package/classification work.

## Completion and audit

All scoped charge contributions use adjustment subtraction consistently, net charge totals match displayed line amounts, raw locally appended prices are not double-negated, and unrelated item/payment semantics stay intact. Review the complete baseline-relative patch and remaining charge formulas; check exact applied content, task-added whitespace, reverse patch applicability, original calcBalance bytes and tracked-file/status preservation. Builds/tests/compiler parsing require explicit user confirmation under AGENTS.md and are not authorized; perform source-only audit. No staging/commit/deployment, dependencies, generated files or server edits.

## Plan refinement before applying source

Further tracing shows budget/live-cart service entries retain the actual CustSOC catalog snapshot (codeType), even though their generic item wrappers lack BillingType. Therefore they can carry a verified local billing direction without a shared/API change. The earlier exclusion of all budget/cart calculations is narrowed: do not infer classification for products/manual DTOs without metadata, but propagate the real SOC adjustment classification for service entries.

Additional exact scope, reviewed before any main source mutation:
- BudgetSOCView.swift and AddServiceFormView.swift retain billingType derived from loaded CustSOC.codeType in returned ChargeObject.
- BudgetView/Budget+ItemView.swift gains a default-charge billingType initializer/property and applies it to initial/edited row subtotal. BudgetView.swift passes service billingType from new ChargeObject or loaded CustSOC, and calcBalance applies each row's billingType.
- BudgetView/Budget+HistoricItemPreView.swift derives service classification from CustSOC for historic row prices/subtotals and balance accumulation.
- Structurs/SalePointObject.swift gains a default-charge billingType property via a compatible initializer. SalePointView.swift retains it on cart copies, new services and loaded SOC budget rows, uses signed service-row display prices and signed multiply-before-divide cart balance. Shared SaleProductPDVObject values remain raw.

Self-review: these are UI-only propagation of authoritative catalog classification, not new server authority/contracts. Manual/product/rental defaults and cost calculations remain unchanged. No source mutation in the main checkout occurred before this refinement. The user's original StartServiceOrder.calcBalance remains protected.

## Baseline refresh before mutation

A guarded preflight detected that another task had updated only the earlier ORDER-VIEW-COMPACT-CLEANUP archive status sentence. No main-checkout source had been written. Re-reviewed the one-line external documentation change, refreshed only the archive baseline and rebased this task's appended record onto it. All user text is retained; source scope/implementation assumptions are unchanged.
