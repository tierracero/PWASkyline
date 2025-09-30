//
//  Cust+SearchVendor.swift
//  
//
//  Created by Victor Cantu on 11/21/22.
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
func searchVendor(
    /// Term to Search
    term: String,
    callback: @escaping ((_ term: String, _ resp: [CustVendorsQuick])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchVendor") + "&term=\(_term)"
    
    xhr.open(method: "GET", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")

    xhr.send("")
    
    xhr.onError {
        print("error")
        print(xhr.responseText ?? "")
        callback(term,[])
    }
    xhr.onLoad {
        
        if let data = xhr.responseText?.data(using: .utf8) {
            do {
                let resp = try JSONDecoder().decode([CustVendorsQuick].self, from: data)
                
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
