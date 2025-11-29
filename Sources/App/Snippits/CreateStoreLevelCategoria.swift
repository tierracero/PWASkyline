//
//  CreateStoreLevelCategoria.swift
//  
//
//  Created by Victor Cantu on 9/17/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

class CreateStoreLevelCategoria: Div {
    
    override class var name: String { "div" }
    
    let cat:  CustStoreCatsAPI?
    
    var depid: UUID
    
    var depname: String
    
    private var callback: ((
        _ id: UUID,
        _ name: String
    ) -> ())
    
    private var deleted: ((
    ) -> ())
    
    private var changeAvatar: ((
        _ id: UUID,
        _ url: String
    ) -> ())
    
    init(
        cat:  CustStoreCatsAPI? = nil,
        depid: UUID,
        depname: String,
        callback: @escaping ((
            _ id: UUID,
            _ name: String
        ) -> ()),
        deleted: @escaping ((
        ) -> ()),
        changeAvatar: @escaping ((
            _ id: UUID,
            _ url: String
        ) -> ())
    ) {
        
        self.cat = cat
        self.depid = depid
        self.depname = depname
        self.callback = callback
        self.deleted = deleted
        self.changeAvatar = changeAvatar
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    
    var titleText = "Crear Categoria"
    
    var buttonText = "Crear Categoria"
    
    @State var uploadPercent: String? = nil
    
    @State var name = ""
    
    @State var descr = ""
    
    lazy var nameField = InputText(self.$name)
        .placeholder("Nombre de la Categoria")
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDarkLarge)
    
