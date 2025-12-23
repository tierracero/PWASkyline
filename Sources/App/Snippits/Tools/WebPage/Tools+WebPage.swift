//
//  Tools+WebPage.swift
//  
//
//  Created by Victor Cantu on 8/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension ToolsView {
    
    class WebPage: Div {
        
        override class var name: String { "div" }
        
        var account: TCAccountsItem
        
        init(
            account: TCAccountsItem
        ) {
            self.account = account
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var webTool: WebTools = .pages
        
        lazy var activeButtons = Ul()
            .class(.connectedSortable)
            .id(.init("sortable1"))
            .height(100.percent)
        
        lazy var inactiveButtons = Ul()
            .class(.connectedSortable)
            .id(.init("sortable2"))
            .height(100.percent)
        
        @State var indexListener = ""
        
        @State var meetUsListener = ""
        
        @State var serviceListener = ""
        
        @State var productListener = ""
        
        @State var promotionListener = ""
        
        @State var calendarListener = ""
        
        @State var albumListener = ""
        
        @State var blogListener = ""
        
        @State var downloadListener = ""
        
        @State var orderListener = ""
        
        @State var contactListener = ""
    
        lazy var indexButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_index.png")
                    .height(89.px)
                    .width(89.px)
            }
            Div{
                InputText(self.$indexListener)
                    .placeholder("Inicio")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject, .fixItem)
                    .height(31.px)
                    .id(.init(WebPageLink.index.rawValue))
            }
        }
            .class(.uibutton, .fixItem)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                self.loadIndexView()
            }
        
        lazy var meetUsButton = Li{
            Div{
                
                Img()
                    .src("/skyline/media/panel_meetus.png")
                    .height(89.px)
                    .width(89.px)
            
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$meetUsListener)
                    .placeholder("Quienes Somos")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.meetUs.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                self.loadMeetusView()
            }
        
        lazy var serviceButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_service.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$serviceListener)
                    .placeholder("Servicios")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.service.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                self.loadServiceView()
            }
        
        lazy var productButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_product.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$productListener)
                    .placeholder("Productos")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.product.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var promotionButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_promotion.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$promotionListener)
                    .placeholder("Promociones")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.promotion.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var calendarButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_calander.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$calendarListener)
                    .placeholder("Calendario")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.calendar.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var albumButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_album.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$albumListener)
                    .placeholder("Album")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.album.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var blogButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_blog.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$blogListener)
                    .placeholder("Blog")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.blog.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                self.loadBlogView()
            }
        
        lazy var downloadButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_download.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$downloadListener)
                    .placeholder("Descargas")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.download.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var orderButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_order.png")
                    .height(89.px)
                    .width(89.px)
                
                Img()
                    .src("/skyline/media/paragraph_justify.png")
                    .class(.buttonHandle)
                    .position(.absolute)
                    .height(29.px)
                    .width(29.px)
                    .right(3.px)
                    .top(3.px)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
            }
            Div{
                InputText(self.$orderListener)
                    .placeholder("Ordenes")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject)
                    .height(31.px)
                    .id(.init(WebPageLink.order.rawValue))
            }
        }
            .class(.uibutton)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                
            }
        
        lazy var contactButton = Li{
            Div{
                Img()
                    .src("/skyline/media/panel_contact.png")
                    .height(89.px)
                    .width(89.px)
            }
            Div{
                InputText(self.$contactListener)
                    .placeholder("Contactanos")
                    .custom("width","calc(100% - 24px)")
                    .class(.textFiledBlackDark, .webButtonObject, .fixItem)
                    .height(31.px)
                    .id(.init(WebPageLink.contact.rawValue))
            }
        }
            .class(.uibutton, .fixItem)
            .position(.relative)
            .borderRadius(24.px)
            .margin(all: 7.px)
            .height(124.px)
            .width(124.px)
            .float(.left)
            .onClick {
                self.loadContactView()
            }
        
        var logosPageIsLoaded = false

        lazy var logosPageContainer: Div = Div()
            .hidden(self.$webTool.map{ $0 != .logos })
            .height(100.percent)
            .width(80.percent)
            .float(.left)

        var redesPageIsLoaded = false

        lazy var redesPageContainer: Div = Div()
            .hidden(self.$webTool.map{ $0 != .social })
            .height(100.percent)
            .width(80.percent)
            .float(.left)

        var themsPageIsLoaded = false

        lazy var themsPageContainer: Div = Div()
            .hidden(self.$webTool.map{ $0 != .theme })
            .height(100.percent)
            .width(80.percent)
            .float(.left)

        var chatPageIsLoaded = false

        lazy var chatPageContainer: Div = Div()
            .hidden(self.$webTool.map{ $0 != .chat })
            .height(100.percent)
            .width(80.percent)
            .float(.left)

        var otherPageIsLoaded = false

        lazy var otherPageContainer: Div = Div()
            .hidden(self.$webTool.map{ $0 != .other })
            .height(100.percent)
            .width(80.percent)
            .float(.left)

        @DOM override var body: DOM.Content {
            
            Div{
                
                /* Header */
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Configuracion de la pagina")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Div{
                    /* MARK: Tools*/
                    Div{
                        Div{
                            H2("Herramientas")
                                .marginLeft(7.px)
                                .color(.white)
                        }
                        Div{
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_web_pages.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Paginas")
                                    .color(self.$webTool.map{ $0 != .pages ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .pages ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {
                                self.webTool = .pages
                            }
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_logos.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Logos")
                                    .color(self.$webTool.map{ $0 != .logos ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .logos ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {

                                if self.logosPageIsLoaded {
                                    self.webTool = .logos
                                }

                                self.loadLogosView()
                                
                            }
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_redes.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Redes")
                                    .color(self.$webTool.map{ $0 != .social ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .social ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {
                                self.webTool = .social
                            }
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_theme.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Temas")
                                    .color(self.$webTool.map{ $0 != .theme ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .theme ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {
                                self.webTool = .theme
                            }
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_chat_settings.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Chat")
                                    .color(self.$webTool.map{ $0 != .chat ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .chat ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {
                                self.webTool = .chat
                            }
                            
                            Div{
                                Img()
                                    .src("/skyline/media/panel_ajustes.png")
                                    .marginRight(12.px)
                                    .height(33.px)
                                    .width(33.px)
                                    .float(.left)
                                
                                H3("Otros Ajustes")
                                    .color(self.$webTool.map{ $0 != .other ? .gray : .white })
                                    .float(.left)
                                
                                Div().class(.clear)
                            }
                            .backgroundColor(self.$webTool.map{ $0 != .other ? .backGroundRow : .black })
                            .custom("width", "calc(100% - 18px)")
                            .class(.uibtnLarge, .oneLineText)
                            .onClick {
                                self.webTool = .other
                            }
                            
                            Div().class(.clear)
                            
                        }
                        .custom("height", "calc(100% - 35px)")
                        .overflow(.auto)
                        
                    }
                    .height(100.percent)
                    .width(20.percent)
                    .float(.left)
                    
                    Div{
                        
                        /* MARK: Active Buttons */
                        Div{
                            Div{
                                H2("Paginas Activas")
                                    //.marginLeft(7.px)
                                    .color(.white)
                            }
                            Div{
                                Div{
                                    self.activeButtons
                                }
                                    .id(.init("activeButtonDiv"))
                                    .custom("height", "calc(100% - 6px)")
                                    .class(.roundDarkBlue)
                                    .padding(all: 3.px)
                                    .margin(all: 3.px)
                            }
                            .custom("height", "calc(100% - 35px)")
                        }
                        .height(100.percent)
                        .width(50.percent)
                        .float(.left)
                        
                        /* MARK: Incative Buttons */
                        Div{
                            Div{
                                H2("Paginas Inactivas")
                                    //.marginLeft(7.px)
                                    .color(.white)
                            }
                            Div{
                                Div{
                                    self.inactiveButtons
                                }
                                    .id(.init("inactiveButtonDiv"))
                                    .custom("height", "calc(100% - 6px)")
                                    .class(.roundDarkBlue)
                                    .padding(all: 3.px)
                                    .margin(all: 3.px)
                            }
                            .custom("height", "calc(100% - 35px)")
                            
                        }
                        .height(100.percent)
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    .hidden(self.$webTool.map{ $0 != .pages })
                    .height(100.percent)
                    .width(80.percent)
                    .float(.left)
                    
                    self.logosPageContainer

                    self.redesPageContainer

                    self.themsPageContainer

                    self.chatPageContainer

                    self.otherPageContainer

                    Div().class(.clear)
                    
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
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.themeV1.getWebButtons { resp in
                
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
                
                let allbuttons: [WebPageLink] = [.index, .meetUs, .service, .product, .promotion, .calendar, .album, .blog, .download, .order, .contact]
                
                var currentbuttons: [WebPageLink] = []
                
                self.activeButtons.appendChild(self.indexButton)
                
                payload.buttons.activeButtons.forEach { button in
                    
                    currentbuttons.append(button)
                    
                    switch button {
                    case .index:
                        break
                    case .meetUs:
                        self.activeButtons.appendChild(self.meetUsButton)
                    case .service:
                        self.activeButtons.appendChild(self.serviceButton)
                    case .product:
                        self.activeButtons.appendChild(self.productButton)
                    case .promotion:
                        self.activeButtons.appendChild(self.promotionButton)
                    case .calendar:
                        self.activeButtons.appendChild(self.calendarButton)
                    case .album:
                        self.activeButtons.appendChild(self.albumButton)
                    case .blog:
                        self.activeButtons.appendChild(self.blogButton)
                    case .download:
                        self.activeButtons.appendChild(self.downloadButton)
                    case .order:
                        self.activeButtons.appendChild(self.orderButton)
                    case .contact:
                        break
                    case .myaccount:
                        break
                    case .legal:
                        break
                    case .privacy:
                        break
                    case .webstore:
                        break
                    case .sitemap:
                        break
                    case .viewProduct:
                        break
                    case .viewService:
                        break
                    case .viewBlog:
                        break
                    case .viewAlbum:
                        break
                    case .viewOrder:
                        break
                    case .viewDiploma:
                        break
                    case .viewProfile:
                        break
                    case .work:
                        break
                    case .vendor:
                        break
                    case .business:
                        break
                    case .wishList:
                        break
                    case .redes:
                        break
                    case .notFound:
                        break
                    }
                    
                }
                
                self.activeButtons.appendChild(self.contactButton)
                
                allbuttons.forEach { button in
                    
                    if currentbuttons.contains(button) {
                        return
                    }
                    
                    switch button {
                    case .index:
                        break
                    case .meetUs:
                        self.inactiveButtons.appendChild(self.meetUsButton)
                    case .service:
                        self.inactiveButtons.appendChild(self.serviceButton)
                    case .product:
                        self.inactiveButtons.appendChild(self.productButton)
                    case .promotion:
                        self.inactiveButtons.appendChild(self.promotionButton)
                    case .calendar:
                        self.inactiveButtons.appendChild(self.calendarButton)
                    case .album:
                        self.inactiveButtons.appendChild(self.albumButton)
                    case .blog:
                        self.inactiveButtons.appendChild(self.blogButton)
                    case .download:
                        self.inactiveButtons.appendChild(self.downloadButton)
                    case .order:
                        self.inactiveButtons.appendChild(self.orderButton)
                    case .contact:
                        break
                    case .myaccount:
                        break
                    case .legal:
                        break
                    case .privacy:
                        break
                    case .webstore:
                        break
                    case .sitemap:
                        break
                    case .viewProduct:
                        break
                    case .viewService:
                        break
                    case .viewBlog:
                        break
                    case .viewAlbum:
                        break
                    case .viewOrder:
                        break
                    case .viewDiploma:
                        break
                    case .viewProfile:
                        break
                    case .work:
                        break
                    case .vendor:
                        break
                    case .business:
                        break
                    case .wishList:
                        break
                    case .redes:
                        break
                    case .notFound:
                        break
                    }
                    
                }
                
                let _ = JSObject.global.webPagesSortable!( JSClosure { args in
                    
                    print("⭐️ webPagesSortable ")
                    
                    guard let data = args.first?.string?.data(using: .utf8) else {
                        print("🔴 Error al convertir hilo a data \(#function)")
                        return .undefined
                    }
                    
                    do {
                        
                        let newItems = try JSONDecoder().decode([WebPageLink].self, from: data)
                        
                        API.themeV1.updateActiveButtons(buttons: newItems) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else {
                                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para completar operación")
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                        }
                        
                        
                    }
                    catch{
                        
                        print("🔴 Error al convertir data a objeto \(#function)")
                        
                    }
                    
                    return .undefined
                })
                
                self.indexListener = payload.buttons.defaults.index.nick
                
                self.meetUsListener = payload.buttons.defaults.meetUs.nick
                
                self.serviceListener = payload.buttons.defaults.service.nick
                
                self.productListener = payload.buttons.defaults.product.nick
                
                self.promotionListener = payload.buttons.defaults.promotion.nick
                
                self.calendarListener = payload.buttons.defaults.calendar.nick
                
                self.albumListener = payload.buttons.defaults.album.nick
                
                self.blogListener = payload.buttons.defaults.blog.nick
                
                self.downloadListener = payload.buttons.defaults.download.nick
                
                self.orderListener = payload.buttons.defaults.order.nick
                
                self.contactListener = payload.buttons.defaults.contact.nick
                
                self.activateButtonListener()
                
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
        }
        
        func updateButtonName(id: WebPageLink, name: String) {
            
            if name.isEmpty {
                return
            }
            
            API.themeV1.updateButtons(
                id: id,
                name: name
            ) { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir.")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                print("🟢 updateButtonName \(id.rawValue) \(name)")
                
            }
        }
        
        func activateButtonListener(){
            
            $indexListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.indexListener {
                        return
                    }
                    self.updateButtonName(id: .index, name: string)
                }
            }
            
            $meetUsListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.meetUsListener {
                        return
                    }
                    self.updateButtonName(id: .meetUs, name: string)
                }
            }
            
            $serviceListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.serviceListener {
                        return
                    }
                    self.updateButtonName(id: .service, name: string)
                }
            }
            
            $productListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.productListener {
                        return
                    }
                    self.updateButtonName(id: .product, name: string)
                }
            }
            
            $promotionListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.promotionListener {
                        return
                    }
                    self.updateButtonName(id: .promotion, name: string)
                }
            }
            
            $calendarListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.calendarListener {
                        return
                    }
                    self.updateButtonName(id: .calendar, name: string)
                }
            }
            
            $albumListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.albumListener {
                        return
                    }
                    self.updateButtonName(id: .album, name: string)
                }
            }
            
            $blogListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.blogListener {
                        return
                    }
                    self.updateButtonName(id: .blog, name: string)
                }
            }
            
            $downloadListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.downloadListener {
                        return
                    }
                    self.updateButtonName(id: .download, name: string)
                }
            }
            
            $orderListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.orderListener {
                        return
                    }
                    self.updateButtonName(id: .order, name: string)
                }
            }
            
            $contactListener.listen{ string in
                Dispatch.asyncAfter(0.5) {
                    if string != self.contactListener {
                        return
                    }
                    self.updateButtonName(id: .contact, name: string)
                }
            }
            
        }
        
        /*
        MARK: Page View Loader
        */

        func loadIndexView() {
            
            loadingView(show: true)
           
            API.themeV1.getWebIndex(
                theme: self.account.pwa.rawValue,
                configLanguage: .Spanish
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
                
               let view = IndexPage(
                data: payload.data,
                structure: payload.structure,
                imagesOne: payload.imagesOne,
                imagesTwo: payload.imagesTwo,
                imagesThree: payload.imagesThree,
                imagesFour: payload.imagesFour,
                imagesFive: payload.imagesFive,
                imagesSix: payload.imagesSix,
                imagesSeven: payload.imagesSeven,
                imagesEight: payload.imagesEight,
                imagesNine: payload.imagesNine,
                imagesTen: payload.imagesTen,
                imagesEleven: payload.imagesEleven,
                imagesTwelve: payload.imagesTwelve,
                carucelOneForground: payload.carucelOneForground,
                carucelOneBackground: payload.carucelOneBackground,
                carucelTwoForground: payload.carucelTwoForground,
                carucelTwoBackground: payload.carucelTwoBackground,
                carucelThreeForground: payload.carucelThreeForground,
                carucelThreeBackground: payload.carucelThreeBackground
               )
                
                addToDom(view)
                
           }
        }
        
        func loadContactView() {
            
            loadingView(show: true)
           
            API.themeV1.getWebContact(
                theme: self.account.pwa.rawValue,
                configLanguage: .Spanish
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
                
               let view = ContactPage(
                data: payload.data,
                structure: payload.structure,
                imageOne: payload.imagesOne,
                imageTwo: payload.imagesTwo,
                imageThree: payload.imagesThree
               )
                
                addToDom(view)
                
           }
        }
        
        func loadMeetusView() {
            
            loadingView(show: true)
           
            API.themeV1.getWebMeetUs(
                theme: self.account.pwa.rawValue,
                configLanguage: .Spanish
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
               
                /// let payload: ThemeComponents.GetWebMeetUsResponse
               guard let payload = resp.data else {
                   showError(.unexpectedResult, .unexpenctedMissingPayload)
                   return
               }
                
                let view = MeetUsPage(
                    data: payload.data,
                    structure: payload.structure,
                    diplomas: payload.diplomas,
                    profiles: payload.profiles,
                    imageOne: payload.imagesOne,
                    imageTwo: payload.imagesTwo,
                    imageThree: payload.imagesThree
                )
                
                addToDom(view)
                
           }
        }
        
        func loadServiceView() {
            
            loadingView(show: true)
           
            API.themeV1.getWebService(
                theme: self.account.pwa.rawValue,
                configLanguage: .Spanish
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
                
               let view = ServicePage(
                data: payload.data,
                structure: payload.structure,
                services: payload.services,
                imageOne: payload.imagesOne,
                imageTwo: payload.imagesTwo,
                imageThree: payload.imagesThree
               )
                
                addToDom(view)
                
           }
        }
        
        func loadBlogView() {
            
            loadingView(show: true)
           
            API.themeV1.getWebBlog(
                theme: self.account.pwa.rawValue,
                configLanguage: .Spanish
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
               
               let view = BlogPage(
                data: payload.data,
                structure: payload.structure,
                blogs: payload.blogs,
                imageOne: payload.imagesOne,
                imageTwo: payload.imagesTwo,
                imageThree: payload.imagesThree
               )
                
                addToDom(view)
                
           }
        }

        /*
        MARK: General Components Loader
        */
        func loadLogosView() {
            
            loadingView(show: true)

            API.themeV1.getLogos { resp in

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

                self.logosPageIsLoaded = true 

                self.logosPageContainer.appendChild(LogosView(
                    darkLogo: payload.darkLogo,
                    darkTransLogo: payload.darkTransLogo,
                    lightLogo: payload.lightLogo,
                    lightTransLogo: payload.lightTransLogo,
                    iconLogo: payload.iconLogo,
                    darkLogos: payload.darkLogos,
                    darkTransLogos: payload.darkTransLogos,
                    lightLogos: payload.lightLogos,
                    lightTransLogos: payload.lightTransLogos,
                    iconLogos: payload.iconLogos
                ))

                 self.webTool = .logos

            }

        }

    }
}

