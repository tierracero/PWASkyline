//
//  MoneyManager+NewDailyCut+SelectUserView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.NewDailyCutView {
    
    class NewDailyCutSelectUserView: Div {
        
        override class var name: String { "div" }
        
        private var callback: ((
            _ user: API.custAPIV1.UserList
        ) -> ())
        
        init(
            callback: @escaping ((
                _ user: API.custAPIV1.UserList
            ) -> ())
        ) {
            self.callback = callback
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var users: [API.custAPIV1.UserList] = []
        
        @DOM override var body: DOM.Content {
            //Select Code
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Seleccione Servicio")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    ForEach(self.$users){ user in
                        Div{
                            Strong(user.name)
                                .fontSize(24.px)
                                .color(.white)
                            
                            Div().clear(.both).height(7.px)
                            
                            Span(user.user)
                                .color(.gray)
                            
                        }
                        .custom("width", "calc(100% - 24px)")
                        .class(.uibtnLarge, .oneLineText)
                        .onClick {
                            self.callback(user)
                            self.remove()
                        }
                    }
                }
                .maxHeight(500.px)
                .overflow(.auto)
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(40.percent)
            .left(30.percent)
            .top(20.percent)
            .color(.white)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custAPIV1.dailyCutSelectUser { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.generalError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                guard let payload = resp.data else {
                    showError(.unexpectedResult, .payloadDecodError)
                    return
                }
                
                self.users = payload.users
                   
            }
        }
    }
}

