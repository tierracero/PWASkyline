//
//  ImageEditor.swift
//  
//
//  Created by Victor Cantu on 9/19/22.
//


import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest


/// https://tierracero.com/iCatch/image.jpeg

class ImageEditor: Div {
    
    override class var name: String { "div" }
    
    let eventid: UUID
    
    /// product, service, album, blog, order, webNote, oncreate, chat, departmentAvatar, categoryAvatar, lineAvatar
    let to: ImagePickerTo
    
    let relid: UUID?
    
    /// logoIndexMain, logoIndexWhite, logoIndexWhiteTrans, logoIndexBlack, logoIndexBlackTrans, logoIndexIcon, ...
    let subId: CustWebFilesObjectType?
    
    let isAvatar: Bool
    
    /// in case this image has been previosly registerd
    let mediaid: UUID?
    
    let path: String
    
    var originalImage: String
    
    let originalWidth: Int
    
    let originalHeight: Int
    
    let wapWidthPre: Int?
    
    let wapHeightPre: Int?
    
    /// gives feed back when image  is being proccessd
    /// the new image will de provided via web socket
    private var callback: ((
    ) -> ())
    
    init(
        eventid: UUID,
        to: ImagePickerTo,
        relid: UUID?,
        subId: CustWebFilesObjectType?,
        isAvatar: Bool,
        mediaid: UUID?,
        path: String,
        originalImage: String,
        originalWidth: Int,
        originalHeight: Int,
        wapWidthPre: Int? =  nil,
        wapHeightPre: Int? =  nil,
        callback: @escaping ((
        ) -> ())
    ) {
        self.eventid = eventid
        self.to = to
        self.relid = relid
        self.subId = subId
        self.isAvatar = isAvatar
        self.mediaid = mediaid
        self.path = path
        self.originalImage = originalImage
        self.originalWidth = originalWidth
        self.originalHeight = originalHeight
        self.wapWidthPre = wapWidthPre
        self.wapHeightPre = wapHeightPre
        self.callback = callback
    }
    
    let ws = WS()
    
    @State var imageIsLoaded: Bool = false
    
    var secondCropperIsActive = false
    
    var imgEditorIsActive = false
    
    var imgIsBeingReplaced = false
    
    @State var relativeHeight: Int = 500
    @State var relativeWidth: Int = 500
    @State var top: Int = 0
    @State var left: Int = 0
    
    @State var logoRelativeHeight: Int = 500
    @State var logoRelativeWidth: Int = 500
    @State var logoTop: Int = 0
    @State var logoLeft: Int = 0
    
    @State var editStep: EditStep = .thump
    
    var thumpWidth = 0
    var thumpHeight = 0
    var thumpX = 0
    var thumpY = 0
    
    var wapWidth = 0
    var wapHeight = 0
    var wapX = 0
    var wapY = 0
    
    var watermarks: [String] = []
    
    var watermarksRefs: [ String : WatermarkItem ] = [:]
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var imageThump = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .id(Id(stringLiteral: "imageEditorThump"))
    
    lazy var imageWap = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .id(Id(stringLiteral: "imageEditorWap"))
    
    lazy var imageLogo = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .id(Id(stringLiteral: "imageEditorWaterMark"))
        
    lazy var editThumpDiv = Div{
        
        Div{
            self.imageThump
                .height(self.$relativeHeight)
                .width(self.$relativeWidth)
        }
        .id(.init("imageThumpContainer"))
        .height(self.$relativeHeight)
        .width(self.$relativeWidth)
        .position(.relative)
        .left(self.$left)
        .top(self.$top)
        
    }
        .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
        .id(Id(stringLiteral: "imageEditorThumpDiv"))
        .custom("height", "calc(100% - 73px)")
        .backgroundColor(.grayBlackDark)
        .borderRadius(all: 12.px)
        .width(100.percent)
        .hidden(self.$editStep.map{ ($0 != .thump) })
    
    lazy var editWapDiv = Div{
        Div{
            self.imageWap
                .height(self.$relativeHeight)
                .width(self.$relativeWidth)
        }
        .id(.init("imageThumpContainer"))
        .height(self.$relativeHeight)
        .width(self.$relativeWidth)
        .position(.relative)
        .left(self.$left)
        .top(self.$top)

    }
        .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
        .id(Id(stringLiteral: "imageEditorWapDiv"))
        .custom("height", "calc(100% - 73px)")
        .backgroundColor(.grayBlackDark)
        .borderRadius(all: 12.px)
        .width(100.percent)
        .hidden(self.$editStep.map{ ($0 != .wap) })
    
