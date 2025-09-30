//
//  Mail+Open.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import XMLHttpRequest

extension MailEndpointV1 {
    
    public struct OpenRequest: Codable {
        
        public let username: String
        
        public var box: String
        
        public var uid: Int
        
        public init(
            username: String,
            box: String,
            uid: Int
        ) {
            self.username = username
            self.box = box
            self.uid = uid
        }
    }
    
    
    
    func open(
        username: String,
        box: String,
        uid: Int,
        callback: @escaping ((
            _ resp: MailAPIResponset<MessageMail>?
        )->())
    ){
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl(
            "https://tierracero.com/dev/skyline/api.php"
        ) + "&ie=openMail"
        
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
            tcon: .web, 
            applicationType: .customer
        )){
            
            if let str = String(data: jsonData, encoding: .utf8) {
                
                let utf8str = str.data(using: .utf8)
                
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
            
        }
        
        var payload = ""
        
        let object = OpenRequest(
            username: username,
            box: box,
            uid: uid
        )
        
        do {
            
            let data = try JSONEncoder().encode(object)
            
            if let json = String(data: data, encoding: .utf8) {
                payload = json
            }
            
        } catch { }
        
        
        xhr.send(payload)
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(nil)
        }
        
        xhr.onLoad {
            
            print("🟢 🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  ")
            
            print(xhr.responseText!)
            
            if let data = xhr.responseText?.data(using: .utf8) {
                do {
                    let resp = try JSONDecoder().decode(MailAPIResponset<MessageMail>.self, from: data)
                    
                    callback(resp)
                    
                }
                catch {
                    
                    print(error)
                    callback(nil)
                    
                }
            }
            else{
                
                callback(nil)
                
            }
        }
    }
}

