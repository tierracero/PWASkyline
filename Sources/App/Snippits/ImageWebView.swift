//
//  ImageWebView.swift
//
//
//  Created by Victor Cantu on 1/25/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ImageWebView: Div {
    
    override class var name: String { "div" }
    
    /// logoIndexMain, logoIndexWhite, logoIndexWhiteTrans, logoIndexBlack, logoIndexBlackTrans, logoIndexIcon, ...
    let relation: CustWebFilesObjectType
    
    @State var relationId: UUID?
    
    /// img, vdo, audio, gif, threeSixtyPan, threeSixtyCore
    var type: WebFilesTypes?
    
    /// If media is registerd in database
    var mediaId: UUID?
    
    var file: String?
    
    @State var image: String?
    
    @State var descr: String
    
    var width: Int
    
    var height: Int
    
    var selectedAvatar: State<String>
     
    private var callback: ((
        _ viewId: UUID,
        _ mediaId: UUID?,
        _ path: String,
        _ originalImage: String,
        _ originalWidth: Int,
        _ originalHeight: Int,
        _ isAvatar: Bool
    ) -> ())
    
    private var imAvatar: ((
        _ viewId: UUID,
        _ name: String
    ) -> ())
    
    private var removeMe: ((
        _ viewId: UUID
    ) -> ())
    
    init(
        relation: CustWebFilesObjectType,
        relationId: UUID?,
        type: WebFilesTypes?,
        mediaId: UUID?,
        file: String?,
        image: String?,
        descr: String,
        width: Int,
        height: Int,
        selectedAvatar: State<String>,
        callback: @escaping (
            _ viewId: UUID,
            _ mediaId: UUID?,
            _ path: String,
            _ originalImage: String,
            _ originalWidth: Int,
            _ originalHeight: Int,
            _ isAvatar: Bool
        ) -> Void,
        imAvatar: @escaping (
            _ viewId: UUID,
            _ name: String
        ) -> Void,
        removeMe: @escaping (
            _ viewId: UUID
        ) -> Void
    ) {
        self.relation = relation
        self.relationId = relationId
        self.type = type
        self.mediaId = mediaId
        self.file = file
        self.image = image
        self.descr = descr
        self.width = width
        self.height = height
        self.selectedAvatar = selectedAvatar
        self.callback = callback
        self.imAvatar = imAvatar
        self.removeMe = removeMe
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    @State var loadPercent = ""
    
    @State var isAvatar = false
    
    var isLoaded = false
    
    var path = ""
    
    var viewId: UUID = .init()
    
    lazy var imageDiv = Div {
        Img()
            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            .hidden(self.$image.map{ $0 != nil })
            .height(100.percent)
            .width(100.percent)
            .opacity(0.24)
        
        Div{
            Table{
                Tr{
                    Td(self.$loadPercent)
                        .verticalAlign(.middle)
                        .fontSize(36.px)
                        .align(.center)
                        .color(.white)
                }
            }
            .width(100.percent)
            .height(100.percent)
        }
        .hidden(self.$loadPercent.map{ $0.isEmpty})
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .top(0.px)
        
    }
    
    lazy var imageAvatar = Img()
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                Img()
                    .src("/skyline/media/cross.png")
                    .paddingLeft(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .float(.left)
                    .onClick {
                        
                        if let mediaId = self.mediaId {
                            
                            guard let image = self.image else {
                                return
                            }
                            
                            if self.selectedAvatar.wrappedValue == image {
                                showError(.errorGeneral, "No puede eliminar un avatar establesido, cambie de avatar para poder eliminar la imagen actual.")
                                return
                            }
                            
                            loadingView(show: true)
                            
                            API.themeV1.deleteWebContentImage(
                                id: mediaId
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
                             
                                self.removeMe(self.viewId)
                                
                                self.remove()
                                
                            }
                        }
                        else{
                            
                            if let img = self.image {
                                
                                if self.selectedAvatar.wrappedValue == img {
                                    self.selectedAvatar.wrappedValue = ""
                                }
                                
                            }
                            
                            self.removeMe(self.viewId)
                            
                            self.remove()
                        }
                    
                    }
                
                self.imageAvatar
                    .src(self.$isAvatar.map{ $0 ? "/skyline/media/star_yellow.png" : "/skyline/media/star_gray.png"})
                    .hidden(self.$image.map{ $0 == nil })
                    .paddingRight(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .onClick{
                        
                        guard let image = self.image, self.isLoaded else {
                            return
                        }
                        
                        guard let mediaId = self.mediaId else {
                            self.isAvatar = true
                            self.imAvatar( self.viewId, image)
                            return
                        }
                        
                        var relationType: API.themeV1.ImageConfigurationSaveType? = nil
                        
                        if self.relation == .general {
                            guard let relationId = self.relationId else {
                                self.isAvatar = true
                                self.imAvatar( self.viewId, image)
                                return
                            }
                            relationType = .custWebContent(relationId)
                        }
                        else {
                            relationType = .element(self.relation)
                        }
                        
                        guard let relationType else {
                            showError(.unexpectedResult, "No Relation Type Set")
                            return
                        }
                        
                        API.themeV1.imageConfigurationSave(
                            mediaId: mediaId,
                            relationType: relationType,
                            configLanguage: .Spanish,
                            fileName: image
                        ) { resp in
                            
                            guard let resp else {
                                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            self.isAvatar = true
                            self.imAvatar( self.viewId, image)
                            
                        }
                        
                    }
                    
                Img()
                    .src("/skyline/media/pencil.png")
                    .hidden(self.$image.map{ $0 == nil })
                    .paddingRight(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .onClick {
                        
                        if !self.isLoaded {
                            return
                        }
                        
                        self.editImage()
                        
                    }
            }
            .marginBottom(2.px)
            .align(.right)
            .height(21.px)
            
            Div{
                TextArea(self.$descr)
                    .placeholder("Ingrese descricion de la imagen")
                    .custom("border", "none")
                    .borderRadius(all: 12.px)
                    .class(.textFiledLight)
                    .backgroundColor(.grayBlack)
                    .width(99.percent)
                    .height(67.px)
                    .color(.lightGray)
            }

        }
        .custom("width", "calc(100% - 107px)")
        .padding(all: 2.px)
        .margin(all: 2.px)
        .float(.right)
        
        self.imageDiv
            .backgroundSize(all: .contain)
            .backgroundPosition( .center)
            .backgroundRepeat( .noRepeat)
            .borderRadius(all: 24.px)
            .position(.relative)
            .overflow(.hidden)
            .margin(all: 2.px)
            .cursor(.pointer)
            .height(96.px)
            .width(96.px)
            .onClick{
                
                var fileType: FileTypes = .image
                
                if self.type == .vdo {
                    fileType = .video
                }
                
                if let avatar = self.image, let file = self.file {
                    
                    addToDom(MediaViewer(
                        relid: self.relationId,
                        type: .product,
                        url: self.path,
                        files: [.init(
                            fileId: nil,
                            file: file,
                            avatar: avatar,
                            type: fileType
                        )],
                        currentView: 0
                    ))
                    
                }
            }
        
    }
    
    override func buildUI() {
        boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
        backgroundColor(.grayBlackDark)
        borderRadius(all: 12.px)
        marginBottom(7.px)
        overflow(.hidden)
        cursor(.pointer)
        height(100.px)
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            switch event {
            case .requestMobileCamaraComplete:
                break
            case .requestMobileCamaraFail:
                break
            case .requestMobileCamaraInitiate:
                break
            case .requestMobileCamaraProgress:
                break
            case .asyncFileUpload:
                
                guard let payload = self.ws.asyncFileUpload($0) else {
                    return
                }
                
                guard self.viewId == payload.eventid else {
                    return
                }
                
                self.isLoaded = true
                
                self.loadPercent = ""
                
                self.mediaId = payload.mediaid
                
                self.width = payload.width
                
                self.height = payload.height
                
                self.file = payload.fileName
                
                self.image = payload.fileName
                
                self.loadImage(payload.avatar)
                
            case .asyncFileUpdate:
                
                guard let payload = self.ws.asyncFileUpdate($0) else {
                    return
                }
                
                guard self.viewId == payload.eventId else {
                    return
                }
                
                self.loadPercent = payload.message
                
            case .asyncCropImage:
                
                guard let payload = self.ws.asyncCropImage($0) else {
                    return
                }
                
                guard self.viewId == payload.eventid else {
                    return
                }
                
                self.isLoaded = true
                
                self.loadPercent = ""
                
                self.file = payload.fileName
                
                self.image = payload.fileName
                
                self.loadImage(payload.fileName)
                
                if self.isAvatar {
                    self.selectedAvatar.wrappedValue = payload.fileName
                    self.isAvatar = true
                }
            default:
                break
            }
        }
        
        $relationId.listen {
            
            if self.relation == .general {
                self.path = "https://\(custCatchUrl)/contenido/"
            }
            else {
                if $0 == nil {
                    self.path = "https://\(custCatchUrl)/iCatch/"
                }
                else{
                    if let pDir = customerServiceProfile?.account.pDir {
                        self.path = "https://\(custCatchUrl)/contenido/"
                    }
                }
            }
            
        }
        
        if relation == .general {
            
            if relationId == nil {
                self.path = "https://\(custCatchUrl)/iCatch/"
            }
            else{
                self.path = "https://\(custCatchUrl)/contenido/"
            }
        }
        else {
            self.path = "https://\(custCatchUrl)/contenido/"
        }
        
        selectedAvatar.listen {
            self.isAvatar = (self.selectedAvatar.wrappedValue == self.image)
        }
        
        isAvatar = (self.selectedAvatar.wrappedValue == self.image)
        
        if let image {
            loadImage(image)
        }
        
    }
    
    override func didAddToDOM(){
        
    }
    
    func loadImage(_ image: String) {
        
        let _ = Img()
            .src("\(self.path)thump_\(image)")
            .onLoad {
                
                self.image = image
                
                self.imageDiv
                    .custom("background-image", "url('\(self.path)thump_\(image)')")
                
                self.isLoaded = true
                
            }
            .onError { event in
                
                guard let mediaId = self.mediaId else {
                    return
                }
                
                guard let relationId = self.relationId else {
                    return
                }
                
                API.custPOCV1.removeMedia(
                    poc: relationId,
                    id: mediaId,
                    img: image,
                    autoRemoval: true,
                    viewid: self.viewId
                ) { resp in
                    
                    guard let resp else {
                        return
                    }
                    
                    guard resp.status == .ok else {
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    switch payload {
                    case .deleted:
                        self.removeMe(self.viewId)
                        self.remove()
                    case .recovery:
                        showSuccess(.operacionExitosa, "Imagen \(image) en recuperacion.")
                    }
                    
                }
            }
    }
    
    func editImage(_ img: String? = nil){
        
        if let img {
            self.callback(
                viewId,
                mediaId,
                path,
                img,
                width,
                height,
                selectedAvatar.wrappedValue == image
            )
        }
        else{
            if let image {
                self.callback(
                    viewId,
                    mediaId,
                    path,
                    image,
                    width,
                    height,
                    selectedAvatar.wrappedValue == image
                )
            }
        }
    }
    
    func chekUploadState(wait: Double){
        
        Dispatch.asyncAfter(wait) {
            
            if self.isLoaded {
                return
            }
            
            API.custAPIV1.asyncCheckUploadStatus(
                type: .upload,
                eventid: self.viewId
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
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
                
                switch payload.status {
                case .active, .processed:
                    if wait > 20 {
                        showError(.errorGeneral, "Fallo cargo del archivo.")
                        return
                    }
                    self.chekUploadState(wait: wait + 1)
                case .error:
                    showError(.errorGeneral, "Fallo cargo del archivo.")
                    self.removeMe(self.viewId)
                    self.remove()
                case .done:
                    
                    guard let image = payload.image else {
                        showError(.errorGeneral, "No se encontro imagen, refsque para cargarla.")
                        return
                    }
                    
                    self.isLoaded = true
                        
                    self.loadPercent = ""
                    
                    self.loadImage( image )
                    
                    if self.isAvatar {
                        self.selectedAvatar.wrappedValue = image
                    }
                    
                    self.callback(
                        self.viewId,
                        self.mediaId,
                        self.path,
                        image,
                        payload.width,
                        payload.height,
                        self.selectedAvatar.wrappedValue == image
                    )
                }
            }
        }
    }
    
    func chekCropState(wait: Double){
        
        Dispatch.asyncAfter(wait) {
            
            if self.isLoaded {
                return
            }
            
            API.custAPIV1.asyncCheckUploadStatus(
                type: .crop,
                eventid: self.viewId
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
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
                
                switch payload.status {
                case .active, .processed:
                    if wait > 20 {
                        showError(.errorGeneral, "Fallo cargo del archivo.")
                        return
                    }
                    self.chekUploadState(wait: wait + 1)
                case .error:
                    showError(.errorGeneral, "Fallo cargo del archivo.")
                    self.removeMe(self.viewId)
                    self.remove()
                case .done:
                    
                    guard let image = payload.image else {
                        showError(.errorGeneral, "No se encontro imagen, refsque para cargarla.")
                        return
                    }
                    
                    self.isLoaded = true
                    
                    self.loadPercent = ""
                    
                    self.loadImage( image )
                    
                }
            }
        }
    }
}
