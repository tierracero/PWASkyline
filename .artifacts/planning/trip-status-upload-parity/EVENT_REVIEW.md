# Source review of upload/camera event scenarios

These are static traces of the implemented handlers, not executed tests or browser/device observations.

| Scenario | Reviewed source behavior |
| --- | --- |
| Request camera, take no picture | The parent selects the row and requests `eventid:nil`/multiple captures. No row `begin`, pending entry, spinner, cancel control or confirmation wait is created. |
| Selected followed by initiate for one capture | The first message appends that event ID once. The second uses the same owner and existing pending entry without resetting progress or appending again. |
| Two independent captures | Each server event ID creates its own entry on the selected row. Each successful image completion increments the completed-file count once and appears in completedFiles/MediaViewer. |
| Switch from row A to B after A's capture was assigned | `row(for:)` searches all known owners before falling back to the active camera row. A's progress/completion stays with A. New unbound captures go to B. Selected/initiate contain only event IDs, so the latest requested row is necessarily the context for unbound captures. |
| Completion arrives before selected/initiate | A valid .asset completion can bind its new event ID to the active row and finish it directly. Later selected/initiate see the terminal ID and do not recreate pending entries. |
| Cancel/fail, then late completion | fail records the terminal ID before removing the pending entry/aborting XHR. owns preserves the original row; beginRemoteCapture rejects terminal IDs and complete rejects events without pending entries. |
| HTTP and WebSocket both finish a local upload | The first complete removes pending and records terminal ownership. The second complete sees no pending entry and does nothing. |
| Different event IDs describe the same file URL/name | complete's existing file/URL duplicate check removes the redundant order entry; the counter remains the number of unique completed images. |
| First completed image differs from selection order | avatarEventId is set only for the first unique completion. Later completions do not replace that avatar. Completed gallery ordering retains the existing selection/event order. |
| Local upload still processing during confirmation | confirm does not inspect pending. It returns only completedFiles, retaining transition/comment/asset-route/media validation. remove clears pending before abort, so abort callbacks cannot restore or report removed uploads. |
| Close the view before remote/HTTP/status-check callbacks | Parent WebSocket listener and API/XHR/status-check continuations retain DOM guards. Parent camera target is cleared; rows stop requests and remove the viewer/listeners. Late completions are ignored. |
| Camera completion for another destination | The parent requires payload.to == .asset before accepting remote completion. Known local uploads are not adopted as camera captures. |

Local upload's image/30 MB checks, multipart event ID/file/asset destination/connection fields, authorization header, progress callbacks, processing poll, completed image metadata and gallery implementation remain unchanged from the before snapshot. ManagePOC is a reference only and is unchanged.