    lazy var iconLogoDiv = Div()
        .id(Id(stringLiteral: "iconLogoDiv"))
    
    lazy var fileInput = InputFile()
        .multiple(true)
        .accept([ "image/png", "image/jpg", "image/jpge", "image/webp" ])
        .display(.none)
    
    var watingBackgroundRemoval = false
    
    var backgroundRemovalId: UUID = .init()
    
    @State var imageEditorProcessingViewText = ""
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2("Editar Imagen ")
                    .color(.lightBlueText)
                
            }
            .marginBottom(3.px)
            
            self.editThumpDiv
            
            self.editWapDiv
            
            Div{
                Div{
                    Div{
                        self.imageLogo
                        .height(self.$logoRelativeHeight)
                        .width(self.$logoRelativeWidth)
                    }
                    .id(Id(stringLiteral: "imageEditorWMImg"))
                    .height(self.$logoRelativeHeight)
                    .width(self.$logoRelativeWidth)
                    .position(.relative)
                    .left(self.$logoLeft)
                    .top(self.$logoTop)
                    
                }
                .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
                .id(Id(stringLiteral: "imageEditorWMDiv"))
                .custom("width", "calc(100% - 270px)")
                .backgroundColor(.grayBlackDark)
                .borderRadius(all: 12.px)
                .height(100.percent)
                .float(.left)
                
                Div{
                    
                    H3("Herramientas")
                        .color(.white)
                        .float(.left)
                    
                    Div()
                        .clear(.both)
                        .height(3.px)
                    
                    Div{
                        Div("Remover Fondo")
                            .color(.yellowTC)
                            .padding(all: 3.px)
                            .width(95.percent)
                            .marginTop(3.px)
                            .class(.uibtn)
                            .onClick {
                                self.removeBackGround()
                            }
                    }
                    
                    Div()
                        .clear(.both)
                        .height(12.px)
                    
                    Div{
                        self.fileInput
                        H3("Iconos")
                            .color(.white)
                            .float(.left)
                        
                        Img()
                            .src("/skyline/media/add.png")
                            .cursor(.pointer)
                            .marginTop(3.px)
                            .float(.right)
                            .width(24.px)
                            .onClick {
                                self.fileInput.click()
                            }
                    }
                    
                    Div()
                        .clear(.both)
                        .height(3.px)
                    
                    self.iconLogoDiv
                    .class(.roundDarkBlue)
                    .width(100.percent)
                    .padding(all: 3.px)
                    .overflow(.auto)
                    .height(300.px)
                    
                }
                .height(100.percent)
                .marginRight(5.px)
                .width(260.px)
                .float(.right)
                
                Div().class(.clear)
                
            }
            .hidden(self.$editStep.map{ ($0 != .logo) })
            .custom("height", "calc(100% - 73px)")
                    
            Div{
                H2("Miniatura Cuadrada")
                    .color(self.$editStep.map{ ($0 == .thump) ?  .lightGray : .gray })
                    .marginRight(12.px)
                    .marginTop(12.px)
                    .float(.left)
                
                H2("Miniatura General")
                    .color(self.$editStep.map{ ($0 == .wap) ?  .lightGray : .gray })
                    .marginRight(12.px)
                    .marginTop(12.px)
                    .float(.left)
                
                H2("Imagen Principal")
                    .color(self.$editStep.map{ ($0 == .logo) ?  .lightGray : .gray })
                    .marginTop(12.px)
                    .float(.left)
                
                Div(self.$editStep.map{ ($0 == .logo) ?  "Guardar" : "Siguiente" })
                    .hidden(self.$imageIsLoaded.map{ !$0})
                    .class(.uibtnLargeOrange)
                    .marginTop(5.px)
                    .align(.center)
                    .float(.right)
                    .width(125.px)
                    .onClick {
                        switch self.editStep {
                        case .thump:
                            
                            //Set Thump Data
                            self.thumpWidth = getElementWidth("imageEditorThumpBox")
                            self.thumpHeight = getElementHeight("imageEditorThumpBox")
                            self.thumpX = getElementX("imageEditorThumpBox")
                            self.thumpY = getElementY("imageEditorThumpBox")
                            
                            self.editStep = .wap
                            
                            if !self.secondCropperIsActive {
                                
                                self.secondCropperIsActive = true
                                
                                //let gridWidth = Double(getElementWidth("imageEditorWapDiv"))
                                
                                //let gridHeight = Double(getElementHeight("imageEditorWapDiv"))
                                
                                let thumpWidth = self.wapWidthPre ?? 300
                                
                                let thumpHeight = self.wapHeightPre ?? 370
                                
                                var cropWidth: Int = 0
                                
                                var cropHeight: Int = 0
                                
                                let radio = Double(self.relativeHeight) / Double(thumpHeight)
                                
                                print(Double(self.relativeHeight) / Double(thumpHeight))
                                
                                print(Double(thumpHeight) / Double(self.relativeHeight))
                                
                                cropWidth = (Int(Double(thumpWidth) * radio) / 3) * 2
                                
                                cropHeight = (Int(Double(thumpHeight) * radio) / 3 ) * 2
                                
                                print("cropWidth \(cropWidth)")
                                
                                print("cropHeight \(cropHeight)")

                                cropWidth = (cropWidth / 3) * 2
                                
                                cropHeight = (cropHeight / 3) * 2
                                
                                jcrop("imageEditorWap",cropWidth, cropHeight)
                                
                            }
                        case .wap:
                            
                            // Set Wap Data
                            
                            self.wapWidth = getElementWidth("imageEditorWapBox")
                            self.wapHeight = getElementHeight("imageEditorWapBox")
                            self.wapX = getElementX("imageEditorWapBox")
                            self.wapY = getElementY("imageEditorWapBox")
                            
                            self.editStep = .logo
                            
                            self.calcLogoIconWorkSpace()
                            
                        case .logo:
                            self.finishEdition()
                        }
                    }
                
                Div("Atras")
                    .hidden(self.$editStep.map{ ($0 == .thump) })
                    .class(.uibtnLarge)
                    .marginRight(7.px)
                    .marginTop(5.px)
                    .float(.right)
                    .onClick {
                        switch self.editStep {
                        case .thump:
                            break
                        case .wap:
                            self.editStep = .thump
                        case .logo:
                            self.editStep = .wap
                        }
                    }
                 
            }
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .width(80.percent)
        .left(10.percent)
        .top(10.percent)
        .color(.white)
        
        Div{
            Table {
                Tr{
                    Td(self.$imageEditorProcessingViewText)
                        .fontSize(22.px)
                        .verticalAlign(.middle)
                        .fontWeight(.bolder)
                        .align(.center)
                        .color(.white)
                }
            }
            .height(100.percent)
            .width(100.percent)
        }
        .hidden(self.$imageEditorProcessingViewText.map{ $0.isEmpty })
        .class(.transparantBlackBackGround)
        .height(100.percent)
        .width(100.percent)
        .position(.fixed)
        .left(0.px)
        .top(0.px)
        
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        if !waterMarkItems.isEmpty {
            loadWaterMarkItems()
        }
        else {
            API.custPOCV1.getIconWaterMark { resp in
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, .unexpenctedMissingPayload)
                    return
                }
                
                waterMarkItems = data
                
                self.loadWaterMarkItems()
            }
        }
        
        self.fileInput.$files.listen {
            if let file = $0.first {
                self.uploadIcon(file)
            }
            
        }
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            switch event {
            case .asyncRemoveBackground:
                
                loadingView(show: false)
                
                if let payload = self.ws.asyncRemoveBackground($0) {
                    
                    print("🗳  \(payload.url)")
                    
                    print("🗳  \(payload.fileName)")
                    
                    self.watingBackgroundRemoval = false
                    self.imageEditorProcessingViewText = "Cargando Nueva Imagen"
                    self.imageLogo
                        .load("\(payload.url)\(payload.fileName)")
                        .onLoad {
                            self.imageEditorProcessingViewText = ""
                        }

                    self.imgIsBeingReplaced = true
                    
                    self.originalImage = payload.fileName
                    
                    
                }
                else {
                    showError(.errorGeneral, .unexpenctedMissingPayload)
                    return
                }
            default:
                break
            }
            
        }
        
    }
    
    override func didAddToDOM() {
        
        Console.clear()
        
        print("🟢  001")
        
        /// Set placeholder image
        let gridWidth = getElementWidth("imageEditorThumpDiv")
        
        let gridHeight = getElementHeight("imageEditorThumpDiv")
        
        print("🟢  002")
        
        print("gridWidth")
        print(gridWidth)
        print("gridHeight")
        print(gridHeight)
        
        self.relativeWidth = gridHeight
        
        self.relativeHeight = gridHeight
        
        self.left = (gridWidth / 2) - (gridHeight / 2)
        
        print("🟢  003")
        
        //scalcLogoIconWorkSpace()
        
        print("\(self.path)og_\(self.originalImage)")
        
        print("🟢  004")
        
        _ = Img()
            .src("\(self.path)og_\(self.originalImage)")
            .onLoad {
                
                print("🟢  004 LOADED")
                
                var w = 0
                var h = 0
                
                let _gridWidth: Double = Double(gridWidth)
                let _gridHeight: Double = Double(gridHeight)
                let _iw: Double = Double(self.originalWidth)
                let _ih: Double = Double(self.originalHeight)
                
                if (_iw < _gridWidth) && (_ih < _gridHeight) {
                    w = Int(_iw)
                    h = Int(_ih)
                }
                else {
                    
                    if _iw > _ih {
                        
                        var ratio = _gridWidth / _iw
                        
                        let _h = _ih * ratio
                        
                        if _h <= _gridHeight {
                            w = Int(_gridWidth)
                            h = Int(_h)
                        }
                        else{
                           
                            ratio = _gridHeight / _ih
                            
                            h = Int(_gridHeight)
                            
                            w = Int(_iw * ratio)
                        }
                    }
                    else {
                        
                        var ratio = _gridHeight / _ih
                         
                        let _w = _iw * ratio
                        
                        if _w <= _gridWidth {
                            h = Int(_gridHeight)
                            w = Int(_w)
                        }
                        else{
                            ratio = _gridWidth / _iw
                            w = Int(_gridWidth)
                            h = Int(_ih * ratio)
                        }
                        
                    }
                }
                
                print("🟢  🟢  \(self.path)og_\(self.originalImage)")
                
                self.imageThump
                    .load("\(self.path)og_\(self.originalImage)")
                
                self.imageWap
                    .load("\(self.path)og_\(self.originalImage)")
                
                self.imageLogo
                    .load("\(self.path)og_\(self.originalImage)")

                self.relativeWidth = w
                
                self.relativeHeight = h
                
                self.left = (gridWidth / 2) - (self.relativeWidth / 2)
                
                self.top = (gridHeight / 2) - (self.relativeHeight / 2)
                
                self.imageIsLoaded = true
                
                var cropWidth = self.relativeHeight
                
                var cropHeight = cropWidth
                
                
                cropWidth = (cropWidth / 3) * 2
                cropHeight = (cropHeight / 3) * 2
                
                jcrop("imageEditorThump",cropWidth, cropHeight)
                
            }
            .onError {
                print("🔴  004 NOT_LOADED")
            }
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }

    func calcLogoIconWorkSpace(){
        /// Set logo / iocn image
        let gridWidth = getElementWidth("imageEditorWMDiv")
        
        let gridHeight = getElementHeight("imageEditorWMDiv")
        
        var w = 0
        var h = 0
        
        print("gridWidth")
        print(gridWidth)
        print("gridHeight")
        print(gridHeight)
        
        let _gridWidth: Double = Double(gridWidth)
        
        let _gridHeight: Double = Double(gridHeight)
        
        let _iw: Double = Double(self.originalWidth)
        let _ih: Double = Double(self.originalHeight)
        
        if (_iw < _gridWidth) && (_ih < _gridHeight) {
            w = Int(_iw)
            h = Int(_ih)
        }
        else{
            if _iw > _ih {
                
                var ratio = _gridWidth / _iw
                
                let _h = _ih * ratio
                
                if _h <= _gridHeight {
                    w = Int(_gridWidth)
                    h = Int(_h)
                }
                else{
                   
                    ratio = _gridHeight / _ih
                    
                    h = Int(_gridHeight)
                    
                    w = Int(_iw * ratio)
                }
            }
            else{
                
                var ratio = _gridHeight / _ih
                 
                let _w = _iw * ratio
                
                if _w <= _gridWidth {
                    h = Int(_gridHeight)
                    w = Int(_w)
                }
                else{
                    ratio = _gridWidth / _iw
                    w = Int(_gridWidth)
                    h = Int(_ih * ratio)
                }
            }
        }
                
        self.logoRelativeWidth = w
        
        self.logoRelativeHeight = h
        
        self.logoLeft = (gridWidth / 2) - (self.logoRelativeWidth / 2)
        
        self.logoTop = (gridHeight / 2) - (self.logoRelativeHeight / 2)
        
    }
    
    func loadWaterMarkItems(){
    
        waterMarkItems.forEach { file in
            
            let view = ImageEditorItem( 
                url: "https://\(custCatchUrl)/contenido/\(file.file)",
                width: file.width,
                height: file.height
            ) { url, width, height in
                self.addIconToEditor(url, width, height)
            }
            
            iconLogoDiv.appendChild(view)
            
        }
    }
    
    func addIconToEditor(_ url: String, _ width: Int, _ height: Int) {

        let itemID = callKey(12)
        
        var w = width
        var h = height
        
        if logoRelativeWidth < width {
            w = logoRelativeWidth
            h = Int((Double(logoRelativeWidth) / Double(width)) * Double(height))
        }
        
        if logoRelativeHeight < h {
            w = Int((Double(logoRelativeHeight) / Double(height)) * Double(width))
            h = logoRelativeHeight
        }
        
        if ( w < 50 || h < 50){
            w = w * 2
            h = h * 2
        }
        
        jcrop("imageEditorWaterMark",itemID, url, w, h)
        
        guard let imageName = url.explode("/").last else {
            return
        }
        
        self.watermarks.append(itemID)
        
        self.watermarksRefs[itemID] = .init(
            imageName: imageName,
            originalWidth: width,
            originalHeight: height
        )
        
        
        if let domElement = WebApp.shared.document.querySelector("#\(itemID)") {
            
            domElement.appendChild(
                Img()
                    .src("/skyline/media/cross.png")
                    .margin(all: 7.px)
                    .cursor(.pointer)
                    .float(.right)
                    .width(24.px)
                    .onClick {
                        
                        var ni: [String] = []
                        
                        self.watermarks.forEach { item in
                            if item != itemID {
                                ni.append(item)
                            }
                        }
                        
                        self.watermarks = ni
                        
                        removeItem(itemID)
                        
                    }
            )
        }
    }
    
    func finishEdition(){
        
        var _watermarks: [WaterMarkItem] = []
        
        watermarks.forEach { id in
            
            guard let img = watermarksRefs[id] else {
                return
            }
            
            
            let parentid = getParentId(childid: "\(id)Img")
            
            let _w = getElementWidth("\(id)Img")
            
            let _h = getElementHeight("\(id)Img")
            
            let _x = getElementX(parentid)
            
            let _y = getElementY(parentid)
            
            _watermarks.append(.init(
                id: .init(),
                image: img.imageName,
                originalWidth: img.originalWidth,
                originalHeight: img.originalHeight,
                width: _w,
                height: _h,
                x: _x,
                y: _y
            ))
            
        }
        
        loadingView(show: true)
        
        API.custAPIV1.saveCropImage(
            eventid: self.eventid,
            replaceImage: self.imgIsBeingReplaced,
            to: to, 
            subId: self.subId,
            relId: relid,
            folio: nil,
            isAvatar: isAvatar,
            mediaid: self.mediaid,
            originalImage: self.originalImage,
            originalWidth: self.originalWidth,
            originalHeight: self.originalHeight,
            relativeWidth: self.relativeWidth,
            relativeHieght: self.relativeWidth,
            logoRelativeHeight: self.logoRelativeWidth,
            logoRelativeWidth: self.logoRelativeWidth,
            thumpWidth: self.thumpWidth,
            thumpHeight: self.thumpHeight,
            thumpX: self.thumpX,
            thumpY: self.thumpY,
            wapWidth: self.wapWidth,
            wapHeight: self.wapHeight,
            wapX: self.wapX,
            wapY: self.wapY,
            watermarks: _watermarks,
            connid: custCatchChatConnID,
            roomtoken: nil,
            usertoken: nil,
            mid: nil,
            replyTo: nil
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            do {
                
                let data = try JSONEncoder().encode(resp)
                
                print("🦄  NEW IMAGE")
                
                print(String(data: data, encoding: .utf8)!)
                
            }
            catch {  }

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }

            self.remove()
            
        }
    }
    
    func uploadIcon(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        let view = ImageEditorItem(
            url: nil,
            width: 0,
            height: 0
        ){ url, width, height in
            self.addIconToEditor(url, width, height)
        }
        
        xhr.onLoadStart {
            //self.uploadPercent = "0"
            self.iconLogoDiv.appendChild(view)
            
            _ = JSObject.global.scrollToBottom!( "iconLogoDiv")
        }
        
        xhr.onError { jsValue in
            showError(.errorDeCommunicacion, .serverConextionError)
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            view.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.errorGeneral, .serverConextionError + " 001")
                view.remove()
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.errorGeneral, .serverConextionError + " 002")
                view.remove()
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadMediaResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    view.remove()
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se pudo cargar datos")
                    view.remove()
                    return
                }
                
                waterMarkItems.append(.init(
                    id: data.id ?? .init(),
                    createdAt: getNow(),
                    modifiedAt: getNow(),
                    custWebContent: nil,
                    type: .img,
                    objectType: .general,
                    file: data.file,
                    avatar: data.file,
                    description: "",
                    descr_en: "",
                    isAvatar: false,
                    files: data.file,
                    lang: .Spanish,
                    width: data.width,
                    height: data.height
                ))
                
                view.width = data.width
                view.height = data.height
                view.loadImage("\(data.url)\(data.file)")
                
            } catch {
                
                showError(.errorGeneral, .serverConextionError + " 003")
                view.remove()
                print(error)
                
                return
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
        
        xhr.open(method: "POST", url: "https://intratc.co/api/custPOC/v1/uploadIconWaterMark")
        
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
    
    func removeBackGround() {
        
        imageEditorProcessingViewText = "Solictando"
        
        backgroundRemovalId = .init()
        
        API.custAPIV1.removeBackground(
            eventid: backgroundRemovalId,
            to: to,
            toId: relid, 
            subId: subId,
            fileName: originalImage,
            connid: custCatchChatConnID,
            roomtoken: nil,
            usertoken: nil,
            mid: nil,
            replyTo: nil
        ) { resp in
            
            guard let resp else {
                self.imageEditorProcessingViewText = ""
                showError(.errorDeCommunicacion, .serverConextionError)
                loadingView(show: false)
                return
            }
            
            guard resp.status == .ok else {
                self.imageEditorProcessingViewText = ""
                showError(.errorGeneral, resp.msg)
                loadingView(show: false)
                return
            }
            
            self.watingBackgroundRemoval = true
            
            self.imageEditorProcessingViewText = "Processando..."
            
            self.checkRemoveBackGroundState(wait: 7)
            
        }
        
    }
    
    func checkRemoveBackGroundState(wait: Double){
        
        Dispatch.asyncAfter(wait) {
            
            if !self.watingBackgroundRemoval {
                return
            }
            
            API.custAPIV1.asyncCheckUploadStatus(
                type: .removeBackgrond,
                eventid: self.backgroundRemovalId
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
                        self.watingBackgroundRemoval = false
                        showError(.errorGeneral, "Fallo cargo del archivo.")
                        return
                    }
                    self.checkRemoveBackGroundState(wait: wait + 1)
                case .error:
                    self.watingBackgroundRemoval = false
                    showError(.errorGeneral, "Fallo cargo del archivo.")
                case .done:
                    
                    guard var image = payload.image else {
                        showError(.errorGeneral, "No se encontro imagen, refsque para cargarla.")
                        return
                    }
                    
                    self.watingBackgroundRemoval = false
                    
                    if let ext = AllowedExtentions(rawValue: (image.explode(".").last ?? "")) {
                        switch ext.requestType {
                        case .document:
                            break
                        case .image:
                            break
                        case .audio:
                            break
                        case .video:
                            image = image.replace(from: ".mp4", to: ".jpg")
                        }
                    }
                    
                    self.imageLogo
                        .load("https://\(custCatchUrl)/iCatch/thump_\(image)")

                    self.imgIsBeingReplaced = true
                    
                    self.originalImage = image
                    
                }
            }
        }
    }
    
}

extension ImageEditor {
    
    struct WatermarkItem: Codable {
        let imageName: String
        let originalWidth: Int
        let originalHeight: Int
    }
    
    enum EditStep: String {
        case thump
        case wap
        case logo
        
    }
    
}
