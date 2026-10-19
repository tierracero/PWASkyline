# Charge direction source review

Date: 2026-10-15. Manual source review only; no executable tests or build ran.

The reference is the user's unchanged StartServiceOrder.calcBalance: subtotal = (price * scaledQuantity) / 100; adjustment subtracts subtotal, all other BillingType values add it. BillingType.signedAmount applies exactly this direction to an already calculated amount and does not abs/normalize the source value.

| Path | Reviewed behavior |
|---|---|
| Existing order / initial render | Uses persisted billingType for net charge subtotal and signed row price. Products/rentals still add; payments still subtract. |
| Order/trip append | Effective classification comes from adjustment code or ChargeObject.billingType. The model/cache stores soc.price unchanged; row receives signed unit price and actual soc.units. Later calcBalance signs the raw subtotal once. |
| Edit charge | Model retains prior billingType and raw edited price. Row quantity/price states are updated, so its existing listeners calculate the signed full subtotal rather than an unsigned unit-price string. |
| Approved SOC budget | Uses SOC projection's type:BillingType for subtotal/row sign; retained charge model mapping remains separate from ChargeType. |
| Print engines | Three order print engines and POS receipt use signed quantity-scaled charge subtotals/unit prices. Product/payment/rental behavior is preserved. |
| Sales summaries | Charge selling/revenue amounts include billing direction and actual scaled quantity; business costs/production times are preserved. Shared billing description identifies adjustment rows. |
| Charge creation forms | AddChargeForm overrides classification for adjustment codeType. Service/budget forms retain the real loaded CustSOC.codeType and return it as ChargeObject.billingType. |
| Live budget | ItemView defaults to charge, retains actual service classification and signs initial/edited subtotals; parent balance applies each row's classification to raw prices. |
| Historic budget | Only service rows derive direction from actual CustSOC metadata; read-only row prices/subtotals and service balance contribution agree. |
| Live cart / loaded budget | SalePointObject retains local billingType with a compatible charge default. New and loaded service entries receive actual classification; all three reconstruction paths copy it. Raw SaleProductPDVObject values and shared request shape remain unchanged. |

Manual arithmetic examples (expected results, not runtime test output):
- price 10000 cents × quantity 150 / 100 = 15000 cents; charge contributes +15000 and adjustment contributes -15000.
- charge 10000, adjustment 2500 and payment 5000 leave 2500 cents due.
- Signing the row unit price then using the existing integer subtotal formula yields the same signed subtotal; no stored price is pre-negated by the order/trip append paths.
- Zero subtotal stays zero. Other billing types retain their prior direction. No new absolute-value behavior was introduced for already signed inputs.

Boundary: pure product/rental/project/payment values do not carry BillingType. Aggregate order ReportsObjectsCharges omits billing classification; client reports cannot infer it from ChargeType/name. Fiscal concept/tax generation and backend/shared models were outside this PWA balance change. These paths were not assigned guessed billing metadata.
