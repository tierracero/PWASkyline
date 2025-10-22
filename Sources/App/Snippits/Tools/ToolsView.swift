//
//  ToolsView.swift
//  
//
//  Created by Victor Cantu on 1/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolsView: Div {
    
    override class var name: String { "div" }
    
    
    /*
     
     init(
         currentChatIds: [UUID],
         callback: @escaping ((_ id: CustChatRoomProfile) -> ())
     ) {
         self.currentChatIds = currentChatIds
         self.callback = callback
         super.init()
     }
     
     required init() {
         fatalError("init() has not been implemented")
     }
     
     */
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.remove()
                    }
                
                H2("Ajustes y Herramientas")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
                Div {
                    
                    /// Services
                    Div{
                        
                        Table{
                            
                            Tr{
                                Td{
                                    
                                    Img() 
                                        .src("skyline/media/service_icon.png")
                                        .height(100.px)
                                    
                                    Div("Servicios")
                                        .textAlign(.center)
                                        .margin(all: 7.px)
                                        .color(.white)
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                        
                    }
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .height(150.px)
                    .width(150.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        addToDom(ServiceManager())
                        self.remove()
                    }
                    
                    /*.Adjustments */
                    Div{
                        
                        Table{
                            Tr{
                                Td{
                                    
                                    Img()
                                        .src("skyline/media/gear.png")
                                        .height(100.px)
                                    
                                    Div("Ajustes")
                                        .textAlign(.center)
                                        .margin(all: 7.px)
                                        .color(.white)
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                        
                    }
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .height(150.px)
                    .width(150.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        addToDom(SystemSettings())
                        self.remove()
                    }
                    
                    /*.User and settings */
                    Div{
                        
                        Table{
                            Tr{
                                Td{
                                    
                                    Img()
                                        .src("skyline/media/user_configuration_icon.png")
                                        .height(100.px)
                                    
                                    Div("Tiendas y Usuarios")
                                        .textAlign(.center)
                                        .margin(all: 7.px)
                                        .color(.white)
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                        
                    }
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .height(150.px)
                    .width(150.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        addToDom(SystemSettings.UserStoreConfiguration())
                        self.remove()
                    }
                    
                    /* Website */
                    Div{
                        
                        Table{
                            Tr{
                                Td{
                                    
                                    Img()
                                        .src("skyline/media/website_icon.png")
                                        .height(100.px)
                                    
                                    Div("Pagina Web")
                                        .textAlign(.center)
                                        .margin(all: 7.px)
                                        .color(.white)
                                    
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                        
                    }
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .height(150.px)
                    .width(150.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        
                        guard let tcaccount else {
                            showError(.errorGeneral, "No se localizaron datos de la centa")
                            return
                        }
                        
                    
                        addToDom(WebPage(account: tcaccount))
                        
                        self.remove()
                    }
                    
                    
                }
                .padding(all: 3.px)
                .margin(all: 3.px)
                
            }
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .width(80.percent)
        .left(10.percent)
        .top(10.percent)
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
    }
    
    
    override public func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
