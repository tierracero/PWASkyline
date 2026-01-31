//
//  ProductTransferView.swift
//  
//
//  Created by Victor Cantu on 4/28/23.
//

import Foundation
import TCFundamentals
// import SkylinePublicAPI
import TCFireSignal
import Web

class ProductTransferView: Div {
    
    override class var name: String { "div" }
    
    /*
    let workView: WorkViewControler
    
    var alerts: [CustTaskAuthorizationManager]
    
    init(
        workView: WorkViewControler,
        alerts: [CustTaskAuthorizationManager]
    ) {
        self.workView = workView
        self.alerts = alerts
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    */
    
    lazy var incomingTransfer = Div()
    lazy var outgoingTransfer = Div()
    
    @State var hasTransfers = false
    
    @State var currentView: CurrentView = .mainView
    
    @State var selectedStore: CustStore? = nil
    
    @State var searchTerm = ""
    
    @State var searchMermTerm = ""
    
    @State var kart: [SalePointObject] = []
    
    var selectedInventoryIDs: [UUID] = []
    
    lazy var storeSelect = Select{
        Option("Seleccione Tienda")
            .value("")
    }
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .fontSize(32.px)
        .height(36.px)
    
    lazy var storeMermSelect = Select{
        Option("Seleccione Tienda")
            .value("")
    }
        .custom("width","calc(100% - 18px)")
        .class(.textFiledBlackDark)
        .fontSize(32.px)
        .height(36.px)
    
    lazy var searchBox = InputText($searchTerm)
        .custom("background", "url('images/barcode.png') no-repeat scroll 7px 7px rgb(29, 32, 38)")
        .placeholder("Ingrese UPC/SKU/POC o Referencia")
        .backgroundSize(h: 18.px, v: 18.px)
        .class(.textFiledBlackDark)
        .marginLeft(7.px)
        .paddingLeft(30.px)
        .width(350.px)
        .height(32.px)
        .float(.left)
        .onFocus { tf in
            self.resultBox.innerHTML = ""
            tf.text = ""
        }
        .onBlur {
            Dispatch.asyncAfter(0.7) {
                self.resultBox.innerHTML = ""
            }
        }
        .onKeyUp{ _, event in
            if ignoredKeys.contains(event.key) {
                return
            }
            self.search()
        }
        .onEnter {
            self.search()
        }
    
    let resultBox = Div()
        .backgroundColor(.transparentBlack)
        .borderRadius(12.px)
        .position(.absolute)
        .margin(all: 3.px)
        .marginTop(12.px)
        .width(900.px)
    
    let resultMermBox = Div()
        .backgroundColor(.transparentBlack)
        .borderRadius(12.px)
        .position(.absolute)
        .margin(all: 3.px)
        .marginTop(12.px)
        .width(900.px)
    
    lazy var itemGrid = Table{
        Tr {
            Td().width(50)
            Td("Marca").width(100)
            Td("Modelo / Nombre")
            //Td("Hubicación").width(200)
            Td("Units").width(50)
            Td("C. Uni").width(70)
            Td("S. Total").width(90)
        }
    }
        .width(100.percent)
        .color(.white)
    
    lazy var itemMermGrid = Table{
        Tr {
            Td().width(50)
            Td("Marca").width(100)
            Td("Modelo / Nombre")
            //Td("Hubicación").width(200)
            Td("Units").width(50)
            Td("C. Uni").width(70)
            Td("S. Total").width(90)
        }
    }
        .width(100.percent)
        .color(.white)
    
    @State var pullRequst: PullRequest = .current
    
    @State var selectPullTypeIsHidden: Bool = true
    
