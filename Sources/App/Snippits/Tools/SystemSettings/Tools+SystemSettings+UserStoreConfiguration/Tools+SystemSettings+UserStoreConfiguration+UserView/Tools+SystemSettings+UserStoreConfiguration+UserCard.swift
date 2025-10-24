//
//  Tools+SystemSettings+UserStoreConfiguration+UserCard.swift
//
//
//  Created by Victor Cantu on 6/9/24.
// 

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class UserCard: Div {
        
        override class var name: String { "div" }
        
        let user: CustUsernameMin
        
        let snippit: CustUsernamePreformanceSnippets?
        
        private var callback: ((
            _ view: ToolsView.SystemSettings.UserStoreConfiguration.UserCard
        ) -> ())
        
        init(
            user: CustUsernameMin,
            snippit: CustUsernamePreformanceSnippets?,
            callback: @escaping ((
                _ view: ToolsView.SystemSettings.UserStoreConfiguration.UserCard
            ) -> ())
        ) {
            self.user = user
            self.snippit = snippit
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// general, supervisor, manager, gmanager, owner
        @State var role: UsernameRoles = .general
        
        /// active, suspended, canceled
        @State var status: UsernameStatus = .active
        
        @State public var nick: String = ""
        
        @State var assistance: Int = 0
        
        @State var incidence: Int = 0
        
        @State var ppmanager: Int = 0
        
        @State var qareport: Int = 0
        
        @DOM override var body: DOM.Content {
            Div{

                Div{
                    
                    Span(self.$role.map{ $0.description })
                        .color(.white)
                    
                    Span(self.user.MID)
                        .float(.right)
                        .color(.white)
                    
                }
                
                Div().clear(.both).height(3.px)
                
                Div{
                    
                    Div{
                        
                        Div().clear(.both).height(3.px)
                        
                        // Faltas / Retardos
                        Div{
                            
                            Div("Faltas / Retardos")
                                .class(.oneLineText)
                                .width(70.percent)
                                .color(.white)
                                .float(.left)
                            
                            Div{
                                Span(self.$assistance.map{ $0.toString })
                                    .marginRight(3.px)
                                    .color(.white)
                            }
                                .class(.oneLineText)
                                .textAlign(.right)
                                .width(30.percent)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(3.px)
                        
                        // Incidencia
                        Div{
                            
                            Div("Incidencias")
                                .class(.oneLineText)
                                .width(70.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                Span(self.$incidence.map{ $0.toString })
                                    .marginRight(3.px)
                                    .color(.white)
                            }
                                .class(.oneLineText)
                                .textAlign(.right)
                                .width(30.percent)
                                .color(.white)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(3.px)
                        
                        // Prodccion Points
                        Div{
                            
                            Div("Puntos de productividad")
                                .class(.oneLineText)
                                .width(70.percent)
                                .color(.white)
                                .float(.left)
                            Div{
                                Span(self.$ppmanager.map{ $0.toString })
                                    .marginRight(3.px)
                                    .color(.white)
                            }
                                .class(.oneLineText)
                                .textAlign(.right)
                                .width(30.percent)
                                .color(.white)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(3.px)
                        
                        // Calidad
                        Div{
                            
                            Div("Calidad")
                                .class(.oneLineText)
                                .width(70.percent)
                                .color(.white)
                                .float(.left)
                            
                            Div{
                                Span(self.$qareport.map{ $0.toString })
                                    .marginRight(3.px)
                                    .color(.white)
                            }
                                .class(.oneLineText)
                                .textAlign(.right)
                                .width(30.percent)
                                .color(.white)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(3.px)
                    }
                    .height(100.percent)
                    .width(70.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{

                            Img()
                                .src("/skyline/media/mobileCamara.png")
                                .height(22.px)
                                .class(.iconWhite)
                                .marginLeft(7.px)
                                .cursor(.pointer)
                                .onClick { _, event in
                                    
                                    let eventid = UUID()
                                    
                                    API.custAPIV1.requestMobileCamara(
                                        type: .useCamaraForUser,
                                        connid: custCatchChatConnID,
                                        eventid: eventid,
                                        relatedid: self.user.id,
                                        relatedfolio: "",
                                        multipleTakes: false
                                    ) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp else {
                                            showError(.errorDeCommunicacion, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            showError(.errorGeneral, resp.msg)
                                            return
                                        }
                                        
                                        showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                                        
                                    }
                                }
                
                            Img()
                                .src("/skyline/media/icon_clip.png")
                                .height(22.px)
                                .class(.iconWhite)
                                .marginLeft(7.px)
                                .cursor(.pointer)
                                .onClick { _, event in
                                    //self.msgFileLoader.click()
                                }
            
                        }

                        Div{
                            Img()
                                .src("/skyline/media/default_panda.jpeg")
                                .custom("aspect-ratio", "1/1")
                                .width(100.percent)
                                .borderRadius(7.px)
                                .objectFit(.cover)
                        }
                        .width(100.percent)
                        .margin(all: 7.px)
                    }
                    .height(100.percent)
                    .width(30.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .height(120.px)
                
                Div().height(7.px)
                
                Div{
                    Span("username")
                        .color(.gray)
                    
                    Div().height(3.px)
                    
                    Div(self.user.username)
                        .class(.oneLineText)
                        .width(293.px)
                        .color(.white)
                }
                .width(50.percent)
                .float(.left)

                Div{
                    Span("nombre")
                        .color(.gray)
                    
                    Div().height(3.px)
                    
                    Div(self.$nick.map{ $0.isEmpty ? "-- Sin Nombre --" : $0 })
                        .color(.white)
                }
                .width(50.percent)
                .float(.left)
                
                Div().clear(.both).height(3.px)
                
            }
            .backgroundColor(.grayBlackDark)
            .borderRadius(7.px)
            .padding(all: 3.px)
            .cursor(.pointer)
            .onClick {
                self.callback(self)
            }
        }
        
        override func buildUI() {
            super.buildUI()
            
            custom("width", "calc(50% - 14px)")
            maxWidth(400.px)
            minWidth(300.px)
            margin(all: 7.px)
            float(.left)
        
            role = user.role
            
            status = user.status
            
            nick = user.nick
            
            if !user.avatar.isEmpty {
                
            }
            
        }
    }
}
