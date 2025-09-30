//
//  Mail+Flag.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//

import Foundation
import MailAPICore
import XMLHttpRequest

extension MailEndpointV1 {
    /*
    func flag(
        
        callback: @escaping ((_ term: String, _ resp: [APISearchResultsGeneral])->())
    ){
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl(
            "https://tierracero.com/dev/skyline/api.php?" +
            "ie=flagMail"
        )
        
        xhr.open(method: "POST", url: url)
        
        xhr.setRequestHeader("Accept", "application/json")
            .setRequestHeader("Content-Type", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web
        )){
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        let formData = FormData()
        
        formData.append("file", file, filename: file.name)
        
        xhr.send(formData)
        
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
     */
}
