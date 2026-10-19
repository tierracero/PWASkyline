# Order view inset holder

Date: 2026-10-14

## PLAN

User scope: remove the order view's full-screen presentation and match the point-of-sale holder. Do not move the corner icon or modify any internal order elements.

Primary checklist: `.agent/skills/swifweb_ui_skill.md`. Architecture IDs: SWWEB-001/002/003. Source map and UI architecture already loaded in this session.

- Change only five declarations in TCOrderViewTheme's scoped shell rule: top 25px, left 40px, width calc(100% - 100px), height calc(100% - 70px), border-radius 24px. These match SalePointView's standalone holder geometry.
- Preserve existing shell padding, glass treatment and border-box sizing. Keep every toolbar/content/control rule, OrderView source, AccoutOverview holder markup and floating icon unchanged.
- Record the verified holder fact in UI architecture, append project memory/task archive. No boundary or source ownership changes.
- Review baseline-relative diff, protected-file hashes, scoped selector ownership and final status; no build/test commands without user confirmation.

## Reviewed before source mutation

Self-reviewed against repository workflow and UI checklist. The screenshots show the contrast between the inset sale holder and edge-to-edge order holder. AccoutOverview already supplies the order shell class and enables the theme only in order mode. The theme's important declarations force zero offsets/full dimensions/zero radius; overriding just those five declarations is sufficient and avoids changing any child element. SalePointView's standalone dimensions and position were read directly in source. No independent reviewer or subagents required.

Completion: order mode has an inset rounded holder with standalone point-of-sale geometry; internal contents and corner icon sources remain byte-identical. Browser layout remains unverified without execution.
