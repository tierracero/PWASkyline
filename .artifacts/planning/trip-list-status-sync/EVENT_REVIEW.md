# Trip list status synchronization source review

Static event traces of the actual implementation; no browser or server test was run.

| Sequence | Reviewed source behavior |
|---|---|
| Detail opened by Work folio search (empty injected callback) | TripViewBeta's acknowledged-success path now independently forwards trip ID/status to the mounted TripsControlerView. |
| Detail opened from Followup or creation | Dashboard forwarding runs on the same success path; existing Followup/caller updates remain intact. |
| Detail opened from dashboard card/creation | Central forwarding updates the dashboard first. Existing callback receives the same ID/status and exits without regrouping a second time. |
| pending → inProgress/completed/cancelled group transitions | Existing processItems repartitions by status and updates the derived arrays, counters and grid item collections. Valid transition checks remain unchanged (pending → inProgress/cancelled; inProgress → completed/cancelled). |
| Failed or nil changeTripStatus response | Returns before dashboard notification and existing status callback; list status is preserved. |
| Session changes before acknowledgement | Existing TripViewBeta session guard returns before either notification; no other session's dashboard is updated. |
| Detail closed while status request is pending | Success uses the captured trip ID, session ID and callback. Dashboard forwarding does not depend on weak detail self or the optional detail refresh. |
| Detail refresh fails after acknowledged change | Dashboard is already updated; getTrip failure cannot roll it back. |
| List request begins, then status changes, then old response arrives | Matching status is updated immediately and recorded locally for that request. Returned matching item gets the acknowledged status before regrouping. |
| Old list response arrives, then status acknowledgement | Response is processed first; acknowledgement updates the now-current matching item normally. |
| Multiple status changes during one list request | Dictionary key is trip UUID; later acknowledgement replaces earlier status for that trip. Distinct IDs stay separate. |
| List request begins after status acknowledgement | Request dictionary starts empty; response remains server-authoritative. No persistent optimistic status cache is introduced. |
| Unknown trip ID while request is pending | No existing row is added or unrelated row changed, but the acknowledgement is captured in case that ID appears in the incoming response. |
| List request errors | Request-scoped overrides clear. Already updated visible data is retained because no payload replacement runs. Existing errors/loading behavior is preserved. |
| Dashboard removed before acknowledgement | Mounted reference clears and instance callback guard rejects removed lists. |
| Dashboard removed before list response | Local overrides clear; mounted/session response guard prevents applying the payload. |
| Dashboard replaced, old one later removes | Identity check prevents the old view from clearing the newer mounted reference. The reference is weak and cannot retain the workspace. |

The app currently constructs TripsControlerView only in WorkViewControler.loadTripView. The private weak reference coordinates this mounted presentation and does not store trip records. Work/Followup source, APIs, CSS, dependency pins and the existing server status contract remain unchanged.
