//
//  ImagePOCContainer.swift
//
//
//  Created by Victor Cantu on 9/25/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ImagePOCContainer: Div {
    
    override class var name: String { "div" }
    
    /// img, vdo, audio, gif, threeSixtyPan, threeSixtyCore
    var type: WebFilesTypes
    /// If media is registerd in database
    var mediaid: UUID?
    /// if product is alredy registerd in database
    @State var pocid: UUID?
    var file: String?
    @State var image: String?
    @State var imageLoader: String?
    @State var descr: String
    var width: Int
    var height: Int
    var selectedAvatar: State<String>
     
    private var callback: ((
        _ viewid: UUID,
        _ mediaid: UUID?,
        _ path: String,
        _ originalImage: String,
        _ originalWidth: Int,
        _ originalHeight: Int,
        _ isAvatar: Bool
    ) -> ())
    
   private var imAvatar: ((
       _ name: String
   ) -> ())
    
   private var removeMe: ((
       _ viewid: UUID
   ) -> ())
    
    init(
        type: WebFilesTypes,
        mediaid: UUID?,
        pocid: UUID?,
        file: String?,
        image: String?,
        width: Int,
        description: String,
        height: Int,
        selectedAvatar: State<String>,
        callback: @escaping ((
            _ viewid: UUID,
            _ mediaid: UUID?,
            _ path: String,
            _ originalImage: String,
            _ originalWidth: Int,
            _ originalHeight: Int,
            _ isAvatar: Bool
        ) -> ()),
        imAvatar: @escaping ((
            _ name: String
        ) -> ()),
        removeMe: @escaping ((
            _ viewid: UUID
        ) -> ())
    ) {
        self.type = type
        self.mediaid = mediaid
        self.pocid = pocid
        self.file = file
        self.image = nil
        self.imageLoader = image
        self.descr = description
        self.width = width
        self.height = height
        self.callback = callback
        self.selectedAvatar = selectedAvatar
        self.imAvatar = imAvatar
        self.removeMe = removeMe
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var loadPercent = ""
    
    @State var isAvatar = false
    
    var isLoaded = false
    
    var path = ""
    
    var viewid: UUID = .init()
    
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
                        .fontSize(18.px)
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
                    //.hidden(self.$image.map{ $0 == nil })
                    .paddingLeft(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .float(.left)
                    .onClick {
                        
                        if let mediaid = self.mediaid {
                            
                            guard let image = self.image else {
                                return
                            }
                            
                            guard let pocid = self.pocid else {
                                return
                            }
                            
                            if self.selectedAvatar.wrappedValue == image {
                                showError(.errorGeneral, "No puede eliminar un avatar establesido, cambie de avatar para poder eliminar la imagen actual.")
                                return
                            }
                            
                            loadingView(show: true)
                            
                            API.custPOCV1.removeMedia(
                                poc: pocid,
                                id: mediaid,
                                img: image,
                                autoRemoval: false,
                                viewid: self.viewid
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
                             
                                self.removeMe(self.viewid)
                                
                                self.remove()
                                
                            }
                        }
                        else{
                            
                            if let img = self.image {
                                
                                if self.selectedAvatar.wrappedValue == img {
                                    self.selectedAvatar.wrappedValue = ""
                                }
                                
                            }
                            
                            self.removeMe(self.viewid)
                            
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
                        
                        guard self.isLoaded else {
                            return
                        }
                        
                        self.setAsAvatar(image: nil)
                        
                    }
                    
                Img()
                    .src("/skyline/media/pencil.png")
                    .hidden(self.$image.map{ $0 == nil })
                    .paddingRight(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .onClick{
                        
                        guard self.isLoaded else {
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
                    .backgroundColor(.grayBlack)
                    .custom("border", "none")
                    .borderRadius(all: 12.px)
                    .class(.textFiledLight)
                    .color(.lightGray)
                    .width(99.percent)
                    .height(67.px)
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
                        relid: self.pocid,
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
                    
                    //addToDom(ImageViewer(type: .product, url: "\(self.path)\(image)"))
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
        
        $pocid.listen {
            
           if $0 == nil {
               self.path = "https://\(custCatchUrl)/iCatch/"
           }
           else{
               if let pDir = customerServiceProfile?.account.pDir {
                   self.path = "https://intratc.co/cdn/\(pDir)/"
               }
           }
            
        }
        
        if pocid == nil {
            self.path = "https://\(custCatchUrl)/iCatch/"
        }
        else{
           if let pDir = customerServiceProfile?.account.pDir {
               self.path = "https://intratc.co/cdn/\(pDir)/"
           }
        }
        
        selectedAvatar.listen {
            self.isAvatar = (self.selectedAvatar.wrappedValue == self.image)
        }
        
        if let image = self.imageLoader {
            loadImage(image)
        }
        
    }
    
    override func didAddToDOM(){
        
    }
    
    func loadImage(_ image: String, edit: Bool = false) {
     
        let item = Img()
            .src("\(self.path)thump_\(image)")
            .onLoad {
                
                self.image = image
                
                self.imageDiv
                    .custom("background-image", "url('\(self.path)thump_\(image)')")
                
                self.isLoaded = true
                
            }
            .onError { event in
                
                guard let mediaid = self.mediaid else {
                    return
                }
                
                guard let pocid = self.pocid else {
                    return
                }
                
                API.custPOCV1.removeMedia(
                    poc: pocid,
                    id: mediaid,
                    img: image,
                    autoRemoval: true,
                    viewid: self.viewid
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
                        self.removeMe(self.viewid)
                        self.remove()
                    case .recovery:
                        showSuccess(.operacionExitosa, "Imagen \(image) en recuperacion.")
                    }
                    
                }
            }
        
        if edit {
            self.editImage(image)
        }
        
    }
    
    func editImage(_ img: String? = nil){
        
        guard isLoaded else {
            return
        }
        
        if let img = img {
            self.callback(
                viewid,
                mediaid,
                path,
                img,
                width,
                height,
                selectedAvatar.wrappedValue == image
            )
        }
        else{
            if let image = image {
                self.callback(
                    viewid,
                    mediaid,
                    path,
                    image,
                    width,
                    height,
                    selectedAvatar.wrappedValue == image
                )
            }
        }
    }
    
    func setAsAvatar(image providedImage: String?){
        
        if let img = providedImage {
            
            if self.selectedAvatar.wrappedValue == img {
                return
            }
            
            guard let mediaid else {
                return
            }
            
            guard let pocid else {
                return
            }
            
            API.custPOCV1.setAvatar(
                poc: pocid,
                id: mediaid,
                img: img
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "Error de servidor al establecer avatar")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, "Al Establecer Avatar" + resp.msg)
                    return
                }
                
                self.isAvatar = true
                
                self.imAvatar(img)
                
            }
            
        }
        else if let img = self.image {
            
            if self.selectedAvatar.wrappedValue == img {
        
                return
            }
            
            guard let mediaid else {
                return
            }
            
            guard let pocid else {
                return
            }
            
            API.custPOCV1.setAvatar(
                poc: pocid,
                id: mediaid,
                img: img
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "Erro de servidor al establecer avatar")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, "Al Establecer Avatar" + resp.msg)
                    return
                }
                
                self.isAvatar = true
                
                self.imAvatar(img)
                
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
                eventid: self.viewid
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
                    self.removeMe(self.viewid)
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
                        self.viewid,
                        self.mediaid,
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
                eventid: self.viewid
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
                    return
                }
                
                switch payload.status {
                case .active, .processed:
                    if wait > 20 {
                        showError(.errorGeneral, "Fallo cargo del archivo.")
                        return
                    }
                    self.chekCropState(wait: wait + 1)
                case .error:
                    showError(.errorGeneral, "Fallo cargo del archivo.")
                    self.removeMe(self.viewid)
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
