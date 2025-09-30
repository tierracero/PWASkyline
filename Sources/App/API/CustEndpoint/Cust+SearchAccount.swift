//
//  Cust+SearchAccount.swift
//  
//
//  Created by Victor Cantu on 10/25/22.
//

import Foundation
import TCFundamentals
import Web
import XMLHttpRequest

/// Return a list of accounts
/// - Parameters:
///   - term: Term
///   - priceType: CustAcctCostTypes cost_a, cost_b, cost_c
///   - callback: [SearchChargeResponse]
func searchAccount(
    /// Term to Search
    term: String,
    callback: @escaping ((_ term: String, _ resp: [CustAcctSearch])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
      
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchAccount") + "&term=\(_term)"
    
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
                let resp = try JSONDecoder().decode([CustAcctSearch].self, from: data)
                
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

