//
//  HistorySettings+OrderProcessing.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import Web

extension ToolsView.HistorySettings {
    
    class OrderProcessing: Div {
        
        override class var name: String { "div" }
        
        @State var currentView: CuttentView = .reportView
        
        var searchHistoricalPurchaseView: SearchHistoricalPurchaseView? =  nil
        
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
                    
                    H2("Ajustes y Auditoria del Sistea de Ordenes")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                    if custCatchHerk > 2 {
                        
                        H2("Ajustes")
                            .borderBottom(width: .thin, style: self.$currentView.map{($0 == .settingsView) ? .solid : .none }, color: .lightBlue)
                            .color(self.$currentView.map{ ($0 == .settingsView) ? .lightBlue : .gray })
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .float(.right)
                            .onClick {
                                self.currentView = .settingsView
                            }
                    }
                    
                    H2("Reportes")
                        .borderBottom(width: .thin, style: self.$currentView.map{($0 == .reportView) ? .solid : .none }, color: .lightBlue)
                        .color(self.$currentView.map{ ($0 == .reportView) ? .lightBlue : .gray })
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .float(.right)
                        .onClick {
                            self.currentView = .reportView
                        }
                    
                    Div().class(.clear)

                }
                
                Div{
                    Reports()
                }
                .hidden(self.$currentView.map{ $0 != .reportView })
                .custom("height","calc(100% - 35px)")
                .borderRadius(12.px)
                .marginTop(7.px)
                
                Div{
                    
                }
                .hidden(self.$currentView.map{ $0 != .settingsView })
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

