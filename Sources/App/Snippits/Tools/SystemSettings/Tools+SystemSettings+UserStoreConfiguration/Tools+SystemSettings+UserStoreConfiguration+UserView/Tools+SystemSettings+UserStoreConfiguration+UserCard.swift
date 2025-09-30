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
                
                Div().marginTop(3.px)
                
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
                    .width(170.px)
                    .float(.left)
                    
                    Div{
                        Img()
                            .src("/skyline/media/default_panda.jpeg")
                            .borderRadius(7.px)
                            .height(128.px)
                            .width(128.px)
                    }
                    .width(128.px)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                
                Div().marginTop(3.px)
                
                Span("username")
                    .color(.gray)
                
                Div().marginTop(1.px)
                
                Div(self.user.username)
                    .class(.oneLineText)
                    .width(293.px)
                    .color(.white)
                
                Div().marginTop(3.px)
                
                Span("nombre")
                    .color(.gray)
                
                Div().marginTop(1.px)
                
                Div(self.$nick.map{ $0.isEmpty ? "-- Sin Nombre --" : $0 })
                    .color(.white)
                
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