    lazy var descriptionField = TextArea(self.$descr)
        .placeholder("Lista, marcas, o pequeña description")
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDarkLarge)
        .borderRadius(12.px)
        .padding(all: 7.px)
        .height(95.px)
        .onEnter { input in
            self.createLevel()
        }
    
    lazy var fileLoader: InputFile = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // , ".heic"
        .hidden(true)
    
    lazy var imgAvatar = Img()
        .src("/skyline/media/tierraceroRoundLogoWhite.svg")
        .custom("aspect-ratio", "1/1")
        .width(90.percent)
        .cursor(.pointer)
        .onClick {
            self.fileLoader.click()
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.titleText)
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).marginBottom(3.px)
            
            H3("Crear categoria en \( self.depname.uppercased() )")
                .class(.oneLineText)
                .color(.darkOrange)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                Label("Nombre de Categoria")
                    
                Div().class(.clear).marginBottom(7.px)
                
                self.nameField
                    .onEnter {
                        self.createLevel()
                    }
                
                Div().class(.clear).marginBottom(12.px)
                
                Label("Descripcion Corta")
                    
                Div().class(.clear).marginBottom(7.px)
                
                self.descriptionField
            }
            .width(70.percent)
            .float(.left)
            
            Div{
                
                self.fileLoader
                
                Label("Avatar")
                
                Div().class(.clear).marginBottom(7.px)
                
                Div{
                    
                    self.imgAvatar
                    
                    Div{
                        Table{
                            Tr{
                                Td(self.$uploadPercent.map{ ($0 == nil) ? "" : $0! })
                                    .verticalAlign(.middle)
                                    .fontSize(48.px)
                                    .align(.center)
                                    .color(.white)
                            }
                        }
                        .backgroundColor(.init(r: 0, g: 0, b: 0, a: 0.5))
                        .height(100.percent)
                        .width(100.percent)
                    }
                    .hidden(self.$uploadPercent.map{ $0 == nil })
                    .borderRadius(all: 24.px)
                    .position(.absolute)
                    .height(100.percent)
                    .width(100.percent)
                    .overflow(.hidden)
                    .left(0.px)
                    .top(0.px)
                }
                .position(.relative)
                .height(100.percent)
                .width(100.percent)
                .align(.center)
                
            }
            .width(30.percent)
            .float(.left)
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Div(self.buttonText)
                    .class(.uibtnLarge)
                    .onClick{
                        self.createLevel()
                    }
            }
            .align(.center)
            
            Div().class(.clear).marginBottom(7.px)
            
            if let _ = self.cat {
                
                Div{
                    H2("Eliminar")
                        .letterSpacing(2.px)
                        .cursor(.pointer)
                        .color(.red)
                        .onClick {
                            self.deleteLevel()
                        }
                }
                .align(.center)
                
                Div().class(.clear).marginBottom(7.px)
            }
            
        }
        .backgroundColor(.grayBlack)
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 200px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(700.px)
        .color(.white)
        
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        if let cat {
            
            titleText = "Editar Categoria"
            
            buttonText = "Guardar Cambios"
            
            name = cat.name
            
            descr = cat.smallDescription
            
            if !cat.coverLandscape.isEmpty {
                self.imgAvatar.load("https://\(custCatchUrl)/contenido/thump_\(cat.coverLandscape)")
            }
            
        }
        
        fileLoader.$files.listen {
            $0.forEach { file in
                self.loadMedia(file)
            }
        }
        
    }
    
    override func didAddToDOM() {
        self.nameField.select()
        
        nameField.select()
    }
    
    func createLevel() {
        
        name = name.purgeSpaces.purgeHtml.capitalized
        
        descr = descr.purgeSpaces.purgeHtml.capitalizeFirstLetter
        
        if name.isEmpty {
            showError(.campoRequerido, .requierdValid("Nombre"))
            nameField.select()
            return
        }
        
        loadingView(show: true)
        
        if let id = self.cat?.id {
            API.custAPIV1.saveStoreLevel(
                id: id,
                type: .cat,
                name: name,
                smallDescription: descr,
                description: "",
                icon: "",
                isPublic: true
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Cambios Guardados")
                
                self.callback(id, self.name)
                
                self.remove()
            }
        }
        else{
            
            API.custAPIV1.createStoreLevel(
                id: self.depid,
                type: .cat,
                name: name,
                smallDescription: descr,
                description: "",
                icon: "",
                coverLandscape: "",
                coverPortrait: "",
                isPublic: true
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let id = resp.id else {
                    showError(.unexpectedResult, "No se obtuvo id de la nueva categoria, refresque la webapp.")
                    return
                }
                
                self.callback(id, self.name)
                
                self.remove()
                
            }
            
        }
    }
    
    func deleteLevel(){
        
        guard let cat else {
            return
        }
        
        addToDom(ConfirmView(
            type: .yesNo,
            title: "Confirmar Eliminacion",
            message: "¿Realmente desea eliminar categoria \(cat.name)?"){ isConfirmed, message in
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custAPIV1.deleteStoreLevel(
                        id: cat.id,
                        type: .cat
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        self.deleted()
                        
                        self.remove()
                    }
                    
                }
            }
        )
    }
    
    func loadMedia(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        xhr.onLoadStart {
            self.uploadPercent = "0"
        }
        
        xhr.onError { jsValue in
            _ = JSObject.global.alert!("Server Conection Error")
            self.uploadPercent = nil
            //self.saveChatData(mid)
        }
        
        xhr.onLoadEnd {
            
            guard let responseText = xhr.responseText else {
                _ = JSObject.global.alert!("Error de conexion 001")
                self.uploadPercent = nil
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                _ = JSObject.global.alert!("Error de conexion 002")
                self.uploadPercent = nil
                return
            }
            
            do {
                self.uploadPercent = nil
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<CustComponents.UploadMediaResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    print("🔴 UPLAD ERROR")
                    print(resp)
                    _ = JSObject.global.alert!( resp.msg)
                    return
                }
                
                guard let file = resp.data else {
                    _ = JSObject.global.alert!( "No se pudo cargar datos")
                    return
                }
                
                self.imgAvatar.load("\(file.url)thump_\(file.avatar)")
                
                if let id = self.cat?.id {
                    self.changeAvatar(id, "\(file.url)thump_\(file.avatar)")
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
            
            self.uploadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString + "%"
            
            print("🟡 \(((Double(event.loaded) / Double(event.total)) * 100).toInt.toString)%")
            
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event.loaded)
            print(event.total)
        }
        
        let formData = FormData()
        
        let fileName = safeFileName(name: file.name, to: .categoryAvatar, folio: nil)
        
        formData.append("event", UUID().uuidString)
        
        formData.append("to", ImagePickerTo.categoryAvatar.rawValue)
        
        if let id = cat?.id {
            formData.append("id", id.uuidString)
        }
        
        formData.append("fileName", fileName)

        formData.append("file", file, filename: fileName)
        
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadMedia")
        
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

