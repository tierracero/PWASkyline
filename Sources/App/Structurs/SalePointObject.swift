//
//  SalePointObject.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals

struct SalePointObject {
    let id: UUID
    let kartItemView: KartItemView
    let data: SaleProductPDVObject
    let billingType: BillingType

    init(
        id: UUID,
        kartItemView: KartItemView,
        data: SaleProductPDVObject,
        billingType: BillingType = .charge
    ) {
        self.id = id
        self.kartItemView = kartItemView
        self.data = data
        self.billingType = billingType
    }
}
