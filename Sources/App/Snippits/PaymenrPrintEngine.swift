//
//  PaymenrPrintEngine.swift
//
//
//  Created by Victor Cantu on 6/27/26.
//

import Foundation
import TCFundamentals
import Web

class PaymenrPrintEngine: Div {
    
    override class var name: String { "div" }
    
    let order: CustOrderLoadFolioDetails?
    
    let payment: CustAcctPayments
    
    let oldbalance: Int64
    
    let newbalance: Int64
    
    let status: CustFolioStatus
    
    init(
        order: CustOrderLoadFolioDetails?,
        payment: CustAcctPayments,
        oldbalance: Int64,
        newbalance: Int64,
        status: CustFolioStatus
    ) {
        self.order = order
        self.payment = payment
        self.oldbalance = oldbalance
        self.newbalance = newbalance
        self.status = status
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var logo = "/skyline/media/logoTierraCeroLongBlack.svg"
    
    lazy var storeData = Div{
        Strong("Recibo de Pago")
            .fontSize(16.px)
    }

    lazy var storeDataCopy = Div{
        Strong("Recibo de Pago")
            .fontSize(16.px)
    }
    
    lazy var paymentData = Table()
        .width(100.percent)

    lazy var paymentDataCopy = Table()
        .width(100.percent)
        
    
    @DOM override var body: DOM.Content {
        
        switch configStore.print.document {
        case .letter, .halfLetter:

            Div {
                self.headerView()
                
                Div().height(18.px)
                
                self.customerView()
                
                Div().height(18.px)
                
                self.paymentData
                
                Div().height(50.px)
                
                self.signatureView()
            }
            .padding(all: 18.px)
            .height(470.px)
            .overflowX(.hidden)

            Div {
                self.headerViewCopy()
                
                Div().height(18.px)
                
                self.customerView()
                
                Div().height(18.px)
                
                self.paymentDataCopy
                
                Div().height(50.px)
                
                self.signatureView()
            }
            .padding(all: 18.px)
            .height(470.px)
            .overflowX(.hidden)
            
        case .miniprinter:
            Div {
                self.headerView()
                
                Br()
                
                self.customerView()
                
                Br()
                
                self.paymentData
                
                Br()
                
                self.signatureView()
            }
            .width(300.px)
            
        case .pdf:
            H1("Documento no soportado")
        }
    }
    
    override func buildUI() {
        super.buildUI()
        
        if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            if !_logo.isEmpty {
                logo = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/\(_logo)"
            }
        }
        
        if let cstore = payment.store {
            stores.forEach { id, store in
                if cstore == id {

                    self.storeData.appendChild(
                        Small {
                            Span("SUC:").marginRight(3.px)
                            Strong(store.name).marginRight(3.px)
                            Span(store.telephone).marginRight(3.px)
                            Br()
                            Span(store.street).marginRight(3.px)
                            Span(store.colony).marginRight(3.px)
                            Span(store.city).marginRight(3.px)
                            Br()
                            Span(store.schedulea).marginRight(3.px)
                            Span(store.scheduleb).marginRight(3.px)
                            Span(store.schedulec).marginRight(3.px)
                            Br()
                        }
                        .fontSize(12.px)
                    )
                    

                    self.storeDataCopy.appendChild(
                        Small {
                            Span("SUC:").marginRight(3.px)
                            Strong(store.name).marginRight(3.px)
                            Span(store.telephone).marginRight(3.px)
                            Br()
                            Span(store.street).marginRight(3.px)
                            Span(store.colony).marginRight(3.px)
                            Span(store.city).marginRight(3.px)
                            Br()
                            Span(store.schedulea).marginRight(3.px)
                            Span(store.scheduleb).marginRight(3.px)
                            Span(store.schedulec).marginRight(3.px)
                            Br()
                        }
                        .fontSize(12.px)
                    )

                }
            }
        }
        
        appendPaymentRows()
    }
    
