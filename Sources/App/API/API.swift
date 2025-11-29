//
//  API.swift
//
//
//  Created by Victor Cantu on 2/16/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

public struct API {
    
    public typealias v1 = APIComponents
    public typealias adminV1 = AdminComponents
    public typealias authV1 = AuthComponents
    public typealias cloudUserV1 = CloudUserComponents
    public typealias custAccountV1 = CustAccountComponents
    public typealias custPDVV1 = CustPDVComponents
    public typealias custPOCV1 = CustPOCComponents
    public typealias custSOCV1 = CustSOCComponents
    public typealias custOrderV1 = CustOrderComponents
    public typealias custRouteV1 = CustRouteComponents
    public typealias custAPIV1 = CustComponents
    //public typealias customerV1 = CustomerComponents
    public typealias domainV1 = DomainComponents
    
    public typealias fiscalV1 = FiscalComponents
    public var mailV1 = MailComponents()
    public typealias notificationV1 = NotificationComponents
    public typealias saleManagerV1 = SaleManagerComponents
    public typealias themeV1 = ThemeComponents
    //public typealias papaContadorV1 = PapaContadorComponents
    public typealias wsV1 = WSComponents
    
    public typealias rewardsV1 = RewardsComponents
    
}
