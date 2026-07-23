# Patch Review Skill

Checklist for reviewing source or documentation changes.

## Before Patch

- Confirm current git status.
- Identify exact task scope.
- Confirm generated outputs are in or out of scope.
- Load relevant architecture and skill docs.

## Patch Quality

- Diff is focused.
- No unrelated formatting churn.
- No accidental generated/local files.
- No secret exposure.
- No hidden contract drift.
- Existing user changes are preserved.

## Verification

- Run the smallest meaningful validation when feasible.
- If validation cannot be run, explain why.
- Record git status after changes.

