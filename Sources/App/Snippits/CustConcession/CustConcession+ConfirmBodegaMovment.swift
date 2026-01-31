//
// CustConcession+ConfirmBodegaMovment.swift
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class ConfirmBodegaMovment: Div {
    
        override class var name: String { "div" }

        let accountId: UUID

        let bodega: CustStoreBodegasQuick?

        let bodegas: [CustStoreBodegasQuick]

        let selectedItems:[CustPOCInventorySoldObject]

        let pocs:[CustPOCQuick]
        
        private var moveItemsTo: ((
            _ items: [CustPOCInventorySoldObject],
            _ alocatedTo: UUID?
        ) -> ())

        init(
            accountId: UUID,
            bodega: CustStoreBodegasQuick?,
            bodegas: [CustStoreBodegasQuick],
            selectedItems: [CustPOCInventorySoldObject],
            pocs: [CustPOCQuick],
            moveItemsTo: @escaping ((
                _ items: [CustPOCInventorySoldObject],
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.accountId = accountId
            self.bodega = bodega
            self.bodegas = bodegas
            self.selectedItems = selectedItems
            self.pocs = pocs
            self.moveItemsTo = moveItemsTo
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var selectId: UUID? = nil

        @State var selectListener = ""
        
        lazy var select = Select($selectListener)
            .class(.textFiledBlackDarkLarge)
            .marginBottom(7.px)
            .width(99.percent)
            .fontSize(32.px)
            .height(48.px)
            .body {
                Option( (self.bodega == nil) ? "Mantener en General" : "Mover a General" )
                .value("")
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
                    
                    H2("Seleccione nueva hubicación")
                        .color(.lightBlueText)
                        .height(35.px)
                    
                }
                
                Div {
                    // MARK:  Item Preview
                    Div{
                        Div {
                            H3("Productos")
                                .color(.white)

                                Div()
                                    .height(7.px)
                                    .class(.clear)

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
                        .margin(all: 7.px)
                    }
                    .width(60.percent)
                    .overflow(.auto)
                    .float(.left)

                    // MARK:  Bodega seleccion && details
                    Div{

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

                        Div()
                            .height(7.px)
                            .class(.clear)

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

                        Div()
                            .height(7.px)
                            .class(.clear)

                        Span("Seleccione de la siguiente lista")
                            .color(.gray)
                        
                        Div()
                            .height(7.px)
                            .class(.clear)
                        
                        self.select
                        
                        Div()
                            .height(7.px)
                            .class(.clear)
                        
                        Div{

                            Div("Seleccionar Ubicación")
                                .class(.uibtnLargeOrange)
                                .opacity(0.5)
                                .cursor(.default)
                                .hidden( self.$selectId.map{  $0 !=  self.bodega?.id } )

                            Div("Mover Productos")
                                .class(.uibtnLargeOrange)
                                .hidden( self.$selectId.map{  $0 ==  self.bodega?.id } )
                                .onClick {
                                    
                                    self.selectNewPlacement()
                                    
                                }
                        }
                        .align(.right)

                    }
                    .width(40.percent)
                    .float(.left)
                }
                
            }
            .custom("left", "calc(50% - 424px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
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

            bodegas.forEach { bodega in
                select.appendChild(
                    Option(bodega.name)
                        .value(bodega.id.uuidString)
                )
            }

            $selectListener.listen {
                self.selectId = UUID(uuidString: $0)
            }

            if let bodega {
                selectListener  =  bodega.id.uuidString
            }

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

        func selectNewPlacement () {

            let view = ConfirmationView(
                type: ConfirmViewButton.yesNo,
                title: "Confirme Accion",
                message: "Va acambiar \(self.selectedItems.count) piezas"
            ) { isConfirmed, comment in

                if isConfirmed {

                    loadingView(show: true)

                    API.custPOCV1.moveConcessionInventory(
                        accountId: self.accountId,
                        itemIds: self.selectedItems.map{  $0.id },
                        bodegaId: self.selectId
                    ) { resp in

                        loadingView(show: false)


                        guard let resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else {
                            showError(.generalError, resp.msg)
                            return
                        }

                        self.moveItemsTo(
                            self.selectedItems,
                            self.selectId
                        )

                        self.remove()

                    }
                }

            }

            addToDom(view)

        }
 
    }
}