# Audit: counter-charge balance calculations

Date: 2026-10-15

## Result

Applied 18 source changes (one new App helper, 17 existing source files) and five governance updates in the main PWASkyline checkout. Source scope follows the reviewed plan and its budget/cart refinement. Preserved the user's corrected StartServiceOrder.calcBalance byte-for-byte; only its pre-charge display row was aligned with billingType. No server/shared API or dependency changes.

## Concrete evidence

- Inspected shared BillingType, ChargeObject, CustOrderLoadFolioCharges, SOC projection, CustAcctChargesQuick, SaleProductPDVObject and CustSOC classification. Verified the SOC projection's type is BillingType, unlike generic ChargeType.
- Reviewed every task-relative source hunk and the documentation updates before applying guarded writes.
- All 23 resulting files match the reviewed candidates exactly. New helper creation was guarded against an existing file; existing files were guarded by their baseline SHA-256 content.
- User-reference-function range matches the saved user-calcBalance.swift exactly after application.
- Task-only added-line whitespace review passed for all source/docs.
- git apply --check --reverse .artifacts/planning/charge-balance-adjustments/change.diff passed with exit 0.
- Remaining scoped quantity/price formulas all apply signedAmount, except the original user calcBalance (already corrected) and commented-out historic code. Product/payment costs and fields without a billing discriminator retain their existing calculations.
- Whole tracked-file SHA-256 comparison confirms that only the 22 intended existing source/docs paths changed; the new helper is separately verified. Every other pre-existing tracked file remains byte-for-byte unchanged.
- Git status retains all previous entries, adding only intended source modifications, the new helper and this evidence directory. No previous status entry was removed.
- A concurrent task changed one existing archive status sentence during preparation. The preflight guard stopped before mutation; that sentence was reviewed and preserved by refreshing only the archive baseline before appending this task record.

See flow-review.md for sign/raw-price, append, edit, reload, budget, cart, receipt and classification propagation review, plus manual arithmetic examples clearly distinguished from runtime evidence.

## Limits

No builds, tests, compiler parsing, browser/server execution or deployment ran. AGENTS.md requires explicit confirmation before build/test commands; no confirmation was provided for this task. Runtime correctness and compilation remain unverified. Source/diff review is the completed audit evidence. No staging, commit, generated outputs, package pins or shared/server source changes.

## Documentation

Updated UI/API verified-source facts, project memory and task archive with source-only verification limits. Source map identifies the new App-only extension. No architecture IDs, ownership, target or module boundaries changed; ARCH_INDEX/MODULES need no change.
