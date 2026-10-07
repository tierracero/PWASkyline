# tabButton state mapping

Date: 2026-10-01

## PLAN — reviewed before source mutation

- Scope: only `tabButton` in the existing, user-owned untracked file `Sources/App/Functions/tabsContainer.swift`. Leave `TabContainer`, `tabsContainer`, and all other pending work unchanged.
- Architecture IDs: SWWEB-001, SWWEB-002. No architecture boundary or lifecycle change.
- `State<String>.map` receives a `String`, as confirmed by the existing tab-button implementation in `CustAssets+AssetItemView.swift`. Compare `$0` directly with `title` for text and background colors.
- Replace the red background placeholder with the intended explicit-RGB selected color and transparent unselected background. Preserve the existing click state update and layout.
- Completion: compare the file against a temporary pre-edit copy, confirm only the two state mappings changed, and review git status. Do not run builds or tests without user confirmation.

## Review

The fix follows the established Swift Web tab pattern and preserves the user's incomplete container implementation. Stable architecture documentation requires no update because its existing verified facts and boundaries remain accurate.

## AUDIT

- Compared the user-owned untracked source against its pre-edit temporary copy with `git diff --no-index`: only `tabButton`'s text/background mappings changed. The remainder is unchanged.
- `git diff --no-index --check` against that copy passed.
- Reviewed the click handler: it still sets `selectedValue.wrappedValue = title`.
- Git status confirms the source remains untracked and only this planning artifact was added to the starting status set. No unrelated files were edited, staged, or committed.
- Builds/tests were not run because user confirmation was not provided. Verification is limited to source-pattern and diff review.