    lazy var searchMermBox = InputText($searchMermTerm)
        .custom("background", "url('images/barcode.png') no-repeat scroll 7px 7px rgb(29, 32, 38)")
        .placeholder("Ingrese UPC/SKU/POC o Referencia")
        .backgroundSize(h: 18.px, v: 18.px)
        .class(.textFiledBlackDark)
        .marginLeft(7.px)
        .paddingLeft(30.px)
        .width(350.px)
        .height(32.px)
        .float(.left)
        .onFocus { tf in
            self.resultMermBox.innerHTML = ""
            tf.text = ""
        }
        .onBlur {
            Dispatch.asyncAfter(0.7) {
                self.resultMermBox.innerHTML = ""
            }
        }
        .onKeyUp { _, event in
            if ignoredKeys.contains(event.key) {
                return
            }
            self.searchMerm()
        }
        .onEnter {
            self.searchMerm()
        }
        
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                /*
                Div {
                    Img()
                        .src("/skyline/media/brightness.png")
                        .marginRight(3.px)
                        .marginLeft(3.px)
                        .marginTop(-3.px)
                        .height(16.px)
                    
                    Span("Nueva")
                }
                .marginRight(12.px)
                .marginTop(-5.px)
                .float(.right)
                .class(.uibtn)
                .onClick {
                    self.currentView = .selectStore
                }
                */
                
                Img()
                    .src("/skyline/media/addBlueIcon.png")
                    .marginRight(18.px)
                    .height(24.px)
                    .float(.right)
                    .onClick {
                        self.currentView = .selectStore
                    }
                
                Img()
                    .src("skyline/media/history_color.png")
                    .marginRight(18.px)
                    .marginLeft(18.px)
                    .cursor(.pointer)
                    .height(24.px)
                    .float(.right)
                    .onClick {
                        addToDom(ProductTransferReportView(reportType: .byStores))
                    }
                
                Div{
                    
                    Div{
                        
                        Div(self.$pullRequst.map{ $0.description })
                            .custom("width", "calc(100% - 45px)")
                            .class(.oneLineText)
                            .marginLeft(7.px)
                            .fontSize(22.px)
                            .float(.left)
                         
                         Div{
                             Img()
                                 .src(self.$selectPullTypeIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                 .class(.iconWhite)
                                 .paddingTop(7.px)
                                 .width(18.px)
                         }
                         .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                         .paddingRight(3.px)
                         .paddingLeft(7.px)
                         .marginLeft(7.px)
                         .float(.right)
                         .width(18.px)
                         .onClick { _, event in
                             self.selectPullTypeIsHidden = !self.selectPullTypeIsHidden
                             event.stopPropagation()
                         }
                         
                        Div().clear(.both)
                        
                    }
                    .marginRight(7.px)
                    .marginTop(-6.px)
                    .width(180.px)
                    .class(.uibtn)
                    .onClick { _, event in
                        self.loadTransfer()
                        event.stopPropagation()
                    }
                    
                    Div{
                        Div(PullRequest.current.description)
                            .width(95.percent)
                            .marginTop(7.px)
                            .class(.uibtn)
                            .onClick { _, event in
                                self.pullRequst = .current
                            }
                        
                        Div(PullRequest.historic.description)
                            .width(95.percent)
                            .marginTop(7.px)
                            .class(.uibtn)
                            .onClick { _, event in
                                self.pullRequst = .historic
                            }
                        
                    }
                    .hidden(self.$selectPullTypeIsHidden)
                    .backgroundColor(.transparentBlack)
                    .position(.absolute)
                    .borderRadius(12.px)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop(7.px)
                    .width(250.px)
                    .float(.right)
                    .zIndex(1)
                    .onClick { _, event in
                        event.stopPropagation()
                    }
                }
                .float(.right)
                
                H2("Ordenes de Transferencias")
                    .color(.lightBlueText)
                    .height(35.px)
                
            }
            
            Div{
                self.incomingTransfer
                self.outgoingTransfer
            }
            .hidden(self.$hasTransfers.map{ !$0 })
            .custom( "height", "calc(100% - 35px)")
            .borderRadius(7.px)
            .overflow(.auto)
            
