//
//  CustFolioStatus.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

extension CustFolioStatus {
    
    public var color: Color {
        switch self {
        case .pending:
            return .init(r: 255, g: 165, b: 16)
        case .active:
            return .init(r: 0, g: 176, b: 236)
        case .pendingSpare:
            return .init(r: 241, g: 90, b: 36)
        case .canceled:
            return .init(r: 224, g: 224, b: 224)
        case .finalize:
            return .init(r: 0, g: 178, b: 52)
        case .archive:
            return .init(r: 224, g: 224, b: 224)
        case .collection:
            return .init(r: 255, g: 204, b: 204)
        case .sideStatus:
            return .init(r: 83, g: 136, b: 150)
        case .saleWait:
            return .init(r: 83, g: 136, b: 150)
        }
    }
    
    public var colorIcon128: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_pending@128.png")
        case .active:
            return Img().src("/skyline/media/icon_active@128.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_pending_spare@128.png")
        case .canceled:
            return Img().src("/skyline/media/icon_general_statusl@128.png")
        case .finalize:
            return Img().src("/skyline/media/icon_pending_pickup@128.png")
        case .archive:
            return Img().src("/skyline/media/icon_archive@128.png")
        case .collection:
            return Img().src("/skyline/media/icon_alert@128.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_general_statusl@128.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_general_statusl@128.png")
        }
    }
    
    public var colorIcon256: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_pending@256.png")
        case .active:
            return Img().src("/skyline/media/icon_active@256.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_pending_spare@256.png")
        case .canceled:
            return Img().src("/skyline/media/icon_general_statusl@256.png")
        case .finalize:
            return Img().src("/skyline/media/icon_pending_pickup@256.png")
        case .archive:
            return Img().src("/skyline/media/icon_archive@256.png")
        case .collection:
            return Img().src("/skyline/media/icon_alert@256.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_general_statusl@256.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_general_statusl@256.png")
        }
    }
    
    public var colorIcon512: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_pending@512.png")
        case .active:
            return Img().src("/skyline/media/icon_active@512.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_pending_spare@512.png")
        case .canceled:
            return Img().src("/skyline/media/icon_general_statusl@512.png")
        case .finalize:
            return Img().src("/skyline/media/icon_pending_pickup@512.png")
        case .archive:
            return Img().src("/skyline/media/icon_archive@512.png")
        case .collection:
            return Img().src("/skyline/media/icon_alert@512.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_general_statusl@512.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_general_statusl@512.png")
        }
    }
    
    public var whiteIcon128: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_white_pending@128.png")
        case .active:
            return Img().src("/skyline/media/icon_white_active@128.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_white_pending_spare@128.png")
        case .canceled:
            return Img().src("/skyline/media/icon_white_general_statusl@128.png")
        case .finalize:
            return Img().src("/skyline/media/icon_white_pending_pickup@128.png")
        case .archive:
            return Img().src("/skyline/media/icon_white_archive@128.png")
        case .collection:
            return Img().src("/skyline/media/icon_white_alert@128.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_white_general_statusl@128.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_white_general_statusl@128.png")
        }
    }
    
    public var whiteIcon256: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_white_pending@256.png")
        case .active:
            return Img().src("/skyline/media/icon_white_active@256.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_white_pending_spare@256.png")
        case .canceled:
            return Img().src("/skyline/media/icon_white_general_statusl@256.png")
        case .finalize:
            return Img().src("/skyline/media/icon_white_pending_pickup@256.png")
        case .archive:
            return Img().src("/skyline/media/icon_white_archive@256.png")
        case .collection:
            return Img().src("/skyline/media/icon_white_alert@256.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_white_general_statusl@256.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_white_general_statusl@256.png")
        }
    }
    
    public var whiteIcon512: Img {
        switch self {
        case .pending:
            return Img().src("/skyline/media/icon_white_pending@512.png")
        case .active:
            return Img().src("/skyline/media/icon_white_active@512.png")
        case .pendingSpare:
            return Img().src("/skyline/media/icon_white_pending_spare@512.png")
        case .canceled:
            return Img().src("/skyline/media/icon_white_general_statusl@512.png")
        case .finalize:
            return Img().src("/skyline/media/icon_white_pending_pickup@512.png")
        case .archive:
            return Img().src("/skyline/media/icon_white_archive@512.png")
        case .collection:
            return Img().src("/skyline/media/icon_white_alert@512.png")
        case .sideStatus:
            return Img().src("/skyline/media/icon_white_general_statusl@512.png")
        case .saleWait:
            return Img().src("/skyline/media/icon_white_general_statusl@512.png")
        }
    }
}
