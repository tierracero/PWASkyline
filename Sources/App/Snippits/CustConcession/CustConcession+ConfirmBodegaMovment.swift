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

        let bodega: CustStoreBodegasQuick?

        let bodegas: [CustStoreBodegasQuick]

        let selectedItems:[CustPOCInventorySoldObject]
        
        private var moveItemsTo: ((
            _ items: CustPOCInventorySoldObject,
            _ alocatedTo: UUID?
        ) -> ())

        init(
            bodega: CustStoreBodegasQuick?,
            bodegas: [CustStoreBodegasQuick],
            selectedItems: [CustPOCInventorySoldObject],
            moveItemsTo: @escaping ((
                _ items: CustPOCInventorySoldObject,
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.bodega = bodega
            self.bodegas = bodegas
            self.selectedItems = selectedItems
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
                .value
            }

        @DOM override var body: DOM.Content {

            Div{
                /// Header
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
                
                Div{
                    
                    Span("Seleccione se la siguiente lista")
                        .color(.gray)
                    
                    Div()
                        .marginBottom(7.px)
                        .class(.clear)
                    
                    self.select
                    
                    Div()
                        .marginBottom(7.px)
                        .class(.clear)
                    
                    Div{

                        Div("Seleccionar Ubicación")
                            .class(.uibtnLargeOrange)
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
                .position(.relative)
                .overflow(.hidden)
                
            }
            .custom("left", "calc(50% - 274px)")
            .custom("top", "calc(50% - 274px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(500.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
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
                selectListener  =  bodega.id
            }

        }

        func selectNewPlacement () {

        }
 
    }
}