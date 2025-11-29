//
//  Mail+Box.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//

import Foundation
import TCFundamentals
import MailAPICore
import XMLHttpRequest
import Web

extension MailComponents {
    
    public struct BoxRequest: Codable {
        
        public let username: String
        
        public var box: String
        
        public init(
            username: String,
            box: String
        ) {
            self.username = username
            self.box = box
        }
    }
    
    public func box(
        username: String,
        box: String,
        callback: @escaping ((
            _ resp: MailAPIResponset<[MessagePreview]>?
        )->())
    ){
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") +
        "&ie=getMailBox"
        
        xhr.open(method: "POST", url: url)
        
        xhr.setRequestHeader("Accept", "application/json")
            .setRequestHeader("Content-Type", "application/json")
            .setRequestHeader("AppName", applicationName)
            .setRequestHeader("AppVersion", SkylineWeb().version.description)
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
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
        
        do {
            let data = try JSONEncoder().encode(BoxRequest(
                    username: username,
                    box: box
                ))
            
            if let json = String(data: data, encoding: .utf8) {
                payload = json
            }
        }
        catch {}
        
        xhr.send(payload)
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(nil)
        }
        
        xhr.onLoad {
            
            if let data = xhr.responseText?.data(using: .utf8) {
                do {
                    let resp = try JSONDecoder().decode(MailAPIResponset<[MessagePreview]>.self, from: data)
                    callback(resp)
                } catch  {
                    print("📩  🔴  📩  🔴  📩  🔴  📩  \(#function)")
                    print(error)
                    print(xhr.responseText!)
                    callback(nil)
                }
            }
            else{
                print("📩  📩  📩  📩  📩  📩  📩  \(#function)")
                print("🔴  EMPRTY_BODY  🔴")
                callback(nil)
            }
        }
        
    }
}

