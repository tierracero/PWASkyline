//
//  MediaViewer.swift  ImageViewer
//  
//
//  Created by Victor Cantu on 9/6/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class MediaViewer: Div {
    
    override class var name: String { "div" }
    
    let relid: UUID?
    
    /// orderChat, orderFile, product
    let type: MediaDownloadType
    
    let url: String
    
    let files: [MediaFile]
    
    /// What media will be the initial loaded
    var currentView: Int
    
    private var deleteCallback: ((
    ) -> ())?
    
    @State var currentType: FileTypes = .image
    
    init(
        relid: UUID?,
        type: MediaDownloadType,
        url: String,
        files: [MediaFile],
        currentView: Int,
        deleteCallback: ((
        ) -> ())? = nil
    ) {
        self.relid = relid
        self.type = type
        self.url = url
        self.files = files
        self.currentView = currentView
        self.deleteCallback = deleteCallback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var file: MediaFile? = nil
    
    lazy var image = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .maxHeight(80.percent)
        .marginTop(5.percent)
        .height(80.percent)
    
    lazy var video = Video()
        .poster("skyline/media/tierraceroRoundLogoWhite.svg")
        .maxHeight(80.percent)
        .marginTop(5.percent)
        .height(80.percent)
        .controls(true)
    
    @DOM override var body: DOM.Content {
        
        Div {
            self.image
                .hidden(self.$currentType.map{ $0 != .image })
            
            self.video
                .hidden(self.$currentType.map{ $0 != .video })
        }
        .height(100.percent)
        .width(100.percent)
        .align(.center)
        
        Div{
            
            Img()
                .closeButton(.uiView3)
                .onClick{
                    self.remove()
                }
            
            H2("Ver media")
                .color(.lightBlueText)
        }
        .custom("width", "calc(100% - 48px)")
        .position(.absolute)
        .padding(all: 24.px)
        .top(0.px)
        .right(0.px)
        
        if type != .product {
            
            Div{
                Div{

                    Img()
                        .src("/skyline/media/rotateCounterClockwise.png")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            self.rotateCounterClockwise()
                        }
                    
                    Img()
                        .src("/skyline/media/rotateClockwise.png")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            self.rotateClockwise()
                        }
                    
                    Img()
                        .src("/skyline/media/download2.png")
                        .marginRight(12.px)
                        .height(18.px)
                    
                    Span("100%")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .onClick {
                            self.downloadMedia(size: .fullSize)
                        }
                    
                    Span("50%")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .onClick {
                            self.downloadMedia(size: .halfSize)
                        }
                    
                    Span("25%")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .onClick {
                            self.downloadMedia(size: .oneForthSize)
                        }

                    Img()
                        .src("/skyline/media/cross.png")
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            self.deleteMedia()
                        }

                }
                .padding(all: 7.px)
                .margin(all: 7.px)
                .align(.right)
                .fontSize(22.px)
                .color(.gray)
            }
            .backgroundColor(.transparentBlack)
            .position(.absolute)
            .width(100.percent)
            .height(50.px)
            .bottom(0.px)
            .left(0.px)
            
        }
        
    }
    
    override func buildUI() {
        self
        .backgroundColor(.init(.rgba(0, 0, 0, 0.9)))
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .zIndex(999999999)
        .left(0.px)
        .top(0.px)
        
        if url.isEmpty {
            self.remove()
            return
        }
        
        guard let file = files.first else {
            print("🔴 file")
            return
        }
        
        self.file = file
        
        print("🟢  file")
        
        currentType = file.type
        
        print("currentType \(currentType)")
        
        if file.type == .image {
            self.image.load("\(url)\(file.file)")
        }
        else if file.type == .video {
            
            print("🟡 \(url)\(file.avatar)")
            
            let _ = Img()
                .src("\(url)\(file.avatar)")
                .onLoad {
            
                    print("🟢 \(self.url)\(file.avatar)")
                    
                    self.video.poster("\(self.url)\(file.avatar)")
                    
                    self.video.src("\(self.url)\(file.file)")
                    
                }
            
        }
        
    }
    
    func downloadMedia(size: MediaDownloadSize){
        
        guard let file else {
            showError(.generalError, "No se ha selecionado archivo para descargar.")
            return
        }
        
        let url = baseSkylineAPIUrl(ie: "downloadMediaFile") +
        "&file=\(file.file)" +
        "&type=\(type.rawValue)" +
        "&size=\(size.rawValue)" +
        "&storeid=\(custCatchStore.uuidString)"
        
        _ = JSObject.global.goToURL!(url)
        
    }
    
    func rotateClockwise(){
        
        guard let file else {
            showError(.generalError, "No se ha selecionado archivo para descargar.")
            return
        }
        
        guard let relid else {
            showError(.generalError, "No se ha localizado el id relacionado.")
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.rotateClockwise(
            relid: relid,
            fileName: file.file,
            type: type
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
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            self.file = file
            
            if self.currentType == .image {
                self.image.load("\(payload.url)\(payload.fileName)")
            }
            else if self.currentType == .video {
                
                let avatar = payload.fileName.replace(from: ".mp4", to: ".jpg")
                
                let _ = Img()
                    .src("\(payload.url)\(avatar)")
                    .onLoad {
                        
                        self.video.poster("\(payload.url)\(avatar)")
                        
                        self.video.src("\(payload.url)\(payload.fileName)")
                    }
                
            }
            
        }
        
    }
    
    func rotateCounterClockwise(){
        
        guard let file else {
            showError(.generalError, "No se ha selecionado archivo para descargar.")
            return
        }
        
        guard let relid else {
            showError(.generalError, "No se ha localizado el id relacionado.")
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.rotateCounterClockwise(
            relid: relid,
            fileName: file.file,
            type: type
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
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            self.file = file
            
            if self.currentType == .image {
                self.image.load("\(payload.url)\(payload.fileName)")
            }
            else if self.currentType == .video {
                
                let avatar = payload.fileName.replace(from: ".mp4", to: ".jpg")
                
                let _ = Img()
                    .src("\(payload.url)\(avatar)")
                    .onLoad {
                        
                        self.video.poster("\(payload.url)\(avatar)")
                        
                        self.video.src("\(payload.url)\(payload.fileName)")
                    }
                
            }
            
        }
        
    }
    
    func deleteMedia(){
        
        switch type {
        case .orderChat:
            break
        case .orderFile:
            
            guard let orderId = relid else {
                return
            }
            
            guard let fileId = files.first?.fileId else {
                return
            }
            
            addToDom(ConfirmationView(
                type: .aproveDeny,
                title: "Eliminar Elemento",
                message: "¿Esta seguro que desea eliminar, esta accion no se puede revertir.?"
            ){ isConfirmed, comment in
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.deleteFile(
                        orderId: orderId,
                        fileId: fileId
                    ) { resp in
                    
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        if let deleteCallback = self.deleteCallback {
                            deleteCallback()
                        }
                        
                        self.remove()
                        
                    }
                }
                
            }.zIndex(999999999))
        case .product:
            break
        }
    }
    
}

extension MediaViewer {
    
    public struct MediaFile {
        
        public var fileId: UUID?
        
        public var file: String
        
        public var avatar: String
        
        public var type: FileTypes
        
        public init(
            fileId: UUID?,
            file: String,
            avatar: String,
            type: FileTypes
        ) {
            self.fileId = fileId
            self.file = file
            self.avatar = avatar
            self.type = type
        }
    }
}
