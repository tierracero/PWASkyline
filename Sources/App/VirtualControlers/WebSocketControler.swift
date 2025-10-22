//
//  WebSocketControler.swift
//
//
//  Created by Victor Cantu on 1/26/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import WebSocketAPI
import Web

fileprivate var lastHeartBeat: Int64 = 0

func getWebsocketTokens() {
    
    if let connid = WebApp.current.window.sessionStorage.string(forKey: "custCatchChatConnID"){
        
        if connid == ""{
            custCatchChatConnID = callKey(64)
            
            WebApp.current.window.sessionStorage.set(JSString(custCatchChatConnID), forKey: "custCatchChatConnID")
        }
        else{
            custCatchChatConnID = connid
        }
        
    }
    else{
        custCatchChatConnID = callKey(64)
        WebApp.current.window.sessionStorage.set(JSString(custCatchChatConnID), forKey: "custCatchChatConnID")
    }
    
    print("⚡️⚡️  custCatchChatConnID  \(custCatchChatConnID)")
    print("⚡️⚡️  custCatchChatConnID  \(custCatchChatConnID)")
    print("⚡️⚡️  custCatchChatConnID  \(custCatchChatConnID)")
    
    
    if let token = WebApp.current.window.localStorage.string(forKey: "custCatchChatToken"){
        if token == "" {
            
            API.authV1.getChatToken { resp in
                guard let resp = resp else {
                    print("Network Error 001, WS Conect")
                    return
                }

                guard let chatToken = resp.data?.chatToken else {
                    print("un expected missing payload")
                    return
                }

                guard !chatToken.isEmpty else {
                    print("Response Error 002, WS Conect")
                    return
                }
                
                custCatchChatToken = chatToken
                WebApp.current.window.localStorage.set( JSString(custCatchChatToken), forKey: "custCatchChatToken")
                
                /// connect
                connWebsocket(interval: 0)
                
            }
            
        }
        else{
            
            custCatchChatToken = token
            /// connect
            connWebsocket(interval: 0)
        }
    }
    else{
        
        API.authV1.getChatToken { resp in
            
            guard let resp = resp else {
                print("Network Error 001, WS Conect")
                return
            }

            guard let chatToken = resp.data?.chatToken else {
                print("Unexpected misisng payload")
                return
            }

            guard !chatToken.isEmpty else {
                print("Response Error 002, WS Conect")
                return
            }
            
            custCatchChatToken = chatToken
            WebApp.current.window.localStorage.set( JSString(custCatchChatToken), forKey: "custCatchChatToken")
            
            /// connect
            connWebsocket(interval: 0)
            
        }
        
    }
}

