//
//  ToolReciveSendInventory.swift
//  
//
//  Created by Victor Cantu on 9/8/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

/**
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 ``TODO -> at load to place in inventory, bases on selected poc, see if has "ordenes de compra" ``
 
 */

class ToolReciveSendInventory: Div {
    
    override class var name: String { "div" }
    
    let loadid: UUID?
    
    init(
        loadid: UUID?
    ) {
        self.loadid = loadid
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    let viewid: UUID = .init()
    
    @State var uploadPercent = ""
    
    var vendorid: UUID? = nil
    
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
    
    @State var internalCost: Int64 = 0
    
    @State var balance = ""
    
    @State var officialDate = ""
    
    @State var dueDate = ""
    
    @State var hasProduct: Bool = false
    
    @State var itemsEmpty: Bool = true
    
    @State var items: [FiscalConceptView] = []
    
    @State var docs: [FiscalDocumentRowView] = []
    
    @State var manualItems: [FiscalConceptManualView] = []
    
    @State var barcodes: [BarcodePrinting] = []
    
    @State var controlStatus: FiscalDocumentControlStatus = .active
    
    /// Document of inventory processing
    @State var captureDocuments: [UUID] = []
    
    @State var canAddTargets: Bool = true
    
    @State var recentXMLviewIsHidden = true
    
    @State var ingresoManual: Bool? = nil
    
    @State var custInventoryPurchaseManagerStatus: CustInventoryPurchaseManagerStatus? = nil
    
    @State var manualPurchaseManager: CustInventoryPurchaseManagerDecoded? = nil
    
    var profile: FiscalComponents.Profile? = nil
    
    lazy var fileInput = InputFile()
        .multiple(false)
        .accept(["text/xml",".txt"])
        .display(.none)
    
    lazy var productDiv = Div()
        .custom("height", "calc(100% - 275px)")
        .hidden(self.$itemsEmpty)
        .class(.roundBlue)
        .overflow(.auto)
    
    lazy var noProductsAvailable = Div {
        Table {
            Tr{
                Td("No hay productos que ingresar")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
    .custom("height", "calc(100% - 275px)")
    .hidden( self.$itemsEmpty.map{ !$0 } )
    .class(.roundBlue)
    
    lazy var noDocSelected = Div()
    
    lazy var recentXMLviewNoResuls = Div {
        Table {
            Tr{
                Td("No hay facturas recientes.")
                    .verticalAlign(.middle)
                    .align(.center)
                    .color(.gray)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
        .custom("height", "calc(100% - 70px)")
        .class(.roundBlue)
        .hidden(self.$docs.map{ !$0.isEmpty })
    
    lazy var recentXMLviewResuls = Div()
        .custom("height", "calc(100% - 70px)")
        .class(.roundBlue)
        .overflow(.auto)
        .hidden(self.$docs.map{ $0.isEmpty })
    
    @State var recentXMLviewFilterText = ""
    
    @State var recentXMLviewFilterSearch = ""
   
    /// Name /  RFC
    var vendorRefrence: [String:String] = [:]
    
    var vendorName: [String] = []
    
    lazy var recentXMLviewFilter = InputText(self.$recentXMLviewFilterSearch)
        .placeholder("Filtrar Resultados")
        .class(.textFiledBlackDark)
        .marginRight(12.px)
        .fontSize(23.px)
        .width(350.px)
        .height(32.px)
        .float(.right)
        .onPaste {
            self.loadFilter()
        }
        .onKeyUp {
            self.loadFilter()
        }
        .onFocus({ tf in
            tf.select()
            self.loadFilter()
        })
        .onBlur {
            Dispatch.asyncAfter(0.3) {
                self.recentXMLviewResults.innerHTML = ""
            }
        }
    
    lazy var recentXMLviewResults = Div ()
        .backgroundColor(.transparentBlack)
        .maxHeight(80.percent)
        .borderRadius(12.px)
        .position(.absolute)
        .overflow(.auto)
        .width(430.px)
        .right(18.px)
        .top(50.px)
    
    lazy var recentXMLview = Div {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.recentXMLviewIsHidden = true
                    }
                
                self.recentXMLviewFilter
                
                Div{
                    Img()
                        .src("/skyline/media/reload.png")
                        .marginRight(7.px)
                        .height(18.px)
                    
                    Span("Sincronizar")
                        .fontSize(18.px)
                }
                .class(.uibtn)
                .marginRight(12.px)
                .float(.right)
                .onClick({
                    self.sincRecentXML()
                })
                
                H2("Facturas Recientes")
                    .color(.lightBlueText)
            }
            .paddingBottom(4.px)
            
            Div{
                self.recentXMLviewResults
            }
            .paddingBottom(3.px)
            
            Div{
                
                Div("Fecha")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .align(.center)
                    .width(110.px)
                    .float(.left)
                
                Div("Receptor")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .width(140.px)
                    .float(.left)
                    .align(.left)
                
                Div("Emisor")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .width(140.px)
                    .float(.left)
                    .align(.left)
                
                Div("")
                    .custom("width", "calc(100% - 700px)")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .float(.left)
                
                Div("Serie")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .width(90.px)
                    .float(.left)
                    .align(.center)
                
                Div("Folio")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .width(90.px)
                    .float(.left)
                    .align(.right)
                
                /// tipoDePago
                Div("Total")
                    .class(.oneLineText)
                    .marginTop(7.px)
                    .width(120.px)
                    .float(.left)
                    .align(.right)
                
                Div().class(.clear)
            }
            .color(.gray)
            .marginBottom(7.px)
            
            self.recentXMLviewNoResuls 
            
            self.recentXMLviewResuls
        }
        .custom("height", "calc(100% - 100px)")
        .custom("width", "calc(100% - 100px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .left(38.px)
        .top(38.px)
    }
    .backgroundColor(.transparentBlack)
    .position(.absolute)
    .width(100.percent)
    .height(100.percent)
    .top(0.px)
    .left(0.px)
    .hidden(self.$recentXMLviewIsHidden)

    @State var selectManualDocumentMenuViewIsHidden = true
    
    lazy var selectManualDocumentDiv = Div()
    
    @State var totalUnits: Int = 0
    
    @State var downloadDocumentViewIsHidden = true
    
    lazy var innerBody = Div{

            /*. Fiscal Profiles */
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
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    Div{
                        
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
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                    /// Total
                    Div{
                        
                        Label("Total")
                            .color(.yellowTC)
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                        
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
                        
                    }
                    .paddingBottom(3.px).class(.section)
                    .hidden(self.$ingresoManual.map{ $0 == true })
                    
                    /// Costos
                    Div{
                        
                        Label("Costo")
                            .color(.yellowTC)
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                        
                        Div( self.$internalCost.map{ $0.formatMoney } )
                            .color(self.$internalCost.map{ ($0 == 0) ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                    }
                    .hidden(self.$ingresoManual.map{ $0 != true })
                    .paddingBottom(3.px).class(.section)
                    
                    
                    /// Numero de Unidades
                    Div{
                        
                        Label("Unidades")
                            .color(.yellowTC)
                            .padding(all: 3.px)
                            .paddingLeft(0.px)
                            .marginLeft(0.px)
                            .fontSize(18.px)
                        
                        Div( self.$totalUnits.map{ $0 == 0 ? "" : $0.toString } )
                            .color(self.$total.map{ $0.isEmpty ? .grayContrast : .white })
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
                    .custom("width", "calc(100% - 585px)")
                    .class(.oneLineText)
                    .float(.left)
                
                Div("Costo")
                    .class(.oneLineText)
                    .align(.center)
                    .width(90.px)
                    .float(.left)
                
                Div("Precio")
                    .class(.oneLineText)
                    .align(.center)
                    .width(90.px)
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
            
            self.noProductsAvailable
            
            Div().class(.clear).height(4.px)
            
            Div {
                
                /// Descargar Docs (capturado)
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginTop(3.px)
                            .height(18.px)
                        
                    }
                    .marginTop(3.px)
                    .float(.left)
                    
                    Span("Descargar Docs")
                        .fontSize(18.px)
                    
                }
                .hidden(self.$captureDocuments.map{ $0.isEmpty })
                .marginRight(18.px)
                .marginTop(3.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.downloadDocs()
                }
                
                /// Print barodes (capturado)
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .marginTop(3.px)
                            .height(18.px)
                        
                    }
                    .marginTop(3.px)
                    .float(.left)
                    
                    Span("Imprimir Etiquetas")
                        .fontSize(18.px)
                    
                }
                .marginRight(18.px)
                .marginTop(3.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    self.printTags()
                }
                
                /// (Archive || Save) (no capturado)
                Div{
                    
                    Div{
                        
                        Div{
                            Div{
                                
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/add.png")
                                        .margin(all:3.px)
                                        .height(18.px)
                                }
                                .float(.left)
                            }
                            .float(.left)
                            
                            Span("Ingersar Inventario")
                                .color(.darkOrange)
                                .fontSize(18.px)
                            
                        }
                        .hidden(self.$hasProduct.map{ !$0 })
                        .marginRight(18.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            self.saveDoc()
                        }
                        
                        Div{
                            
                            Div{
                                
                                Img()
                                    .src("/skyline/media/icon_archive.png")
                                    .class(.iconWhite)
                                    .margin(all:3.px)
                                    .height(18.px)
                            }
                            .float(.left)
                            
                            if custCatchHerk > 4 {
                                Span("Archivar")
                                    .fontSize(18.px)
                            }
                            else {
                                Span("Soliciar Archivo")
                                    .fontSize(18.px)
                            }
                            
                        }
                        .marginRight(12.px)
                        .class(.uibtn)
                        .float(.right)
                        .onClick {
                            self.archiveDoc()
                        }
                        
                    }
                    .hidden(self.$controlStatus.map{ !($0 == .active) })
                    
                    Div("Archivo Solicitado")
                        .hidden(self.$controlStatus.map{ !($0 == .filedRequest) })
                        .color(.goldenRod)
                        .fontSize(24.px)
                    
                    Div("Archivado")
                        .hidden(self.$controlStatus.map{ !($0 == .filed) })
                        .color(.goldenRod)
                        .fontSize(24.px)
                      
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .float(.right)
                
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .margin(all:3.px)
                            .height(18.px)
                    }
                    .float(.left)
                    
                    Span("Imprimir")
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .marginRight(18.px)
                .marginTop(3.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.printDispetion()
                }
                
                /// Clean all
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/cross.png")
                            .marginRight(7.px)
                            .marginTop(3.px)
                            .height(18.px)
                    }
                    .float(.left)
                    
                    Span("Cerrar")
                        .color(.darkOrange)
                        .fontSize(18.px)
                    
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .marginRight(12.px)
                .marginTop(5.px)
                .float(.left)
                .class(.uibtn)
                .onClick {
                    self.resetView()
                }
                
            }
            .hidden(self.$docuuid.map{ $0 == "" })
            
            Div {
                
                /// Clean all
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/cross.png")
                            .marginRight(7.px)
                            .marginTop(3.px)
                            .height(18.px)
                    }
                    .float(.left)
                    
                    Span("Cerrar")
                        .color(.darkOrange)
                        .fontSize(18.px)
                    
                }
                .hidden(self.$captureDocuments.map{ $0.isEmpty })
                .marginRight(12.px)
                .marginTop(5.px)
                .float(.left)
                .class(.uibtn)
                .onClick {
                    self.resetView()
                }
                
                Div{
                    Div{
                        //
                        Div{
                            Span("Con Detalle")
                        }
                        .width(90.percent)
                        .marginTop(7.px)
                        .class(.uibtn)
                        .onClick {
                            self.downloadManualDocs(true)
                        }
                        
                        Div{
                            Span("Sin Detalle")
                        }
                        .width(90.percent)
                        .marginTop(7.px)
                        .class(.uibtn)
                        .onClick {
                            self.downloadManualDocs(false)
                        }
                        
                        Div().marginTop(7.px)
                    }
                    .hidden(self.$downloadDocumentViewIsHidden)
                    .backgroundColor(.transparentBlack)
                    .position(.absolute)
                    .borderRadius(12.px)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .bottom(42.px)
                    .right(30.px)
                    .zIndex(1)
                    .onClick { _, event in
                        self.downloadDocumentViewIsHidden = true
                        event.stopPropagation()
                    }
                    Div().clear(.both)
                    /// Descargar Docs
                    Div{
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/download2.png")
                                .marginTop(1.px)
                                .height(18.px)
                            
                        }
                        .marginTop(3.px)
                        .float(.left)
                        
                        Span("Descargar Docs")
                            .fontSize(18.px)
                        
                        Div{
                            Img()
                                .src(self.$downloadDocumentViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                .class(.iconWhite)
                                .paddingTop(7.px)
                                .width(14.px)
                        }
                        .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                        .paddingRight(3.px)
                        .paddingLeft(7.px)
                        .marginLeft(7.px)
                        .float(.right)
                        
                        Div().clear(.both)
                        
                    }
                    .class(.uibtn)
                    .onClick { _, event in
                        self.downloadDocumentViewIsHidden = !self.downloadDocumentViewIsHidden
                        event.stopPropagation()
                    }
                    
                }
                .hidden(self.$captureDocuments.map{ $0.isEmpty })
                .marginRight(18.px)
                .marginTop(1.px)
                .float(.right)
                
                /// Print barodes
                Div{
                    
                    Div {
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .marginTop(3.px)
                            .height(18.px)
                        
                    }
                    .marginTop(3.px)
                    .float(.left)
                    
                    Span("Imprimir Etiquetas")
                        .fontSize(18.px)
                    
                }
                .marginRight(18.px)
                .marginTop(3.px)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    self.printTags()
                }
                
                /// Agregar Producto
                Div{
                    
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .marginRight(7.px)
                            .marginTop(3.px)
                            .height(18.px)
                    }
                    .float(.left)
                    
                    
                    Span("Agregar Producto")
                        .fontSize(18.px)
                    
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .marginRight(12.px)
                .marginTop(5.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.selectPOC()
                }
                
                /// Guardar Ingreso Manual
                Div{
                    
                    self.selectManualDocumentDiv
                        .hidden(self.$selectManualDocumentMenuViewIsHidden)
                        .backgroundColor(.transparentBlack)
                        .position(.absolute)
                        .borderRadius(12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .marginTop(7.px)
                        .width(250.px)
                        .bottom(42.px)
                        .zIndex(1)
                        .onClick { _, event in
                            event.stopPropagation()
                        }
                    
                    Div{
                        Span(self.$custInventoryPurchaseManagerStatus.map{ $0?.description ?? "" })
                            .color(.darkOrange)
                            .fontSize(18.px)
                        
                        Div{
                            Img()
                                .src(self.$selectManualDocumentMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png" })
                                .class(.iconWhite)
                                .paddingTop(3.px)
                                .opacity(0.5)
                                .width(18.px)
                        }
                        .hidden(self.$custInventoryPurchaseManagerStatus.map{ $0?.validStatusUpdate.isEmpty ?? true })
                        .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                        .paddingRight(3.px)
                        .paddingLeft(7.px)
                        .marginLeft(7.px)
                        .float(.right)
                         
                    }
                    .marginRight(12.px)
                    .marginTop(5.px)
                    .height(24.px)
                    .class(.uibtn)
                    .onClick {
                        self.selectManualDocumentMenuViewIsHidden = !self.selectManualDocumentMenuViewIsHidden
                    }
                    
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .float(.right)
                .onClick{ _, event in
                    event.stopPropagation()
                }
                
                Div{
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .marginLeft(12.px)
                            .height(18.px)
                    
                        /// pre print  manual doc
                         Span("Imprimir")
                         
                    }
                    .marginRight(12.px)
                    .marginTop(5.px)
                    .height(24.px)
                    .class(.uibtn)
                    .onClick {
                        //self.downloadManualDocs(true) goku
                        self.printManualDispetion()
                    }
                }
                .hidden(self.$captureDocuments.map{ !$0.isEmpty })
                .float(.right)
                 
            }
            .hidden(self.$ingresoManual.map{ $0 != true })
            .marginTop(-3.px)
            
            self.recentXMLview
    }
    .height(100.percent)

    @DOM override var body: DOM.Content {
        
        Div{
           
            /* Header */
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                self.fileInput
               
                Div{
                    Img()
                        .src("/skyline/media/icon_list.png")
                        .class(.iconWhite)
                        .marginRight(7.px)
                        .height(18.px)
                    
                    Span("Ingreso Manual")
                        .fontSize(18.px)
                    
                }
                .hidden(self.$ingresoManual.map{ ($0 != nil) })
                .marginRight(18.px)
                .marginTop(-5.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    
                    addToDom(ToolReciveSendInventoryManualDispertionsView(
                        load: { doc in
                            self.loadManualDispertion(doc)
                        },
                        new: {
                            
                        }
                    ))
                    
                }
                
                Div{
                    Img()
                        .src("/skyline/media/upload2.png")
                        .height(18.px)
                        .marginRight(7.px)
                    
                    Span("Subir XML")
                        .fontSize(18.px)
                    
                }
                .hidden(self.$ingresoManual.map{ $0 == true })
                .marginRight(18.px)
                .marginTop(-5.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.fileInput.click()
                }
                
                Div{
                    Img()
                        .src("/skyline/media/icon_history.png")
                        .class(.iconWhite)
                        .height(18.px)
                        .marginRight(7.px)
                    
                    Span("XMLs Recientes")
                        .fontSize(18.px)
                    
                }
                .hidden(self.$ingresoManual.map{ $0 == true })
                .marginRight(18.px)
                .marginTop(-5.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.getDocControlPendingCapture()
                }
                
                Img()
                    .hidden(self.$ingresoManual.map{ $0 == true })
                    .src("/skyline/media/mobileScannerWhite.png")
                    .marginRight(7.px)
                    .marginTop(-7.px)
                    .cursor(.pointer)
                    .height(32.px)
                    .float(.right)
                    .onClick {
                        
                        API.custAPIV1.requestMobileCamara( 
                            type: .scanner,
                            connid: custCatchChatConnID,
                            eventid: self.viewid,
                            relatedid: nil,
                            relatedfolio: "",
                            multipleTakes: false
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
                            
                            showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                            
                        }
                    }
                
                Div(self.$uploadPercent)
                    .hidden(self.$ingresoManual.map{ $0 == true })
                    .color(.darkOrange)
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.right)
                
                H2("Ingresar inventario")
                    .color(.lightBlueText)
                    .float(.left)
            
                H2(self.$manualPurchaseManager.map{ ($0?.folio ?? "").isEmpty ? "" : "Manual \(($0?.folio ?? "")) \(($0?.name ?? ""))" })
                    .hidden(self.$manualPurchaseManager.map{ ($0?.folio ?? "").isEmpty })
                    .marginLeft(7.px)
                    .color(.gray)
                    .float(.left)
                
                Div().clear(.both)
                
            }
            
            Div().class(.clear).height(7.px)
            

            self.innerBody
            
        }
        .custom("height", "calc(100% - 70px)")
        .custom("width", "calc(100% - 70px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .left(24.px)
        .top(24.px)
 
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        onClick {
            self.selectManualDocumentMenuViewIsHidden = true
        }
        
        fileInput.$files.listen {
            if let file = $0.first {
                self.loadXMLFile(file)
            }
        }
        
        $captureDocuments.listen {
            if $0.count > 0 {
                self.canAddTargets = false
            }
        }
        
        $docid.listen {
            if $0 != nil {
                self.ingresoManual = false
            }
        }
        
        $manualItems.listen {
            
            self.itemsEmpty = $0.isEmpty
            
            self.udpateManualInventoryCatch()
            
            var totalItems: Int64 = 0
            
            $0.forEach { item in
                
                item.inventoryDestinations.forEach { _, destination in
                    totalItems += destination.units
                }
            }
            
            self.totalUnits = totalItems.toInt
        }
        
        $items.listen {
            
            self.itemsEmpty = $0.isEmpty
            
            var totalItems: Int64 = 0
            
            $0.forEach { item in
                item.inventoryDestinations.forEach { id, destination in
                    totalItems += destination.units
                }
            }
            
            self.totalUnits = totalItems.toInt
            
        }
        
        
        
        $manualPurchaseManager.listen {
            if let manager = $0 {
                self.custInventoryPurchaseManagerStatus = manager.status
            }
            else {
                self.custInventoryPurchaseManagerStatus = nil
            }
        }
        
        $custInventoryPurchaseManagerStatus.listen { status in
            
            self.selectManualDocumentMenuViewIsHidden = true
            
            self.selectManualDocumentDiv.innerHTML = ""
            
            status?.validStatusUpdate.forEach({ item in
                self.selectManualDocumentDiv.appendChild(
                    Div{
                        Span(item.description)
                        
                        Img()
                            .src("/skyline/media/help.png")
                            .marginRight(3.px)
                            .marginTop(3.px)
                            .float(.right)
                            .height(18.px)
                            .onClick { _, event in
                                addToDom(ConfirmationView(
                                    type: .ok,
                                    title: "Informacion \(item.description)",
                                    message: item.helpText
                                ))
                                event.stopPropagation()
                            }
                        
                    }
                    .width(95.percent)
                    .marginTop(7.px)
                    .class(.uibtn)
                    .onClick { _, event in
                        self.changeManualDispertionStatus(item)
                        event.stopPropagation()
                    }
                )
            })
            
            self.selectManualDocumentDiv.appendChild(Div().height(7.px))
            
        }
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            switch event {
            case .requestMobileScannerComplete:
                
                guard let payload = self.ws.requestMobileScannerComplete($0) else {
                    return
                }
                
                guard self.viewid == payload.eventid else {
                    return
                }
                
                // searchFolio
                let text = payload.text
                print("🟢  sat.gob.")
                if text.contains("/c/") {
                    
                    let parts = text.explode("/c/")
                    
                    guard parts.count > 1 else {
                        return
                    }
                    
                    let code = parts[1]

                    if !code.containCaracter(what: "-", where: 4) {
                        return
                    }
                    
                    
                    let prefix = String(code.prefix(2))
                     
                     print("⚪️ prefix \(prefix)")
                     
                    if let type = CustFolioSequenceTableType(rawValue: prefix) {
                        showError(.invalidFormat, "Lo sentimos \"\(type.description)\" no esta soportodo en este modulo.")
                    }
                    return
                }
                else if !text.contains("http") {
                    
                    if !text.containCaracter(what: "-", where: 4) {
                        return
                    }
                    
                    
                    let prefix = String(text.prefix(2))
                     
                     print("⚪️ prefix \(prefix)")
                     
                    if let type = CustFolioSequenceTableType(rawValue: prefix) {
                        showError(.invalidFormat, "Lo sentimos \"\(type.description)\" no esta soportodo en este modulo.")
                    }
                    return
                }
                else if text.contains("http") {
                    
                    if text.contains( "sat.gob.mx") {
                        
                        /**
                         https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?
                         id=F72D2ECA-25B6-43C3-9BE5-2DEBFFA7E96F&
                         re=TRA9001086M0&
                         rr=CUSE8006061Q1&
                         tt=8655.010000&fe=Qv8pXQ==
                         */
                        
                        guard let url = URLComponents(string: text) else {
                            return
                        }
                    
                        guard let id = UUID(uuidString: (url.queryItems?.first(where: { $0.name == "id" })?.value ?? "")) else {
                            showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                            return
                        }
                        
                        guard let emisor = url.queryItems?.first(where: { $0.name == "re" })?.value else {
                            showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                            return
                        }
                        
                        guard let receptor = url.queryItems?.first(where: { $0.name == "rr" })?.value else {
                            showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                            return
                        }
                        
                        let profiles = fiscalProfiles.map{ $0.rfc }
                        
                        if profiles.contains(emisor) {
                            
                            loadingView(show: true)

                            API.fiscalV1.loadDocument(docid: id) { resp in

                                loadingView(show: false)

                                guard let resp else {
                                    showError(.comunicationError, .serverConextionError)
                                    return
                                }

                                guard resp.status == .ok else {
                                    showError(.generalError, resp.msg)
                                    return
                                }

                                guard let payload = resp.data else {
                                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                                    return
                                }

                                if payload.doc.tipoDeComprobante == .pago {
                                    showError(.generalError, "Documentos de pagos aun no son soportados.")
                                }
                                
                                let view = ToolFiscalViewDocument(
                                    type: payload.type,
                                    doc: payload.doc,
                                    reldocs: payload.reldocs,
                                    account: payload.account
                                ) {
                                    /// Document canceled
                                    self.remove()
                                }
                                
                                addToDom(view)

                            }
                        
                        }
                        else if profiles.contains(receptor) {
                            addToDom(ToolReciveSendInventory(loadid: id))
                        }
                        else {
                            showError(.generalError, "Este documento no pertenece a ningun perfil fiscal de la ceunta")
                        }
                        
                    }
                    else {
                        showAlert(.alerta, "Formato no soportado, si cree que es un error, contacta a Soporte TC")
                    }
                }
                
            default:
                break
            }
            
        }
        
        if let loadid {
            loadXMLDocument(loadid)
        }
        
    }
    
