# Camera-to-payload source review

This is a source trace, not a runtime test. No customer payload or photos are persisted in these artifacts.

| Scenario | Reviewed path / expected result from source |
|---|---|
| Two camera photos | Each event ID creates one ImageGeneralView with its own view ID. Both IDs enter imageOrder and uploadFileControler; complete stores each original file. create() emits two CreateAssetItemFile values. |
| Single / multiple asset units | Single creation passes images inside [item]. Multi-item callback returns that same typed item; CreateAssetMultipleItemView appends it and passes items unchanged to createAssettem. |
| Selected then Initiate, or reversed/duplicated | Helper reuses imageRefrence[eventId]; no second upload-registry entry or order append. |
| Complete arrives first | Mounted same-session camera requester and assetItem destination create/register the card before filling its file. |
| Complete duplicate or late progress/initiate/selected | Terminal capture ID prevents reapplication, status reset and duplicate cards. |
| Known remote async upload | Only assetItem destination plus a retained same-session event mapping is accepted; fileName is stored and readiness set. Alternate completion then becomes redundant. |
| Pending second photo | Registered incomplete view is seen by the existing readiness guard; no premature create/preItem callback. |
| Failed or cancelled pending capture | Remove event map by capture UUID, registry/order by view UUID; record terminal ID and remove preview. Other retained photos stay in the payload. |
| Removed completed photo | removeMe discards correct event/registry/order keys even though upload already terminal. Later events do not reinsert it. |
| Fail/cancel before a card exists | Event is marked terminal; later selected/complete cannot create that failed card. |
| Mixed local and remote photos | Existing local XHR registration/order is unchanged; remote helper uses the same registry. Local ImageGeneralView still consumes its own async events by local view ID. |
| Thumbnail load delay | Completion marks isLoaded true and stores original file immediately; preview loading no longer determines submission readiness for camera photos. |
| Retained crop and avatar | Existing crop updates retained mapped file and avatar state; manual avatar callback and create() isAvatar calculation remain. No avatar default redesign. |
| Removed form / changed session | Weak/mount guard rejects detached events; remote session ID mismatch rejects old session. Removal clears camera reception. |
| Other destinations | Camera/async completion require assetItem. Initial selected/initiate payloads contain only event UUIDs and lack destination/form context; existing protocol cannot fully disambiguate simultaneous mounted asset forms that both requested remote cameras. No global routing change introduced. |

Contract review: pinned TCFireSignal CreateAssetItemFile carries fileName and isAvatar; the client wrapper embeds supplied items unchanged. The local mobile .useCamaraForAssetItem branch constructs CamaraViewController(to: .assetItem, multipleTakes:true when request eventid is nil). Server WS completion forwards eventid, to and file unchanged to the specified connection. No endpoint/payload model mutation is required.
