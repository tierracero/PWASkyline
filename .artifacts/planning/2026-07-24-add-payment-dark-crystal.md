# Plan — AddPaymentFormView dark crystal style

## Scope

- `Sources/App/Snippits/AddPaymentFormView.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`

No payment validation, API, balance calculation, rewards, callback, fiscal-code, date parsing, or removal behavior changes.

## Architecture

- `SWWEB-001` — keep the work in the browser UI layer.
- `SWWEB-002` — preserve the existing modal lifecycle and payment actions.

## Implementation

1. Add an `addPayment` variant and narrowly scoped semantic classes to `TCCrystalSurfaceTheme`.
2. Replace the fixed-position legacy gray panel presentation with a centered, viewport-safe dark crystal modal.
3. Add a compact title bar, responsive payment-method row, crystal detail sections, summary rows, toggle/date rows, and aligned actions.
4. Restyle inputs, selects, textarea, bank results, buttons, labels, and values while keeping all existing state bindings and callbacks.
5. Add responsive one-column behavior for narrow screens.

## Completion Criteria

- `AddPaymentFormView` uses the new dark crystal variant.
- The panel is centered, responsive, scrollable when needed, and capped by the viewport.
- Card, cheque, transfer, and adjustment sections remain conditionally visible exactly as before.
- Payment, points, close, toggle, date, and balance behavior remains unchanged.
- No unrelated source changes are introduced.
- Build/test is not run without explicit user confirmation, per repository rules.
