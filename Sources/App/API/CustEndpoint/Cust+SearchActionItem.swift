//
//  Cust+SearchActionItem.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import Web
import XMLHttpRequest
import TCFireSignal

extension CustAPIEndpointV1 {
    
    /// Return a list of SOCs and POCs, generaly used to add a charge to an order
    /// - Parameters:
    ///   - term: Term
    ///   - currentIDs: [UUID]]
    ///   - type: saleItem actionItem
    ///   - callback: [SearchChargeResponse]
    static func searchActionItem(
        term: String,
        currentIDs: [UUID],
        type: SaleActionType,
        callback: @escaping ((_ term: String, _ resp: [CustSaleActionQuick])->())
    ){
        
        var ids = "[]"
        
        do {
            let data = try JSONEncoder().encode(currentIDs)
            
            if let json = String(data: data, encoding: .utf8) {
                ids = json
            }
            
        }
        catch {}
        
        let _ids = (ids.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _type = (type.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchActionItem") +
        "&term=\(_term)" +
        "&currentIDs=\(_ids)" +
        "&type=\(_type)"
        
        xhr.open(method: "GET", url: url)
        
        xhr.setRequestHeader("Accept", "application/json")
            .setRequestHeader("Content-Type", "application/json")
        .setRequestHeader("AppName", applicationName)
        .setRequestHeader("AppVersion", SkylineWeb().version.description)

        xhr.send("")
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(term,[])
        }
        xhr.onLoad {
            
            if let data = xhr.responseText?.data(using: .utf8) {
                do {
                    let resp = try JSONDecoder().decode([CustSaleActionQuick].self, from: data)
                    
                    callback(term,resp)
                    
                } catch  {
                    print(error)
                    callback(term,[])
                }
            }
            else{
                callback(term,[])
            }
            
        }
    }
}

