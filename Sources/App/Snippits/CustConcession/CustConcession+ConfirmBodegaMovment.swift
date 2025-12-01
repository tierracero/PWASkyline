//
// CustConcession+ConfirmBodegaMovment.swift
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class ConfirmBodegaMovment: Div {

        override class var name: String { "div" }

        let consetionId: UUID
        
        let consetionName: String

        let bodega: CustStoreBodegasQuick?

        let items: [CustStoreBodegasQuick]

        private var relinquishItems: ((
            _ items: CustPOCInventorySoldObject,
            _ alocatedTo: UUID?
        ) -> ())

        init(
            consetionId: UUID,
            consetionName: String,
            bodega: CustStoreBodegasQuick,
            items: [CustPOCInventorySoldObject],
            relinquishItems: @escaping ((
                _ items: CustPOCInventorySoldObject,
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.consetionId = consetionId
            self.consetionName = consetionName
            self.bodega = bodega
            self.items = items
            self.relinquishItems = relinquishItems
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            Div()
        }


        override func buildUI() {
            super.buildUI()
        }

    }
}