//
//  Tools+WebPage+IndexPage.swift
//  
//
//  Created by Victor Cantu on 2/21/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage {
    
    class IndexPage: Div {
        
        override class var name: String { "div" }
        
        @State var metaTitle: String
        
        @State var metaDescription: String
        
        @State var title: String
        
        @State var descr: String
        
        @State var mainText: String
        
        @State var subText: String
        
        // MARK: NEW
        @State var carouselOneText: String
        
        @State var carouselOneSecondaryText: String
        
        @State var carouselOneBtnIsActive: Bool
        
        @State var carouselOneBtnText: String
        
        @State var carouselOneBtnLink: String
        
        @State var carouselTwoText: String
        
        @State var carouselTwoSecondaryText: String
        
        @State var carouselTwoBtnIsActive: Bool
        
        @State var carouselTwoBtnText: String
        
        @State var carouselTwoBtnLink: String
        
        @State var carouselThreeText: String
        
        @State var carouselThreeSecondaryText: String
        
        @State var carouselThreeBtnIsActive: Bool
        
        @State var carouselThreeBtnText: String
        
        @State var carouselThreeBtnLink: String
        
        // MARK: NEW [END]
        
        @State var imgOne: String
        
        @State var imgTwo: String
        
        @State var imgThree: String
        
        @State var imgFour: String
        
        @State var imgFive: String
        
        @State var imgSix: String
        
        @State var imgSeven: String
        
        @State var imgEight: String
        
        @State var imgNine: String
        
        @State var imgTen: String
        
        @State var imgEleven: String
        
        @State var imgTwelve: String
        
        @State var carouselOneForeground: String
        
        @State var carouselOneBackground: String
        
        @State var carouselTwoForeground: String
        
        @State var carouselTwoBackground: String
        
        @State var carouselThreeForeground: String
        
        @State var carouselThreeBackground: String
        
        let structure: WebConfigIndex
        
        /// indexImgOne
        @State var imagesOne: [CustWebFilesQuick]
        
        /// indexImgTwo
        @State var imagesTwo: [CustWebFilesQuick]
        
        /// indexImgThree
        @State var imagesThree: [CustWebFilesQuick]
        
        /// indexImgFoure
        @State var imagesFour: [CustWebFilesQuick]
        
        /// indexImgFive
        @State var imagesFive: [CustWebFilesQuick]
        
        /// indexImgSix
        @State var imagesSix: [CustWebFilesQuick]
        
        /// indexImgSeven
        @State var imagesSeven: [CustWebFilesQuick]
        
        /// indexImgEight
        @State var imagesEight: [CustWebFilesQuick]
        
        /// indexImgNine
        @State var imagesNine: [CustWebFilesQuick]
        
        /// indexImgTen
        @State var imagesTen: [CustWebFilesQuick]
        
        /// indexImgEleven
        @State var imagesEleven: [CustWebFilesQuick]
        
        /// indexImgTwelve
        @State var imagesTwelve: [CustWebFilesQuick]
        
        /// indexCarouselOneForeground
        @State var carucelOneForground: [CustWebFilesQuick]
        
        /// indexCarouselOneBackground
        @State var carucelOneBackground: [CustWebFilesQuick]
        
        /// indexCarouselTwoForeground
        @State var carucelTwoForground: [CustWebFilesQuick]
        
        /// indexCarouselTwoBackground
        @State var carucelTwoBackground: [CustWebFilesQuick]
        
        /// indexCarouselThreeForeground
        @State var carucelThreeForground: [CustWebFilesQuick]
        
        /// indexCarouselThreeBackground
        @State var carucelThreeBackground: [CustWebFilesQuick]
        
        public init(
            data: WebIndex,
            structure: WebConfigIndex,
            imagesOne: [CustWebFilesQuick],
            imagesTwo: [CustWebFilesQuick],
            imagesThree: [CustWebFilesQuick],
            imagesFour: [CustWebFilesQuick],
            imagesFive: [CustWebFilesQuick],
            imagesSix: [CustWebFilesQuick],
            imagesSeven: [CustWebFilesQuick],
            imagesEight: [CustWebFilesQuick],
            imagesNine: [CustWebFilesQuick],
            imagesTen: [CustWebFilesQuick],
            imagesEleven: [CustWebFilesQuick],
            imagesTwelve: [CustWebFilesQuick],
            carucelOneForground: [CustWebFilesQuick],
            carucelOneBackground: [CustWebFilesQuick],
            carucelTwoForground: [CustWebFilesQuick],
            carucelTwoBackground: [CustWebFilesQuick],
            carucelThreeForground: [CustWebFilesQuick],
            carucelThreeBackground: [CustWebFilesQuick]
        ) {
            self.metaTitle = data.metaTitle
            self.metaDescription = data.metaDescription
            self.title = data.title
            self.descr = data.description
            self.mainText = data.mainText
            self.subText = data.subText
            self.carouselOneText = data.carouselOneText
            self.carouselOneSecondaryText = data.carouselOneSecondaryText
            self.carouselOneBtnIsActive = data.carouselOneBtnIsActive
            self.carouselOneBtnText = data.carouselOneBtnText
            self.carouselOneBtnLink = data.carouselOneBtnLink
            self.carouselTwoText = data.carouselTwoText
            self.carouselTwoSecondaryText = data.carouselTwoSecondaryText
            self.carouselTwoBtnIsActive = data.carouselTwoBtnIsActive
            self.carouselTwoBtnText = data.carouselTwoBtnText
            self.carouselTwoBtnLink = data.carouselTwoBtnLink
            self.carouselThreeText = data.carouselThreeText
            self.carouselThreeSecondaryText = data.carouselThreeSecondaryText
            self.carouselThreeBtnIsActive = data.carouselThreeBtnIsActive
            self.carouselThreeBtnText = data.carouselThreeBtnText
            self.carouselThreeBtnLink = data.carouselThreeBtnLink
            self.imgOne = data.imgOne
            self.imgTwo = data.imgTwo
            self.imgThree = data.imgThree
            self.imgFour = data.imgFour
            self.imgFive = data.imgFive
            self.imgSix = data.imgSix
            self.imgSeven = data.imgSeven
            self.imgEight = data.imgEight
            self.imgNine = data.imgNine
            self.imgTen = data.imgTen
            self.imgEleven = data.imgEleven
            self.imgTwelve = data.imgTwelve
            self.carouselOneForeground = data.carouselOneForeground
            self.carouselOneBackground = data.carouselOneBackground
            self.carouselTwoForeground = data.carouselTwoForeground
            self.carouselTwoBackground = data.carouselTwoBackground
            self.carouselThreeForeground = data.carouselThreeForeground
            self.carouselThreeBackground = data.carouselThreeBackground
            self.structure = structure
            self.imagesOne = imagesOne
            self.imagesTwo = imagesTwo
            self.imagesThree = imagesThree
            self.imagesFour = imagesFour
            self.imagesFive = imagesFive
            self.imagesSix = imagesSix
            self.imagesSeven = imagesSeven
            self.imagesEight = imagesEight
            self.imagesNine = imagesNine
            self.imagesTen = imagesTen
            self.imagesEleven = imagesEleven
            self.imagesTwelve = imagesTwelve
            self.carucelOneForground = carucelOneForground
            self.carucelOneBackground = carucelOneBackground
            self.carucelTwoForground = carucelTwoForground
            self.carucelTwoBackground = carucelTwoBackground
            self.carucelThreeForground = carucelThreeForground
            self.carucelThreeBackground = carucelThreeBackground
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
        
        // MARK: Carousel One
        
        lazy var carouselOneTextTextArea = TextArea(self.$carouselOneText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel uno texto principal")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselOneSecondaryTextTextArea = TextArea(self.$carouselOneSecondaryText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel uno texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselOneBtnIsActiveToggle = InputCheckbox().toggle(self.$carouselOneBtnIsActive)
        
        lazy var carouselOneBtnTextField = InputText(self.$carouselOneBtnText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Nombre del botton")
            .class(.textFiledBlackDarkMedium)
        
        lazy var carouselOneBtnLinkTextArea = TextArea(self.$carouselOneBtnLink)
            .custom("width","calc(100% - 18px)")
            .placeholder("Link de boton")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        // MARK: Carousel Two
        
        lazy var carouselTwoTextTextArea = TextArea(self.$carouselTwoText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel dos texto principal")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselTwoSecondaryTextTextArea = TextArea(self.$carouselTwoSecondaryText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel dos texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselTwoBtnIsActiveToggle = InputCheckbox().toggle(self.$carouselTwoBtnIsActive)
        
        lazy var carouselTwoBtnTextField = InputText(self.$carouselTwoBtnText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto de boton")
            .class(.textFiledBlackDarkMedium)
        
        lazy var carouselTwoBtnLinkTextArea = TextArea(self.$carouselTwoBtnLink)
            .custom("width","calc(100% - 18px)")
            .placeholder("Vinculo de boton")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        // MARK: Carousel Three
        
        lazy var carouselThreeTextTextArea = TextArea(self.$carouselThreeText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel tres texto principal")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselThreeSecondaryTextTextArea = TextArea(self.$carouselThreeSecondaryText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Carucel tres texto secundario")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        lazy var carouselThreeBtnIsActiveToggle = InputCheckbox().toggle(self.$carouselThreeBtnIsActive)
        
        lazy var carouselThreeBtnTextField = InputText(self.$carouselOneBtnText)
            .custom("width","calc(100% - 18px)")
            .placeholder("Texto de boton")
            .class(.textFiledBlackDarkMedium)
        
        lazy var carouselThreeBtnLinkTextArea = TextArea(self.$carouselThreeBtnLink)
            .custom("width","calc(100% - 18px)")
            .placeholder("Vunculo de boton")
            .class(.textFiledBlackDark)
            .padding(all: 7.px)
            .height(70.px)
        
        // MARK: File Input
        
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
        
        
        lazy var fileInputFour = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
           
        lazy var fileInputFive = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputSix = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputSeven = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
           
        lazy var fileInputEight = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputNine = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputTen = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
           
        lazy var fileInputEleven = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
        lazy var fileInputTwelve = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
            .multiple(false)
            .display(.none)
        
         lazy var fileInputCarouselBackgroundOne = InputFile()
             .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
             .multiple(false)
             .display(.none)
         
         lazy var fileInputCarouselForgroundOne = InputFile()
             .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
             .multiple(false)
             .display(.none)
        
         lazy var fileInputCarouselBackgroundTwo = InputFile()
             .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
             .multiple(false)
             .display(.none)
         
         lazy var fileInputCarouselForgroundTwo = InputFile()
             .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
             .multiple(false)
             .display(.none)
        
         lazy var fileInputCarouselBackgroundThree = InputFile()
             .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
             .multiple(false)
             .display(.none)
         
         lazy var fileInputCarouselForgroundThree = InputFile()
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
        
        lazy var fileContainerFour = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerFive = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerSix = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerSeven = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerEight = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerNine = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerTen = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerEleven = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerTwelve = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselOneBackground = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselOneForground = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselTwoBackground = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselTwoForground = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselThreeBackground = Div()
            .class(.roundDarkBlue)
            .paddingBottom(7.px)
            .paddingTop(7.px)
            .overflow(.auto)
            .height(150.px)
        
        lazy var fileContainerCarouselThreeForground = Div()
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
        
        /// [ viewId : ImageWebContainer]
        var imageFourContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageFiveContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageSixContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageSevenContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageEightContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageNineContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageTenContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageElevenContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageTwelveContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselOneBackgroundContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselOneForgroundContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselTwoBackgroundContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselTwoForgroundContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselThreeBackgroundContainer: [UUID:ImageWebView] = [:]
        
        /// [ viewId : ImageWebContainer]
        var imageCarouselThreeForgroundContainer: [UUID:ImageWebView] = [:]
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
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
                    
                    H2("Configuración Pagina Inicio")
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
                            Div{
                                
                                // MARK: Image One
                                Div {
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
                                        
                                        H2("Imagen 1 \(self.structure.imgOneWidth)x\(self.structure.imgOneHeight)")
                                            .color(.white)
                                        
                                        self.fileInputOne
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerOne
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgOne)
                                
                                // MARK: Image Two
                                Div {
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
                                
                                // MARK: Image Three
                                Div {
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
                                
                                // MARK: Image Four
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileFour()
                                            }
                                        
                                        H2("Imagen 4 \(self.structure.imgFourWidth)x\(self.structure.imgFourHeight)")
                                            .color(.white)
                                        
                                        self.fileInputFour
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerFour
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgFour)
                                
                                // MARK: Image Five
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileFive()
                                            }
                                        
                                        H2("Imagen 5 \(self.structure.imgFiveWidth)x\(self.structure.imgFiveHeight)")
                                            .color(.white)
                                        
                                        self.fileInputFive
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerFive
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgFive)
                                
                                // MARK: Image Six
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileSix()
                                            }
                                        
                                        H2("Imagen 6 \(self.structure.imgSixWidth)x\(self.structure.imgSixHeight)")
                                            .color(.white)
                                        
                                        self.fileInputSix
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerSix
                                }
                                .hidden(!self.structure.imgSix)
                                
                                // MARK: Image Seven
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileSeven()
                                            }
                                        
                                        H2("Imagen 7 \(self.structure.imgSevenWidth)x\(self.structure.imgSevenHeight)")
                                            .color(.white)
                                        
                                        self.fileInputSeven
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerSeven
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgSeven)
                                
                                // MARK: Image Eight
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileEight()
                                            }
                                        
                                        H2("Imagen 8 \(self.structure.imgEightWidth)x\(self.structure.imgEightHeight)")
                                            .color(.white)
                                        
                                        self.fileInputEight
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerEight
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgEight)
                                
                                // MARK: Image Nine
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileNine()
                                            }
                                        
                                        H2("Imagen 9 \(self.structure.imgNineWidth)x\(self.structure.imgNineHeight)")
                                            .color(.white)
                                        
                                        self.fileInputNine
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerNine
                                }
                                .hidden(!self.structure.imgNine)
                                
                                // MARK: Image Ten
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileTen()
                                            }
                                        
                                        H2("Imagen 10 \(self.structure.imgTenWidth)x\(self.structure.imgTenHeight)")
                                            .color(.white)
                                        
                                        self.fileInputTen
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerTen
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgTen)
                                
                                // MARK: Image Eleven
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileEleven()
                                            }
                                        
                                        H2("Imagen 11 \(self.structure.imgElevenWidth)x\(self.structure.imgElevenHeight)")
                                            .color(.white)
                                        
                                        self.fileInputEleven
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerEleven
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.imgEleven)
                                
                                // MARK: Image Twelve
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileTwelve()
                                            }
                                        
                                        H2("Imagen 12 \(self.structure.imgTwelveWidth)x\(self.structure.imgTwelveHeight)")
                                            .color(.white)
                                        
                                        self.fileInputTwelve
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerTwelve
                                }
                                .hidden(!self.structure.imgTwelve)
                                
                                // MARK: Carrusel Data One
                                
                                H2("Carucel Uno")
                                    .color(.white)
                                
                                Div(self.$carouselOneText.map{ "Carucel uno texto principal \($0.count)/\(self.structure.carouselOneText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselOneTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div(self.$carouselOneSecondaryText.map{ "Carucel uno texto secundario \($0.count)/\(self.structure.carouselOneSecondaryText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselOneSecondaryTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div{
                                    Div{
                                        
                                        self.carouselOneBtnIsActiveToggle
                                            .float(.right)
                                        
                                        Div("Botton de carucel uno")
                                            .fontSize(20.px)
                                            .color(.white)
                                        
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Div{
                                            Span("Nombre de Boton")
                                                .color(.white)
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                        Div{
                                            self.carouselOneBtnTextField
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div("Vincilo de botton")
                                        .fontSize(20.px)
                                        .color(.white)
                                    Div().clear(.both).height(3.px)
                                    self.carouselOneBtnLinkTextArea
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselOneBtnIsActive)
                                
                                // MARK: Carrusel Background One
                                
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselOneBackground()
                                            }
                                        
                                        H2("Carrusel Uno Principal \(self.structure.imgCarouselOneBackgroundWidth)x\(self.structure.imgCarouselOneBackgroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselBackgroundOne
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselOneBackground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselOneBackground)
                                
                                // MARK: Carrusel Forground One
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselOneForground()
                                            }
                                        
                                        H2("Carrusel Uno Secundaria \(self.structure.imgCarouselOneForegroundWidth)x\(self.structure.imgCarouselOneForegroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselForgroundOne
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselOneForground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselOneForeground)
                                
                                // MARK: Carrusel Data Two
                                
                                H2("Carucel Dos")
                                    .color(.white)
                                
                                Div(self.$carouselTwoText.map{ "Carucel dos texto principal \($0.count)/\(self.structure.carouselTwoText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselTwoTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div(self.$carouselTwoSecondaryText.map{ "Carucel dos texto secundario \($0.count)/\(self.structure.carouselTwoSecondaryText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselTwoSecondaryTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div{
                                    Div{
                                        
                                        self.carouselTwoBtnIsActiveToggle
                                            .float(.right)
                                        
                                        Div("Botton de carucel dos")
                                            .fontSize(20.px)
                                            .color(.white)
                                        
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Div{
                                            Span("Nombre de Boton")
                                                .color(.white)
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                        Div{
                                            self.carouselTwoBtnTextField
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div("Vincilo de botton")
                                        .fontSize(20.px)
                                        .color(.white)
                                    Div().clear(.both).height(3.px)
                                    self.carouselTwoBtnLinkTextArea
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselTwoBtnIsActive)
                                
                                // MARK: Carrusel Background Two
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselTwoBackground()
                                            }
                                        
                                        H2("Carrusel Dos Principal \(self.structure.imgCarouselTwoBackgroundWidth)x\(self.structure.imgCarouselTwoBackgroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselBackgroundTwo
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselTwoBackground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselTwoBackground)
                                
                                // MARK: Carrusel Forground Two
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselTwoForground()
                                            }
                                        
                                        H2("Carrusel Dos Secundaria \(self.structure.imgCarouselTwoForegroundWidth)x\(self.structure.imgCarouselTwoForegroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselForgroundTwo
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselTwoForground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselTwoForeground)
                                
                                // MARK: Carrusel Data Three
                                
                                H2("Boton Tres")
                                    .color(.white)
                                
                                Div(self.$carouselThreeText.map{ "Carucel tres texto principal \($0.count)/\(self.structure.carouselThreeText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselThreeTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div(self.$carouselThreeSecondaryText.map{ "Carucel tres texto secundario \($0.count)/\(self.structure.carouselThreeSecondaryText)"})
                                    .fontSize(20.px)
                                    .color(.white)
                                Div().clear(.both).height(3.px)
                                self.carouselThreeSecondaryTextTextArea
                                Div().clear(.both).height(7.px)
                                
                                Div{
                                    
                                    Div{
                                        
                                        self.carouselThreeBtnIsActiveToggle
                                            .float(.right)
                                        
                                        Div("Botton de carucel tres")
                                            .fontSize(20.px)
                                            .color(.white)
                                        
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div{
                                        Div{
                                            Span("Nombre de Boton")
                                                .color(.white)
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                        Div{
                                            self.carouselThreeBtnTextField
                                        }
                                        .width(50.percent)
                                        .float(.left)
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                    
                                    Div("Vincilo de botton")
                                        .fontSize(20.px)
                                        .color(.white)
                                    Div().clear(.both).height(3.px)
                                    self.carouselThreeBtnLinkTextArea
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselThreeBtnIsActive)
                                
                                // MARK: Carrusel Background Three
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselThreeBackground()
                                            }
                                        
                                        H2("Carrusel Tres Principal \(self.structure.imgCarouselThreeBackgroundWidth)x\(self.structure.imgCarouselThreeBackgroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselBackgroundThree
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselThreeBackground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselThreeBackground)
                                
                                // MARK: Carrusel Forground Three
                                Div {
                                    Div{
                                        
                                        Img()
                                            .src("/skyline/media/add.png")
                                            .padding(all: 3.px)
                                            .paddingRight(0.px)
                                            .cursor(.pointer)
                                            .float(.right)
                                            .height(22.px)
                                            .onClick {
                                                self.renderInputFileCarouselThreeForground()
                                            }
                                        
                                        H2("Carrusel Tres Secundaria \(self.structure.imgCarouselThreeForegroundWidth)x\(self.structure.imgCarouselThreeForegroundHeight)")
                                            .color(.white)
                                        
                                        self.fileInputCarouselForgroundThree
                                        
                                    }
                                    Div().clear(.both).height(3.px)
                                    self.fileContainerCarouselThreeForground
                                    Div().clear(.both).height(7.px)
                                }
                                .hidden(!self.structure.carouselThreeForeground)
                                
                            }
                            .padding(all: 3.px)
                        }
                        .custom("height", "calc(100% - 61px)")
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
            
            imagesOne.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgOne,
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
            
            imagesTwo.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgTwo,
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
            
            imagesThree.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgThree,
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
            
            imagesFour.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgFour,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgFour
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .four,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgFour = selectedAvatar
                    self.imageFourContainer[viewId]?.image = selectedAvatar
                    self.imageFourContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageFourContainer[viewId]?.remove()
                    self.imageFourContainer.removeValue(forKey: viewId)
                }
                
                self.imageFourContainer[imageView.viewId] = imageView
                
                fileContainerFour.appendChild(imageView)
                
            }
            
            imagesFive.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgFive,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgFive
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .five,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgFive = selectedAvatar
                    self.imageFiveContainer[viewId]?.image = selectedAvatar
                    self.imageFiveContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageFiveContainer[viewId]?.remove()
                    self.imageFiveContainer.removeValue(forKey: viewId)
                }
                
                self.imageFiveContainer[imageView.viewId] = imageView
                
                fileContainerFive.appendChild(imageView)
                
            }
            
            imagesSix.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgSix,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgSix
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .six,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgSix = selectedAvatar
                    self.imageSixContainer[viewId]?.image = selectedAvatar
                    self.imageSixContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageSixContainer[viewId]?.remove()
                    self.imageSixContainer.removeValue(forKey: viewId)
                }
                
                self.imageSixContainer[imageView.viewId] = imageView
                
                fileContainerSix.appendChild(imageView)
                
            }
            
            imagesSeven.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgSeven,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgSeven
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .seven,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgSeven = selectedAvatar
                    self.imageSevenContainer[viewId]?.image = selectedAvatar
                    self.imageSevenContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageSevenContainer[viewId]?.remove()
                    self.imageSevenContainer.removeValue(forKey: viewId)
                }
                
                self.imageSevenContainer[imageView.viewId] = imageView
                
                fileContainerSeven.appendChild(imageView)
                
            }
            
            imagesEight.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgEight,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgEight
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .eight,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgEight = selectedAvatar
                    self.imageEightContainer[viewId]?.image = selectedAvatar
                    self.imageEightContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageEightContainer[viewId]?.remove()
                    self.imageEightContainer.removeValue(forKey: viewId)
                }
                
                self.imageEightContainer[imageView.viewId] = imageView
                
                fileContainerEight.appendChild(imageView)
                
            }
            
            imagesNine.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgNine,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgNine
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .nine,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgNine = selectedAvatar
                    self.imageNineContainer[viewId]?.image = selectedAvatar
                    self.imageNineContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageNineContainer[viewId]?.remove()
                    self.imageNineContainer.removeValue(forKey: viewId)
                }
                
                self.imageNineContainer[imageView.viewId] = imageView
                
                fileContainerNine.appendChild(imageView)
                
            }
            
            imagesTen.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgTen,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgTen
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .ten,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTen = selectedAvatar
                    self.imageTenContainer[viewId]?.image = selectedAvatar
                    self.imageTenContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageTenContainer[viewId]?.remove()
                    self.imageTenContainer.removeValue(forKey: viewId)
                }
                
                self.imageTenContainer[imageView.viewId] = imageView
                
                fileContainerTen.appendChild(imageView)
                
            }
            
            imagesEleven.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgEleven,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgEleven
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .eleven,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgEleven = selectedAvatar
                    self.imageElevenContainer[viewId]?.image = selectedAvatar
                    self.imageElevenContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageElevenContainer[viewId]?.remove()
                    self.imageElevenContainer.removeValue(forKey: viewId)
                }
                
                self.imageElevenContainer[imageView.viewId] = imageView
                
                fileContainerEleven.appendChild(imageView)
                
            }
            
            imagesTwelve.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexImgTwelve,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$imgTwelve
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .twelve,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTwelve = selectedAvatar
                    self.imageTwelveContainer[viewId]?.image = selectedAvatar
                    self.imageTwelveContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageTwelveContainer[viewId]?.remove()
                    self.imageTwelveContainer.removeValue(forKey: viewId)
                }
                
                self.imageTwelveContainer[imageView.viewId] = imageView
                
                fileContainerTwelve.appendChild(imageView)
                
            }
            
            carucelOneBackground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselOneBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselOneBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundOne,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselOneBackground = selectedAvatar
                    self.imageCarouselOneBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselOneBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselOneBackgroundContainer[viewId]?.remove()
                    self.imageCarouselOneBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselOneBackgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselOneBackground.appendChild(imageView)
                
            }
            
            carucelOneForground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselOneForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselOneForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundOne,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselOneForeground = selectedAvatar
                    self.imageCarouselOneForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselOneForgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselOneForgroundContainer[viewId]?.remove()
                    self.imageCarouselOneForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselOneForgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselOneForground.appendChild(imageView)
                
            }
            
            carucelTwoBackground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselTwoBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselTwoBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundTwo,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselTwoBackground = selectedAvatar
                    self.imageCarouselTwoBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselTwoBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselTwoBackgroundContainer[viewId]?.remove()
                    self.imageCarouselTwoBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselTwoBackgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselTwoBackground.appendChild(imageView)
                
            }
            
            carucelTwoForground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselTwoForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselTwoForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundTwo,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselTwoForeground = selectedAvatar
                    self.imageCarouselTwoForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselTwoForgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselTwoForgroundContainer[viewId]?.remove()
                    self.imageCarouselTwoForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselTwoForgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselTwoForground.appendChild(imageView)
                
            }
            
            carucelThreeBackground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselThreeBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselThreeBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundThree,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselThreeBackground = selectedAvatar
                    self.imageCarouselThreeBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselThreeBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselThreeBackgroundContainer[viewId]?.remove()
                    self.imageCarouselThreeBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselTwoBackgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselThreeBackground.appendChild(imageView)
                
            }
            
            carucelThreeForground.forEach { image in
                
                let imageView = ImageWebView(
                    relation: .indexCarouselThreeForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: image.id,
                    file: image.file,
                    image: image.avatar,
                    descr: image.description,
                    width: image.width,
                    height: image.height,
                    selectedAvatar: self.$carouselThreeForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundThree,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselThreeForeground = selectedAvatar
                    self.imageCarouselThreeForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselThreeForgroundContainer[viewId]?.loadImage(selectedAvatar)
                    
                } removeMe: { viewId in
                    self.imageCarouselThreeForgroundContainer[viewId]?.remove()
                    self.imageCarouselThreeForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselThreeForgroundContainer[imageView.viewId] = imageView
                
                fileContainerCarouselThreeForground.appendChild(imageView)
                
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
            
            API.themeV1.saveWebIndex(
                configLanguage: .Spanish,
                metaTitle: metaTitle,
                metaDescription: metaDescription,
                title: title,
                description: descr,
                mainText: mainText,
                subText: subText,
                carouselOneText: carouselOneText,
                carouselOneSecondaryText: carouselOneSecondaryText,
                carouselOneBtnIsActive: carouselOneBtnIsActive,
                carouselOneBtnText: carouselOneBtnText,
                carouselOneBtnLink: carouselOneBtnLink,
                carouselTwoText: carouselTwoText,
                carouselTwoSecondaryText: carouselTwoSecondaryText,
                carouselTwoBtnIsActive: carouselTwoBtnIsActive,
                carouselTwoBtnText: carouselTwoBtnText,
                carouselTwoBtnLink: carouselTwoBtnLink,
                carouselThreeText: carouselThreeText,
                carouselThreeSecondaryText: carouselThreeSecondaryText,
                carouselThreeBtnIsActive: carouselThreeBtnIsActive,
                carouselThreeBtnText: carouselThreeBtnText,
                carouselThreeBtnLink: carouselThreeBtnLink
            )  { resp in
                
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
                    relation: .indexImgOne,
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
                    to: .webContent(.indexImgOne),
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
                    relation: .indexImgTwo,
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
                    to: .webContent(.indexImgTwo),
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
                    relation: .indexImgThree,
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
                    to: .webContent(.indexImgThree),
                    imageView: imageView,
                    imageContainer: self.fileContainerThree
                )
                
            }
            
            fileInputThree.click()
            
        }
        
        func renderInputFileFour() {
            
            fileInputFour = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputFour.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgFour,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgFour
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .four,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgFour = selectedAvatar
                    self.imageFourContainer[viewId]?.image = selectedAvatar
                    self.imageFourContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageFourContainer[viewId]?.remove()
                    self.imageFourContainer.removeValue(forKey: viewId)
                }
                
                self.imageFourContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgFour),
                    imageView: imageView,
                    imageContainer: self.fileContainerFour
                )
                
            }
            
            fileInputFour.click()
            
        }
        
        func renderInputFileFive() {
            
            fileInputFive = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputFive.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgFive,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgFive
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .five,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgFive = selectedAvatar
                    self.imageFiveContainer[viewId]?.image = selectedAvatar
                    self.imageFiveContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageFiveContainer[viewId]?.remove()
                    self.imageFiveContainer.removeValue(forKey: viewId)
                }
                
                self.imageFiveContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgFive),
                    imageView: imageView,
                    imageContainer: self.fileContainerFive
                )
                
            }
            
            fileInputFive.click()
            
        }
        
        func renderInputFileSix() {
            
            fileInputSix = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputSix.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgSix,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgSix
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .six,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgSix = selectedAvatar
                    self.imageSixContainer[viewId]?.image = selectedAvatar
                    self.imageSixContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageSixContainer[viewId]?.remove()
                    self.imageSixContainer.removeValue(forKey: viewId)
                }
                
                self.imageSixContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgSix),
                    imageView: imageView,
                    imageContainer: self.fileContainerSix
                )
                
            }
            
            fileInputSix.click()
            
        }
        
        func renderInputFileSeven() {
            
            fileInputSeven = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputSeven.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgSeven,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgSeven
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .seven,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgSeven = selectedAvatar
                    self.imageSevenContainer[viewId]?.image = selectedAvatar
                    self.imageSevenContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageSevenContainer[viewId]?.remove()
                    self.imageSevenContainer.removeValue(forKey: viewId)
                }
                
                self.imageSevenContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgSeven),
                    imageView: imageView,
                    imageContainer: self.fileContainerSeven
                )
                
            }
            
            fileInputSeven.click()
            
        }
        
        func renderInputFileEight() {
            
            fileInputEight = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputEight.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgEight,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgEight
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .eight,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgEight = selectedAvatar
                    self.imageEightContainer[viewId]?.image = selectedAvatar
                    self.imageEightContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageEightContainer[viewId]?.remove()
                    self.imageEightContainer.removeValue(forKey: viewId)
                }
                
                self.imageEightContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgEight),
                    imageView: imageView,
                    imageContainer: self.fileContainerEight
                )
                
            }
            
            fileInputEight.click()
            
        }
        
        func renderInputFileNine() {
            
            fileInputNine = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputNine.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgNine,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgNine
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHNine, isAvatar in
                    self.startEditImage(
                        .nine,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHNine,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgNine = selectedAvatar
                    self.imageNineContainer[viewId]?.image = selectedAvatar
                    self.imageNineContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageNineContainer[viewId]?.remove()
                    self.imageNineContainer.removeValue(forKey: viewId)
                }
                
                self.imageNineContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgNine),
                    imageView: imageView,
                    imageContainer: self.fileContainerNine
                )
                
            }
            
            fileInputNine.click()
            
        }
        
        func renderInputFileTen() {
            
            fileInputTen = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputTen.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgTen,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgTen
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHTen, isAvatar in
                    self.startEditImage(
                        .ten,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHTen,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTen = selectedAvatar
                    self.imageTenContainer[viewId]?.image = selectedAvatar
                    self.imageTenContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageTenContainer[viewId]?.remove()
                    self.imageTenContainer.removeValue(forKey: viewId)
                }
                
                self.imageTenContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgTen),
                    imageView: imageView,
                    imageContainer: self.fileContainerTen
                )
                
            }
            
            fileInputTen.click()
            
        }
        
        func renderInputFileEleven() {
            
            fileInputEleven = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputEleven.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgEleven,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgEleven
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHEleven, isAvatar in
                    self.startEditImage(
                        .eleven,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHEleven,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgEleven = selectedAvatar
                    self.imageElevenContainer[viewId]?.image = selectedAvatar
                    self.imageElevenContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageElevenContainer[viewId]?.remove()
                    self.imageElevenContainer.removeValue(forKey: viewId)
                }
                
                self.imageElevenContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgEleven),
                    imageView: imageView,
                    imageContainer: self.fileContainerEleven
                )
                
            }
            
            fileInputEleven.click()
            
        }
        
        func renderInputFileTwelve() {
            
            fileInputTwelve = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputTwelve.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexImgTwelve,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$imgTwelve
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .twelve,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.imgTwelve = selectedAvatar
                    self.imageTwelveContainer[viewId]?.image = selectedAvatar
                    self.imageTwelveContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageTwelveContainer[viewId]?.remove()
                    self.imageTwelveContainer.removeValue(forKey: viewId)
                }
                
                self.imageTwelveContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexImgTwelve),
                    imageView: imageView,
                    imageContainer: self.fileContainerTwelve
                )
                
            }
            
            fileInputTwelve.click()
            
        }
        
        func renderInputFileCarouselOneBackground() {
            
            fileInputCarouselBackgroundOne = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselBackgroundOne.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselOneBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselOneBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundOne,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselOneBackground = selectedAvatar
                    self.imageCarouselOneBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselOneBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselOneBackgroundContainer[viewId]?.remove()
                    self.imageCarouselOneBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselOneBackgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselOneBackground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselOneBackground
                )
                
            }
            
            fileInputCarouselBackgroundOne.click()
            
        }
        
        func renderInputFileCarouselOneForground() {
            
            fileInputCarouselForgroundOne = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselForgroundOne.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselOneForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselOneForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundOne,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselOneForeground = selectedAvatar
                    self.imageCarouselOneForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselOneForgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselOneForgroundContainer[viewId]?.remove()
                    self.imageCarouselOneForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselOneForgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselOneForeground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselOneForground
                )
                
            }
            
            fileInputCarouselForgroundOne.click()
            
        }
        
        func renderInputFileCarouselTwoBackground() {
            
            fileInputCarouselBackgroundTwo = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselBackgroundTwo.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselTwoBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselTwoBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundTwo,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselTwoBackground = selectedAvatar
                    self.imageCarouselTwoBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselTwoBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselTwoBackgroundContainer[viewId]?.remove()
                    self.imageCarouselTwoBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselTwoBackgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselTwoBackground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselTwoBackground
                )
                
            }
            
            fileInputCarouselBackgroundTwo.click()
            
        }
        
        func renderInputFileCarouselTwoForground() {
            
            fileInputCarouselForgroundTwo = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselForgroundTwo.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselTwoForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselTwoForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundTwo,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselTwoForeground = selectedAvatar
                    self.imageCarouselTwoForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselTwoForgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselTwoForgroundContainer[viewId]?.remove()
                    self.imageCarouselTwoForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselTwoForgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselTwoForeground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselTwoForground
                )
                
            }
            
            fileInputCarouselForgroundTwo.click()
            
        }
        
        func renderInputFileCarouselThreeBackground() {
            
            fileInputCarouselBackgroundThree = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselBackgroundThree.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselThreeBackground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselThreeBackground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellBackgroundThree,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselThreeBackground = selectedAvatar
                    self.imageCarouselThreeBackgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselThreeBackgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselThreeBackgroundContainer[viewId]?.remove()
                    self.imageCarouselThreeBackgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselThreeBackgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselThreeBackground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselThreeBackground
                )
                
            }
            
            fileInputCarouselBackgroundThree.click()
            
        }
        
        func renderInputFileCarouselThreeForground() {
            
            fileInputCarouselForgroundThree = InputFile()
                .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // ,".heic"
                .multiple(false)
                .display(.none)
            
            fileInputCarouselForgroundThree.$files.listen {
                
                guard let file = $0.first else {
                    return
                }
            
                let imageView = ImageWebView(
                    relation: .indexCarouselThreeForeground,
                    relationId: nil,
                    type: .img,
                    mediaId: nil,
                    file: nil,
                    image: nil,
                    descr: "",
                    width: 0,
                    height: 0,
                    selectedAvatar: self.$carouselThreeForeground
                ) { viewId, mediaId, path, originalImage, originalWidth, originalHeight, isAvatar in
                    self.startEditImage(
                        .carucellForgroundThree,
                        viewId,
                        mediaId,
                        path,
                        originalImage,
                        originalWidth,
                        originalHeight,
                        isAvatar
                    )
                } imAvatar: { viewId, selectedAvatar in
                    self.carouselThreeForeground = selectedAvatar
                    self.imageCarouselThreeForgroundContainer[viewId]?.image = selectedAvatar
                    self.imageCarouselThreeForgroundContainer[viewId]?.loadImage(selectedAvatar)
                } removeMe: { viewId in
                    self.imageCarouselThreeForgroundContainer[viewId]?.remove()
                    self.imageCarouselThreeForgroundContainer.removeValue(forKey: viewId)
                }
                
                self.imageCarouselThreeForgroundContainer[imageView.viewId] = imageView
                
                ToolsView.WebPage.loadMedia(
                    file: file,
                    to: .webContent(.indexCarouselThreeForeground),
                    imageView: imageView,
                    imageContainer: self.fileContainerCarouselThreeForground
                )
                
            }
            
            fileInputCarouselForgroundThree.click()
            
        }
        
        func startEditImage(
            _ type: IndexEditImageType,
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
                subId = .indexImgOne
                wapWidthPre = structure.imgOneWidth
                wapHeightPre = structure.imgOneHeight
            case .two:
                subId = .indexImgTwo
                wapWidthPre = structure.imgTwoWidth
                wapHeightPre = structure.imgTwoHeight
            case .three:
                subId = .indexImgThree
                wapWidthPre = structure.imgThreeWidth
                wapHeightPre = structure.imgThreeHeight
            case .four:
                subId = .indexImgFour
                wapWidthPre = structure.imgFourWidth
                wapHeightPre = structure.imgFourHeight
            case .five:
                subId = .indexImgFive
                wapWidthPre = structure.imgFiveWidth
                wapHeightPre = structure.imgFiveHeight
            case .six:
                subId = .indexImgSix
                wapWidthPre = structure.imgSixWidth
                wapHeightPre = structure.imgSixHeight
            case .seven:
                subId = .indexImgSeven
                wapWidthPre = structure.imgSevenWidth
                wapHeightPre = structure.imgSevenHeight
            case .eight:
                subId = .indexImgEight
                wapWidthPre = structure.imgEightWidth
                wapHeightPre = structure.imgEightHeight
            case .nine:
                subId = .indexImgNine
                wapWidthPre = structure.imgNineWidth
                wapHeightPre = structure.imgNineHeight
            case .ten:
                subId = .indexImgTen
                wapWidthPre = structure.imgTenWidth
                wapHeightPre = structure.imgTenHeight
            case .eleven:
                subId = .indexImgEleven
                wapWidthPre = structure.imgElevenWidth
                wapHeightPre = structure.imgElevenHeight
            case .twelve:
                subId = .indexImgTwelve
                wapWidthPre = structure.imgTwelveWidth
                wapHeightPre = structure.imgTwelveHeight
            case .carucellBackgroundOne:
                subId = .indexCarouselOneBackground
                wapWidthPre = structure.imgCarouselOneBackgroundWidth
                wapHeightPre = structure.imgCarouselOneBackgroundHeight
            case .carucellForgroundOne:
                subId = .indexCarouselOneForeground
                wapWidthPre = structure.imgCarouselOneForegroundWidth
                wapHeightPre = structure.imgCarouselOneForegroundHeight
            case .carucellBackgroundTwo:
                subId = .indexCarouselTwoBackground
                wapWidthPre = structure.imgCarouselTwoBackgroundWidth
                wapHeightPre = structure.imgCarouselTwoBackgroundHeight
            case .carucellForgroundTwo:
                subId = .indexCarouselTwoForeground
                wapWidthPre = structure.imgCarouselTwoForegroundWidth
                wapHeightPre = structure.imgCarouselTwoForegroundHeight
            case .carucellBackgroundThree:
                subId = .indexCarouselThreeBackground
                wapWidthPre = structure.imgCarouselThreeBackgroundWidth
                wapHeightPre = structure.imgCarouselThreeBackgroundHeight
            case .carucellForgroundThree:
                subId = .indexCarouselThreeForeground
                wapWidthPre = structure.imgCarouselThreeForegroundWidth
                wapHeightPre = structure.imgCarouselThreeForegroundHeight
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
                case .four:
                    if let view = self.imageFourContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .five:
                    if let view = self.imageFiveContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .six:
                    if let view = self.imageSixContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .seven:
                    if let view = self.imageSevenContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .eight:
                    if let view = self.imageEightContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .nine:
                    if let view = self.imageNineContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .ten:
                    if let view = self.imageTenContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .eleven:
                    if let view = self.imageElevenContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .twelve:
                    if let view = self.imageTwelveContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellBackgroundOne:
                    if let view = self.imageCarouselOneBackgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellForgroundOne:
                    if let view = self.imageCarouselOneForgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellBackgroundTwo:
                    if let view = self.imageCarouselTwoBackgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellForgroundTwo:
                    if let view = self.imageCarouselTwoForgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellBackgroundThree:
                    if let view = self.imageCarouselThreeBackgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                case .carucellForgroundThree:
                    if let view = self.imageCarouselThreeForgroundContainer[viewid] {
                        view.loadPercent = "Trabajando"
                        view.isLoaded = false
                        view.chekCropState(wait: 7)
                    }
                }
                
            }
            
            addToDom(editor)
        }
        
        enum IndexEditImageType {
            case one
            case two
            case three
            case four
            case five
            case six
            case seven
            case eight
            case nine
            case ten
            case eleven
            case twelve
            case carucellBackgroundOne
            case carucellForgroundOne
            case carucellBackgroundTwo
            case carucellForgroundTwo
            case carucellBackgroundThree
            case carucellForgroundThree
        }
        
    }
}
