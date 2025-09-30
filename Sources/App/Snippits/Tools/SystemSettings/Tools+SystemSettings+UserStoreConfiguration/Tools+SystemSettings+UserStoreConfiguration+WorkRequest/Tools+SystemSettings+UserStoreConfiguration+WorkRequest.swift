//
//  Tools+UserStoreConfiguration+WorkRequestAndProfileControles.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class WorkRequest: Div {
        
        override class var name: String { "div" }
        
        private var userCreated: ((
            _ user: CustUsername
        ) -> ())

        init(
            userCreated: @escaping ((
                _ user: CustUsername
            ) -> ())
        ) {
            self.userCreated = userCreated
        }

        required init() {
          fatalError("init() has not been implemented")
        }

        
        
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    Div("Archivadas")
                    .class(.uibtnLargeOrange)
                    .marginRight(12.px)
                    .marginTop(-3.px)
                    .fontSize(18.px)
                    .float(.right)
                    .onClick {
                        
                    }
                    
                    H2("Solicitudes de Trabajo")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    
                }
                .custom("height", "calc(100% - 35px)")
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
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
        }
    }
}
