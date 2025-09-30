//
//  WS+NotifyAddMercadoLibreProfile.swift
//  
//
//  Created by Victor Cantu on 9/28/23.
//

import Foundation
import TCFundamentals

extension WS {
    
    func notifyAddMercadoLibreProfile(_ payload: String) -> MercadoLibreProfile? {
        if let data = payload.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(API.wsV1.AddMercadoLibreProfileNotification.self, from: data).payload
            } catch {
                print(error)
                return nil
            }
        }
        else{
            return nil
        }
    }
    
}
