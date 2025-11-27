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
    term: String,
    costType: CustAcctCostTypes,
    currentCodeIds: [UUID],
    accountId: UUID?,
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
    
    var url = baseAPIUrl("https://intratc.co/api/cust/v1/searchCharge") +
    "&term=\(_term)" +
    "&costType=\(_costType)" +
    "&currentCodes=\(_ids)"
    
    if let accountId {
        let _accountId = (accountId.uuidString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")

        url += "&accountId=\(_accountId)"
    }

    if WebApp.shared.window.location.hostname == "localhost" {
        print(url)
    }

    xhr.open(method: "GET", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")
        .setRequestHeader("AppName", applicationName)
        .setRequestHeader("AppVersion", SkylineWeb().version.description)

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

