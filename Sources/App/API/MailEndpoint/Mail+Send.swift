//
//  Mail+Sent.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import XMLHttpRequest
import Web

extension MailComponents {
    
    func send(
        uid: Int?,
        sender: EmailCompose.EmailAddress,
        recipients: [EmailCompose.EmailAddress],
        subject: String,
        body: String,
        attachments: [String],
        callback: @escaping ((_ resp: ApiResponse?)->())
    ){
        
        struct Payload: Codable {
            let uid: Int?
            let sender: EmailCompose.EmailAddress
            let recipients: [EmailCompose.EmailAddress]
            let subject: String
            let body: String
            let files: [String]
        }
        
        if recipients.isEmpty {
            return
        }
        
        let xhr = XMLHttpRequest()
        
        let url = baseAPIUrl( "https://intratc.co/api/cust/v1/sendEmail")
        
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
        
        let _subject: String = subject.purgeSpaces
        
        let _body: String = body.purgeSpaces
        
        var json = ""
        
        do {
            
            let data = try JSONEncoder().encode(Payload(
                uid: uid,
                sender: sender,
                recipients: recipients,
                subject: _subject,
                body: _body,
                files: attachments
            ))
            
            if let string = String(data: data, encoding: .utf8) {
                
                json = string
                
            }
            else{
                callback(nil)
                showError(.generalError, "Error al codificar mensaje 001")
                return
            }
            
        }
        catch {
            callback(nil)
            showError(.generalError, "Error al codificar mensaje 002")
            return
        }
        
        xhr.send(json)
        
        xhr.onError {
            print("error")
            print(xhr.responseText ?? "")
            callback(nil)
        }
        
        xhr.onLoad {
            
            print("✉️ sent email response")
            
            print(xhr.responseText ?? "")
            
            if let data = xhr.responseText?.data(using: .utf8) {
                
                do {
                    
                    let resp = try JSONDecoder().decode(ApiResponse.self, from: data)
                    
                    callback(resp)
                    
                }
                catch  {
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

