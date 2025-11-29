//
//  IMSocialChatView.swift
//  
//
//  Created by Victor Cantu on 4/19/23.
//

import Foundation
import TCFundamentals
import Web
import XMLHttpRequest
import TCFireSignal

/// Instant Comunication Room View
class IMSocialChatView: Div {
    
    override class var name: String { "div" }
    
    let roomType: RoomType
    
    /// siwe, facebook, instagram, youtube, tiktok, pintrest, twitter, snapchat, googleplus, general
    let profileType: SocialProfileType
    
    /// id, folio
    let roomid: HybridIdentifier
    
    let name: String
    
    let avatar: String
    
    let idString: String
    
    @State var lastMessageRecivedAt: Int64 = 0
    
    @State var sendeFormIsDisabled = false
    
    private let callback: ((
        _ chatIsArchived: Bool
    ) -> ())
    
    private let sentMessage: ((
        _ room: CustChatRoomProfile,
        _ message: String,
        _ lastMessageAt: Int64
    ) -> ())
    
    init(
        roomType: RoomType,
        profileType: SocialProfileType,
        roomid: HybridIdentifier,
        name: String,
        avatar: String,
        callback: @escaping ((
            _ chatIsArchived: Bool
        ) -> ()),
        sentMessage: @escaping ((
            _ room: CustChatRoomProfile,
            _ message: String,
            _ lastMessageAt: Int64
        ) -> ())
    ) {
        self.roomType = roomType
        self.profileType = profileType
        self.roomid = roomid
        self.name = name
        self.avatar = avatar
        self.callback = callback
        self.sentMessage = sentMessage
        
        switch roomid {
        case .id(let uUID):
            idString = uUID.uuidString
        case .folio(let string):
            idString = string
        }
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var roomAccountId: UUID? = nil
    
    var roomAccountToken: String? = nil
    
    lazy var headder = Div {
        Img()
            .closeButton(.uiView3)
            .onClick({ _, event in
                self.callback(false)
                self.remove()
                event.stopPropagation()
            })
        
        Div{
            Div("Archivar")
                .padding(all: 3.px)
        }
            .marginRight(12.px)
            .marginTop(-2.px)
            .class(.uibtn)
            .float(.right)
            .onClick {
                self.archiveChats()
            }
        
        //<img id="WDbVTRYf" src="/skyline/media/lowerWindow.png" class="iconWhite" style="float:right;margin-right:18.0px;margin-left:18.0px;cursor:pointer;width:24.0px;">
        
        Img()
            .src("/skyline/media/scicon_\(self.profileType.rawValue).jpg")
            .borderRadius(7.px)
            .height(28.px)
            .float(.left)
        
        H2("\(self.profileType.description) \(self.name)")
            .color(.lightBlueText)
            .fontWeight(.bold)
            .marginLeft(7.px)
            .float(.left)
        
        Div().class(.clear)
        
    }
    .id(Id(stringLiteral: "chatWindowsHeader\(idString)"))
    .backgroundColor(.black)
    .cursor(self.$cursor)
    .padding(all: 7.px)
    .height(26.px)
    
    lazy var messageGrid = Div()
        .id(Id(stringLiteral: "chatGrid\(idString)"))
        .height(100.percent)
        .width(100.percent)
        .overflow(.auto)
    
    @State var loaded: Bool = false
    
    @State var cursor: CursorType = .grab
    
    @State var message: String = ""
    
    var messageRefrence: [ String : ChatMessageView ] = [:]
    
    lazy var messageInput = InputText(self.$message)
        .height(32.px)
    
    lazy var fileLoader: InputFile = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
        .hidden(true)
    
    
    @DOM override var body: DOM.Content {
        
        self.headder
        
        Div().class(.clear)
        
        Div{
            self.messageGrid
        }
        .custom("height", "calc(100% - 88px)")
        
        Div{
            Div{
                self.fileLoader
                
                self.messageInput
                    .placeholder(LString(
                        .es("Nuevo mensaje..."),
                        .en("New message...")
                    ))
                    .fontSize(23.px)
                    .class(.textFiledBlackDark)
                    .custom("width", "calc(100% - 135px)")
                    .onEnter {
                        self.sendMessage()
                    }

                Img()
                    .src("/skyline/media/icon_clip.png")
                    .class(.iconWhite)
                    .marginLeft(7.px)
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.fileLoader.click()
                    }
                
                Div{
                    
                    Strong("Enviar")
                        .border(width: .thin, style: .solid, color: .lightBlueText)
                        .borderRadius(all: 7.px)
                        .color(.lightBlueText)
                        .paddingBottom(3.px)
                        .paddingRight(7.px)
                        .paddingLeft(7.px)
                        .paddingTop(3.px)
                        .fontSize(18.px)
                        .onClick {
                            self.sendMessage()
                        }
                    
                    Div().class(.clear)
                }
                .marginTop(7.px)
                .width(77.px)
                .float(.right)
                .align(.center)
                
            }
            .paddingTop(7.px)
            .marginLeft(7.px)
            .marginRight(7.px)
            
            Div{
                Table {
                    Tr{
                        Td("No se puede enviar mensajes a \(self.profileType.description), han pasado 24h.")
                            .verticalAlign(.middle)
                            .align(.center)
                    }
                }
                .height(100.percent)
                .width(100.percent)
                
            }
            .custom("height", "calc(100% - 0px)")
            .backgroundColor(.transparentBlack)
            .hidden(self.$sendeFormIsDisabled.map{ !$0 })
            .position(.absolute)
            .width(100.percent)
            .color(.white)
            .top(0.px)
            
        }
        .backgroundColor(.transparentBlack)
        .position(.absolute)
        .width(100.percent)
        .height(50.px)
        
        Div{
            Table{
                Tr{
                    Td("cargando...")
                        .align(.center)
                        .verticalAlign(.middle)
                        .color(.gray)
                }
            }
            .width(100.percent)
            .height(100.percent)
        }
        .position(.absolute)
        .top(0.px)
        .left(0.px)
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(.transparentBlack)
        .hidden(self.$loaded.map{ $0 })
        
    }
    