            Div{
                Table()
                    .noResult(label: "No hay transferencias 🚀")
            }
            .custom( "height", "calc(100% - 35px)")
            .hidden(self.$hasTransfers)
            .borderRadius(7.px)
            
        }
        .hidden(self.$currentView.map{ $0 != .mainView })
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.currentView = .mainView
                    }
                
                Div("Mermar")
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(-7.px)
                    .float(.right)
                    .onClick {
                        self.currentView = .selectStoreToMerm
                    }
                
                H2("Selecione Tienda")
                    .color(.lightBlueText)
                    .height(35.px)
            }
            
            Div{
                Table{
                    Tr{
                        Td{
                            
                            Div("Iniciar Transferir")
                                .marginBottom(12.px)
                                .color(.goldenRod)
                                .fontSize(36.px)
                            
                            Div("Seleccione tienda destino.")
                                .marginBottom(12.px)
                                .color(.white)
                                .fontSize(28.px)
                            
                            self.storeSelect
                                .marginBottom(12.px)
                            
                            Div{
                                
                                Div("Iniciar Transferir")
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        
                                        guard let storeid = UUID(uuidString: self.storeSelect.value) else {
                                            print("No store selected (id)")
                                            return
                                        }
                                        
                                        guard let store = stores[storeid] else {
                                            print("No store selected (store)")
                                            return
                                        }
                                        
                                        self.kart.removeAll()
                                        
                                        self.selectedInventoryIDs.removeAll()
                                        
                                        self.itemGrid.innerHTML = ""
                                        
                                        self.itemGrid.appendChild(
                                            Tr {
                                                Td().width(50)
                                                Td("Marca").width(100)
                                                Td("Modelo / Nombre")
                                                //Td("Hubicación").width(200)
                                                Td("Units").width(50)
                                                Td("C. Uni").width(70)
                                                Td("S. Total").width(90)
                                            }
                                        )
                                        
                                        self.selectedStore = store
                                        
                                        self.currentView = .addInventory
                                        
                                        self.searchBox.select()
                                    }
                                
                                
                            }
                            .align(.right)
                        }
                        .verticalAlign(.middle)
                        .align(.center)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .custom("height", "calc(100% - 35px)")
            
        }
        .hidden(self.$currentView.map{ $0 != .selectStore })
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
        /// PROCESS TRANFER ITEM
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.currentView = .selectStore
                    }
                
                H2("Ingrese Inventario")
                    .float(.left)
                    .color(.lightBlueText)
                    .height(35.px)
                
                self.searchBox
                    .float(.left)
                
                Div().class(.clear)
            }
            
            self.resultBox
            
            Div().class(.clear)
            
            Div{
                self.itemGrid
            }
            .custom("height", "calc(100% - 75px)")
            Div{
                H2(self.$selectedStore.map{ $0?.name ?? "Seleccione tienda" })
                    .color(.white)
                    .float(.left)
                
                Div("Crear Transferencia")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.creatTransfer()
                    }
            }
            .align(.right)
        }
        .hidden(self.$currentView.map{ $0 != .addInventory })
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
        /// SELECT STORE TO MERM
        Div {
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.currentView = .mainView
                    }
                
                Div("Transferencia")
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(-7.px)
                    .float(.right)
                    .onClick {
                        self.currentView = .selectStore
                    }
                
                H2("Selecione Tienda")
                    .color(.lightBlueText)
                    .height(35.px)
            }
            
            Div{
                Table{
                    Tr{
                        Td{
                            
                            Div("Iniciar Merma")
                                .marginBottom(12.px)
                                .color(.goldenRod)
                                .fontSize(36.px)
                            
                            Div("Seleccione tienda iniciar")
                                .marginBottom(12.px)
                                .color(.white)
                                .fontSize(28.px)
                            
                            self.storeMermSelect
                                .marginBottom(12.px)
                            
                            Div{
                                
                                Div("Iniciar Mermar")
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        
                                        guard let storeid = UUID(uuidString: self.storeMermSelect.value) else {
                                            print("No store selected (id)")
                                            return
                                        }
                                        
                                        guard let store = stores[storeid] else {
                                            print("No store selected (store)")
                                            return
                                        }
                                        
                                        self.kart.removeAll()
                                        
                                        self.selectedInventoryIDs.removeAll()
                                        
                                        self.itemMermGrid.innerHTML = ""
                                        
                                        self.itemMermGrid.appendChild(
                                            Tr {
                                                Td().width(50)
                                                Td("Marca").width(100)
                                                Td("Modelo / Nombre")
                                                //Td("Hubicación").width(200)
                                                Td("Units").width(50)
                                                Td("C. Uni").width(70)
                                                Td("S. Total").width(90)
                                            }
                                        )
                                        
                                        self.selectedStore = store
                                        
                                        self.currentView = .mermInventory
                                        
                                        self.searchMermBox.select()
                                    }
                                
                            }
                            .align(.right)
                        }
                        .verticalAlign(.middle)
                        .align(.center)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .custom("height", "calc(100% - 35px)")
            
        }
        .hidden(self.$currentView.map{ $0 != .selectStoreToMerm })
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
        /// PROCESS MERM ITEM
        Div {
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.currentView = .selectStoreToMerm
                    }
                
                H2("Seleccione Inventario")
                    .float(.left)
                    .color(.lightBlueText)
                    .height(35.px)
                
                self.searchMermBox
                    .float(.left)
                
                Div().class(.clear)
            }
            
            self.resultMermBox
            
            Div().class(.clear)
            
            Div{
                self.itemMermGrid
            }
            .custom("height", "calc(100% - 75px)")
            Div{
                
                H2(self.$selectedStore.map{ $0?.name ?? "Seleccione tienda" })
                    .color(.white)
                    .float(.left)
                
                Div("Mermar Inevntario")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.creatMerm()
                    }
            }
            .align(.right)
        }
        .hidden(self.$currentView.map{ $0 != .mermInventory })
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 312px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(600.px)
        .width(700.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        onClick {
            self.selectPullTypeIsHidden = true
        }
        
        stores.forEach { id, store in
            
            storeMermSelect.appendChild(
                Option(store.name)
                    .value(id.uuidString)
            )
            
            if custCatchStore == id {
                return
            }
            
            storeSelect.appendChild(
                Option(store.name)
                    .value(id.uuidString)
            )
            
        }
        
        $pullRequst.listen {
            self.selectPullTypeIsHidden = true
            self.loadTransfer()
        }
        
        loadTransfer()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
 
    func search(){
         
         let term = searchTerm.purgeSpaces
         
         if term.count < 4 {
             self.resultBox.innerHTML = ""
             return
         }
         
         Dispatch.asyncAfter(0.5) {
             
             if term != self.searchTerm.purgeSpaces {
                 return
             }
             
             self.searchBox.class(.isLoading)
             
             searchPOC(term: term, costType: .cost_a, getCount: false) { _term, resp in
                 
                 self.searchBox.removeClass(.isLoading)

                 if term != _term {
                     return
                 }
                 
                 self.resultBox.innerHTML = ""
                 
                 resp.forEach { item in
                     
                     self.resultBox.appendChild(
                        
                        StoreItemPOCView(
                            searchTerm: _term,
                            poc: item,
                            callback: { _, _ in
                                self.confirmProductView(pocid: item.id)
                            }
                        )
                        
                     )
                 }
             }
         }
    }
    
       func searchMerm(){
            
            let term = searchMermTerm.purgeSpaces
            
            if term.count < 4 {
                self.resultMermBox.innerHTML = ""
                return
            }
            
            Dispatch.asyncAfter(0.5) {
                
                if term != self.searchMermTerm.purgeSpaces {
                    return
                }
                
                self.searchMermBox.class(.isLoading)
                
                searchPOC(term: term, costType: .cost_a, getCount: false) { _term, resp in
                    
                    self.searchBox.removeClass(.isLoading)

                    if term != _term {
                        return
                    }
                    
                    self.resultMermBox.innerHTML = ""
                    
                    resp.forEach { item in
                        
                        self.resultMermBox.appendChild(
                           
                           StoreItemPOCView(
                               searchTerm: _term,
                               poc: item,
                               callback: { _, _ in
                                   self.confirmProductView(pocid: item.id)
                               }
                           )
                           
                        )
                    }
                }
            }
       }
       
    func confirmProductView(
        pocid: UUID
    ){
        
        Console.clear()
        
        let uuid = ((self.currentView == .mermInventory) ? self.selectedStore?.id : custCatchStore)
        
        if let uuid {
            print(stores[uuid]?.name ?? "NO_STORE_LOCATED")
        }
        else {
            fatalError("🔴  NO_STORE_ID")
        }
        
        let _view = ConfirmProductView(
            accountId: nil, 
            costType: .cost_a,
            pocid: pocid,
            selectedInventoryIDs: self.selectedInventoryIDs,
            blockMultipleStores: true,
            blockPurchaseOrders: true,
            storeId: (self.currentView == .mermInventory) ? self.selectedStore?.id : custCatchStore,
            callback: { poc, price, costType, units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder, soldObjectFrom in
                
                /// ``Remeber NO PURCHASE ORDERS ARE SUPPORTED``
            
                let id = UUID()
                
                var series: [String] = []
                
                items.forEach { item in
                    if !item.series.isEmpty {
                        series.append(item.series)
                    }
                }
                
                let row = KartItemView(
                    id: id,
                    cost: price,
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
                        a: poc.avatar,
                        reqSeries: poc.reqSeries
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
                    
                } editManualCharge: { id, units, description, price, cost in
                    
                }
                    .color(.white)
                
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
                
                if self.currentView == .addInventory {
                    self.itemGrid.appendChild(row)
                    self.searchBox.select()
                }
                else {
                    self.itemMermGrid.appendChild(row)
                    self.searchMermBox.select()
                }
                
                
                
            }
        )
        
        self.appendChild(_view)
        
        _view.quantInput.select()
        
    }
    
    func creatTransfer(){
        
        if selectedInventoryIDs.isEmpty {
            self.searchBox.select()
            return
        }
        
        guard let selectedStore else {
            return
        }
        
        addToDom(ConfirmView(
            type: .ok,
            title: "Confirme Accion",
            message: "Confirme transferencia de mercancia.",
            callback: { isConfirmed, comment in
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.createInventoryTransfer(
                        fromStore: custCatchStore,
                        toStore: selectedStore.id,
                        items: self.selectedInventoryIDs
                    ) { resp in
                    
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.comunicationError, resp.msg)
                            return
                        }
                        
                        guard let payload = resp.data else {
                            showError(.unexpectedResult, "Obtuvo payload de data.")
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Orden de Transferencia \(payload.folio)")
                        
                        downLoadInventoryControlOrders(id: payload.id, detailed: true)
                        
                        self.currentView = .mainView
                        
                        self.selectedStore = nil
                        
                        self.searchTerm = ""
                        
                        self.kart = []
                        
                        self.selectedInventoryIDs = []
                        
                        self.itemGrid.innerHTML = ""
                        
                        self.itemGrid.appendChild(Table{
                            Tr {
                                Td().width(50)
                                Td("Marca").width(100)
                                Td("Modelo / Nombre")
                                //Td("Hubicación").width(200)
                                Td("Units").width(50)
                                Td("C. Uni").width(70)
                                Td("S. Total").width(90)
                            }
                        })
                     
                        if !self.hasTransfers {
                            
                            self.hasTransfers = true
                            
                            self.outgoingTransfer.appendChild(
                                H2("Salientes")
                                    .color(.yellowTC)
                                    .marginBottom(7.px)
                                    .marginTop(3.px)
                            )
                            
                        }
                        
                        let view = ProductTransferViewRow(item: payload, removed: { id in
                            
                        })
                        
                        self.outgoingTransfer.appendChild(view)
                        
                        view.click()
                        
                    }
                }
            })
        )
    }
    
    func creatMerm(){
        
        if selectedInventoryIDs.isEmpty {
            self.searchBox.select()
            return
        }
        
        guard let selectedStore else{
            return
        }
        
        addToDom(ConfirmationView(
            type: .acceptDeny,
            title: "Confirme Accion",
            message: "Confirme merma de mercancia.",
            comments: .required,
            callback: { isConfirmed, comment in
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.mermProductsInventory(
                        storeId: selectedStore.id,
                        items: self.selectedInventoryIDs,
                        reason: comment
                    ) { resp in
                    
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else {
                            showError(.comunicationError, resp.msg)
                            return
                        }
                        
                        guard let payload = resp.data else {
                            showError(.unexpectedResult, "Obtuvo payload de data.")
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Orden de Merma \(payload.folio)")
                        
                        downLoadInventoryControlOrders(id: payload.id, detailed: true)
                        
                        self.currentView = .mainView
                        
                        self.selectedStore = nil
                        
                        self.searchTerm = ""
                        
                        self.kart = []
                        
                        self.selectedInventoryIDs = []
                        
                        self.itemMermGrid.innerHTML = ""
                        
                        self.itemMermGrid.appendChild(Table{
                            Tr {
                                Td().width(50)
                                Td("Marca").width(100)
                                Td("Modelo / Nombre")
                                //Td("Hubicación").width(200)
                                Td("Units").width(50)
                                Td("C. Uni").width(70)
                                Td("S. Total").width(90)
                            }
                        })
                     
                        if !self.hasTransfers {
                            
                            self.hasTransfers = true
                            
                            self.outgoingTransfer.appendChild(
                                H2("Salientes")
                                    .color(.yellowTC)
                                    .marginBottom(7.px)
                                    .marginTop(3.px)
                            )
                            
                        }
                        
                        let view = ProductTransferViewRow(item: payload, removed: { id in
                            
                        })
                        
                        self.outgoingTransfer.appendChild(view)
                        
                        view.click()
                        
                    }
                }
            })
        )
    }
    
    func loadTransfer() {
        
        var type: API.custPOCV1.GetTransferOrdersType?
        
        switch pullRequst{
        case .current:
            type = .current(custCatchStore)
        case .historic:
            type = .historic(custCatchStore)
        }
        
        guard let type else {
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.getTransferOrders(
            type: type
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.comunicationError, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "Obtuvo payload de data.")
                return
            }
            
            self.hasTransfers = (!payload.incoming.isEmpty || !payload.outgoing.isEmpty)
            
            self.incomingTransfer.innerHTML = ""
            
            self.outgoingTransfer.innerHTML = ""
            
            if !payload.incoming.isEmpty {
                
                self.incomingTransfer.appendChild(
                    H2("Entrantes")
                        .color(.yellowTC)
                        .marginBottom(7.px)
                        .marginTop(3.px)
                )
                
                payload.incoming.forEach { item in
                    self.incomingTransfer.appendChild(ProductTransferViewRow(item: item, removed: { id in
                        
                    }))
                }
            }
            
            if !payload.outgoing.isEmpty {
                
                self.outgoingTransfer.appendChild(
                    H2("Salientes")
                        .color(.yellowTC)
                        .marginBottom(7.px)
                        .marginTop(3.px)
                )
                
                payload.outgoing.forEach { item in
                    self.outgoingTransfer.appendChild(ProductTransferViewRow(item: item, removed: { id in
                        
                    }))
                }
            }
        }
        
    }
}

extension ProductTransferView {

    enum PullRequest: String, CaseIterable {
        
        case current
        
        case historic
        
        var description: String{
            switch self {
            case .current:
                return "Actuales"
            case .historic:
                return "Historicos"
            }
        }
        
    }
    
    enum CurrentView: String, Codable, CaseIterable {
        
        // View and Outgoing/Incoming Tranfers
        case mainView
        
        /// Select store for tranfers
        case selectStore
        
        /// Add inventory for tranfer
        case addInventory
        
        /// Select store for tranfers
        case selectStoreToMerm
        
        
        /// Add inventory for tranfer
        case mermInventory
        
    }
}
