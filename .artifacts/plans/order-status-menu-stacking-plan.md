# Order Status Menu Stacking Fix

## Cause

`ViewOrderStatusMenu` is absolutely positioned with `z-index: 1` inside the Work dashboard toolbar. The toolbar's `backdrop-filter` creates a stacking context, while the statistics and order-card layers are later composited siblings. The menu's z-index is therefore confined to the toolbar context and cannot rise above those later layers.

## Implementation

1. Make the dashboard toolbar an explicit positioned stacking context above the statistics and order grid while keeping overflow visible.
2. Make `loadOrderStatusButton` the positioned containing block for `ViewOrderStatusMenu`.
3. Anchor the menu below the button and raise it within the toolbar context.
4. Preserve the existing state bindings, click handlers, filtering behavior, and menu contents.

## Verification

- Compile the App target through source compilation.
- Review only `OrderCatchControler.swift` and `TCWorkDashboardTheme.swift` changes.
- Confirm no trailing whitespace and no unrelated source edits.
