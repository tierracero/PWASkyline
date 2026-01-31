//
//  SocialManagerView.swift
//  
//
//  Created by Victor Cantu on 10/9/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class SocialManagerView: Div {
    
    override class var name: String { "div" }
    
     /*
     socialLive,
     socialLivePremium,
     */
    
    @State var currentView: CurrentView = .editor
    
    @State var currentLoadedMedia: SocialManagerPostType = .text
    
    @State var uploadPercent = ""
    
    @State var profile: BillingEfect? = nil
    
    /// choseBase, choseSocialLive, socialLivePremium
    @State var mode: ActivateServiceViewMode? = nil
    
    @State var pages: [CustSocialPageQuick] = []
    
    @State var pagesView: [SocialManagerItem] = []
    
    @State var posts: [CustSocialPostMain] = []
    
    var choseSocialLiveIsLoaded = false
    
    var choseSocialPremiumIsLoaded = false
    
    @State var hasLoadedMedia = false
    
    var historyIsLoaded = false
    
    /// The user has no Social live service active, we will invite to activate social profile
    lazy var noServiceActiveView = Div{
        if custCatchHerk > 4 {
            
            Div()
            .height(100.percent)
            .width(10.percent)
            .float(.left)
            
            Div{
               
                Div{
                    H1("Social Live")
                        .color(.yellowContrast)
                }
                .padding(all: 7.px)
                .align(.center)
                
                Div{
                    H3("- Con este servicio podras conectar todas tus redes sociales en un solo lugar.")
                        .marginBottom(7.px)
                    
                    H3("- No te pierdas de ningun contacto. Responde a todos los mensajes en TIEMPO REAL.")
                }
                .padding(all: 7.px)
                .color(.white)
                .align(.left)
                
                Div().class(.clear)
                
                Div{
                    
                     Div{
                         H1("Social Live Basico")
                             .color(.yellowContrast)
                     }
                     .padding(all: 7.px)
                     .align(.center)
                    
                    H3("- Leer y mandar mensajes de chat").marginBottom(7.px)
                    
                    H3("- Leer comentarios en publicaciones y responder los ").marginBottom(4.px)
                    
                    H3("y ya... 🥹").marginBottom(7.px)
                    
                }
                .width(50.percent)
                .color(.white)
                .float(.left)
                
                Div{
                    
                     Div{
                         H1("Social Live Premium")
                             .color(.yellowContrast)
                     }
                     .padding(all: 7.px)
                     .align(.center)
                    
                    
                    H3("- Leer y mandar mensajes de chat").marginBottom(7.px)
                    
                    H3("- Leer comentarios en publicaciones y responder los ").marginBottom(7.px)
                    
                    H3("- Editor de Publicaciones").marginBottom(7.px)
                    
                    H3("- Editor de memes").marginBottom(7.px)
                    
                    H3("- Biblioteca con mas de 1000 memes").marginBottom(7.px)
                    
                    H3("- Calendarización de Publicaciones").marginBottom(7.px)
                    
                    H3("- Reportes, que resultados da cada publicación.").marginBottom(7.px)
                    
                    H3("- Multi Publicador, publica en todas tus redes en un solo click").marginBottom(7.px)
                    
                    H3("- Publicación automatica de contenido.").marginBottom(7.px)
                    
                    H3("- Metas y recordatorios para tu Social Manager").marginBottom(7.px)
                }
                .width(50.percent)
                .color(.white)
                .float(.left)
                
                Div().class(.clear).height(12.px)
                
                Div{
                    Div("Contratar Basico 😀")
                        .class(.uibtnLarge)
                        .onClick {
                            self.mode = .choseSocialLive
                        }
                    
                    Span("(ver precios)").color(.gray).marginTop(3.px)
                    
                }
                .width(50.percent)
                .align(.center)
                .float(.left)
                
                Div{
                    
                    Div("Contratar Premium 🤩")
                        .class(.uibtnLarge)
                        .onClick {
                            self.mode = .choseSocialPremium
                        }
                    
                    Span("(ver precios)").color(.gray).marginTop(3.px)
                }
                .width(50.percent)
                .align(.center)
                .float(.left)
                
            }
            .height(100.percent)
            .width(80.percent)
            .float(.left)
            
            Div()
            .height(100.percent)
            .width(10.percent)
            .float(.left)
        }
        else{
            Table{
                Tr{
                    Td("Contacte al dueño del servicio para activar este modulo.")
                        .align(.center)
                        .verticalAlign(.middle)
                }
            }
            .width(100.percent)
            .height(100.percent)
        }
    }
        .hidden(self.$mode.map { $0 != .choseBase })
        .custom("height", "calc(100% - 30px)")
        .width(100.percent)
    
    lazy var choseSocialLiveInner = Div()
        .width(50.percent)
    
    lazy var choseSocialLive = Div {
        self.choseSocialLiveInner
    }
        .hidden(self.$mode.map { $0 != .choseSocialLive })
        .custom("height", "calc(100% - 30px)")
        .width(100.percent)
        .align(.center)
    
    lazy var choseSocialLivePremiumInner = Div()
        .width(50.percent)
    
    lazy var choseSocialLivePremium = Div{
        self.choseSocialLivePremiumInner
    }
        .hidden(self.$mode.map { $0 != .choseSocialPremium })
        .custom("height", "calc(100% - 30px)")
        .width(100.percent)
        .align(.center)
    
    lazy var socialLiveView = Div{
        
    }
        .hidden(self.$profile.map { $0 != .socialLive })
        .custom("height", "calc(100% - 30px)")
        .width(100.percent)
    
    lazy var socialNetworksGrid = Div()
        .padding(all: 3.px)
    
    lazy var socialLivePremiumView = Div {
        
        Div{
            
            H2("Crear Nueva")
                .borderBottom(width: .thin, style: self.$currentView.map{ ($0 == .editor) ? .solid : .hidden }, color: .titleBlue)
                .color( self.$currentView.map{ ($0 == .editor) ? .titleBlue : .gray } )
                .marginRight(7.px)
                .cursor(.pointer)
                .float(.left)
                .onClick {
                    self.currentView = .editor
                }
            
            H2("Publicaciones")
                .borderBottom(width: .thin, style: self.$currentView.map{ ($0 == .posts) ? .solid : .hidden }, color: .titleBlue)
                .color( self.$currentView.map{ ($0 == .posts) ? .titleBlue : .gray } )
                .marginRight(7.px)
                .cursor(.pointer)
                .float(.left)
                .onClick {
                    self.currentView = .posts
                    
                    if !self.historyIsLoaded {
                        self.historyIsLoaded = true
                        self.loadPosts( type: .active )
                    }
                    
                }
            
            Div().class(.clear)
            
        }
        .custom("width", "calc(100% - 350px)")
        //.marginBottom( 7.px)
        .height(33.px)
        .float(.left)
        
        Div{
            H2("Herramientas")
                .color(.titleBlue)
                .float(.left)
                .hidden( self.$currentView.map{ ($0 != .editor) } )
            
            Img()
                .closeButton(.view)
                .onClick{
                    self.remove()
                }
            
            Div().class(.clear)
        }
        .marginLeft(7.px)
        .height(33.px)
        .width(343.px)
        .float(.left)
        
        Div().class(.clear)
        
        /// Image Grid
        Div{
            
            Div{
                self.editThumpDiv
            }
            .custom("height", "calc(100% - 65px)")
            
            Div {
                
                Div("Siguiente")
                    .class(.uibtnLargeOrange)
                    .float(.right)
                    .onClick {
                        self.finishEdition()
                    }
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/upload2.png")
                            .margin(all: 3.px)
                            .height(18.px)
                    }
                    .float(.left)
                    
                    Span("Subir Foto/Video")
                        .fontSize(24.px)
                    
                    Div().class(.clear)
                }
                .hidden(self.$hasLoadedMedia)
                .marginTop(11.px)
                .float(.right)
                .class(.uibtn)
                .onClick {
                    self.fileInput.click()
                }
                
                Div(self.$uploadPercent.map{ $0.isEmpty ? "" : "Uploaded: \($0)%"})
                    .marginRight(7.px)
                    .color(.darkOrange)
                    .fontSize(28.px)
                    .float(.right)
                
                
            }
            
        }
        .hidden( self.$currentView.map{ ($0 != .editor) } )
        .custom("width", "calc(100% - 350px)")
        .custom("height", "calc(100% - 18px)")
        .float(.left)
        
        /// Option Tool
        Div{
            
            self.iconLogoDiv
            .custom("height", "calc(100% - 280px)")
            .class(.roundDarkBlue)
            .overflow(.auto)
            .padding(all: 7.px)
            
            Div{
                
                Img()
                    .float(.right)
                    .cursor(.pointer)
                    .src("/skyline/media/add.png")
                    .height(32.px)
                    .marginTop(-3.px)
                    .paddingRight(0.px)
                    .onClick {
                        addToDom(SocialManagerAddProfileView { page in
                            self.pages.append(page)
                        })
                    }
                
                H2("Mis Perfiles")
                    .color(.titleBlue)
            }
            .marginTop(7.px)
            
            self.socialNetworksGrid
                .class(.roundDarkBlue)
                .overflow(.auto)
                .marginTop(7.px)
                .height(200.px)
            
        }
        .hidden( self.$currentView.map{ ($0 != .editor) } )
        .custom("height", "calc(100% - 20px)")
        .marginLeft(7.px)
        .width(343.px)
        .float(.left)
        
        Div{
            
            Div{
                
                Div{
                    
                    self.loadPostBySelect
                        .float(.right)
                    
                    H2("Historial")
                        .color(.white)
                }
                
                Div().class(.clear)
                
                Div{
                    
                    ForEach(self.$posts){ post in
                        SocialManagerPostRow(post: post)
                            .onClick {
                                addToDom( SocialManagerPostView(post: post) )
                            }
                    }
                    
                }
                .custom("height", "calc(100% - 57px)")
                .class(.roundDarkBlue)
                .padding(all: 3.px)
                .margin(all: 3.px)
                .overflow(.auto)
            }
            .height(100.percent)
            .width(60.percent)
            .float(.left)
            
            Div{
                
            }
            .height(100.percent)
            .width(40.percent)
            .float(.left)
            
            Div().class(.clear)
            
        }
        .hidden( self.$currentView.map{ ($0 != .posts) } )
        .custom("height", "calc(100% - 18px)")
        
        Div().class(.clear)
        
    }
    .hidden(self.$profile.map { $0 != .socialLivePremium })
    .custom("height", "calc(100% - 0px)")
    .width(100.percent)
    
    lazy var titleField = InputText()
        .class(.textFiledBlackDarkLarge)
    
    lazy var bodyField = InputText()
        .class(.textFiledBlackDarkLarge)
    
    lazy var fileInput = InputFile()
        .accept(["image/*", "video/*"])
        .display(.none)
    
    lazy var imageThump = Img()
        .src("skyline/media/tierraceroRoundLogoWhite.svg")
        .id(Id(stringLiteral: "imageEditorThump"))
    
    lazy var videoContainer = Video()
        .poster("skyline/media/tierraceroRoundLogoWhite.svg")
        .id(Id(stringLiteral: "videoEditorThump"))
        .controls(true)
    
    lazy var editorWrapper = Div {
        
        Table().noResult(label: "Seleccione foto/video 📸, o siguiente para have una publicacion sencilla o un vinculo.")
            .hidden(self.$currentLoadedMedia.map{ $0 != .text })
        
        self.imageThump
            .height(self.$relativeHeight)
            .width(self.$relativeWidth)
            .hidden(self.$currentLoadedMedia.map{ $0 != .image })
        
        self.videoContainer
            .height(self.$relativeHeight)
            .width(self.$relativeWidth)
            .hidden(self.$currentLoadedMedia.map{ $0 != .video })
        
    }
    .id(Id(stringLiteral: "editorWrapper"))
    .height(self.$relativeHeight)
    .width(self.$relativeWidth)
    .position(.relative)
    .left(self.$left)
    .top(self.$top)
    
    lazy var editThumpDiv = Div {
        self.editorWrapper
    }
    .boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
    .id(Id(stringLiteral: "imageEditorThumpDiv"))
    .backgroundColor(.grayBlackDark)
    .borderRadius(all: 12.px)
    .height(100.percent)
    .width(100.percent)
    
    lazy var iconLogoDiv = Div()
    
    lazy var loadPostBySelect = Select()
        .class(.textFiledBlackDark)
        .height(31.px)
        .onChange { _, select in
            
            if let type = CustComponents.GetFromDate(rawValue: select.value) {
                self.loadPosts(type: type)
            }
            
        }
    
    @State var imageIsLoaded: Bool = false
    
    var imgEditorIsActive = false
    
    @State var relativeHeight: Int = 500
    @State var relativeWidth: Int = 500
    @State var top: Int = 0
    @State var left: Int = 0
    
    @State var logoRelativeHeight: Int = 500
    @State var logoRelativeWidth: Int = 500
    @State var logoTop: Int = 0
    @State var logoLeft: Int = 0
    
    var path: String = ""
    var originalImage: String = ""
    var originalWidth: Int = 0
    var originalHeight: Int = 0
    
    var watermarks: [String] = []
    
    var watermarksRefs: [String:ImageEditor.WatermarkItem] = [:]
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Redes Sociales 1")
                    .color(.titleBlue)
                    .float(.left)

            }
            .hidden(self.$profile.map { $0 == .socialLivePremium })
            
            Div().class(.clear)
                .hidden(self.$profile.map { $0 == .socialLivePremium })
            
            self.noServiceActiveView
            
            self.choseSocialLive
            
            self.choseSocialLivePremium
            
            self.socialLiveView
            
            self.socialLivePremiumView
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .height(85.percent)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(10.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        fileInput.$files.listen {
            if let file = $0.first {
                self.loadMedia(file)
            }
        }

        $mode.listen{ mode in
            
            let efect = mode?.efect ?? .none
            
            switch mode{
            case .choseBase:
                break
            case .choseSocialLive:
                
                print("⭐️  choseSocialLive  ⭐️")
                
                if !self.choseSocialLiveIsLoaded {
                    
                    self.choseSocialLiveInner.appendChild(Div{
                        Div{
                            Img()
                                .src("/skyline/media/backDarkOrange.png")
                                .height(24.px)
                            
                            Span(" Atras ")
                                .color(.darkOrange)
                                .fontSize(32.px)
                        }
                        .cursor(.pointer)
                        .float(.left)
                        .onClick {
                            self.mode = .choseBase
                        }
                    })
                    
                    self.choseSocialLiveInner.appendChild(Div().class(.clear).height(7.px))
                    
                    self.choseSocialLiveInner.appendChild(Div("Seleccione Paquete Basico").color(.white).fontSize(32.px))
                    
                    loadingView(show: true)
                    
                    API.custAPIV1.getTCSOCAvailableServices(efect: [efect]) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.comunicationError, resp.msg)
                            return
                        }
                        
                        guard let data = resp.data else {
                            showError(.unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }
                        

                        data.forEach { soc in
                            self.choseSocialLiveInner.appendChild(
                                Div {
                                    Div(soc.comercialDescription)
                                        .float(.left)
                                        .width(70.percent)
                                    Div(soc.cost.formatMoney)
                                        .float(.right)
                                    Div().class(.clear)
                                }
                                    .class(.roundDarkBlue)
                                    .padding(all: 12.px)
                                    .margin(all: 12.px)
                                    .cursor(.pointer)
                                    .fontSize(18.px)
                                    .color(.white)
                                    .onClick {
                                        
                                    }
                            )
                        }
                        
                        self.choseSocialLiveIsLoaded = true
                        
                    }
                    
                }
                
            case .choseSocialPremium:
                
                print("⭐️  choseSocialPremium  ⭐️")
                
                if !self.choseSocialPremiumIsLoaded {
                    
                    self.choseSocialLivePremiumInner.appendChild(Div{
                        Div{
                            Img()
                                .src("/skyline/media/backDarkOrange.png")
                                .height(24.px)
                            
                            Span(" Atras ")
                                .color(.darkOrange)
                                .fontSize(32.px)
                        }
                        .cursor(.pointer)
                        .float(.left)
                        .onClick {
                            self.mode = .choseBase
                        }
                        
                    })
                    
                    self.choseSocialLivePremiumInner.appendChild(Div().class(.clear).height(7.px))
                    
                    self.choseSocialLivePremiumInner.appendChild(Div("Seleccione Paquete Premium").color(.white).fontSize(32.px))
                    
                    loadingView(show: true)
                    
                    API.custAPIV1.getTCSOCAvailableServices(efect: [efect]) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.comunicationError, resp.msg)
                            return
                        }

                        guard let data = resp.data else {
                            showError(.comunicationError, .unexpenctedMissingPayload)
                            return
                        }
                        
                        data.forEach { soc in
                            self.choseSocialLivePremiumInner.appendChild(
                                Div {
                                    Div(soc.comercialDescription)
                                        .float(.left)
                                        .width(70.percent)
                                    Div(soc.cost.formatMoney)
                                        .float(.right)
                                    Div().class(.clear)
                                }
                                    .class(.roundDarkBlue)
                                    .padding(all: 12.px)
                                    .margin(all: 12.px)
                                    .cursor(.pointer)
                                    .fontSize(18.px)
                                    .color(.white)
                                    .onClick {
                                        
                                    }
                            )
                        }
                        
                        self.choseSocialPremiumIsLoaded = true
                    }
                    
                }
                
            case .none:
                break
            }
                    
        }
        
        
        $pages.listen {
            ///SocialManagerItem
            
            self.socialNetworksGrid.innerHTML = ""
            
            self.pagesView = []
            
            $0.forEach { page in
                let view = SocialManagerItem(page: page)
                self.pagesView.append(view)
                self.socialNetworksGrid.appendChild(view)
            }
        }
        
        if !waterMarkItems.isEmpty {
            loadWaterMarkItems()
        }
        else {
            
            API.custPOCV1.getIconWaterMark { resp in
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                waterMarkItems = data
                
                self.loadWaterMarkItems()
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        CustComponents.GetFromDate.allCases.forEach { type in
            loadPostBySelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }
        
        if let profile = customerServiceProfile {
            
            if profile.profile.contains(.socialLivePremium) {
                
                print("🟢  I have socialLivePremium")
                
                /// Will try to load profiles off all social networks
                API.custAPIV1.getSocialPages(
                    profileType: nil,
                    custSocialProfile: nil
                ) { resp in
                    /// Activate Premium Page View
                    self.profile = .socialLivePremium
                    
                    ///  $pages.listener will load social nets active
                    self.pages = resp
                    
                    /// No pages available, will promote load view
                    if self.pages.isEmpty {
                        addToDom(SocialManagerAddProfileView { page in
                            self.pages.append(page)
                        })
                    }
                    
                    /// Set placeholder image
                    let gridWidth = getElementWidth("imageEditorThumpDiv")
                    
                    let gridHeight = getElementHeight("imageEditorThumpDiv")
                    
                    if gridWidth > gridHeight {
                        
                        self.relativeWidth = gridHeight
                        
                        self.relativeHeight = gridHeight
                        
                        self.top = 0
                        
                        self.left = (gridWidth / 2) - (gridHeight / 2)
                        
                    }
                    else{
                        
                        self.relativeWidth = gridWidth
                        
                        self.relativeHeight = gridWidth
                        
                        self.top = (gridHeight / 2) - (gridWidth / 2)
                        
                        self.left = 0
                        
                    }
                    
                }
                
            }
            else if profile.profile.contains(.socialLive) {
                print("🟢  I have socialLive")
                self.profile = .socialLive
            }
            else{
                print("🟠  I have no social profile")
                self.mode = .choseBase
            }
            
        }
        else {
            addToDom(ConfirmView(type: .ok, title: "No se pudo cargar perfil", message: "Hubo un problema al cargar perfile, refresque la pagina si el problema consiste contacte a Soporte TC", callback: { isConfirmed, comment in
                self.remove()
            }))
        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        
        print("didRemoveFromDOM good bye !!")
        
        $mode.removeAllListeners()
        
        $pages.removeAllListeners()
    }
    
    func loadMedia(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        print("🗂  \(file.type)")
        
        xhr.onLoadStart {
            loadingView(show: true)
//            self.pocImageContainer.appendChild(view)
//            _ = JSObject.global.scrollToBottom!("pocImageContainer")
        }
        
        xhr.onError { jsValue in
            loadingView(show: false)
            showError(.comunicationError, .serverConextionError)
            self.uploadPercent = ""
            //view.remove()
        }
        
        xhr.onLoadEnd {
            
            self.uploadPercent = ""
            
            guard let responseText = xhr.responseText else {
                loadingView(show: false)
                showError(.generalError, .serverConextionError + " 001")
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                loadingView(show: false)
                showError(.generalError, .serverConextionError + " 002")
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadMediaResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    loadingView(show: false)
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    loadingView(show: false)
                    showError(.generalError, "No se pudo cargar datos")
                    return
                }
                
                /// Set placeholder image
                let gridWidth = getElementWidth("imageEditorThumpDiv")
                
                let gridHeight = getElementHeight("imageEditorThumpDiv")
                
                self.path = data.url
                
                self.originalImage = data.file
                
                self.originalWidth = data.width
                
                self.originalHeight = data.height
                
                guard let fileType = FileExtention(rawValue: data.file.explode(".").last ?? "") else {
                    loadingView(show: false)
                    showError(.generalError, "Archivo invalido, no se reconocio el archivo.")
                    return
                }
                
                print("fileType \(fileType)")
                
                print("fileType.type \(fileType.type)")
                
                self.hasLoadedMedia = true
                
                if fileType.type == .image {
                    
                    self.currentLoadedMedia = .image
                    
                    _ = Img()
                        .src("\(data.url)og_\(data.avatar)")
                        .onLoad {
                            
                            loadingView(show: false)
                            
                            var w = 0
                            var h = 0
                            
                            let _gridWidth: Double = Double(gridWidth)
                            let _gridHeight: Double = Double(gridHeight)
                            let _iw: Double = Double(data.width)
                            let _ih: Double = Double(data.height)
                            
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
                            
                            self.imageThump
                                .src("\(data.url)og_\(data.avatar)")
                            
                            self.relativeWidth = w
                            
                            self.relativeHeight = h
                            
                            self.left = (gridWidth / 2) - (self.relativeWidth / 2)
                            
                            self.top = (gridHeight / 2) - (self.relativeHeight / 2)
                            
                            self.imageIsLoaded = true
                            
                            var cropWidth = self.relativeHeight
                            
                            var cropHeight = cropWidth
                            
                            cropWidth = (cropWidth / 3) * 2
                            cropHeight = (cropHeight / 3) * 2
                            
                            self.calcLogoIconWorkSpace()
                            
                        }
                }
                else if fileType.type == .video {
                    
                    print("process VIDEO")
                    
                    self.currentLoadedMedia = .video
                    
                    print("\(data.url)\(data.avatar)")
                    
                    _ = Img()
                        .src("\(data.url)\(data.avatar)")
                        .onLoad {
                            
                            loadingView(show: false)
                            
                            var w = 0
                            var h = 0
                            
                            let _gridWidth: Double = Double(gridWidth)
                            let _gridHeight: Double = Double(gridHeight)
                            let _iw: Double = Double(data.width)
                            let _ih: Double = Double(data.height)
                            
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
                                else{
                                    
                                    var ratio = _gridHeight / _ih
                                     
                                    let _w = _iw * ratio
                                    
                                    if _w <= _gridWidth {
                                        h = Int(_gridHeight)
                                        w = Int(_w)
                                    }
                                    else {
                                        ratio = _gridWidth / _iw
                                        w = Int(_gridWidth)
                                        h = Int(_ih * ratio)
                                    }
                                    
                                }
                            }
                            
                            self.videoContainer
                                .src("\(data.url)\(data.file)")
                                .poster("\(data.url)\(data.avatar)")
                            
                            self.relativeWidth = w
                            
                            self.relativeHeight = h
                            
                            self.left = (gridWidth / 2) - (self.relativeWidth / 2)
                            
                            self.top = (gridHeight / 2) - (self.relativeHeight / 2)
                            
                            self.imageIsLoaded = true
                            
                            var cropWidth = self.relativeHeight
                            
                            var cropHeight = cropWidth
                            
                            cropWidth = (cropWidth / 3) * 2
                            cropHeight = (cropHeight / 3) * 2
                            
                            self.calcLogoIconWorkSpace()
                            
                        }
                    
                }
                
            }
            catch {
                showError(.generalError, .serverConextionError + " 003")
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            self.uploadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        formData.append("file", file, filename: file.name)
        
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
    
    func calcLogoIconWorkSpace(){
        
        /// Set logo / iocn image
        let gridWidth = getElementWidth("imageEditorThumpDiv")
        
        let gridHeight = getElementHeight("imageEditorThumpDiv")
        
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
    
    func startEditImage(
        _ viewid: UUID,
        _ id: UUID?,
        _ path: String,
        _ originalImage: String,
        _ originalWidth: Int,
        _ originalHeight: Int
    ){
      
    }
    
    func loadWaterMarkItems(){
    
        waterMarkItems.forEach { file in
            
            let view = ImageEditorItem( url: "https://\(custCatchUrl)/contenido/\(file.file)", width: file.width, height: file.height, callback: { url, width, height in
                self.addIconToEditor(url, width, height)
            })
                .float(.left)
                .marginRight(7.px)
            
            iconLogoDiv.appendChild(view)
            
            
            
        }
    }
    
    func addIconToEditor(_ url: String, _ width: Int, _ height: Int) {

        if !imageIsLoaded {
            return
        }
        
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
        
        var canvasid = "imageEditorThump"
        
        if currentLoadedMedia == .video {
            canvasid = "editorWrapper"
        }
        
        jcrop(canvasid,itemID, url, w, h)
        
        guard let imageName = url.explode("/").last else {
            return
        }
        
        self.watermarks.append(itemID)
        
        self.watermarksRefs[itemID] = .init(
            imageName: imageName,
            originalWidth: width,
            originalHeight: height
        )
        
        Dispatch.asyncAfter(0.3) {
            
            let parentid = getParentId(childid: "\(itemID)Img")
            
            if let domElement = WebApp.shared.document.querySelector("#\(parentid)") {
                
                let btn = Img()
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
                
                if self.currentLoadedMedia == .video {
                    btn
                        .position(.absolute)
                        .left(3.px)
                        .top(3.px)
                }
                
                domElement.appendChild(btn)
                
            }
            else{
                
                Dispatch.asyncAfter(0.3) {
                    
                    let parentid = getParentId(childid: "\(itemID)Img")
                    
                    if let domElement = WebApp.shared.document.querySelector("#\(parentid)") {
                        
                        let btn = Img()
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
                        
                        if self.currentLoadedMedia == .video {
                            btn
                                .position(.absolute)
                                .left(3.px)
                                .top(3.px)
                        }
                        
                        domElement.appendChild(btn)
                        
                    }
                    else{
                        
                    }
                }
            }
        }
        
        
    }
    
    func finishEdition(){
        
        var showInsagramAlert = false
        
        pagesView.forEach { page in
            if originalImage.isEmpty && page.page.profileType == .instagram {
                showInsagramAlert = true
                page.isCheked = false
            }
        }
        
        if showInsagramAlert {
            showAlert(.alerta, "Para publicar en Instagram requiere incluir foto o video")
        }
        
        
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
        
        var _pages: [CustSocialPageQuick] = []
        
        pagesView.forEach { page in
            
            if page.isCheked {
                
                if originalImage.isEmpty {
                    
                }
                
                _pages.append(page.page)
            }
        }
        
        if _pages.isEmpty {
            showError(.requiredField, "Seleccione pagina para publicar")
            return
        }
        
        addToDom(SocialManagerConfirmView(
            type: currentLoadedMedia,
            originalImage: originalImage,
            originalWidth: originalWidth,
            originalHeight: originalHeight,
            relativeHeight: relativeWidth,
            relativeWidth: relativeWidth,
            watermarks: _watermarks,
            pages: _pages,
            callback: {
                self.currentLoadedMedia = .text
                self.path = ""
                self.originalImage = ""
            }
        ))
        
    }
    
    func loadPosts(type: CustComponents.GetFromDate){
        
        loadingView(show: true)
        
        API.custAPIV1.getSocialPosts(getFrom: type, profile: nil) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
         
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.posts = data.posts
            
        }
    }
}

extension SocialManagerView {
    
    /// choseBase, choseSocialLive, socialLivePremium
    enum ActivateServiceViewMode {
        /// Promote both services and let cust chose
        case choseBase
        /// Chose socialLive plan
        case choseSocialLive
        /// Chose socialLivePremium plan
        case choseSocialPremium
        
        var efect: BillingEfect? {
            switch self {
            case .choseBase:
                return nil
            case .choseSocialLive:
                return .socialLive
            case .choseSocialPremium:
                return .socialLivePremium
            }
        }
        
    }
    
    enum CurrentView {
        case editor
        case posts
    }
    
}

