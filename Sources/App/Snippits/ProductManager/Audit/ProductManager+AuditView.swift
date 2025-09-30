//
//  ProductManager+AuditView.swift
//  
//
//  Created by Victor Cantu on 8/26/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView {
    
    class AuditView: Div {
        
        override class var name: String { "div" }
        
        var auditType: AuditType
        
        init(
            auditType: AuditType
        ) {
            self.auditType = auditType
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var currentView: CuttentView = .productView
        
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
                    
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/zoom.png")
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .height(18.px)
                        }
                        .marginRight(12.px)
                        .paddingTop(3.px)
                        .float(.left)
                        
                        Label("Compras")
                            .marginRight(7.px)
                    }
                    .padding(all: 3.px)
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(-7.px)
                    .cursor(.pointer)
                    .fontSize(22.px)
                    .float(.right)
                    .onClick {
                        
                        let view = SearchHistoricalPurchaseView(close: {
                            self.searchHistoricalPurchaseView?.remove()
                            self.searchHistoricalPurchaseView = nil
                        }, minimize: {
                            
                        })
                        
                        view.minimizeButton.hidden(true)
                        
                        self.searchHistoricalPurchaseView = view
                        
                        addToDom(view)
                    }
                    
                    H2("Sistema de auditoria")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                    switch self.auditType {
                    case .general:
                        
                        if custCatchHerk > 2 {
                            
                            H2("Inventarios")
                                .borderBottom(width: .thin, style: self.$currentView.map{($0 == .inventoryView) ? .solid : .none }, color: .lightBlue)
                                .color(self.$currentView.map{ ($0 == .inventoryView) ? .lightBlue : .gray })
                                .marginRight(12.px)
                                .cursor(.pointer)
                                .float(.left)
                                .onClick {
                                    self.currentView = .inventoryView
                                }
                        }
                        
                        H2("Cardex")
                            .borderBottom(width: .thin, style: self.$currentView.map{($0 == .productView) ? .solid : .none }, color: .lightBlue)
                            .color(self.$currentView.map{ ($0 == .productView) ? .lightBlue : .gray })
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.currentView = .productView
                            }
                        
                        H2("Tranfersencias")
                            .borderBottom(width: .thin, style: self.$currentView.map{($0 == .tranfers) ? .solid : .none }, color: .lightBlue)
                            .color(self.$currentView.map{ ($0 == .tranfers) ? .lightBlue : .gray })
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.currentView = .tranfers
                            }

                        H2("Mermas")
                            .borderBottom(width: .thin, style: self.$currentView.map{($0 == .memrs) ? .solid : .none }, color: .lightBlue)
                            .color(self.$currentView.map{ ($0 == .memrs) ? .lightBlue : .gray })
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.currentView = .memrs
                            }
                        
                    case .concessionaire(let custAcct):
                        H2("\(custAcct.folio) \(custAcct.businessName) \(custAcct.firstName) \(custAcct.lastName)")
                            .color(.white)
                    }
                    
                    Div().class(.clear)

                }
                
                Div{
                    Inventory(auditType: self.auditType)
                }
                .hidden(self.$currentView.map{ $0 != .inventoryView })
                .custom("height","calc(100% - 35px)")
                .borderRadius(12.px)
                .marginTop(7.px)
                
                switch self.auditType {
                case .general:
                    
                    Div{
                        Products()
                    }
                    .hidden(self.$currentView.map{ $0 != .productView })
                    .custom("height","calc(100% - 35px)")
                    .borderRadius(12.px)
                    .marginTop(7.px)
                    
                    Div{
                        Transfers()
                    }
                    .hidden(self.$currentView.map{ $0 != .tranfers })
                    .custom("height","calc(100% - 35px)")
                    .borderRadius(12.px)
                    .marginTop(7.px)
                    
                    Div{
                        Merms()
                    }
                    .hidden(self.$currentView.map{ $0 != .memrs })
                    .custom("height","calc(100% - 35px)")
                    .borderRadius(12.px)
                    .marginTop(7.px)
                    
                    
                case .concessionaire(let _):
                    Div()
                }
                
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
            
            if custCatchHerk > 2 {
                currentView = .inventoryView
            }
            
            
        }
    }
}

extension ProductManagerView.AuditView {
    enum CuttentView {
        case productView
        case inventoryView
        case tranfers
        case memrs
    }
    
    enum AuditType {
        
        /// Escaneo general de consesion
        case general
        
        case concessionaire(CustAcct)
        
    }
    
}
