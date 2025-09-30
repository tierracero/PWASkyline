//
//  ConcessionConfirmationView.swift
//
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import Web
import JavaScriptKit

class ConcessionConfirmationView: Div {
    
    override class var name: String { "div" }
    
    @State var accountid: UUID
    
    @State var accountFolio: String
    
    @State var accountName: String
    
    var purchaseManager: UUID
    
    var subTotal: String
    
    var document: CustFiscalInventoryControl
    
    var kart: [SalePointObject]
    
    let cardex: [CustPOCCardex]
    
    init(
        accountid: UUID,
        accountFolio: String,
        accountName: String,
        purchaseManager: UUID,
        subTotal: String,
        document: CustFiscalInventoryControl,
        kart: [SalePointObject],
        cardex: [CustPOCCardex]
    ) {
        self.accountid = accountid
        self.accountFolio = accountFolio
        self.accountName = accountName
        self.purchaseManager = purchaseManager
        self.subTotal = subTotal
        self.document = document
        self.kart = kart
        self.cardex = cardex
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var printaccount = ""
    var printfolio = ""
    var printname = ""
    var printlastname = ""
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .closeButton(.subView)
                .onClick{
                    self.remove()
                }
            
            H1("Consession realizada con exito")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            Div()
                .class(.clear)
                .marginTop(24.px)
            
            Div {
                
                Img()
                    .src("/skyline/media/checkmark.png")
                    .width(128.px)
                
                Div{
                    Strong("Imprimir")
                        .fontSize(24.px)
                        .color(.highlighBlue)
                }
                    .class(.smallButtonBox)
                    .margin(all: 24.px)
                    .onClick {
                        self.printTicket()
                    }
            }
            .align(.center)
            .class(.oneHalf)
            
            Div {
                Div{
                    
                    Strong("Cuenta")
                        .color(.highlighBlue)
                        .float(.left)
                    
                    Span(self.$accountFolio.map{ $0 ?? "S/F"})
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                Div().class(.clear)
                
                Div{
                    Strong("Cliente")
                        .float(.left)
                    
                    Span(self.$accountName.map{ $0 ?? "Publico General" })
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                //
                Div().class(.breaks)
                    .marginTop(7.px)
                    .marginBottom(7.px)
                
                // SubTotal
                Div{
                    Strong("Sub Total")
                    .float(.left)
                    .marginLeft(24.percent)
                    
                    Span(self.subTotal)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
                //
                Div().class(.breaks)
                    .marginTop(7.px)
                    .marginBottom(7.px)
                //
                
                // consession folio
                Div{
                    Strong("Orden de Concession")
                        .float(.left)
                    
                    Span(self.document.folio)
                    
                }
                .fontSize(23.px)
                .margin(all: 12.px)
                .align(.right)
                
            }
            .class(.oneHalf)
            
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
    }
    
    func printTicket(){
        
        // https://tierracero.com/dev/skyline/api.php?token=1706837090MTcOcCKAVoWSLm3Bk4GbHDbcwfXZx6gr5w3Yu6NBCcZcdfCY&user=vcantu01@tierracero.com&key=XBuHxkAYZHBUwnzysyXhu4pj8jY8cCVX3bwXqXv0dgg%3d&mid=%2boPlYEoYnKf8tbQ13pA8zQ%3d%3d&ie=downLoadInventoryControlOrders&docid=2CD304AE-2531-4D33-A39D-2A6EE22A561B&storeid=DCD5BD1B-789A-489D-B069-A3D781F520B6&detailed=true
        loadingView(show: true)
        
        downLoadInventoryControlOrders(id: purchaseManager, detailed: true)
        
        Dispatch.asyncAfter(3.0) {
            loadingView(show: false)
        }
        
    }
    
}
