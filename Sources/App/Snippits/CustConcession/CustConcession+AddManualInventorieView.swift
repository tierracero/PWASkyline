//
//  CustConcession+AddManualInventorieView.swift
//
//
//  Created by Victor Cantu on 7/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class AddManualInventorieView: Div {
        
        override class var name: String { "div" }
        
        let account: CustAcct
        
        let newDocumentName: String

        let vendor: CustVendorsQuick

        let profile: FiscalEndpointV1.Profile

        @State var bodegas: [CustStoreBodegasQuick]

        @State var seccions: [CustStoreSeccionesQuickRef]
        
        init(
            account: CustAcct,
            newDocumentName: String,
            vendor: CustVendorsQuick,
            profile: FiscalEndpointV1.Profile,
            bodegas: [CustStoreBodegasQuick],
            seccions: [CustStoreSeccionesQuickRef]
        ) {
            self.account = account
            self.newDocumentName = newDocumentName
            self.vendor = vendor
            self.profile = profile
            self.bodegas = bodegas
            self.seccions = seccions
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        /* MARK: general data */

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
        
        @State var totalUnits: Int = 0

        /* MARK: Kart */
        @State var balanceString =  "0.00"
        
        @State var kart: [SalePointObject] = []
        
        @State var searchTerm = ""
        
        @State var bodegaListener = ""

        @State var sectionListener = ""

        @State var kartItems: [SearchChargeResponse] = []

        @State var currentSeccions: [CustStoreSeccionesQuickRef] = []

        /// [ CustStoreBodegas.id: [CustStoreSeccionesQuickRef] ]
        var seccionRefrence: [ UUID: [CustStoreSeccionesQuickRef] ] = [:]

        lazy var searchBox = InputText(self.$searchTerm)
            .custom("background", "url('images/barcode.png') no-repeat scroll 7px 7px rgb(29, 32, 38)")
            .placeholder("Ingrese UPC/SKU/POC o Referencia")
            .backgroundSize(h: 18.px, v: 18.px)
            .onKeyUp(searchTermAct)
            .class(.textFiledLight)
            .paddingLeft(30.px)
            .marginLeft(7.px)
            .width(350.px)
            .height(32.px)
            .color(.white)
            .float(.left)
            .onFocus { tf in
                self.kartItems.removeAll()
            }
        
        lazy var resultBox = Div{
            Div{
                ForEach(self.$kartItems) { item in
                    SearchChargeView(
                        data: .init(
                            t: .product,
                            i: item.i,
                            u: item.u,
                            n: item.n,
                            b: item.b,
                            m: item.m,
                            p: item.p,
                            a: item.a,
                            reqSeries: item.reqSeries
                        ),
                        costType: .cost_a
                    ) { item in
                        
                        self.kartItems.removeAll()

                        addToDom(ConfirmConcessionView(
                            item: .init(
                                id: item.i,
                                upc: item.u,
                                name: item.n,
                                brand: item.b,
                                model: item.m,
                                price: item.p,
                                avatar: item.a,
                                units: nil,
                                reqSeries: item.reqSeries
                            )
                        ){ item, units in

                            

                            self.addItem(item: item, units: units)
                        })
                        
                    }
                    .custom("width", "calc(50% - 28px)")
                    .marginRight(3.px)
                    .float(.left)
                }
            }
            .margin(all: 3.px)
        }
            .class(.transparantBlackBackGround, .roundDarkBlue)
            .hidden(self.$kartItems.map{ $0.isEmpty })
            .maxHeight(70.percent)
            .position(.absolute)
            .overflow(.auto)
            .width(1000.px)
        
        lazy var itemGrid = Table{
            Tr {
                Td().width(50)
                Td("Marca").width(200)
                Td("Modelo / Nombre")
                //Td("Hubicación").width(200)
                Td("Units").width(100)
                Td("C. Uni").width(100)
                Td("S. Total").width(100)
            }
        }
        .width(100.percent)
        .color(.white)

         lazy var serieField = InputText(self.$docSerie)
        .class(.textFiledBlackDark)
        .placeholder("Serie")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)

         lazy var folioField = InputText(self.$docFolio)
        .class(.textFiledBlackDark)
        .placeholder("Folio")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        
        lazy var bodegaSelect = Select(self.$bodegaListener)
        .body {
            Option("Selecione Bodega")
            .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

        lazy var sectionSelect = Select(self.$sectionListener)
        .body {
            Option("Selecione Seccion")
            .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .hidden(self.$currentSeccions.map{ $0.isEmpty })

        lazy var sectionSelectDisabled = Select()
        .body {
            Option("Selecione Seccion")
            .value("")
        }
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
        .hidden(self.$currentSeccions.map{ !$0.isEmpty })

        @DOM override var body: DOM.Content {
            
            Div{
                Div().clear(.both).height(3.px)

                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Agregar concesión del proveedor")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    self.searchBox
                    
                    // MARK: Add product butt on
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/add.png")
                                .height(18.px)
                        }
                        .float(.left)
                        
                        Span("Crear Nuevo Producto")
                            .paddingTop(4.px)
                            .paddingLeft(7.px)
                            .fontSize(16.px)
                            .color(.gray)
                            .float(.left)
                        
                        Div().clear(.both)

                    }
                    .class(.uibtnLarge)
                    .marginTop(-7.px)
                    .marginLeft(7.px)
                    .float(.left)
                    .onClick{
                        let view = SelectStoreDepartment { type, levelid, titleText in
                        
                            let view = ManagePOC(
                                leveltype: type,
                                levelid: levelid,
                                levelName: titleText,
                                pocid: nil,
                                titleText: titleText,
                                quickView: true
                            ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                                
                                addToDom(ConfirmConcessionView(
                                    item: .init(
                                        id: pocid,
                                        upc: upc,
                                        name: name,
                                        brand: brand,
                                        model: model,
                                        price: price,
                                        avatar: avatar,
                                        units: nil,
                                        reqSeries: reqSeries
                                    )
                                ){ item, units in
                                    self.addItem(
                                        item: item,
                                        units: units
                                    )
                                })
                                
                            } deleted: { }
                            
                            addToDom( view )

                        }

                        addToDom( view )
                    }


                    Div().class(.clear)
                }
                
                Div().clear(.both).height(3.px)
            
                self.resultBox

                Div().clear(.both).height(3.px)

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
                            
                            Div( self.$receptorRfc.map{ $0.purgeSpaces.isEmpty ? "XAXX010101000" : $0 } )
                                .color(self.$receptorRfc.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            .fontSize(18.px)
                            
                        }.marginBottom(3.px).class(.section)
                        
                        /// Razon
                        Div{
                            Label("Razon Social")
                                .color(.gray)
                                .fontSize(14.px)
                            
                            Div(self.$receptorRazon.map { $0.purgeSpaces.isEmpty ? "Razon Social" : $0 })
                                .color(self.$receptorRazon.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
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
                            
                            Div( self.$vendorFolio.map{ $0.purgeSpaces.isEmpty ? "veXX-0000" : $0 } )
                                .color(self.$vendorFolio.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
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
                            
                            Div(self.$vendorRfc.map { $0.purgeSpaces.isEmpty ? "XAXX010101000" : $0 })
                                .color(self.$vendorRfc.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                .class(.textFiledBlackDarkReadMode, .oneLineText)
                                .fontSize(18.px)
                            
                        }.marginBottom(3.px).class(.section)
                        
                        /// Razon
                        Div{
                            Label("Razon Social")
                                .color(.gray)
                                .fontSize(14.px)
                            
                            Div(self.$vendorRazon.map { $0.purgeSpaces.isEmpty ? "Razon Social" : $0 })
                                .color(self.$vendorRazon.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                .class(.textFiledBlackDarkReadMode, .oneLineText)
                                .fontSize(18.px)
                            
                        }.marginBottom(3.px)
                        
                        /// Buisness Name
                        Div{
                            
                            Label("Nombre Empresa")
                                .color(.gray)
                                .fontSize(14.px)
                            
                            Div(self.$businessName.map { $0.purgeSpaces.isEmpty ? "Nombre Empresa" : $0 })
                                .color(self.$businessName.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
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
                                
                                Span(self.$finaceContact.map{ $0.purgeSpaces.isEmpty ? "8341230000" : $0 })
                                    .color(self.$finaceContact.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                
                                Span(" / ")
                                    .color(self.$oporationContact.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                
                                Span(self.$oporationContact.map{ $0.purgeSpaces.isEmpty ? "8341230000" : $0 })
                                    .color(self.$oporationContact.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                
                            }
                            .color(self.$docuuid.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                            .class(.textFiledBlackDarkReadMode, .oneLineText)
                            
                        }.marginBottom(3.px)
                        
                        /// UUID
                        Div{
                            
                            Label("UUID")
                                .fontSize(14.px)
                                .color(.gray)
                            
                            Div(self.$docuuid.map{ $0.purgeSpaces.isEmpty ? "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" : $0 })
                                .color(self.$docuuid.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
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
                                Div{
                                    self.serieField
                                }
                                .width(50.percent)
                                .float(.left)

                                Div{
                                    self.folioField
                                }
                                .width(50.percent)
                                .float(.left)
                            }
                        }
                    }
                    .marginRight(1.percent)
                    .width(24.percent)
                    .float(.left)
                    
                    /// Document
                    Div{

                        /// Total
                        Div{
                            
                            Label("Total")
                                .color(.yellowTC)
                                .padding(all: 3.px)
                                .paddingLeft(0.px)
                                .marginLeft(0.px)
                                .fontSize(18.px)
                            
                            Div( self.$total.map{ $0.purgeSpaces.isEmpty ? "0.00" : $0 } )
                                .color(self.$total.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                .class(.textFiledBlackDarkReadMode, .oneLineText)
                                .fontSize(18.px)
                            
                        }.paddingBottom(3.px).class(.section)
                        
                        /// Balance
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
                        .paddingBottom(3.px).class(.section)
                        
                        /// Numero de Unidades
                        Div{
                            
                            Label("Unidades")
                                .color(.yellowTC)
                                .padding(all: 3.px)
                                .paddingLeft(0.px)
                                .marginLeft(0.px)
                                .fontSize(18.px)
                            
                            Div( self.$totalUnits.map{ $0 == 0 ? "0" : $0.toString } )
                                .color(self.$total.map{ $0.purgeSpaces.isEmpty ? .grayContrast : .white })
                                .class(.textFiledBlackDarkReadMode, .oneLineText)
                                .fontSize(18.px)
                            
                        }.paddingBottom(3.px).class(.section)
                        
                        Div{
                            self.bodegaSelect

                            Div().height(7.px)
                        }
                        .hidden(self.$bodegas.map{ $0.isEmpty })

                        Div{

                            self.sectionSelect

                            self.sectionSelectDisabled

                            Div().height(7.px)
                        }
                        .hidden(self.$seccions.map{ $0.isEmpty })
                        
                    }
                    .marginRight(1.percent)
                    .width(24.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                }.height(175.px)

                Div().clear(.both).height(3.px)                

                //Price Grid
                Div{
                    self.itemGrid
                }
                .custom("height", "calc(100% - 310px)")
                .padding(all: 7.px)
                .class(.roundDarkBlue)
                .overflow(.auto)
                .onClick {
                    
                    self.kartItems.removeAll()

                }
                
                Div{

                    Div("Agregar Concesión")
                        .class(.uibtnLargeOrange)
                        .marginRight(5.px)
                        .hidden(self.$kart.map{ $0.isEmpty })
                        
                        .onClick {
                            self.addConcession()
                        }

                    Div("Agregar Concesión")
                        .class(.uibtnLarge)
                        .marginRight(5.px)
                        .cursor(.default)
                        .opacity(0.5)
                        .hidden(self.$kart.map{ !$0.isEmpty })
                }
                .align(.right)
                
            }
            .custom("height","calc(100% - 50px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(90.percent)
            .left(5.percent)
            .top(25.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)

            $kartItems.listen {
                if $0.isEmpty {
                    self.searchTerm = ""
                }
            }   

            vendorFolio = vendor.folio
            
            businessName = vendor.businessName
            
            vendorRfc = vendor.rfc
            
            vendorRazon = vendor.razon
            
            finaceContact = "\(vendor.firstName) \(vendor.lastName)"
            
            oporationContact = vendor.fiscalPOCMobile
            
            receptorRfc = account.fiscalRfc
            
            receptorRazon = account.fiscalRazon
            
            fiscalUse = account.cfdiUse
            
            bodegas.forEach { item in
                bodegaSelect.appendChild(
                    Option(item.name)
                    .value(item.id.uuidString)
                )
            }

            seccions.forEach { item in
                if let _ = seccionRefrence[item.custStoreBodegas] {
                    seccionRefrence[item.custStoreBodegas]?.append( item )
                }
                else {
                    seccionRefrence[item.custStoreBodegas] = [item]
                }
            }

        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            $bodegaListener.listen {
                
                print("🟢  ch bod")

                self.sectionListener = ""

                if let id: UUID = UUID(uuidString: $0) {
                    print("🟢  found od")
                    self.currentSeccions = self.seccionRefrence[id] ?? []

                    print("🟢  sec count")

                    print(self.currentSeccions.count)

                }
                
            }

            $currentSeccions.listen {

                self.sectionSelect.innerHTML = ""
 
                self.sectionSelect.appendChild(
                    Option("Selecione Seccion")
                    .value("")
                )

                $0.forEach { item in
                    self.sectionSelect.appendChild(
                        Option(item.name)
                        .value(item.id.uuidString)
                    )
                }

            }

            searchBox.select()
        }
        
        func searchTermAct() {
            
            if searchTerm.isEmpty {
                kartItems.removeAll()
                return
            }
            
            let term = searchTerm.purgeSpaces
            
            Dispatch.asyncAfter(0.37) {

                self.searchBox.class(.isLoading)

                if term == self.searchTerm.purgeSpaces {

                    // TODO: properly parse currentCodeIds
                    searchPOC(
                        term: self.searchTerm,
                        costType: .cost_a,
                        getCount: false
                    ) { term, resp in
                        
                        self.searchBox.removeClass(.isLoading)

                        if self.searchTerm == term {

                            if resp.count == 1 {
                                
                                guard let item = resp.first else {
                                    return
                                }

                                self.kartItems.removeAll()
                                
                                addToDom(ConfirmConcessionView(item: item){ item, units in
                                    self.addItem(
                                        item: item,
                                        units: units
                                    )
                                })
                                
                                return
                                
                            }

                            self.kartItems = resp.map{ item in
                                .init(
                                    t: .product,
                                    i: item.id,
                                    u: item.upc,
                                    n: item.name,
                                    b: item.brand,
                                    m: item.model,
                                    p: item.price,
                                    a: item.avatar,
                                    reqSeries: item.reqSeries
                                )
                            }

                        }
                    }
                }
            }
        }
        
        func addItem( item: SearchPOCResponse, units: Int64) {
            
            let id = UUID()
            
            let row = KartItemView(
                id: id,
                cost: 0,
                quant: (units / 100),
                price: 0,
                data: .init(
                    t: .product,
                    i: item.id,
                    u: item.upc,
                    n: item.name,
                    b: item.brand,
                    m: item.model,
                    p: 0,
                    a: item.avatar,
                    reqSeries: item.reqSeries
                )
            ) { id in
                
                var _kart: [SalePointObject] = []
                
                self.kart.forEach { item in
                    if item.id != id {
                        _kart.append(item)
                    }
                }
                
                self.kart = _kart
                
            } 
            editManualCharge: { _, _, _, _, _ in
                // MARK: No editd are suported / required
            }
            .color(.white)
            
            self.kart.append(.init(
                id: id,
                kartItemView: row,
                data: .init(
                    type: .product,
                    id: item.id,
                    store: custCatchStore,
                    ids: [],
                    series: [],
                    cost: 0,
                    units: units,
                    unitPrice: 0,
                    subTotal: 0,
                    costType: .cost_a,
                    name: item.name,
                    brand: item.brand,
                    model: item.model,
                    pseudoModel: "",
                    avatar: item.avatar,
                    fiscCode: "",
                    fiscUnit: "",
                    preRegister: false
                )
            ))
            
            self.itemGrid.appendChild(row)
            
            self.searchBox.select()
            
        }
        
        func addConcession(){
            
            if kart.isEmpty {
                return
            }
            
            addToDom(ConfirmationView(
                type: .yesNo,
                title: "Agregar Concession Manuel",
                message: "Confirme la marcacia agregada",
                callback: { isConfirmed, comment in
                    
                    if !isConfirmed {
                        return
                    }

                    let items: [CreateManualProductObject] = self.kart.map{ .init(
                        pocId: $0.data.id,
                        description: "\($0.data.name) \($0.data.brand) \($0.data.model)".purgeSpaces,
                        units: .units(Int($0.data.units.fromCents)),
                        price: nil
                    ) }

                    API.custPOCV1.addManualInventory(
                        storeId: custCatchStore,
                        relationType: .conssesion(self.account.id),
                        items: items,
                        documentName: self.newDocumentName,
                        documentSerie: self.docSerie,
                        documentFolio: self.docFolio,
                        vendorId: self.vendor.id,
                        profileId: self.profile.id,
                        bodegaId: UUID(uuidString: self.bodegaListener),
                        sectionId: UUID(uuidString: self.sectionListener)
                    ) { resp in
                        
                        loadingView(show: false)

                        guard let resp else {
                            showError(.errorDeCommunicacion, "Error de comunicacion")
                            return
                        }

                        if resp.status != .ok {
                            showError(.errorGeneral, resp.msg)
                            return
                        }

                        guard let payload = resp.data else {
                            showError(.unexpectedResult, "No se obtuvo payload de data")
                            return
                        }

                        let control: CustFiscalInventoryControl = payload.control

                        let cardex: [CustPOCCardex] = payload.cardex

                        self.appendChild(ConcessionConfirmationView(
                            accountid: self.account.id,
                            accountFolio: self.account.folio,
                            accountName: "\(self.account.fiscalRfc) \(self.account.fiscalRazon)",
                            purchaseManager: control.id,
                            subTotal: self.balanceString,
                            document: control,
                            kart: self.kart,
                            cardex: cardex
                        ))
                        
                        self.kart.removeAll()

                        self.itemGrid.innerHTML = ""

                        self.itemGrid.appendChild(Tr {
                            Td().width(50)
                            Td("Marca").width(200)
                            Td("Modelo / Nombre")
                            //Td("Hubicación").width(200)
                            Td("Units").width(100)
                            Td("C. Uni").width(100)
                            Td("S. Total").width(100)
                        })
                    }
            
                })
            )
        }
    }
}