    func printDispetion() {
        
        var fiscalItems: [CustManualInventoryCatchItems] = []
        
        var hasError: String? = nil
        
        items.forEach { item in
            
            if let _ = hasError {
                return
            }
            
            if item.isService {
                return
            }
            
            guard let pocid = item.pocid else  {
                hasError = "No se ha relacionado: \("\(item.item.noIdentificacion) \(item.item.descripcion)".purgeSpaces.uppercased())"
                return
            }
            
            let placedUnits = item.inventoryDestinations.map{ $1.units }.reduce(0, +)
            
            if item.item.cantidad.toInt64 != placedUnits {
                hasError = "No se ha colocado todas las unidades de: \("\(item.item.noIdentificacion) \(item.item.descripcion)".purgeSpaces.uppercased())"
                return
            }
            
            fiscalItems.append(
                .init(
                    pocid: pocid,
                    upc: item.upc,
                    brand: item.brand,
                    model: item.model,
                    name: item.name,
                    cost: (item.item.valorUnitario.toCents + item.taxes),
                    price: item.price,
                    avatar: "",
                    intentory: item.inventoryDestinations.map({ _, value in
                            .init(
                                selectedPlace: value.selectedPlace,
                                storeid: value.storeid,
                                storeName: value.storeName,
                                custAccountId: value.custAccountId,
                                placeid: value.placeid,
                                placeName: value.placeName,
                                bodid: value.bodid,
                                bodName: value.bodName,
                                secid: value.secid,
                                secName: value.secName,
                                units: value.units,
                                series: value.series,
                                missingUnitsCount: nil,
                                missingUnitsReason: nil
                            )
                    })
                )
            )
            
        }
        
        if let hasError {
            showError(.generalError, hasError)
            return
        }
        
        var table = Table {
            Tr{
                Td("UPC")
                Td("Marca")
                Td("Modelo")
                Td("Description")
                Td("Costo")
                Td("Precio")
                Td("T. Unis.")
                Td("T. Costo")
            }
        }
            .width(100.percent)
        
        var missingInventoryInvery = Table {
            Tr{
                Td("UPC")
                Td("Marca")
                Td("Modelo")
                Td("Description")
                Td("Costo")
                Td("Unis")
                Td("Total")
            }
        }
        .width(100.percent)
        
        var grandUnits: Int64 = 0
        var granMissingUnits: Int64 = 0
        var grandTotalUnits: Int64 = 0
        
        var granPaid: Int64 = 0
        var granCredit: Int64 = 0
        var granCost: Int64 = 0
        
        fiscalItems.forEach { item in
            
            var totalUnits: Int64 = 0
            var subCost: Int64 = 0
            
            item.intentory.forEach { subItem in
                
                var subUnits = subItem.units
                
                grandUnits += subItem.units
                
                
                granPaid += (subItem.units * item.cost)
                subCost += (subUnits * item.cost)
                
                if subItem.selectedPlace == .missingFromVendor || subItem.selectedPlace == .returnToVendor {
                    granMissingUnits += subUnits
                    granCredit += (subUnits * item.cost)
                    
                    missingInventoryInvery.appendChild(Tr{
                        Td(item.upc)
                        Td(item.brand)
                        Td(item.model)
                        Td(item.name)
                        Td(item.cost.formatMoney)
                        Td(subUnits.toString)
                        Td((subUnits * item.cost).formatMoney)
                    })
                    
                }
                else {
                    totalUnits += subUnits
                }
                
            }
            
            table.appendChild(
                Tr{
                    Td(item.upc)
                    Td(item.brand)
                    Td(item.model)
                    Td(item.name)
                    Td(item.cost.formatMoney)
                    Td(item.price.formatMoney)
                    Td(totalUnits.toString)
                    Td(subCost.formatMoney)
                }
            )
            
            table.appendChild(
                Tr{
                    Td()
                    Td()
                    Td("Destino").colSpan(3)
                    Td("Solicitadas")
                    Td("Faltantes")
                    Td("Unidades")
                }.color(.gray)
            )

            item.intentory.forEach { subItem in
                
                var totalUnits = subItem.units
                
                var missingUnits = ""
                
                table.appendChild(
                    Tr{
                        Td()
                        Td()
                        Td("\(subItem.selectedPlace.description) \(subItem.storeName)")
                            .colSpan(3)
                        Td(subItem.units.toString)
                        Td(missingUnits)
                        Td(totalUnits.toString)
                    }.color(.gray)
                )
            }
            
            grandTotalUnits += totalUnits
            granCost += subCost
            
        }
        
        let body = Div{
            
            table
            
            Div().height(23).clear(.both)
            
            
            Div{
                
                Div{
                    Table{
                        Tr{
                            Td("Articulos Comprados")
                                .align(.right)
                            Td(grandUnits.toString)
                                .width(150.px)
                                .align(.right)
                        }
                        if granMissingUnits > 0 {
                            Tr{
                                Td("Unidades Faltante")
                                    .align(.right)
                                Td(granMissingUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                            Tr{
                                Td("Articulos Surtidos")
                                    .align(.right)
                                Td(grandTotalUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                        }
                    }
                    .width(100.percent)
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    Table{
                        Tr{
                            Td("Total de Compra")
                                .align(.right)
                            Td(granPaid.formatMoney)
                                .width(200.px)
                                .align(.right)
                        }
                        if granCredit > 0 {
                            Tr{
                                Td("Credito/Faltante")
                                    .align(.right)
                                Td(granCredit.formatMoney)
                                    .width(150.px)
                                    .align(.right)
                            }
                            Tr{
                                Td("Balance de Compra")
                                    .align(.right)
                                Td(granCost.formatMoney)
                                    .width(200.px)
                                    .align(.right)
                            }
                        }
                        
                    }
                    .width(100.percent)
                }
                .width(50.percent)
                .float(.left)
                
            }
            
            Div().height(50).clear(.both)
            
            Table{
                Tr{
                    Td().width(10.percent)
                    Td()
                        .borderTop(width: .thin, style: .solid, color: .black)
                    Td().width(10.percent)
                    Td()
                        .borderTop(width: .thin, style: .solid, color: .black)
                    Td().width(10.percent)
                }
                Tr{
                    Td().width(10.percent)
                    Td("Ingresado Por").textAlign(.center)
                    Td().width(10.percent)
                    Td("Revizado Por").textAlign(.center)
                    Td().width(10.percent)
                }
            }
            .width(100.percent)
            
            Div().height(50).clear(.both)
            
        }
        
        if granCredit > 0 {
            
            /*
             
             docid = data.docid
             
             docuuid = uuid.uuidString
             
             vendorid = data.vendor.id
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
            
            body.appendChild(Div{
                H2{
                    Span(self.officialDate)
                        .float(.right)
                    Span("Vale por falta de mercancia")
                }
                Div{
                    
                    H3("\(self.vendorRfc) \(self.vendorRazon)")
                    
                }
                
                H3("Monto de vale: $\(granCredit.formatMoney)")
                    .fontWeight(.bolder)
                Div{
                    
                    Div{
                        Table{
                            Tr{
                                Td("Articulos Comprados")
                                    .align(.right)
                                Td(grandUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                            if granMissingUnits > 0 {
                                Tr{
                                    Td("Unidades Faltante")
                                        .align(.right)
                                    Td(granMissingUnits.toString)
                                        .width(150.px)
                                        .align(.right)
                                }
                                Tr{
                                    Td("Articulos Surtidos")
                                        .align(.right)
                                    Td(grandTotalUnits.toString)
                                        .width(150.px)
                                        .align(.right)
                                }
                            }
                        }
                        .width(100.percent)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Table{
                            Tr{
                                Td("Total de Compra")
                                    .align(.right)
                                Td(granPaid.formatMoney)
                                    .width(200.px)
                                    .align(.right)
                            }
                            if granCredit > 0 {
                                Tr{
                                    Td("Credito/Faltante")
                                        .align(.right)
                                    Td(granCredit.formatMoney)
                                        .width(150.px)
                                        .align(.right)
                                }
                                Tr{
                                    Td("Balance de Compra")
                                        .align(.right)
                                    Td(granCost.formatMoney)
                                        .width(200.px)
                                        .align(.right)
                                }
                            }
                            
                        }
                        .width(100.percent)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().height(3).clear(.both)
                
                H3("Detalle")
                
                missingInventoryInvery
            }
                .borderTop(width: .medium, style: .dashed, color: .black)
                .padding(all: 7.px))
            
        }
        
        _ = JSObject.global.generalPrint!(body.innerHTML)
        
    }
    
    func printManualDispetion() {
        
        
        /*
        FiscalConceptDestinationManualItemsView
         
         var documentStatus: State<CustInventoryPurchaseManagerStatus?>
         /// store, order, sold, merm, returnToVendor
         let selectedPlace: InventoryPlaceType
         let storeid: UUID?
         let storeName: String
         let custAccountId: UUID?
         ///  can be order id, sale id
         let placeid: UUID?
         let placeName: String
         let bodid: UUID?
         let bodName: String
         let secid: UUID?
         let secName: String
         let units: Int64
         let series: [String]
         @State var missingUnitsCount: Int64?
         var missingUnitsReason: InventoryPlaceType?
         
        */
        /// [ storeId :  [pocid: [CustManualInventoryCatchItems]]  ]
        var storeRefrence: [UUID:[CustManualInventoryCatchItems]] = [:]
        
        Console.clear()
        
        print("🟡 manualItems.count \(manualItems.count) ")
        
        manualItems.forEach { view in
            
            print("🟡 manualItems.view.inventoryDestinations.count \(view.inventoryDestinations.count) ")
            
            view.inventoryDestinations.forEach { _, dest in
                
                switch dest.selectedPlace{
                case .store:
                    
                    guard let storeId = dest.storeid else {
                        return
                    }
                    
                    if let _ = storeRefrence[storeId] {
                        
                        var inventory: [CustManualInventoryCatchInventory] = []
                        
                        view.inventoryDestinations.forEach { _, value in
                            if storeId == value.storeid {
                                inventory.append(.init(
                                    selectedPlace: value.selectedPlace,
                                    storeid: value.storeid,
                                    storeName: value.storeName,
                                    custAccountId: value.custAccountId,
                                    placeid: value.placeid,
                                    placeName: value.placeName,
                                    bodid: value.bodid,
                                    bodName: value.bodName,
                                    secid: value.secid,
                                    secName: value.secName,
                                    units: value.units,
                                    series: value.series,
                                    missingUnitsCount: value.missingUnitsCount,
                                    missingUnitsReason: value.missingUnitsReason
                                ))
                            }
                        }
                        
                        storeRefrence[storeId]?.append(.init(
                            pocid: view.pocid,
                            upc: view.upc,
                            brand: view.brand,
                            model: view.model,
                            name: view.name,
                            cost: view.cost,
                            price: view.price,
                            avatar: "",
                            intentory: inventory
                        ))
                    }
                    else {
                        
                        var inventory: [CustManualInventoryCatchInventory] = []
                        
                        view.inventoryDestinations.forEach { _, value in
                            if storeId == value.storeid {
                                inventory.append(.init(
                                    selectedPlace: value.selectedPlace,
                                    storeid: value.storeid,
                                    storeName: value.storeName,
                                    custAccountId: value.custAccountId,
                                    placeid: value.placeid,
                                    placeName: value.placeName,
                                    bodid: value.bodid,
                                    bodName: value.bodName,
                                    secid: value.secid,
                                    secName: value.secName,
                                    units: value.units,
                                    series: value.series,
                                    missingUnitsCount: value.missingUnitsCount,
                                    missingUnitsReason: value.missingUnitsReason
                                ))
                            }
                        }
                        
                        storeRefrence[storeId] = [.init(
                            pocid: view.pocid,
                            upc: view.upc,
                            brand: view.brand,
                            model: view.model,
                            name: view.name,
                            cost: view.cost,
                            price: view.price,
                            avatar: "",
                            intentory: inventory
                        )]
                    }
                    
                case .order:
                    break
                case .sold:
                    break
                case .merm:
                    break
                case .returnToVendor:
                    break
                case .missingFromVendor:
                    break
                case .concession:
                    break
                case .unconcession:
                    break
                }
            }
        }
        
        /*
        let items: [CustManualInventoryCatchItems] = manualItems.map{ view in
                .init(
                    pocid: view.pocid,
                    upc: view.upc,
                    brand: view.brand,
                    model: view.model,
                    name: view.name,
                    cost: view.cost,
                    price: view.price,
                    avatar: "",
                    intentory: view.inventoryDestinations.map({ (key: UUID, value: FiscalConceptDestinationManualItemsView) in
                        CustManualInventoryCatchInventory(
                            selectedPlace: value.selectedPlace,
                            storeid: value.storeid,
                            storeName: value.storeName,
                            custAccountId: value.custAccountId,
                            placeid: value.placeid,
                            placeName: value.placeName,
                            bodid: value.bodid,
                            bodName: value.bodName,
                            secid: value.secid,
                            secName: value.secName,
                            units: value.units,
                            series: value.series,
                            missingUnitsCount: value.missingUnitsCount,
                            missingUnitsReason: value.missingUnitsReason
                        )
                    })
                )
        }
        
        var table = Table {
            Tr{
                Td("UPC")
                Td("Marca")
                Td("Modelo")
                Td("Description")
                Td("Costo")
                Td("Precio")
                Td("T. Unis.")
                Td("T. Costo")
            }
        }
            .width(100.percent)
        
        var missingInventoryInvery = Table {
            Tr{
                Td("UPC")
                Td("Marca")
                Td("Modelo")
                Td("Description")
                Td("Costo")
                Td("Unis")
                Td("Total")
            }
        }
        .width(100.percent)
        
        var grandUnits: Int64 = 0
        var granMissingUnits: Int64 = 0
        var grandTotalUnits: Int64 = 0
        
        var granPaid: Int64 = 0
        var granCredit: Int64 = 0
        var granCost: Int64 = 0
        
        items.forEach { item in
            
            var totalUnits: Int64 = 0
            var subCost: Int64 = 0
            
            item.intentory.forEach { subItem in
                
                var subUnits = subItem.units
                
                if let missingUnitsCount = subItem.missingUnitsCount {
                    
                    totalUnits -= missingUnitsCount
                    
                    subUnits -= missingUnitsCount
                    
                    granMissingUnits += missingUnitsCount
                    
                    granCredit += (missingUnitsCount * item.cost)
                    
                }
                
                grandUnits += subItem.units
                totalUnits += subUnits
                
                granPaid += (subItem.units * item.cost)
                subCost += (subUnits * item.cost)
                
            }
            
            table.appendChild(
                Tr{
                    Td(item.upc)
                    Td(item.brand)
                    Td(item.model)
                    Td(item.name)
                    Td(item.cost.formatMoney)
                    Td(item.price.formatMoney)
                    Td(totalUnits.toString)
                    Td(subCost.formatMoney)
                }
            )
            
            table.appendChild(
                Tr{
                    Td()
                    Td()
                    Td("Destino").colSpan(3)
                    Td("Solicitadas")
                    Td("Faltantes")
                    Td("Unidades")
                }.color(.gray)
            )

            item.intentory.forEach { subItem in
                
                var totalUnits = subItem.units
                
                var missingUnits = ""
                
                if let missingUnitsCount = subItem.missingUnitsCount {
                    missingUnits = missingUnitsCount.toString
                    totalUnits -= missingUnitsCount
                    
                    missingInventoryInvery.appendChild(Tr{
                        Td(item.upc)
                        Td(item.brand)
                        Td(item.model)
                        Td(item.name)
                        Td(item.cost.formatMoney)
                        Td(missingUnits)
                        Td((missingUnitsCount * item.cost).formatMoney)
                    })
                    
                }
                
                table.appendChild(
                    Tr{
                        Td()
                        Td()
                        Td("\(subItem.selectedPlace.description) \(subItem.storeName)")
                            .colSpan(3)
                        Td(subItem.units.toString)
                        Td(missingUnits)
                        Td(totalUnits.toString)
                    }.color(.gray)
                )
            }
            
            grandTotalUnits += totalUnits
            granCost += subCost
            
        }
        
        let body = Div{
            
            table
            
            Div().height(23).clear(.both)
            
            
            Div{
                
                Div{
                    Table{
                        Tr{
                            Td("Articulos Comprados")
                                .align(.right)
                            Td(grandUnits.toString)
                                .width(150.px)
                                .align(.right)
                        }
                        if granMissingUnits > 0 {
                            Tr{
                                Td("Unidades Faltante")
                                    .align(.right)
                                Td(granMissingUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                            Tr{
                                Td("Articulos Surtidos")
                                    .align(.right)
                                Td(grandTotalUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                        }
                    }
                    .width(100.percent)
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    Table{
                        Tr{
                            Td("Total de Compra")
                                .align(.right)
                            Td(granPaid.formatMoney)
                                .width(200.px)
                                .align(.right)
                        }
                        if granCredit > 0 {
                            Tr{
                                Td("Credito/Faltante")
                                    .align(.right)
                                Td(granCredit.formatMoney)
                                    .width(150.px)
                                    .align(.right)
                            }
                            Tr{
                                Td("Balance de Compra")
                                    .align(.right)
                                Td(granCost.formatMoney)
                                    .width(200.px)
                                    .align(.right)
                            }
                        }
                        
                    }
                    .width(100.percent)
                }
                .width(50.percent)
                .float(.left)
                
            }
            
            Div().height(50).clear(.both)
            
            Table{
                Tr{
                    Td().width(10.percent)
                    Td()
                        .borderTop(width: .thin, style: .solid, color: .black)
                    Td().width(10.percent)
                    Td()
                        .borderTop(width: .thin, style: .solid, color: .black)
                    Td().width(10.percent)
                }
                Tr{
                    Td().width(10.percent)
                    Td("Ingresado Por").textAlign(.center)
                    Td().width(10.percent)
                    Td("Revizado Por").textAlign(.center)
                    Td().width(10.percent)
                }
            }
            .width(100.percent)
            
            Div().height(50).clear(.both)
            
        }
        
        if granCredit > 0 {
            
            guard let manualPurchaseManager = self.manualPurchaseManager else {
                fatalError("No se localizo razon de regreso")
            }
            
            body.appendChild(Div{
                H2{
                    Span(getDate(manualPurchaseManager.createdAt).formatedLong)
                        .float(.right)
                    Span("Vale por falta de mercancia")
                }
                Div{
                    
                    H3("\(manualPurchaseManager.name) \(self.vendorRfc) \(self.vendorRazon)")
                    
                }
                
                H3("Monto de vale: $\(granCredit.formatMoney)")
                    .fontWeight(.bolder)
                Div{
                    
                    Div{
                        Table{
                            Tr{
                                Td("Articulos Comprados")
                                    .align(.right)
                                Td(grandUnits.toString)
                                    .width(150.px)
                                    .align(.right)
                            }
                            if granMissingUnits > 0 {
                                Tr{
                                    Td("Unidades Faltante")
                                        .align(.right)
                                    Td(granMissingUnits.toString)
                                        .width(150.px)
                                        .align(.right)
                                }
                                Tr{
                                    Td("Articulos Surtidos")
                                        .align(.right)
                                    Td(grandTotalUnits.toString)
                                        .width(150.px)
                                        .align(.right)
                                }
                            }
                        }
                        .width(100.percent)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Table{
                            Tr{
                                Td("Total de Compra")
                                    .align(.right)
                                Td(granPaid.formatMoney)
                                    .width(200.px)
                                    .align(.right)
                            }
                            if granCredit > 0 {
                                Tr{
                                    Td("Credito/Faltante")
                                        .align(.right)
                                    Td(granCredit.formatMoney)
                                        .width(150.px)
                                        .align(.right)
                                }
                                Tr{
                                    Td("Balance de Compra")
                                        .align(.right)
                                    Td(granCost.formatMoney)
                                        .width(200.px)
                                        .align(.right)
                                }
                            }
                            
                        }
                        .width(100.percent)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().height(3).clear(.both)
                
                H3("Detalle")
                
                missingInventoryInvery
            }
                .borderTop(width: .medium, style: .dashed, color: .black)
                .padding(all: 7.px))
            
        }
        */
    
        let body = Div()
        
        storeRefrence.forEach { storeId, items in
            
            guard let store = stores[storeId] else {
                return
            }
            
            var table = Table {
                Tr{
                    Td("TEINDA: \(store.name)")
                        .colSpan(8)
                }
                Tr{
                    Td("UPC")
                    Td("Marca")
                    Td("Modelo")
                    Td("Description")
                    Td("Costo")
                    Td("Precio")
                    Td("Unis.")
                    Td("Total")
                }
            }
                .width(100.percent)
            
            var missingInventoryInvery = Table {
                Tr{
                    Td("UPC")
                    Td("Marca")
                    Td("Modelo")
                    Td("Description")
                    Td("Costo")
                    Td("Unis")
                    Td("Total")
                }
            }
            .width(100.percent)
            
            var grandUnits: Int64 = 0
            var granMissingUnits: Int64 = 0
            var grandTotalUnits: Int64 = 0
            
            var granPaid: Int64 = 0
            var granCredit: Int64 = 0
            var granCost: Int64 = 0
            
            items.forEach { item in
                
                var totalUnits: Int64 = 0
                var subCost: Int64 = 0
                
                item.intentory.forEach { subItem in
                    
                    var subUnits = subItem.units
                    
                    if let missingUnitsCount = subItem.missingUnitsCount {
                        
                        totalUnits -= missingUnitsCount
                        
                        subUnits -= missingUnitsCount
                        
                        granMissingUnits += missingUnitsCount
                        
                        granCredit += (missingUnitsCount * item.cost)
                        
                    }
                    
                    grandUnits += subItem.units
                    totalUnits += subUnits
                    
                    granPaid += (subItem.units * item.cost)
                    subCost += (subUnits * item.cost)
                    
                }
                
                /*
                 Td("UPC")
                 Td("Marca")
                 Td("Modelo")
                 Td("Description")
                 Td("Costo")
                 Td("Precio")
                 Td("Unis.")
                 Td("Total")
                 */
                
                table.appendChild(
                    Tr{
                        Td(item.upc)
                        Td(item.brand)
                        Td(item.model)
                        Td(item.name)
                        Td(item.cost.formatMoney)
                        Td(item.price.formatMoney)
                        Td(totalUnits.toString)
                        Td(subCost.formatMoney)
                    }
                )
                
                /*
                 
                table.appendChild(
                    Tr{
                        Td()
                        Td()
                        Td("Destino").colSpan(3)
                        Td("Solicitadas")
                        Td("Faltantes")
                        Td("Unidades")
                    }.color(.gray)
                )
                
                item.intentory.forEach { subItem in
                    
                    var totalUnits = subItem.units
                    
                    var missingUnits = ""
                    
                    if let missingUnitsCount = subItem.missingUnitsCount {
                        missingUnits = missingUnitsCount.toString
                        totalUnits -= missingUnitsCount
                        
                        missingInventoryInvery.appendChild(Tr{
                            Td(item.upc)
                            Td(item.brand)
                            Td(item.model)
                            Td(item.name)
                            Td(item.cost.formatMoney)
                            Td(missingUnits)
                            Td((missingUnitsCount * item.cost).formatMoney)
                        })
                        
                    }
                    
                    table.appendChild(
                        Tr{
                            Td()
                            Td()
                            Td("\(subItem.selectedPlace.description) \(subItem.storeName)")
                                .colSpan(3)
                            Td(subItem.units.toString)
                            Td(missingUnits)
                            Td(totalUnits.toString)
                        }.color(.gray)
                    )
                }
                 
                */
                
                body.appendChild(table)
                
                grandTotalUnits += totalUnits
                granCost += subCost
                
            }
            
            table.appendChild(
                Tr{
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td(grandTotalUnits.toString)
                    Td(granCost.formatMoney)
                }
            )
        }
        
        _ = JSObject.global.generalPrint!(body.innerHTML)
        
    }
    
    func changeManualDispertionStatus(_ status: CustInventoryPurchaseManagerStatus){
        
        self.selectManualDocumentMenuViewIsHidden = true
        
        guard let manualPurchaseManager else {
            return
        }
        
        if status == .externalDispute || status == .internalDispute || status == .canceled {
            
            let view = ConfirmationView(
                type: .yesNo,
                title: "Cambio Status: \(status.description.uppercased())",
                message: status.helpText,
                comments: .required
            ){ isConfirmed, comment in
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.updateManualDispertion(
                        docId: manualPurchaseManager.id,
                        type: .status(status),
                        comment: comment
                    ) { resp in
                    
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else{
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        self.custInventoryPurchaseManagerStatus = status
                    }
                }
            }
            
            addToDom(view)
            
            return
        }
        else if status == .processed {
            
            var hasError = false
            
            manualItems.forEach { view in
                var totalUnits: Int64 =  0
                view.inventoryDestinations.forEach { id, subView in
                    totalUnits += subView.units
                }
                if view.units != totalUnits {
                    showError(.generalError, "Hacen falta ingresos en \(view.name) \(view.brand) \(view.model)")
                    hasError = true
                }
            }
            
            if hasError {
                return
            }
            
            let view = ConfirmationView(
                type: .yesNo,
                title: "Crear Ingreso manual",
                message: "Confirme ingreso de productos"
            ){ isConfirmed, comment in
                if isConfirmed {
                    self.saveManualInventory()
                }
            }
            
            addToDom(view)
            
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.updateManualDispertion(
            docId: manualPurchaseManager.id,
            type: .status(status),
            comment: nil
        ) { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            self.custInventoryPurchaseManagerStatus = status
        }
        
    }
    
    func loadXMLFile(_ file: File) {
        
        resetView()
        
        let xhr = XMLHttpRequest()
        
        xhr.onLoadStart {
            self.uploadPercent = "0"
        }
        
        xhr.onError { jsValue in
            showError(.comunicationError, .serverConextionError)
            self.uploadPercent = ""
        }
        
        xhr.onLoadEnd {
            
            self.uploadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.generalError, .serverConextionError + " 001")
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.generalError, .serverConextionError + " 002")
                return
            }
            
            print("⭐️  loadXMLFile  ⭐️")
            
            print(responseText)
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.fiscalV1.FiscalXMLIngresoResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.generalError, "No se pudo cargar dato")
                    return
                }
                
                self.loadData(data)
                
            } catch {
                showError(.generalError, .serverConextionError + " 003")
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            self.uploadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        formData.append("file", file, filename: file.name)
        
        xhr.open(method: "POST", url: "https://intratc.co/api/fiscal/v1/uploadFiscaXMLIngreso")
        
        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web, 
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        xhr.send(formData)
        
    }

    func loadData(_ data: API.fiscalV1.FiscalXMLIngresoResponse) {
        
        guard let dateParts = data.document.fecha.explode("T").first?.explode("-") else {
            showError(.generalError, "No se pudo obtener fecha de creacion 001.")
            return
        }
        
        guard dateParts.count == 3 else {
            showError(.generalError, "No se pudo obtener fecha de creacion 002.")
            return
        }
        
        guard let uuid = data.document.complemento.timbreFiscalDigital?.uuid else {
            showError(.generalError, "No se pudo localizar uuid e doc.")
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
            showError(.generalError, "No se pudo obtener fecha de creacion 003.")
            return
        }
        
        docid = data.docid
        
        docuuid = uuid.uuidString
        
        vendorid = data.vendor.id
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
        
        captureDocuments = data.captureDocuments
        
        controlStatus = data.controlStatus
        
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
        
        self.items.forEach { view in
            view.remove()
        }
        
        self.items.removeAll()
        
        self.hasProduct = false
        
        data.document.conceptos.concepto.forEach { item in
            
            var pocid: UUID? = nil
            
            data.pocs.forEach { poc in
                
                if item.descripcion.pseudo.contains(poc.description.pseudo) {
                    pocid = poc.pocid
                }
                if pocid == nil{
                    if !item.noIdentificacion.pseudo.isEmpty {
                        if item.noIdentificacion.pseudo == poc.code.pseudo {
                            pocid = poc.pocid
                        }
                    }
                }
            }
            
            let view = FiscalConceptView(
                documentStatus: self.$custInventoryPurchaseManagerStatus,
                itemno: cc,
                docid: docid,
                item: item,
                pocid: pocid,
                vendorid: self.vendorid!,
                vendorname: self.vendorRfc,
                canAddTargets: self.$canAddTargets
            ) {
                
            }
            
            if !view.isService {
                self.hasProduct = true
            }
            
            self.items.append(view)
            
            self.productDiv.appendChild(view)
            
            if let control = data.control[cc.toString]{
                
                if item.descripcion.pseudo == control.pseudo {
                    
                    view.pocid = control.pocid
                    
                    control.items.forEach { item in
                    
                        let subView = FiscalConceptDestinationItemsView(
                            addMoreButtonIsHidden: view.canAddTargets,
                            selectedPlace: item.selectedPlace,
                            storeid: item.storeid,
                            storeName: item.storeName,
                            custAccountId: item.custAccountId,
                            placeid: item.placeid,
                            placeName: item.placeName,
                            bodid: item.bodid,
                            bodName: item.bodName,
                            secid: item.secid,
                            secName: item.secName,
                            units: item.units,
                            series: item.series
                        ) { viewid in
                            view.inventoryDestinations.removeValue(forKey: viewid)
                            view.updateIngresModification()
                        }
                        
                        view.inventoryDestinations[subView.viewid] = subView
                        
                        view.selectedInventoryView.appendChild(subView)
                        
                    }
                }
            }
            
            cc += 1
            
        }
        
    }
    
    func getDocControlPendingCapture() {
        
        recentXMLviewIsHidden = false
        
        loadingView(show: true)
        
        API.fiscalV1.getDocControlPendingCapture { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.recentXMLviewFilterText = ""
            
            /*
            self.recentXMLviewFilterSelect.innerHTML = ""
            
            self.recentXMLviewFilterSelect.appendChild(
                Option("Ver Todos...")
                    .value("")
            )
            */
            
            self.docs.forEach { doc in
                doc.remove()
            }
            
            self.docs.removeAll()
            
            var cc = 0
            
            /// Name / RFC
            self.vendorRefrence = [:]
            
            self.vendorName = []
            
            data.forEach { item in
                
                if !self.vendorName.contains(item.emisorName){
                    self.vendorName.append(item.emisorName.uppercased())
                    self.vendorRefrence[item.emisorName] = item.emisorRfc
                }
                
                let view = FiscalDocumentRowView(isEven: cc.isEven, item: item) { id in
                    self.loadXMLDocument(id)
                }.hidden(self.$recentXMLviewFilterText.map{ ($0 == item.emisorRfc || $0 == "") ? false : true})
                
                self.docs.append(view)
                
                self.recentXMLviewResuls.appendChild(view)
                
                cc += 1
            }
            
            self.vendorName.sort()
            
        }
    }
    
    func loadXMLDocument(_ id: UUID){
        
        loadingView(show: true)
        
        API.fiscalV1.getFiscaXMLIngreso(id: id) { resp in
            
            loadingView(show: false)
            
            self.recentXMLviewIsHidden = true
            
            guard let resp = resp else {
                return
            }
            
            guard resp.status == .ok else{
                return
            }
            
            guard let doc = resp.data else {
                showError(.generalError, resp.msg)
                return
            }
            
            self.loadData(doc)
        }
        
    }
    
    func resetView() {
        
        docuuid = ""
        vendorid = nil
        vendorFolio = ""
        businessName = ""
        
        vendorRfc = ""
        vendorRazon = ""
        
        finaceContact = ""
        oporationContact = ""
        
        receptorRfc = ""
        receptorRazon = ""
        
        fiscalUse = nil
        paymentForm = nil
        docFolio = ""
        docSerie = ""
        total = ""
        
        officialDate = ""
        
        balance = ""
        
        items.removeAll()
        
        manualItems.removeAll()
        
        hasProduct = false
        
        ingresoManual = nil
        
        manualPurchaseManager = nil
        
        custInventoryPurchaseManagerStatus = nil
    }
    
    func archiveDoc() {
        
        var confirmTitle = "Confirme Accion"
    
        var confirmMessage = "¿Confirme que quiere archivar este documento?"
        
        if custCatchHerk < 4 && hasProduct {
            confirmTitle = "Confirme Solicitud"
            confirmMessage = "Se va enviar una solicitud para archivar documento. ¿Desea Continuar?"
        }
        
        guard let docid else {
            return
        }
        
        addToDom(ConfirmView(type: .yesNo, title: confirmTitle, message: confirmMessage, requiersComment: true) { isConfirmed, comment in
            
            if isConfirmed {
                
                loadingView(show: true)
                
                API.fiscalV1.fileDocument(
                    docid: docid,
                    reason: comment,
                    itemCount: (self.hasProduct ? 1 : 0)
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
                    
                    showSuccess(.operacionExitosa, "Se enviado correnctamemt")
                    
                    self.controlStatus = ((custCatchHerk > 4) ? .filed : .filedRequest )
                    
                    
                    if custCatchHerk > 4 {
                        self.docs.forEach { view in
                            if view.item.id == docid {
                                view.remove()
                            }
                        }
                    }
                    
                }
            }
        })
        
    }
    
    func saveDoc() {
        
        guard let docid = docid else {
            showError(.generalError, "No se obtuvo id del documento, reinice el proceso si continua el problema contacte a Soporte TC")
            return
        }

        var hasError = false
        
        var errorMgs = ""
        
        var _items: [DispersionDocumentItem] = []
        
        items.forEach { item in
            
            if hasError { return }
            
            if item.isService {
                return
            }
            
            guard let pocid = item.pocid else {
                hasError = true
                errorMgs = "Seleccione producto para: \(item.item.descripcion)"
                return
            }
            
            let units = item.units
            
            var workedUnits: Int64 = 0
            
            var dispertion: [CustManualInventoryCatchInventory] = []
            
            item.inventoryDestinations.forEach { id, target in
                
                workedUnits += target.units
                
                dispertion.append(.init(
                    selectedPlace: target.selectedPlace,
                    storeid: target.storeid,
                    storeName: target.storeName,
                    custAccountId: target.custAccountId,
                    placeid: target.placeid,
                    placeName: target.placeName,
                    bodid: target.bodid,
                    bodName: target.bodName,
                    secid: target.secid,
                    secName: target.secName,
                    units: target.units,
                    series: target.series,
                    missingUnitsCount: nil,
                    missingUnitsReason: nil
                ))
                
            }
            
            _items.append( .init(
                code: item.item.noIdentificacion,
                description: item.item.descripcion,
                fiscCode: item.item.claveProdServ,
                fiscUnit: item.item.claveUnidad,
                cost: item.item.importe.toInt64,
                pocid: pocid,
                dispertion: dispertion
            ))
            
            if workedUnits != units {
                hasError = true
                errorMgs = "Falta procesar unidades de: \(item.item.descripcion)"
            }
            
        }
        
        if hasError {
            showError(.generalError, errorMgs)
            return
        }
        
        let payload: API.custPOCV1.CreateDispersionDocumentRequest = .init(docid: docid, storeid: custCatchStore, items: _items)
        
        do {
            let data = try JSONEncoder().encode(payload)
            
            print(String(data: data, encoding: .utf8)!)
            
        } catch  {
            
        }
        
        do {
            let data = try JSONEncoder().encode(_items)
            
            if let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            
        } catch  {
            
        }
        
        loadingView(show: true)
        
        API.custPOCV1.createDispersionDocument(
            docid: docid,
            storeid: custCatchStore,
            items: _items
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
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.captureDocuments = data
            
            self.downloadDocs()
            
            self.barcodes = self.items.map{ .init(
                id: $0.pocid!,
                upc: $0.upc,
                brand: "",
                model: "",
                name: $0.item.descripcion,
                price: $0.price
            )}
            
            self.docs.forEach { view in
                if view.item.id == docid {
                    view.remove()
                }
            }
        }
    }
    
    func loadFilter() {
        
        recentXMLviewResults.innerHTML = ""
        
        if vendorName.isEmpty {
            return
        }
        
        if recentXMLviewFilterSearch.isEmpty {
            vendorName.forEach { vendor in
                
                guard let rfc = vendorRefrence[vendor] else {
                    return
                }
                
                recentXMLviewResults.appendChild(
                    Div(vendor)
                        .class(.uibtnLarge, .oneLineText)
                        .margin(all: 3.px)
                        .width(95.percent)
                        .onClick {
                            self.recentXMLviewFilterText = rfc
                            self.recentXMLviewFilterSearch = vendor
                        }
                )
                
            }
        }
        else {
            
            var included: [String] = []
            
            vendorName.forEach { vendor in
                
                guard let rfc = vendorRefrence[vendor] else {
                    return
                }
                
                if vendor.hasPrefix(recentXMLviewFilterSearch.uppercased()) {
                    
                    included.append(vendor)
                    
                    recentXMLviewResults.appendChild(
                        Div(vendor)
                            .class(.uibtnLarge, .oneLineText)
                            .margin(all: 3.px)
                            .width(95.percent)
                            .onClick {
                                self.recentXMLviewFilterText = rfc
                                self.recentXMLviewFilterSearch = vendor
                            }
                    )
                    
                }
                
                if vendor.contains(recentXMLviewFilterSearch.uppercased()) && !included.contains(vendor) {
                    
                    included.append(vendor)
                    
                    recentXMLviewResults.appendChild(
                        Div(vendor)
                            .class(.uibtnLarge, .oneLineText)
                            .margin(all: 3.px)
                            .width(95.percent)
                            .onClick {
                                self.recentXMLviewFilterText = rfc
                                self.recentXMLviewFilterSearch = vendor
                            }
                    )
                    
                }
                
            }
        }
    }
    
    func downloadDocs() {
        
        if captureDocuments.isEmpty {
            showAlert(.alerta, "No hay docuemntos por descargar")
            return
            
        }
        
        guard let docid = docid else {
            return
        }
        
        loadingView(show: true)
        
        downloadDocumentControlOrders(id: docid)
        
        Dispatch.asyncAfter(3.0) {
            loadingView(show: false)
        }
        
        
    }
    
    func addPOC(
        _ pocid: UUID,
        _ upc: String,
        _ brand: String,
        _ model: String,
        _ name: String,
        _ cost: Int64?,
        _ price: Int64,
        _ avatar: String,
        _ reqSeries: Bool,
        _ items: [CustManualInventoryCatchInventory] = [],
        _ autoLoad: Bool = true
    ) {
        
        if let cost {
            
            let view: FiscalConceptManualView = .init(
                isEven: self.manualItems.count.isEven,
                documentStatus: self.$custInventoryPurchaseManagerStatus,
                pocid: pocid,
                upc: upc,
                brand: brand,
                model: model,
                name: name,
                cost: cost,
                price: price,
                removeRow: { viewid in
                    
                    addToDom(ConfirmView(type: .yesNo, title: "Eliminar Producto", message: "¿Quiere remover este elemnto, no se puede revertir?", callback: { isConfirmed, comment in
                        
                        if isConfirmed {
                            
                            var _manualItems: [FiscalConceptManualView] = []
                            
                            self.manualItems.forEach { view in
                                
                                if view.viewid == viewid {
                                    view.remove()
                                    return
                                }
                                
                                _manualItems.append(view)
                                
                            }
                            
                            self.manualItems = _manualItems
                            
                        }
                    }))
                },
                itemsChanged: {
                    self.recalculateManualBalance()
                    self.udpateManualInventoryCatch()
                }
            )
            
            if !items.isEmpty {
                items.forEach { item in
                    view.addStoragePlace(
                        item.selectedPlace,
                        item.storeid,
                        item.storeName,
                        item.custAccountId,
                        item.placeid,
                        item.placeName,
                        item.bodid,
                        item.bodName,
                        item.secid,
                        item.secName,
                        item.units,
                        item.series,
                        item.missingUnitsCount,
                        item.missingUnitsReason
                    )
                }
            }
            
            view.autoLoad = autoLoad
            
            self.manualItems.append(view)
            
            self.productDiv.appendChild(view)
            
            self.recalculateManualBalance()
            
            return
        }
        
        loadingView(show: false)
        
        API.custPOCV1.getPOCCost(id: pocid) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let cost = resp.data else {
                showError(.generalError, "No se obtuvo data de la respusta")
                return
            }
        
            let view: FiscalConceptManualView = .init(
                isEven: self.manualItems.count.isEven, 
                documentStatus: self.$custInventoryPurchaseManagerStatus,
                pocid: pocid,
                upc: upc,
                brand: brand,
                model: model,
                name: name,
                cost: cost,
                price: price,
                removeRow: { viewid in
                    
                    addToDom(ConfirmView(type: .yesNo, title: "Eliminar Producto", message: "¿Quiere remover este elemnto, no se puede revertir?", callback: { isConfirmed, comment in
                        
                        if isConfirmed {
                            
                            var _manualItems: [FiscalConceptManualView] = []
                            
                            self.manualItems.forEach { view in
                                
                                if view.viewid == viewid {
                                    view.remove()
                                    return
                                }
                                
                                _manualItems.append(view)
                                
                            }
                            
                            self.manualItems = _manualItems
                            
                        }
                    }))
                },
                itemsChanged: {
                    self.recalculateManualBalance()
                    self.udpateManualInventoryCatch()
                }
            )
            
            if !items.isEmpty {
                items.forEach { item in
                    view.addStoragePlace(
                        item.selectedPlace,
                        item.storeid,
                        item.storeName,
                        item.custAccountId,
                        item.placeid,
                        item.placeName,
                        item.bodid,
                        item.bodName,
                        item.secid,
                        item.secName,
                        item.units,
                        item.series,
                        item.missingUnitsCount,
                        item.missingUnitsReason
                    )
                }
            }
            
            view.autoLoad = autoLoad
            
            self.manualItems.append(view)
            
            self.productDiv.appendChild(view)
            
            self.recalculateManualBalance()
            
            return
            
        }
        
    }
    
    func selectPOC() {
        
        addToDom(ToolReciveSendInventorySelectPOC(
            isManual: true,
            selectedPOC: {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                self.addPOC(pocid, upc, brand, model, name, cost, price, avatar, reqSeries)
            },
            createPOC: { type, levelid, titleText in
                
                let view = ManagePOC(
                    leveltype: type,
                    levelid: levelid,
                    levelName: titleText,
                    pocid: nil,
                    titleText: titleText,
                    quickView: true
                ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                    self.addPOC(pocid, upc, brand, model, name, nil, price, avatar, reqSeries)
                } deleted: { }
                
                addToDom( view )
                
            }
        ))
    }
 
    func recalculateManualBalance() {
        
        var _total: Int64 = 0
        
        var _units: Int64 = 0
        
        var _internalCost: Int64 = 0
        
        manualItems.forEach { view in
            
            var units: Int64 = 0
            
            view.inventoryDestinations.forEach { id, value in
                units += value.units
            }
            
            _units += units
            
            _total += (units * view.price)
            
            _internalCost += (units * view.cost)
        }
        
        self.total = _total.formatMoney
        
        self.internalCost = _internalCost
        
        self.totalUnits = _units.toInt
        
    }
    
    func saveManualInventory() {
        
        guard let manualPurchaseManager else {
            showError(.generalError, "No se localizo Documento")
            return
        }
        
        if self.manualItems.isEmpty {
            showAlert(.alerta, "Ingrese Inventario")
            self.selectPOC()
            return
        }
        
        var _items: [DispersionDocumentManualItem] = []
  
        manualItems.forEach { item in

            var dispertion: [CustManualInventoryCatchInventory] = []

            item.inventoryDestinations.forEach { id, target in

                dispertion.append(.init(
                    selectedPlace: target.selectedPlace,
                    storeid: target.storeid,
                    storeName: target.storeName,
                    custAccountId: target.custAccountId,
                    placeid: target.placeid,
                    placeName: target.placeName,
                    bodid: target.bodid,
                    bodName: target.bodName,
                    secid: target.secid,
                    secName: target.secName,
                    units: target.units,
                    series: target.series,
                    missingUnitsCount: target.missingUnitsCount,
                    missingUnitsReason: target.missingUnitsReason
                ))

            }
            
            _items.append(.init(
                pocid: item.pocid,
                code: item.upc,
                description: "\(item.brand) \(item.model) \(item.name)".purgeSpaces,
                dispertion: dispertion
            ))
            
        }
        
        loadingView(show: true)
        
        API.custPOCV1.createManualDispersionDocument(
            docId: manualPurchaseManager.id,
            items: _items
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
            
            guard let data = resp.data else {
                showError(.generalError, "No se obtuvo data de la respusta")
                return
            }
            
            self.custInventoryPurchaseManagerStatus = .processed
            
            self.captureDocuments = data.documents
         
            self.downloadManualDocs(false)
            
            self.barcodes = self.manualItems.map{ .init(
                id: $0.pocid,
                upc: $0.upc,
                brand: $0.brand,
                model: $0.model,
                name: $0.name,
                price: $0.price
            )}
            
            showSuccess(.operacionExitosa, "Inventario ingresado con exito folio \(data.folio)", .long)
            
        }
    }
    
    func printTags() {
        addToDom(PrintBarcodes(barodes: self.barcodes))
    }
    
    func downloadManualDocs(_ withDetail: Bool){
        
        if captureDocuments.isEmpty {
            showAlert(.alerta, "No hay docuemntos por descargar")
            return
        }
        
        guard let docid = manualPurchaseManager?.id else {
            return
        }
        
        loadingView(show: true)
        
        downloadManualInventoryControlOrders(id: docid, detailed: withDetail)
        
        Dispatch.asyncAfter(3.0) {
            loadingView(show: false)
        }
    }
    
    func sincRecentXML() {
        
        loadingView(show: true)
        
        API.fiscalV1.sincRecentXML { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            if !payload.hasProfile {
                addToDom(ConfirmView(
                    type: .ok,
                    title: "No se localizo perfiles",
                    message: "",
                    callback: { isConfirmed, comment in
                        
                    }))
                
                return
            }
            
            var str = ""
            
            if !payload.profilesWithOutRequest.isEmpty {
                str += "Perfiles por procesar\n"
                payload.profilesWithOutRequest.forEach { profile  in
                    str += "\(profile)\n"
                }
            }
            
            if !payload.profilesWithRequest.isEmpty {
                str += "Perfiles procesados\n"
                payload.profilesWithRequest.forEach { profile  in
                    str += "\(profile)\n"
                }
            }
            
            addToDom(ConfirmView(
                type: .ok,
                title: "Resultados de la peticion",
                message: str,
                callback: { isConfirmed, comment in
                    
                }
            ))
            
        }
    }
    
    func loadManualDispertion(_ data: API.custPOCV1.GetManualDispertionResponse) {
        
        let vendor = data.vendor
        
        let document = data.document
        
        vendorid = vendor.id
        
        vendorFolio = vendor.folio
        
        businessName = vendor.businessName
        
        vendorRfc = vendor.rfc
        
        vendorRazon = vendor.razon
        
        fiscalProfiles.forEach { prof in
            if document.fiscalProfile == prof.id {
                profile = prof
            }
        }
        
        guard let profile else {
            showError(.generalError, "No se localizo perfil fiscal. No se pudo cargar documeto.")
            return
        }
        
        receptorRfc = profile.rfc
        
        receptorRazon = profile.razon
        
        ingresoManual = true
        
        document.items.forEach { item in
            addPOC(
                item.pocid,
                item.upc,
                item.brand,
                item.model,
                item.name,
                item.cost,
                item.price,
                item.avatar,
                false,
                item.intentory,
                false
            )
        }
        
        manualPurchaseManager = document
        
        captureDocuments = document.controlDocuments
     
        if document.status != .preparing {
            manualItems.forEach { view in
                view.addMoreButtonIsHidden = true
            }
        }
        
    }

}

extension ToolReciveSendInventory {
    
