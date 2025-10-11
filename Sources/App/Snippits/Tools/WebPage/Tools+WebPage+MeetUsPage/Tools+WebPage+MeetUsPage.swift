//
//  Tools+WebPage+MeetUsPage.swift
//
//
//  Created by Victor Cantu on 2/21/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage {
    
    class MeetUsPage: Div {
        
        override class var name: String { "div" }
        
        @State var metaTitle: String
        
        @State var metaDescription: String
        
        @State var title: String
        
        @State var bisName: String
        
        @State var slogan: String
        
        @State var mantra: String
        
        @State var descr: String
        
        @State var mainText: String
        
        @State var subText: String
        
        @State var history: String
        
        @State var vision: String
        
        @State var imgOne: String
        
        @State var imgTwo: String
        
        @State var imgThree: String
        
        public let structure: WebConfigMeetUs
        
        @State var diplomas: [CustWebContent]

        @State var profiles: [CustWebContent]

        /// serviceImgOne
        @State var imageOne: [CustWebFilesQuick]
        
        /// serviceImgTwo
        @State var imageTwo: [CustWebFilesQuick]
        
        /// serviceImgThree
        @State var imageThree: [CustWebFilesQuick]
        
        public init(
            data: WebMeetUs,
            structure: WebConfigMeetUs,
            diplomas: [CustWebContent],
            profiles: [CustWebContent],
            imageOne: [CustWebFilesQuick],
            imageTwo: [CustWebFilesQuick],
            imageThree: [CustWebFilesQuick]
        ) {
            self.metaTitle = data.metaTitle
            self.metaDescription = data.metaTitle
            self.title = data.metaTitle
            self.bisName = data.bisName
            self.slogan = data.slogan
            self.mantra = data.mantra
            self.descr = data.description
            self.mainText = data.mainText
            self.subText = data.subText
            self.history = data.history
            self.vision = data.vision
            self.imgOne = data.imgOne
            self.imgTwo = data.imgTwo
            self.imgThree = data.imgThree
            self.structure = structure
            self.diplomas = diplomas
            self.profiles = profiles
            self.imageOne = imageOne
            self.imageTwo = imageTwo
            self.imageThree = imageThree
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var diplomaRowsGrid = Div()
            .custom("height", "calc(100% - 37px)")
            .overflow(.auto)
        
        /// [CustWebContent.Id : DiplomaRow ]
        var diplomaRows: [UUID : DiplomaRow] = [:]

        lazy var profileRowsGrid = Div()
            .custom("height", "calc(100% - 37px)")
            .overflow(.auto)
        
        /// [CustWebContent.Id : ProfileRow ]
        var profileRows: [UUID : ProfileRow] = [:]
        
        lazy var metaTitleTextArea = TextArea(self.$metaTitle)
            .custom("width","calc(100% - 18px)")
            .placeholder("Meta texto")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var metaDescriptionTextArea = TextArea(self.$metaDescription)
            .custom("width","calc(100% - 18px)")
            .placeholder("Meta descripción")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var titleTextArea = TextArea(self.$title)
            .custom("width","calc(100% - 18px)")
            .placeholder("Saludo cuarto")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var bisNameField = InputText(self.$bisName)
            .custom("width","calc(100% - 18px)")
            .placeholder("Saludo cuarto")
            .class(.textFiledBlackDark)
            .height(35.px)
        
        lazy var sloganTextArea = TextArea(self.$slogan)
            .custom("width","calc(100% - 18px)")
            .placeholder("Saludo cuarto")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var mantraTextArea = TextArea(self.$mantra)
            .custom("width","calc(100% - 18px)")
            .placeholder("Saludo cuarto")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var descrTextArea = TextArea(self.$descr)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto principal")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var mainTextTextArea = TextArea(self.$mainText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var subTextTextArea = TextArea(self.$subText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var historyTextArea = TextArea(self.$history)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var visionTextArea = TextArea(self.$vision)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var fileInputOne = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
           
        lazy var fileInputTwo = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputThree = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileContainerOne = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerTwo = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerThree = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        /// [ viewId : ImageWebContainer]
        var imageOneContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageTwoContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageThreeContainer: [UUID:ImageWebView] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /* Header */
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    Img()
                        .src("/skyline/media/panel_service.png")
                        .marginLeft(7.px)
                        .height(35.px)
                        .float(.left)
                    
                    H2("Configuracion Pagina Conocenos")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Div{
                    
                    Div{
                        Div{
                        
                            // MARK: Meta Title
                            Div{
                                Div("Meta Titulo")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Lo que va aparecer en la pestaña")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.metaTitleTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Meta Description
                            Div{
                                Div("Meta Descripción")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Descripcion corta oculta")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.metaDescriptionTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Title
                            Div{
                                Div("Texto del titulo")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div(self.$title.map{ "Texto del titulo de la pagina \($0.count.toString)/\(self.structure.mainText.toString)" })
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.titleTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Description
                            Div{
                                Div("Texto Descriptivo")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div(self.$descr.map{ "Texto descriptivo \($0.count.toString)/\(self.structure.description.toString)" })
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.descrTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Main Text
                            Div{
                                Div("Texto Princial")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div(self.$subText.map{ "Texto principal \($0.count.toString)/\(self.structure.subText.toString)" })
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.mainTextTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Sub Text
                            Div{
                                Div("Texto Secundario")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div(self.$subText.map{ "Texto secundario \($0.count.toString)/\(self.structure.subText.toString)" })
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.subTextTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Buisness Name
                            Div{
                                Div("Nombre de la Empresa")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Nombre comercial de la empresa")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.bisNameField
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Slogan
                            Div{
                                Div("Slogan")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Frace comercial")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.sloganTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Mantra
                            Div{
                                Div("Mantra")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("La razon de ser de la empresa")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.mantraTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: History
                            Div{
                                Div("Historia")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Historia de la empresa")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.historyTextArea
                            Div().clear(.both).height(7.px)
                            
                            // MARK: Vision
                            Div{
                                Div("Vision")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div("Vision de la empresa")
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.visionTextArea
                            Div().clear(.both).height(7.px)
                            
                        }
                        .custom("height", "calc(100% - 14px)")
                        .margin(all: 7.px)
                        .overflow(.auto)
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            
                            /* MARK: DIPLOMAS */
                            Div{
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick {
                                            
                                            let view = DiplomaView(
                                                item: nil,
                                                files: [],
                                                notes: []
                                            ) { itemId, name, description in
                                                
                                                guard let view = self.diplomaRows[itemId] else {
                                                    return
                                                }
                                                
                                                view.name = name
                                                
                                                view.descr = description
                                                
                                            } updateAvatar: { itemId, avatar in
                                                
                                                guard let view = self.diplomaRows[itemId] else {
                                                    return
                                                }
                                                
                                                view.avatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
                                                
                                            } addItem: { item in
                                                self.addDiplomaRow(item)
                                            } deleteItem: { itemId in
                                                
                                                self.diplomaRows[itemId]?.remove()
                                                
                                                self.diplomaRows.removeValue(forKey: itemId)
                                                
                                            }
                                            
                                            addToDom(view)
                                            
                                        }
                                    
                                    H2("Lista de diplomas")
                                        .color(.white)
                                }
                                
                                Div().clear(.both)
                                
                                self.diplomaRowsGrid
                            }
                            .height(350.px)

                            /* MARK: PROFILES */
                            Div{
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick {
                                            
                                            let view = ProfileView(
                                                item: nil,
                                                files: [],
                                                notes: []
                                            ) { itemId, name, description in
                                                
                                                guard let view = self.profileRows[itemId] else {
                                                    return
                                                }
                                                
                                                view.name = name
                                                
                                                view.descr = description
                                                
                                            } updateAvatar: { itemId, avatar in
                                                
                                                guard let view = self.profileRows[itemId] else {
                                                    return
                                                }
                                                
                                                view.avatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
                                                
                                            } addItem: { item in
                                                self.addProfileRow(item)
                                            } deleteItem: { itemId in
                                                
                                                self.profileRows[itemId]?.remove()
                                                
                                                self.profileRows.removeValue(forKey: itemId)
                                                
                                            }
                                            
                                            addToDom(view)
                                            
                                        }
                                    
                                    H2("Lista de perfiles")
                                        .color(.white)
                                }
                                
                                Div().clear(.both)
                                
                                self.diplomaRowsGrid
                            }
                            .height(350.px)
                            
                            /* MARK: Carucell One */
                            Div{
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick {
                                            self.renderInputFileOne()
                                        }
                                    
                                    H2("Imagen 1 \(self.structure.imgOneWidth)x\(self.structure.imgTwoHeight)")
                                        .color(.white)
                                    
                                    self.fileInputOne
                                    
                                }
                                Div().clear(.both).height(3.px)
                                self.fileContainerOne
                                Div().clear(.both).height(7.px)
                            }
                            .hidden(!self.structure.imgOne)
                            
                            /* MARK: Carucell Two */
                            Div{
                                
                                Div{
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick {
                                            self.renderInputFileTwo()
                                        }
                                    
                                    H2("Imagen 2 \(self.structure.imgTwoWidth)x\(self.structure.imgTwoHeight)")
                                        .color(.white)
                                    
                                    self.fileInputTwo
                                    
                                }
                                Div().clear(.both).height(3.px)
                                self.fileContainerTwo
                                Div().clear(.both).height(7.px)
                                
                            }
                            .hidden(!self.structure.imgTwo)
                            
                            /* MARK: Carucell Three*/
                            Div{
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .padding(all: 3.px)
                                        .paddingRight(0.px)
                                        .cursor(.pointer)
                                        .float(.right)
                                        .height(22.px)
                                        .onClick {
                                            self.renderInputFileThree()
                                        }
                                    
                                    H2("Imagen 3 \(self.structure.imgThreeWidth)x\(self.structure.imgThreeHeight)")
                                        .color(.white)
                                    
                                    self.fileInputThree
                                    
                                }
                                Div().clear(.both).height(3.px)
                                self.fileContainerThree
                            }
                            .hidden(!self.structure.imgThree)
                            
                        }
                        .custom("height", "calc(100% - 110px)")
                        .overflow(.auto)
                        
                        Div().clear(.both).height(3.px)
                        
                        Div{
                            Div("Guardar Cambios")
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    self.saveChanges()
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
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(5% - 14px)")
            .custom("top", "calc(5% - 14px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(90.percent)
            .width(90.percent)
            
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
            
            profiles.forEach { item in
                addProfileRow(item)
            }

            imageOne.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .meetUsImgOne,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgOne
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .one,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgOne = selectedAvatar
                    self.imageOneContainer[viewId]?.image = selectedAvatar
                    self.imageOneContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageOneContainer[viewId]?.remove()
                    self.imageOneContainer.removeValue(forKey: viewId)
                }
                
                self.imageOneContainer[imageView.viewId] = imageView
                
                fileContainerOne.appendChild(imageView)
                
            }
            
            imageTwo.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .meetUsImgTwo,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgTwo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .two,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTwo = selectedAvatar
                    self.imageTwoContainer[viewId]?.image = selectedAvatar
                    self.imageTwoContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageTwoContainer[viewId]?.remove()
                    self.imageTwoContainer.removeValue(forKey: viewId)
                }
                
                self.imageTwoContainer[imageView.viewId] = imageView
                
                fileContainerTwo.appendChild(imageView)
                
            }
            
            imageThree.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .meetUsImgThree,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgThree
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .three,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgThree = selectedAvatar
                    self.imageThreeContainer[viewId]?.image = selectedAvatar
                    self.imageThreeContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageThreeContainer[viewId]?.remove()
                    self.imageThreeContainer.removeValue(forKey: viewId)
                }
                
                self.imageThreeContainer[imageView.viewId] = imageView
                
                fileContainerThree.appendChild(imageView)
                
            }
            
        }
        
        func saveChanges() {
            
            if metaTitle.isEmpty {
                showError(.campoRequerido, .requierdValid("meta titulo"))
            }
            
            if metaDescription.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
            }
            
            if title.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                titleTextArea.focus()
                return
            }
            
            if bisName.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                titleTextArea.focus()
                return
            }
            
            if slogan.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                titleTextArea.focus()
                return
            }
            
            if mantra.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                titleTextArea.focus()
                return
            }
            
            if descr.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                descrTextArea.focus()
                return
            }
            
            if mainText.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                mainTextTextArea.focus()
                return
            }
            
            if subText.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                subTextTextArea.focus()
                return
            }
            
            if history.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                historyTextArea.focus()
                return
            }
            
            if vision.isEmpty {
                showError(.campoRequerido, .requierdValid("meta descripción"))
                visionTextArea.focus()
                return
            }
            
            loadingView(show: true)
            
            API.themeV1.saveWebMeetUs(
                configLanguage: .Spanish,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                bisName: bisName,
                slogan: slogan,
                mantra: mantra,
                description: descr,
                mainText: mainText,
                subText: subText,
                history: history,
                vision: vision
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
                
            }
        }
        
        func renderInputFileOne() {
            
            fileInputOne = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputOne.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .meetUsImgOne,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgOne
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .one,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgOne = selectedAvatar
                    self.imageOneContainer[viewId]?.image = selectedAvatar
                    self.imageOneContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageOneContainer[viewId]?.remove()
                    self.imageOneContainer.removeValue(forKey: viewId)
                }
                
                self.imageOneContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.meetUsImgOne),
                    imageView: imageView,
                    imageContainer: self.fileContainerOne
                )
                
            }
            
            fileInputOne.click()
            
        }
        
        func renderInputFileTwo() {
            
            fileInputTwo = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputTwo.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .meetUsImgTwo,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgTwo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .two,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTwo = selectedAvatar
                    self.imageTwoContainer[viewId]?.image = selectedAvatar
                    self.imageTwoContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageTwoContainer[viewId]?.remove()
                    self.imageTwoContainer.removeValue(forKey: viewId)
                }
                
                self.imageTwoContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.meetUsImgTwo),
                    imageView: imageView,
                    imageContainer: self.fileContainerTwo
                )
                
            }
            
            fileInputTwo.click()
            
        }
        
        func renderInputFileThree() {
            
            fileInputThree = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputThree.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .meetUsImgThree,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgThree
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .three,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgThree = selectedAvatar
                    self.imageThreeContainer[viewId]?.image = selectedAvatar
                    self.imageThreeContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageThreeContainer[viewId]?.remove()
                    self.imageThreeContainer.removeValue(forKey: viewId)
                }
                
                self.imageThreeContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.meetUsImgThree),
                    imageView: imageView,
                    imageContainer: self.fileContainerThree
                )
                
            }
            
            fileInputThree.click()
            
        }
        
        func addProfileRow(_ item: CustWebContent) {
            
            let view = ProfileRow(item: item) { view in
                loadingView(show: true)
                API.themeV1.getViewProfile(
                    id: item.id
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
                    
                    let view = ProfileView(
                        item: payload.profile,
                        files: payload.files,
                        notes: payload.notes
                    ) { profileId, name, description in
                        
                        view.name = name
                        
                        view.descr = description
                        
                    } updateAvatar: { serviceId, avatar in
                        
                        view.avatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
                        
                    } addItem: { service in
                        // MARK: un used since service exist
                    } deleteItem: { serviceId in
                        
                        self.profileRows[serviceId]?.remove()
                        
                        self.profileRows.removeValue(forKey: serviceId)
                        
                    }
                    
                    addToDom(view)
                    
                }
            }
            
            profileRows[item.id] =  view
            
            profileRowsGrid.appendChild(view)
            
        }
        
        func addDiplomaRow(_ item: CustWebContent) {
            
            let view = DiplomaRow(item: item) { view in
                loadingView(show: true)
                API.themeV1.getViewDiploma(
                    id: item.id
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
                    
                    let view = DiplomaView(
                        item: payload.diploma,
                        files: payload.files,
                        notes: payload.notes
                    ) { itemId, name, description in
                        
                        view.name = name
                        
                        view.descr = description
                        
                    } updateAvatar: { itemId, avatar in
                        
                        view.avatar.load("https://\(custCatchUrl)/contenido/thump_\(avatar)")
                        
                    } addItem: { item in
                        // MARK: un used since service exist
                    } deleteItem: { itemId in
                        
                        self.diplomaRows[itemId]?.remove()
                        
                        self.diplomaRows.removeValue(forKey: itemId)
                        
                    }
                    
                    addToDom(view)
                    
                }
            }
            
            diplomaRows[item.id] =  view
            
            diplomaRowsGrid.appendChild(view)
            
        }
        
        func startEditImage(
            _ type: EditImageType,
            _ viewid: UUID,
            _ mediaid: UUID?,
            _ path: String,
            _ originalImage: String,
            _ originalWidth: Int,
            _ originalHeight: Int,
            _ isAvatar: Bool
        ){
            
            var subId: CustWebFilesObjectType? = nil
            
            var wapWidthPre: Int? = nil
            
            var wapHeightPre: Int? = nil
            
            switch type {
            case .one:
                subId = .contactImgOne
                wapWidthPre = structure.imgOneWidth
                wapHeightPre = structure.imgOneHeight
            case .two:
                subId = .contactImgTwo
                wapWidthPre = structure.imgTwoWidth
                wapHeightPre = structure.imgTwoHeight
            case .three:
                subId = .contactImgThree
                wapWidthPre = structure.imgThreeWidth
                wapHeightPre = structure.imgThreeHeight
            }
            
            let editor = ImageEditor(
                eventid: viewid,
                to: .webContent,
                relid: nil,
                subId: subId,
                isAvatar: isAvatar,
                mediaid: mediaid,
                path: path,
                originalImage: originalImage,
                originalWidth: originalWidth,
                originalHeight: originalHeight,
                wapWidthPre: wapWidthPre,
                wapHeightPre: wapHeightPre
            ) {
                
                switch type {
                case .one:
                    if let view = self.imageOneContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .two:
                    if let view = self.imageTwoContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .three:
                    if let view = self.imageThreeContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                }
                
                
            }
            
            addToDom(editor)
        }
        
        enum EditImageType {
            case one
            case two
            case three
        }
        
    }
}

