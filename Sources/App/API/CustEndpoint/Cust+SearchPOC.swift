//
//  Cust+SearchPOC.swift
//  
//
//  Created by Victor Cantu on 9/15/22.
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
func searchPOC(
    /// Term to Search
    term: String,
    /// cost_a, cost_b, cost_c
    costType: CustAcctCostTypes,
    getCount: Bool,
    callback: @escaping ((_ term: String, _ resp: [SearchPOCResponse])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let _costType = (costType.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
        
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl("https://intratc.co/api/cust/v1/searchPOC") +
    "&term=\(_term)" +
    "&costType=\(_costType)" +
    "&getCount=\(getCount)"
    
    xhr.open(method: "GET", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")

    if let jsonData = try? JSONEncoder().encode(APIHeader(
        AppID: thisAppID,
        AppToken: thisAppToken,
        user: custCatchUser,
        mid: custCatchMid,
        key: custCatchKey,
        token: thisAppToken,
        tcon: .web, 
        applicationType: .customer
    )){
        if let str = String(data: jsonData, encoding: .utf8){
            let utf8str = str.data(using: .utf8)
            if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
//                print("Authorization")
//                print(base64Encoded)
                xhr.setRequestHeader("Authorization", base64Encoded)
            }
        }
    }
    
    xhr.send()
    
    xhr.onError {
        print("error")
        print(xhr.responseText ?? "")
        callback(term,[])
    }
    xhr.onLoad {
        
        if let data = xhr.responseText?.data(using: .utf8) {
            do {
                let resp = try JSONDecoder().decode([SearchPOCResponse].self, from: data)
                
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
