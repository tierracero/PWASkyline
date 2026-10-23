# Plan: Explicit equipment relation for new orders

## Goal

Ensure equipment entries submitted when creating a new service order use `CustFolioObjectsType.equipment` and `relId: nil` while asset-item order support is not available.

## Scope

- `Sources/App/Snippits/StartServiceOrder.swift`: explicitly mark the initial/default equipment entry as `.equipment` with no related asset ID.
- `Sources/App/Snippits/StartServiceOrderEquipmentView.swift`: explicitly mark each added or edited equipment entry the same way.
- Leave the API wrapper unchanged: its shared `CreateRequest` already accepts and forwards `[EquipmentObject]`, whose shared contract carries `type` and optional `relId`.
- Leave bulk creation unchanged: its current `OrderExtractPayload` contract does not submit equipment entries.

## Architecture routing

- `API-001`: preserve the existing API wrapper request construction and forwarded shared payload.
- `API-002`: use the current TCFundamentals/TCFireSignal contract without changing backend wire shape.

## Completion criteria

1. Every `EquipmentObject` created by the single service-order flow explicitly has `type == .equipment` and `relId == nil`.
2. The API create call passes those values through in `CreateRequest.equipments`.
3. The focused diff preserves unrelated existing edits; static source/diff audit is complete.
4. No build or tests run without the required user confirmation.
