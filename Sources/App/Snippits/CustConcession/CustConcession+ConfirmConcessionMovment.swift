//
// CustConcession+ConfirmConcessionMovment.swift
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class ConfirmConcessionMovment: Div {
    
        override class var name: String { "div" }


        let account: CustAcct
        
        let newDocumentName: String

        let vendor: CustVendorsQuick

        let profile: FiscalComponents.Profile

        let items: [CreateManualProductObject]
        
        private var callback: (() -> ())

        init(
            account: CustAcct,
            newDocumentName: String,
            vendor: CustVendorsQuick,
            profile: FiscalComponents.Profile,
            items: [CreateManualProductObject],
            callback: @escaping (() -> ())
        ) {
            self.account = account
            self.newDocumentName = newDocumentName
            self.vendor = vendor
            self.profile = profile
            self.items = items
            self.callback = callback
        }

        required init() {
            fatalError("init() has not been implemented")
        }
         
        lazy var productContainer = TBody()

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
                                H3("Productos:")
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                H3(self.items.count.toString)
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
                                H3("Unidades:")
                                .color(.white)
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                H3(self.items.map{ $0.units.count }.reduce(0,+).toString)
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
                                H3(self.items.map{ ($0.price ?? 0) * $0.units.count.toInt64 }.reduce(0,+).formatMoney)
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

                            Div("Mover Productos")
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    
                                    self.callback()
                                    
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
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            items.forEach { item in 

                self.productContainer.appendChild(Tr{
                    Td(item.units.count.toString)
                    Td(item.description)
                        .colSpan(2)
                    Td(item.units.count.toString)
                    Td( ( item.units.count.toInt64 * (item.price ?? 0.toInt64) ).formatMoney )
                }) 

            }
        }
    }
}