//
//  BudgetView.swift
//  
//
//  Created by Victor Cantu on 8/29/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class BudgetView: Div {
    
    override class var name: String { "div" }
    
    let accountId: UUID
    
    var budgetStatus: State<CustBudgetManagerStatus?>
    
    /// cost_a, cost_b, cost_c
    var costType: CustAcctCostTypes
    
    var orderid: UUID
    
    var customerName: String
    
    var customerMobile: String
    
    private var callback: ((
        _ items: API.custOrderV1.ApproveBudgetResponse
    ) -> ())
    
    private var addNote: ((
        _ note: CustOrderLoadFolioNotes
    ) -> ())

    init(
        accountId: UUID,
        budgetStatus: State<CustBudgetManagerStatus?>,
        costType: CustAcctCostTypes,
        orderid: UUID,
        customerName: String,
        customerMobile: String,
        callback: @escaping ((
            _ items: API.custOrderV1.ApproveBudgetResponse
        ) -> ()),
        addNote: @escaping ((
            _ note: CustOrderLoadFolioNotes
        ) -> ())
    ) {
        self.accountId = accountId
        self.budgetStatus = budgetStatus
        self.costType = costType
        self.orderid = orderid
        self.customerName = customerName
        self.customerMobile = customerMobile
        self.callback = callback
        self.addNote = addNote
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var budgetid: UUID? = nil
    
    @State var budgetCredit: Int64? = nil
    
    @State var budgetCreditExpire: Int64? = nil
    
    @State var folio: String = ""
    
    /// Term to search POC or SOC
    @State var searchTerm = ""
    
    @State var budgetCost: Float = 0
    
    @State var balance: Float = 0
    
    @State var printMenuViewIsHidden = true
    
    @State var sendMenuViewIsHidden = true
    
    /// Name of the charge
    var lastSearchTerm = ""
    
    var canAutoLoad = true
    
    @State var itemRefrence: [ UUID: ItemView ] = [:]
    
    lazy var searchTermInput = InputText(self.$searchTerm)
        .placeholder("Modelo / SKU / SOC / POC")
        .class(.textFiledBlackDarkLarge)
        .marginTop(-3.px)
        .fontSize(24.px)
        .height(32.px)
        .width(350.px)
        .onBlur {
            Dispatch.asyncAfter(0.3) {
                self.resultBox.innerHTML = ""
            }
        }
        .onFocus { tf in tf.select() }
        .onKeyUp { tf in
            
            if ignoredKeys.contains(tf.text) {
               return
            }
            
            self.search()
            
        }
    
    lazy var resultBox = Div()
        .position(.absolute)
        .width(500.px)
    
    lazy var chargesGrid = Table {
        Tr{
            /// Edit Icon
            Td()
                .align(.center)
                .width(50.px)
            
            Td("Marca")
                .align(.left)
                .width(120.px)
            
            Td("Modelo / Nombre")
                .align(.left)
            
            Td("Hubicación")
                .align(.left)
                .width(120.px)
            
            Td("Uni.")
                .align(.center)
                .width(75.px)
            
            Td("C. Uni.")
                .align(.center)
                .width(75.px)
            
            Td("Sub Total")
                .align(.center)
                .width(100.px)
        }
    }
        .width(100.percent)
        .color(.white)
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/zoom.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(0.px)
                    }
                    .marginRight(12.px)
                    .paddingTop(3.px)
                    .float(.left)
                    
                    Label("Compras")
                }
                .padding(all: 3.px)
                .class(.uibtnLarge)
                .marginTop(-7.px)
                .marginRight(12.px)
                .cursor(.pointer)
                .fontSize(22.px)
                .float(.right)
                .onClick {
                    addToDom(SearchHistoricalPurchaseView())
                }
                
                H2(self.$folio.map{ $0.isEmpty ? "Presupuesto Nuevo" : "Presupuesto \($0)" })
                    .color(.lightBlueText)
                    .float(.left)
                
                Div{
                    self.searchTermInput
                    self.resultBox
                }
                .marginLeft(7.px)
                .float(.left)
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/add.png")
                            .padding(all: 3.px)
                            .paddingRight(0.px)
                            .height(18.px)
                    }
                    .marginRight(12.px)
                    .paddingTop(3.px)
                    .float(.left)
                    
                    Label("Cargo Manual")
                }
                .padding(all: 3.px)
                .class(.uibtnLarge)
                .marginTop(-7.px)
                .marginLeft(7.px)
                .cursor(.pointer)
                .fontSize(22.px)
                .float(.left)
                .onClick {
                    
                    addToDom(BudgetManualChargeView { units, description, price, cost in
                        
                        loadingView(show: true)
                        
                        let obj = SaleProductPDVObject(
                            type: .manual,
                            id: .init(),
                            store: custCatchStore,
                            ids: [],
                            series: [],
                            cost: cost,
                            units: units,
                            unitPrice: price,
                            subTotal: price * (units / 100),
                            costType: .cost_a,
                            name: description,
                            brand: "",
                            model: "",
                            pseudoModel: "",
                            avatar: "",
                            fiscCode: "",
                            fiscUnit: "",
                            preRegister: false
                        )
                        
                        API.custOrderV1.createBudgetObject(
                            budgetId: self.budgetid,
                            orderId: self.orderid,
                            comment: "",
                            store: custCatchStore,
                            saleType: .folio,
                            objects: [.init(
                                name: description,
                                brand: "",
                                model: "",
                                pseudoModel: "",
                                saleObject: obj,
                                cost: Double(cost.fromCents),
                                ids: []
                            )]
                        ) { resp in
                            
                            loadingView(show: false)
                            
                            print("🟡  001")
                            
                            guard let resp else {
                                showError(.errorDeCommunicacion, .serverConextionError)
                                return
                            }

                            guard resp.status == .ok else {
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            guard let payload = resp.data else {
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            self.budgetid = payload.budgetId
                            
                            self.budgetStatus.wrappedValue = payload.budgetStatus
                            
                            OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(payload.budgetStatus))
                            
                            self.folio = payload.folio
                            
                            let view = ItemView(
                                storeid: custCatchStore,
                                orderid: self.orderid,
                                budgetid: payload.budgetId,
                                objectid: obj.id,
                                type: .manual,
                                avatar: "",
                                uuids: [],
                                price: price,
                                units: units,
                                unitCost: cost,
                                subTotal: (price / (units / 100)),
                                costType: self.costType,
                                brand: "",
                                model: "",
                                name: description,
                                storagePlace: "Cargo Manual"
                            ){ id in
                            
                                self.itemRefrence[id]?.remove()
                                
                                self.itemRefrence.removeValue(forKey: id)
                                
                            } updateUnits: {
                                self.calcBalance()
                            }
                            
                            self.itemRefrence[view.viewid] = view
                            
                            self.chargesGrid.appendChild(view)
                            
                        }
                        
                    } removeCharge: {
                        
                    })
                }
                
            }
            
            Div().class(.clear).height(7.px)

            Div{
                self.chargesGrid
            }
            .custom("height", "calc(100% - 90px)")
            .class(.roundDarkBlue)
            .padding(all: 7.px)
            .overflow(.auto)
            
            Div{
                
                H2(self.$balance.map{ $0.formatMoney })
                    .color(.lightBlueText)
                    .fontSize(36.px)
                    .float(.right)
                
                if custCatchHerk >= sneekPeekLimit {
                    Div{
                        H2(self.$budgetCost.map{ "\($0.formatMoney) CI" })
                            .fontSize(18.px)
                            .color(.gray)
                        
                        H2(self.$budgetCost.map{ "\(( self.balance - $0 ).formatMoney) GA" } )
                            .fontSize(18.px)
                            .color(.yellowTC)
                    }
                    .hidden(self.$budgetCost.map {  $0 == 0 })
                    .marginRight(7.px)
                    .textAlign(.right)
                    .float(.right)
                }
                
                Div{
                    Div{
                        /// Download
                        Div{
                            Div{
                                Div{
                                    Span("Sin Detalles")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.downloadBudget(false)
                                    self.printMenuViewIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                Div{
                                    Span("Con Detalles")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.downloadBudget(true)
                                    self.printMenuViewIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                Div().height(7.px)
                            }
                            .hidden(self.$printMenuViewIsHidden)
                            .backgroundColor(.transparentBlack)
                            .position(.absolute)
                            .borderRadius(12.px)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .marginTop(7.px)
                            .bottom(42.px)
                            .zIndex(1)
                            .onClick { _, event in
                                event.stopPropagation()
                            }
                            Div{
                                
                                Img()
                                    .src("/skyline/media/download2.png")
                                    .marginLeft(12.px)
                                    .height(18.px)
                            
                                 Span("Descargar")
                                 
                                 Div{
                                     Img()
                                         .src(self.$printMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                         .class(.iconWhite)
                                         .paddingTop(7.px)
                                         .opacity(0.5)
                                         .width(18.px)
                                 }
                                 .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                                 .paddingRight(3.px)
                                 .paddingLeft(7.px)
                                 .marginLeft(7.px)
                                 .float(.right)
                                 
                                 Div().clear(.both)
                                 
                             }
                            .class(.uibtn)
                            .onClick {
                                self.printMenuViewIsHidden = !self.printMenuViewIsHidden
                            }
                        }
                        .paddingRight(7.px)
                        .float(.left)
                        
                        /// Send
                        Div{
                            Div{
                                Div{
                                    Span("Sin Detalles")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.sendMenuViewIsHidden = true
                                    loadingView(show: true)
                                    self.sendBudget(false) { note in
                                        loadingView(show: false)
                                        showSuccess(.operacionExitosa, "Enviado")
                                        if let note {
                                            self.addNote(note)
                                        }
                                        
                                    }
                                    event.stopPropagation()
                                }
                                
                                Div{
                                    Span("Con Detalles")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.sendMenuViewIsHidden = true
                                    loadingView(show: true)
                                    self.sendBudget(true) { note in
                                        loadingView(show: false)
                                        showSuccess(.operacionExitosa, "Enviado")
                                    }
                                    event.stopPropagation()
                                }
                                
                                Div().height(7.px)
                            }
                            .hidden(self.$sendMenuViewIsHidden)
                            .backgroundColor(.transparentBlack)
                            .position(.absolute)
                            .borderRadius(12.px)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .marginTop(7.px)
                            .bottom(42.px)
                            .zIndex(1)
                            .onClick { _, event in
                                event.stopPropagation()
                            }
                            
                            Div{
                                
                                Img()
                                    .src("/skyline/media/mail.png")
                                    .marginLeft(12.px)
                                    .height(18.px)
                            
                                 Span("Enviar")
                                 
                                 Div{
                                     Img()
                                         .src(self.$sendMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                         .class(.iconWhite)
                                         .paddingTop(7.px)
                                         .opacity(0.5)
                                         .width(18.px)
                                 }
                                 .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                                 .paddingRight(3.px)
                                 .paddingLeft(7.px)
                                 .marginLeft(7.px)
                                 .float(.right)
                                 
                                 Div().clear(.both)
                                 
                             }
                            .class(.uibtn)
                            .onClick {
                                self.sendMenuViewIsHidden = !self.sendMenuViewIsHidden
                            }
                        }
                        .paddingRight(7.px)
                        .float(.left)
                        
                        /// Delete
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginLeft(7.px)
                                .height(18.px)
                            
                            Span("Remover")
                        }
                        .hidden(self.budgetStatus.map{ $0 == .canceled })
                        .paddingRight(7.px)
                        .class(.uibtn)
                        .float(.left)
                        .onClick { _ in
                            
                            addToDom(ConfirmView(
                                type: .yesNo,
                                title: "Remover Presupuesto",
                                message: "¿Desea desvincular el presupueto de la orden de servicio?"
                            ){ isConfirmed, message in
                                
                                if isConfirmed {
                                    
                                    guard let budgetId = self.budgetid else {
                                        return
                                    }
                                    
                                    loadingView(show: true)
                                    
                                    API.custOrderV1.cancelBudget(
                                        orderId: self.orderid,
                                        budgetId: budgetId
                                    ) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp else {
                                            showError(.errorDeCommunicacion, .serverConextionError)
                                            return
                                        }

                                        guard resp.status == .ok else {
                                            showError(.errorGeneral, resp.msg)
                                            return
                                        }
                                        
                                        self.itemRefrence.forEach { id, view in
                                            view.remove()
                                        }
                                        
                                        self.itemRefrence.removeAll()
                                        
                                        self.budgetStatus.wrappedValue = nil
                                        
                                        self.budgetid = nil
                                        
                                        OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(nil))
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        }
                        
                        /// Aprove
                        Div{
                            
                            Img()
                                .src("/skyline/media/checkmark.png")
                                .marginLeft(7.px)
                                .height(18.px)
                            
                            Span("Aprobar")
                        }
                        .paddingRight(7.px)
                        .class(.uibtn)
                        .float(.left)
                        .onClick { _ in
                            self.aproveBudget()
                        }
                        
                    }
                    .float(.left)
                    .hidden(self.budgetStatus.map{[
                        CustBudgetManagerStatus.preparing,
                        CustBudgetManagerStatus.budgetRequested
                    ].contains($0)})
                    
                    
                    Div{
                        
                        /// Budget Ready
                        Div{
                            
                            Img()
                                .src("/skyline/media/checkmark.png")
                                .marginLeft(7.px)
                                .height(18.px)
                            
                            Span("Presupuesto Listo")
                            
                        }
                        .paddingRight(7.px)
                        .class(.uibtn)
                        .onClick { _ in
                            
                            guard let budgetId = self.budgetid else {
                                return
                            }
                            
                            loadingView(show: true)
                            
                            API.custOrderV1.confirmBudget(
                                orderId: self.orderid,
                                budgetId: budgetId
                            ) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }

                                guard resp.status == .ok else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }
                                                                
                                self.budgetStatus.wrappedValue = .prepared
                                
                                OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(.prepared))
                                
                            }
                        }
                    }
                    .float(.left)
                    .hidden(self.budgetStatus.map{![
                        CustBudgetManagerStatus.preparing,
                        CustBudgetManagerStatus.budgetRequested
                    ].contains($0)})
                    
                    /// Budget Credit
                    Div{
                        Span(self.$budgetCredit.map{ ( ($0 ?? 0) > 0 ) ? ($0 ?? 0).formatMoney : "Agregar Bonificación" })
                            .color(.white)
                    }
                    .paddingRight(7.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick {
                        
                        guard let budgetid = self.budgetid else {
                            showError(.errorGeneral, "No se localizo id del presupuesto.")
                            return
                        }
                        
                        let view = Credit(
                            budgetId: budgetid,
                            credit: self.budgetCredit,
                            creditExpireAt: self.budgetCreditExpire
                        ) { credit, creditExpireAt in
                            
                            self.budgetCredit = credit
                            
                            self.budgetCreditExpire = creditExpireAt
                            
                        }
                        
                        addToDom(view)
                    }
                    
                    Div{
                        
                        Div("Bonificacion")
                            .fontSize(14.px)
                            .color(.yellowTC)
                        
                        Div(self.$budgetCreditExpire.map{ getDate($0 ?? 0).formatedShort })
                            .color(.lightGray)
                            .fontSize(14.px)
                        
                    }
                    .hidden(self.$budgetCreditExpire.map{ $0 == nil })
                    .float(.left)
                    
                    
                    
                }
                .hidden(self.$budgetid.map{ $0 == nil })
                .paddingTop(7.px)
                .float(.left)
                
                Div{
                    
                    /// Request  Budget
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_budgets_required.png")
                            .marginLeft(7.px)
                            .height(18.px)
                        
                        Span("Solicitar Presupuesto")
                    }
                    .paddingRight(7.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick { _ in
                        addToDom(ConfirmView(
                            type: .yesNo,
                            title: "Requerir Presupueto",
                            message: "Ingrese la descripción de lo que se reqiere para el presupuesto",
                            requiersComment: true
                        ){ isConfirmed, comment in
                            
                            loadingView(show: true)
                            
                            API.custOrderV1.requestBudget(
                                orderId: self.orderid,
                                storeId: custCatchStore,
                                comment: comment
                            ) { resp in
                                
                                loadingView(show: false)
                                
                                guard let resp = resp else {
                                    showError(.errorDeCommunicacion, .serverConextionError)
                                    return
                                }

                                guard resp.status == .ok else {
                                    showError(.errorGeneral, resp.msg)
                                    return
                                }
                                
                                guard let payload = resp.data else {
                                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                                    return
                                }
                                
                                self.budgetid = payload.id
                                
                                self.folio = payload.folio
                                
                                self.budgetStatus.wrappedValue = .budgetRequested
                                
                                OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(.budgetRequested))
                                
                            }
                        })
                    }
                    
                    /// Load Past Budgest
                    Div{
                        
                        Img()
                            .src("/skyline/media/history_color.png")
                            .marginLeft(7.px)
                            .height(18.px)
                        
                        Span("Cargar Presupuesto")
                    }
                    .paddingRight(7.px)
                    .class(.uibtn)
                    .float(.left)
                    .onClick { _ in
                        // HistoricItemsView
                        
                        addToDom(HistoricItemsView(
                            accountId: self.accountId,
                            orderId: self.orderid,
                            callback: { budget in
                                
                                
                                guard let manager = budget.manager else {
                                    showError(.errorGeneral, "No se localizo id del manager \(#function)")
                                    return
                                }
                                
                                self.budgetid = manager.id
                                
                                self.folio = manager.folio
                                
                                OrderCatchControler.shared.updateParameter(self.orderid, .budgetStatus(.prepared))
                                self.loadBudget()
                            }
                        ))
                    }
                    
                }
                .hidden(self.$budgetid.map{ $0 != nil })
                .paddingTop(7.px)
                .float(.left)
                
            }
            
        }
        .custom("height", "calc(100% - 150px)")
        .custom("width", "calc(100% - 150px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .left(75.px)
        .top(75.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        loadingView(show: true)
        
        $itemRefrence.listen {
            self.calcBalance()
        }
        
        loadBudget()
    }
    
    override func didAddToDOM() {
        searchTermInput.select()
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
            
            if let payload = searchChargeCatch[term] {
                
                print("💾 in catch")
                
                self.searchTermProcess(payload:payload)
                return
            }
            
            self.searchTermInput.class(.isLoading)
            
            // TODO: properly parse currentCodeIds
            searchCharge(
                term: term,
                costType: self.costType,
                currentCodeIds: []
            ) { term, resp in
                self.searchTermInput.removeClass(.isLoading)
                searchChargeCatch[term] = resp
                self.searchTermProcess(payload: resp)
            }
            
        }
        
    }
    
    func searchTermProcess(payload: [SearchChargeResponse]){
        
        resultBox.innerHTML = ""
        
        if payload.count == 1 {
            
            if canAutoLoad {
                
                guard let charge = payload.first else {
                    return
                }
                
                switch charge.t {
                case .product:
                    //self.addPoc(charge.i)
                    self.loadPOC(poc: charge.i)
                case .service:
                    self.loadSOC(soc: charge)
                case .manual:
                    break
                case .rental:
                    break
                }
                
            }
            
            canAutoLoad = false
        }
        
        payload.forEach { data in
            
            resultBox.appendChild(
                SearchChargeView(data: data, costType: self.costType, callback: { charge in
                    /// We will load proper view depending if its a service or a product.
                    switch charge.t {
                    case .product:
                        self.loadPOC(poc: charge.i)
                    case .service:
                        self.loadSOC(soc: charge)
                        break
                    case .manual:
                        break
                    case .rental:
                        break
                    }
                    
                })
            )
        }
    }
    
    func loadPOC(poc id: UUID) {
        
        print("load poc")
        
        let view = ConfirmProductView(
            accountId: accountId,
            costType: costType,
            pocid: id,
            selectedInventoryIDs: []
        ) { poc, price, costType, units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder in
            
            loadingView(show: true)
            
            let obj = SaleProductPDVObject(
                type: .product,
                id: poc.id,
                store: storeid,
                ids: items.map{ $0.id },
                series: [],
                cost: poc.cost,
                units: units,
                unitPrice: price,
                subTotal: Int64(price * (units / 100)),
                costType: costType,
                name: poc.name,
                brand: poc.brand,
                model: poc.model,
                pseudoModel: poc.pseudoModel,
                avatar: poc.avatar,
                fiscCode: poc.fiscCode,
                fiscUnit: poc.fiscUnit,
                preRegister: false
            )
            
            API.custOrderV1.createBudgetObject(
                budgetId: self.budgetid,
                orderId: self.orderid,
                comment: "",
                store: custCatchStore,
                saleType: .folio,
                objects: [.init(
                    name: poc.name,
                    brand: poc.brand,
                    model: poc.model,
                    pseudoModel: poc.pseudoModel,
                    saleObject: obj,
                    cost: Double(poc.cost.fromCents),
                    ids: items.map{ $0.id }
                )]
                    /*
                
                     */
            ) { resp in
                
                print("🟡  002")
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se localizo payload de data.")
                    return
                }
                
                self.budgetid = payload.budgetId
                
                self.folio = payload.folio
                
                self.budgetStatus.wrappedValue = payload.budgetStatus
                
                OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(payload.budgetStatus))
                
                var bod = ""
                if let bodid = items.first?.custStoreBodegas {
                    if let name = bodegas[bodid]?.name {
                        bod = name
                    }
                }
                
                var sec = ""
                if let secid = items.first?.custStoreSecciones {
                    if let name = seccions[secid]?.name {
                        sec = name
                    }
                }
                
                let view = ItemView(
                    storeid: custCatchStore,
                    orderid: self.orderid,
                    budgetid: payload.budgetId,
                    objectid: obj.id,
                    type: .product,
                    avatar: "",
                    uuids: items.map{ $0.id },
                    price: price,
                    units: units,
                    unitCost: poc.cost,
                    subTotal: (price * items.count.toInt64),
                    costType: self.costType,
                    brand: poc.brand,
                    model: poc.model,
                    name: poc.name,
                    storagePlace: "\(bod) \(sec)"
                ){ id in
                
                    self.itemRefrence[id]?.remove()
                    
                    self.itemRefrence.removeValue(forKey: id)
                    
                } updateUnits: {
                    self.calcBalance()
                }
                
                self.itemRefrence[view.viewid] = view
                
                self.chargesGrid.appendChild(view)
                
            }
        }
        
        addToDom(view)
        
    }
 
    func loadSOC(soc: SearchChargeResponse) {
        
        let view = BudgetSOCView(
            loadSocDetails: false,
            soc: soc,
            costType: costType
        ) { soc in
            
            guard let socid = soc.id else{
                return
            }
            
            
            let obj = SaleProductPDVObject(
                type: .service,
                id: socid,
                store: custCatchStore,
                ids: [],
                series: [],
                cost: soc.cost,
                units: soc.units,
                unitPrice: soc.price,
                subTotal: soc.price * (soc.units / 100),
                costType: self.costType,
                name: soc.description,
                brand: "",
                model: "",
                pseudoModel: "",
                avatar: "",
                fiscCode: soc.fiscCode,
                fiscUnit: soc.fiscUnit,
                preRegister: false
            )
            
            API.custOrderV1.createBudgetObject(
                budgetId: self.budgetid,
                orderId: self.orderid,
                comment: "",
                store: custCatchStore,
                saleType: .folio,
                objects: [ .init(
                    name: soc.description,
                    brand: "",
                    model: "",
                    pseudoModel: "",
                    saleObject: obj,
                    cost: Double(soc.cost?.fromCents ?? 0),
                    ids: soc.ids
                )]
            ) { resp in
                
                print("🟡  003")
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se localizo payload de data.")
                    return
                }
                
                self.budgetid = payload.budgetId
                
                self.budgetStatus.wrappedValue = payload.budgetStatus
                
                OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(payload.budgetStatus))
                
                self.folio = payload.folio
                
                let view = ItemView(
                    storeid: custCatchStore,
                    orderid: self.orderid,
                    budgetid: payload.budgetId,
                    objectid: obj.id,
                    type: .service,
                    avatar: "",
                    uuids: soc.ids,
                    price: soc.price,
                    units: soc.units,
                    unitCost: soc.cost ?? 0,
                    subTotal: (soc.price * soc.units) / 100,
                    costType: self.costType,
                    brand: "",
                    model: "",
                    name: soc.description,
                    storagePlace: "Servicio"
                ){ id in
                
                    self.itemRefrence[id]?.remove()
                    
                    self.itemRefrence.removeValue(forKey: id)
                    
                } updateUnits: {
                    self.calcBalance()
                }
                
                self.itemRefrence[view.viewid] = view
                
                self.chargesGrid.appendChild(view)
                
            }
            
        }
        
        addToDom(view)
        
    }
 
    func calcBalance(){
        
        var bal: Int64 = 0
        
        var cost: Int64 = 0
        
        itemRefrence.forEach { id, item in
            bal += ((item.units * item.price) / 100)
            
            cost += ((item.units * item.unitCost) / 100)
            
        }
        
        self.balance = bal.fromCents
        
        self.budgetCost = cost.fromCents
        
    }
    
    func downloadBudget(_ fullDetail: Bool){
        
        guard let budgetid else {
            return
        }
        
        let _orderId = (orderid.uuidString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        
        let _budgetid = (budgetid.uuidString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let _folio = (folio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        let url = baseSkylineAPIUrl(ie: "orderBudgetObjectMail") +
        "&orderId=\(_orderId)" +
        "&budgetId=\(_budgetid)" +
        "&budgetFolio=\(_folio)" +
        "&tcon=web" +
        "&pDir=\(customerServiceProfile?.account.pDir ?? "")" +
        "&download=true" +
        "&fullDetail=" + fullDetail.description
        _ = JSObject.global.goToURL!(url)
        
    }
    
    func sendBudget(
        _ fullDetail: Bool,
        sentResponse: @escaping ( (
            _ note: CustOrderLoadFolioNotes?
        ) -> () )
    ){
        
        guard let budgetid = budgetid else {
            showError(.errorGeneral, "Error al obtener id del presuesto")
            return
        }
        
        let url = "https://tierracero.com/dev/skyline/api.php?ie=orderBudgetObjectMail"
        
        let xhr = XMLHttpRequest()
        
        xhr.open(method: "POST", url: url)
        
        xhr.setRequestHeader("Accept", "application/json")
            //.setRequestHeader("Content-Type", "multipart/form-data")
            //xhr.setRequestHeader("Accept", "application/json")
        
        let formData = FormData()
        
        formData.append("ie", "orderBudgetObjectMail")
        formData.append("token", custCatchToken)
        formData.append("user", custCatchUser)
        formData.append("key", custCatchKey)
        formData.append("mid", custCatchMid)
        formData.append("orderId", orderid.uuidString)
        formData.append("budgetId", budgetid.uuidString)
        formData.append("budgetFolio", folio)
        formData.append("pDir", customerServiceProfile?.account.pDir ?? "")
        formData.append("customerName", customerName)
        formData.append("customerMobile", customerMobile)
        formData.append("fullDetail", fullDetail.description)
        
        xhr.send(formData)
        
        xhr.onError {
            sentResponse(nil)
        }
        
        xhr.onLoad {
            
            guard let data = xhr.responseText?.data(using: .utf8) else {
                print("🔴  JSON to DATA ERROR")
                return
            }
            
            do{
                let payload = try JSONDecoder().decode(APIResponseGeneric<API.custOrderV1.AddNoteResponse>.self, from: data)
                sentResponse(payload.data?.note)
            }
            
            catch{
                sentResponse(nil)
            }
            
            
            
        }
        
        
        
    }
    
    func aproveBudget(){
        
        self.appendChild(ConfirmView(type: .aproveDeny, title: "Aprobar Presupuesto", message: "Confirme la aprobacion del presupuesto ", callback: { isConfirmed, comment in
            if isConfirmed {
                
                loadingView(show: true)
                
                API.custOrderV1.approveBudget(
                    id: self.orderid
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
                        showError(.unexpectedResult, "Refresque el sistama")
                        return
                    }
                    
                    self.budgetid = nil
                    
                    self.folio = ""
                    
                    self.budgetStatus.wrappedValue = nil
                    
                    OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(nil))
                    
                    self.callback(payload)
                    
                    self.remove()

                }
            }
        }))
    }
    
    func loadBudget() {
        
        API.custOrderV1.loadServiceOrderBudgetObject(orderid: self.orderid) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                return
            }
            
            guard let manager = payload.manager else {
                return
            }
            
            self.budgetid = manager.id
            
            self.folio = manager.folio
            
            self.budgetStatus.wrappedValue = manager.status
            
            if let expireAt = manager.creditExpireAt {
                
                if expireAt > getNow() {
                    
                    self.budgetCredit = manager.credit
                    
                    self.budgetCreditExpire = manager.creditExpireAt
                    
                }
                
            }
            
            OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(manager.status))
            
            guard let budgetid = self.budgetid else{
                return
            }
            
            /// Products
            payload.saleObjects.forEach { item in
                
                var bod = ""
                if let bodid = item.ids.first?.custStoreBodegas {
                    if let name = bodegas[bodid]?.name {
                        bod = name
                    }
                }
                
                var sec = ""
                if let secid = item.ids.first?.custStoreSecciones {
                    if let name = seccions[secid]?.name {
                        sec = name
                    }
                }
                
                let view = ItemView(
                    storeid: custCatchStore,
                    orderid: self.orderid,
                    budgetid: budgetid,
                    objectid: item.custPOC.id,
                    type: .product,
                    avatar: "",
                    uuids: item.ids.map{ $0.id },
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.custPOC.cost,
                    subTotal: item.units,
                    costType: self.costType,
                    brand: item.custPOC.brand,
                    model: item.custPOC.model,
                    name: item.custPOC.name,
                    storagePlace: "\(bod) \(sec)"
                ){ id in
                
                    self.itemRefrence[id]?.remove()
                    
                    self.itemRefrence.removeValue(forKey: id)
                    
                } updateUnits: {
                    self.calcBalance()
                }
                
                self.itemRefrence[view.viewid] = view
                
                self.chargesGrid.appendChild(view)
                
            }
            
            /// Services
            payload.saleObjectsSOC.forEach { item in
                
                let view = ItemView(
                    storeid: custCatchStore,
                    orderid: self.orderid,
                    budgetid: budgetid,
                    objectid: item.custSOC.id,
                    type: .service,
                    avatar: "",
                    uuids: [],
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.custSOC.cost,
                    subTotal: (item.unitPrice * (item.units / 100)),
                    costType: self.costType,
                    brand: "",
                    model: "",
                    name: item.custSOC.name,
                    storagePlace: "Servicio"
                ){ id in
                
                    self.itemRefrence[id]?.remove()
                    
                    self.itemRefrence.removeValue(forKey: id)
                    
                } updateUnits: {
                    self.calcBalance()
                }
                
                self.itemRefrence[view.viewid] = view
                
                self.chargesGrid.appendChild(view)
                
            }
            
            /// Manual
            payload.saleObjectsManual.forEach { item in
                
                let view = ItemView(
                    storeid: custCatchStore,
                    orderid: self.orderid,
                    budgetid: budgetid,
                    objectid: item.id,
                    type: .manual,
                    avatar: "",
                    uuids: [],
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.cost ?? 0,
                    subTotal: (item.units * (item.unitPrice / 100)),
                    costType: self.costType,
                    brand: "",
                    model: "",
                    name: item.name,
                    storagePlace: "Servicio"
                ){ id in
                
                    self.itemRefrence[id]?.remove()
                    
                    self.itemRefrence.removeValue(forKey: id)
                    
                } updateUnits: {
                    self.calcBalance()
                }
                
                self.itemRefrence[view.viewid] = view
                
                self.chargesGrid.appendChild(view)
                
            }
            
        }
    }
    
    
}

