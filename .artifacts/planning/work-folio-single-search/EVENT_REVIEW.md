# Work search event source review

This is a static review of the actual handlers, not a browser or hardware-scanner test.

## Cause

InputText.onEnter adds another onKeyUp subscriber. Web's Container.createOrUpdate appends subscribers and calls all of them for each key-up. Previously, Enter scheduled a 0.37-second automatic search and immediately called searchFolio through onEnter. A previous character timer could also survive because its only freshness check was unchanged field text. The automatic branch's ignoredKeys check compared the whole input text rather than event.key, so it did not exclude navigation/modifier keys. Automatic clearing occurred only after another 0.25 seconds, leaving an interval for immediate resubmission.

## Reviewed event sequences

| Sequence | Expected source behavior after fix |
|---|---|
| Rapid formatted-code typing | Each eligible key replaces the debounce ID. Older delayed closures fail the ID check; the last unchanged input submits once. |
| Type a code, then Enter before 0.37 seconds | Automatic handler excludes Enter. onEnter submits once; searchFolio changes the ID, cancelling the typing timer. |
| NumpadEnter | Excluded from automatic handling and submitted by the existing onEnter subscriber, just like Enter. |
| Automatic search finishes, then Enter or click | Automatic submission clears searchTerm synchronously. The later submission sees an empty term and returns before minimizing account views or making another lookup request. |
| Search-button click while debounce is pending | The click calls searchFolio, changes the generation, and invalidates the automatic lookup. |
| Mobile-scanner explicit submission while debounce is pending | Existing scanner calls searchFolio with its explicit code; entry invalidation prevents the earlier field timer from submitting. Scanner routing itself is unchanged. |
| Arrow/Shift/Control/Alt key-up | Filter uses event.key; these keys do not create another timer. A pending actual edit remains eligible. |
| Backspace/Delete before delayed submission | These ignored keys do not schedule a search. Changed raw input fails the existing snapshot check. |
| Replace or clear field before delayed submission | Old closure fails the raw-input check; subsequent eligible typing also changes the generation. |
| Apostrophe/backtick used as separator; spaces present | The automatic handler normalizes the captured input and passes that exact normalized code into searchFolio, instead of computing then discarding it. |
| qr- prefix | Still excluded from automatic lookup. Existing manual/mobile QR handling is retained. |
| Work controller removed/re-added before delay | Removal changes the ID. Weak capture and isInDOM checks suppress removed-controller timers; a reattachment cannot revive the earlier generation. |
| Same code intentionally typed again after automatic clearing | The new input creates a new generation and can submit; no persistent/time-based code blacklist is added. |
| Advanced fallback response after clearing/new typing | The advanced result view receives the searchFolio local term submitted to the API, rather than the live field's later value. |

## Preserved dispatch

Recognized folio/account/sale/budget/transfer/warranty-card/trip/asset prefixes retain their existing branches and explicit return before the general search. Warranty-card resolution followed by its related order/asset load remains intentional. API wrappers, transport callback-once behavior and order caching are unchanged. No unrelated startup-configuration or QR-scanner design work is included.
