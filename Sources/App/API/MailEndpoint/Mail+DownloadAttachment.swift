//
//  Mail+DownloadAttachment.swift
//  
//
//  Created by Victor Cantu on 2/19/23.
//

import Foundation
import TCFundamentals
import MailAPICore
import Web

extension MailEndpointV1 {
    
    struct GetMessageAttachment: Codable {
        
        public let username: String
        
        public let box: String
        
        public let uid: Int
        
        public let fileName: String
        
        public init(
            username: String,
            box: String,
            uid: Int,
            fileName: String
        ) {
            self.username = username
            self.box = box
            self.uid = uid
            self.fileName = fileName
        }
        
    }
    
    public func downloadAttachment(
        username: String,
        box: String,
        uid: Int,
        fileName: String
    ){
        
        let url = baseAPIUrl("https://tierracero.com/dev/skyline/api.php") + "&ie=downloadMailAttachment" +
        "&username=\(username.uriEncode)" +
        "&box=\(box.uriEncode)" +
        "&uid=\(uid.toString)" +
        "&fileName=\(fileName.uriEncode)"
        
        _ = JSObject.global.goToURL!(url)
        
    }
}
