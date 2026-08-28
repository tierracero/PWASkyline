//
//  Tools+SystemSettings+CommunicationProfile.swift
//
//  Created by OpenAI on 6/21/26.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension ToolsView.SystemSettings {
    
    class CommunicationProfile: Div {
        
        override class var name: String { "div" }

        var viewId: UUID = .init()
        
        init(communicationProfile: CustCommunicationProfile) {
            self.orderCommunicationProfile = communicationProfile.orderCommunicationProfile
            self.saleCommunicationProfile = communicationProfile.saleCommunicationProfile
            self.dateCommunicationProfile = communicationProfile.dateCommunicationProfile
            self.rentCommunicationProfile = communicationProfile.rentCommunicationProfile
            self.welcomeMessageSalute = communicationProfile.welcomeMessage.salute.joined(separator: "\n")
            self.welcomeMessageBody = communicationProfile.welcomeMessage.body.joined(separator: "\n")
            self.welcomeMessageClosingMessage = communicationProfile.welcomeMessage.closingMessage.joined(separator: "\n")
            self.closingMessageSalute = communicationProfile.closingMessage.salute.joined(separator: "\n")
            self.closingMessageBody = communicationProfile.closingMessage.body.joined(separator: "\n")
            self.closingMessageClosingMessage = communicationProfile.closingMessage.closingMessage.joined(separator: "\n")
            self.closingImage = communicationProfile.closingImage ?? ""
            self.closingLink = communicationProfile.closingLink ?? ""
            self.sendFinalizedOrderFollowUp = communicationProfile.sendFinalizedOrderFollowUp?.rawValue ?? ""
            self.sendFinalizedOrderMarketingFollowUp = communicationProfile.sendFinalizedOrderMarketingFollowUp?.rawValue ?? ""
            self.sendOrderBudgetCreditExperationAlert = communicationProfile.sendOrderBudgetCreditExperationAlert?.toString ?? ""
            self.orderTermsAndConditions = communicationProfile.orderTermsAndConditions ?? ""
            self.saleTermsAndConditions = communicationProfile.saleTermsAndConditions ?? ""
            self.dateTermsAndConditions = communicationProfile.dateTermsAndConditions ?? ""
            self.rentalTermsAndConditions = communicationProfile.rentalTermsAndConditions ?? ""
            self.followUpWelcomeDocument = communicationProfile.followUpWelcomeDocument ?? ""
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }

        @State var orderCommunicationProfile: [CustCommunicationEvents] = []
        @State var saleCommunicationProfile: [CustCommunicationEvents] = []
        @State var dateCommunicationProfile: [CustCommunicationEvents] = []
        @State var rentCommunicationProfile: [CustCommunicationEvents] = []
        
        @State var welcomeMessageSalute: String = ""
        @State var welcomeMessageBody: String = ""
        @State var welcomeMessageClosingMessage: String = ""
        
        @State var closingMessageSalute: String = ""
        @State var closingMessageBody: String = ""
        @State var closingMessageClosingMessage: String = ""
        
        @State var closingImage: String = ""
        @State var closingLink: String = ""
        
        @State var sendFinalizedOrderFollowUp: String = ""
        @State var sendFinalizedOrderMarketingFollowUp: String = ""
        
        @State var sendOrderBudgetCreditExperationAlert: String = ""
        @State var orderTermsAndConditions: String = ""
        @State var saleTermsAndConditions: String = ""
        @State var dateTermsAndConditions: String = ""
        @State var rentalTermsAndConditions: String = ""
        @State var followUpWelcomeDocument: String = ""
        
        let orderCommunicationProfileDiv = Div().class(.roundDarkBlue)
        let saleCommunicationProfileDiv = Div().class(.roundDarkBlue)
        let dateCommunicationProfileDiv = Div().class(.roundDarkBlue)
        let rentCommunicationProfileDiv = Div().class(.roundDarkBlue)
        
        let ws = WS()

        var uploadFinalizeId: UUID = .init()

        var uploadFollowupId: UUID = .init()
        
        @State var uploadPercentFinilize = ""

        @State var uploadPercentFollowup = ""

        lazy var welcomeMessageSaluteTextArea = TextArea(self.$welcomeMessageSalute)
        .placeholder("Hola campeon, [CUST_NAME]\nDebe inlcuir [CUST_NAME]\nMinimo 4 elementos\nUn elemento por linea")
        .class(.textFiledBlackDark)
        .width(95.percent)
        .height(80.px)
        
        lazy var welcomeMessageBodyTextArea = TextArea(self.$welcomeMessageBody)
        .placeholder("Su [ORDER_FOLIO] esta preparadisima\nDebe inlcuir [ORDER_FOLIO]\nMinimo 4 elementos\nUn elemento por linea")
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(120.px)
        
        lazy var welcomeMessageClosingMessageTextArea = TextArea(self.$welcomeMessageClosingMessage)
        .placeholder("Estamos al pendiente\nMinimo 4 elementos\nUn elemento por linea")
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(80.px)
        
        lazy var closingMessageSaluteTextArea = TextArea(self.$closingMessageSalute)
        .placeholder("Hola campeon, [CUST_NAME]\nDebe inlcuir [CUST_NAME]\nMinimo 4 elementos\nUn elemento por linea")
        .class(.textFiledBlackDark)
        .width(95.percent)
        .height(80.px)
        
        lazy var closingMessageBodyTextArea = TextArea(self.$closingMessageBody)
        .placeholder("ya armamaos su orden [ORDER_FOLIO]\nDebe inlcuir [ORDER_FOLIO]\nMinimo 4 elementos\nUn elemento por linea")
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(120.px)
        
        lazy var closingMessageClosingMessageTextArea = TextArea(self.$closingMessageClosingMessage)
        .placeholder("Muuuuuuchas garcias\nMinimo 4 elementos\nUn elemento por linea")
            .class(.textFiledBlackDark)
            .width(95.percent)
            .height(80.px)
        
        lazy var closingLinkField = InputText(self.$closingLink)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("https://")
        
        lazy var sendFinalizedOrderFollowUpSelect = Select(self.$sendFinalizedOrderFollowUp)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var sendFinalizedOrderMarketingFollowUpSelect = Select(self.$sendFinalizedOrderMarketingFollowUp)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var sendOrderBudgetCreditExperationAlertField = InputText(self.$sendOrderBudgetCreditExperationAlert)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
            .placeholder("Dias")
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
        
        lazy var orderTermsAndConditionsField = InputText(self.$orderTermsAndConditions)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var saleTermsAndConditionsField = InputText(self.$saleTermsAndConditions)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var dateTermsAndConditionsField = InputText(self.$dateTermsAndConditions)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        lazy var rentalTermsAndConditionsField = InputText(self.$rentalTermsAndConditions)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)

        lazy var fileLoaderFinalize: InputFile = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // , ".heic"
            .hidden(true)
        
        lazy var fileLoaderFollowup: InputFile = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // , ".heic"
            .hidden(true)

        lazy var imgAvatarFinalize = Img()
            .src(self.$closingImage.map{ $0.isEmpty ? "/skyline/media/tierraceroRoundLogoWhite.svg" : "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\($0)" })
            .borderRadius(all: 24.px)
            .height(100.percent)
            .width(100.percent)
            .objectFit(.cover)
            .cursor(.pointer)
            .onClick {
                self.fileLoaderFinalize.click()
            }

        lazy var imgAvatarFollowup = Img()
            .src(self.$followUpWelcomeDocument.map{ $0.isEmpty ? "/skyline/media/tierraceroRoundLogoWhite.svg" : "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\($0)" })
            .borderRadius(all: 24.px)
            .height(100.percent)
            .width(100.percent)
            .objectFit(.cover)
            .cursor(.pointer)
            .onClick {
                self.fileLoaderFollowup.click()
            }
        @DOM override var body: DOM.Content {


            self.fileLoaderFinalize

            self.fileLoaderFollowup

            H1("Perfil de Comunicación").color(.white)
                
            Div{

                self.profileSection("Ordenes", self.orderCommunicationProfileDiv)

                Div().clear(.both).height(7.px)

                self.profileSection("Ventas", self.saleCommunicationProfileDiv)

                Div().clear(.both).height(7.px)

                self.profileSection("Citas", self.dateCommunicationProfileDiv)

                Div().clear(.both).height(7.px)

                self.profileSection("Rentas", self.rentCommunicationProfileDiv)
                
                Div().clear(.both).height(7.px)

                Div {

                    Div {
                        H3("Mensaje de Bienvenida").color(.lightBlueText)
                        self.textAreaRow("Saludo", self.welcomeMessageSaluteTextArea)
                        self.textAreaRow("Mensaje", self.welcomeMessageBodyTextArea)
                        self.textAreaRow("Cierre", self.welcomeMessageClosingMessageTextArea)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        H3("Mensaje de Cierre").color(.lightBlueText)
                        self.textAreaRow("Saludo", self.closingMessageSaluteTextArea)
                        self.textAreaRow("Mensaje", self.closingMessageBodyTextArea)
                        self.textAreaRow("Cierre", self.closingMessageClosingMessageTextArea)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)

                }

                Div {
                    
                    Div {
                        Div{
                            Label("Imagen publictaria de cierre de orden")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{

                            Div {
                                self.imgAvatarFinalize

                                Div{
                                    Table {
                                        Tr {
                                            Td(self.$uploadPercentFinilize)
                                            .verticalAlign(.middle)
                                            .align(.center)
                                            .color(.white)
                                        }
                                    }
                                    .height(100.percent)
                                    .width(100.percent)
                                }
                                .backgroundColor(.transparentBlack)
                                .position(.absolute)
                                .top(0.px)
                                .left(0.px)
                                .height(100.percent)
                                .width(100.percent)
                                .custom("z-index", "1")
                                .hidden(self.$uploadPercentFinilize.map{ $0.isEmpty })
                            }
                            .position(.relative)
                            .height(125.px)
                            .width(125.px)
                            .overflow(.hidden)

                            Div().clear(.both)    

                        }
                        .class(.oneHalf)
                        Div().clear(.both)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div {
                        Div{
                            Label("Imagen publictaria de seguimiento")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{

                            Div {
                                self.imgAvatarFollowup
                                
                                Div{
                                    Table {
                                        Tr {
                                            Td(self.$uploadPercentFollowup)
                                            .verticalAlign(.middle)
                                            .align(.center)
                                            .color(.white)
                                        }
                                    }
                                    .height(100.percent)
                                }
                                .backgroundColor(.transparentBlack)
                                .position(.absolute)
                                .top(0.px)
                                .left(0.px)
                                .height(100.percent)
                                .width(100.percent)
                                .custom("z-index", "1")
                                .hidden(self.$uploadPercentFollowup.map{ $0.isEmpty })
                            }
                            .position(.relative)
                            .height(125.px)
                            .width(125.px)
                            .overflow(.hidden)

                            Div().clear(.both)    
                            
                        }
                        .class(.oneHalf)
                        Div().clear(.both)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().clear(.both)

                }
                
                Div().clear(.both).height(7.px)
                
                self.inputRow("Link de cierre", self.closingLinkField)
                
                H3("Seguimiento").color(.lightBlueText)
                self.inputRow("Seguimiento finalizado", self.sendFinalizedOrderFollowUpSelect)
                self.inputRow("Marketing finalizado", self.sendFinalizedOrderMarketingFollowUpSelect)
                self.inputRow("Alerta exp. presupuesto/credito", self.sendOrderBudgetCreditExperationAlertField)
                
                H3("Terminos y Condiciones").color(.lightBlueText)
                self.inputRow("Orden", self.orderTermsAndConditionsField)
                self.inputRow("Venta", self.saleTermsAndConditionsField)
                self.inputRow("Cita", self.dateTermsAndConditionsField)
                self.inputRow("Renta", self.rentalTermsAndConditionsField)
                
            }
            .custom("width", "calc(100% - 14px)")
            .custom("height", "calc(100% - 92px)")
            .overflow(.auto)
            .padding(all: 7.px)
            
            Div("Guardar Cambios")
                .border(width: .thin, style: .solid, color: .darkGray)
                .custom("box-shadow", "1px 1px 28px #000000")
                .class(.uibtnLargeOrange)
                .position(.absolute)
                .bottom(12.px)
                .right(12.px)
                .onClick {
                    self.saveData()
                }

        }
        
        override func buildUI() {
            super.buildUI()
            height(100.percent)
            position(.relative)
            overflow(.hidden)
            
            self.sendFinalizedOrderFollowUpSelect.appendChild(Option("Seleccionar").value(""))
            self.sendFinalizedOrderMarketingFollowUpSelect.appendChild(Option("Seleccionar").value(""))
            
            AutoCommunicationsFollowUp.allCases.forEach { item in
                self.sendFinalizedOrderFollowUpSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
                self.sendFinalizedOrderMarketingFollowUpSelect.appendChild(
                    Option(item.description).value(item.rawValue)
                )
            }
            
            self.$orderCommunicationProfile.listen { _ in self.renderOrderProfile() }
            self.$saleCommunicationProfile.listen { _ in self.renderSaleProfile() }
            self.$dateCommunicationProfile.listen { _ in self.renderDateProfile() }
            self.$rentCommunicationProfile.listen { _ in self.renderRentProfile() }
            
            renderOrderProfile()
            renderSaleProfile()
            renderDateProfile()
            renderRentProfile()


            fileLoaderFinalize.$files.listen {
                $0.forEach { file in
                    self.loadMediaFinalize(file)
                }
            }

            fileLoaderFollowup.$files.listen {
                $0.forEach { file in
                    self.loadMediaFollowup(file)
                }
            }

            WebApp.current.wsevent.listen {
                
                if $0.isEmpty { return }
                
                let (event, _) = self.ws.recive($0)
                
                guard let event else {
                    return
                }
                
                switch event {
                case .requestMobileCamaraComplete:
                    
                    guard let payload = self.ws.requestMobileCamaraComplete($0) else {
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {

                        self.uploadPercentFinilize = ""

                        let avatar = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)"

                        self.imgAvatarFinalize.load(avatar)
                        
                    
                    }
                    else if payload.eventid == self.uploadFollowupId {

                        self.uploadPercentFollowup = ""

                        let avatar = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)"

                        self.imgAvatarFollowup.load(avatar)
                        
                    } 

                case .requestMobileCamaraFail:

                    guard let payload = self.ws.requestMobileCamaraFail($0) else {
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {

                        showError(.generalError, "No se pudo iniciar camara")

                        self.uploadPercentFinilize = ""

                    }
                    else if payload.eventid == self.uploadFollowupId {
                        self.uploadPercentFollowup = ""
                    }

                    

                case .requestMobileCamaraInitiate:

                    if let payload = self.ws.requestMobileCamaraInitiate($0) {
                        
                        if payload.eventid == self.uploadFinalizeId {
                            self.uploadPercentFinilize = "Se inicio camara"
                        }
                        else if payload.eventid == self.uploadFollowupId {
                            self.uploadPercentFollowup = "Se inicio camara"
                        }

                    }
                
                case .requestMobileCamaraProgress:
                    
                    guard let payload = self.ws.requestMobileCamaraProgress($0) else {
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {
                        self.uploadPercentFinilize = "\(payload.percent.toString)%"
                    }
                    else if payload.eventid == self.uploadFollowupId {
                        self.uploadPercentFollowup = "\(payload.percent.toString)%"
                    }
                    
                case .requestMobileCamaraCancel:

                    guard let payload = self.ws.requestMobileCamaraCancel($0) else {
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {
                        self.uploadPercentFinilize = ""
                    }
                    else if payload.eventid == self.uploadFollowupId {
                        self.uploadPercentFollowup = ""
                    }
                    
                case .requestMobileCamaraSelected:
                    
                    guard let payload = self.ws.requestMobileCamaraSelected($0) else {
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {
                        self.uploadPercentFinilize = "Iniciando Carga..."
                    }
                    else if payload.eventid == self.uploadFollowupId {
                        self.uploadPercentFollowup = "Iniciando Carga..."
                    }

                case .asyncFileUpload:

                    guard let payload = self.ws.asyncFileUpload($0) else {
                        print("🔴 DECODE FAIL asyncFileUpload")
                        return
                    }

                    if payload.eventid == self.uploadFinalizeId {
                            
                        self.uploadPercentFinilize = ""

                        let avatar = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)"

                        print("⚠️ FINILIZE \(avatar) ")

                        self.imgAvatarFinalize.load(avatar)
                        
                    }
                    else if payload.eventid == self.uploadFollowupId {
                            
                        self.uploadPercentFollowup = ""

                        let avatar = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)"

                        print("⚠️ FOLLOWUP \(avatar) ")

                        self.imgAvatarFollowup.load(avatar)
                        
                    }
                    else {
                        print("🔴 FAILED ID asyncFileUpload")
                    }

                case .asyncFileUpdate:
                    
                    guard let payload = self.ws.asyncFileUpdate($0) else {
                        return
                    }

                    if payload.eventId == self.uploadFinalizeId {
                        self.uploadPercentFinilize = payload.message
                    }
                    else if payload.eventId == self.uploadFollowupId {
                        self.uploadPercentFollowup = payload.message
                    }
                    
                default:
                    break
                }
            }

        }

        func loadMediaFinalize(_ file: File) {
            
            let xhr = XMLHttpRequest()
            
            xhr.onLoadStart {
                self.uploadPercentFinilize = "0"
            }
            
            xhr.onError { jsValue in
                _ = JSObject.global.alert!("Server Conection Error")
                self.uploadPercentFinilize = ""
                //self.saveChatData(mid)
            }
            
            xhr.onLoadEnd {
                
                guard let responseText = xhr.responseText else {
                    _ = JSObject.global.alert!("Error de conexion 001")
                    self.uploadPercentFinilize = ""
                    return
                }
                
                print("⚠️ responseText")
                print(responseText)

                guard let data = responseText.data(using: .utf8) else {
                    _ = JSObject.global.alert!("Error de conexion 002")
                    self.uploadPercentFinilize = ""
                    return
                }
                
                do {
                    self.uploadPercentFinilize = ""
                    
                    let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        
                        return
                    }
                    
                    guard let process = resp.data else {
                        showError(.generalError, "No se pudo cargar datos")
                        return
                    }
                    
                    switch process {
                    case .processing(let process):
                        
                        self.uploadPercentFinilize = "processando..."
                        
                        print("⚠️  processando...")
                        print(process)

                    case .processed(let payload):
                        
                        self.imgAvatarFinalize.load("https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)")
                        
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
                
                self.uploadPercentFinilize = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString + "%"
                
                print("🟡 \(((Double(event.loaded) / Double(event.total)) * 100).toInt.toString)%")
                
            }
            
            xhr.onProgress { event in
                print("⭐️ uploadPercentFinilize 002")
                print(event.loaded)
                print(event.total)
            }
            
            let formData = FormData()
            
            let fileName = safeFileName(name: file.name, to: .communicationClosingImage, folio: nil)
            
            formData.append("eventid", self.uploadFinalizeId.uuidString)
            
            formData.append("to", ImagePickerTo.communicationClosingImage.rawValue)
            
            formData.append("fileName", fileName)

            formData.append("file", file, filename: fileName)

            formData.append("connid", custCatchChatConnID)
            
            formData.append("remoteCamera", false.description)
            
            xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
            
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("WSId", custCatchChatConnID)
            
            if let jsonData = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                url: custCatchUrl,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web, 
                applicationType: custCatchAccountType.sessionType
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
        
        func loadMediaFollowup(_ file: File) {
            
            let xhr = XMLHttpRequest()
            
            xhr.onLoadStart {
                self.uploadPercentFollowup = "0"
            }
            
            xhr.onError { jsValue in
                _ = JSObject.global.alert!("Server Conection Error")
                self.uploadPercentFollowup = ""
                //self.saveChatData(mid)
            }
            
            xhr.onLoadEnd {
                
                guard let responseText = xhr.responseText else {
                    _ = JSObject.global.alert!("Error de conexion 001")
                    self.uploadPercentFollowup = ""
                    return
                }
                
                print("⚠️ responseText")
                print(responseText)

                guard let data = responseText.data(using: .utf8) else {
                    _ = JSObject.global.alert!("Error de conexion 002")
                    self.uploadPercentFollowup = ""
                    return
                }
                
                do {
                    self.uploadPercentFollowup = ""
                    
                    let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        
                        return
                    }
                    
                    guard let process = resp.data else {
                        showError(.generalError, "No se pudo cargar datos")
                        return
                    }
                    
                    switch process {
                    case .processing(let process):
                        
                        self.uploadPercentFollowup = "processando..."
                        
                        print("⚠️  processando...")
                        print(process)

                    case .processed(let payload):
                        
                        self.imgAvatarFollowup.load("https://\(custCatchUrl)\(skylineUrlPatch)/contenido/thump_\(payload.avatar)")
                        
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
                
                self.uploadPercentFollowup = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString + "%"
                
                print("🟡 \(((Double(event.loaded) / Double(event.total)) * 100).toInt.toString)%")
                
            }
            
            xhr.onProgress { event in
                print("⭐️  002")
                print(event.loaded)
                print(event.total)
            }
            
            let formData = FormData()
            
            let fileName = safeFileName(name: file.name, to: .communicationFollowUpWelcomeDocument, folio: nil)
            
            formData.append("eventid", self.uploadFollowupId.uuidString)
            
            formData.append("to", ImagePickerTo.communicationFollowUpWelcomeDocument.rawValue)
            
            formData.append("fileName", fileName)

            formData.append("file", file, filename: fileName)

            formData.append("connid", custCatchChatConnID)
            
            formData.append("remoteCamera", false.description)
            
            xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
            
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("WSId", custCatchChatConnID)
            
            if let jsonData = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                url: custCatchUrl,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web, 
                applicationType: custCatchAccountType.sessionType
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
        


        
        func profileSection(_ title: String, _ content: Div) -> Div {
            Div{
                H3(title).color(.lightBlueText)
                content
                    .padding(all: 7.px)
                    .width(95.percent)
                Div().clear(.both)
            }
        }
        
        func textAreaRow(_ title: String, _ element: TextArea) -> Div {
            Div{
                Label(title).color(.lightGray)
                Div().clear(.both).height(3.px)
                element
                Div().clear(.both).height(7.px)
            }
        }
        
        func inputRow(_ title: String, _ element: InputText) -> Div {
            Div{
                Div{
                    Label(title)
                        .color(.lightGray)
                }
                .class(.oneHalf)
                Div{
                    element
                }
                .class(.oneHalf)
                Div().clear(.both)
            }
        }
        
        func inputRow(_ title: String, _ element: Select) -> Div {
            Div{
                Div{
                    Label(title)
                        .color(.lightGray)
                }
                .class(.oneHalf)
                Div{
                    element
                }
                .class(.oneHalf)
                Div().clear(.both)
            }
        }
        
        func renderOrderProfile() {
            renderProfile(self.orderCommunicationProfileDiv, selected: self.orderCommunicationProfile) { item in
                self.toggleOrderCommunicationProfile(item)
            }
        }
        
        func renderSaleProfile() {
            renderProfile(self.saleCommunicationProfileDiv, selected: self.saleCommunicationProfile) { item in
                self.toggleSaleCommunicationProfile(item)
            }
        }
        
        func renderDateProfile() {
            renderProfile(self.dateCommunicationProfileDiv, selected: self.dateCommunicationProfile) { item in
                self.toggleDateCommunicationProfile(item)
            }
        }
        
        func renderRentProfile() {
            renderProfile(self.rentCommunicationProfileDiv, selected: self.rentCommunicationProfile) { item in
                self.toggleRentCommunicationProfile(item)
            }
        }
        
        func renderProfile(
            _ container: Div,
            selected: [CustCommunicationEvents],
            onToggle: @escaping (CustCommunicationEvents) -> Void
        ) {
            container.innerHTML = ""
            
            CustCommunicationEvents.allCases.forEach { item in
                let isSelected = selected.contains(item)
                
                container.appendChild(
                    Div(item.description)
                        .display(.inlineBlock)
                        .cursor(.pointer)
                        .marginRight(7.px)
                        .marginBottom(7.px)
                        .paddingTop(5.px)
                        .paddingBottom(5.px)
                        .paddingLeft(10.px)
                        .paddingRight(10.px)
                        .borderRadius(all: 14.px)
                        .border(
                            width: .medium,
                            style: .solid,
                            color: isSelected ? .skyBlue : .darkGray
                        )
                        .color(isSelected ? .lightBlueText : .white)
                        .onClick {
                            onToggle(item)
                        }
                )
            }
        }
        
        func toggleOrderCommunicationProfile(_ item: CustCommunicationEvents) {
            orderCommunicationProfile = toggled(orderCommunicationProfile, item)
        }
        
        func toggleSaleCommunicationProfile(_ item: CustCommunicationEvents) {
            saleCommunicationProfile = toggled(saleCommunicationProfile, item)
        }
        
        func toggleDateCommunicationProfile(_ item: CustCommunicationEvents) {
            dateCommunicationProfile = toggled(dateCommunicationProfile, item)
        }
        
        func toggleRentCommunicationProfile(_ item: CustCommunicationEvents) {
            rentCommunicationProfile = toggled(rentCommunicationProfile, item)
        }
        
        func toggled(_ items: [CustCommunicationEvents], _ item: CustCommunicationEvents) -> [CustCommunicationEvents] {
            if items.contains(item) {
                return items.filter { $0 != item }
            }
            var newItems = items
            newItems.append(item)
            return newItems
        }
        
        func splitLines(_ value: String) -> [String] {
            value
                .components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        func optionalString(_ value: String) -> String? {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        
        func saveData() {
            let finalizedOrderFollowUp = optionalString(sendFinalizedOrderFollowUp).flatMap {
                AutoCommunicationsFollowUp(rawValue: $0)
            }
            
            let finalizedOrderMarketingFollowUp = optionalString(sendFinalizedOrderMarketingFollowUp).flatMap {
                AutoCommunicationsFollowUp(rawValue: $0)
            }
            
            var budgetCreditExpirationAlert: Int? = nil
            if let value = optionalString(sendOrderBudgetCreditExperationAlert) {
                guard let parsedValue = Int(value) else {
                    showError(.invalidField, "Establezca dias de alerta de expiracion")
                    sendOrderBudgetCreditExperationAlertField.select()
                    return
                }
                budgetCreditExpirationAlert = parsedValue
            }
            
            loadingView.show()
            
            API.custAPIV1.saveCommunicationProfile(
                orderCommunicationProfile: orderCommunicationProfile,
                saleCommunicationProfile: saleCommunicationProfile,
                dateCommunicationProfile: dateCommunicationProfile,
                rentCommunicationProfile: rentCommunicationProfile,
                welcomeMessage: CustCustomeMessage(
                    salute: splitLines(welcomeMessageSalute),
                    body: splitLines(welcomeMessageBody),
                    closingMessage: splitLines(welcomeMessageClosingMessage)
                ),
                closingMessage: CustCustomeMessage(
                    salute: splitLines(closingMessageSalute),
                    body: splitLines(closingMessageBody),
                    closingMessage: splitLines(closingMessageClosingMessage)
                ),
                closingImage: optionalString(closingImage),
                closingLink: optionalString(closingLink),
                sendFinalizedOrderFollowUp: finalizedOrderFollowUp,
                sendFinalizedOrderMarketingFollowUp: finalizedOrderMarketingFollowUp,
                sendOrderBudgetCreditExperationAlert: budgetCreditExpirationAlert,
                orderTermsAndConditions: optionalString(orderTermsAndConditions),
                saleTermsAndConditions: optionalString(saleTermsAndConditions),
                dateTermsAndConditions: optionalString(dateTermsAndConditions),
                rentalTermsAndConditions: optionalString(rentalTermsAndConditions),
                followUpWelcomeDocument: optionalString(followUpWelcomeDocument)
            ) { resp in
                
                loadingView.hide()
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Actualizado")
            }
        }
        
        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $orderCommunicationProfile.removeAllListeners()
            $saleCommunicationProfile.removeAllListeners()
            $dateCommunicationProfile.removeAllListeners()
            $rentCommunicationProfile.removeAllListeners()
            $welcomeMessageSalute.removeAllListeners()
            $welcomeMessageBody.removeAllListeners()
            $welcomeMessageClosingMessage.removeAllListeners()
            $closingMessageSalute.removeAllListeners()
            $closingMessageBody.removeAllListeners()
            $closingMessageClosingMessage.removeAllListeners()
            $closingImage.removeAllListeners()
            $closingLink.removeAllListeners()
            $sendFinalizedOrderFollowUp.removeAllListeners()
            $sendFinalizedOrderMarketingFollowUp.removeAllListeners()
            $sendOrderBudgetCreditExperationAlert.removeAllListeners()
            $orderTermsAndConditions.removeAllListeners()
            $saleTermsAndConditions.removeAllListeners()
            $dateTermsAndConditions.removeAllListeners()
            $rentalTermsAndConditions.removeAllListeners()
            $followUpWelcomeDocument.removeAllListeners()
        }
    }
}