extension ToolsView.WebPage {
    
    enum EditImageType {
        case one
        case two
        case three
    }
    
    enum WebTools {
        case pages
        case logos
        case social
        case theme
        case chat
        case other
    }
    
    public enum LoadMediaType {
        
        case product(UUID?)
        
        case service(UUID?)
        
        case album(UUID?)
        
        case blog(UUID?)
        
        case order(UUID)
        
        case webNote(UUID)
        
        case chat(UUID)
        
        case departmentAvatar(UUID)
        
        case categoryAvatar(UUID)
        
        case lineAvatar(UUID)
        
        case webContent(CustWebFilesObjectType)
        
        case webService(UUID?)

        case webBlog(UUID?)

        case webDiploma(UUID?)

        case webProfile(UUID?)
    
    }
    
    static func loadMedia(file: File, to toType: LoadMediaType, imageView view: ImageWebView, imageContainer container: Div ) {
        
        let xhr = XMLHttpRequest()
        
        xhr.onLoadStart { event in
            container.appendChild(view)
            //_ = JSObject.global.scrollToBottom!("pocImageContainer")
        }
        
        xhr.onError { jsValue in
            showError(.errorDeCommunicacion, .serverConextionError)
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            print("⭐️ onLoadEnd 001")
            
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
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    view.remove()
                    return
                }
                
                guard let process = resp.data else {
                    showError(.errorGeneral, "No se pudo cargar datos")
                    view.remove()
                    return
                }
                
                switch process {
                case .processing(_):
                    
                    view.loadPercent = "processando..."
                    view.chekUploadState(wait: 7)
                    
                case .processed(let payload):
                    
                    guard let mediaid = payload.mediaid else {
                        showAlert(.alerta, "Fotosubida pero no se pudo cargar, refresque y preporte el error a Soporte TC")
                        return
                    }
                    
                    view.mediaId = mediaid
                    view.width = payload.width
                    view.height = payload.height
                    
                    view.file = payload.avatar
                    
                    view.image = payload.avatar
                    
                    view.loadImage(payload.avatar)
                    
                }
                
            }
            catch {
                showError(.errorGeneral, .serverConextionError + " 003")
                view.remove()
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            
            let event = ProgressEvent(_event.jsEvent)
            
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
            print("PROGRESS 002 \(view.loadPercent)")
            
        }
        
