//
// CustConcession+ConfirmOrderMovment.swift
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class ConfirmOrderMovment: Div {
    
        override class var name: String { "div" }

        let accountId: UUID

        let bodegaId: UUID?

        let order: CustOrderLoadFolios

        let selectedItems:[CustPOCInventorySoldObject]

        let pocs:[CustPOCQuick]
        
        private var moveItemsTo: ((
            _ items: [CustPOCInventorySoldObject]
        ) -> ())

        init(
            accountId: UUID,
            bodegaId: UUID?,
            order: CustOrderLoadFolios,
            selectedItems: [CustPOCInventorySoldObject],
            pocs: [CustPOCQuick],
            moveItemsTo: @escaping ((
                _ items: [CustPOCInventorySoldObject]
            ) -> ())
        ) {
            self.accountId = accountId
            self.bodegaId = bodegaId
            self.order = order
            self.selectedItems = selectedItems
            self.pocs = pocs
            self.moveItemsTo = moveItemsTo
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        lazy var productContainer = TBody()

        var pocRefrence: [UUID:CustPOCQuick] = [:]

        @DOM override var body: DOM.Content {

            Div{
                // MARK:  Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Mover produtos a orden")
                        .color(.lightBlueText)
                        .height(35.px)
                    
                }
                
                Div {
                    // MARK:  Item Preview
                    Div{

                        H3("Productos")
                            .color(.white)

                        Div().height(7.px).class(.clear)

                        Div {

                            Div{
                                Table {
                                    THead {
                                        Tr {
                                            Td("Unidades")
                                            Td("UPC")
                                            Td("Descripcion")
                                            Td("Total")
                                        }
                                    }
                                    self.productContainer
                                }
                                .color(.white)
                            }
                            .padding(all: 7.px)

                        }
                        .custom("height", "calc(100% - 35px)")
                        .class(.roundDarkBlue)
                        .overflow(.auto)
                        
                    }
                    .height(100.percent)
                    .width(57.percent)
                    .overflow(.auto)
                    .float(.left)

                    Div()
                    .height(100.percent)
                    .width(3.percent)
                    .float(.left)

                    // MARK:  Bodega seleccion && details
                    Div{

                        Div{
                            // ADD_ORDER_DATA
                            H3("Orden")
                                .color(.white)
                            
                            Div().height(7.px).class(.clear)
                            
                            Div {
                                
                                Div {

                                    Div {
                                        Label("Folio")
                                            .color(.gray)
                                        
                                        Div().class(.clear).height(4.px)
                                        
                                        Div(self.order.folio)
                                            .class(.textFiledBlackDark, .oneLineText)
                                            .padding(all: 10.px)
                                            .color(.white)
                                    }
                                    .width(49.percent)
                                    .float(.left)

                                    Div()
                                    .width(2.percent)
                                    .height(35.px)
                                    .float(.left)

                                    Div {
                                        Label("Fecha de Creacion")
                                            .color(.gray)
                                        
                                        Div().class(.clear).height(4.px)
                                        
                                        Div(getDate(self.order.createdAt).formatedLong)
                                            .class(.textFiledBlackDark, .oneLineText)
                                            .padding(all: 10.px)
                                            .color(.white)
                                    }
                                    .width(49.percent)
                                    .float(.left)
                                    
                                    Div().clear(.both)
                                    
                                }

                                Div().class(.clear).height(7.px)
                                
                                Div {
                                    Label("Nombre")
                                        .color(.gray)
                                    
                                    Div().class(.clear).height(4.px)
                                    
                                    Div(self.order.name)
                                        .class(.textFiledBlackDark, .oneLineText)
                                        .padding(all: 10.px)
                                        .color(.white)
                                }
                                
                                Div().class(.clear).height(7.px)
                                
                                Div {
                                    Label("Direccion")
                                        .color(.gray)
                                    
                                    Div().class(.clear).height(4.px)
                                    
                                    Div(self.order.address)
                                        .class(.textFiledBlackDark)
                                        .custom("height", "auto")
                                        .padding(all: 10.px)
                                        .color(.white)
                                }
                                
                            }
                            .padding(all: 7.px)
                            .class(.roundDarkBlue)
                        }

                        Div().height(7.px).class(.clear)

                        Div{
                            
                            Div{
                                H3("Unidades:")
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                H3(self.selectedItems.count.toString)
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }

                        Div().height(7.px).class(.clear)

                        Div{
                            Div{
                                H3("Total:")
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)
                            Div{
                                H3(self.selectedItems.map{ ($0.soldPrice ?? 0) }.reduce(0,+).formatMoney)
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }

                        Div().height(7.px).class(.clear)

                        Div{

                            Div("Agregar a Orden")
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    self.addToOrder()
                                }
                        }
                        .align(.right)

                    }
                    .width(40.percent)
                    .float(.left)
                }
                .custom("height", "calc(100% - 35px)")
                
            }
            .custom("left", "calc(50% - 424px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(500.px)
            .width(800.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            pocs.forEach { poc in
                pocRefrence[poc.id] = poc
            }

            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            var itemRefrence: [ UUID : [CustPOCInventorySoldObject] ] = [:]

            selectedItems.forEach{ item in
                if let _ = itemRefrence[item.POC] {
                    itemRefrence[item.POC]?.append(item)
                }
                else {
                    itemRefrence[item.POC] = [item]
                }
            }

            itemRefrence.forEach { pocId, items in 

                guard let data = self.pocRefrence[pocId] else {
                    return
                }

                self.productContainer.appendChild(Tr{
                    Td(items.count.toString)
                    Td(data.upc)
                    Td("\(data.name) \(data.model) ")
                    Td( items.map{ ($0.soldPrice ?? 0) }.reduce(0, +).formatMoney )
                }) 

            }

        }

        func addToOrder() {

            loadingView(show: true)

            API.custPOCV1.moveConcessionInventoryToOrder(
                accountId: self.accountId,
                bodegaId: self.bodegaId,
                orderId: self.order.id,
                itemIds: self.selectedItems.map{ $0.id }
            ) { resp in

                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                self.moveItemsTo(self.selectedItems)

                self.remove()


            }

        }

    }
}