    func headerView() -> Div {
        Div {
            Table {
                Tr {
                    Td {
                        Img()
                            .src(self.logo)
                            .maxWidth(200.px)
                            .maxHeight(70.px)
                    }
                    .align(.left)
                    .width(33.percent)
                    
                    Td {
                        self.storeData
                    }
                    .align(.center)
                    .fontSize(32.px)
                    .width(33.percent)
                    
                    Td {
                        Strong {
                            Div("PAGO")
                                .fontSize(20.px)
                            Div(self.payment.folio)
                                .fontSize(32.px)
                        }
                    }
                    .align(.right)
                    .width(33.percent)
                }
            }
            .width(100.percent)
        }
    }
    
    func headerViewCopy() -> Div {
        Div {
            Table {
                Tr {
                    Td {
                        Img()
                            .src(self.logo)
                            .maxWidth(200.px)
                            .maxHeight(70.px)
                    }
                    .align(.left)
                    .width(33.percent)
                    
                    Td {
                        self.storeDataCopy
                    }
                    .align(.center)
                    .fontSize(32.px)
                    .width(33.percent)
                    
                    Td {
                        Strong {
                            Div("PAGO")
                                .fontSize(20.px)
                            Div(self.payment.folio)
                                .fontSize(32.px)
                        }
                    }
                    .align(.right)
                    .width(33.percent)
                }
            }
            .width(100.percent)
        }
    }
    
    func customerView() -> Div {
        Div {
            if let order = self.order {
                Div {
                    Strong(order.name)
                    Br()
                    if !order.street.isEmpty || !order.colony.isEmpty || !order.city.isEmpty {
                        Span("\(order.street) \(order.colony) \(order.city) ")
                    }
                    if !order.mobile.isEmpty {
                        Span(" Celular: ")
                        Strong(order.mobile)
                    }
                    if !order.email.isEmpty {
                        Span(" Correo: ")
                        Strong(order.email)
                    }
                    if !order.telephone.isEmpty {
                        Span(" Telefono: ")
                        Strong(order.telephone)
                    }
                }
                
                Div {
                    Span("Orden: ")
                    Strong(order.folio)
                    Span(order.description)

                }
                .marginTop(7.px)
            }
            else {
                Div {
                    Span("Cuenta: ")
                    Strong(self.payment.custAcct?.uuidString ?? "N/A")
                }
            }
        }
    }
    
    func signatureView() -> Div {
        Div {
            Div()
                .borderBottom(width: .thin, style: .solid, color: .black)
                .marginTop(24.px)
                .marginBottom(12.px)
            
            Div("Firma de Recibido")
                .align(.center)
        }
    }
    
    func appendPaymentRows() {

        paymentData.appendChild(
            Tr {
                Td("Fecha")
                    .width(35.percent)
                Td(getDate(self.payment.createdAt).formatedLong)
                Td("Folio")
                Td(self.payment.folio)
            }
        )
        
        paymentData.appendChild(
            Tr {
                Td("Tipo")
                Td(self.payment.type.description)
                Td("Forma de pago")
                Td("\(self.payment.fiscCode.rawValue) \(self.payment.fiscCode.description)")
            }
        )
        
        if !payment.ref.isEmpty {
            paymentData.appendChild(
                Tr {
                    Td("Referencia")
                    Td(self.payment.ref)
                    Td("Autorizacion")
                    Td(self.payment.auth)
                }
            )
        }

        paymentData.appendChild(
            Tr {
                Td("Descripcion")
                Td(self.payment.description)

                Td("Pago")
                Td(self.payment.cost.formatMoney)
            }
        )

        paymentDataCopy.appendChild(
            Tr {
                Td("Fecha")
                    .width(35.percent)
                Td(getDate(self.payment.createdAt).formatedLong)
                Td("Folio")
                Td(self.payment.folio)
            }
        )
        
        paymentDataCopy.appendChild(
            Tr {
                Td("Tipo")
                Td(self.payment.type.description)
                Td("Forma de pago")
                Td("\(self.payment.fiscCode.rawValue) \(self.payment.fiscCode.description)")
            }
        )
        
        if !payment.ref.isEmpty {
            paymentDataCopy.appendChild(
                Tr {
                    Td("Referencia")
                    Td(self.payment.ref)
                    Td("Autorizacion")
                    Td(self.payment.auth)
                }
            )
        }

        paymentDataCopy.appendChild(
            Tr {
                Td("Descripcion")
                Td(self.payment.description)

                Td("Pago")
                Td(self.payment.cost.formatMoney)
            }
        )
        
    }
}
