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
    public typealias v1 = APIEndpointV1
    public typealias adminV1 = AdminEndpointV1
    public typealias authV1 = AuthEndpointV1
    public typealias cloudUserV1 = CloudUserEndpointV1
    public typealias custAccountV1 = CustAccountEndpointV1
    public typealias custPDVV1 = CustPDVEndpointV1
    public typealias custPOCV1 = CustPOCEndpointV1
    public typealias custSOCV1 = CustSOCEndpointV1
    public typealias custOrderV1 = CustOrderEndpointV1
    public typealias custRouteV1 = CustRouteEndpointV1
    public typealias custAPIV1 = CustAPIEndpointV1
    //public typealias customerV1 = CustomerEndpointV1
    public typealias domainV1 = DomainEndpointV1
    
    public typealias fiscalV1 = FiscalEndpointV1
    public var mailV1 = MailEndpointV1()
    public typealias notificationV1 = NotificationEndpointV1
    public typealias saleManagerV1 = SaleManagerEndpointV1
    public typealias themeV1 = ThemeEndpointV1
    //public typealias papaContadorV1 = PapaContadorEndpointV1
    public typealias wsV1 = WSEndpointV1
    
    public typealias rewardsV1 = RewardsEndpointV1
    
}
