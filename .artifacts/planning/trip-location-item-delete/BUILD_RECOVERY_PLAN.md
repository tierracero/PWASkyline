# Reviewed build recovery amendment

Focused build failed before source compilation: current Package.resolved pins TCFundamentals 48b0bdebb49b40201b50249e08942dfe49874b7d and TCFireSignal 08967c8621117ae18d2298ff46f71cb50942ca90; corresponding Git cache trees are missing. Existing source changes remain paused until recovery review.

Recover only those exact pins with git fetch origin <SHA> in the existing .build/repositories caches. Do not select another revision, modify Package.resolved, push, or touch external source checkouts. This is a scoped cache recovery needed by the already-approved focused build. Preserve logs in this task's artifact directory. Review fetched DeleteLocationRequest and FiscalLocationItem contracts before retrying the same build. If source compatibility differs, re-plan rather than speculative fixes.

The user further confirmed deleteLocation cancels a FiscalLocationBase instead of deleting its database record; removeLocation is a separate trip-stop endpoint. The current new button uses deleteLocation only; parent callback reuses existing local picker cleanup after success.

Self-review: exact-pin cache fetch is reversible, no dependency contract/version selection or user-source mutation is authorized. Lockfile/current status checks required after build.
