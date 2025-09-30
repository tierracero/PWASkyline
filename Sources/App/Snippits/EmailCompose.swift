//
//  EmailCompose.swift
//  
//
//  Created by Victor Cantu on 2/19/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import Web
import XMLHttpRequest

class EmailCompose: Div {
    
    override class var name: String { "div" }
    
    var uid: Int?
    
    @State var subject: String
    
    var sender: EmailAddress
    
    var recipients: [EmailAddress]
    
    init(
        uid: Int?,
        subject: String,
        sender: EmailAddress,
        recipients: [EmailAddress]
    ) {
        
        self.uid = uid
        self.subject = subject
        self.sender = sender
        self.recipients = recipients
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var emailBody = ""
    
    @State var sendersString = ""
    
    lazy var senderField = InputText(self.$sendersString)
        .placeholder("Seleccione Remitente")
        .class(.textFiledBlackDark)
        .width(99.percent)
        .disabled(true)
        .height(31.px)
    
    @State var recipientsString = ""
    
    lazy var recipientsField = InputText(self.$recipientsString)
        .custom("width", "calc(100% - 50px)")
        .placeholder("Ingrese  Receptores")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    lazy var subjectField = InputText(self.$subject)
        .class(.textFiledBlackDark)
        .placeholder("Asunto...")
        .width(99.percent)
        .height(31.px)
    
    lazy var attachmentView = Div()
        .custom("height", "calc(100% - 90px)")
    .class(.roundDarkBlue)
    
    //var imageRefrence: []
    
    var filesRefrence: [UUID : NewMailAttachment] = [:]
    
    lazy var fileInput = InputFile()
        .multiple(true)
        .display(.none)
    
    @State var addContactViewIsHidden = true
    @State var addContactName = ""
    @State var addContactEmail = ""
    
    @DOM override var body: DOM.Content {
        
        Div{
        
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$subject.map{ $0.isEmpty ? "- Sin Asunto -" : $0 })
                    .color(.white)
            }
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                Div{
                    Div("De")
                        .padding(all: 12.px)
                        .width(20.percent)
                        .color(.white)
                        .float(.left)
                    
                    Div{
                        self.senderField
                    }
                    .width(73.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                    Div("Para")
                        .padding(all: 12.px)
                        .width(20.percent)
                        .color(.white)
                        .float(.left)
                    
                    Div{
                        
                        self.recipientsField
                            .float(.left)
                        
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .cursor(.pointer)
                                .marginTop(5.px)
                                .width(24.px)
                                .onClick {
                                    self.addContactName = ""
                                    self.addContactEmail = ""
                                    self.addContactViewIsHidden = false
                                }
                        }
                        .align(.center)
                        .float(.right)
                        .width(24.px)
                        
                    }
                    .width(73.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                    
                    Div("Asunto")
                        .padding(all: 12.px)
                        .width(20.percent)
                        .color(.white)
                        .float(.left)
                    
                    Div{
                        self.subjectField
                    }
                    .width(73.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                    TextArea(self.$emailBody)
                        .placeholder("Ingrse mensaje...")
                        .custom("height", "calc(100% - 145px)")
                        .padding(all: 3.px)
                        .width(98.percent)
                        .fontSize(23.px)
                    
                }
                .custom("width", "calc(100% - 324px)")
                .height(100.percent)
                .marginRight(7.px)
                .overflow(.auto)
                .float(.left)
                
                Div{
                    Div {
                        
                        Img()
                            .src("/skyline/media/add.png")
                            .cursor(.pointer)
                            .float(.right)
                            .width(24.px)
                            .onClick {
                                self.fileInput.click()
                            }
                        
                        H2("Archivos Adjuntos")
                            .color(.white)
                            .marginBottom(7.px)
                         
                    }
                    
                    self.attachmentView
                    
                    Div("Enviar")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(95.percent)
                    .marginTop(7.px)
                    .onClick {
                        self.sendEmail()
                    }
                }
                .height(99.percent)
                .padding(all: 3.px)
                .margin(all: 3.px)
                .width(300.px)
                .float(.left)
            }
            .custom("height", "calc(100% - 40px)")
            .marginTop(7.px)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .width(80.percent)
        .left(10.percent)
        .top(10.percent)
        
        Div {
            Div{
            
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.addContactViewIsHidden = true
                        }
                    
                    H2("Agregar Receptor")
                        .color(.white)
                    
                    Label("Nombre")
                        .marginBottom(7.px)
                        .color(.white)
                    
                    InputText(self.$addContactName)
                        .custom("width", "calc(100% - 50px)")
                        .placeholder("Nombre Receptore")
                        .class(.textFiledBlackDark)
                        .marginBottom(7.px)
                        .height(31.px)
                    
                    
                    Label("Correo Electronico")
                        .marginBottom(7.px)
                        .color(.white)
                    
                    InputText(self.$addContactEmail)
                        .custom("width", "calc(100% - 50px)")
                        .placeholder("Correo Receptore")
                        .class(.textFiledBlackDark)
                        .marginBottom(7.px)
                        .height(31.px)
                    
                    Div{
                        Div("+ Agregar")
                            .class(.uibtnLargeOrange)
                            .onClick {
                                
                                if self.addContactName.isEmpty {
                                    showError(.errorGeneral, "Ingrese nombre")
                                    return
                                }
                                
                                if self.addContactEmail.isEmpty {
                                    showError(.errorGeneral, "Ingrese nombre")
                                    return
                                }
                                
                                var duplicate = false
                                
                                self.recipients.forEach { contact in
                                    if contact.email == self.addContactEmail.purgeSpaces {
                                        duplicate = true
                                    }
                                }
                                
                                if duplicate {
                                    showError(.errorGeneral, "Contacto Duplicado")
                                    return
                                }
                                
                                self.recipientsString += " \(self.addContactName.purgeSpaces) <\(self.addContactEmail.purgeSpaces)>;"
                                
                                self.recipients.append(.init(personal: self.addContactName, email: self.addContactEmail))
                                
                                self.addContactViewIsHidden = true
                                
                            }
                    }
                    .marginBottom(7.px)
                    .align(.right)
                    
                }
            }
            
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(30.percent)
            .width(30.percent)
            .left(35.percent)
            .top(35.percent)
        }
        .hidden(self.$addContactViewIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        senderField.text = "\(sender.personal) <\(sender.email)>".purgeSpaces
        
        recipients.forEach { email in
            recipientsString += " \(email.personal) <\(email.email)>;".purgeSpaces
        }
     
        recipientsString = recipientsString.purgeSpaces
        
        fileInput.$files.listen {
            
            $0.forEach { file in
                self.loadMedia(file)
            }
            
            
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func sendEmail() {
        //send
        
        if subject.isEmpty {
            showError(.campoRequerido, "Incluya Asunto")
            return
        }
        
        if emailBody.isEmpty {
            showError(.campoRequerido, "Incluya Mensaje")
            return
        }
        
        loadingView(show: true)
        
        API().mailV1.send(
            uid: uid,
            sender: sender,
            recipients: recipients,
            subject: subject,
            body: emailBody,
            attachments: filesRefrence.map {  $0.value.fileName }
        ) { resp in
            loadingView(show: false)
            
            guard let resp else{
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            showSuccess(.operacionExitosa, "Correo Enviado")
            
            self.remove()
            
        }
    }
    
    
    func loadMedia(_ file: File) {
        
        struct _Decoder: Codable {
            
            let status: APIStatus
            
            let msg: String
            
        }
        
        let xhr = XMLHttpRequest()
        
        let view = NewMailAttachment(file: file) { viewid in
            
            self.filesRefrence[viewid]?.remove()
            
            self.filesRefrence.removeValue(forKey: viewid)
            
        }
        
        filesRefrence[view.viewid] = view

        xhr.onLoadStart {
            self.attachmentView.appendChild(view)
        }

        xhr.onError { jsValue in
            
            showError(.errorDeCommunicacion, .serverConextionError)
            
            self.filesRefrence[view.viewid]?.remove()
            self.filesRefrence.removeValue(forKey: view.viewid)
        }

        xhr.onLoadEnd {

            view.loadPercent = ""

            guard let responseText = xhr.responseText else {
                showError(.errorGeneral, .serverConextionError + " 001")
                
                self.filesRefrence[view.viewid]?.remove()
                self.filesRefrence.removeValue(forKey: view.viewid)
                
                return
            }

            print("upload attach")
            
            
            print(responseText)
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.errorGeneral, .serverConextionError + " 002")
                
                self.filesRefrence[view.viewid]?.remove()
                self.filesRefrence.removeValue(forKey: view.viewid)
                
                return
            }
            
            do {
                let payload = try JSONDecoder().decode(_Decoder.self, from: data)
                
                if payload.status != .ok {
                    
                    self.filesRefrence[view.viewid]?.remove()
                    self.filesRefrence.removeValue(forKey: view.viewid)
                    
                    showError(.errorGeneral, payload.msg)
                    
                }
                
                view.fileName = payload.msg
                
                view.isuploaded = true
                
            }
            catch {
                
                self.filesRefrence[view.viewid]?.remove()
                self.filesRefrence.removeValue(forKey: view.viewid)
                
            }
        }

        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
        }

        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }

        let formData = FormData()

        formData.append("file", file, filename: file.name)

        xhr.open(method: "POST", url: "https://tierracero.co/api/uploader.php")

        xhr.setRequestHeader("Accept", "application/json")

//        if let jsonData = try? JSONEncoder().encode(APIHeader(
//            AppID: thisAppID,
//            AppToken: thisAppToken,
//            user: custCatchUser,
//            mid: custCatchMid,
//            key: custCatchKey,
//            token: custCatchToken,
//            tcon: .web
//        )){
//            if let str = String(data: jsonData, encoding: .utf8) {
//                let utf8str = str.data(using: .utf8)
//                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
//                    xhr.setRequestHeader("Authorization", base64Encoded)
//                }
//            }
//        }

        xhr.send(formData)
//
    }
    
}

extension EmailCompose {
 
    public struct EmailAddress: Codable {
        
        public let personal: String
        
        public let email: String
        
        public init(
            personal: String,
            email: String
        ) {
            self.personal = personal
            self.email = email
        }
    }
    
}
