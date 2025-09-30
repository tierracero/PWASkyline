//
//  SearchHistoricalPurchaseDetailedView.swift
//  
//
//  Created by Victor Cantu on 2/8/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SearchHistoricalPurchaseDetailedView: Div {
    
    override class var name: String { "div" }
    
    var control: CustFiscalProductControlQuick
    
    var vendor: CustVendorsQuick
    
    @State var poc: CustPOCWeb?
    
    init(
        control: CustFiscalProductControlQuick,
        vendor: CustVendorsQuick,
        poc: CustPOCWeb?
    ) {
        self.control = control
        self.vendor = vendor
        self.poc = poc
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// Vendor Data
    @State var businessName: String = ""
    
    @State var firstName: String = ""
    
    @State var lastName: String = ""
    
    @State var rfc: String = ""
    
    @State var razon: String = ""
    
    @State var email: String = ""
    
    @State var fiscalPOCMobile: String = ""
    
    @State var mobile: String = ""
    
    @State var creditDays: String = "0"
    
    lazy var pocView = Div{
        
        /// Vendor
        H3("Producto")
            .color(.white)
        
        Table{
            Tr{
                Td{
                    Div("Seleccionar Producto")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.searchPOC()
                        }
                }
            }
        }
        .height(90.percent)
        .width(100.percent)
    }
    
    lazy var historicalGrid = Table{
        Tr{
            Td("Fecha")
                .width(100.px)
            Td("Costo")
                .align(.right)
                .width(10.px)
            Td("Serie/Folio")
                .align(.right)
            Td()
                .width(24.px)
        }
    }
        .width(100.percent)
        .color(.white)
    
    @DOM override var body: DOM.Content {
        Div{
            /// Header
            Div {

                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }

                H2("Detalles de compra")
                    .color(.lightBlueText)
                    .float(.left)
            }
            
            Div().class(.clear).height(3.px)
            
            Div{
                
                /// Product
                Div{
                    Div{
                        
                        H3("Compra")
                            .color(.white)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Codigo")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        /// self.$mobile.map{ $0.isEmpty ? LString(pack: String.mobile()) : $0 }
                        Div({self.control.code.isEmpty ? "00000000000" : self.control.code}())
                            .color({self.control.code.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(7.px)
                        
                        Span("Descripcion")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        /// self.$mobile.map{ $0.isEmpty ? LString(pack: String.mobile()) : $0 }
                        Div({self.control.description.isEmpty ? "Descripcion de la compra" : self.control.description}())
                            .color({self.control.description.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(7.px)
                        
                        Span("Costo")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div(self.control.cost.formatMoney)
                            .color(.lightGray)
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(7.px)
                        
                        H3("Historial")
                            .color(.lightGray)
                        
                        self.historicalGrid
                        
                        Div().class(.clear).height(7.px)
                        
                    }
                    .height(100.percent)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .overflow(.auto)
                }
                .height(100.percent)
                .width(40.percent)
                .float(.left)
                
                /// Vendor
                Div{
                    Div{
                        Div{
                            
                            
                        Img()
                            .src("/skyline/media/pencil.png")
                            .paddingRight(3.px)
                            .cursor(.pointer)
                            .height(18.px)
                            .float(.right)
                            .onClick{
                                
                                addToDom(SearchVendorView(loadBy: .account(self.vendor), callback: { vendor in
                                   
                                    self.businessName = vendor.businessName
                                    self.firstName = vendor.firstName
                                    self.lastName = vendor.lastName
                                    self.rfc = vendor.rfc
                                    self.razon = vendor.razon
                                    self.email = vendor.email
                                    self.fiscalPOCMobile = vendor.fiscalPOCMobile
                                    self.mobile = vendor.mobile
                                    self.creditDays = vendor.creditDays.formatMoney
                                    
                                }))
                            }
                            
                            /// Vendor
                            H3("Vendor")
                                .color(.white)
                        }
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Nombre del Negocio")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$businessName.map{ $0.isEmpty ? "Nombre del Negocio" : $0 })
                            .color(self.$businessName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Primer Nombre")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$firstName.map{ $0.isEmpty ? "Primer Nombre" : $0 })
                            .color(self.$firstName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Apellido")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$lastName.map{ $0.isEmpty ? "Apellido" : $0 })
                            .color(self.$lastName.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("RFC")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$rfc.map{ $0.isEmpty ? "RFC" : $0 })
                            .color(self.$rfc.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                         
                        Span("Razon Social")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$razon.map{ $0.isEmpty ? "Razon Social" : $0 })
                            .color(self.$razon.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Correo Principal")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$email.map{ $0.isEmpty ? "correo@empresa.com" : $0 })
                            .color(self.$email.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Movil Fiscal")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$fiscalPOCMobile.map{ $0.isEmpty ? "8340001234" : $0 })
                            .color(self.$fiscalPOCMobile.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                        
                        Span("Movil Principal")
                            .fontSize(14.px)
                            .color(.lightGray)
                        
                        Div( self.$mobile.map{ $0.isEmpty ? "8340001234" : $0 })
                            .color(self.$mobile.map{ $0.isEmpty ? Color(r: 81, g: 85, b: 94) : .white })
                            .class(.oneLineText)
                            .fontSize(24.px)
                        
                        Div().class(.clear).height(3.px)
                         
                        
                        
                    }
                    .height(100.percent)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .overflow(.auto)
                }
                .height(100.percent)
                .width(30.percent)
                .float(.left)
                
                /// POC
                Div{
                    self.pocView
                    .height(100.percent)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .overflow(.auto)
                }
                .height(100.percent)
                .width(30.percent)
                .float(.left)
                
            }
            .custom("height", "calc(100% - 38px)")
            
        }
        .custom("top", "calc(50% - 250px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(80.percent)
        .left(10.percent)
        .height(500.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if !control.meta.isEmpty {
            
            control.meta.reversed().forEach { meta in
                
                let date = getDate(meta.createdAt)
                //3514332080
                historicalGrid.appendChild( Tr{
                    Td("\(date.day.toString)/\(date.monthName.prefix(3))/\(date.year.toString.suffix(2))")
                    
                    Td(meta.cost.formatMoney)
                        .align(.right)
                    
                    Td{
                        Div("\(meta.serie)/\(meta.folio)")
                            .class(.oneLineText)
                            .width(100.percent)
                    }
                    .align(.right)
                    
                    Td{
                        Img()
                            .src("/skyline/media/attachment.png")
                            .cursor(.pointer)
                            .height(22.px)
                            .onClick {
                                
                                loadingView(show: true)
                                
                                API.fiscalV1.getFiscaXMLIngreso(id: meta.uuid) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp = resp else {
                                        showError(.errorDeCommunicacion, .serverConextionError)
                                        return
                                    }
                                    
                                    guard resp.status == .ok  else {
                                        showError(.errorGeneral, resp.msg)
                                        return
                                    }
                                    
                                    guard let doc = resp.data else {
                                        showError( .errorGeneral, .unexpenctedMissingPayload)
                                        return
                                    }
                                    
                                    addToDom(ToolViewFiscalXMLDocument(doc: doc))
                                    
                                }
                                
                            }
                    }
                    .align(.center)
                    .width(24.px)
                    
                })
            }
        }

        businessName = vendor.businessName
        firstName = vendor.firstName
        lastName = vendor.lastName
        rfc = vendor.rfc
        razon = vendor.razon
        email = vendor.email
        fiscalPOCMobile = vendor.fiscalPOCMobile
        mobile = vendor.mobile
        creditDays = vendor.creditDays.formatMoney
        
        $poc.listen {
            if let poc = $0 {
                self.loadPoc(relate: true, poc: poc)
            }
        }
        
        
        if let poc {
            self.loadPoc(relate: false, poc: poc)
        }
    }
    
    override func didAddToDOM(){
        super.didAddToDOM()
    }
    
    func loadPoc(relate: Bool, poc: CustPOCWeb) {
        pocView.innerHTML = ""
        
        let avatar = Img()
            .src("/skyline/media/tierraceroRoundLogoBlack.svg")
            .height(128.px)
            .width(128.px)
        
        if !poc.avatar.isEmpty, let pDir = customerServiceProfile?.account.pDir  {
            avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.avatar)")
        }
        
        pocView.appendChild(Div{
            
            Div {
            
                Img()
                    .src("/skyline/media/reload.png")
                    .paddingRight(3.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .float(.right)
                    .onClick{
                        self.searchPOC()
                    }
            
                Img()
                    .src("/skyline/media/pencil.png")
                    .paddingRight(12.px)
                    .cursor(.pointer)
                    .height(18.px)
                    .float(.right)
                    .onClick{
                        self.editPOC(pocid: poc.id)
                    }
                
                H3("Producto")
                    .color(.white)
            }
            
            Div().class(.clear).height(3.px)
            
            Div{
                avatar
            }
            .align(.center)
            
            Div().class(.clear).height(3.px)
            
            Span("Nombre")
                .fontSize(14.px)
                .color(.lightGray)
            
            Div({poc.name.isEmpty ? "Nombre" : poc.name}())
                .color({poc.name.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                .class(.oneLineText)
                .fontSize(24.px)
            
            Div().class(.clear).height(7.px)
            
            Span("SKU / UPC")
                .fontSize(14.px)
                .color(.lightGray)
            
            Div({poc.upc.isEmpty ? "00000000000" : poc.upc}())
                .color({poc.upc.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                .class(.oneLineText)
                .fontSize(24.px)
            
            Div().class(.clear).height(7.px)
            
            Span("Marca")
                .fontSize(14.px)
                .color(.lightGray)
            
            Div({poc.brand.isEmpty ? "Apple, Motorola, Patito..." : poc.brand}())
                .color({poc.brand.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                .class(.oneLineText)
                .fontSize(24.px)
            
            Div().class(.clear).height(7.px)
            
            Span("Modelo")
                .fontSize(14.px)
                .color(.lightGray)
            
            Div({poc.model.isEmpty ? "00000000000" : poc.model}())
                .color({poc.model.isEmpty ? Color(r: 81, g: 85, b: 94) : .white}())
                .class(.oneLineText)
                .fontSize(24.px)
            
            Div().class(.clear).height(7.px)
            
            Span("Precio")
                .fontSize(14.px)
                .color(.lightGray)
            
            Div(poc.pricea.formatMoney)
                .color(.lightGray)
                .class(.oneLineText)
                .fontSize(24.px)
            
            Div().class(.clear).height(7.px)
            
        })
        
        if relate {
            
//            control
//            relatePOCtoProductControlItem
            
            loadingView(show: true)
            
            API.fiscalV1.relatePOCtoProductControlItem(
                productContolId: control.id,
                vendorId: self.vendor.id,
                vendorRfc: self.vendor.rfc,
                pocid: poc.id,
                name: poc.name,
                brand: poc.brand,
                model: poc.model,
                upc: poc.upc
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok  else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
            }
        }
    }
 
    func searchPOC() {
        
        let view = ToolReciveSendInventorySelectPOC(
            isManual: false
        ) { pocid, upc, brand, model, name, cost, price, avatar in
            
            self.poc = .init(
                id: pocid,
                name: name,
                upc: upc,
                brand: brand,
                model: model,
                pricea: price,
                avatar: avatar
            )
            
        } createPOC: { type, levelid, titleText in
            
            let view = ManagePOC(
                leveltype: type,
                levelid: levelid,
                levelName: titleText,
                pocid: nil,
                titleText: titleText,
                quickView: true
            ){ pocid, upc, brand, model, name, cost, price, avatar in
                
                self.poc = .init(
                    id: pocid,
                    name: name,
                    upc: upc,
                    brand: brand,
                    model: model,
                    pricea: price,
                    avatar: avatar
                )
                
            } deleted: {
                
            }
            
            view.cost = self.control.cost.formatMoney
            
            view.model = self.control.code
            
            view.name = self.control.description
            
            view.fiscCode = self.control.fiscCode
            
            view.fiscCodeField.loadFiscalCodeData(self.control.fiscCode)
            
            view.fiscUnit = self.control.fiscUnit
            
            view.fiscUnitField.loadFiscalCodeData(self.control.fiscUnit)
            
            view.addVendor(id: self.vendor.id, name: self.vendor.rfc)
            
            addToDom(view)
            
        }
        
        addToDom(view)
        
    }
    
    func editPOC(pocid: UUID){
        
        let view = ManagePOC(
            leveltype: CustProductType.all,
            levelid: nil,
            levelName: "",
            pocid: pocid,
            titleText: "",
            quickView: false
        ) {  pocid, upc, brand, model, name, cost, price, avatar in
            
            self.poc = .init(
                id: pocid,
                name: name,
                upc: upc,
                brand: brand,
                model: model,
                pricea: price,
                avatar: avatar
            )
        } deleted: { }
        
        addToDom(view)
    }
}
