//
//  ToolViewFiscalXMLDocument.swift
//  
//
//  Created by Victor Cantu on 2/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolViewFiscalXMLDocument: Div {
    
    override class var name: String { "div" }
    
    var doc: API.fiscalV1.FiscalXMLIngresoResponse
    
    init(
        doc: API.fiscalV1.FiscalXMLIngresoResponse
    ) {
        self.doc = doc
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var vendorFolio = ""
    
    @State var businessName = ""
    
    @State var vendorRfc = ""
    
    @State var vendorRazon = ""
    
    @State var finaceContact = ""
    
    @State var oporationContact = ""
    
    @State var receptorRfc = ""
    
    @State var receptorRazon = ""
    
    @State var fiscalUse: FiscalUse? = nil
    
    @State var paymentForm: FiscalPaymentMeths? = nil
    
    /// Documet data
    @State var docid: UUID? = nil
    
    @State var docuuid = ""
    
    @State var docFolio = ""
    
    @State var docSerie = ""
    
    @State var total = ""
    
    @State var balance = ""
    
    @State var officialDate = ""
    
    @State var dueDate = ""
    
    @State var canAddTarget = false
    
    @State var custInventoryPurchaseManagerStatus: CustInventoryPurchaseManagerStatus? = nil
    
    @State var manualPurchaseManager: CustInventoryPurchaseManagerDecoded? = nil
    
    lazy var productDiv = Div()
        .custom("height", "calc(100% - 275px)")
        .class(.roundBlue)
        .overflow(.auto)
    
    
    @DOM override var body: DOM.Content {
        
        Div{
           
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                Div{
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .class(.iconWhite)
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Imprimir")
                }
                .marginRight(18.px)
                .marginTop(-4.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.printDocument()
                }
                
                H2("Ver Documento Fiscal")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear).height(7.px)
            
            /// Fiscal Profiles
            Div {
                
                /// Receptor Data
                Div{
                    
                    Label("Perfil Fiscal")
                        .padding(all: 3.px)
                        .paddingLeft(0.px)
                        .marginLeft(0.px)
                        .fontSize(18.px)
                        .color(.gray)
                        .marginBottom(3.px)
                    
                    /// RFC
                    Div{
                        
                        Label("RFC")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div( self.$receptorRfc.map{ $0.isEmpty ? "XAXX010101000" : $0 } )
                            .color(self.$receptorRfc.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.marginBottom(3.px).class(.section)
                    
                    /// Razon
                    Div{
                        Label("Razon Social")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div(self.$receptorRazon.map { $0.isEmpty ? "Razon Social" : $0 })
                            .color(self.$receptorRazon.map{ $0.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                        
                    }.marginBottom(3.px)
                    
                    /// USO
                    Div{
                        
                        Label(LString(
                            .es("Uso CFDI"),
                            .en("Use CFDI")
                        ))
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div(self.$fiscalUse.map { ($0 == nil) ? "USO CFDI" : ($0?.description ?? "") })
                            .color(self.$fiscalUse.map{ ($0 == nil) ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                            
                    }.marginBottom(3.px)
                   
                }
                .marginRight(1.percent)
                .width(24.percent)
                .float(.left)
                
                /// Vendor  Data
                Div{
                    
                    /// Account Number
                    Div{
                        
                        Label("Cuenta")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div( self.$vendorFolio.map{ $0.isEmpty ? "veXX-0000" : $0 } )
                            .color(self.$vendorFolio.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.marginBottom(3.px).class(.section)
                    
                    
                    /// RFC
                    Div{
                        
                        Label("RFC")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div(self.$vendorRfc.map { $0.isEmpty ? "XAXX010101000" : $0 })
                            .color(self.$vendorRfc.map{ $0.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                        
                    }.marginBottom(3.px).class(.section)
                    
                    /// Razon
                    Div{
                        Label("Razon Social")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div(self.$vendorRazon.map { $0.isEmpty ? "Razon Social" : $0 })
                            .color(self.$vendorRazon.map{ $0.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                        
                    }.marginBottom(3.px)
                    
                    /// Buisness Name
                    Div{
                        
                        Label("Nombre Empresa")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div(self.$businessName.map { $0.isEmpty ? "Nombre Empresa" : $0 })
                            .color(self.$businessName.map{ $0.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                        
                    }.marginBottom(3.px)
                    
                }
                .marginRight(1.percent)
                .width(24.percent)
                .float(.left)
                
                /// Vendor / Document
                Div{
                    
                    /// contacto
                    Div{
                        
                        Label("Con. Finz / Con. Operativo")
                            .fontSize(14.px)
                            .color(.gray)
                        
                        Div{//
                            
                            Span(self.$finaceContact.map{ $0.isEmpty ? "8341230000" : $0 })
                                .color(self.$finaceContact.map{ $0.isEmpty ? .grayContrast : .white })
                            
                            Span(" / ")
                                .color(self.$oporationContact.map{ $0.isEmpty ? .grayContrast : .white })
                            
                            Span(self.$oporationContact.map{ $0.isEmpty ? "8341230000" : $0 })
                                .color(self.$oporationContact.map{ $0.isEmpty ? .grayContrast : .white })
                            
                        }
                        .color(self.$docuuid.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        
                    }.marginBottom(3.px)
                    
                    /// UUID
                    Div{
                        
                        Label("UUID")
                            .fontSize(14.px)
                            .color(.gray)
                        
                        Div(self.$docuuid.map{ $0.isEmpty ? "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" : $0 })
                            .color(self.$docuuid.map{ $0.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(12.px)
                        
                    }
                    
                    /// Folio /Serie
                    Div{
                        
                        Label("Folio/Serie")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div{
                            
                            Span(self.$docSerie.map{ $0.isEmpty ? "Serie" : $0 })
                                .color(self.$docSerie.map{ $0.isEmpty ? .grayContrast : .white })
                            
                            Span("/")
                                .color(self.$docFolio.map{ $0.isEmpty ? .grayContrast : .white })
                            
                            Span(self.$docFolio.map{ $0.isEmpty ? "Folio" : $0 })
                                .color(self.$docFolio.map{ $0.isEmpty ? .grayContrast : .white })
                            
                        }
                        .color(self.$vendorRfc.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.class(.section)
                    
                    /// Forma de Pago
                    Div{
                        
                        Label("Forma de Pago")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div(self.$paymentForm.map { ($0 == nil) ? "Forma de Pago" : ($0?.description ?? "") })
                            .color(self.$paymentForm.map{ ($0 == nil) ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                            
                    }
                    
                }
                .marginRight(1.percent)
                .width(24.percent)
                .float(.left)
                
                /// Document
                Div{
                
                    /// Ofical Date
                    Div{
                        
                        Label("Fecha de Emision")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div( self.$officialDate.map{ $0.isEmpty ? "DD/MM/AAAA" : $0 } )
                            .color(self.$officialDate.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.marginBottom(3.px)
                    
                    /// Due Date
                    Div{
                        
                        Label("Fecha de Pago")
                            .color(.gray)
                            .fontSize(14.px)
                        
                        Div( self.$dueDate.map{ $0.isEmpty ? "DD/MM/AAAA" : $0 } )
                            .color(self.$dueDate.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }
                    
                    /// Total
                    Div{
                        
                        Label("Total")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div( self.$total.map{ $0.isEmpty ? "0.00" : $0 } )
                            .color(self.$total.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.paddingBottom(3.px).class(.section)
                    
                    /// Balance
                    Div{
                        
                        Label("Balance")
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                            .color(.gray)
                            
                        
                        Div( self.$balance.map{ $0.isEmpty ? "0.00" : $0 } )
                            .color(self.$balance.map{ $0.isEmpty ? .grayContrast : .white })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .fontSize(18.px)
                        
                    }.paddingBottom(3.px).class(.section)
                
                }
                .marginRight(1.percent)
                .width(24.percent)
                .float(.left)
                
                Div().class(.clear)
                
            }.height(175.px)
            
            Div {
                
                Div("Cantidad")
                    .class(.oneLineText)
                    .align(.center)
                    .width(55.px)
                    .float(.left)
                
                Div("Clave Producto")
                    .class(.oneLineText)
                    .width(150.px)
                    .float(.left)
                
                Div("Descripsion")
                    .custom("width", "calc(100% - 510px)")
                    .class(.oneLineText)
                    .float(.left)
                
                Div("Costo")
                    .class(.oneLineText)
                    .align(.center)
                    .width(100.px)
                    .float(.left)
                
                Div("POC")
                    .class(.oneLineText)
                    .align(.center)
                    .width(50.px)
                    .float(.left)
                
                Div("+ Inventario")
                    .align(.center)
                    .width(150.px)
                    .float(.left)
                
                Div().class(.clear)
                 
            }
            .color(.white)
            .padding(all: 3.px)
            .margin(all: 3.px)
            
            self.productDiv
            
        }
        .custom("height", "calc(100% - 100px)")
        .custom("width", "calc(100% - 100px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .left(50.px)
        .top(60.px)
        
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        loadData(self.doc)
        
    }
    
    override func didRemoveFromDOM() {
        print("did remove from dom 🤖")
    }
    
    func loadData(_ data: API.fiscalV1.FiscalXMLIngresoResponse) {
        
        guard let dateParts = data.document.fecha.explode("T").first?.explode("-") else {
            showError(.errorGeneral, "No se pudo obtener fecha de creacion 001.")
            return
        }
        
        guard dateParts.count == 3 else {
            showError(.errorGeneral, "No se pudo obtener fecha de creacion 002.")
            return
        }
        
        guard let uuid = data.document.complemento.timbreFiscalDigital?.uuid else {
            showError(.errorGeneral, "No se pudo obtener uuid de doc")
            return
        }
        
        let day = dateParts[2]
        
        let month = dateParts[1]
        
        let year = dateParts[0]
        
        var thisMonthCalendarComponants = DateComponents()
        thisMonthCalendarComponants.day = Int(day)
        thisMonthCalendarComponants.month = Int(month)
        thisMonthCalendarComponants.year = Int(year)
        
        /// this is the ral life calander date  i cant go befor this date
        guard let uts = Calendar.current.date(from: thisMonthCalendarComponants)?.uts else {
            showError(.errorGeneral, "No se pudo obtener fecha de creacion 003.")
            return
        }
        
        docid = data.docid
        
        docuuid = uuid.uuidString
        
        vendorFolio = data.vendor.folio
        businessName = data.vendor.businessName
        
        vendorRfc = data.vendor.rfc
        vendorRazon = data.vendor.razon
        
        finaceContact = data.vendor.fiscalPOCMobile
        oporationContact = data.vendor.contactTel
        
        receptorRfc = data.document.receptor.rfc
        receptorRazon = data.document.receptor.nombre
        
        fiscalUse = data.document.receptor.usoCFDI
        paymentForm = data.document.metodoPago
        docFolio = data.document.folio
        docSerie = data.document.serie
        total = data.document.total.formatMoney
        
        if paymentForm == .pagoEnParcialidadesODiferido {
            
            balance = data.document.total.formatMoney
            
            if data.vendor.creditActive {
                dueDate = getDate( uts + ( data.vendor.creditDays * (60 * 60 * 24) ) ).formatedShort
            }
            
        }
        else {
            balance = ""
        }
        
        officialDate = "\(day)/\(month)/\(year)"
        
        var cc = 0
               
        data.document.conceptos.concepto.forEach { item in
            
            var pocid: UUID? = nil
            
            data.pocs.forEach { poc in
                if item.noIdentificacion.pseudo == poc.code.pseudo || item.descripcion.pseudo.contains(poc.description.pseudo) {
                    pocid =  poc.pocid
                }
            }
            
            let view = FiscalConceptView(
                documentStatus: self.$custInventoryPurchaseManagerStatus, 
                itemno: cc,
                docid: docid,
                item: item,
                pocid: pocid,
                vendorid: data.vendor.id,
                vendorname: self.vendorRfc,
                canAddTargets: $canAddTarget
            ) {
                
            }
            
            view.noSelectedInventoryView.remove()
            
            self.productDiv.appendChild(view)
            
            cc += 1
            
           
            
        }
    }
    
    func printDocument() {
        
        let data = doc
        
        guard let dateParts = data.document.fecha.explode("T").first?.explode("-") else {
            showError(.errorGeneral, "No se pudo obtener fecha de creacion 001.")
            return
        }
        
        guard dateParts.count == 3 else {
            showError(.errorGeneral, "No se pudo obtener fecha de creacion 002.")
            return
        }
        
        guard let uuid = data.document.complemento.timbreFiscalDigital?.uuid else {
            showError(.errorGeneral, "No se pudo obtener uuid de doc")
            return
        }
        
        /*
        docid = data.docid
        
        docuuid = uuid.uuidString
        
        vendorFolio = data.vendor.folio
        
        businessName = data.vendor.businessName
        
        vendorRfc = data.vendor.rfc
        vendorRazon = data.vendor.razon
        
        finaceContact = data.vendor.fiscalPOCMobile
        oporationContact = data.vendor.contactTel
        
        receptorRfc = data.document.receptor.rfc
        receptorRazon = data.document.receptor.nombre
        
        fiscalUse = data.document.receptor.usoCFDI
        paymentForm = data.document.metodoPago
        docFolio = data.document.folio
        docSerie = data.document.serie
        total = data.document.total.formatMoney
        */
        
        let document = data.document
        
        guard let timbreFiscalDigital = document.complemento.timbreFiscalDigital else {
            showError(.errorGeneral, "No se pudo obtener Timbre Digital")
            return
        }
        
        let certificadoSat = timbreFiscalDigital.noCertificadoSAT
        
        let noCertificado = data.document.noCertificado
        
        let selloCFD = timbreFiscalDigital.selloCFD
        
        let selloSAT = timbreFiscalDigital.selloSAT
        
        let priceGrid = Table{
            Tr{
                Td("Clave Prod")
                Td("Cant")
                Td("Clave Uni")
                Td("Codigo")
                Td("Concepto")
                Td("P. Uni")
                Td("Importe")
            }
        }
        .marginBottom(12.px)
        .width(100.percent)
        .fontSize(14.px)
        
        data.document.conceptos.concepto.forEach { item in
            
            priceGrid.appendChild(Tr{
                Td(item.claveProdServ)///
                // "Cant"
                Td(item.cantidad.formatMoney)
                // "Clave Uni"
                Td(item.claveUnidad)
                // "Codigo"
                Td(item.noIdentificacion)
                // Concepto
                Td(item.descripcion)
                // P. Uni
                Td(item.valorUnitario.formatMoney)
                // Importe
                Td((item.cantidad * item.valorUnitario).formatMoney)
            })
            
        }
        
        /*
                     public var base: Double
                     /// isr 001, iva 002, ieps 003
                     public var impuesto: TaxType
                     /// Tasa
                     public var tipoFactor: TaxFactor
                     public var tasaOCuota: String
                     public var importe: Double
                     */
        
        priceGrid.appendChild(Tr{
            Td()
            Td()
            Td()
            Td()
            Td()
            Td("Sub Total")
            Td(document.subTotal.formatMoney)
        })
        
        data.document.impuestos?.traslados?.traslado.forEach({ tax in
            priceGrid.appendChild(Tr{
                Td()
                Td()
                Td()
                Td()
                Td()
                Td(tax.impuesto.code.uppercased())
                Td(tax.importe.formatMoney)
            })
        })
        
        data.document.impuestos?.retenidos?.retenido.forEach({ tax in
            priceGrid.appendChild(Tr{
                Td()
                Td()
                Td()
                Td()
                Td()
                Td(tax.impuesto.code.uppercased())
                Td(tax.importe.formatMoney)
            })
        })
        
        priceGrid.appendChild(Tr{
            Td()
            Td()
            Td()
            Td()
            Td()
            Td("TOTAL")
            Td(document.total.formatMoney)
        })
        
        let body = Div{
            Div("Factura Electronica CFDI v\(document.version.rawValue)")
                .marginBottom(12.px)
                .fontWeight(.bolder)
                .textAlign(.center)
                .fontSize(32.px)
            
            Div("Este documento es una representacion impresa de un CFDI")
                .marginBottom(12.px)
                .textAlign(.center)
                .fontSize(18.px)
            
            /// Main data and QR
            Table{
                Tr{
                    Td("Folio Fiscal")
                        .fontWeight(.bolder)
                        .width(30.percent)
                        .align(.left)
                    Td(uuid.uuidString)
                        .align(.right)
                    Td{
                        Div()
                            .id(Id(stringLiteral: "satQrCode"))
                    }
                    .width(30.percent)
                    .align(.center)
                    .rowSpan(4)
                }
                Tr{
                    Td("Certificado SAT")
                        .fontWeight(.bolder)
                        .align(.left)
                    Td(certificadoSat)
                        .align(.right)
                }
                Tr{
                    Td("Certificado del Emisor")
                        .fontWeight(.bolder)
                        .align(.left)
                    Td(noCertificado)
                        .align(.right)
                }
                Tr{
                    Td("Fecha de Certificación")
                        .fontWeight(.bolder)
                        .align(.left)
                    Td(self.officialDate)
                        .align(.right)
                }
            }
            .marginBottom(12.px)
            .width(100.percent)
            .fontSize(14.px)
            
            /// Emisor Receptor
            Table{
                Tr{
                    Td("Emisor")
                        .fontWeight(.bolder)
                        .width(35.percent)
                    Td("Receptor")
                        .fontWeight(.bolder)
                        .width(35.percent)
                    Td{
                        Div("Serie/Folio: \(self.docSerie)/\(self.docFolio)")
                            .class(.oneLineText)
                        Div("Expedido en: \(document.lugarExpedicion)")
                            .class(.oneLineText)
                        Div("Forma de Pago: \(document.formaPago.rawValue) \(document.formaPago.description)")
                            .class(.oneLineText)
                        Div("Fecha de Pago: \(document.fecha)")
                            .class(.oneLineText)
                        Div("\(document.metodoPago.rawValue) \(document.metodoPago.description)")
                            .class(.oneLineText)
                    }
                    .rowSpan(4)
                }
                Tr{
                    Td("Razon: \(document.emisor.nombre)")
                    Td("Razon: \(document.receptor.nombre)")
                }
                Tr{
                    Td("RFC: \(document.emisor.rfc)")
                    Td("RFC: \(document.receptor.rfc)")
                }
                Tr{
                    Td("Tipo: \(document.tipoDeComprobante.rawValue) \(document.tipoDeComprobante.description)")
                    Td("Uso CFDI: \(document.receptor.usoCFDI.rawValue) \(document.receptor.usoCFDI.description)")
                }
            }
            .marginBottom(12.px)
            .width(100.percent)
            .fontSize(14.px)
            
            priceGrid
            
            Div().height(23.px)
            
            Div("Sello Digita Contribuyente:").marginBottom(7.px)
            Div(selloCFD).marginBottom(24.px)
            Div("Sello Digital SAT:").marginBottom(7.px)
            Div(selloSAT)
            
            
        }
        
        var url = "https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?" +
        "&id=\(uuid.uuidString)" +
        "&re=\(document.emisor.rfc.uppercased())" +
        "&rr=\(document.receptor.rfc.uppercased())" +
        "&tt=\(document.total.toString)" +
        "&fe=\(String(selloCFD.suffix(8)))"
        
        _ = JSObject.global.renderFiscalDocumentPrint!(custCatchUrl, uuid.uuidString, body.innerHTML, url)
        
    }
    
}
