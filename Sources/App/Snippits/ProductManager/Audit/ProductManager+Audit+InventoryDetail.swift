//
//  ProductManager+Audit+InventoryDetail.swift
//  
//
//  Created by Victor Cantu on 1/24/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class InventoryDetail: Div {
        
        override class var name: String { "div" }
        
        let poc: CustPOCQuick
        
        let item: API.custPOCV1.AuditObject
        
        init(
            poc: CustPOCQuick,
            item: API.custPOCV1.AuditObject
        ) {
            self.poc = poc
            self.item = item
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        lazy var tableBody = TBody()
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Sistema de auditoria")
                        .color(.lightBlueText)
                        .marginRight(12.px)
                        .float(.left)
                    
                    Div().class(.clear)

                }
                Table {
                    THead {
                        Tr{
                            Td("POC/SKU/UPC")
                            Td("Nombre")
                            Td("Marca")
                            Td("Modelo")
                            Td("DiaZero")
                            Td("Actual")
                            Td("Vendido")
                            Td("Costo")
                            Td("Precio")
                        }
                    }
                    self.tableBody
                }
                .marginBottom(24.px)
                .width(100.percent)
                .color(.white)
                
            }
            .custom("height", "calc(100% - 224px)")
            .custom("width", "calc(100% - 224px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(100.px)
            .top(100.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
            
            let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
            
            tableBody.appendChild(Tr{
                Td(self.poc.upc ?? "N/D")
                Td(self.poc.name ?? "N/D")
                Td(self.poc.brand ?? "N/D")
                Td(self.poc.model ?? "N/D")
                Td(self.item.zeroDay?.toString ?? "---")
                Td((self.item.currentStock ?? 0).toString)
                Td(self.item.items.count.toString)
                Td(itemCostTotal.formatMoney)
                Td(itemPriceTotal.formatMoney)
            }.backgroundColor(.backGroundRow))
            
            self.item.items.forEach { item in
                
                tableBody.appendChild(Tr{
                    Td("Serie")
                    Td("\(item.id.suffix) \(item.series)".purgeSpaces)
                        .colSpan(6)
                    Td(item.cost.formatMoney)
                    Td(item.price.formatMoney)
                })
                
            }
            
        }
    }
}