    override func buildUI() {
        
        id(Id(stringLiteral: "chatWindows\(idString)"))
        border(width: .thin, style: .solid, color: .gray)
        custom("left", "calc(50% - 400px)")
        custom("top", "calc(50% - 300px)")
        backgroundColor(.grayBlack)
        borderRadius(all: 24.px)
        position(.absolute)
        overflow(.hidden)
        height(600.px)
        width(800.px)
        
        switch roomType {
        case .userToUser:
            break
        case .public:
            self.sendeFormIsDisabled = false
        case .siweToSiwe:
            break
        case .customerService:
            break
        case .social:
            switch profileType {
            case .siwe:
                break
            case .facebook, .instagram:
                
                $lastMessageRecivedAt.listen {
                    
                    let elapsedTime = getNow() - $0
                    
                    if elapsedTime > 82800 {
                        self.sendeFormIsDisabled = true
                    }
                    else {
                        self.sendeFormIsDisabled = false
                    }
                    
                }
                
            case .youtube:
                break
            case .tiktok:
                break
            case .pintrest:
                break
            case .twitter:
                break
            case .snapchat:
                break
            case .googleplus:
                break
            case .telegram:
                break
            case .whatsapp:
                break
            case .mercadoLibre:
                break
            case .ebay:
                break
            case .amazon:
                break
            case .general:
                break
            }
        case .siweToUser:
            break
        }
        
        getUsers(storeid: nil, onlyActive: false) { users in
        
            API.wsV1.loadChatData(
                type: self.roomType,
                profileType: self.profileType,
                roomid: self.roomid
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.remove()
                    return
                }
                
                self.loaded = true
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se localizo payload de data")
                    self.callback(false)
                    self.remove()
                    return
                }
                
                self.lastMessageRecivedAt = payload.messages.last?.createdAt ?? 0
                
                self.roomAccountId = payload.roomId
                
                self.roomAccountToken = payload.roomToken
                
                payload.messages.forEach { msg in
                    
                    let view = ChatMessageView(
                        type: self.roomType,
                        note: msg,
                        users: users
                    )
                    
                    self.messageRefrence[msg.mid] = view
                    
                    self.messageGrid.appendChild(view)
                    
                }
                
                Dispatch.asyncAfter(0.3) {
                    _ = JSObject.global.scrollToBottom!("chatGrid\(self.idString)")
                }
                
                /*
                do{
                    let data = try JSONEncoder().encode(payload.messages)
                    
                    print(String(data: data, encoding: .utf8)!)
                    
                }
                catch{}
                */
                
            }
            
        }
        
        fileLoader.$files.listen {
            $0.forEach { file in
                self.loadMedia(file)
            }
        }
    }
    
    override func didAddToDOM() {
        
        super.didAddToDOM()
        
        self.headder
            .onMouseDown {
                print("onMouseDown")
                self.cursor = .grabbing
            }
            .onMouseUp {
                print("onMouseUp")
                self.cursor = .grab
            }
        
        //dragElement("chatWindows\(idString)")
        
    }
    
    func sendMessage(){
        
        /// ``Pre Validation``
        switch roomType {
        case .userToUser:
            break
        case .public:
            break
        case .siweToSiwe:
            break
        case .customerService:
            break
        case .social:
            
            switch profileType {
            case .siwe:
                break
            case .facebook, .instagram:
                   
                let elapsedTime = getNow() - lastMessageRecivedAt
                    
                if elapsedTime > 82800 {
                    
                    showError(.errorGeneral, "No se pueden mandar mensajes 24 horas despues del ultimo mensaje del cliente.")
                    
                    return
                    
                }
                
            case .youtube:
                break
            case .tiktok:
                break
            case .pintrest:
                break
            case .twitter:
                break
            case .snapchat:
                break
            case .googleplus:
                break
            case .telegram:
                break
            case .whatsapp:
                break
            case .mercadoLibre:
                break
            case .ebay:
                break
            case .amazon:
                break
            case .general:
                break
            }
            
        case .siweToUser:
            break
        }
        
        let msg = message.purgeSpaces
        
        if msg.isEmpty {
            return
        }
        
        let sincToken = getNow().toString + callKey(24)
        
        /*
         .init(
             connid: custCatchChatConnID,
             sincToken: sincToken,
             roomid: self.roomid,
             type: .msg,
             message: msg,
             replyTo: nil
         )
         */
        
        let payload = API.wsV1.SendMessageNotification(
            event: "sendMessage",
            payload: .init(
                connid: custCatchChatConnID,
                sincToken: sincToken,
                roomid: self.roomid,
                type: .msg,
                message: msg,
                replyTo: nil
            )
        )
        
        getUsers(storeid: nil, onlyActive: false) { users in
            
             let view = ChatMessageView(
                 type: self.roomType,
                 note: .init(
                    createdAt: getNow(),
                    profileType: self.profileType,
                    pageid: "",
                    roomid: "",
                    senderid: custCatchMyChatToken,
                    ownerid: custCatchMyChatToken,
                    mid: sincToken,
                    type: .msg,
                    subType: .person,
                    message: msg,
                    replyTo: nil,
                    attachment: nil,
                    isMine: true
                 ),
                 users: users
             )
             
            self.messageRefrence[sincToken] = view
            
            self.messageGrid.appendChild(view)
            
            Dispatch.asyncAfter(0.3) {
                _ = JSObject.global.scrollToBottom!("chatGrid\(self.idString)")
            }
            
            do {
                
                let data = try JSONEncoder().encode(payload)
                
                guard let str = String(data: data, encoding: .utf8) else {
                    showError(.errorGeneral, "No se pudo enviar mensaje 002")
                    return
                }
                
                webSocket?.send(str)
                
                self.message = ""
                
            }
            catch {
                showError(.errorGeneral, "No se pudo enviar mensaje 001")
            }
        }
        
        
    }
    
    func confimedRecivedMessage(sincToken: String, mid: String) {
        
        if let view = messageRefrence[sincToken] {
            
            view.status = .sent
            
            view.note.status = .sent
            
            messageRefrence[mid] = view
            
        }
        
    }
    
    func updateMessageStatus(_ data: API.wsV1.UpdateMessageStatus){
        
        switch data.type {
        case .allmsgs:
            messageRefrence.forEach { msgToken, view  in
                view.updateMessageStatus(data.status)
            }
        case .amsg:
            messageRefrence[data.token]?.updateMessageStatus(data.status)
        }
    }
    
    func addMessageToGrid(_ msg: CustSocialMessage){
        
        getUsers(storeid: nil, onlyActive: false) { users in
            
            let view = ChatMessageView(
                type: self.roomType,
                note: msg,
                users: users
            )
            
            self.messageRefrence[msg.mid] = view
            
            self.messageGrid.appendChild(view)
            
            self.lastMessageRecivedAt = msg.createdAt
            
            switch self.roomType {
            case .userToUser:
                break
            case .public:
                break
            case .siweToSiwe:
                break
            case .customerService:
                break
            case .social:
                switch self.profileType {
                case .siwe:
                    break
                case .facebook:
                    
                    guard let roomAccountId = self.roomAccountId else {
                        return
                    }
                    
                    let payload: API.wsV1.WebSocketPayload<API.wsV1.SocialMessageWasRead> = .init(
                        event: "socialMessageWasRead",
                        payload: .init(
                            socialAcct: roomAccountId
                        )
                    )
                    
                    do {
                        
                        let data = try JSONEncoder().encode(payload)
                        
                        guard let str = String(data: data, encoding: .utf8) else {
                            showError(.errorGeneral, "No se pudo enviar mensaje 002")
                            return
                        }
                        
                        webSocket?.send(str)
                        
                        self.message = ""
                        
                    }
                    catch {
                        showError(.errorGeneral, "No se pudo enviar mensaje 001")
                    }
                    
                case .instagram:
                    break
                case .youtube:
                    break
                case .tiktok:
                    break
                case .pintrest:
                    break
                case .twitter:
                    break
                case .snapchat:
                    break
                case .googleplus:
                    break
                case .telegram:
                    break
                case .whatsapp:
                    break
                case .mercadoLibre:
                    break
                case .ebay:
                    break
                case .amazon:
                    break
                case .general:
                    break
                }
            case .siweToUser:
                break
            }
            
            
            Dispatch.asyncAfter(0.3) {
                _ = JSObject.global.scrollToBottom!("chatGrid\(self.idString)")
            }
            
            
        }
        
    }
    
    func archiveChats(){
        
        addToDom(ConfirmView(type: .yesNo, title: "Archivar Conversacion", message: "¿Desea cerrar la interaccion y archivar esta conversación ?", callback: { isConfirmed, comment in
            
            if isConfirmed {
                
                loadingView(show: true)
                
                API.wsV1.archiveChat(
                    roomid: self.roomid,
                    pageid: ""
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        self.remove()
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        self.remove()
                        return
                    }
                    
                    self.callback(true)
                    
                    self.remove()
                    
                }
            }
            
        }))
        
    }
    
    func loadMedia(_ file: File) {
        
        guard let roomAccountToken else {
            return
        }
        
        getUsers(storeid: nil, onlyActive: false) { users in
            
            let xhr = XMLHttpRequest()
            
            print("🗂  \(file.type)")
            
            var subType: MessageType? = nil
            
            /*
            if file.type.contains("video/") {
                subType = .vdo
            }
            else if file.type.contains("image/") {
                subType = .img
            }
            else if file.type == "application/pdf"{
                
            }
            */
            
            if file.type.contains("image/") {
                subType = .img
            }
            
            guard let subType else {
                _ = JSObject.global.alert!( "Lo sentimos solo fotos son soportadas.")
                return
            }
            
            let mid = getNow().toString + callKey(24)
            
            xhr.onLoadStart {
                
                //CustSocialMessage
                 let view = ChatMessageView(
                     type: self.roomType,
                     note: .init(
                        createdAt: getNow(),
                        profileType: self.profileType,
                        pageid: "",
                        roomid: "",
                        senderid: custCatchMyChatToken,
                        ownerid: custCatchMyChatToken,
                        mid: mid,
                        type: .msg,
                        subType: .person,
                        message: "Cargando...",
                        replyTo: nil,
                        attachment: nil,
                        isMine: true
                     ),
                     users: users
                 )
                
                self.messageRefrence[mid] = view
                
                self.messageGrid.appendChild(view)
                
                _ = JSObject.global.scrollToBottom!("chatGrid\(self.idString)")
            }
            
            xhr.onError { jsValue in
                _ = JSObject.global.alert!("Server Conection Error")
                self.messageRefrence[mid]?.remove()
                self.messageRefrence.removeValue(forKey: mid)
                //self.saveChatData(mid)
            }
            
            xhr.onLoadEnd {
                
                self.messageRefrence[mid]?.messageText = ""
                
                guard let responseText = xhr.responseText else {
                    _ = JSObject.global.alert!("Error de conexion 001")
                    self.messageRefrence[mid]?.remove()
                    self.messageRefrence.removeValue(forKey: mid)
                    //self.saveChatData(mid)
                    return
                }
                
                guard let data = responseText.data(using: .utf8) else {
                    _ = JSObject.global.alert!("Error de conexion 002")
                    self.messageRefrence[mid]?.remove()
                    self.messageRefrence.removeValue(forKey: mid)
                    //self.saveChatData(mid)
                    return
                }
                
                do {
                    
                    let resp = try JSONDecoder().decode(APIResponseGeneric<CustComponents.UploadMediaResponse>.self, from: data)
                    
                    guard resp.status == .ok else {
                        print("🔴 UPLAD ERROR")
                        print(resp)
                        _ = JSObject.global.alert!( resp.msg)
                        self.messageRefrence[mid]?.remove()
                        self.messageRefrence.removeValue(forKey: mid)
                        return
                    }
                    
                    guard let file = resp.data else {
                        _ = JSObject.global.alert!( "No se pudo cargar datos")
                        self.messageRefrence[mid]?.remove()
                        self.messageRefrence.removeValue(forKey: mid)
                        return
                    }
                    
                    print("⭐️  subType  \(subType.rawValue)")
                    
                    switch subType {
                    case .msg, .msgQry, .msgRsp, .link:
                        /// these cases are not suported by file uploder method
                        break
                    case .img:
                        
                        print("newFile")
                        print("https://\(custCatchUrl)/fileNet/\(file.file)")
                        
                        self.messageRefrence[mid]?.messageText = file.file
                        
                        self.messageRefrence[mid]?.newMedia(mediaUrl: "https://\(custCatchUrl)/fileNet/\(file.file)")
                        
                        self.messageRefrence[mid]?.updateMessageStatus(.sent)
                        
                    case .doc:
                        break
                    case .voice:
                        break
                    case .vdo:
                        break
                    }
                    
                    Dispatch.asyncAfter(0.3) {
                        _ = JSObject.global.scrollToBottom!("chatGrid\(self.idString)")
                    }
                    
                    
                }
                catch {
                    
                    print("🔴  decode ERROR")
                    
                    print(error)
                    
                    return
                }
                
            }
            
            xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
                let event = ProgressEvent(_event.jsEvent)
                self.messageRefrence[mid]?.messageText = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString + "%"
                
                print("🟡 \(((Double(event.loaded) / Double(event.total)) * 100).toInt.toString)%")
                
            }
            
            xhr.onProgress { event in
                print("⭐️  002")
                print(event.loaded)
                print(event.total)
            }
            
            let formData = FormData()
            
            let fileName = safeFileName(name: file.name, to: .chat, folio: nil)
            
            formData.append("event", UUID().uuidString)
            
            formData.append("to", ImagePickerTo.chat.rawValue)
            
            //formData.append("id", )
            
            //formData.append("folio", )
            
            formData.append("fileName", fileName)

            formData.append("file", file, filename: fileName)
            
            formData.append("connid", custCatchChatConnID)
            
            formData.append("roomtoken", roomAccountToken)
            
            formData.append("usertoken", custCatchMyChatToken)
            
            formData.append("mid", mid)
            // Optional
            // formData.append("replyTo", chatUserToken)
            
            xhr.open(method: "POST", url: "https://intratc.co/api/v1/uploadMediaPublic")
            
            xhr.setRequestHeader("Accept", "application/json")
            
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
            
            xhr.send(formData)
            
        }
        
    }
}
