# Audit: Explicit equipment relation for new orders

## Result

- `StartServiceOrder.createOrder` explicitly constructs the initial equipment row with `.equipment` and `relId: nil` (`Sources/App/Snippits/StartServiceOrder.swift:3070`).
- `StartServiceOrderEquipmentView.addEquipment` explicitly constructs each added/edited row with `.equipment` and `relId: nil` (`Sources/App/Snippits/StartServiceOrderEquipmentView.swift:1696`). The parent flow appends these rows and includes them in the create request.
- The current shared `CreateRequest` accepts `[EquipmentObject]`, and the app wrapper forwards that array without rewriting it (`Sources/App/API/CustOrderEndpoint/CustOrder+Create.swift:36,43-62`). `CustOrderCreateEquipments` is deprecated and is not used by this create path.
- Shared `EquipmentObject` declares `type: CustFolioObjectsType` and `relId: UUID?`; `.equipment` encodes as `"equipment"`. Standard synthesized Codable omits a nil optional key, and the shared model decodes a missing `relId` as nil.
- Bulk order creation uses `OrderExtractPayload`, which has no equipment entries; rental order creation sends an empty equipment array.

## Validation

- `git diff --check -- Sources/App/Snippits/StartServiceOrder.swift Sources/App/Snippits/StartServiceOrderEquipmentView.swift Sources/App/API/CustOrderEndpoint/CustOrder+Create.swift` — passed with no whitespace errors.
- Reviewed the relevant source diff. The pre-existing unrelated charge edits in `StartServiceOrder.swift` remain unchanged.
- No build or tests were run; repository instructions require user confirmation before those commands.
- Git status contains the expected modifications to the two source files and this plan/audit artifact; other modified and untracked files were already present before this task.
