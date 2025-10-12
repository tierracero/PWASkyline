//
//  Tools+WebPage+MeetUsPage+DiplomaView.swift
//
//
//  Created by Victor Cantu on 1/24/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage.MeetUsPage {
    
    class ProfileView: Div {
        
        override class var name: String { "div" }
        
        @State var id: UUID?
        
        @State var name: String
        
        @State var smallDescription: String
        
        @State var descr: String
        
        @State var inPromo: Bool
        
        @State var avatar: String
        
        var files: [CustWebFilesQuick]
        
        var notes: [CustGeneralNotes]
        
        private var updateItem: ((
            _ id: UUID,
            _ name: String,
            _ description: String
        ) -> ())
        
        private var updateAvatar: ((
            _ id: UUID,
            _ avatar: String
        ) -> ())
        
        private var addItem: ((
            _ service: CustWebContent
        ) -> ())
        
        private var deleteItem: ((
            _ id: UUID
        ) -> ())
        
        required init(
            item: CustWebContent?,
            files: [CustWebFilesQuick],
            notes: [CustGeneralNotes],
            updateItem: @escaping ((
                _ id: UUID,
                _ name: String,
                _ description: String
            ) -> ()),
            updateAvatar: @escaping ((
                _ id: UUID,
                _ avatar: String
            ) -> ()),
            addItem: @escaping ((
                _ service: CustWebContent
            ) -> ()),
            deleteItem: @escaping ((
                _ id: UUID
            ) -> ())
        ) {
            self.id = item?.id
            self.name = item?.name ?? ""
            self.smallDescription = item?.smallDescription ?? ""
            self.descr = item?.description ?? ""
            self.inPromo = item?.inPromo ?? false
            self.avatar = item?.avatar ?? "/skyline/media/tierraceroRoundLogoWhite.svg"
            self.files = files
            self.notes = notes
            self.updateItem = updateItem
            self.updateAvatar = updateAvatar
            self.addItem = addItem
            self.deleteItem = deleteItem
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var nameField = InputText(self.$name)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Nombre del servivcio")
            .height(31.px)
        
        lazy var smallDescriptionField = TextArea(self.$smallDescription)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Descripcion Corta")
            .height(90.px)
        
        lazy var descrField = TextArea(self.$descr)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .placeholder("Small Description")
            .height(90.px)
        
        lazy var inPromoCheckbox = InputCheckbox().toggle(self.$inPromo)
        
        lazy var imageAvatar = Img()
            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            .padding(all: self.$selectedAvatar.map{ $0.isEmpty ? 7.px : 0.px})
            .height(self.$selectedAvatar.map{ $0.isEmpty ? 250.px : 264.px})
            .width(self.$selectedAvatar.map{ $0.isEmpty ? 250.px : 264.px})
        
        lazy var fileInput = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) //, "video/*", ".heic"
            .multiple(false)
            .display(.none)
        
        lazy var imageContainer = Div()
            .id(Id(stringLiteral: "imageContainer"))
        
        @State var editImage: Bool = true
        
        @State var selectedAvatar = ""
        
        var imageRefrence: [ UUID : ImageWebView ] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2(self.$id.map{ ($0 == nil) ? "Crear Perfil" : "Editar Perfil" })
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Div{
                    
                    Div{
                        
                        /// Media View Grid
                        Div{
                            
                            H2 {
                                Span("Fotos y videos")
                                
                            }.color(.lightBlueText)
                            
                            Div().class(.clear)
                            
                            Div {
                                self.imageAvatar
                            }
                            .custom("height", "calc(100% - 35px)")
                            .class(.roundDarkBlue)
                            .padding(all: 0.px)
                            .overflow(.hidden)
                            .align(.center)
                            
                        }
                        .class(.oneHalf)
                        .height(300.px)
                        
                        /// Media Upload Grid
                        Div {
                            
                            self.fileInput
                            
                            Div{
                                
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/mobileCamara.png")
                                        .class(.iconWhite)
                                        .marginLeft( 3.px)
                                        .cursor(.pointer)
                                        .height(28.px)
                                        .onClick {
                                            
                                            showError(.errorGeneral, "Habilitar esta funcion")
                                            /*
                                            loadingView(show: true)
                                            
                                            let view = ImageWebView(
                                                relation: CustWebFilesObjectType.general,
                                                relationId: self.id,
                                                type: nil,
                                                mediaId: nil,
                                                file: nil,
                                                image: nil,
                                                descr: "",
                                                width: 0,
                                                height: 0,
                                                selectedAvatar: self.$selectedAvatar
                                            ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                                                /*
                                                 self.startEditImage(
                                                     viewid,
                                                     mediaid,
                                                     path,
                                                     originalImage,
                                                     originalWidth,
                                                     originalHeight,
                                                     isAvatar
                                                 )
                                                 */
                                            } imAvatar: { name in
                                                self.selectedAvatar = name
                                            } removeMe: { viewId in
                                                self.imageRefrence.removeValue(forKey: viewId)
                                            }
                                            
                                            self.imageRefrence[view.viewId] = view
                                             */
                                            /*
                                            API.custAPIV1.requestMobileCamara(
                                                type: .useCamaraForProduct,
                                                connid: custCatchChatConnID,
                                                eventid: view.viewId,
                                                relatedid: self.id,
                                                relatedfolio: "",
                                                multipleTakes: !self.editImage
                                            ) { resp in
                                                
                                                loadingView(show: false)
                                                
                                                guard let resp else {
                                                    showError(.errorDeCommunicacion, .serverConextionError)
                                                    return
                                                }
                                                
                                                guard resp.status == .ok else {
                                                    showError(.errorGeneral, resp.msg)
                                                    return
                                                }
                                                
                                                showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                                                
                                            }
                                             */
                                        }
                                }
                                .float(.left)
                                
                                Div{
                                    Div{
                                        Img()
                                            .src("/skyline/media/upload2.png")
                                            .margin(all: 3.px)
                                            .height(18.px)
                                    }
                                    .float(.left)
                                    
                                    Span("Subir Foto/Video")
                                        .fontSize(18.px)
                                    
                                    Div().class(.clear)
                                    
                                }
                                .float(.right)
                                .class(.uibtn)
                                .onClick {
                                    self.renderInputFile()
                                }
                                
                                Div().class(.clear)
                                
                            }
                            .marginBottom( 7.px)
                            
                            self.imageContainer
                                .custom("height", "calc(100% - 41px)")
                                .class(.roundDarkBlue)
                                .padding(all: 4.px)
                                .overflow(.auto)
                            
                        }
                        .marginLeft(7.px)
                        .class(.oneHalf)
                        .height(287.px)
                        
                        Div().class(.clear).height(7.px)
                        
                        Div{
                        
                            Div{
                                Span("En Promo")
                                    .fontSize(22.px)
                                    .color(.white)
                            }
                            .class(.oneHalf)
                            
                            Div{
                                self.inPromoCheckbox
                            }
                            .class(.oneHalf)
                            
                            Div().class(.clear)
                            
                        }
                        
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div {
                            // MARK: NAME ES
                            Label("Nombre del Servicio")
                                .color(.gray)
                            
                            Div().class(.clear).height(3.px)
                            
                            self.nameField
                            
                            Div().class(.clear).height(7.px)
                        
                            // MARK: Small Description ES
                            Label("Descripción Corta")
                                .color(.gray)
                            
                            Div().class(.clear).height(3.px)
                            
                            self.smallDescriptionField
                            
                            Div().class(.clear).height(7.px)
                        
                            // MARK: Small Description EN
                            Label("Descripción Completa")
                                .color(.gray)
                            
                            Div().class(.clear).height(3.px)
                            
                            self.descrField
                            
                            Div().class(.clear).height(7.px)

                        }
                        .custom("height", "calc(100% - 50px)")
                        
                        Div{
                            
                            Div("Eliminar Servicio")
                                .hidden(self.$id.map{ $0 == nil })
                                .class(.uibtnLarge)
                                .float(.left)
                                .onClick {
                                    guard let id = self.id else {
                                        return
                                    }
                                    self.deleteItem(id)
                                }
                            
                            Div(self.$id.map{ ($0 ==  nil) ? "Crear Perfil" : "Guardar Cambios" })
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    self.saveServiceData()
                                }
                        }
                        .align(.right)
                        
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .custom("height", "calc(100% - 35px)")
            }
            .custom("height", "calc(100% - 110px)")
            .custom("left", "calc(50% - 575px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(1150.px)
            .color(.white)
            .top(45.px)
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
         
            if !avatar.isEmpty {
                imageAvatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
            }
            
            files.forEach { file in
                
                let imageView = ImageWebView(
                    relation: .general,
                    relationId: id,
                    type: file.type,
                    mediaId: file.id,
                    file: file.file,
                    image: file.avatar,
                    descr: file.description,
                    width: file.width,
                    height: file.height,
                    selectedAvatar: $avatar
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, fileName in
                    self.avatar = fileName
                    self.imageAvatar.load("https://\(custCatchUrl)/contenido/thump_\(fileName)")
                    self.updateAvatar(viewId, fileName)
                } removeMe: { viewId in
                    self.imageRefrence[viewId]?.remove()
                    self.imageRefrence.removeValue(forKey: viewId)
                }
                
                imageRefrence[imageView.viewId] = imageView
                
                imageContainer.appendChild(imageView)
                
                
            }
            
        }
        
        func renderInputFile() {
            
            fileInput = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) //, "video/*", ".heic"
                .multiple(false)
                .display(.none)
            
            fileInput.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .general,
                    relationId: self.id,
                    type: nil,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$avatar
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, fileName in
                    self.avatar = fileName
                    self.imageAvatar.load("https://\(custCatchUrl)/contenido/thump_\(fileName)")
                    self.updateAvatar(viewId, fileName)
                } removeMe: { viewId in
                    self.imageRefrence[viewId]?.remove()
                    self.imageRefrence.removeValue(forKey: viewId)
                }
                
                self.imageRefrence[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webProfile(self.id),
                    imageView: imageView,
                    imageContainer: self.imageContainer
                )
                
            }
            
            fileInput.click()
            
        }
        
        func saveServiceData() {
            
            if name.isEmpty {
                showError(.campoRequerido,.requierdValid("nombre"))
                return
            }
            
            if smallDescription.isEmpty {
                showError(.campoRequerido,.requierdValid("descripción corta"))
                return
            }
            
            if descr.isEmpty {
                showError(.campoRequerido,.requierdValid("descripción completa"))
                return
            }
            
            loadingView(show: true)
            
            if let id {
                
                API.themeV1.saveViewProfile(
                    id: id,
                    name: name,
                    smallDescription: smallDescription,
                    description: descr,
                    configLanguage: .Spanish,
                    inPromo: inPromo
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    self.updateItem(id, self.name, self.descr)
                    
                }
                
                return
            }
                
            var files: [ThemeEndpointV1.FileObject] = []
            
            imageRefrence.forEach { viewId, view in
                
                guard let fileName = view.file else {
                    return
                }
                
                files.append(.init(
                    fileName: fileName,
                    width: view.width,
                    height: view.height,
                    isAvatar: view.isAvatar
                ))
                
            }
            
            API.themeV1.addViewProfile(
                name: name,
                smallDescription: smallDescription,
                description: descr,
                configLanguage: .Spanish,
                inPromo: inPromo,
                files: files
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.id = payload.profile.id
                
                self.addItem(payload.profile)
                
            }
        }
        
        func startEditImage(
            _ viewid: UUID,
            _ mediaid: UUID?,
            _ path: String,
            _ originalImage: String,
            _ originalWidth: Int,
            _ originalHeight: Int,
            _ isAvatar: Bool
        ){
            
            let editor = ImageEditor(
                eventid: viewid,
                to: .webProfile,
                relid: id,
                subId: nil,
                isAvatar: isAvatar,
                mediaid: mediaid,
                path: path,
                originalImage: originalImage,
                originalWidth: originalWidth,
                originalHeight: originalHeight
            ) {
                if let view = self.imageRefrence[viewid] {
                    view.loadPercent = "Trabajando"
                    view.isLoaded = false
                    view.chekCropState(wait: 7)
                }
            }
            
            
            addToDom(editor)
        }
        
        
    }
}
