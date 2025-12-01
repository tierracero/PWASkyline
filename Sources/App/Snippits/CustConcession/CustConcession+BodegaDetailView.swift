//
// CustConcession+BodegaDetailView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class BodegaDetailView: Div {

        override class var name: String { "div" }

        let consetionId: UUID
        
        let consetionName: String

        let bodega: CustStoreBodegasQuick

        let items: [CustPOCInventorySoldObject]

        private var relinquishItems: ((
            _ items: CustPOCInventorySoldObject,
            _ alocatedTo: UUID?
        ) -> ())

        init(
            consetionId: UUID,
            consetionName: String,
            bodega: CustStoreBodegasQuick,
            items: [CustPOCInventorySoldObject],
            callback: @escaping ((
                _ items: CustPOCInventorySoldObject,
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.consetionId = consetionId
            self.consetionName = consetionName
            self.bodega = bodega
            self.items = items
            self.callback = callback
        }

    }
}