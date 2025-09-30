//
//  CustAPI+SearchCharge.swift
//
//
//  Created by Victor Cantu on 7/2/22.
//

import Foundation
import TCFundamentals
import Web
import XMLHttpRequest

/// Return a list of SOCs and POCs, generaly used to add a charge to an order
/// - Parameters:
///   - term: Term
///   - priceType: CustAcctCostTypes cost_a, cost_b, cost_c
///   - callback: [SearchChargeResponse]
func searchCharge(
    /// Term to Search
    term: String,
    /// cost_a, cost_b, cost_c
    costType: CustAcctCostTypes,
    currentCodeIds: [UUID],
    callback: @escaping ((_ term: String, _ resp: [SearchChargeResponse])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _costType = (costType.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
        
    var _ids = "[]"
    
    do{
        let data = try JSONEncoder().encode(currentCodeIds)
        
        if let json = String(data: data, encoding: .utf8) {
            _ids = json
        }
        
    }
    catch { }
    
    _ids = (_ids.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchCharge") +
    "&term=\(_term)" +
    "&costType=\(_costType)" +
    "&currentCodes=\(_ids)"
    
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
                let resp = try JSONDecoder().decode([SearchChargeResponse].self, from: data)
                
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

