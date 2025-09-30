//
//  Cust+SearchOperationalObject.swift
//
//
//  Created by Victor Cantu on 11/12/23.
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
    static func searchOperationalObject(
        term: String,
        currentIDs: [UUID],
        callback: @escaping ((_ term: String, _ resp: [CustSOCActionOperationalObjectQuick])->())
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
        
        let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchActionItem") +
        "&currentIDs=\(_ids)" +
        "&term=\(_term)"
        
        xhr.open(method: "GET", url: url)
        
        xhr.setRequestHeader("Accept", "application/json")
            .setRequestHeader("Content-Type", "application/json")

        xhr.send()
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(term,[])
        }
        
        xhr.onLoad {
            
            if let data = xhr.responseText?.data(using: .utf8) {
                do {
                    
                    let resp = try JSONDecoder().decode([CustSOCActionOperationalObjectQuick].self, from: data)
                    
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

