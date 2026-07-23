//
//  PaymentReciptFormView.swift
//
//
//  Created by Victor Cantu on 6/27/26.
//

import Foundation
import JavaScriptKit
import TCFundamentals
import Web

class PaymentReciptFormView: Div {
    
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
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div {
            Img()
                .closeButton(.uiView2)
                .onClick {
                    self.remove()
                }
            
            H2("Recibo de Pago")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            Div {
                Img()
                    .src("/skyline/media/checkmark.png")
                    .width(96.px)
                
                H2(self.payment.cost.formatMoney)
                    .color(.white)
                    .marginTop(7.px)
                
                Div(self.payment.folio)
                    .color(.lightBlueText)
                    .fontSize(22.px)
                
                Div(getDate(self.payment.createdAt).formatedLong)
                    .color(.white)
                    .marginTop(7.px)
            }
            .align(.center)
            
            Div().class(.clear).height(18.px)
            
            self.infoRow("Orden", self.order?.folio ?? "N/A")
            
            self.infoRow("Cliente", self.order?.name ?? "N/A")
            
            self.infoRow("Descripcion", self.payment.description)
            
            self.infoRow("Forma de pago", "\(self.payment.fiscCode.rawValue) \(self.payment.fiscCode.description)")
            
            if !self.payment.ref.isEmpty {
                self.infoRow("Referencia", self.payment.ref)
            }
            
            if !self.payment.auth.isEmpty {
                self.infoRow("Autorizacion", self.payment.auth)
            }
            
            Div().class(.clear).height(12.px)
            
            self.moneyRow("Balance Anterior", self.oldbalance)
            
            self.moneyRow("Pago", self.payment.cost)
            
            self.moneyRow("Nuevo Balance", self.newbalance)
            
            Div {
                Strong("Estado")
                    .float(.left)
                    .color(.white)
                
                Span(self.status.description)
                    .color(self.status.color)
            }
            .fontSize(22.px)
            .margin(all: 12.px)
            .align(.right)
            
            Div().class(.clear)
            
            Div {
                Img()
                    .src("/skyline/media/print.png")
                    .marginRight(7.px)
                    .width(18.px)
                
                Strong("Imprimir")
            }
            .class(.uibtnLargeOrange)
            .marginTop(18.px)
            .float(.right)
            .onClick {
                self.printRecipt()
            }
            
            Div().class(.clear)
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("top","calc(50% - 300px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 18.px)
        .width(42.percent)
        .left(29.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
    
    func infoRow(_ title: String, _ value: String) -> Div {
        Div {
            Strong(title)
                .float(.left)
                .color(.white)
            
            Span(value)
                .color(.white)
        }
        .fontSize(20.px)
        .margin(all: 12.px)
        .align(.right)
    }
    
    func moneyRow(_ title: String, _ value: Int64) -> Div {
        Div {
            Strong(title)
                .float(.left)
                .color(.white)
            
            Span(value.formatMoney)
                .color(.white)
        }
        .fontSize(22.px)
        .margin(all: 12.px)
        .align(.right)
    }
    
    func printRecipt() {
        let printBody = PaymenrPrintEngine(
            order: order,
            payment: payment,
            oldbalance: oldbalance,
            newbalance: newbalance,
            status: status
        ).innerHTML
        
        _ = JSObject.global.renderGeneralPrint!(custCatchUrl, payment.folio, printBody)
    }
}
