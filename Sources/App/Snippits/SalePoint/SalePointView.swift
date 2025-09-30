//
//  SalePointView.swift
//
//
//  Created by Victor Cantu on 2/18/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class SalePointView: Div {
    
    override class var name: String { "div" }
    
    let loadBy: ViewLoader?
    
    let isSubView: Bool
    
    private var closeView: ((
    ) -> ())?
    
    
    private var minimizeView: ((
    ) -> ())?
    
    init(
        loadBy: ViewLoader?,
        isSubView: Bool = false,
        closeView: ((
        ) -> ())? = nil,
        minimizeView: ((
        ) -> ())? = nil
    ) {
        
        self.loadBy = loadBy
        self.isSubView = isSubView
        self.closeView = closeView
        self.minimizeView = minimizeView
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var smsTokens: [String] = []
    
    @State var custAcctFolio: String = "S/F"
    
    @State var custAcct: CustAcctSearch? = nil
    
    @State var custSubAcct: UUID? = nil
    
    @State var custSale: UUID? = nil
    
    @State var budgetid: UUID? = nil
    
    @State var budgetFolio: String = ""
    
    @State var selectedAccountName: String = "S/F Publico General"
    
    @State var firstName: String = "Publico"
    
    @State var lastName: String = "General"
    
    @State var mobile: String = ""
    
    @State var comment: String = ""
    
    @State var payment = "0.00"
    
    @State var balanceString = "0.00"
    
    @State var changeString = "0.00"
    
    @State var searchTerm = ""
    
    @State var kart: [SalePointObject] = []
    
    var selectedInventoryIDs: [UUID] = []
    
    var tokens: [String] = []
    
    @State var rewadsPoints: Float? =  nil
    
    @State var allowBudgetDetails: Bool = false
    
    lazy var allowBudgetDetailsCheckbox = InputCheckbox($allowBudgetDetails)
        .id(.init(stringLiteral: "allowBudgetDetailsBox"))
        .marginRight(3.px)
    
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
    
    lazy var searchBox = InputText($searchTerm)
        .custom("background", "url('images/barcode.png') no-repeat scroll 7px 7px rgb(29, 32, 38)")
        .placeholder("Ingrese UPC/SKU/POC o Referencia")
        .backgroundSize(h: 18.px, v: 18.px)
        .onKeyUp(searchTermAct)
        .class(.textFiledLight)
        .paddingLeft(30.px)
        .width(350.px)
        .height(32.px)
        .color(.white)
        .float(.left)
        .onFocus { tf in
            self.resultBox.innerHTML = ""
            tf.text = ""
        }
    
    lazy var customerSearchBox = Span($selectedAccountName)
        .cursor( self.$custAcct.map{ ( $0 == nil ) ? .default : .pointer } )
        .color( self.$custAcct.map{ ( $0 == nil ) ? .gray : .black } )
        .class(.textFiledLight, .oneLineText)
        .backgroundColor(.hex(0xeeeeee))
        .display(.inlineBlock)
        .marginRight(12.px)
        .padding(all: 7.px)
        .borderRadius(7.px)
        .fontSize(20.px)
        .width(230.px)
        .onClick {
            self.openAccount()
        }
    
    let resultBox = Div()
        .class(.transparantBlackBackGround, .roundDarkBlue)
        .maxHeight(70.percent)
        .position(.absolute)
        .overflow(.auto)
        .width(1000.px)
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            // Top Tools
            Div{
                
                self.searchBox
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(0.px)
                        
                    }
                    .marginRight(12.px)
                    .paddingTop(3.px)
                    .float(.left)
                    
                    Label("Cargo Manual")
                        .marginRight(7.px)
                }
                .hidden({ (custCatchHerk < 4) }())
                .class(.uibtnLarge)
                .padding(all: 3.px)
                .marginTop(-3.px)
                .marginLeft(7.px)
                .cursor(.pointer)
                
                .fontSize(22.px)
                .float(.left)
                .onClick {
                    
                    addToDom(BudgetManualChargeView { units, description, price, cost in
                        
                        let id = UUID()
                        let manualid = UUID()
                        
                        let row = KartItemView(
                            id: id,
                            cost: cost,
                            quant: units / 100,
                            price: price,
                            data: .init(
                                t: .manual,
                                i: manualid,
                                u: "",
                                n: description,
                                b: "",
                                m: "",
                                p: price,
                                a: ""
                            )
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                            
                            self.kart.forEach { item in
                                if item.id != id {
                                    _kart.append(item)
                                }
                            }
                            
                            self.kart = _kart
                            
                            self.calcBalance()
                            
                        } editManualCharge: { id, units, description, price, cost in
                           
                            Console.clear()
                            
                            print("⭐️  editManualCharge  ⭐️  editManualCharge 001")
                            
                            var _kart: [SalePointObject] = []
                            
                            self.kart.forEach { item in
                                
                                if item.id == id {
                                    
                                    _kart.append(.init(
                                        id: id,
                                        kartItemView: item.kartItemView,
                                        data: .init(
                                            type: .manual,
                                            id: manualid,
                                            store: custCatchStore,
                                            ids: [],
                                            series: [],
                                            cost: cost,
                                            units: units,
                                            unitPrice: price,
                                            subTotal: price * (units / 100),
                                            costType: self.custAcct?.costType ?? .cost_a,
                                            name: description,
                                            brand: "",
                                            model: "",
                                            pseudoModel: "",
                                            avatar: "",
                                            fiscCode: "",
                                            fiscUnit: "",
                                            preRegister: false
                                        )
                                    ))
                                    
                                    return
                                }
                                
                                _kart.append(item)
                                
                            }
                            
                            self.kart = _kart
                            
                            self.calcBalance()
                            
                        }
                        
                        self.kart.append(
                            .init(
                                id: id,
                                kartItemView: row,
                                data: .init(
                                    type: .manual,
                                    id: manualid,
                                    store: custCatchStore,
                                    ids: [],
                                    series: [],
                                    cost: cost,
                                    units: units,
                                    unitPrice: price,
                                    subTotal: price * (units / 100),
                                    costType: self.custAcct?.costType ?? .cost_a,
                                    name: description,
                                    brand: "",
                                    model: "",
                                    pseudoModel: "",
                                    avatar: "",
                                    fiscCode: "",
                                    fiscUnit: "",
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.itemGrid.appendChild(row)
                        
                        self.searchBox.select()
                        
                        self.calcBalance()
                        
                    } removeCharge: {
                        
                    })
                }
                
                Div{
                    
                    Div{
                        Img()
                            .src("skyline/media/history_color.png")
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .marginTop(10.px)
                            .height(28.px)
                            .onClick {
                                addToDom(HistoryView())
                            }
                    }
                    .float(.left)
                    
                    self.customerSearchBox
                    
                    Div{
                        
                        Span()
                            .class(.ico)
                            .backgroundImage("images/zoom.png")
                        
                        Span("Buscar Cliente")
                            .fontSize(21.px)
                        
                    }
                    .class(.uibutton)
                    .display(.inlineBlock)
                    .marginRight(18.px)
                    .onClick {
                        
                        let view = SearchCustomerQuickView { account in
                            
                            self.custAcct = account
                            
                        } create: { term in
                            // No customer, create customer.
                            addToDom(CreateNewCusomerView(
                                searchTerm: term,
                                custType: .general,
                                callback: { acctType, custType, searchTerm in
                                    
                                    let custDataView = CreateNewCustomerDataView(
                                        acctType: acctType,
                                        custType: custType,
                                        orderType: nil,
                                        searchTerm: searchTerm
                                    ) { account in
                                        
                                        self.custAcct = account
                                        
                                    }

                                    self.appendChild(custDataView)
                                    
                                }))
                        }

                        addToDom(view)
                    }
                    
                    if !self.isSubView {
                        
                        Img()
                            .closeButton(.view)
                            .marginTop(12.px)
                            .onClick {
                                
                                if let callback = self.closeView {
                                    callback()
                                    return
                                }
                                
                                self.remove()
                            }
                        
                        Img()
                            .src("/skyline/media/lowerWindow.png")
                            .marginRight(18.px)
                            .cursor(.pointer)
                            .marginTop(12.px)
                            .float(.right)
                            .width(24.px)
                            .onClick {
                                
                                print("🟢  Will try to lower window 001")
                                
                                if let callback = self.minimizeView {
                                    callback()
                                    return
                                }
                            }
                        
                    }
                    else {
                        
                        Div{
                            
                            Span("Nueva Venta")
                                .fontSize(21.px)
                            
                        }
                        .class(.uibutton)
                        .display(.inlineBlock)
                        .marginRight(18.px)
                        .onClick {
                            self.resetView()
                        }
                    }
                    
                    
                }
                .marginRight(7.px)
                .marginTop(-12.px)
                .float(.right)
                
                Div().class(.clear)
                
                // ResultBox
                self.resultBox
            }
            .paddingBottom(3.px)
            
            //Price Grid
            Div{
                self.itemGrid
                
                Div{
                    Span(self.$rewadsPoints.map{ "⭐️ Estas Usando \( ($0 ?? 0).formatMoney ) pts" })
                    
                    Img()
                        .src("/skyline/media/cross.png")
                        .cursor(.pointer)
                        .marginLeft(7.px)
                        .marginTop(7.px)
                        .height(18.px)
                        .onClick {
                            self.rewadsPoints = nil
                        }
                    
                }
                    .class(.uibtnLargeOrange)
                    .position(.absolute)
                    .bottom(72.px)
                    .hidden(self.$rewadsPoints.map{ ($0 ?? 0) == 0 })
            }
            .custom("height", "calc(100% - 115px)")
            .padding(all: 7.px)
            .class(.roundBlue)
            .overflow(.auto)
            .onClick {
                self.resultBox.innerHTML = ""
            }
            
            Div {
                /// Crear Presupuesto
                Div{
                    Div{
                        
                        Span()
                            .backgroundImage("skyline/media/list.png")
                            .class(.ico)
                        
                        Span("Crear Presupuesto")
                        
                    }
                    .hidden(self.$kart.map{ $0.isEmpty })
                    .onClick(self.createBudget)
                    .marginRight(12.px)
                    .class(.uibutton)
                }
                .hidden(self.$budgetid.map{ $0 != nil })
                .float(.left)
                
                /// Budget Control Buttons
                Div{
                    
                    H2(self.$budgetFolio)
                        .marginRight(12.px)
                        .float(.left)
                    
                    Div{
                        // Download
                        Div{
                            
                            Span()
                                .backgroundImage("skyline/media/download2.png")
                                .class(.ico)
                            
                            Span("Descargar")
                            
                        }
                        .onClick{
                            self.sendBudgetDocument(type: .print, fiscalProfile: nil)
                        }
                        .marginRight(12.px)
                        .class(.uibutton)
                        .float(.left)
                        
                        // Send
                        Div{
                            
                            Span()
                                .backgroundImage("skyline/media/sendToMobile.png")
                                .class(.ico)
                            
                            Span("Enviar")
                            
                        }
                        .onClick{
                            self.sendBudgetDocument(type: .send, fiscalProfile: nil)
                        }
                        .marginRight(12.px)
                        .class(.uibutton)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                        Div{
                            self.allowBudgetDetailsCheckbox
                            Label("IVA Desglosado")
                                .for("allowBudgetDetailsBox")
                        }
                        
                    }
                    .float(.left)
                    
                    
                    
                }
                .hidden(self.$budgetid.map{ $0 == nil })
                .float(.left)
                
                /// Credit Button
                Div{
                    Div("Enviar a Credito")
                    .marginRight(12.px)
                    .class(.uibutton)
                    .onClick {
                        self.sendToCredit()
                    }
                }
                .hidden(self.$custAcct.map{ $0?.crstatus != .active})
                .float(.left)
                
                /// Consetion Button
                Div{
                    Div("Enviar a Concesión")
                    .marginRight(12.px)
                    .class(.uibutton)
                    .onClick {
                        self.sendToConsetion()
                    }
                }
                .hidden(self.$custAcct.map{ $0?.crstatus != .active})
                .float(.left)
                
                Img()
                    .src("images/card_paybtn.png")
                    .float(.right)
                
                Div{
                    
                    Span()
                        .backgroundImage("images/bill.png")
                        .class(.ico)
                    
                    Span("Pagar y Cerrar")
                        .fontSize(16.px)
                    
                }
                .onClick{
                    self.confirmSale()
                }
                .marginRight(12.px)
                .class(.uibutton)
                .float(.right)
                
                H2(self.$balanceString)
                    .color(.highlighBlue)
                    .marginRight(5.px)
                    .marginLeft(5.px)
                    .fontSize(32.px)
                    .float(.right)
                
                H2("TOTAL")
                    .marginRight(5.px)
                    .marginLeft(5.px)
                    .fontSize(32.px)
                    .float(.right)
                    .color(.gray)
                
                
            }
            .marginTop(3.px)
            
            Div().class(.clear)
            
        }
        .custom("height", isSubView ? "calc(100% - 31px)" : "calc(100% - 70px)")
        .custom("width", isSubView ? "calc(100% - 31px)" : "calc(100% - 100px)")
        .left(isSubView ? 3.px : 40.px)
        .top(isSubView ? 3.px : 25.px)
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        
    }
    
    override func buildUI() {
        
        if !isSubView {
            
            self.class(.transparantBlackBackGround)
            height(100.percent)
            position(.absolute)
            width(100.percent)
            left(0.px)
            top(0.px)
            
        }
        
        $rewadsPoints.listen {
            self.calcBalance()
        }
        
        $custAcct.listen {
            
            if let account = $0 {
                
                let folio = account.folio.explode("-").last ?? ""
                
                switch account.type{
                case .personal:
                    self.selectedAccountName = "\(folio) \(account.firstName) \(account.lastName)"
                case .empresaFisica, .empresaMoral, .organizacion:
                    self.selectedAccountName = "\(folio) \(account.businessName) \(account.fiscalRfc)"
                }
                
                self.firstName = account.firstName
                
                self.lastName = account.lastName
                
                self.mobile = account.mobile
            }
            
        }
        
        if let loadBy {
            
            switch loadBy{
            case .budget(let id):
                
                loadingView(show: true)
                
                API.custAPIV1.loadBudgetObject(
                    id: id,
                    store: custCatchStore
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else{
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    self.budgetid = payload.budgetId
                    
                    self.budgetFolio = payload.budgetFolio
            
                    self.custAcct = payload.custAcct
                    
                    payload.saleObjects.forEach { item in
                        
                        let poc = item.custPOC
                        
                        let price = item.unitPrice
                        
                        let id = UUID()
                        
                        var series: [String] = item.ids.map{ $0.series }
                        
                        let row = KartItemView(
                            id: id,
                            cost: poc.cost,
                            quant: item.units / 100,
                            price: price,
                            data: .init(
                                t: .product,
                                i: poc.id,
                                u: poc.upc,
                                n: poc.name,
                                b: poc.brand,
                                m: poc.model,
                                p: price,
                                a: poc.avatar
                            )
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                           
                            self.kart.forEach { item in
                               if item.id != id {
                                   _kart.append(item)
                               }
                            }
                            
                            self.kart = _kart
                            
                            var _selectedInventoryIDs: [UUID] = []
                            
                            /// Ids  to be removed
                            let ids = item.ids.map{ $0.id }
                            
                            self.selectedInventoryIDs.forEach { id in
                                
                                if !ids.contains(id) {
                                    _selectedInventoryIDs.append(id)
                                }
                                
                            }
                            
                            self.selectedInventoryIDs = _selectedInventoryIDs
                            
                            self.calcBalance()
                        } editManualCharge: { id, units, description, price, cost in
                            print("⭐️  editManualCharge  ⭐️  editManualCharge 002")
                        }
                        
                        let ids = item.ids.map{ $0.id }
                        
                        self.kart.append(
                            .init(
                                id: id,
                                kartItemView: row,
                                data: .init(
                                    type: .product,
                                    id: poc.id,
                                    store: item.ids.first?.custStore ?? custCatchStore,
                                    ids: item.ids.map{ $0.id },
                                    series: series,
                                    cost: poc.pricea,
                                    units: item.units,
                                    unitPrice: price,
                                    subTotal: price * (item.units / 100),
                                    costType: item.costType,
                                    name: poc.name,
                                    brand: poc.brand,
                                    model: poc.model,
                                    pseudoModel: poc.pseudoModel,
                                    avatar: poc.model,
                                    fiscCode: poc.fiscCode,
                                    fiscUnit: poc.fiscUnit,
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.selectedInventoryIDs.append(contentsOf: ids)
                        
                        self.itemGrid.appendChild(row)
                        
                    }
                    
                    payload.saleObjectsSOC.forEach { item in
                        
                        let manualid = UUID()
                        
                        let row = KartItemView(
                            id: item.custSOC.id,
                            cost: item.custSOC.cost,
                            quant: item.units / 100,
                            price: item.unitPrice,
                            data: .init(
                                t: .service,
                                i: item.custSOC.id,
                                u: "",
                                n: item.custSOC.name,
                                b: "",
                                m: "",
                                p: item.unitPrice,
                                a: ""
                            )
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                            
                            self.kart.forEach { item in
                                if item.id != id {
                                    _kart.append(item)
                                }
                            }
                            
                            self.kart = _kart
                            
                            self.calcBalance()
                            
                        } editManualCharge: { id, units, description, price, cost in
                            Console.clear()
                            
                             print("⭐️  editManualCharge  ⭐️  editManualCharge 003")
                            
                             var _kart: [SalePointObject] = []
                             
                             self.kart.forEach { item in
                                 
                                 if item.id == id {
                                     
                                     _kart.append(.init(
                                         id: id,
                                         kartItemView: item.kartItemView,
                                         data: .init(
                                             type: .service,
                                             id: manualid,
                                             store: custCatchStore,
                                             ids: [],
                                             series: [],
                                             cost: cost,
                                             units: units,
                                             unitPrice: price,
                                             subTotal: price * (units / 100),
                                             costType: self.custAcct?.costType ?? .cost_a,
                                             name: description,
                                             brand: "",
                                             model: "",
                                             pseudoModel: "",
                                             avatar: "",
                                             fiscCode: "",
                                             fiscUnit: "",
                                             preRegister: false
                                         )
                                     ))
                                     
                                     return
                                 }
                                 
                                 _kart.append(item)
                                 
                             }
                             
                             self.kart = _kart
                             
                             self.calcBalance()
                             
                        }
                        
                        self.kart.append(
                            .init(
                                id: item.custSOC.id,
                                kartItemView: row,
                                data: .init(
                                    type: .service,
                                    id: manualid,
                                    store: custCatchStore,
                                    ids: [],
                                    series: [],
                                    cost: item.custSOC.cost,
                                    units: item.units,
                                    unitPrice: item.unitPrice,
                                    subTotal: item.unitPrice * (item.units / 100),
                                    costType: item.costType,
                                    name: item.custSOC.name,
                                    brand: "",
                                    model: "",
                                    pseudoModel: "",
                                    avatar: "",
                                    fiscCode: "",
                                    fiscUnit: "",
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.itemGrid.appendChild(row)
                        
                    }
                    
                    payload.saleObjectsManual.forEach { item in
                        
                        let manualid = UUID()
                        
                        let row = KartItemView(
                            id: item.id,
                            cost: item.cost ?? 0,
                            quant: item.units / 100,
                            price: item.unitPrice,
                            data: .init(
                                t: .manual,
                                i: manualid,
                                u: "",
                                n: item.name,
                                b: "",
                                m: "",
                                p: item.unitPrice,
                                a: ""
                            )
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                            
                            self.kart.forEach { item in
                                if item.id != id {
                                    _kart.append(item)
                                }
                            }
                            
                            self.kart = _kart
                            
                            self.calcBalance()
                            
                        } editManualCharge: { id, units, description, price, cost in
                            Console.clear()
                            
                             print("⭐️  editManualCharge  ⭐️  editManualCharge 003")
                            
                             var _kart: [SalePointObject] = []
                             
                             self.kart.forEach { item in
                                 
                                 if item.id == id {
                                     
                                     _kart.append(.init(
                                         id: id,
                                         kartItemView: item.kartItemView,
                                         data: .init(
                                             type: .manual,
                                             id: manualid,
                                             store: custCatchStore,
                                             ids: [],
                                             series: [],
                                             cost: cost,
                                             units: units,
                                             unitPrice: price,
                                             subTotal: price * (units / 100),
                                             costType: self.custAcct?.costType ?? .cost_a,
                                             name: description,
                                             brand: "",
                                             model: "",
                                             pseudoModel: "",
                                             avatar: "",
                                             fiscCode: "",
                                             fiscUnit: "",
                                             preRegister: false
                                         )
                                     ))
                                     
                                     return
                                 }
                                 
                                 _kart.append(item)
                                 
                             }
                             
                             self.kart = _kart
                             
                             self.calcBalance()
                             
                        }
                        
                        self.kart.append(
                            
                            .init(
                                id: item.id,
                                kartItemView: row,
                                data: .init(
                                    type: .manual,
                                    id: manualid,
                                    store: custCatchStore,
                                    ids: [],
                                    series: [],
                                    cost: item.cost,
                                    units: item.units,
                                    unitPrice: item.unitPrice,
                                    subTotal: item.unitPrice * (item.units / 100),
                                    costType: item.costType,
                                    name: item.name,
                                    brand: "",
                                    model: "",
                                    pseudoModel: "",
                                    avatar: "",
                                    fiscCode: "",
                                    fiscUnit: "",
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.itemGrid.appendChild(row)
                        
                    }
                    
                    self.calcBalance(firstLoad: true)
                    
                }
                
            case .transferInventory(_):
                break
            case .transferOrder(_):
                break
            }
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        searchBox.select()
    }
    
    func searchTermAct() {
        
        if searchBox.text.isEmpty {
            self.resultBox.innerHTML = ""
            return
        }
        
        let term = searchBox.text.purgeSpaces
        
        Dispatch.asyncAfter(0.37) {
            
            if term == self.searchBox.text.purgeSpaces {
                
                // TODO: properly parse currentCodeIds
                searchCharge(
                    term: self.searchBox.text,
                    costType: .cost_a,
                    currentCodeIds: []
                ) { term, resp in
                    
                    if self.searchBox.text == term {
                        
                        self.resultBox.innerHTML = ""
                        
                        if resp.count == 1 {
                            
                            guard let data = resp.first else {
                                return
                            }
                            
                            self.searchBox.text = ""
                            
                            switch data.t {
                            case .service:
                                self.loadSOC(soc: data)
                            case .product:
                                self.confirmProductView(pocid: data.i)
                            case .manual:
                                break
                            case .rental:
                                break
                            }
                            
                            return
                            
                        }
                        
                        resp.forEach { data in
                            
                            let view = SearchChargeView(data: data, costType: .cost_a, callback: { data in
                                
                                self.searchBox.text = ""
                                self.resultBox.innerHTML = ""
                                
                                switch data.t {
                                case .service:
                                    self.loadSOC(soc: data)
                                case .product:
                                    self.confirmProductView(pocid: data.i)
                                case .manual:
                                    break
                                case .rental:
                                    break
                                }
                                
                            })
                                .custom("width", "calc(50% - 28px)")
                                .marginRight(3.px)
                                .float(.left)
                            
                            
                            self.resultBox.appendChild(view)
                        }
                    }
                }
            }
        }
    }
    
    func calcBalance(firstLoad: Bool = false){
        
        if let _ = budgetid {
            if !firstLoad {
                saveBudgetDocument()
            }
        }
        
        var balance: Int64 = 0
        
        self.kart.forEach { item in
            balance += (item.data.unitPrice * (item.data.units / 100))
        }
        
        if let points = rewadsPoints?.toCents {
            balance -= points
        }
        
        self.balanceString = balance.formatMoney
        
        changeString = "0.00"
        
        guard let currentBalance = Float(self.balanceString)?.toCents else{
            return
        }
        
        guard let currentPayment = Float(self.payment)?.toCents else{
            return
        }
        
        if currentPayment <= 0 {
            return
        }
        
        guard currentPayment > currentBalance else {
            return
        }
        
        let change = currentPayment - currentBalance
        
        changeString = change.formatMoney
        
    }
    
    func sendToConsetion() {
        
        if kart.isEmpty {
            showAlert(.alerta, "No hay articulos en el carrito")
            searchBox.select()
            return
        }
        
        guard let custAcct else {
            showError(.errorGeneral, "Seleccione cuenta para continuar.")
            return
        }
        
        guard custAcct.type != .personal else {
            showError(.errorGeneral, "Lo sentimos, no se pueden generar consesiones a una cuenta personal")
            return
        }
        
        guard custAcct.crstatus == .active else {
            showError(.errorGeneral, "El credito en esta cuenta actualmente no esta activa.")
            return
        }
        
        var missingInventory = false
        
        var products: [SaleObjectItem] = []
        
        var services: [SaleObjectItem] = []
        
        var manuals: [SaleObjectItem] = []
        
        var ids:[UUID] = []
        
        kart.forEach { item in
            
            let data = item.data
            
            switch data.type {
            case .service:
                
                services.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: data.name
                    )
                )
                
            case .product:
                
                ids.append(contentsOf: data.ids)
                
                if (data.units / 100).toInt > data.ids.count {
                    missingInventory = true
                }
                
                products.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: "\(data.brand) \(data.model) \(data.name)"
                    )
                )
                
            case .manual:
                
                manuals.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: data.name
                    )
                )
                
            case .rental:
                break
            }
            
        }
        
        guard services.isEmpty else {
            showError(.errorGeneral, "No puede enviar sevicios a concesión")
            return
        }
        
        guard manuals.isEmpty else {
            showError(.errorGeneral, "No puede enviar cargos manuales a concesión")
            return
        }
        
        if products.isEmpty {
            showError(.errorGeneral, "No hay productos para evnviar a concesión")
            return
        }
        
        if missingInventory {
            showError(.errorGeneral, "No se pueden generar ordenes de compra sobre concesiones")
            return
        }
        
        addToDom(ConfirmView(type: .aproveDeny, title: "Confirme Accion", message: "¿Desea enviar esta productos a conseción?"){ isConfirmed, _ in
            
            if isConfirmed {
    
                addToDom(SMSRequestPIN(
                    custAcct: custAcct.id,
                    firstName: self.firstName,
                    cc: .mexico,
                    mobile: self.mobile,
                    callback: { token in
                        
                        self.tokens.append(token)
                        
                        addToDom(ConfirmartionSMSView(
                            tokens: self.tokens,
                            mobile: self.mobile,
                            customer: nil
                        ){ token in
                            
                            loadingView(show: true)
                            
                            API.custPDVV1.sendToConcession(
                                token: token,
                                storeId: custCatchStore,
                                accountId: custAcct.id,
                                items: products
                            ) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp = resp else {
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
                                
                                let control = payload.control
                                
                                let cardex = payload.cardex
                                
                                
                                self.appendChild(ConcessionConfirmationView(
                                    accountid: custAcct.id,
                                    accountFolio: custAcct.folio,
                                    accountName: "\(custAcct.fiscalRfc) \(custAcct.fiscalRazon)",
                                    purchaseManager: control.id,
                                    subTotal: self.balanceString,
                                    document: control,
                                    kart: self.kart,
                                    cardex: cardex
                                ))
                                
                                self.resetView()
                                
                            }
                        })
                    }
                ))
            }
        })
    }
    
    func sendToCredit() {
        
        guard let currentBalance = Float(self.balanceString.replace(from: ",", to: ""))?.toCents else{
            return
        }
        
        if currentBalance <= 0 {
            return
        }

        addToDom(ConfirmView(type: .aproveDeny, title: "Confirme Accion", message: "¿Desea enviar esta compra a credito?"){ isConfirmed, _ in
            if isConfirmed {
                self.closeSale(.porDefenir, "Venta a Credito", currentBalance.fromCents, "", "", "")
            }
        })
        
    }
    
    func confirmSale(force: Bool = false) {
        
        guard let currentBalance = Float(self.balanceString.replace(from: ",", to: ""))?.toCents else{
            return
        }
        
        if currentBalance <= 0 {
            return
        }
        
        if !force {
            
            if (custAcct?.CardID ?? "").isEmpty {
                
                if let orderCloseInscriptionMode = configStoreProcessing.rewardsPrograme?.pointOfSaleCloseInscriptionMode {
                    
                    switch orderCloseInscriptionMode {
                    case .required, .recomended:
                        
                        if orderCloseInscriptionMode == .required {
                            showError(.errorGeneral, "Se requiere que incriba al cliente en el sistema de recompensas")
                        }
                        
                        self.addLoyaltyCard( isRequiered: orderCloseInscriptionMode == .required ) {
                            self.confirmSale(force: true)
                        }
                        
                        return
                    case .notrequired:
                        break
                    case .optional:
                        break
                    }
                    
                }
                
            }
            
        }
        
        let paymentView = AddPaymentFormView (
            accountId: self.custAcct?.id,
            cardId: self.custAcct?.CardID,
            currentBalance: currentBalance,
            isUsingPoints: ((self.rewadsPoints ?? 0) != 0 )
        ) { code, description, amount, provider, lastFour, auth, uts in
            
            if code == .dineroElectronico {
                self.payWithPoints(amount)
                return
            }
            
            self.closeSale(code, description, amount, provider, lastFour, auth)
            
        }
        
        paymentView.isDownPaymentDisabled = true
        
        paymentView.datePickerIsHidden = true
        
        self.appendChild(paymentView)
        
        paymentView.paymentInput.select()
        
    }
    /// Adds points to balance of the account
    func payWithPoints(_ points: Float) {
        
        if let rewadsPoints {
            showError(.errorGeneral, "Ya esta usando \(rewadsPoints.toInt) pts" )
            return
        }
        
        guard let currentBalance = Float(self.balanceString) else {
            return
        }
        
        rewadsPoints = points
        
        let remaingBalance = currentBalance - points
        
        if remaingBalance == 0 {
            closeSale(.dineroElectronico, "", 0, "", "", "")
            return
        }
        
    }
    
    func closeSale(
        _ fiscCode: FiscalPaymentCodes,
        _ description: String,
        _ amount: Float,
        _ provider: String,
        _ lastFour: String,
        _ auth: String
    ) {
        
        guard let currentBalance = Float(self.balanceString.replace(from: ",", to: "")) else{
            return
        }
        
        print("currentBalance \(currentBalance)")
        print("amount \(amount)")
        
        if currentBalance > amount {
            print("🟡  MORE PAYMENT")
            return
        }
        
        print("🟢 OK PAYMENT")
        
        if kart.isEmpty {
            showAlert(.alerta, "No hay articulos en el carrito")
            searchBox.select()
            return
        }
        
        var missingInventory = false
        
        var products: [SaleObjectItem] = []
        
        var services: [SaleObjectItem] = []
        
        var manuals: [SaleObjectItem] = []
        
        var ids:[UUID] = []
        
        kart.forEach { item in
            
            let data = item.data
            
            switch data.type {
            case .service:
                
                services.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: data.name
                    )
                )
                
            case .product:
                
                ids.append(contentsOf: data.ids)
                
                if (data.units / 100).toInt > data.ids.count {
                
                    missingInventory = true
                    
                }
                
                products.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: "\(data.brand) \(data.model) \(data.name)"
                    )
                )
                
            case .manual:
                
                manuals.append(
                    .init(
                        id: data.id,
                        store: data.store,
                        ids: data.ids,
                        quant: data.units.fromCents,
                        price: data.unitPrice.fromCents,
                        subtotal: (data.unitPrice * (data.units / 100)).fromCents,
                        costType: data.costType,
                        serie: "",
                        description: data.name
                    )
                )
                
            case .rental:
                break
            }
            
        }
        
        if missingInventory {
            
            if custAcct == nil {
                
                let view = SearchCustomerQuickView { account in
                    
                    self.custAcct = account
                    
                    self.closeSale(
                        fiscCode,
                        description,
                        amount,
                        provider,
                        lastFour,
                        auth
                    )
                    
                }
                create: { term in
                    /// No customer, create customer.
                    addToDom(CreateNewCusomerView(
                        searchTerm: term,
                        custType: .general,
                        callback: { acctType, custType, searchTerm in
                            
                            let custDataView = CreateNewCustomerDataView(
                                acctType: acctType,
                                custType: custType,
                                orderType: nil,
                                searchTerm: searchTerm
                            ) { account in
                                
                                self.custAcct = account
                                
                                self.closeSale(
                                    fiscCode,
                                    description,
                                    amount,
                                    provider,
                                    lastFour,
                                    auth
                                )
                                
                            }

                            self.appendChild(custDataView)
                            
                        }))
                }

                addToDom(view)
                
                return
            }
        }
        
        loadingView(show: true)
        
        API.custPDVV1.closeSale(
            custAcct: custAcct?.id,
            cardId: custAcct?.CardID,
            custSubAcct: custSubAcct,
            custSale: custSale,
            firstName: firstName,
            lastName: lastName,
            mobile: mobile,
            comment: comment,
            store: custCatchStore,
            saleObject: products,
            saleObjectService: services,
            saleObjectManual: manuals,
            saleType: .pdv,
            fiscCode: fiscCode,
            description: description,
            amount: amount,
            provider: provider,
            lastFour: lastFour,
            auth: auth,
            rewardsPoints: self.rewadsPoints?.toInt
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, "Error de comunicacion")
                return
            }
            
            if resp.status != .ok {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data")
                return
            }
            
            var cambio = ""
            
            if let _total = Float(self.balanceString.replace(from: ",", to: ""))?.toCents{
                let _payment = amount.toCents
                cambio = (_payment - _total).formatMoney
            }
            
            let view = PaymentConfirmationView(
                saleId: data.id,
                saleFolio: data.folio,
                accountid: self.custAcct?.id,
                accountFolio: self.custAcct?.folio,
                accountName: "\(self.firstName) \(self.lastName)",
                subTotal: self.balanceString,
                payment: amount.formatMoney,
                change: cambio,
                kart: self.kart,
                cardex: []
            )
            
            self.appendChild(view)
            
            self.selectedInventoryIDs.append(contentsOf: ids)
            
            self.resetView()
            
        }
         
    }
    
    func createBudget(){
        
        guard let custAcct else {
            
            let view = SearchCustomerQuickView { account in
                
                self.custAcct = account
                
                self.createBudget()
                
            } create: { term in
                /// No customer, create cuatomer.
                addToDom(CreateNewCusomerView(
                    searchTerm: term,
                    custType: .general,
                    callback: { acctType, custType, searchTerm in
                        
                        let custDataView = CreateNewCustomerDataView(
                            acctType: acctType,
                            custType: custType,
                            orderType: nil,
                            searchTerm: searchTerm
                        ) { account in
                            
                            self.custAcct = account
                            self.createBudget()
                            
                        }

                        self.appendChild(custDataView)
                        
                    }))
            }

            addToDom(view)
            
            return
        }
        
        let view = BudgetConfirmationView (
            custAcct: custAcct,
            comment: "",
            store: custCatchStore,
            saleType: .sale,
            kart: kart
        ) { type, budgetid, budgetFolio, fiscalProfile in
            
            self.budgetid = budgetid
            
            self.budgetFolio = budgetFolio
            
            self.sendBudgetDocument(type: type, fiscalProfile: fiscalProfile)
            
        }
        
        addToDom(view)
        
    }
    
    func saveBudgetDocument() {
    
        guard let custAcct else {
            showError(.errorGeneral, "No se la localizado cuenta del cliente. Contacte a Soporte TC")
            return
        }
       
        API.custPDVV1.createBudgetReport(
            fiscalProfile: nil,
            budgetid: budgetid,
            custAcct: custAcct.id,
            comment: comment,
            store: custCatchStore,
            saleType: .sale,
            saleObjects: kart.map{ $0.data }
        ) { resp in
           
           guard let resp else {
               showError(.errorDeCommunicacion, .serverConextionError)
               return
           }
           
           guard resp.status == .ok else {
               showError(.errorGeneral, resp.msg)
               return
           }
           
           showSuccess(.operacionExitosa, "Presupuesto actualizado \(self.budgetFolio)", .short)
           
       }
       
    }
    
    func sendBudgetDocument(type: BudgetConfirmationView.BudgetType, fiscalProfile: UUID?) {
    
        guard let custAcct else {
            showError(.unexpectedResult, "No se localizo cuenta")
            return
        }
        
        guard let budgetid else {
            showError(.unexpectedResult, "No se localizo id del presupuesto")
            return
        }
        
        guard let pDirRaw = customerServiceProfile?.account.pDir else {
            showError(.unexpectedResult, "No se localizo pdir")
            return
        }
        
        let firstName = custAcct.firstName
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let lastName = custAcct.lastName
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let mobile = custAcct.mobile
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _type = type.rawValue
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let id = budgetid.uuidString
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let pDir = pDirRaw
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        var url = baseSkylineAPIUrl(ie: "createBudgetReport") +
        "&firstName=\(firstName)" +
        "&lastName=\(lastName)" +
        "&mobile=\(mobile)" +
        "&type=\(type)" +
        "&id=\(id)" +
        "&pDir=\(pDir)".replace(from: " ", to: "+") +
        "&deductedTaxes=\(self.allowBudgetDetails.description)"
        
        if let fiscalProfile {
            url += "&fiscalProfile=\(fiscalProfile.uuidString)"
        }
        
        switch type {
        case .print:
            _ = JSObject.global.goToURL!(url)
            showSuccess(.operacionExitosa, "Preparando descarga")
        case .send:
            
            let xhr = XMLHttpRequest()
            
            
            xhr.open(method: "GET", url: url)
            
            xhr.setRequestHeader("Accept", "application/json")
                .setRequestHeader("Content-Type", "application/json")

            xhr.send()
            
            xhr.onError {
                print("❌ 002 enviar doc")
                print(xhr.responseText ?? "")
            }
            
            xhr.onLoad {
                
                if let data = xhr.responseText?.data(using: .utf8) {
                    do {
                        
                        let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                                
                        guard resp.status == .ok else {
                            print("❌ 004 enviar doc")
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Documemto Enviado")
                        
                    } catch {}
                }
                else{
                    print("❌ 001 enviar doc")
                }
                
            }
        }
    }
    
    func confirmProductView( pocid: UUID){
        
        let _view = ConfirmProductView(
            accountId: custAcct?.id,
            costType: custAcct?.costType ?? .cost_a,
            pocid: pocid,
            selectedInventoryIDs: self.selectedInventoryIDs,
            callback: { poc, price, costType, units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder in
                
                if (units.toInt / 100) > items.count {
                    
                    let missingInventoryCount = ((units.toInt / 100) - items.count).toInt64
                    
                    /**
                     ``Add current Inventory``
                     */
                    
                    if items.count > 0 {
                        
                        let id = UUID()
                        
                        var series: [String] = []
                        
                        items.forEach { item in
                            if !item.series.isEmpty {
                                series.append(item.series)
                            }
                        }
                        
                        let row = KartItemView(
                            id: id,
                            cost: poc.cost,
                            quant: items.count.toInt64 / 100,
                            price: price,
                            data: .init(
                                t: .product,
                                i: poc.id,
                                u: poc.upc,
                                n: poc.name,
                                b: poc.brand,
                                m: poc.model,
                                p: price,
                                a: poc.avatar
                            )
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                           
                            self.kart.forEach { item in
                               if item.id != id {
                                   _kart.append(item)
                               }
                            }
                            
                            self.kart = _kart
                            
                            var _selectedInventoryIDs: [UUID] = []
                            
                            /// Ids  to be removed
                            let ids = items.map{ $0.id }
                            
                            self.selectedInventoryIDs.forEach { id in
                                
                                if !ids.contains(id) {
                                    _selectedInventoryIDs.append(id)
                                }
                                
                            }
                            
                            self.selectedInventoryIDs = _selectedInventoryIDs
                            
                            self.calcBalance()
                        } editManualCharge: { id, units, description, price, cost in
                            print("⭐️  editManualCharge  ⭐️  editManualCharge 004")
                        }
                        
                        let ids = items.map{$0.id}
                        
                        self.kart.append(
                            .init(
                                id: id,
                                kartItemView: row,
                                data: .init(
                                    type: .product,
                                    id: poc.id,
                                    store: storeid,
                                    ids: items.map{$0.id},
                                    series: series,
                                    cost: poc.cost,
                                    units: items.count.toInt64 * 100.toInt64,
                                    unitPrice: price,
                                    subTotal: price * items.count.toInt64,
                                    costType: costType,
                                    name: poc.name,
                                    brand: poc.brand,
                                    model: poc.model,
                                    pseudoModel: poc.pseudoModel,
                                    avatar: poc.model,
                                    fiscCode: poc.fiscCode,
                                    fiscUnit: poc.fiscUnit,
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.selectedInventoryIDs.append(contentsOf: ids)
                        
                        self.itemGrid.appendChild(row)
                        
                        self.searchBox.select()
                        
                        self.calcBalance()
                        
                    }
                    
                    /**
                        ``Add mining Inventory``
                     */
                    
                    if missingInventoryCount > 0 {
                        
                        let id = UUID()
                        
                        var series: [String] = []
                        
                        items.forEach { item in
                            if !item.series.isEmpty {
                                series.append(item.series)
                            }
                        }
                        
                        let row = KartItemView(
                            id: id,
                            cost: poc.cost,
                            quant: missingInventoryCount,
                            price: price,
                            data: .init(
                                t: .product,
                                i: poc.id,
                                u: poc.upc,
                                n: poc.name,
                                b: poc.brand,
                                m: poc.model,
                                p: price,
                                a: poc.avatar
                            ),
                            missingInventory: true
                        ) { id in
                            
                            var _kart: [SalePointObject] = []
                           
                            self.kart.forEach { item in
                               if item.id != id {
                                   _kart.append(item)
                               }
                            }
                           
                            self.kart = _kart
                            
                            self.calcBalance()
                        } editManualCharge: { id, units, description, price, cost in
                            print("⭐️  editManualCharge  ⭐️  editManualCharge 007")
                        }
                        
                        let ids = items.map{$0.id}
                        
                        self.kart.append(
                            .init(
                                id: id,
                                kartItemView: row,
                                data: .init(
                                    type: .product,
                                    id: poc.id,
                                    store: storeid,
                                    ids: [],
                                    series: series,
                                    cost: poc.cost,
                                    units: missingInventoryCount * 100,
                                    unitPrice: price,
                                    subTotal: price * missingInventoryCount,
                                    costType: costType,
                                    name: poc.name,
                                    brand: poc.brand,
                                    model: poc.model,
                                    pseudoModel: poc.pseudoModel,
                                    avatar: poc.model,
                                    fiscCode: poc.fiscCode,
                                    fiscUnit: poc.fiscUnit,
                                    preRegister: false
                                )
                            )
                        )
                        
                        self.selectedInventoryIDs.append(contentsOf: ids)
                        
                        self.itemGrid.appendChild(row)
                        
                        self.searchBox.select()
                        
                        self.calcBalance()
                        
                    }
                    
                    
                }
                else {
                    
                    let id = UUID()
                    
                    var series: [String] = []
                    
                    items.forEach { item in
                        if !item.series.isEmpty {
                            series.append(item.series)
                        }
                    }
                    
                    let row = KartItemView(
                        id: id,
                        cost: poc.cost,
                        quant: units / 100,
                        price: price,
                        data: .init(
                            t: .product,
                            i: poc.id,
                            u: poc.upc,
                            n: poc.name,
                            b: poc.brand,
                            m: poc.model,
                            p: price,
                            a: poc.avatar
                        )
                    ) { id in
                        
                        var _kart: [SalePointObject] = []
                       
                        self.kart.forEach { item in
                           if item.id != id {
                               _kart.append(item)
                           }
                        }
                       
                        self.kart = _kart
                        
                        var _selectedInventoryIDs: [UUID] = []
                        
                        /// Ids  to be removed
                        let ids = items.map{ $0.id }
                        
                        self.selectedInventoryIDs.forEach { id in
                            
                            if !ids.contains(id) {
                                _selectedInventoryIDs.append(id)
                            }
                            
                        }
                        
                        self.selectedInventoryIDs = _selectedInventoryIDs
                        
                        self.calcBalance()
                    } editManualCharge: { id, units, description, price, cost in
                        print("⭐️  editManualCharge  ⭐️  editManualCharge 009")
                    }
                    
                    let ids = items.map{$0.id}
                    
                    self.kart.append (
                        .init(
                            id: id,
                            kartItemView: row,
                            data: .init(
                                type: .product,
                                id: poc.id,
                                store: storeid,
                                ids: items.map{$0.id},
                                series: series,
                                cost: poc.cost,
                                units: units,
                                unitPrice: price,
                                subTotal: price * (units / 100),
                                costType: costType,
                                name: poc.name,
                                brand: poc.brand,
                                model: poc.model,
                                pseudoModel: poc.pseudoModel,
                                avatar: poc.model,
                                fiscCode: poc.fiscCode,
                                fiscUnit: poc.fiscUnit,
                                preRegister: false
                            )
                        )
                    )
                    
                    self.selectedInventoryIDs.append(contentsOf: ids)
                    
                    self.itemGrid.appendChild(row)
                    
                    self.searchBox.select()
                    
                    self.calcBalance()
                    
                }
                
            }
        )
        
        self.appendChild(_view)
        
        _view.quantInput.select()
        
    }
    
    func loadSOC(soc: SearchChargeResponse) {
       
       let view = BudgetSOCView(
            loadSocDetails: false,
            soc: soc,
            costType: custAcct?.costType ?? .cost_a
       ) { soc in
           
           let id = UUID()
           
           let row = KartItemView(
               id: id,
               cost: soc.price,
               quant: (soc.units / 100),
               price: soc.price,
               data: .init(
                   t: .service,
                   i: soc.id ?? .init(),
                   u: "",
                   n: soc.description,
                   b: "",
                   m: "",
                   p: soc.price,
                   a: ""
               )
           ) { id in
               
               var _kart: [SalePointObject] = []
              
               self.kart.forEach { item in
                  if item.id != id {
                      _kart.append(item)
                  }
               }
              
               self.kart = _kart
               
               self.calcBalance()
           } editManualCharge: { id, units, description, price, cost in
               print("⭐️  editManualCharge  ⭐️  editManualCharge 0010")
           }
           
           self.kart.append(
               .init(
                   id: id,
                   kartItemView: row,
                   data: .init(
                       type: .service,
                       id: soc.id ?? .init(),
                       store: custCatchStore,
                       ids: [],
                       series: [],
                       cost: soc.price,
                       units: soc.units,
                       unitPrice: soc.price,
                       subTotal: soc.price * (soc.units / 100),
                       costType: self.custAcct?.costType ?? .cost_a,
                       name: soc.description,
                       brand: "",
                       model: "",
                       pseudoModel: "",
                       avatar: "",
                       fiscCode: "",
                       fiscUnit: "",
                       preRegister: false
                   )
               )
           )
           
           self.itemGrid.appendChild(row)
           
           self.searchBox.select()
           
           self.calcBalance()
            
       }
       
       addToDom(view)
       
   }
    
    func resetView(){
        
        kart = []
        
        itemGrid.innerHTML = ""
        
        itemGrid.appendChild(
            Tr {
                Td().width(50)
                Td("Marca").width(200)
                Td("Modelo / Nombre")
                //Td("Hubicación").width(200)
                Td("Units").width(100)
                Td("C. Uni").width(100)
                Td("S. Total").width(100)
            }
        )
        
        custAcctFolio = "S/F"
        custAcct = nil
        custSubAcct = nil
        custSale = nil
        selectedAccountName = "S/F Publico General"
        firstName = "Publico"
        lastName = "General"
        mobile = ""
        comment = ""
        payment = "0.00"
        balanceString = "0.00"
        changeString = "0.00"
        searchTerm = ""
        rewadsPoints = nil
    }
    
    func addLoyaltyCard(isRequiered: Bool, callback: @escaping (() -> ())){
        
        if let custAcct {
            guard custAcct.type == .personal else {
                showError(.errorGeneral, "Lo sentimos las cuentas \(custAcct.type.description) aun no es soportado.")
                return
            }
        }
        
        let _callback = isRequiered ? nil : callback
        
        addToDom(AccountView.RequestSiweCard(
            accountId: custAcct?.id,
            cc: .mexico,
            mobile: custAcct?.mobile ?? "",
            callback: { token, cardId, account in
                
                if let account {
                    if !account.CardID.isEmpty {
                        
                        self.custAcct = account
                        
                        self.custAcct?.CardID = account.CardID
                        
                        self.confirmSale()
                        
                        return
                    }
                }
                
                self.custAcct = account
                
                
                guard let custAcct = self.custAcct else {
                    showError(.unexpectedResult, "No se localizo cuenta cargue cuenta e intente de nuevo.")
                    return
                }
                
                self.smsTokens.append(token)
                
                addToDom(AccountView.ConfimeSiweCard(
                    custAcct: custAcct.id,
                    cc: .mexico,
                    mobile: custAcct.mobile,
                    tokens: self.smsTokens,
                    cardId: cardId,
                    callback: { cardId in
                        
                        self.custAcct?.CardID = cardId
                        
                        self.confirmSale()
                        
                    }
                ))
                
            },
            bypassProgram: _callback
        ))
    }
    
    func openAccount(){
        
        guard let custAcct else {
            return
        }
        
        let view = AccoutOverview(id: .id(custAcct.id))
            .zIndex(999999992)
        
        view.loadAccout()
        
        addToDom(view)
        
    }
    
}

extension SalePointView {
    
    enum BudgetDownloadType {
        case print
    }
    
    enum ViewLoader {
        case budget(HybridIdentifier)
        case transferInventory(HybridIdentifier)
        case transferOrder(HybridIdentifier)
    }
    
}
