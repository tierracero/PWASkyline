# Minimal camera payload source review

The previous broader implementation is rejected and reverted. See rejected-* artifacts for history only. This review describes the current minimal source change.

- Original camera handlers already store each uploaded original filename in imageRefrence[eventId].file and record its separate viewId in imageOrder.
- create() continues iterating imageOrder. For each viewId, it first uses uploadFileControler[viewId], then falls back to imageRefrence.values.first(where: viewId matches).
- Two completed camera views yield two CreateAssetItemFile(fileName:isAvatar:) entries, preserving existing ordering and avatar calculation. Nil files continue to be skipped as before.
- Local-file lookup, creation readiness, all WS handlers, camera requests, callback behavior, cleanup and lifecycle state are byte-for-byte the original task snapshot outside this one payload guard.
- Single creation retains images in [item]; batch creation retains the same typed item from .preItem and forwards items unchanged.
- No completion, cleanup, duplicate-event or session behavior is redesigned. Live camera/server behavior is not tested.
