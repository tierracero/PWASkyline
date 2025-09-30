//
//  ToolFiscalConfirmView.swift
//  
//
//  Created by Victor Cantu on 5/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalConfirmView: Div {
    
    override class var name: String { "div" }
    
    var taxMode: TaxMode
    var comment: String
    var communicationMethod: String
    var type: FIAccountsServicesRelatedType
    var accountid: UUID
    var orderid: UUID?
    var folio: String?
    var officialDate: Int64?
    var profile: UUID
    var razon: String
    var rfc: String
    var zip: String
    var regimen: FiscalRegimens
    var use: FiscalUse
    var metodo: FiscalPaymentMeths
    var forma: FiscalPaymentCodes
    var items: [FiscalConcept]
    var provider: String
    var auth: String
    var lastFour: String
    var cartaPorte: FiscalCartaPorte?
    var globalInformation: InformacionGlobal?
    let total: String
    
    private var callback: ((
    ) -> ())
    
    init(
        taxMode: TaxMode,
        comment: String,
        communicationMethod: String,
        type: FIAccountsServicesRelatedType,
        accountid: UUID,
        orderid: UUID?,
        folio: String?,
        officialDate: Int64?,
        profile: UUID,
        razon: String,
        rfc: String,
        zip: String,
        regimen: FiscalRegimens,
        use: FiscalUse,
        metodo: FiscalPaymentMeths,
        forma: FiscalPaymentCodes,
        items: [FiscalConcept],
        provider: String,
        auth: String,
        lastFour: String,
        cartaPorte: FiscalCartaPorte?,
        globalInformation: InformacionGlobal?,
        total: String,
        callback: @escaping ((
        ) -> ())
    ) {
        self.taxMode = taxMode
        self.comment = comment
        self.communicationMethod = communicationMethod
        self.type = type
        self.accountid = accountid
        self.orderid = orderid
        self.folio = folio
        self.officialDate = officialDate
        self.profile = profile
        self.razon = razon
        self.rfc = rfc
        self.zip = zip
        self.regimen = regimen
        self.use = use
        self.metodo = metodo
        self.forma = forma
        self.items = items
        self.provider = provider
        self.auth = auth
        self.lastFour = lastFour
        self.cartaPorte = cartaPorte
        self.globalInformation = globalInformation
        self.total = total
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var viewName = ""
    
    @State var buttonName = "Crear Factura"
    
    lazy var detailView = Div()
    
    lazy var itemsDiv = Div()
        .custom("height","calc(100% - 300px)")
        .class(.roundDarkBlue)
        .marginTop(3.px)
        .marginBottom(7.px)
        .padding(all: 7.px)
        .overflow(.auto)
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$viewName)
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            self.detailView
                .custom("height","calc(100% - 86px)")
            
            Div {
                
                H1("TOTAL")
                    .color(.white)
                    .marginRight(7.px)
                    .marginTop(12.px)
                    .float(.left)
                
                H1(self.total)
                    .marginTop(12.px)
                    .color(.goldenRod)
                    .float(.left)
                
                
                Div(self.$buttonName)
                .class(.uibtnLargeOrange)
                .marginTop(7.px)
                .float(.right)
                .onClick{
                    self.remove()
                    self.callback()
                }
                
                Div().class(.clear)
                
            }
            .align(.center)
            
            Div().class(.clear)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 400px)")
        .custom("top", "calc(50% - 300px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(600.px)
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
        
        switch type {
        case .general:
            viewName = "Factura General"
        case .order:
            viewName = "Facturar Orden \(self.folio ?? "")"
        case .sale:
            viewName = "Facturar Venta \(self.folio ?? "")"
        case .fiscalComplement:
            viewName = "Complemento de Pago"
        case .bill:
            detailView.appendChild(
                H2("").color(.white)
            )
        }
        
        if cartaPorte != nil {
            buttonName = "Crear Carta Porte"
        }
        
        var fiscalProfile: FiscalEndpointV1.Profile? = nil
        
        fiscalProfiles.forEach { prof in
            if profile == prof.id {
                fiscalProfile = prof
            }
        }
        
        guard let fiscalProfile else {
            showError(.errorGeneral, "No se localizo perfil fiscal")
            return
        }
        
        detailView.appendChild(
            H2("Emisor").color(.goldenRod)
        )
        
        detailView.appendChild(
            Div{
               
                Div{
                    
                    Div(fiscalProfile.razon)
                        .class(.textFiledBlackDark, .oneLineText)
                        .borderRadius(12.px)
                        .padding(all: 12.px)
                        .textAlign(.right)
                        .margin(all: 3.px)
                        .fontSize(24.px)
                        .color(.white)
                    
                }
                .width(60.percent)
                .float(.left)
                
                 Div{
                     
                     Div(fiscalProfile.rfc)
                         .class(.textFiledBlackDark, .oneLineText)
                         .borderRadius(12.px)
                         .padding(all: 12.px)
                         .textAlign(.right)
                         .margin(all: 3.px)
                         .fontSize(24.px)
                         .color(.white)
                 }
                 .width(40.percent)
                 .float(.left)
                 
                Div().class(.clear)
                
            }
            
        )
        
        detailView.appendChild(
            H2("Receptor").color(.goldenRod)
        )
        
        detailView.appendChild(
            Div{
               
                Div{
                    
                    Div(self.razon)
                        .class(.textFiledBlackDark, .oneLineText)
                        .borderRadius(12.px)
                        .padding(all: 12.px)
                        .textAlign(.right)
                        .margin(all: 3.px)
                        .fontSize(24.px)
                        .color(.white)
                    
                }
                .width(60.percent)
                .float(.left)
                
                 Div{
                     
                     Div(self.rfc)
                         .class(.textFiledBlackDark, .oneLineText)
                         .borderRadius(12.px)
                         .padding(all: 12.px)
                         .textAlign(.right)
                         .margin(all: 3.px)
                         .fontSize(24.px)
                         .color(.white)
                 }
                 .width(40.percent)
                 .float(.left)
                 
                Div().class(.clear)
                
            }
            
        )
        
        
        
        /*
         
         ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir...
        var use: FiscalUse
         
         /// pagoEnUnaSolaExhibicion PUE
         /// pagoEnParcialidadesODiferido PPD
        var metodo: FiscalPaymentMeths
         
         ///Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
        var forma: FiscalPaymentCodes
        */
       
        
        detailView.appendChild(
            Div{
               
                Div{
                    
                    Div{
                        Label("Uso de Factura")
                            .color(.white)
                        Div(self.use.description)
                            .fontSize(22.px)
                            .color(.goldenRod)
                    }
                    .class(.section)
                    .marginBottom(7.px)
                    
                    
                    Div{
                        Label("Forma de Pago")
                            .color(.white)
                        Div(self.forma.description)
                            .fontSize(22.px)
                            .color(.goldenRod)
                    }
                    .class(.section)
                    .marginBottom(7.px)
                    
                }
                .width(50.percent)
                .float(.left)
                
                 Div{
                     
                     Div{
                         Label("Metodo de Pago")
                             .color(.white)
                         Div(self.metodo.description)
                             .fontSize(22.px)
                             .color(.goldenRod)
                     }
                     .class(.section)
                     .marginBottom(7.px)
                     
                 }
                 .width(50.percent)
                 .float(.left)
                 
                Div().class(.clear)
                
            }
                .color(.white)
        )
        
        /// Header
        detailView.appendChild(
            Div{
                
                Div("Unis.")
                    .width(10.percent)
                    .float(.left)
                
                Div("Descripción y costo")
                    .width(55.percent)
                    .float(.left)
                
                Div("Sub Total")
                    .width(15.percent)
                    .align(.center)
                    .float(.left)
                
                Div("Total")
                    .width(15.percent)
                    .align(.center)
                    .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(3.px)
            .textAlign(.left)
            .marginTop(3.px)
            .color(.white)
        )
       
        detailView.appendChild(
            Div().class(.clear)
        )
        
        detailView.appendChild(
            self.itemsDiv
        )
        
        items.forEach { item in
            self.itemsDiv.appendChild(
                Div{
                    
                    Div(item.units.fiscalFormatMoney)
                        .class(.oneLineText)
                        .width(10.percent)
                        .float(.left)
                    
                    Div(item.name)
                        .class(.oneLineText)
                        .width(55.percent)
                        .float(.left)
                    
                    Div(item.subTotal.fiscalFormatMoney)
                        .class(.oneLineText)
                        .width(15.percent)
                        .align(.center)
                        .float(.left)
                    
                    Div(item.total.fiscalFormatMoney)
                        .class(.oneLineText)
                        .width(15.percent)
                        .align(.center)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(3.px)
                .textAlign(.left)
                .marginTop(3.px)
                .color(.white)
            )
        }
            
    }
    /*
     var taxMode: TaxMode
     var comment: String
     var communicationMethod: String
     var type: FIAccountsServicesRelatedType
     var accountid: UUID
     var orderid: UUID?
     var officialDate: Int64?
     var profile: UUID
     var razon: String
     var rfc: String
     var zip: String
     var regimen: FiscalRegimens
     var use: FiscalUse
     var metodo: FiscalPaymentMeths
     var forma: FiscalPaymentCodes
     var items: [FiscalConcept]
     var provider: String
     var auth: String
     var lastFour: String
     var cartaPorte: FiscalCartaPorte?
     var globalInformation: InformacionGlobal?
     */
    
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
}

