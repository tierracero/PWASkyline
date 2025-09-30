//
//  ToolsView+HistorySettings.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import Web

extension ToolsView {
 
    class HistorySettings: Div {
        
        override class var name: String { "div" }
        
        @State var departmentSelectListener = ""
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Sistema de Ajustes y Reportes")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                }
                
                Div{
                    
                }
                .custom("height","calc(100% - 35px)")
                .borderRadius(12.px)
                .marginTop(7.px)
                
            }
            .custom("height", "calc(100% - 124px)")
            .custom("width", "calc(100% - 124px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(50.px)
            .top(60.px)
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
extension ToolsView.HistorySettings {
    enum CuttentView {
        case reportView
        case settingsView
    }
}
