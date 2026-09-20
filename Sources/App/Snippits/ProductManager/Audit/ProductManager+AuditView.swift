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
            VPopUp(.full) {

                VTitle("Sistema de auditoría", icon: "icon_report.png") {

                    Div()
                    .marginRight(7.px)
                    .float(.left)
                    .width(7.px)

                    switch self.auditType {
                    case .general:
                        if custCatchHerk > 2 {
                            self.auditTab("Inventarios", view: .inventoryView)
                        }
                        self.auditTab("Cardex", view: .productView)
                        self.auditTab("Transferencias", view: .tranfers)
                        self.auditTab("Mermas", view: .memrs)
                        self.auditTab("Actividad", view: .activity)

                    case .concessionaire(_):
                        USmallTitle("Inventario en concesión")
                    }

                    switch self.auditType {
                    case .general:
                        USmallTitle("Inventario y operaciones")
                    case .concessionaire(let custAcct):
                        USmallTitle("\(custAcct.folio) · \("\(custAcct.businessName) \(custAcct.firstName) \(custAcct.lastName)".purgeSpaces)")
                    }

                    Div {

                        Img()
                            .attribute("aria-hidden", "true")
                            .src("/skyline/media/zoom.png")
                            .custom("flex", "0 0 auto")
                            .class(.iconBlue)
                            .height(24.px)

                        Span("Compras")

                    }
                        .class(.uibtnLargeOrange)
                        .marginRight(7.px)
                        .marginTop(0.px)
                        .fontSize(23.px)
                        .float(.right)
                        .onClick {
                            self.openPurchaseHistory()
                        }

                } onClose: {
                    self.remove()
                }

                VBodyGrid {

                    VGrid(.full) {

                        Div {
                            Inventory(auditType: self.auditType)
                        }
                        // .class(Class(TCCrystalSurfaceClass.auditPanel))
                        .custom("height", "100%")
                        .custom("min-height", "0")
                        .custom("overflow", "visible")
                        .hidden(self.$currentView.map{ $0 != .inventoryView })

                        switch self.auditType {
                        case .general:
                            Div {
                                Products()
                            }
                            // .class(Class(TCCrystalSurfaceClass.auditPanel))
                            .hidden(self.$currentView.map{ $0 != .productView })

                            Div {
                                Transfers()
                            }
                            // .class(Class(TCCrystalSurfaceClass.auditPanel))
                            .hidden(self.$currentView.map{ $0 != .tranfers })

                            Div {
                                Merms()
                            }
                            // .class(Class(TCCrystalSurfaceClass.auditPanel))
                            .hidden(self.$currentView.map{ $0 != .memrs })

                            Div {
                                Activity()
                            }
                            .custom("height", "100%")
                            .custom("min-height", "0")
                            .custom("overflow", "hidden")
                            // .class(Class(TCCrystalSurfaceClass.auditPanel))
                            .hidden(self.$currentView.map{ $0 != .activity })

                        case .concessionaire(_):
                            Div()
                        }
                        
                    }
                    .class(Class(TCCrystalSurfaceClass.auditPanelHost))
                }
                .class(Class(TCCrystalSurfaceClass.auditBody))
                .id(.init("bodyGrid"))
                .display(.block)
            }
            .class(Class(TCCrystalSurfaceClass.auditPopup))
        }

        fileprivate func auditTab(_ title: String, view: CuttentView) -> H2 {
            /*
            USmallButton(title)
                .class(Class(TCCrystalSurfaceClass.auditTab))
                .borderBottom(
                    width: .medium,
                    style: self.$currentView.map { $0 == view ? .solid : .none },
                    color: .lightBlue
                )
                .color(self.$currentView.map { $0 == view ? .lightBlue : .gray })
                .attribute("aria-label", "Mostrar \(title.lowercased())")
                .onClick {
                    self.currentView = view
                }
            */

            H2(title)
                .borderBottom(width: .thin, style: self.$currentView.map{($0 == view) ? .solid : .none }, color: .lightBlue)
                .color(self.$currentView.map{ ($0 == view) ? .lightBlue : .gray })
                .marginRight(12.px)
                .cursor(.pointer)
                .float(.left)
                .onClick {
                    self.currentView = view
                }
        }

        fileprivate func openPurchaseHistory() {
            let view = SearchHistoricalPurchaseView(close: {
                self.searchHistoricalPurchaseView?.remove()
                self.searchHistoricalPurchaseView = nil
            }, minimize: {
            })

            view.minimizeButton.hidden(true)
            searchHistoricalPurchaseView = view
            addToDom(view)
        }
        
        override func buildUI() {
            super.buildUI()
            
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            self.class(Class(TCCrystalSurfaceClass.auditWorkspace))
            CrystalTheme.apply(to: self)
            
            switch auditType {
            case .general:
                if custCatchHerk > 2 {
                    currentView = .inventoryView
                }
            case .concessionaire(_):
                currentView = .inventoryView
            }
            
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $currentView.removeAllListeners()
            $departmentSelectListener.removeAllListeners()
        }
    }
}

extension ProductManagerView.AuditView {
    enum CuttentView {
        case productView
        case inventoryView
        case tranfers
        case memrs
        case activity
    }
    
    enum AuditType {
        
        /// Escaneo general de consesion
        case general
        
        case concessionaire(CustAcct)
        
    }
    
}
