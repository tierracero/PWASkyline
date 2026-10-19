# Reviewed revision — user requests previous camera logic

The user explicitly rejected the broader implementation and requests preserving all previous upload/camera logic, changing only inclusion in items[].images.

Restore the original task snapshot after confirming current source/doc deltas exactly match our saved patches (checked before mutation). Keep all previous user edits. In create(), look up each existing ordered view ID in uploadFileControler, falling back to the existing imageRefrence values by viewId. Read fileName and avatar using the existing calculation. No event handlers, state, readiness, cleanup, camera requests or shared views change.

Replace the rejected implementation's stable documentation with the narrow verified payload behavior; keep rejected artifacts as transient history. Parse and run the already-approved focused App build. Review the final source diff against the original snapshot: only the payload lookup may differ. Verify status/staging and lockfile preservation. No live upload/server mutation or tests.

Self-review: the original remote handlers already assign file to mapped preview views and append those view IDs to imageOrder. A fallback in the payload builder consumes that state without changing upload-registry membership or the existing readiness guard. This fulfills the user's narrowed scope directly.
