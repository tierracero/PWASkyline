//
//  Tools+WebPage+LogosView.swift
//
//
//  Created by Victor Cantu on 2/21/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage {
    
    class LogosView: Div {

        @State var darkLogo: String

        @State var darkTransLogo: String

        @State var lightLogo: String

        @State var lightTransLogo: String

        @State var iconLogo: String

        @State var darkLogos: [CustWebFiles]

        @State var darkTransLogos: [CustWebFiles]

        @State var lightLogos: [CustWebFiles]

        @State var lightTransLogos: [CustWebFiles]

        @State var iconLogos: [CustWebFiles]

       init(
            darkLogo: String?,
            darkTransLogo: String?,
            lightLogo: String?,
            lightTransLogo: String?,
            iconLogo: String?,
            darkLogos: [CustWebFiles],
            darkTransLogos: [CustWebFiles],
            lightLogos: [CustWebFiles],
            lightTransLogos: [CustWebFiles],
            iconLogos: [CustWebFiles]
        ) {
            self.darkLogo = darkLogo ?? ""
            self.darkTransLogo = darkTransLogo ?? ""
            self.lightLogo = lightLogo ?? ""
            self.lightTransLogo = lightTransLogo ?? ""
            self.iconLogo = iconLogo ?? ""
            self.darkLogos = darkLogos
            self.darkTransLogos = darkTransLogos
            self.lightLogos = lightLogos
            self.lightTransLogos = lightTransLogos
            self.iconLogos = iconLogos
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }

        lazy var fileInputDark = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)

        lazy var fileInputDarkTrans = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)

        lazy var fileInputLight = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)

        lazy var fileInputLightTrans = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)

        lazy var fileInputIcon = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)

        lazy var fileContainerDark = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)

        lazy var fileContainerDarkTrans = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
            
        lazy var fileContainerLight = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)

        lazy var fileContainerLightTrans = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
            
        lazy var fileContainerIcon = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
            

        /// [ viewId : ImageWebContainer]
        var imageDarkContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageDarkTransContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageLightContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageLightTransContainer: [UUID:ImageWebView] = [:]

        /// [ viewId : ImageWebContainer]
        var imageIconContainer: [UUID:ImageWebView] = [:]
        
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

                    /* MARK: Image Dark */
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
                                    self.renderInputFileDark()
                                }
                            
                            H2("Icono Oscuro 512x256")
                                .color(.white)
                            
                            self.fileInputDark
                            
                        }
                        Div().clear(.both).height(3.px)
                        self.fileContainerDark
                        Div().clear(.both).height(7.px)
                    }
                    
                    /* MARK: Image Light */
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
                                    self.renderInputFileLight()
                                }
                            
                            H2("Icono Oscuro 512x256")
                                .color(.white)
                            
                            self.fileInputLight
                            
                        }
                        Div().clear(.both).height(3.px)
                        self.fileContainerLight
                        Div().clear(.both).height(7.px)
                    }
                    
                    /* MARK: Image Icon */
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
                                    self.renderInputFileIcon()
                                }
                            
                            H2("Icono Oscuro 512x256")
                                .color(.white)
                            
                            self.fileInputIcon
                            
                        }
                        Div().clear(.both).height(3.px)
                        self.fileContainerIcon
                        Div().clear(.both).height(7.px)
                    }
                    
                    
                }
                .custom("height", "calc(100% - 35px)")
                .width(50.percent)
                .float(.left)

                Div{

                    /* MARK: Image Dark Trans */
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
                                    self.renderInputFileDarkTrans()
                                }
                            
                            H2("Icono Oscuro Transparente 512x256")
                                .color(.white)
                            
                            self.fileInputDarkTrans
                            
                        }
                        Div().clear(.both).height(3.px)
                        self.fileContainerDarkTrans
                        Div().clear(.both).height(7.px)
                    }
                    
                    /* MARK: Image Light Trans */
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
                                    self.renderInputFileLightTrans()
                                }
                            
                            H2("Icono Light 512x256")
                                .color(.white)
                            
                            self.fileInputLightTrans
                            
                        }
                        Div().clear(.both).height(3.px)
                        self.fileContainerLightTrans
                        Div().clear(.both).height(7.px)
                    }
                    
                }
                .custom("height", "calc(100% - 35px)")
                .width(50.percent)
                .float(.left)

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

        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            darkLogos.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .logoIndexBlack,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$darkLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.darkLogo = selectedAvatar
                    self.imageDarkContainer[viewId]?.image = selectedAvatar
                    self.imageDarkContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageDarkContainer[viewId]?.remove()
                    self.imageDarkContainer.removeValue(forKey: viewId)
                }
                
                self.imageDarkContainer[imageView.viewId] = imageView
                
                fileContainerDark.appendChild(imageView)
                
            }    
    
            darkTransLogos.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .logoIndexBlackTrans,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$darkTransLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.darkTransLogo = selectedAvatar
                    self.imageDarkTransContainer[viewId]?.image = selectedAvatar
                    self.imageDarkTransContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageDarkTransContainer[viewId]?.remove()
                    self.imageDarkTransContainer.removeValue(forKey: viewId)
                }
                
                self.imageDarkTransContainer[imageView.viewId] = imageView
                
                fileContainerDarkTrans.appendChild(imageView)
                
            }    
    
            lightLogos.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .logoIndexWhite,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$lightLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.lightLogo = selectedAvatar
                    self.imageLightContainer[viewId]?.image = selectedAvatar
                    self.imageLightContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageLightContainer[viewId]?.remove()
                    self.imageLightContainer.removeValue(forKey: viewId)
                }
                
                self.imageLightContainer[imageView.viewId] = imageView
                
                fileContainerLight.appendChild(imageView)
                
            }    
    
            lightTransLogos.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .logoIndexWhiteTrans,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$lightTransLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.lightTransLogo = selectedAvatar
                    self.imageLightTransContainer[viewId]?.image = selectedAvatar
                    self.imageLightTransContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageLightTransContainer[viewId]?.remove()
                    self.imageLightTransContainer.removeValue(forKey: viewId)
                }
                
                self.imageLightTransContainer[imageView.viewId] = imageView
                
                fileContainerLightTrans.appendChild(imageView)
                
            }    
    
            iconLogos.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .logoIndexIcon,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$iconLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.iconLogo = selectedAvatar
                    self.imageIconContainer[viewId]?.image = selectedAvatar
                    self.imageIconContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageIconContainer[viewId]?.remove()
                    self.imageIconContainer.removeValue(forKey: viewId)
                }
                
                self.imageIconContainer[imageView.viewId] = imageView
                
                fileContainerIcon.appendChild(imageView)
                
            }    
    
        }
    

        func renderInputFileDark() {
            
            fileInputDark = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputDark.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .logoIndexBlack,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$darkLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.darkLogo = selectedAvatar
                    self.imageDarkContainer[viewId]?.image = selectedAvatar
                    self.imageDarkContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageDarkContainer[viewId]?.remove()
                    self.imageDarkContainer.removeValue(forKey: viewId)
                }
                
                self.imageDarkContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.logoIndexBlack),
                    imageView: imageView,
                    imageContainer: self.fileContainerDark
                )
                
            }
            
            fileInputDark.click()
            
        }
        
        func renderInputFileDarkTrans() {
            
            fileInputDarkTrans = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputDarkTrans.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .logoIndexBlackTrans,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$darkTransLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   // MARK: Logo can not be etited
                } imAvatar: { viewId, selectedAvatar in
                    self.darkTransLogo = selectedAvatar
                    self.imageDarkTransContainer[viewId]?.image = selectedAvatar
                    self.imageDarkTransContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageDarkTransContainer[viewId]?.remove()
                    self.imageDarkTransContainer.removeValue(forKey: viewId)
                }
                
                self.imageDarkTransContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.logoIndexBlackTrans),
                    imageView: imageView,
                    imageContainer: self.fileContainerDarkTrans
                )
                
            }
            
            fileInputDarkTrans.click()
            
        }
        
        func renderInputFileLight() {
            
            fileInputLight = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputLight.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .logoIndexWhite,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$lightLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.lightLogo = selectedAvatar
                    self.imageLightContainer[viewId]?.image = selectedAvatar
                    self.imageLightContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageLightContainer[viewId]?.remove()
                    self.imageLightContainer.removeValue(forKey: viewId)
                }
                
                self.imageLightContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.logoIndexWhite),
                    imageView: imageView,
                    imageContainer: self.fileContainerLight
                )
                
            }
            
            fileInputLight.click()
            
        }
        
        func renderInputFileLightTrans() {
            
            fileInputLightTrans = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputLightTrans.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .logoIndexWhiteTrans,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$lightTransLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.lightTransLogo = selectedAvatar
                    self.imageLightTransContainer[viewId]?.image = selectedAvatar
                    self.imageLightTransContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageLightTransContainer[viewId]?.remove()
                    self.imageLightTransContainer.removeValue(forKey: viewId)
                }
                
                self.imageLightTransContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.logoIndexWhiteTrans),
                    imageView: imageView,
                    imageContainer: self.fileContainerLightTrans
                )
                
            }
            
            fileInputLightTrans.click()
            
        }
        
        func renderInputFileIcon() {
            
            fileInputIcon = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputIcon.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .logoIndexIcon,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$iconLogo
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                   
                } imAvatar: { viewId, selectedAvatar in
                    self.iconLogo = selectedAvatar
                    self.imageIconContainer[viewId]?.image = selectedAvatar
                    self.imageIconContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageIconContainer[viewId]?.remove()
                    self.imageIconContainer.removeValue(forKey: viewId)
                }
                
                self.imageIconContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.logoIndexIcon),
                    imageView: imageView,
                    imageContainer: self.fileContainerIcon
                )
                
            }
            
            fileInputIcon.click()
            
        }
        
        


    }



}