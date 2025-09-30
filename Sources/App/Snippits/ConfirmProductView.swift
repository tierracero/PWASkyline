//
//  ConfirmProductView.swift
//
//
//  Created by Victor Cantu on 2/20/22.
//

import Foundation
import TCFundamentals
import Web

class ConfirmProductView: Div {
    
    override class var name: String { "div" }
    
    let accountId: UUID?
    
    let costType: CustAcctCostTypes
    
    let pocid: UUID
    
    let selectedInventoryIDs: [UUID]
    
    let blockMultipleStores: Bool
    
    let blockPurchaseOrders: Bool
    
    let isWarenty: Bool
    
    let internalWarenty: Bool?
    
    @State var storeid: UUID
    
    private var callback: ((
        /// POC Data
        _ poc: CustPOC,
        _ cost: Int64,
        _ costType: CustAcctCostTypes,
        _ units: Int64,
        _ items: [CustPOCInventoryMin],
        _ storeid: UUID,
        _ isWarenty: Bool,
        _ internalWarenty: Bool?,
        _ generateRepositionOrder: Bool?
    ) -> ())
    
    init(
        accountId: UUID?,
        costType: CustAcctCostTypes,
        pocid: UUID,
        selectedInventoryIDs: [UUID],
        blockMultipleStores: Bool = false,
        blockPurchaseOrders: Bool = false,
        isWarenty: Bool = false,
        internalWarenty: Bool? = nil,
        storeId: UUID? = nil,
        callback: @escaping ((
            _ poc: CustPOC,
            _ cost: Int64,
            _ costType: CustAcctCostTypes,
            _ units: Int64,
            _ items: [CustPOCInventoryMin],
            _ storeid: UUID,
            _ isWarenty: Bool,
            _ internalWarenty: Bool?,
            _ generateRepositionOrder: Bool?
        ) -> ())
    ) {
        self.accountId = accountId
        self.costType = costType
        self.pocid = pocid
        self.selectedInventoryIDs = selectedInventoryIDs
        self.callback = callback
        self.blockMultipleStores = blockMultipleStores
        self.blockPurchaseOrders = blockPurchaseOrders
        self.isWarenty = isWarenty
        self.internalWarenty = internalWarenty
        self.storeid = storeId ?? custCatchStore
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var generateRepositionOrder: Bool = false
    
    @State var storeIdSelectListener = ""
    
    @State var changePriceViewIsHidden: Bool = true
    
    @State var price = "0.00"
    
    @State var pricea = "0.00"
    
    @State var priceb = "0.00"
    
    @State var pricec = "0.00"
    
    @State var customePrice = "0"
    
    @State var name = ""
    
    @State var upc = ""
    
    @State var brand = ""
    
    @State var model = ""
    
    @State var cost: Int64 = 0
    
    @State var cuant = "1"
    
    @State var pocDescr = ""
    
    @State var pocTotalInventory = "0"
    
    @State var quantFieldIsDisabeld = false
    
    @State var poc: CustPOC? = nil
    
    var inventory: [CustStoreProductInventorySale] = []
    
    var inConcession: [CustPOCConcessionInventoryID] = []
    
    var img = Img()
        .objectFit(.cover)
        .src("images/tc-logo-512x512.png")
        .width(100.percent)
        .height(100.percent)
    
    lazy var quantInput = InputNumber(self.$cuant)
        .custom("patern", "[0-9]*")
        .class(.textFiledLight)
        .textAlign(.center)
        .marginRight(12.px)
        .marginLeft(12.px)
        .height(36.px)
        .width(70.px)
        .onKeyUp { input, event in
            if event.key == "Enter" {
                self.addToKart()
            }
        }
        .disabled(self.$quantFieldIsDisabeld)
    
    lazy var inventoryGrid = Div {
        Table{
            Tr{
                Td("No hay inventario")
                .align(.center)
                .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
    .padding(all: 3.px)
    .margin(all: 3.px)
    .class(.roundBlue)
    .overflow(.auto)
    .height(200.px)
    
    lazy var storeSelect = Select(self.$storeIdSelectListener)
        .custom("width","calc(100% - 132px)")
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .float(.right)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick {
                        self.remove()
                    }
                
                H2("Agregar Producto")
                    .color(.lightBlueText)
                    .marginRight(7.px)
                    .marginLeft(7.px)
                    .float(.left)
                
                if self.isWarenty {
                    Div{
                        
                        Img()
                            .src("/skyline/media/icons_alert.png")
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Span("Se esta agragando como garantia")
                            .fontSize(24.px)
                            .color(.red)
                    }
                    .float(.left)
                }
                
                Div().class(.clear)
            }
            
            
            
            Div().class(.clear)
            
            /// Productr Image
            Div{
                Div{
                    self.img
                }
                .margin(all: 12.px)
                .overflow(.hidden)
                .class(.roundGray)
                .height(250.px)
            }
            .class(.oneThird)
            
            /// Inventory selection
            Div{
                Div("Description")
                .color(.lightBlueText)
                .fontSize(24.px)
                
                Span(self.$pocDescr)
                    .fontSize(18.px)
                
                Div().class(.clear)
                
                /*
                H2{
                    
                    
                    Span("Inventario Total")
                        .color(.lightBlueText)
                        .fontSize(23.px)
                        
                }
                .color(.lightBlueText)
                */
                Div{
                    
                    InputText(self.$pocTotalInventory)
                        .class(.textFiledLight)
                        .marginRight(7.px)
                        .textAlign(.right)
                        .disabled(true)
                        .width(100.px)
                        .height(28.px)
                        .float(.right)
                    
                    self.storeSelect
                    
                    Div().class(.clear)
                    
                }
                
                
                self.inventoryGrid
                
            }
            .class(.oneThird)
            
            /// Product detail / Units
            Div{
                
                H2(self.$name)
                    .hidden(self.$name.map{ $0.isEmpty })
                
                // SOC
                Div{
                    Label("UPC / SOC / SKU")
                    Div{
                        InputText(self.$upc)
                            .height(23.px)
                            .class(.textFiledLight)
                            .textAlign(.right)
                            .disabled(true)
                    }
                }
                .class(.section)
                Div().class(.clear)
                
                // marca
                Div{
                    Label("Marca")
                    Div{
                        InputText(self.$brand)
                            .height(23.px)
                            .class(.textFiledLight)
                            .textAlign(.right)
                            .disabled(true)
                    }
                }
                .class(.section)
                Div().class(.clear)
                
                // Model
                Div{
                    Label("Modelo")
                    Div{
                        InputText(self.$model)
                            .height(23.px)
                            .class(.textFiledLight)
                            .textAlign(.right)
                            .disabled(true)
                    }
                }
                .class(.section)
                Div().class(.clear)
                
                // Cost
                Div{
                    Label("Costo")
                    Div{
                        
                        InputText(self.$cost.map{  $0.formatMoney })
                            .height(23.px)
                            .class(.textFiledLight)
                            .textAlign(.right)
                            .disabled(true)
                    }
                }
                .class(.section)
                
                /// `Change Price`
                if custCatchHerk > 1 {
                    
                    Div{
                        /// Precio Public
                        Div{
                            Label("Precio Public")
                            Div{
                                Div{
                                    Span("$")
                                        .marginRight(7.px)
                                    Span(self.$pricea)
                                }
                                .custom("width", "fit-content")
                                .paddingRight(7.px)
                                .paddingLeft(7.px)
                                .margin(all: 0.px)
                                .fontSize(23.px)
                                .onClick {
                                    self.changePriceViewIsHidden = true
                                    
                                    if let _cost = Float(self.pricea.replace(from: ",", to: ""))?.toCents  {
                                        self.cost = _cost
                                    }
                                        
                                }
                            }
                            .class(.uibutton)
                        }
                        .class(.section)
                        
                        /// Medio Mayoreo
                        Div{
                            Label("Medio Mayoreo")
                            
                            Div{
                                Div{
                                    Span("$")
                                        .marginRight(7.px)
                                    Span(self.$priceb)
                                }
                                .custom("width", "fit-content")
                                .paddingRight(7.px)
                                .paddingLeft(7.px)
                                .margin(all: 0.px)
                                .fontSize(23.px)
                                .onClick {
                                    self.changePriceViewIsHidden = true
                                    
                                    if let _cost = Float(self.priceb.replace(from: ",", to: ""))?.toCents  {
                                        self.cost = _cost
                                    }
                                }
                                
                            }
                            .class(.uibutton)
                            
                        }
                        .class(.section)
                        
                        Div().class(.clear)
                        
                        /// Precio Mayoreo
                        Div {
                            
                            Label("Precio Mayoreo")
                            
                            Div{
                                Div{
                                    Span("$")
                                        .marginRight(7.px)
                                    Span(self.$pricec)
                                }
                                .custom("width", "fit-content")
                                .paddingRight(7.px)
                                .paddingLeft(7.px)
                                .margin(all: 0.px)
                                .fontSize(23.px)
                                .onClick {
                                    self.changePriceViewIsHidden = true
                                    
                                    if let _cost = Float(self.pricec.replace(from: ",", to: ""))?.toCents  {
                                        self.cost = _cost
                                    }
                                }
                            }
                            .class(.uibutton)
                            
                        }
                        .class(.section)
                        
                        Div {
                            
                            Label("Personalizado")
                            
                            Div{
                                
                                InputText(self.$customePrice)
                                    .class(.textFiledLight)
                                    .marginRight(3.px)
                                    .width(100.px)
                                    .onKeyDown({ tf, event in
                                        guard let _ = Float(event.key) else {
                                            if !ignoredKeys.contains(event.key) {
                                                event.preventDefault()
                                            }
                                            return
                                        }
                                    })
                                    .onFocus { tf in
                                        tf.select()
                                    }
                            }
                            
                            Div{
                                
                                Span(" Agregar ")
                                .custom("width", "fit-content")
                                .paddingRight(7.px)
                                .paddingLeft(7.px)
                                .margin(all: 0.px)
                                .class(.uibutton)
                                .fontSize(18.px)
                                .onClick {
                                    
                                    if let _cost = Float(self.customePrice)?.toCents  {
                                        
                                        if custCatchHerk > 4 {
                                            
                                            self.changePriceViewIsHidden = true
                                            
                                            self.cost = _cost
                                            
                                        }
                                        else {
                                            
                                            addToDom(CustTaskAuthRequestWaitView(
                                                type: .product,
                                                id: self.pocid,
                                                requestedPrice: _cost,
                                                reason: "",
                                                callback: { auth in
                                                    
                                                    self.changePriceViewIsHidden = true
                                                    
                                                    if auth {
                                                        self.cost = _cost
                                                    }
                                                    
                                                })
                                            )
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        .class(.section)
                        
                        
                    }
                    .hidden(self.$changePriceViewIsHidden.map{ $0 })
                    
                }
                
                Div().class(.clear)
                
                Div{
                    
                    if custCatchHerk > 1 {
                        Span{
                            
                            Div{
                                Img()
                                    .src("/skyline/media/random.png")
                                    .height(12.px)
                                    .marginRight(7.px)
                                
                                Span("C.P.")
                                    .fontSize(14.px)
                            }
                            .custom("width", "fit-content")
                            .padding(all: 7.px)
                            .marginLeft(0.px)
                            .class(.uibutton)
                            .float(.right)
                            .hidden(self.$changePriceViewIsHidden.map{ !$0 })
                            .onClick { _ in
                                self.changePriceViewIsHidden = false
                            }
                        }
                        .hidden(self.$changePriceViewIsHidden.map{ !$0 })
                        .float(.left)
                    }
                    
                    Div{
                        
                        /// Delete Button
                        Div {
                            Span()
                                .class(.ico)
                                .backgroundImage("images/delete.png")
                                .width(18.px)
                        }
                        .marginRight(12.px)
                        .class(.uibutton)
                        .float(.right)
                        .onClick {
                            if let cuant = Int(self.cuant) {
                                if cuant > 1 {
                                    self.cuant = String(cuant - 1)
                                }
                            }
                        }
                        
                        /// Cuant
                        self.quantInput
                            .float(.right)
                        
                        /// Add Icon
                        Div {
                            Span()
                                .class(.ico)
                                .backgroundImage("images/add.png")
                                .width(18.px)
                        }
                        .class(.uibutton)
                        .float(.right)
                        .onClick {
                            if let cuant = Int(self.cuant) {
                                self.cuant = String(cuant + 1)
                            }
                        }
                        
                    }
                    .hidden(self.$changePriceViewIsHidden.map{ !$0 })
                    
                    Div().class(.clear)
                    
                }
                .align(.right)
                
            }
            .class(.oneThird)
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                if self.isWarenty && (self.internalWarenty == false) {
                    
                    Div {
                        InputCheckbox()
                            .toggle(self.$generateRepositionOrder)
                            .marginRight(7.px)
                        
                        Div("Generar Orden de Repuesto")
                            .color(self.$generateRepositionOrder.map{ $0 ? .black : .gray })
                            .marginTop(1.px)
                            .fontSize(24.px)
                            .float(.left)
                        
                    }
                    .float(.left)
                    
                }
                
                Div(" Agregar ")
                    .hidden(self.$changePriceViewIsHidden.map{ !$0 })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addToKart()
                    }
            }
            .align(.right)
            
            
        }
        .padding(all: 3.px)
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .width(80.percent)
        .left(10.percent)
        //.height(70.percent)
        //.top(15.percent)
        .top(20.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        width(100.percent)
        position(.fixed)
        left(0.px)
        top(0.px)
        
        $storeIdSelectListener.listen {
            
            if $0 == "concession" {
                self.cost = 0
            }
            else {
                self.cost = self.poc?.pricea ?? 0
            }
            
            self.loadStore()
            
        }
        
        loadingView(show: true)
        
        API.custAPIV1.storeProductSale(
            pocId: self.pocid,
            accountId: self.accountId
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorGeneral, "No se pudo obtener respuesta del servidor intente de nuevo. Si el problema persiste contacte a Soporte TC")
                self.remove()
                return
            }
            
            guard let payload = resp.data else {
                showError(.errorGeneral, "No se pudo obtener POC del servidor intente de nuevo. Si el problema persiste contacte a Soporte TC")
                self.remove()
                return
            }
            
            if resp.status != .ok {
                showError(.errorGeneral, resp.msg)
                self.remove()
                return
            }
            
            let poc = payload.poc
            
            let inventory = payload.inventory
            
            let inConcession = payload.inConcession
            
            self.poc = poc
            
            self.upc = poc.upc
            
            self.name = poc.name
            
            self.brand = poc.brand
            
            self.model = poc.model
            
            if !poc.smallDescription.isEmpty {
                self.pocDescr = poc.smallDescription
            }
            else {
                self.pocDescr = poc.description
            }
            
            if self.isWarenty {
                
                self.cost = 0
                
            }
            else {
                
                switch self.costType {
                case .cost_a:
                    self.cost = poc.pricea
                case .cost_b:
                    self.cost = poc.priceb
                case .cost_c:
                    self.cost = poc.pricec
                }
                
            }
            
            self.pricea = poc.pricea.formatMoney
            
            self.priceb = poc.priceb.formatMoney
            
            self.pricec = poc.pricec.formatMoney
            
            self.customePrice = poc.pricec.formatMoney
            
            if !poc.avatar.isEmpty {
                if let pDir = customerServiceProfile?.account.pDir {
                    self.img.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.avatar)")
                }
            }
            
            if poc.reqSeries {
                self.cuant = "1"
                self.quantFieldIsDisabeld = true
            }
            
            self.inventory = inventory
            
            self.inConcession = inConcession
            
            inventory.forEach { storeInventory in
                
                guard let store = storeInventory.store else {
                    return
                }
                
                self.storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }
            
            if !payload.inConcession.isEmpty {
                self.storeSelect.appendChild(
                    Option("En Concession")
                        .value("concession")
                )
                self.storeIdSelectListener = "concession"
            }
            else {
                self.storeIdSelectListener = self.storeid.uuidString
            }
            
        }
    }
    
    func addToKart(){
        
        quantFieldIsDisabeld = true

        guard let cuant = Int(self.cuant) else {
            quantFieldIsDisabeld = false
            quantInput.select()
            showError(.campoInvalido, "Ingrese una cantidad valida")
            return
        }
        
        guard let poc else {
            quantFieldIsDisabeld = false
            showError(.errorGeneral, "No se pudo cargar POC, refresque e intente de nuevo.")
            return
        }
        
        var _cuant = cuant
        
        var items: [CustPOCInventoryMin] = []
        
        if storeIdSelectListener == "concession" {
            
            inConcession.forEach { item in
                if !selectedInventoryIDs.contains(item.id) {
                    if _cuant > 0 {
                        
                        items.append(.init(
                            id: item.id,
                            custStoreBodegas: item.custStoreBodegas,
                            custStoreSecciones: item.custStoreSecciones,
                            series: item.series
                        ))
                        
                        _cuant -= 1
                        
                    }
                }
            }
            
        }
        else {
            
            guard let storeId = UUID(uuidString: storeIdSelectListener) else {
                quantFieldIsDisabeld = false
                showError(.errorGeneral, "Seleccione tienda valida")
                return
            }

            var selectedInventorie: CustStoreProductInventorySale? = nil
            
            inventory.forEach { currentInventorie in
                if storeId == currentInventorie.store?.id {
                    selectedInventorie = currentInventorie
                }
            }
            
            guard let selectedInventorie else {
                quantFieldIsDisabeld = false
                showError(.errorGeneral, "No se encontro inventario, agregue inventario e intente de nuevo.")
                return
            }

            selectedInventorie.inventory.forEach { obj in
                if !selectedInventoryIDs.contains(obj.id) {
                    if _cuant > 0 {
                        items.append(obj)
                        _cuant -= 1
                    }
                }
            }
            
        }
        
        print("items.count \(items.count)")
        
        print("cuant \(cuant)")
        
        if (items.count < cuant){
            
            if blockPurchaseOrders {
                showError(.errorGeneral, "No tiene inventario suficiente.")
                return
            }
        
            if storeIdSelectListener == "concession" {
                showError(.errorGeneral, "No se pueden generar Ordenes de Compra de la bodegade concesión. Seleccione un producto del inventario general y seleccion \"Generar Orden de Repuesto\"")
                return
            }
            
            addToDom(LowInventoryView(generatePurchaseOrder: {
                self.callback(
                    poc,
                    self.cost,
                    self.costType,
                    Int64(cuant * 100),
                    items,
                    ( UUID(uuidString: self.storeIdSelectListener) ?? custCatchStore ),
                    self.isWarenty,
                    self.internalWarenty,
                    self.generateRepositionOrder
                )
                self.remove()
            }))
            
            return
        }
        
        self.callback(
            poc,
            cost,
            costType,
            Int64(cuant * 100),
            items,
            storeid,
            isWarenty,
            internalWarenty,
            generateRepositionOrder
        )
        
        self.remove()
        
    }
    
    func loadStore(){
        
        if storeIdSelectListener == "concession" {
            
            self.inventoryGrid.innerHTML = ""
            
            var count = 0
            
            inConcession.forEach { sobj in
                
                if !self.selectedInventoryIDs.contains(sobj.id) {
                    
                    count += 1
                    
                    var bod = ""
                    var sec = ""
                    
                    if let id = sobj.custStoreBodegas {
                        if let _bod = bodegas[id] {
                            bod = _bod.name
                        }
                    }
                    
                    if let id = sobj.custStoreSecciones {
                        if let _sec = seccions[id] {
                            sec = _sec.name
                        }
                    }
                    
                    self.inventoryGrid.appendChild(
                        Div{
                            Span("\(bod)/\(sec)")
                                .float(.right)
                            Div().class(.clear)
                        }
                        .class(.smallButtonBox)
                    )
                }
            }
            
            self.pocTotalInventory = String(count)
        }
        else {
            
            guard let storeId = UUID(uuidString: storeIdSelectListener) else {
                showError(.errorGeneral, "Seleccione tienda valida")
                quantFieldIsDisabeld = false
                return
            }
            
            var selectedInventory: CustStoreProductInventorySale? = nil
            
            inventory.forEach { storeInventory in
                if storeInventory.store?.id == storeId {
                    selectedInventory = storeInventory
                }
            }
            
            guard let selectedInventory else {
                return
            }
            
            self.inventoryGrid.innerHTML = ""
            
            var count = 0
            
            selectedInventory.inventory.forEach { sobj in
                
                if !self.selectedInventoryIDs.contains(sobj.id) {
                    
                    count += 1
                    
                    var bod = ""
                    var sec = ""
                    
                    if let id = sobj.custStoreBodegas {
                        if let _bod = bodegas[id] {
                            bod = _bod.name
                        }
                    }
                    
                    if let id = sobj.custStoreSecciones {
                        if let _sec = seccions[id] {
                            sec = _sec.name
                        }
                    }
                    
                    self.inventoryGrid.appendChild(
                        Div{
                            Span("\(bod)/\(sec)")
                                .float(.right)
                            Div().class(.clear)
                        }
                        .class(.smallButtonBox)
                    )
                }
            }
            
            self.pocTotalInventory = String(count)
            
            
        }
        
    }
    
}
