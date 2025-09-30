
//
//  Order+PrintPreView.swift
//  
//
//  Created by Victor Cantu on 11/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class PrintPreView: Div {
        
        override class var name: String { "div" }
        
        let order: CustOrderLoadFolioDetails
        
        private var printDocument: ((
        ) -> ())

        private var sendDocument: ((
        ) -> ())
        
        init(
            order: CustOrderLoadFolioDetails,
            printDocument: @escaping () -> Void,
            sendDocument: @escaping () -> Void
        ) {
            self.order = order
            self.printDocument = printDocument
            self.sendDocument = sendDocument
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }


        @DOM override var body: DOM.Content {
            /* Select Code */
            Div{
                
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.subView)
                            .onClick {
                                self.remove()
                            }
                        
                        H2("Orden Creada")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    Div {
                        Div{
                            // 314
                            
                            H2{
                                Span("ORDEN:")
                                    .marginRight(7.px)
                                    .color(.gray)

                                Span(self.order.folio)
                            }

                            Div().class(.clear).height(7.px)
                            
                            H2{
                                Span("CLIENTE:")
                                    .marginRight(7.px)
                                    .color(.gray)
                                Span(self.order.name)
                            }

                            Div().class(.clear).height(7.px)

                            H2{
                                Span("DATOS:")
                                    .marginRight(7.px)
                                    .color(.gray)
                            }

                            Div().class(.clear).height(7.px)
                            
                            H2{
                                Span(self.order.smallDescription)
                            }

                            Div().class(.clear).height(7.px)
                            

                        }
                        .width(50.percent)
                        .float(.left)

                        Div{

                            Div{

                                Div{

                                    Img()
                                        .src("/skyline/media/icon_print.png")
                                        .class(.iconWhite)
                                        .marginRight(3.px)
                                        .marginLeft(3.px)
                                        .paddingTop(7.px)
                                        .width(18.px)
                                        .float(.right)

                                    Span("Descargar")

                                }
                                .width(99.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick {
                                    self.printDocument()
                                    self.remove()
                                }

                                Div().class(.clear).height(7.px)

                                Div{

                                    Img()
                                        .src("/skyline/media/mail_sent.png")
                                        .class(.iconWhite)
                                        .marginRight(3.px)
                                        .marginLeft(3.px)
                                        .paddingTop(7.px)
                                        .width(18.px)
                                        .float(.right)

                                    Span("Enviar")

                                }
                                .width(99.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick {
                                    self.sendDocument()
                                    self.remove()
                                }

                                Div().class(.clear).height(7.px)

                            }.padding(all: 12.px)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                    
                        Div().class(.clear)

                    }

                }
                .padding(all: 12.px)

            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .width(40.percent)
            .left(30.percent)
            .top(25.percent)
            .color(.white)
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
        