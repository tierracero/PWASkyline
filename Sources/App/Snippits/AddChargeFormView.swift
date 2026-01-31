//
//  AddChargeFormView.swift
//
//
//  Created by Victor Cantu on 7/2/22.
//

import Foundation
import TCFundamentals
import Web

class AddChargeFormView: Div {
    
    override class var name: String { "div" }

    let accountId: UUID?
    
    let allowManualCharges: Bool
    
    let allowWarrantyCharges: Bool
    
    let socCanLoadAction: Bool
    
    let currentSOCMasters: [UUID]
    
    /// cost_a, cost_b, cost_c
    let costType: CustAcctCostTypes
    
    private var addPoc: ((
        _ pocid: UUID,
        _ isWarenty: Bool,
        _ internalWarenty: Bool?
    ) -> ())
    
    private var addSoc: ((
        _ soc: ChargeObject,
        _ codeType: SOCCodeType,
        _ isWarenty: Bool,
        _ internalWarenty: Bool?
    ) -> ())

    private var addItem: ((
        _ item: SearchChargeResponse,
        _ warenty: SoldObjectWarenty?
    ) -> ())

    init(
        accountId: UUID?,
        allowManualCharges: Bool,
        allowWarrantyCharges: Bool,
        socCanLoadAction: Bool,
        /// cost_a, cost_b, cost_c
        costType: CustAcctCostTypes,
        currentSOCMasters: [UUID],
        addPoc: @escaping ((
            _ pocid: UUID,
            _ isWarenty: Bool,
            _ internalWarenty: Bool?
        ) -> ()),
        addSoc: @escaping ((
            _ soc: ChargeObject,
            _ codeType: SOCCodeType,
            _ isWarenty: Bool,
            _ internalWarenty: Bool?
        ) -> ()),
        addItem: @escaping ((
            _ item: SearchChargeResponse,
            _ warenty: SoldObjectWarenty?
        ) -> ())
    ) {
        self.accountId = accountId
        self.allowManualCharges = allowManualCharges
        self.allowWarrantyCharges = allowWarrantyCharges
        self.socCanLoadAction = socCanLoadAction
        self.costType = costType
        self.currentSOCMasters = currentSOCMasters
        self.addPoc = addPoc
        self.addSoc = addSoc
        self.addItem = addItem
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var canAutoLoad = true
    
    /// Last term that was serch. Used to avoid un necesary call back when input has not changed
    var lastSearchTerm = ""
    
    /// Term to search POC or SOC
    @State var searchTerm = ""
    /// Name of the charge
    @State var name = "Cargo General"
    /// Number of units
    @State var amount = "1"
    /// Price customer will be billed
    @State var price = "0.00"
    
    @State var pricea = "0.00"
    
    @State var priceb = "0.00"
    
    @State var pricec = "0.00"
    
    /// Add my cost view is visible
    @State var addInternalCostIsHidden: Bool = true
    /// My cost amount
    @State var costAmount = "0.00"
    
    @State var changePriceViewIsHidden: Bool = true
    
    @State var processAsWarenty: Bool = false
    
    @State var processAsInternalWarenty: Bool? = nil
    
    var fiscCode = ""
    
    var fiscUnit = ""
    
    var productionTime: Int64 = 0
    
    var codeType: SOCCodeType = .charge
    
    @State var actionItems: [CustSaleActionItem] = []
    
    var serviceAction: [CustSaleActionDecoder] = []
    
    @State var actionItemsRefrence: [UUID:CustSaleActionObjectConstructor] = [:]
    
    ///product, service, manual
    var chargeType: ChargeType = .manual
    
    /// the UUID If its a POC or SOC
    @State var chargeId: UUID? = nil
    
    @State var saleActions: UUID? = nil
    
    lazy var searchTermInput = InputText(self.$searchTerm)
        .placeholder("Modelo / SKU / SOC / POC")
        .width(95.percent)
        .class(.textFiledLightLarge)
        .fontSize(23.px)
        .disabled(self.$chargeId.map{ $0 != nil })
        .onFocus { tf in tf.select() }
        .onKeyUp { tf in
            self.search()
        }
    
    lazy var resultBox = Div()
        .position(.absolute)
    
    lazy var amountInput = InputText(self.$amount)
        .placeholder("Cantidad")
        .width(25.percent)
        .class(.textFiledLight)
        .fontSize(23.px)
        .disabled(self.$actionItems.map{ $0.count > 0 })
        .onFocus { tf in tf.select() }
    
    lazy var nameInput = InputText(self.$name)
        .placeholder("Description")
        .width(95.percent)
        .class(.textFiledLightLarge)
        .fontSize(23.px)
        .disabled(self.$chargeId.map{ $0 != nil })
        .onFocus { tf in tf.select() }
    
    lazy var salePriceInput = InputText(self.$price)
        .placeholder("0.00")
        .width(25.percent)
        .class(.textFiledLightLarge)
        .fontSize(23.px)
        .disabled(self.$chargeId.map{ $0 != nil })
        .onFocus { tf in tf.select() }
    
    lazy var costAmountInput = InputText(self.$costAmount)
        .placeholder("0.00")
        .width(25.percent)
        .class(.textFiledLightLarge)
        .fontSize(23.px)
        .disabled(self.$chargeId.map{ $0 != nil })
        .onFocus { tf in tf.select() }
    
    lazy var customeSalePriceInput = InputText()
        .onFocus { tf in tf.select() }
        .class(.textFiledLightLarge)
        .placeholder("0.00")
        .width(25.percent)
        .fontSize(23.px)
    
    lazy var actionView = Div{
        
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div {
                
                Img()
                    .closeButton( .uiView2)
                    .onClick {
                        self.remove()
                    }
                    .hidden( self.$actionItems.map{ ($0.count != 0) } )
                
                H2("Ingresar Cargo")
                    .color( .lightBlueText)
                
                Div().class( .clear)
                
                /// Modelo / SKU / SOC / POC
                Div{
                    Label("SKU / UPC")
                        .fontSize( 12.px)
                    Div {
                        self.searchTermInput
                    }
                }
                .class( .section)
                Div().class(.clear)
                
                self.resultBox
                    .zIndex(1)
                
                Div().class( .clear)
                
                /// Amount
                Div{
                    Label("Cantidad")
                        .fontSize( 12.px)
                    Div {
                        self.amountInput
                    }
                }
                .class( .section)
                Div().class( .clear)
                
                /// Description
                Div{
                    Label("Description")
                        .fontSize(12.px)
                    Div {
                        self.nameInput
                    }
                }
                .class(.section)
                Div().class(.clear)
                
                /// Sale Price
                Div{
                    Label("Precio")
                        .fontSize(12.px)
                    
                    Div {
                        
                        Span{
                            /// Add Internal cost
                            Div{
                                Img()
                                    .src("/skyline/media/add.png")
                                    .height(12.px)
                                    .marginRight(7.px)
                                
                                Span("Costo Interno")
                                    .fontSize(14.px)
                            }
                            .hidden(self.$addInternalCostIsHidden.map{ !$0 })
                            .custom("width", "fit-content")
                            .padding(all: 7.px)
                            .marginLeft(0.px)
                            .class(.uibutton)
                            .float(.right)
                            .onClick { _ in
                                self.addInternalCostIsHidden = false
                                self.costAmountInput.select()
                            }
                        }
                        .hidden(self.$chargeId.map { $0 != nil })
                        
                        Span{
                            ///
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
                        .hidden(self.$chargeId.map { $0 == nil })
                        .float(.right)
                        
                        self.salePriceInput
                        
                    }
                    
                }
                .class(.section)
                Div().class(.clear)
                
                /// `My Cost`
                Div{
                    Label("Costo Interno")
                        .fontSize(12.px)
                    Div {
                        
                        Img()
                            .src("/skyline/media/cross.png")
                            .height(18.px)
                            .margin(all: 3.px)
                            .cursor(.pointer)
                            .float(.right)
                            .onClick { _ in
                                showAlert(.alerta, "Costo interno removido")
                                self.costAmount = "0.00"
                                self.addInternalCostIsHidden = true
                            }
                        
                        self.costAmountInput
                    }
                }
                .class(.section)
                .hidden(self.$addInternalCostIsHidden)
                
                /// `Change Price`
                Div{
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
                                self.price = self.pricea
                            }
                        }
                        .class(.uibutton)
                    }
                    .class(.section)
                    
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
                                self.price = self.priceb
                            }
                            
                        }
                        .class(.uibutton)
                        
                    }
                    .class(.section)
                    
                    Div{
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
                                self.price = self.pricec
                            }
                        }
                        .class(.uibutton)
                        
                    }
                    .class(.section)
                    
                    /// Custome price
                    Div{
                        Label("Precio Personal")
                        
                        Div{
                            
                            self.customeSalePriceInput
                            
                            Span("Personalizado")
                            .class(.uibutton)
                            .float(.right)
                            .fontSize(18.px)
                            .onClick {
                                
                                guard let _price = Float(self.customeSalePriceInput.text.replace(from: ",", to: "") )?.toCents else {
                                    showError(.generalError, "Ingrese un precio  valido")
                                    self.customeSalePriceInput.select()
                                    return
                                }
                                
                                if custCatchHerk > 4 {
                                    
                                    self.changePriceViewIsHidden = true
                                    
                                    self.price = _price.formatMoney.replace(from: ",", to: "").replace(from: "$", to: "")
                                    
                                }
                                else {
                                    
                                    guard let socid = self.chargeId else {
                                        showError(.unexpectedResult, "No se localizo id del cargo.")
                                        return
                                    }
                                    
                                    addToDom(CustTaskAuthRequestWaitView(
                                        type: .service,
                                        id: socid,
                                        requestedPrice: _price,
                                        reason: "",
                                        callback: { auth in
                                            self.changePriceViewIsHidden = true
                                            if auth {
                                                self.price = _price.formatMoney.replace(from: ",", to: "").replace(from: "$", to: "")
                                            }
                                        })
                                    )
                                }
                            }
                        }
                    }
                    .class(.section)
                    
                }
                .hidden(self.$changePriceViewIsHidden.map{ $0 })
                
                Div().class(.clear)
                
                Div{
                    
                    if self.allowWarrantyCharges {
                        
                            Div{
                                
                                InputCheckbox()
                                    .toggle(self.$processAsWarenty)
                                    .marginRight(7.px)
                                    .float(.left)
                                
                                Div("Agregar Como Garantia")
                                    .color(self.$processAsWarenty.map{ $0 ? .black : .gray })
                                    .marginTop(3.px)
                                    .fontSize(22.px)
                                    .float(.left)
                                
                                Div().clear(.both)
                                
                                Div{
                                    
                                    InputRadio()
                                        .id(.init("internalWarenty"))
                                        .name("typeOfWarentie")
                                        .marginRight(7.px)
                                        .onClick { input in
                                            self.processAsInternalWarenty = true
                                        }
                                    
                                    Label("Garantia Interna")
                                        .for("internalWarenty")
                                        .marginRight(12.px)
                                    
                                    InputRadio()
                                        .id(.init("exteralWarenty"))
                                        .name("typeOfWarentie")
                                        .marginRight(7.px)
                                        .onClick { input in
                                            self.processAsInternalWarenty = false
                                        }
                                    
                                    Label("Garantia Externa")
                                        .for("exteralWarenty")
                                        
                                    
                                }
                                .hidden(self.$processAsWarenty.map{ !$0 })
                                 
                            }
                        .float(.left)
                    }
                    
                    Div {
                        Span()
                            .class(.ico)
                            .backgroundImage("images/shopping_basket.png")
                            .width(22.px)
                        
                        Span(" Agregar")
                            .fontSize(22.px)
                    }
                    .class(.uibutton)
                    .float(.right)
                    .onClick {
                        self.addChargeToOrder()
                    }
                }
                
                Div().class(.clear)
                
                
            }
            .class(self.$actionItems.map{ ($0.count == 0) ? .fullWidth : .oneHalf })
            .onClick {
                self.searchTerm = ""
                self.resultBox.innerHTML = ""
            }
            
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                self.actionView
            }
            .hidden(self.$actionItems.map{ ($0.count == 0) })
            .overflow(.auto)
            .class(.oneHalf)
            
        }
        .width(self.$actionItems.map{ ($0.count == 0) ? 40.percent : 80.percent })
        .left(self.$actionItems.map{ ($0.count == 0) ? 30.percent : 10.percent })
        .top(self.$actionItems.map{ ($0.count == 0) ? 35.percent : 15.percent })
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .maxHeight(70.percent)
        .position(.absolute)
        .padding(all: 12.px)
        .top(25.percent)
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
            self.searchTerm = ""
            self.resultBox.innerHTML = ""
        }
        
        $processAsWarenty.listen {
            if $0 {
                self.price = 0.formatMoney
            }
            else {
                self.processAsInternalWarenty = true
                self.price = self.pricea
            }
            
        }
        
        
    }
    
    func search(){
        
        let term = searchTerm.purgeSpaces
        
        Dispatch.asyncAfter(0.4) {
            
            if term != self.searchTerm.purgeSpaces {
                return
            }
            
            if term.count < 3 {
                if term.count == 0 {
                    self.resultBox.innerHTML = ""
                }
                return
            }
            
            if term == self.lastSearchTerm {
                return
            }
            // TODO: fix searchChargeCatch not to load  only linked  socs or remove it compleatly
            /*
            if let payload = searchChargeCatch[term] {
                print("💾 in catch")
                self.searchTermProcess(payload:payload)
                return
            }
            */
            self.searchTermInput.class(.isLoading)
            
            searchCharge(
                term: term,
                costType: self.costType,
                currentCodeIds: self.currentSOCMasters,
                accountId: self.accountId
            ) { term, resp in
                self.searchTermInput.removeClass(.isLoading)
                //searchChargeCatch[term] = resp
                self.searchTermProcess(payload: resp)
            }
        }
        
    }
    
    func searchTermProcess(payload: [SearchChargeResponse]){
        
        resultBox.innerHTML = ""
        
        if WebApp.shared.window.location.hostname == "localhost"  {
            print("🟢 payload ")
            print(payload.count)
            payload.forEach { item in
                print(item)
            }
        }

        if payload.count == 1, canAutoLoad {
            
            guard let charge = payload.first else {
                return
            }
            
            if self.processAsWarenty {
                guard let _ = self.processAsInternalWarenty else {
                    showError(.requiredField, "Seleccione el tipo de garantia")
                    return
                }
            }
            
            switch charge.t {
            case .product:
                self.addPoc(charge.i, self.processAsWarenty, self.processAsInternalWarenty)
                self.remove()
            case .service:
                self.loadSOC(soc: charge)
            case .manual:
                break
            case .rental:
                break
            case .inventory:
                
                var warenty: SoldObjectWarenty? = nil

                if self.processAsWarenty, let processAsInternalWarenty = self.processAsInternalWarenty {
                    warenty = processAsInternalWarenty ? .internal : .external
                }

                self.addItem(charge, warenty)

                self.remove()
                
            }

            canAutoLoad = false
           
            return

        }
        
        payload.forEach { data in
            
            resultBox.appendChild(
                
                SearchChargeView(data: data, costType: self.costType, callback: { charge in
                    
                    if self.processAsWarenty {
                        guard let _ = self.processAsInternalWarenty else {
                            showError(.requiredField, "Seleccione el tipo de garantia")
                            return
                        }
                    }
                    
                    /// We will load proper view depending if its a service or a product.
                    switch charge.t {
                    case .product:
                        self.addPoc(charge.i, self.processAsWarenty, self.processAsInternalWarenty)
                        self.remove()
                    case .service:
                        self.loadSOC(soc: charge)
                    case .manual:
                        break
                    case .rental:
                        break
                    case .inventory:
                        break
                    }
                    
                })
            )
        }
    }
    
    func loadSOC(soc: SearchChargeResponse){
        
        do {
            let data = try JSONEncoder().encode(soc)
            if let str = String(data: data, encoding: .utf8){
                print(str)
            }
        } catch  {}
        
        
        self.searchTerm = ""
        
        self.resultBox.innerHTML = ""
        
        self.addInternalCostIsHidden = true
        
        loadingView(show: true)
        
        self.chargeType = .service
        self.chargeId = soc.i
        self.name = soc.n
        self.price = soc.p.formatMoney
        
        API.custAPIV1.loadServiceActionItems(
            id: soc.i
        ) { resp in
            
            do {
                let data = try JSONEncoder().encode(resp)
                if let str = String(data: data, encoding: .utf8){
                    print(str)
                }
                
            } catch  {}
        
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let soc = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.fiscCode = soc.fiscCode
            
            self.fiscUnit = soc.fiscUnit
            
            self.productionTime = soc.productionTime
            
            self.codeType = soc.codeType
            
            self.pricea = soc.pricea.formatMoney
            
            self.priceb = soc.priceb.formatMoney
            
            self.pricec = soc.pricec.formatMoney
            
            self.costAmount = soc.cost.formatMoney
            
            if self.socCanLoadAction {
                
                guard soc.saleAction.count > 0 else{
                    self.amountInput.select()
                    return
                }
                    
                /**
                 
                 @State var actionItems: [CustSaleActionItem] = []
                 
                 var serviceAction: [CustSaleActionDecoder] = []
                 */
                
                self.actionItems = soc.saleAction

                self.serviceAction = soc.serviceAction
                
                self.actionItems.forEach { item in
                    
                    let action = CustSaleActionObjectConstructor(
                        custSaleAction: item.id,
                        name: item.name,
                        productionTime: item.productionTime,
                        workforceLevel: item.workforceLevel,
                        productionLevel: item.productionLevel,
                        objects: item.objects.map{
                            .init(
                                id: $0.id,
                                type: $0.type,
                                title: $0.title,
                                help: $0.help,
                                placeholder: $0.placeholder,
                                value: "",
                                options: $0.options,
                                isRequired: $0.isRequired,
                                customerMessage: $0.customerMessage
                            )
                        }
                    )
                    
                    self.actionItemsRefrence[action.id] = action
                    
                    self.actionView.appendChild(ActionItemView(
                        constructoreid: action.id,
                        item: item,
                        callback: { constructor in
                            self.actionItemsRefrence[constructor.id] = constructor
                            
                            print(self.actionItemsRefrence)
                            
                        })
                    )
                }
            }
            
        }
    }
    
    func addChargeToOrder() {
        // CustOrderCreateCharges actionItemsRefrence
        
        if !allowManualCharges {
            guard let _ = chargeId else {
                showAlert(.alerta, "Seleccione producto o servicio.")
                return
            }
        }
        
        
        if processAsWarenty {
            guard let _ = processAsInternalWarenty else {
                showError(.requiredField, "Seleccione el tipo de garantia")
                return
            }
        }
        
        var actionRequieredIsEmpty = false
        
        self.actionItemsRefrence.forEach { id, action in
            
            action.objects.forEach { object in
                if object.isRequired && object.value.isEmpty {
                    showError(.requiredField, .requierdValid("\(action.name): \(object.title)"))
                    actionRequieredIsEmpty = true
                }
            }
        }
        
        if actionRequieredIsEmpty {
            return
        }
        
        guard var amountFloat = Float(self.amount.replace(from: ",", to: "")) else {
            showError(.generalError, "Ingrese una cantidad valida")
            return
        }
        
        guard let priceFloat = Float(self.price.replace(from: ",", to: "")) else {
            showError(.generalError, "Ingrese una precio valida")
            return
        }
        
        let costFloat = Float(self.costAmount.replace(from: ",", to: ""))
        
        if self.codeType == .adjustment{
            amountFloat = 1
        }
        
        //codeType
        self.addSoc(
            .init(
                refid: .init(),
                id: chargeId,
                fiscCode: self.fiscCode,
                fiscUnit: self.fiscUnit,
                code: "",
                units: amountFloat.toCents,
                price: priceFloat.toCents,
                description: self.name,
                type: self.chargeType,
                cost: Float(costFloat ?? 0).toCents,
                productionTime: self.productionTime,
                ids: [],
                saleAction: self.actionItemsRefrence.map{ $1 },
                serviceAction: self.serviceAction,
                isWarenty: self.processAsWarenty,
                internalWarenty: self.processAsInternalWarenty,
                generateRepositionOrder: nil
            ),
            self.codeType,
            self.processAsWarenty,
            self.processAsInternalWarenty
        )
        
        
        self.remove()
        
    }
    
}