        xhr.onProgress { event in
            print("⭐️ onProgress 002")
            print(event.loaded)
            print(event.total)
        }
        
        let fileName =  safeFileName(name: file.name, to: nil, folio: nil)

        let formData = FormData()

        formData.append("file", file, filename: fileName)
        
        var to: ImagePickerTo? =  nil
        
        var toId: UUID? = nil
        
        /// logoIndexMain, logoIndexWhite, logoIndexWhiteTrans, logoIndexBlack, logoIndexBlackTrans, logoIndexIcon, ...
        var subId: CustWebFilesObjectType? = nil
        
        switch toType {
        case .product(let id):
            to = .product
            toId = id
        case .service(let id):
            to = .service
            toId = id
        case .album(let id):
            to = .album
            toId = id
        case .blog(let id):
            to = .blog
            toId = id
        case .order(let id):
            to = .order
            toId = id
        case .webNote(let id):
            to = .webNote
            toId = id
        case .chat(let id):
            to = .chat
            toId = id
        case .departmentAvatar(let id):
            to = .departmentAvatar
            toId = id
        case .categoryAvatar(let id):
            to = .categoryAvatar
            toId = id
        case .lineAvatar(let id):
            to = .lineAvatar
            toId = id
        case .webContent(let type):
            to = .webContent
            subId = type
        case .webService(let id):
            to = .webService
            toId = id
        case .webBlog(let id):
            to = .webBlog
            toId = id
        case .webDiploma(let id):
            to = .webDiploma
            toId = id
        case .webProfile(let id):
            to = .webProfile
            toId = id
        }
        
        guard let to else {
            return
        }
        
        xhr.setRequestHeader("x-eventid", view.viewId.uuidString)
        
        /// products, service, album, webService... general...
        xhr.setRequestHeader("x-to", to.rawValue)
        
        /// EG: product id
        if let id = toId?.uuidString {
            xhr.setRequestHeader("x-id", id)
        }
        
        /// EG: webContent -> serviceImgOne
        if let subId {
            xhr.setRequestHeader("x-subid", subId.rawValue)
        }
        
        xhr.setRequestHeader("x-filename", fileName)
        
        xhr.setRequestHeader("x-connid", custCatchChatConnID)
        
        xhr.setRequestHeader("x-remotecamera", false.description)
        
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadManager")
        
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
    
}
