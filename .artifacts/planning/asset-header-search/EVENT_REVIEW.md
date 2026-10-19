# Asset header search — source review

These are source traces, not live browser or server tests.

| Path | Reviewed behavior |
|---|---|
| Empty or whitespace-only input | Returns without creating a child or making an API request. |
| Ordinary text / asset folio | Opens AssetItemView with .folio(trimmed input); clears input before presentation, so a repeated Enter sees empty input. |
| Formatted sc / legacy qr prefix | Uses the shared CustFolioSequenceTableType enum to recognize the same code classes used by Work, then calls getWarrantyCard with .code(term). Prefix detection is case-insensitive; the submitted code retains its original case. |
| Successful asset card | Validates .asset and nonnil card.orderId, then opens .id(linked UUID). The card's own UUID is never used as the asset identifier. |
| Other card types | Shows the unsupported alert and returns without creating any asset detail. |
| Asset card without a link | Shows the inactive/unlinked-card error and retains the search input. |
| Transport / API / payload errors | Uses the existing localized error paths. Clears pending/busy state before returning; input remains available for correction/retry. |
| Repeated click / Enter while pending | isSearching guard prevents a second lookup, and field/button are disabled by that same state. No automatic key-up timer was introduced. |
| View removal before response | Clears request UUID; weak-self, isInDOM and UUID guards reject the delayed response. Owned search-state listeners are removed. |
| Session change before response | Captured custCatchID must still match after clearing local busy state; no old-session asset view or error is shown. |
| Existing department/category flow | Existing requests, renderers and add/edit actions remain unchanged in the task-relative source diff. |

The sole current CustAssetsView presentation constructs a fresh instance in AccountView. The focused source diff preserves the preexisting addAssetButton annotation and unrelated user changes.
