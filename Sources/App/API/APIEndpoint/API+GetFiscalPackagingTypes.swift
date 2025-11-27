//
//  API+GetFiscalPackagingTypes.swift
//  
//
//  Created by Victor Cantu on 1/12/23.
//

import Foundation
import TCFundamentals
import Web
import XMLHttpRequest

/// Return a list of SOCs and POCs, generaly used to add a charge to an order
/// - Parameters:
///   - term: Term
///   - callback: [APISearchResultsGeneral]
func getFiscalPackagingTypes(
    /// Term to Search
    term: String,
    callback: @escaping ((_ term: String, _ resp: [APISearchResultsGeneral])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
       
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl( "https://intratc.co/api/v1/getFiscalPackagingTypes") + "&term=\(_term)"
    
    print(url)
    
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
                let resp = try JSONDecoder().decode([APISearchResultsGeneral].self, from: data)
                
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

