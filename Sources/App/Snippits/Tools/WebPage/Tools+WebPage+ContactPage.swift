//
//  Tools+WebPage+ContactPage.swift
//
//
//  Created by Victor Cantu on 2/21/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage {
    
    class ContactPage: Div {
        
        override class var name: String { "div" }
        
        @State var metaTitle: String
        
        @State var metaDescription: String
        
        @State var title: String
        
        @State var descr: String
        
        @State var mainText: String
        
        @State var subText: String
        
        @State var imgOne: String
        
        @State var imgTwo: String
        
        @State var imgThree: String
        
        public let structure: WebConfigContact
        
        /// contactImgOne
        @State var imageOne: [CustWebFilesQuick]
        
        /// contactImgTwo
        @State var imageTwo: [CustWebFilesQuick]
        
        /// contactImgThree
        @State var imageThree: [CustWebFilesQuick]
        
        public init(
            data: WebContact,
            structure: WebConfigContact,
            imageOne: [CustWebFilesQuick],
            imageTwo: [CustWebFilesQuick],
            imageThree: [CustWebFilesQuick]
        ) {
            self.metaTitle = data.metaTitle
            self.metaDescription = data.metaDescription
            self.title = data.title
            self.descr = data.description
            self.mainText = data.mainText
            self.subText = data.subText
            self.imgOne = data.imgOne
            self.imgTwo = data.imgTwo
            self.imgThree = data.imgThree
            self.structure = structure
            self.imageOne = imageOne
            self.imageTwo = imageTwo
            self.imageThree = imageThree
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
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
        
        lazy var descrTextArea = TextArea(self.$descr)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto descriptivo")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var mainTextTextArea = TextArea(self.$mainText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto principal")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var subTextTextArea = TextArea(self.$subText)
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
                    
                    H2("Configuracion Pagina Contacto")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Div{
                    
                    Div{
                        Div{
                            
                            
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
                            
                            Div{
                                Div("Texto Principal")
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                Div(self.$mainText.map{ "Texto principal \($0.count.toString)/\(self.structure.mainText.toString)" })
                                    .fontSize(14.px)
                                    .color(.gray)
                            }
                            self.mainTextTextArea
                            Div().clear(.both).height(7.px)
                            
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
                            
                            // MARK: Carucell Three
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
            
            imageOne.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .contactImgOne,
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
                    relation: .contactImgTwo,
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
                    relation: .contactImgThree,
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
                showError(.requiredField, .requierdValid("meta titulo"))
            }
            
            if metaDescription.isEmpty {
                showError(.requiredField, .requierdValid("meta descripción"))
            }
            
            if title.isEmpty {
                showError(.requiredField, .requierdValid("meta descripción"))
                titleTextArea.focus()
                return
            }
            
            if descr.isEmpty {
                showError(.requiredField, .requierdValid("meta descripción"))
                descrTextArea.focus()
                return
            }
            
            if mainText.isEmpty {
                showError(.requiredField, .requierdValid("meta descripción"))
                mainTextTextArea.focus()
                return
            }
            
            if subText.isEmpty {
                showError(.requiredField, .requierdValid("meta descripción"))
                subTextTextArea.focus()
                return
            }
            
            loadingView(show: true)
            
            API.themeV1.saveWebContact(
                configLanguage: .Spanish,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                description: descr,
                mainText: mainText,
                subText: subText
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
                    relation: .contactImgOne,
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
                    to: .webContent(.contactImgOne),
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
                    relation: .contactImgTwo,
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
                    to: .webContent(.contactImgTwo),
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
                    relation: .contactImgThree,
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
                    to: .webContent(.contactImgThree),
                    imageView: imageView,
                    imageContainer: self.fileContainerThree
                )
                
            }
            
            fileInputThree.click()
            
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
        
    }
}

