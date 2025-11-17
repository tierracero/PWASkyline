//
//  BudgetSOCView.swift
//  
//
//  Created by Victor Cantu on 10/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class BudgetSOCView: Div {
    
    override class var name: String { "div" }
    
    let loadSocDetails: Bool
    
    let soc: SearchChargeResponse

    /// cost_a, cost_b, cost_c
    let costType: CustAcctCostTypes

    private var addSoc: ((
      _ soc: ChargeObject
    ) -> ())

    init(
        loadSocDetails: Bool,
        /// cost_a, cost_b, cost_c
        soc: SearchChargeResponse,
        costType: CustAcctCostTypes,
        addSoc: @escaping ((
          _ soc: ChargeObject
        ) -> ())
    ) {
        self.loadSocDetails = loadSocDetails
        self.soc = soc
        self.costType = costType
        self.addSoc = addSoc
    }

    required init() {
      fatalError("init() has not been implemented")
    }
    
    var canAutoLoad = true
    
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
    
    @State var customePrice = "0"
    
    /// Add my cost view is visible
    @State var addInternalCostIsHidden: Bool = true
    /// My cost amount
    @State var costAmount = "0.00"
    
    @State var changePriceViewIsHidden: Bool = true
    
    var fiscCode = ""
    
    var fiscUnit = ""
    
    var productionTime: Int64 = 0
    
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
        .class(.textFiledLightLarge)
        .placeholder("0.00")
        .width(25.percent)
        .fontSize(23.px)
        .disabled(self.$chargeId.map{ $0 != nil })
        .onFocus { tf in tf.select() }
    
    lazy var actionView = Div{
        
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                    .hidden(self.$actionItems.map{ ($0.count != 0) })
                
                H2("Ingresar Presupuesto")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
                /// Modelo / SKU / SOC / POC
                Div{
                    Label("SKU / UPC")
                        .fontSize(12.px)
                    Div {
                        self.searchTermInput
                    }
                }
                .class(.section)
                
                Div().class(.clear)
                
                /// Amount
                Div{
                    Label("Cantidad")
                        .fontSize(12.px)
                    Div {
                        self.amountInput
                    }
                }
                .class(.section)
                Div().class(.clear)
                
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
                        
                        if custCatchHerk > 1 {
                            
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
                            
                        }
                        
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
                            
                            Span(" Agregar ")
                            .custom("width", "fit-content")
                            .paddingRight(7.px)
                            .paddingLeft(7.px)
                            .margin(all: 0.px)
                            .class(.uibutton)
                            .fontSize(18.px)
                            .onClick {
                                
                                self.changePriceViewIsHidden = true
                                
                                guard let _price = Float(self.customePrice)?.toCents else {
                                    showError(.errorGeneral, "Ingrese un precio  valido")
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
                    Div {
                        Span()
                            .class(.ico)
                            .backgroundImage("images/shopping_basket.png")
                            .width(22.px)
                        Span(" Agregar")
                            .fontSize(22.px)
                    }
                    .class(.uibutton)
                    .onClick {
                        self.addChargeToOrder()
                    }
                }
                .align(.right)
                
                Div().class(.clear)
                
                
            }
            .class(self.$actionItems.map{ ($0.count == 0) ? .fullWidth : .oneHalf })
            
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
        .overflow(.auto)
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
        
        loadSOC(soc: soc)
        
    }
    
    func loadSOC(soc: SearchChargeResponse){
        
        do {
            let data = try JSONEncoder().encode(soc)
            if let str = String(data: data, encoding: .utf8){
                print(str)
            }
        } catch  {}
        
        self.addInternalCostIsHidden = true
        
        self.chargeType = .service
        self.searchTerm = soc.u
        self.chargeId = soc.i
        self.name = soc.n
        self.price = soc.p.formatMoney
        
        loadingView(show: true)
        
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
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }

            guard let soc = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.fiscCode = soc.fiscCode
            
            self.fiscUnit = soc.fiscUnit
            
            self.costAmount = soc.cost.formatMoney
            
            self.productionTime = soc.productionTime
            
            self.pricea = soc.pricea.formatMoney
            
            self.priceb = soc.priceb.formatMoney
            
            self.pricec = soc.pricec.formatMoney
        
            if self.loadSocDetails {
            
                guard soc.saleAction.count > 0 else {
                    self.amountInput.select()
                    return
                }
                  
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
        
        var actionRequieredIsEmpty = false
        
        self.actionItemsRefrence.forEach { id, action in
            
            action.objects.forEach { object in
                if object.isRequired && object.value.isEmpty {
                    showError(.campoRequerido, .requierdValid("\(action.name): \(object.title)"))
                    actionRequieredIsEmpty = true
                }
            }
        }
        
        if actionRequieredIsEmpty {
            return
        }
        
        guard let amountFloat = Float(self.amount) else {
            showError(.errorGeneral, "Ingrese una cantidad valida")
            return
        }
        
        guard let priceFloat = Float(self.price) else {
            showError(.errorGeneral, "Ingrese una cantidad valida")
            return
        }
        
        let costFloat = Float(self.costAmount)
        
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
                isWarenty: false,
                internalWarenty: nil,
                generateRepositionOrder: nil
            ))
        
        self.remove()
        
    }
}