    func udpateManualInventoryCatch(){
        
        guard let manualPurchaseManager else {
            return
        }
        
        let items: [CustManualInventoryCatchItems] = manualItems.map{ view in
                .init(
                    pocid: view.pocid,
                    upc: view.upc,
                    brand: view.brand,
                    model: view.model,
                    name: view.name,
                    cost: view.cost,
                    price: view.price,
                    avatar: "",
                    intentory: view.inventoryDestinations.map({ (key: UUID, value: FiscalConceptDestinationManualItemsView) in
                        CustManualInventoryCatchInventory(
                            selectedPlace: value.selectedPlace,
                            storeid: value.storeid,
                            storeName: value.storeName,
                            custAccountId: value.custAccountId,
                            placeid: value.placeid,
                            placeName: value.placeName,
                            bodid: value.bodid,
                            bodName: value.bodName,
                            secid: value.secid,
                            secName: value.secName,
                            units: value.units,
                            series: value.series,
                            missingUnitsCount: value.missingUnitsCount,
                            missingUnitsReason: value.missingUnitsReason
                        )
                    })
                )
        }
        
        API.custPOCV1.updateManualDispertion(
            docId: manualPurchaseManager.id,
            type: .items(items),
            comment: nil
        ) { resp in
        
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
        }
        
    }
    
