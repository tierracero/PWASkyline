# ManagePOC remote image processing — audit

Date: 2026-10-23. Reviewed plan: PLAN.md. Task-relative diff: task.diff.

## Concrete evidence

- Read the supplied console attachment and extracted only event names, anonymized capture aliases, image dimensions and processing stage labels into redacted-event-order.txt. No raw connection IDs, image URLs, media IDs or full payloads were retained. The same capture receives a 0x0 completion followed by processing updates and a 1200x1600 completion.
- Shared RequestMobileCamaraCompleteResponse supplies type/to/eventid/id/file/avatar/width/height; async upload supplies the corresponding typed fields. No payload decoder/schema change is needed for the extra incoming connid field.
- Source cause: the original complete handler inserted the capture into finishedRemoteCameraEvents on the first completion. remoteCameraImage then rejected the actual final completion, while asyncFileUpdate could still write Generate mobile image to the existing card.
- Manual supplied-sequence trace after the change: selected registers the card; progress updates it; zero-dimension image completion leaves it pending and does not publish temporary media ID/dimensions or start thumbnail/avatar work; subsequent processing is visible; the final positive-dimension completion stores final metadata, marks ready, clears progress and starts thumbnail/avatar presentation.
- Manual ordering review: a final completion delivered first can still register the card and finish it. Later zero-dimension/duplicate completions cannot change it. requestMobileCamaraProgress already checks terminal IDs; asyncFileUpdate now does too. Registered remote asyncFileUpload applies readiness/terminal checks before writing any metadata, so the alternate final path cannot regress a completed capture. Removed/cancelled captures remain terminal. Ordinary local upload branch and crop/manual editing behavior are unchanged.
- Task-relative diff review: only the intended readiness/terminal guards, processing label and remote complete loaded state changed in Swift. The user's existing initiate block and previous mount fix are preserved, along with unrelated work.
- All four task-relative git diff --no-index --check commands return 1 (files differ) without whitespace diagnostics. Full scoped git diff --check reports existing user-added initiate-block whitespace (lines 2942/2952/2957/2958/2968 at inspection), present in before-0; no task-added whitespace error.
- Before/after git status reviewed: no unexpected changed paths. Only the four scoped files and this evidence directory were written. No staging/commit.

## Limits

Builds/tests and live browser/mobile uploads were not authorized or run under the repository confirmation rule. Validation is supplied-event data inspection, shared-contract/source/manual flow and diff/whitespace/status review; runtime presentation remains unverified.
