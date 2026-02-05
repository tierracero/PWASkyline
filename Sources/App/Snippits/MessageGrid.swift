//
//  MessageGrid.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Foundation
import Web

class MessageGrid: Div {
    
    override class var name: String { "div" }
    
    /// light, dark
    let style: StyleType
    
    /// Order ID
    let orderid: UUID
    
    let accountid: UUID
    
    let folio: String
    
    /// Order Name
    let name: String
    
    /// Order Mobile
    let mobile: String
    
    var notes: [CustOrderLoadFolioNotes]
    
    var lastCommunicationMethod: State<MessagingCommunicationMethods?>
    
    private var callback: ((_ note: CustOrderLoadFolioNotes) -> ())
    
    init(
        style: StyleType,
        orderid: UUID,
        accountid: UUID,
        folio: String,
        name: String,
        mobile: String,
        notes: [CustOrderLoadFolioNotes],
        lastCommunicationMethod: State<MessagingCommunicationMethods?>,
        callback: @escaping ((_ note: CustOrderLoadFolioNotes) -> ())
    ) {
        
        self.style = style
        self.orderid = orderid
        self.accountid = accountid
        self.folio = folio
        self.name = name
        self.mobile = mobile
        self.notes = notes
        self.lastCommunicationMethod = lastCommunicationMethod
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    @State var viewMessage: NoteTypes = .all
    
    @State var message: String = ""
    
    @State var buttonTitle: String = "Guardar y Enviar"
    
    @State var inputClass: Class = .textFiledLight
    
    @State var isPopup: Bool = true
    
    lazy var noteTypeFilter = Select().onChange({ event, select in
        if let type = NoteTypes(rawValue: select.value) {
            self.viewMessage = type
            _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
        }
    })
        .borderStyle(.none)
        .height(23.px)
        .fontSize(16.px)
        .class(self.$inputClass)
    
    lazy var newNoteFilter = Select().onChange({ event, select in
        if let type = NoteTypes(rawValue: select.value) {
            if type == .webNote {
                self.buttonTitle = "Guardar y Enviar"
            }
            else{
                self.buttonTitle = "Solo Guardar"
            }
        }
    })
        .borderStyle(.none)
        .height(23.px)
        .fontSize(18.px)
        .class(self.$inputClass)
    
    lazy var grid = Div()
        .id(Id("message_grid_\(self.orderid.uuidString.lowercased())"))
        .custom("height", "calc(100% - 80px)")
        .class(.roundBlue)
        .overflow(.auto)
    
    lazy var messageInput = InputText(self.$message)
    
    lazy var msgFileLoader = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "application/pdf", "video/mp4", "video/x-m4v", "video/*", "video", "pages", "numbers", "key"]) //  ".heic",
        .hidden(true)
    
    lazy var maximizeMsgView = Img()
        .src("/skyline/media/maximizeWindow.png")
        .hidden(self.$isPopup.map{ !$0 })
        .class(.iconWhite)
        .marginLeft(7.px)
        .cursor(.pointer)
        .marginTop(2.px)
        .height(18.px)
        .float(.left)
   
    /// [ Note UUID : MessageObject ]
    var noteViewCatche: [UUID:MessageObject] = [:]
    
    @DOM override var body: DOM.Content {
        Div{
            self.noteTypeFilter
                .float(.right)
            
            Span("Ver:")
                .float(.right)
                .fontSize(18.px)
                .marginRight(7.px)
                .color(.gray)
            
            H3("Notas Actuales")
                .color(.gray)
                .float(.left)
            
            self.maximizeMsgView
            
            Div().class(.clear)
        }
        
        Div().class(.clear)
            .marginTop(3.px)
        
        self.grid
        
        Div().class(.clear)
            .marginTop(3.px)
        
        Div{
            self.newNoteFilter
                .float(.right)
            
            Span("Tipo:")
                .float(.right)
                .fontSize(18.px)
                .marginRight(7.px)
                .color(.gray)
            
            H4("Nuevo Mensaje")
                .color(.lightBlueText)
        }
        
        Div().class(.clear)
            .marginTop(3.px)
        
        Div{
            
            self.messageInput
                .custom("width", "calc(100% - 260px)")
                .placeholder("Nuevo mensaje...")
                .class(self.$inputClass)
                .fontSize(23.px)
                .onEnter {
                    self.creatMessage(false)
                }
            
            self.msgFileLoader
            
            Img()
                .src("/skyline/media/mobileCamara.png")
                .height(22.px)
                .class(.iconWhite)
                .marginLeft(7.px)
                .cursor(.pointer)
                .onClick { _, event in
                     
                    let eventid = UUID()
                    
                    let view = MessageObject(
                        type: .orderFile,
                        relid: self.orderid,
                        name: self.name,
                        style: self.style,
                        note: .init(
                            id: eventid,
                            createdAt: getNow(),
                            createdBy: custCatchID,
                            type: .webNoteRep,
                            subType: .msg,
                            activity: "... cargando multimedia...",
                            commMeth: [],
                            smsStatus: nil,
                            waStatus: nil, 
                            reactions: []
                        )
                    )
                        .hidden(self.$viewMessage.map{($0 == .all || $0 == .general) ? false : true})
                    
                    self.noteViewCatche[eventid] = view
                    
                    API.custAPIV1.requestMobileCamara(
                        type: .orderMessage,
                        connid: custCatchChatConnID,
                        eventid: eventid,
                        relatedid: self.orderid,
                        relatedfolio: self.folio,
                        multipleTakes: false
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                        
                    }
                }
            
            Img()
                .src("/skyline/media/icon_clip.png")
                .height(22.px)
                .class(.iconWhite)
                .marginLeft(7.px)
                .cursor(.pointer)
                .onClick { _, event in
                    self.msgFileLoader.click()
                }
            
            Div{
                Strong(self.$buttonTitle)
                    .fontSize(18.px)
                    .color(.lightBlueText)
                    .onClick {
                        self.creatMessage(true)
                    }
                    .borderRadius(all: 7.px)
                    .border(width: .thin, style: .solid, color: .lightBlueText)
                    .paddingTop(3.px)
                    .paddingBottom(3.px)
                    .paddingLeft(7.px)
                    .paddingRight(7.px)
            }
            .marginTop(7.px)
            .width(180.px)
            .float(.right)
            .align(.center)
            
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        height(100.percent)
        width(100.percent)
        
        switch self.style{
        case .light:
            break
        case .dark:
            self.inputClass = .textFiledBlackDark
        }
        
        NoteTypes.allCases.forEach { type in
            if type.readAvailable {
                noteTypeFilter.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            if type.writeAvailable {
                newNoteFilter.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
        }
        
        msgFileLoader.$files.listen {
            $0.forEach { file in
                self.loadMedia(file)
            }
        }
        
        loadMessages()
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            print("\(#file)  event: event")
            
            switch event {
            case .requestMobileCamaraComplete:
                if let payload = self.ws.requestMobileCamaraComplete($0) {
                    
                    guard let note = payload.note else {
                        return
                    }
                    
                    if  let _ = self.noteViewCatche[payload.eventid] {
                        
                        self.noteViewCatche[payload.eventid]?.innerHTML = ""
                        
                        var _view = MessageObject(
                            type: .orderFile,
                            relid: self.orderid,
                            name: self.name,
                            style: self.style,
                            note: .init(
                                id: note.id,
                                createdAt: note.createdAt,
                                createdBy: note.createdBy,
                                type: note.type,
                                subType: note.subType,
                                activity: note.activity,
                                commMeth: note.commMeth,
                                smsStatus: note.smsStatus,
                                waStatus: note.waStatus, 
                                reactions: note.reactions
                                
                            )
                        )
                            .hidden(self.$viewMessage.map{($0 == .all || $0 == .webNoteRep) ? false : true})
                        
                        self.noteViewCatche[payload.eventid]?.appendChild(_view)
                        
                        self.noteViewCatche[payload.eventid] = _view
                        
                        _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
                        
                    }
                    
                }
            case .requestMobileCamaraFail:
                if let payload = self.ws.requestMobileCamaraFail($0) {
                    
                    if  let view = self.noteViewCatche[payload.eventid] {
                        view.remove()
                    }
                    
                }
            case .requestMobileCamaraInitiate:
                if let payload = self.ws.requestMobileCamaraInitiate($0) {
                    
                    if  let view = self.noteViewCatche[payload.eventid] {
                        
                        self.grid.appendChild(view)
                        
                        _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
                        
                    }
                    
                }
            case .requestMobileCamaraProgress:
                if let payload = self.ws.requestMobileCamaraProgress($0) {
                    if let view = self.noteViewCatche[payload.eventid] {
                        view.activity = "Cargando \(payload.percent.toString)%"
                    }
                }
            
            case .requestMobileCamaraCancel:
                if let payload = self.ws.requestMobileCamaraCancel($0) {
                    
                    if  let view = self.noteViewCatche[payload.eventid] {
                        view.remove()
                    }
                    
                }
            case .requestMobileCamaraSelected:
                if let payload = self.ws.requestMobileCamaraSelected($0) {
                    if let view = self.noteViewCatche[payload.eventid] {
                        view.activity = "Iniciando Carga.."
                    }
                }
            case .asyncFileUpload:
                if let payload = self.ws.asyncFileUpload($0) {
                    
                    if let view = self.noteViewCatche[payload.eventid] {
                        
                        view.loadPercent = ""
                        
                        view.loadImage(payload.avatar)
                        
                    }
                }
            case .asyncFileUpdate:
                if let payload = self.ws.asyncFileUpdate($0) {
                    
                    if let view = self.noteViewCatche[payload.eventId] {
                        
                        view.loadPercent = payload.message
                        
                    }
                }
            case .asyncFileOCR:
                break
            case .waMsgReactionUpdate:
                if let payload = self.ws.waMsgReactionUpdate($0) {
                    
                    self.noteViewCatche.forEach { viewId, view in
                        
                        if payload.noteid == view.note.id {
                            view.updateReactions(reactions: payload.reactions)
                        }
                        
                    }
                    
                }
            case .waMsgStatusUpdate:
                if let payload = self.ws.waMsgStatusUpdate($0) {
                    
                    self.noteViewCatche.forEach { viewId, view in
                        
                        if payload.noteid == view.note.id {
                            view.waStatus = payload.status
                        }
                        
                    }
                    
                }
            default:
                break
            }
            
        }
    }
    
    func loadMessages(){
        
        self.grid.innerHTML = ""
        
        self.notes.reversed().forEach { note in
            
            var view = MessageObject(
                type: .orderFile,
                relid: orderid,
                name: self.name,
                style: self.style,
                note: note
            )
                .hidden(self.$viewMessage.map{($0 == .all || $0 == note.type || (
                    $0 == .webNote && (
                        note.type == .webNoteClie ||
                        note.type == .webNoteClieBlur ||
                        note.type == .webNoteRep ||
                        note.type == .webNoteRepBlur ||
                        note.type == .webNoteAuto  ||
                        note.type == .webNoteAutoBlur
                    )
                )) ? false : true})
            
            self.noteViewCatche[note.id] = view
            
            self.grid.appendChild(view)
        }
        
        Dispatch.asyncAfter(0.5) {
            _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
        }
    }
    
    /// Create an new note  push to ui
    func creatMessage(_ clicked: Bool){
        
        guard let type = NoteTypes(rawValue: newNoteFilter.value)  else {
            showError(.invalidFormat, "Tipo de nota Invalida")
            return
        }
        
        if self.message.isEmpty {
            if clicked {
                self.messageInput.select()
            }
            return
        }
        
        loadingView(show: true)
        
        API.custOrderV1.addNote (
            order: self.orderid,
            type: type,
            activity: self.message,
            lastCommunicationMethod: lastCommunicationMethod.wrappedValue
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            if let note = resp.data {
            
                print("⭐️   note ")
                
                self.callback(note)
                
                notesCatch[self.orderid]?.insert(
                    .init(
                        id: note.id,
                        createdAt: note.createdAt,
                        createdBy: note.createdBy,
                        type: note.type,
                        subType: note.subType,
                        activity: note.activity,
                        commMeth: note.commMeth,
                        smsStatus: note.smsStatus,
                        waStatus: note.waStatus,
                        reactions: note.reactions
                    ),
                    at: 0
                )
                
                let view = MessageObject(
                    type: .orderFile,
                    relid: self.orderid,
                    name: self.name,
                    style: self.style,
                    note: note
                )
                    .hidden(self.$viewMessage.map{($0 == .all || $0 == note.type || (
                        $0 == .webNote && (
                            note.type == .webNoteClie ||
                            note.type == .webNoteClieBlur ||
                            note.type == .webNoteRep ||
                            note.type == .webNoteRepBlur ||
                            note.type == .webNoteAuto  ||
                            note.type == .webNoteAutoBlur
                        )
                    )) ? false : true})
                
                self.noteViewCatche[note.id] = view
                
                self.grid.appendChild(view)
                
                _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
                
                showSuccess(.operacionExitosa, "Nota Agregada")
                
                self.message = ""
            }
            else {
                print("⭕️   note ")
                showAlert(.alerta, "No se obtuvo confirmacion de la nota")
            }
        }
    }
    
    /// Recive a note form server (created by customer or other terminal/user) and push it to UI
    func reciveMessage(note: CustOrderLoadFolioNotes){
        
        print("⭐️ reciveNote ")
        
        self.callback(note)
        
        notesCatch[self.orderid]?.insert(
            note,
            at: 0
        )
        
        let view = MessageObject(
            type: .orderFile,
            relid: orderid,
            name: self.name,
            style: self.style,
            note: note
        ).hidden(self.$viewMessage.map{($0 == .all || $0 == note.type || (
            
            $0 == .webNote && (
                note.type == .webNoteClie ||
                note.type == .webNoteClieBlur ||
                note.type == .webNoteRep ||
                note.type == .webNoteRepBlur ||
                note.type == .webNoteAuto  ||
                note.type == .webNoteAutoBlur
            )
            
        )) ? false : true})
        
        self.noteViewCatche[note.id] = view
        
        self.grid.appendChild(view)
        
        _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
        
    }

    func loadMedia(_ file: File) {
        

        let fileSize = (file.size / 1000 / 1000)

        if file.type.contains("video") || file.type.contains("image") {
            if  fileSize > 30 {
                showError(.generalError, "No se pueden subir archivoa de mas de 30 mb")

                return 
            }
        }


        let xhr = XMLHttpRequest()
        
        print("🗂  \(file.type)")
        
        var subType: MessageType? = nil
        
        if file.type.contains("video/") {
            subType = .vdo
        }
        else if file.type.contains("image/") {
            subType = .img
        }
        else if file.type == "application/pdf"{
            subType = .doc
        }
        
        guard let subType else {
            showError(.generalError, "Lo sentimos \(file.type.uppercased()) aun no son soportados.")
            return
        }
        
        var note = CustOrderLoadFolioNotes(
            id: .init(),
            createdAt: getNow(),
            createdBy: custCatchID,
            type: .webNoteRep,
            subType: subType,
            activity: "",
            commMeth: [],
            smsStatus: nil,
            waStatus: nil,
            reactions: []
        )
        
        let view = MessageObject(
            type: .orderFile,
            relid: self.orderid,
            name: self.name,
            style: self.style,
            note: note
        )
            .hidden(self.$viewMessage.map{($0 == .all || $0 == note.type || (
                $0 == .webNote && (
                    note.type == .webNoteClie ||
                    note.type == .webNoteClieBlur ||
                    note.type == .webNoteRep ||
                    note.type == .webNoteRepBlur ||
                    note.type == .webNoteAuto  ||
                    note.type == .webNoteAutoBlur
                )
            )) ? false : true})
        
        noteViewCatche[view.viewid] = view
        
        xhr.onLoadStart {
            self.grid.appendChild(view)
            _ = JSObject.global.scrollToBottom!("message_grid_\(self.orderid.uuidString.lowercased())")
        }
        
        xhr.onError { jsValue in
            
            showError(.comunicationError, .serverConextionError)
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            view.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.generalError, .serverConextionError + " 001")
                view.remove()
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.generalError, .serverConextionError + " 002")
                view.remove()
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                
                print("⭐️ resp ⭐️")
                print(resp)
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    view.remove()
                    return
                }
                
                guard let data = resp.data else {
                    showError(.generalError, "No se pudo cargar datos")
                    view.remove()
                    return
                }
                
                switch data {
                case .processing(let payload):
                    /*
                     CustComponents.UploadManagerProcessingObject
                     
                     public let fileName: String
                     
                     public let id: UUID
                     */
                    
                    view.activity = payload.fileName
                    view.note.id = payload.id
                    
                case .processed(let payload):
                    
                    /*
                    CustComponents.UploadManagerFileObject
                    
                    public var eventid: UUID
                    
                    ///image, video, pdf, doc, xml, ptt, pages, numbers, keynote, general
                    public let type: FileTypes
                    
                    ///product, service, album, blog, order, webNote
                    public let to: ImagePickerTo
                    
                    /// id to be used if registered in database
                    public var toId: UUID?
                    
                    public var mediaid: UUID?
                    
                    public var url: String
                    
                    public var fileName: String
                    
                    public var avatar: String
                    
                    public var width: Int
                    
                    public var height: Int
                    
                    public var note: CustOrderLoadFolioNotes?
                    */
                    
                    if let id = payload.note?.id {
                        view.note.id = id
                    }
                    
                    switch payload.type {
                    case .image:
                        view.activity = payload.fileName
                        view.mediaImage.load("https://\(custCatchUrl)/fileNet/thump_\(payload.fileName)")
                    case .video:
                        view.activity = payload.fileName
                        view.poster = payload.avatar
                        view.videoSrc = "https://\(custCatchUrl)/fileNet/thump_\(payload.fileName)"
                    case .audio:
                        break
                    case .pdf:
                        break
                    case .doc, .pages, .numbers, .keynote, .xml:
                        view.activity = payload.fileName
                    case .ptt:
                        break
                    case .general:
                        break
                    }
                    
                }
                
            } 
            catch {
            
                print("🔴  ERROR  🔴")
                
                print(responseText)
                
                print(error)
                
                showError(.generalError, .serverConextionError + " 003")

                return

            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
            print("🟡  \(view.loadPercent)%")
            
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        let fileName = safeFileName(name: file.name, to: .webNote, folio: self.folio)
        
        print("fileName \(fileName)")
        
        formData.append("eventid", view.viewid.uuidString)
        
        formData.append("to", ImagePickerTo.webNote.rawValue)
        
        formData.append("id", self.orderid.uuidString)
        
        formData.append("folio", self.folio)

        formData.append("file", file, filename: fileName)
        
        formData.append("fileName", fileName)

        formData.append("connid", custCatchChatConnID)
        
        formData.append("remoteCamera", false.description)
        
        // xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadMedia")
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadManager")
        
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
