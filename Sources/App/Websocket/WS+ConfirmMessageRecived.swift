//
//  WS+ConfirmMessageRecived.swift
//  
//
//  Created by Victor Cantu on 8/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension WS {
    
    /// Sends acknolegment to server  that a terminal has revived the message
    /// - Parameters:
    ///   - room: Chat Room
    ///   - token: Message Token
    func confirmMessageRecived(_ roomToken: String, token: String) {
        
        let payload = API.wsV1.UpdateMessageStatusNotification(
            event: "updateMessageStatus",
            payload: .init(
                roomToken: roomToken,
                token: token, 
                noteId: nil,
                type: .amsg,
                status: .recived
            )
        )
        
        do {
            let data = try JSONEncoder().encode(payload)
            guard let str = String(data: data, encoding: .utf8) else {
                showError(.generalError, "No se pudo enviar mensaje 002")
                return
            }
            
            webSocket?.send(str)
            
        }
        catch {
            
        }
        
    }
}
