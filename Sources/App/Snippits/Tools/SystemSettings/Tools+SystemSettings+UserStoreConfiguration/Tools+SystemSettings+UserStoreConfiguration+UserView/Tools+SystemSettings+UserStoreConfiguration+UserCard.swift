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
        
        lazy var  avatar = Img()
                .src("/skyline/media/default_panda.jpeg")
                .custom("aspect-ratio", "1/1")
                .width(100.percent)
                .borderRadius(7.px)
                .objectFit(.cover)

        @DOM override var body: DOM.Content {
            Div {
                Div {
                    self.avatar
                }
                    .class(Class(TCStoreUserConfigurationClass.userAvatar))

                Div {
                    Span(self.$nick.map { $0.isEmpty ? "-- Sin Nombre --" : $0 })
                        .class(Class(TCStoreUserConfigurationClass.userName))
                    Span(self.user.username)
                        .class(Class(TCStoreUserConfigurationClass.userUsername))
                }
                    .class(Class(TCStoreUserConfigurationClass.userIdentity))

                Span(self.$role.map { $0.description })
                    .class(Class(TCStoreUserConfigurationClass.rolePill))

                Span(self.$status.map { $0.description })
                    .class(Class(TCStoreUserConfigurationClass.statusPill))
            }
                .class(Class(TCStoreUserConfigurationClass.userRow))
                .onClick {
                    self.callback(self)
                }
        }
        
        override func buildUI() {
            super.buildUI()
            
            width(100.percent)
            maxWidth(100.percent)
            minWidth(0.px)
            margin(all: 0.px)
        
            role = user.role
            
            status = user.status
            
            nick = user.nick
            
            if !user.avatar.isEmpty {
                avatar.load("https://\(custCatchUrl)\(skylineUrlPatch)/contenido/\(user.avatar)")
            }
            
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $role.removeAllListeners()
            $status.removeAllListeners()
            $nick.removeAllListeners()
            $assistance.removeAllListeners()
            $incidence.removeAllListeners()
            $ppmanager.removeAllListeners()
            $qareport.removeAllListeners()
        }
    }
}
