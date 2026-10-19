# Synchronize shared package checkouts and review latest contracts

Date: 2026-10-15

## PLAN

User requests latest TCFireSignal/TCFundamentals commit review and code synchronization. Primary checklist: api_endpoint_skill; supporting UI checklist for the shared-model consumers. IDs: API-001/002/003 and SWWEB-001/003. Owning API/UI architecture and source map reviewed.

- Latest clean local heads: TCFireSignal 0ac424bad97d6c7d6cda4b5fcfb88acec66e529a; TCFundamentals 6a9d6badaa85c1e5081c43dd9fd47fc4bfea5c45. Package.resolved already pins both. Cached checkouts are respectively 08967c8 and 48b0bde; cache object stores lack the new objects.
- Reviewed all intervening source diffs: asset sections/delivery API; deliverd with legacy false default; BillingType.adjustment; ChargeObject.billingType; account charge billingType; order create/load billingType and SOC.type legacy decoding. Current App callers already match these changes, including preserving billingType during edits and default adjustment/charge mappings. Keep separate ChargeType type properties intact.
- Read resolver options, import only the two pinned commit objects from the clean local package repositories into the corresponding SwiftPM repository caches, then let SwiftPM resolve exactly the existing resolved file. No direct source checkout manipulation, remote branch/pin update, source DTO shim or broad package update.
- Re-check checkout revisions and relevant sources against the exact local commits, protect Package.swift/Package.resolved, all other package revisions and existing App edits. If resolution assumptions fail, stop and review before a new action.
- Fix source only if a concrete mismatch is found; otherwise retain the already compatible implementation. Record commit/contract/cache-sync and preservation evidence, append task completion/memory notes if useful. No architecture boundary changes.
- This is dependency synchronization, not a build or test. Do not run any App build/test without explicit user confirmation under AGENTS.md. Audit read-only source/diff/status and hashes.

## Reviewed before mutation

Self-reviewed against repository PLAN -> IMPLEMENT -> AUDIT and git safety. User explicitly authorizes syncing updated shared packages; generated SwiftPM caches are the only intended implementation mutation. Local repositories are clean and their current commit IDs equal the existing package pins; fetching those objects locally avoids unnecessary network access or unrelated branch updates. Existing application source and new delivery wrapper have already been adapted by earlier work and will be preserved. No subagents or independent reviewer required.

Completion: both dependency checkouts match existing pins; delivery/billing callers agree with latest contracts; source/pins preserved or any required focused mismatch fixed and audited. Build/runtime status must be reported accurately.


## Reviewed recovery amendment

The first resolver invocation stopped before checkout synchronization because Swift's default Clang module cache is outside sandbox writable roots. Package.resolved remains unchanged. Retry using task-owned cache/config/security/module-cache paths under .build, with SwiftPM's subprocess sandbox disabled while the outer workspace sandbox remains active. No package source/pin changes are needed. The user has now explicitly approved a focused App build; after exact-pin resolution succeeds, run swift build --target App with automatic resolution disabled and four jobs, logging diagnostics. Fix only concrete package-compatibility errors and re-audit protected source diffs.