func connWebsocket(interval: Double){
    
    if interval > 0 {
        
        Dispatch.asyncAfter(interval) {
            print("⚡️⚡️ RECON_IN \((interval - 1))")
            connWebsocket(interval: (interval - 1))
        }
        
        return
    }
    
    if custCatchChatToken.isEmpty {
        print("⚡️⚡️  🔴 websocket faild no token ")
        return
    }
    
    if custCatchChatConnID.isEmpty {
        print("⚡️⚡️  🔴 websocket faild no connid ")
        return
    }
    
    let queryParams = [
        "token": custCatchChatToken,
        "connid": custCatchChatConnID,
        "lang": "Spanish"
    ]
    
    var components = URLComponents()
    
    var cs = CharacterSet.urlQueryAllowed
    cs.remove("+")
    cs.remove("=")
    cs.remove("/")
    
    components.percentEncodedQuery = queryParams.map {
        $0.addingPercentEncoding(withAllowedCharacters: cs)! +
        "=" + $1.addingPercentEncoding(withAllowedCharacters: cs)!
    }.joined(separator: "&")
    
    guard let query = components.url?.query else {
        print("⚡️⚡️  🔴 websocket faild to prese url ")
        return
    }
    
    var url = "wss://intratc.co/ws?\(query)"
    
    if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
        //url = "wss://localhost:8800/ws?\(query)"
        print("⚡️⚡️  \(url)")
    }
    
    webSocket = WebSocket(url).onOpen {
        print("⚡️⚡️  🟢 ws connected")
        
        lastHeartBeat = getNow()
        
        Dispatch.asyncAfter(70) {
            heartBeat()
        }
        
    }.onClose { (closeEvent: CloseEvent) in
        
        print("⚡️⚡️  🟠 ws disconnected CODE: \(closeEvent.code) \(WebSocketErrorCode(rawValue: closeEvent.code)?.description ?? "") REASON: \(closeEvent.reason)")
        
        var reconect = true
        
        guard let errcode = WebSocketErrorCode(rawValue: closeEvent.code) else {
            print("⚡️⚡️  🔴 \(closeEvent.code) UNKNOWED")
            return
        }
        
        switch errcode {
        case .normalClosure:
            break
        case .goingAway:
            break
        case .protocolError:
            break
        case .unacceptableData:
            reconect = false
        case .closedNoStatus:
            break
        case .closeAbnormal:
            break
        case .dataInconsistentWithMessage:
            break
        case .policyViolation:
            reconect = false
        case .messageTooLarge:
            break
        case .missingExtension:
            break
        case .unexpectedServerError:
            break
        case .serviceResrt:
            break
        case .tryAgainLater:
            break
        case .badGateway:
            break
        case .tlsHandShakeFail:
            break
        }
        
        if reconect {
            print("⚡️⚡️ try to recon")
            connWebsocket(interval: Double.random(in: 2...5).rounded(.up))
        }
        
    }.onError { error in
        print("⚡️⚡️  🔴 ws error")
        print(error)
    }.onMessage { message in
        print("⚡️⚡️  ⚪️ ws message:")
        
        switch message.data {
        case .arrayBuffer(_):
            break
        case .blob(_):
            break
        case .text(let payload):
        
            print(payload)
            
            WebApp.current.wsevent.wrappedValue = payload
            
            let ws = WS()
            
            let (event, _) = ws.recive(payload)
            
            guard let event else {
                print("❌  payload could not be recorded TODO: create error notifier")
                
                return
            }

            switch event {
            case .welcome, .pong:
                break
            case .custFetchUsersResponse:
                break
            case .requestUserToChatResponse:
                break
            case .iAmWritingNotification:
                break
            case .reciveMessage:
                break
            case .updateMessageStatus:
                break
            case .NewChatRoomNotification:
                break
            case .NotifyLoginNotification:
                break
            case .NotifyLogoutNotification:
                break
            case .alertStatusUpdate:
                break
            case .asyncCustMessageSent:
                break
            case .asyncFileUpload:
                break
            case .asyncFileUpdate:
                break
            case .asyncRemoveBackground:
                break
            case .asyncCropImage:
                break
            case .waMsgStatusUpdate:
                break
            case .NotifyAddFacebookProfile:
                break
            case .NotifyAddYoutubeProfile:
                break
            case .NotifyAddMercadoLibreProfile:
                break
            case .metaNewMessengerPayload:
                break
            case .addSocialReaction:
                break
            case .removeSocialReaction:
                break
            case .confirmSentMessage:
                break
            case .requestMobileCamaraComplete:
                break
            case .requestMobileCamaraFail:
                break
            case .requestMobileCamaraInitiate:
                break
            case .requestMobileCamaraProgress:
                break
            case .requestMobileScannerComplete:
                break
            case .requestMobileOCRComplete:
                break
            case .custTaskAuthRequest:
                break
            case .custTaskDenied:
                break
            case .custTaskAuthoroized:
                break
            case .sendToMobile:
                break
            case .whatsAppLoadingScreen:
                break
            case .whatsAppQR:
                break
            case .whatsAppAuthenticated:
                break
            case .whatsAppAuthFailure:
                break
            case .whatsAppReady:
                break
            case .whatsAppDisconnected:
                break
            case .waMsgReactionUpdate:
                break
            case .wsLocationUpdate:
                break
            case .customerOrderStatusUpdate:
                break
            }
            
        case .unknown(let jsValue):
            print(jsValue)
            break
        }
    }
}

func heartBeat() {
    
    let interval = getNow() - lastHeartBeat
    
    //print("💗 ⚡️ heartBeat interval \(interval)")
    
    guard interval > 69 else {
        //print("🔴 heartBeat has been stoped")
        return
    }
    
    let payload = API.wsV1.PingNotification(event: "ping", payload: .init(
        msg: "💗 ⚡️ heartBeat",
        connId: custCatchChatConnID
    ))
    
    do {
        
        let data = try JSONEncoder().encode(payload)
        
        guard let str = String(data: data, encoding: .utf8) else {
            showError(.errorGeneral, "No se pudo enviar mensaje.")
            return
        }
        
        webSocket?.send(str)
        
        //print("💗 ⚡️ heartBeat 🟢")
        
        lastHeartBeat = getNow()
        
        Dispatch.asyncAfter(70) {
            heartBeat()
        }
        
    }
    catch {
        showError(.errorGeneral, "No se pudo enviar mensaje 001")
    }
    
}

