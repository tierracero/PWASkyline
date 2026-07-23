# OrderCatch Menu Backdrops

## Scope

Complete the two menu-backdrop TODOs in `OrderCatchControler.swift` for the store selector and order-status selector.

## Implementation

- Add a fixed translucent black backdrop with browser blur for each dropdown.
- Bind backdrop visibility to the menu's existing hidden state.
- Close only the corresponding menu when its backdrop is clicked.
- Keep the active trigger and menu above the backdrop using local positioned layers.
- Preserve existing selection, search, and event-propagation behavior.

## Verification

- Compile the App target through source compilation.
- Review the focused controller section and working-tree status.

## Browser correction — root portal

Browser validation showed the initial fixed backgrounds were constrained to the green-marked workspace. The toolbar's `backdrop-filter` establishes a containing block for fixed descendants, and the workspace's `overflow: hidden` clips that block. Define the backgrounds as controller-owned views but render them at the `WorkViewControler` root. Place the root backdrop above the dashboard chrome and the toolbar/dropdowns one layer above it so the viewport is fully covered while the active menu remains usable.

## Focus correction

Do not elevate the complete toolbar above the root backdrop. Remove the toolbar stacking context and bind the high layer only to the store or order-status container whose menu is currently open. Keep closed menu containers at layer zero, and close one menu before opening the other so only one control and dropdown can remain focused.