    func loadManualInventoryCatch() -> Bool {
        /* goku
         
         self.vendorid = account.id
         
         self.vendorFolio = account.folio
         
         self.businessName = account.businessName
         
         self.vendorRfc = account.rfc
         
         self.vendorRazon = account.razon
         
         //self.finaceContact = "\(account.fiscalPOCFirstName) \(account.fiscalPOCLastName)"
         
         self.selectManualFiscalProfile()
         
         
         
        var helper: CustManualInventoryCatchHelper? = nil
        
        if let json = WebApp.current.window.localStorage.string(forKey: "manualDispertion"){
        
            if let data = json.data(using: .utf8) {
                do {
                    helper = try JSONDecoder().decode(CustManualInventoryCatchHelper.self, from: data)
                }
                catch { }
            }
        }
        
        guard var helper else {
            return false
        }
        
        vendorid = helper.sessionDetail.vendorid
        
        vendorFolio = helper.sessionDetail.vendorFolio
        
        businessName = helper.sessionDetail.businessName
        
        vendorRfc = helper.sessionDetail.vendorRfc
        
        vendorRazon = helper.sessionDetail.vendorRazon
        
        receptorRfc = helper.sessionDetail.receptorRfc
        
        receptorRazon = helper.sessionDetail.receptorRazon
        
        ingresoManual = true
        
        print("🟢  loadManualInventoryCatch")
        
        helper.items.forEach { item in
            addPOC(
                item.pocid,
                item.upc,
                item.brand,
                item.model,
                item.name,
                item.cost,
                item.price,
                item.avatar,
                item.intentory,
                false
            )
        }
        */
        return true
        
    }
    
}
