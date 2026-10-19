# Asset serial mobile scanner — source traces

The following paths were reviewed in source; they are not live mobile/server tests.

| Scenario | Verified source behavior |
|---|---|
| Serial icon clicked on mounted form | Existing icon calls addSeries; a concrete new request UUID is registered before the API call. Scanner arguments match Work: .scanner, current connid, relatedid nil, relatedfolio empty and multipleTakes false. |
| Request acknowledged | Releases the initiation guard and displays the mobile-notification instruction. Serial remains editable; no global loading overlay is started. |
| Missing response / non-ok response | Clears scanner correlation and pending initiation before the existing transport/API error display. Another click can retry. |
| Matching completion | Existing decoder supplies eventid/text. Matching request and session are required, correlation is consumed, outer whitespace is trimmed, and the existing serial state is assigned. Bound input updates; create() remains user-triggered. |
| Serial formatting | Internal spaces, case, hyphens and ordinary barcode/QR text are retained; no Work folio/URL transformation or search is invoked. Existing create payload serial handling remains unchanged. |
| Empty completion | Consumes the request, shows the empty-scan error and preserves the prior serial. Another click can retry. |
| Double click during initiation | isRequestingSerialScanner prevents a second API call until acknowledgement, error or matching completion. |
| Duplicate completion | First event clears its ID. Replay no longer matches and cannot overwrite later manual input. |
| Another request / another form | Each request owns a different UUID. A new acknowledged scan request replaces the previous correlation; results for older requests or another form do not match. |
| Completion before API acknowledgement | Completion fills serial and resets pending state; the later API callback fails UUID matching, so it cannot change the result or announce stale request state. |
| Removal before API/event response | Removal resets correlation. API and weak/mount-guarded WS callbacks ignore the detached form; shared app WS listeners are not cleared. |
| Session changes | Scanner events require the stored session to match custCatchID. A response from a changed session resets its local scanner state without showing success/error or changing serial. |
| Existing flows | Task-relative source diff retains serial icon/manual field, warranty-card handling, create payload, media event branches and owned-state cleanup. Only the WS subscription capture/mount guard changes around those existing branches. |

No new global mutable state, request/response contract, event decoder or asset mutation was introduced.
