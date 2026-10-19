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
    
    /// orderChat, orderFile, product, content
    let type: MediaDownloadType
    
    let url: String
    
    let files: [MediaFile]

    private let allowsMediaActions: Bool
    
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
        ) -> ())? = nil,
        allowsMediaActions: Bool = true
    ) {
        self.relid = relid
        self.type = type
        self.url = url
        self.files = files
        self.currentView = currentView
        self.deleteCallback = deleteCallback
        self.allowsMediaActions = allowsMediaActions
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var file: MediaFile? = nil
    
    lazy var image = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .maxHeight(100.percent)
        .maxWidth(100.percent)
        .custom("object-fit", "contain")
    
    lazy var video = Video()
        .poster("skyline/media/tierraceroRoundLogoWhite.svg")
        .maxHeight(100.percent)
        .maxWidth(100.percent)
        .controls(true)

    private var showsMediaActions: Bool { allowsMediaActions && type != .product }

    private var thumbnailButtons: [Button] = []

    private lazy var thumbnails = Div()
        .custom("display", "flex")
        .custom("align-items", "center")
        .custom("gap", "8px")
        .custom("padding", "8px 12px")
        .custom("box-sizing", "border-box")
        .custom("background", "rgba(0, 0, 0, 0.65)")
        .overflow(.auto)
        .position(.absolute)
        .height(86.px)
        .width(100.percent)
        .bottom(showsMediaActions ? 50.px : 0.px)
        .left(0.px)
    
    @DOM override var body: DOM.Content {
        
        Div {
            self.image
                .hidden(self.$currentType.map{ $0 != .image })
            
            self.video
                .hidden(self.$currentType.map{ $0 != .video })
        }
        .custom("display", "flex")
        .custom("align-items", "center")
        .custom("justify-content", "center")
        .custom("height", "calc(100% - \(70 + (files.count > 1 ? 86 : 0) + (showsMediaActions ? 50 : 0))px)")
        .position(.absolute)
        .top(70.px)
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
        
        if files.count > 1 {
            self.thumbnails

            Button("‹")
                .attribute("aria-label", "Imagen anterior")
                .position(.absolute)
                .top(50.percent)
                .left(12.px)
                .fontSize(32.px)
                .cursor(.pointer)
                .onClick { self.selectFile((self.currentView + self.files.count - 1) % self.files.count) }

            Button("›")
                .attribute("aria-label", "Imagen siguiente")
                .position(.absolute)
                .top(50.percent)
                .right(12.px)
                .fontSize(32.px)
                .cursor(.pointer)
                .onClick { self.selectFile((self.currentView + 1) % self.files.count) }
        }

        if showsMediaActions {
            
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
        
        guard !files.isEmpty else {
            self.remove()
            return
        }
        renderThumbnails()
        selectFile(files.indices.contains(currentView) ? currentView : 0)
    }

    private func mediaSource(_ name: String, file: MediaFile) -> String {
        if name.hasPrefix("https://") || name.hasPrefix("http://") || name.hasPrefix("/") {
            return name
        }
        return (file.url ?? url) + name
    }

    private func thumbnailName(_ file: MediaFile) -> String {
        let name = file.avatar.isEmpty ? file.file : file.avatar
        // Preserve URL separators and suffixes instead of normalizing a filesystem path.
        let pathEnd = name.firstIndex { $0 == "?" || $0 == "#" } ?? name.endIndex
        let path = name[..<pathEnd]
        let filenameStart = path.lastIndex(of: "/").map { name.index(after: $0) } ?? name.startIndex
        guard !name[filenameStart..<pathEnd].hasPrefix("thump_") else { return name }
        return String(name[..<filenameStart]) + "thump_" + String(name[filenameStart...])
    }

    private func renderThumbnails() {
        thumbnails.innerHTML = ""
        thumbnailButtons.removeAll()
        for (index, file) in files.enumerated() {
            let button = Button {
                Img()
                    .src(self.mediaSource(self.thumbnailName(file), file: file))
                    .attribute("alt", "Archivo \(index + 1)")
                    .width(64.px)
                    .height(64.px)
                    .custom("object-fit", "cover")
            }
                .attribute("aria-label", "Ver archivo \(index + 1)")
                .attribute("aria-pressed", "false")
                .custom("border", "2px solid #252c3b")
                .custom("padding", "0")
                .custom("flex", "0 0 auto")
                .custom("margin-left", index == 0 ? "auto" : "0")
                .custom("margin-right", index == files.count - 1 ? "auto" : "0")
                .custom("border-radius", "6px")
                .overflow(.hidden)
                .cursor(.pointer)
                .onClick { self.selectFile(index) }
            thumbnailButtons.append(button)
            thumbnails.appendChild(button)
        }
    }

    private func selectFile(_ index: Int) {
        guard files.indices.contains(index) else { return }
        // Clearing the video source also stops playback before changing items.
        video.src("")
        let selected = files[index]
        currentView = index
        for (buttonIndex, button) in thumbnailButtons.enumerated() {
            button.attribute("aria-pressed", buttonIndex == index ? "true" : "false")
            button.custom("border", buttonIndex == index ? "2px solid #24b9e8" : "2px solid #252c3b")
        }
        file = selected
        currentType = selected.type
        if selected.type == .image {
            // Assign directly so a slower previous image cannot replace a
            // newer selection through Img.load's temporary-image callback.
            image.src(mediaSource(selected.file, file: selected))
        } else if selected.type == .video {
            video.poster(mediaSource(selected.avatar, file: selected))
            video.src(mediaSource(selected.file, file: selected))
        }
    }
    
    func downloadMedia(size: MediaDownloadSize){
        guard showsMediaActions else { return }
        
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
        guard showsMediaActions else { return }
        
        guard let file else {
            showError(.generalError, "No se ha selecionado archivo para descargar.")
            return
        }
        
        guard let relid else {
            showError(.generalError, "No se ha localizado el id relacionado.")
            return
        }

        let selectedIndex = currentView
        
        loadingView.show()
        
        API.custAPIV1.rotateClockwise(
            relid: relid,
            fileName: file.file,
            type: type
        ) { resp in
                
            loadingView.hide()
            
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

            guard self.isInDOM, self.currentView == selectedIndex else { return }
            
            self.file = file
            
            if self.currentType == .image {
                self.image.src("\(payload.url)\(payload.fileName)")
            }
            else if self.currentType == .video {
                
                let avatar = payload.fileName.replace(from: ".mp4", to: ".jpg")
                
                let _ = Img()
                    .src("\(payload.url)\(avatar)")
                    .onLoad {
                        guard self.isInDOM, self.currentView == selectedIndex else { return }
                        
                        self.video.poster("\(payload.url)\(avatar)")
                        
                        self.video.src("\(payload.url)\(payload.fileName)")
                    }
                
            }
            
        }
    }
    
    func rotateCounterClockwise(){
        guard showsMediaActions else { return }
        
        guard let file else {
            showError(.generalError, "No se ha selecionado archivo para descargar.")
            return
        }
        
        guard let relid else {
            showError(.generalError, "No se ha localizado el id relacionado.")
            return
        }

        let selectedIndex = currentView
        
        loadingView.show()
        
        API.custAPIV1.rotateCounterClockwise(
            relid: relid,
            fileName: file.file,
            type: type
        ) { resp in
                
            loadingView.hide()
            
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

            guard self.isInDOM, self.currentView == selectedIndex else { return }
            
            self.file = file
            
            if self.currentType == .image {
                self.image.src("\(payload.url)\(payload.fileName)")
            }
            else if self.currentType == .video {
                
                let avatar = payload.fileName.replace(from: ".mp4", to: ".jpg")
                
                let _ = Img()
                    .src("\(payload.url)\(avatar)")
                    .onLoad {
                        guard self.isInDOM, self.currentView == selectedIndex else { return }
                        
                        self.video.poster("\(payload.url)\(avatar)")
                        
                        self.video.src("\(payload.url)\(payload.fileName)")
                    }
                
            }
            
        }
        
    }
    
    func deleteMedia(){
        guard showsMediaActions else { return }
        
        switch type {
        case .orderChat:
            break
        case .orderFile:
            
            guard let orderId = relid else {
                return
            }
            
            guard let fileId = file?.fileId else {
                return
            }
            
            addToDom(ConfirmationView(
                type: .aproveDeny,
                title: "Eliminar Elemento",
                message: "¿Esta seguro que desea eliminar, esta accion no se puede revertir.?"
            ){ isConfirmed, comment in
                
                if isConfirmed {
                    
                    loadingView.show()
                    
                    API.custOrderV1.deleteFile(
                        orderId: orderId,
                        fileId: fileId
                    ) { resp in
                    
                        loadingView.hide()
                        
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
        case .content:
            break
        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        video.src("")
        thumbnailButtons.removeAll()
        $currentType.removeAllListeners()
    }

}

extension MediaViewer {
    
    public struct MediaFile {
        
        public var fileId: UUID?
        
        public var file: String
        
        public var avatar: String
        
        public var type: FileTypes

        public var url: String?
        
        public init(
            fileId: UUID?,
            file: String,
            avatar: String,
            type: FileTypes,
            url: String? = nil
        ) {
            self.fileId = fileId
            self.file = file
            self.avatar = avatar
            self.type = type
            self.url = url
        }
    }

}
