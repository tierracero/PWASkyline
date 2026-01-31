//
//  AccoutOverview.swift
//
//
//  Created by Victor Cantu on 4/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension AccoutOverview {
    
    enum CurrentView: String {
        case `default`
        case account
        case order
        case fiscal
        case metrics
    }
    
}

public class AccoutOverview: Div {
    
    public override class var name: String { "div" }
    
    let id: HybridIdentifier
    
    let isSuperView: Bool
    
    init(
        id: HybridIdentifier,
        isSuperView: Bool = false
    ) {
        self.id = id
        self.isSuperView = isSuperView
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var cardId: String = ""
    
    @State var acctType: CustAcctTypes = .personal
    
    var accountViewIsLoaded: Bool = false
    
    var orderViewIsLoaded: Bool = false
    
    var fiscalViewIsLoaded: Bool = false
    
    var metricsViewIsLoaded: Bool = false
    
    var shownHighPriorityNotes: [UUID] = []
    
    @State var order: CustOrderLoadFolioDetails? = nil
    
    @State var orderStatus: CustFolioStatus? = nil
    
    @State var load: CurrentView = .default
    
    var account: CustAcct? = nil
    
    @State var printMenuViewIsHidden = true
    
    lazy var accountView = Div{
        
    }
        .height(100.percent)
        .width(100.percent)
        .hidden(self.$load.map{$0 == .account ? false : true})
    
    lazy var orderView = Div{
        
    }
        .width(100.percent)
        .height(100.percent)
        .hidden(self.$load.map{$0 == .order ? false : true})
    
    lazy var fiscalView = Div{
        
    }
        .width(100.percent)
        .height(100.percent)
        .hidden(self.$load.map{$0 == .fiscal ? false : true})
    
    lazy var metricsView = Div{
        
    }
        .width(100.percent)
        .height(100.percent)
        .hidden(self.$load.map{$0 == .metrics ? false : true})
    
    lazy var accountQuickTool = Div {
        
        /// sendToMobile
        Div{
            
            Img()
                .src("/skyline/media/sendToMobile.png")
                .class(.iconWhite)
                .height(30.px)
                .marginLeft(12.px)
                .onClick {
                    if let accountid = self.account?.id {
                        addToDom(SelectCustUsernameView(
                            type: .all,
                            ignore: [custCatchID],
                            callback: { user in
                                
                                loadingView(show: true)
                                
                                API.custAPIV1.sendToMobile(
                                    type: .account,
                                    targetUser: user.username,
                                    objid: accountid,
                                    smallDescription: "",
                                    description: ""
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
                                    
                                    showSuccess(.operacionExitosa, "Elemento Enviado")
                                    
                                }
                            }))
                    }
                }
        }
        .cursor(.pointer)
        .float(.right)
        
    }
        .overflowX(.auto)
        .marginRight(7.px)
        .align(.right)
        .float(.right)
        .hidden(self.$load.map{$0 == .account ? false : true})
    
    lazy var orderQuickTool = Div {
        
        /// sendToMobile
        Div{
            
            
            Img()
                .src("/skyline/media/notificationIcon.png")
                .marginLeft(12.px)
                .cursor(.pointer)
                .height(30.px)
                .onClick {
                    
                    guard let order = self.order else {
                        return
                    }
                    
                    //_orderView
                    
                    addToDom(RequestTastView(
                        type: .order,
                        relationId: order.id,
                        relationFolio: order.folio,
                        relationName: order.name
                    ){
                        
                    })
                }
            
            Img()
                .src("/skyline/media/sendToMobile.png")
                .class(.iconWhite)
                .marginLeft(12.px)
                .height(30.px)
                .onClick {
                
                    if let order = self.order  {
                        
                        addToDom(SelectCustUsernameView(
                            type: .all,
                            ignore: [custCatchID],
                            callback: { user in
                                
                                loadingView(show: true)
                                
                                API.custAPIV1.sendToMobile(
                                    type: .order,
                                    targetUser: user.username,
                                    objid: order.id,
                                    smallDescription: order.folio,
                                    description: "Favor de revizar orden \(order.name)"
                                ) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp else {
                                        showError(.comunicationError, .unexpenctedMissingPayload)
                                        return
                                    }
                                    
                                    guard resp.status == .ok else {
                                        showError(.generalError, resp.msg)
                                        return
                                    }
                                    
                                    showSuccess(.operacionExitosa, "Elemento Enviado")
                                    
                                }
                            }))
                    }
                
                }
        }
        .hidden(self.$order.map{$0 == nil ? true : false})
        .cursor(.pointer)
        .float(.right)
        
        /// Print
        
        Div{
            
            Div{
                
                Img()
                    .src("/skyline/media/icon_print.png")
                    .class(.iconWhite)
                    .marginLeft(12.px)
                    .height(18.px)
            
                 Span("Imprimir")
                 
                 Div{
                     Img()
                         .src(self.$printMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                         .class(.iconWhite)
                         .paddingTop(7.px)
                         .width(18.px)
                 }
                 .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                 .paddingRight(3.px)
                 .paddingLeft(7.px)
                 .marginLeft(7.px)
                 .float(.right)
                 .onClick { _, event in
                     self.printMenuViewIsHidden = !self.printMenuViewIsHidden
                     event.stopPropagation()
                 }
                 Div().clear(.both)
                 
             }
            .class(.uibtn)
            .onClick {
                
                if let ov = self._orderView {
                    
                    if configStore.print.document == .pdf {
                        showSuccess(.operacionExitosa, "Descargando...")
                        
                        let url = printServiceOrder(orderid: ov.order.id)
                        
                        _ = JSObject.global.goToURL!(url)
                        
                        return
                    }
                    
                    ov.printOrder()
                    
                    //let printBody = OrderPrintEngine(order: ov.order, notes: ov.notes, payments: ov.payments, charges: ov.charges, pocs: ov.pocs, files: ov.files, equipments: ov.equipments, rentals: ov.rentals, transferOrder: ov.transferOrder).innerHTML
                    //_ = JSObject.global.renderPrint!( custCatchUrl, ov.order.folio, ov.order.deepLinkCode, String(ov.order.mobile.suffix(4)), printBody)
                }
                else {
                    showError(.unexpectedResult, "No se pudo leer el folio intente de nuevo.")
                }
            }
            
            Div{
                /* MARK: Carta de Servicio */
                Div{
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .class(.iconWhite)
                        .marginRight(3.px)
                        .marginLeft(3.px)
                        .paddingTop(7.px)
                        .width(18.px)
                        .float(.right)
                    
                    Span("Carta de Servicio")
                }
                .width(90.percent)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    
                    if let orderView = self._orderView {
                        
                        let printBody = OrderPrintServiceLeterEngine(
                            order: orderView.order,
                            notes: orderView.notes,
                            payments: orderView.payments,
                            charges: orderView.charges,
                            pocs: orderView.pocs,
                            files: orderView.files,
                            equipments: orderView.equipments,
                            rentals:orderView.rentals,
                            transferOrder: orderView.transferOrder
                        ).innerHTML
                        _ = JSObject.global.renderPrint!(
                            custCatchUrl,
                            orderView.order.folio,
                            orderView.order.deepLinkCode,
                            String(orderView.order.mobile.suffix(4)),
                            printBody
                        )
                    }
                    
                    self.printMenuViewIsHidden = true
                    event.stopPropagation()
                }
                
                /* MARK: Charges */
                Div{
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .class(.iconWhite)
                        .marginRight(3.px)
                        .marginLeft(3.px)
                        .paddingTop(7.px)
                        .width(18.px)
                        .float(.right)
                    
                    Span("Cargos")
                }
                .width(90.percent)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    if let orderView = self._orderView {
                        let printBody = OrderPrintChargesEngine(
                            order: orderView.order,
                            notes: orderView.notes,
                            payments: orderView.payments,
                            charges: orderView.charges,
                            pocs: orderView.pocs,
                            files: orderView.files,
                            equipments: orderView.equipments,
                            rentals:orderView.rentals,
                            transferOrder: orderView.transferOrder
                        ).innerHTML
                        _ = JSObject.global.renderPrint!(
                            custCatchUrl,
                            orderView.order.folio,
                            orderView.order.deepLinkCode,
                            String(orderView.order.mobile.suffix(4)),
                            printBody
                        )
                    }
                    
                    self.printMenuViewIsHidden = true
                    event.stopPropagation()
                }
                
                /* MARK: Datos de la Ordern */
                Div{

                    // download
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .class(.iconWhite)
                        .marginRight(3.px)
                        .marginLeft(3.px)
                        .paddingTop(7.px)
                        .width(18.px)
                        .float(.right)
                        
                    Span("Imprimir Recibo")
                }
                .width(90.percent)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in

                    if let id = self.order?.id {
                        let link = printServiceOrder(orderid: id)
                        _ = JSObject.global.goToURL!(link)
                    }

                    self.printMenuViewIsHidden = true

                    event.stopPropagation()
                    
                }

                /* MARK: Datos de la Ordern */
                Div{

                    Img()
                        .src("/skyline/media/mail_sent.png")
                        .class(.iconWhite)
                        .marginRight(7.px)
                        .marginLeft(3.px)
                        .paddingTop(7.px)
                        .cursor(.pointer)
                        .width(18.px)
                        .float(.right)

                    Span("Emviar Recibo")
                }
                .width(90.percent)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in

                        if let id = self.order?.id {

                            loadingView(show: true)

                                API.custOrderV1.sendServiceOrder(orderId: id) { resp in

                                    loadingView(show: false)

                                    guard let resp else {
                                        showError(.comunicationError, .serverConextionError)
                                        return
                                    }
                                    
                                    guard resp.status == .ok else {
                                        showError(.generalError, resp.msg)
                                        return
                                    }
        
                                    // TODO: ADD NOTE FROM PAYLOAD RESPONSE 

                                    showSuccess(.operacionExitosa, "Recibo Enviado")

                                }
                            
                        }

                        self.printMenuViewIsHidden = true

                        event.stopPropagation()

                    }
                
            }
            .hidden(self.$printMenuViewIsHidden)
            .backgroundColor(.transparentBlack)
            .position(.absolute)
            .borderRadius(12.px)
            .padding(all: 3.px)
            .margin(all: 3.px)
            .marginTop(7.px)
            .width(300.px)
            .zIndex(1)
            .onClick { _, event in
                event.stopPropagation()
            }
        }
        .hidden(self.$order.map{$0 == nil ? true : false})
        .float(.right)
        
        /// Seperator
        Div()
            .marginRight(12.px)
            .paddingRight(12.px)
            .borderRight(width: .thin, style: .solid, color: .lightGray)
            .height(35.px)
            .float(.right)
            .hidden(self.$order.map{$0 == nil ? true : false})
        
        /// New
        Div{
            /*
            Img()
                .src("/skyline/media/icon_new.png")
                .class(.iconWhite)
                .height(18.px)
                .marginLeft(7.px)
            */
            Span("Activos")
        }
        .class(.uibtn)
        .float(.right)
        .onClick { _ in
            self.loadOrders()
        }
        
        /// History
        Div{
            /*
            Img()
                .src("/skyline/media/icon_history.png")
                .class(.iconWhite)
                .height(18.px)
                .marginLeft(7.px)
            */
            Span("Historial")
        }
        .class(.uibtn)
        .float(.right)
        .onClick { _ in
            self.loadHistorical()
        }
        
        /// Crear Folios
        Div{
            Img()
                .src("/skyline/media/addBlueIcon.png")
                .class(.iconWhite)
                .marginLeft(7.px)
                .height(18.px)
            
            Span("Orden")
        }
        .class(.uibtn)
        .float(.right)
        .onClick { _ in
            
            if let account = self.account {
                self.startServiceOrder(account: account)
            }
            else {
                self.loadAccout { account in
                    self.startServiceOrder(account: account)
                }
            }
            
        }
        
    }
        .marginRight(7.px)
        .float(.right)
        .hidden(self.$load.map{$0 == .order ? false : true})
    
    lazy var fiscalQuickTool = Div {
        
    }
        .overflowX(.auto)
        .marginRight(7.px)
        .align(.right)
        .float(.right)
        .hidden(self.$load.map{$0 == .fiscal ? false : true})
    
    lazy var metricsQuickTool = Div {
        
    }
        .overflowX(.auto)
        .marginRight(7.px)
        .align(.right)
        .float(.right)
        .hidden(self.$load.map{$0 == .metrics ? false : true})
    
    lazy var accountButton = Div("Cuenta")
        .cursor(.pointer)
        .fontSize(22.px)
        .borderRadius(all: 7.px)
        .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
        .marginRight(7.px)
        .color( self.$load.map{$0 == .account ? .white : .lightBlueText})
        .backgroundColor( self.$load.map{$0 == .account ? .lightBlueText : .transparent})
        .float(.left)
        .onClick {
            if self.load == .account { return }
            if self.accountViewIsLoaded {
                self.load = .account
                return
            }
            self.loadAccout()
        }
    
    lazy var orderButton = Div("Ordenes")
        .cursor(.pointer)
        .fontSize(22.px)
        .borderRadius(all: 7.px)
        .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
        .marginRight(7.px)
        .color( self.$load.map{$0 == .order ? .white : .lightBlueText})
        .backgroundColor( self.$load.map{$0 == .order ? .lightBlueText : .transparent})
        .float(.left)
        .onClick {
            if self.load == .order { return }
            if self.orderViewIsLoaded {
                self.load = .order
                return
            }
            self.loadOrders()
        }

    lazy var fiscalButton =  Div("Fiscal")
        .hidden(true)
        .cursor(.pointer)
        .fontSize(22.px)
        .borderRadius(all: 7.px)
        .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
        .marginRight(7.px)
        .color( self.$load.map{$0 == .fiscal ? .white : .lightBlueText})
        .backgroundColor( self.$load.map{$0 == .fiscal ? .lightBlueText : .transparent})
        .float(.left)
        .onClick {
            if self.load == .fiscal { return }
            self.load = .fiscal
        }
    
    lazy var metricsButton =  Div("Metricas")
        .hidden(true)
        .cursor(.pointer)
        .fontSize(22.px)
        .borderRadius(all: 7.px)
        .padding(top: 3.px, right: 7.px, bottom: 3.px, left: 7.px)
        .marginRight(7.px)
        .color( self.$load.map{$0 == .metrics ? .white : .lightBlueText})
        .backgroundColor( self.$load.map{$0 == .metrics ? .lightBlueText : .transparent})
        .float(.left)
        .onClick {
            if self.load == .metrics { return }
            if self.metricsViewIsLoaded {
                self.load = .metrics
                return
            }
            self.loadMetrics()
        }
    
    lazy var _orderView: OrderView? = nil
    
    @DOM public override var body: DOM.Content {
        
        Div {
            // Top Tools
            Div {
                
                Img()
                    .src("/skyline/media/cross.png")
                    .float(.right)
                    .marginRight(7.px)
                    .cursor(.pointer)
                    .width(24.px)
                    .onClick{
                        var accountid: UUID? = nil
                        
                        if let id = self.account?.id {
                            accountid = id
                        }
                        else if let id = self.order?.custAcct {
                            accountid = id
                        }
                        
                        guard let accountid else {
                            return
                        }
                        
                        minViewAcctRefrence.removeValue(forKey: accountid)
                        
                        self.remove()
                    }
                
                Img()
                    .src("/skyline/media/lowerWindow.png")
                    .class(.iconWhite)
                    .float(.right)
                    .marginRight(18.px)
                    .marginLeft(18.px)
                    .cursor(.pointer)
                    .width(24.px)
                    .onClick{
                        self.hideView()
                    }
                
                self.accountButton
                
                self.orderButton
                
                self.fiscalButton
                
                self.metricsButton
                
                self.accountQuickTool
                
                self.orderQuickTool
                
                self.fiscalQuickTool
                
                self.metricsQuickTool
                
                Div().class(.clear)
                
            }
            .paddingBottom(3.px)
            
            //Work Grid
            Div{
                
                Div{
                    self.accountView
                    
                    self.orderView
                    
                    self.fiscalView
                    
                    self.metricsView
                }
                .margin(all: 3.px)
                .custom("height", "calc(100% - 6px)")
                .custom("width", "calc(100% - 6px)")
                
            }
            .custom("height", "calc(100% - 40px)")
            
            Div().class(.clear)
            
        }
        .padding(all: 7.px)
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .boxShadow(h: 0.px, v: 0.px, blur: 3.px, color: .black)
        .custom("width", "calc(100% - 100px)")
        .custom("height", "calc(100% - 77px)")
        .position(.absolute)
        .top(57.px)
        .left(50.px)
    }
    
    public override func buildUI() {
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if !isSuperView {
            zIndex(1)
        }
        
    }
    
    func loadAccout(_ callback: ((
        _ account: CustAcct
    ) -> ())? = nil) {
         
        loadingView(show: true)
        
        API.custAccountV1.load(id: self.id) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                self.remove()
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                self.remove()
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se cargo cuenta del servidor. Contacte a Soporte TC" )
                self.remove()
                return
            }

            let view = AccountView(
                account: payload.custAcct,
                cardId: self.$cardId,
                acctType: self.$acctType
            )
        
            self.accountView.appendChild(view)
            
            self.accountViewIsLoaded = true
            
            self.account = payload.custAcct
            
            self.acctType = payload.custAcct.type
            
            self.load = .account
            
            if let callback {
                callback(payload.custAcct)
            }
            
            payload.highPriorityNotes.forEach { note in
                
                if self.shownHighPriorityNotes.contains(note.id) {
                    return
                }
                
                self.shownHighPriorityNotes.append(note.id)
                
                addToDom(ViewHighPriorityNote(
                    type: .account,
                    note: note,
                    folio: self.account?.folio,
                    name: self.account?.firstName
                ))
                
            }
            
            
            
        }
    }
    
    func loadOrder(
        account: CustAcctMin,
        order: CustOrderLoadFolioDetails,
        notes: [CustOrderLoadFolioNotes],
        payments: [CustOrderLoadFolioPayments],
        charges: [CustOrderLoadFolioCharges],
        pocs: [CustPOCInventoryOrderView],
        files: [CustOrderLoadFolioFiles],
        equipments: [CustOrderLoadFolioEquipments],
        rentals: [CustPOCRentalsMin],
        transferOrder: CustTranferManager?,
        orderHighPriorityNote: [HighPriorityNote],
        accountHighPriorityNote: [HighPriorityNote],
        tasks: [CustTaskAuthorizationManagerQuick],
        orderRoute: CustOrderRoute?,
        loadFromCatch: Bool
    ){
         
        self.cardId = account.CardID
        
        self.order = order
        self.orderStatus = order.status
        minViewOrderAccountRefrence[order.id] = order.custAcct
        
        self.orderView.innerHTML = ""
        
        _orderView = OrderView(
            accountView: self,
            order: order,
            notes: notes,
            payments: payments,
            charges: charges,
            pocs: pocs,
            files: files,
            equipments: equipments,
            rentals: rentals,
            transferOrder: transferOrder,
            orderHighPriorityNote: orderHighPriorityNote,
            accountHighPriorityNote: accountHighPriorityNote,
            tasks: tasks,
            orderRoute: orderRoute,
            loadFromCatch: loadFromCatch
        )
        
        self.orderView.appendChild(_orderView!)
        
        self.load = .order
        
        self.orderViewIsLoaded = true
        
    }
    
    func loadOrder(
        id: UUID,
        callback: @escaping ((
            _ account: CustAcctMin,
            _ order: CustOrderLoadFolioDetails,
            _ notes: [CustOrderLoadFolioNotes],
            _ payments: [CustOrderLoadFolioPayments],
            _ charges: [CustOrderLoadFolioCharges],
            _ pocs: [CustPOCInventoryOrderView],
            _ files: [CustOrderLoadFolioFiles],
            _ equipments: [CustOrderLoadFolioEquipments],
            _ rentals: [CustPOCRentalsMin],
            _ transferOrder: CustTranferManager?,
            _ orderHighPriorityNote: [HighPriorityNote],
            _ accountHighPriorityNote: [HighPriorityNote],
            _ tasks: [CustTaskAuthorizationManagerQuick],
            _ orderRoute: CustOrderRoute?,
            _ loadFromCatch: Bool
        ) -> ())
    ){
        
        if let order = orderCatch[id] {
            
            guard let account = acctMinCatch[id] else {
                return
            }
            
            let notes: [CustOrderLoadFolioNotes] = notesCatch[id] ?? []
            let payments: [CustOrderLoadFolioPayments] = paymentsCatch[id] ?? []
            let charges: [CustOrderLoadFolioCharges] = chargesCatch[id] ?? []
            let pocs: [CustPOCInventoryOrderView] = pocsCatch[id] ?? []
            let files: [CustOrderLoadFolioFiles] = filesCatch[id] ?? []
            let equipments: [CustOrderLoadFolioEquipments] = equipmentsCatch[id] ?? []
            let rentals: [CustPOCRentalsMin] = rentalsCatch[id] ?? []
            let orderHighPriorityNote: [HighPriorityNote] = orderHighPriorityNoteCatch[id] ?? []
            let accountHighPriorityNote: [HighPriorityNote] = accountHighPriorityNoteCatch[id] ?? []
            let tasks: [CustTaskAuthorizationManagerQuick] = tasksCatch[id] ?? []
            let routeCatch = custOrderRouteCatch[id]
            let transferOrder: CustTranferManager? = transferOrderCatch[id]
            
            acctType = account.type
            
            callback(
                account,
                order,
                notes,
                payments,
                charges,
                pocs,
                files,
                equipments,
                rentals,
                transferOrder,
                orderHighPriorityNote,
                accountHighPriorityNote,
                tasks,
                routeCatch,
                true
            )
            
        }
        else{
            
            loadingView(show: true)
            
            API.custOrderV1.loadOrder(identifier: .id(id), modifiedAt: nil){ resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpectedError("DATA"))
                    return
                }
                
                switch payload {
                case .isUpdated:
                    break
                case .load(let loadOrderResponse):
                    
                    self.acctType = loadOrderResponse.account.type
                    
                    /// Order Detail Catch
                    acctMinCatch[id] = loadOrderResponse.account
                    orderCatch[id] = loadOrderResponse.order
                    notesCatch[id] = loadOrderResponse.notes
                    paymentsCatch[id] = loadOrderResponse.payments
                    chargesCatch[id] = loadOrderResponse.charges
                    pocsCatch[id] = loadOrderResponse.pocs
                    filesCatch[id] = loadOrderResponse.files
                    equipmentsCatch[id] = loadOrderResponse.equipments
                    rentalsCatch[id] = loadOrderResponse.rentals
                    orderHighPriorityNoteCatch[id] = loadOrderResponse.orderHighPriorityNote
                    tasksCatch[id] = loadOrderResponse.tasks
                    accountHighPriorityNoteCatch[id] = loadOrderResponse.accountHighPriorityNote
                    if let route = loadOrderResponse.route {
                        custOrderRouteCatch[id] = route
                    }
                    if let transferOrder = loadOrderResponse.transferOrder {
                        transferOrderCatch[id] = transferOrder
                    }
                    
                    callback(
                        loadOrderResponse.account,
                        loadOrderResponse.order,
                        loadOrderResponse.notes,
                        loadOrderResponse.payments,
                        loadOrderResponse.charges,
                        loadOrderResponse.pocs,
                        loadOrderResponse.files,
                        loadOrderResponse.equipments,
                        loadOrderResponse.rentals,
                        loadOrderResponse.transferOrder,
                        loadOrderResponse.orderHighPriorityNote,
                        loadOrderResponse.accountHighPriorityNote,
                        loadOrderResponse.tasks,
                        loadOrderResponse.route,
                        false
                    )
                    
                }
                
            }
        }
    }
    
    func loadHistorical(){
        
        self.orderViewIsLoaded = true
        self.load = .order
        
        loadingView(show: true)
        
        API.custOrderV1.historicalSearch(
            accountid: id,
            tag1: "",
            tag2: "",
            tag3: "",
            tag4: "",
            description: "",
            timeEnd: getNow(),
            timeInit: 0
        ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
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
            
                
                self.order = nil
                self.orderStatus = nil
                self.orderView.innerHTML = ""
                
                self._orderView = nil
                
                if !data.orders.isEmpty {
                    self.orderView.appendChild(
                        H2("Folios Historicos")
                            .color(.white)
                            .marginBottom(23.px)
                    )
                    data.orders.forEach { data in
                        self.orderView.appendChild(self.orderRowView(data))
                    }
                }
                else{
                    showAlert(.alerta, "Sin resultados")
                }
            }
    }
    
    func loadOrders(){
        
        self.orderViewIsLoaded = true
        
        self.load = .order
        
        loadingView(show: true)
        
        API.custOrderV1.loadFolios(
            storeid: nil,
            accountid: id,
            current: [],
            curTrans: []
        ){ resp in
            
            loadingView(show: false)
            
            guard let resp else {
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
            
            do {
                let data = try JSONEncoder().encode(resp)
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            } catch {
                
            }
            
            let firstView = Div().class(.oneTwo)
            let secondView = Div().class(.oneTwo)
            
            self.order = nil
            self.orderStatus = nil
            self.orderView.innerHTML = ""
            
            self.orderView.appendChild(firstView)
            self.orderView.appendChild(secondView)
            
            self._orderView = nil
            
            if !data.pending.isEmpty {
                firstView.appendChild(H2(CustFolioStatus.pending.description)
                                            .color(CustFolioStatus.pending.color))
                data.pending.forEach { data in
                    firstView.appendChild(self.orderRowView(data))
                }
            }
            
            if !data.pendingSpare.isEmpty {
                firstView.appendChild(H2(CustFolioStatus.pendingSpare.description)
                                            .color(CustFolioStatus.pendingSpare.color))
                data.pendingSpare.forEach { data in
                    firstView.appendChild(self.orderRowView(data))
                }
            }
            
            if !data.active.isEmpty {
                secondView.appendChild(H2(CustFolioStatus.active.description)
                                            .color(CustFolioStatus.active.color))
                data.active.forEach { data in
                    secondView.appendChild(self.orderRowView(data))
                }
            }
            
            if !data.pendingPickup.isEmpty {
                secondView.appendChild(H2(CustFolioStatus.finalize.description)
                                            .color(CustFolioStatus.finalize.color))
                data.pendingPickup.forEach { data in
                    secondView.appendChild(self.orderRowView(data))
                }
            }
            
        }
        
    }
    
    func loadFiscal() {
        showAlert(.alerta, "loading fiscal")
        self.fiscalViewIsLoaded = true
        self.load = .fiscal
    }
    
    func loadMetrics() {
        showAlert(.alerta, "loading metrics")
        self.metricsViewIsLoaded = true
        self.load = .metrics
    }
    
    func orderRowView(_ data: CustOrderLoadFolios) -> Div {
        OrderRowView(data: data, callback: { action in
            if let action = action {
                switch action {
                case .open:
                    
                    /// Search If their is a acctid refrence
                    if let accountid = minViewOrderAccountRefrence[data.id] {
                        /// Search if AccoutOverview is available
                        if let accoutOverview = minViewAcctRefrence[accountid] {
                            if accoutOverview.order?.id == data.id {
                                /// The current order is lodad only show
                                /// remove small button
                                minViewDivRefrence[accountid]?.remove()
                                ///  remove small button refrence
                                minViewDivRefrence.removeValue(forKey: accountid)
                                /// Show AccoutOverview
                                accoutOverview.display(.block)
                                return
                            }
                            else{
                                /// Load Order
                                /// remove small button
                                minViewDivRefrence[accountid]?.remove()
                                ///  remove small button refrence
                                minViewDivRefrence.removeValue(forKey: accountid)
                                /// Show AccoutOverview
                                accoutOverview.display(.block)
                                
                                accoutOverview.loadOrder(id: data.id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                                    accoutOverview.loadOrder(
                                        account: account,
                                        order: order,
                                        notes: notes,
                                        payments: payments,
                                        charges: charges,
                                        pocs: pocs,
                                        files: files,
                                        equipments: equipments,
                                        rentals: rentals,
                                        transferOrder: transferOrder,
                                        orderHighPriorityNote: orderHighPriorityNote,
                                        accountHighPriorityNote: accountHighPriorityNote,
                                        tasks: tasks,
                                        orderRoute: route,
                                        loadFromCatch: loadFromCatch
                                    )
                                    
                                    accoutOverview.load = .order
                                    
                                }
                                return
                            }
                        }
                    }
                    
                    self.loadOrder(id: data.id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                        let accoutOverview = AccoutOverview (
                            id: .id(order.custAcct)
                        )
                        accoutOverview.loadOrder(
                            account: account,
                            order: order,
                            notes: notes,
                            payments: payments,
                            charges: charges,
                            pocs: pocs,
                            files: files,
                            equipments: equipments,
                            rentals: rentals,
                            transferOrder: transferOrder,
                            orderHighPriorityNote: orderHighPriorityNote,
                            accountHighPriorityNote: accountHighPriorityNote,
                            tasks: tasks,
                            orderRoute: route,
                            loadFromCatch: loadFromCatch
                        )
                        self.appendChild(accoutOverview)
                    }
                case .print:
                    self.loadOrder(id: data.id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                        let printBody = OrderPrintEngine(
                            order: order,
                            notes: notes,
                            payments: payments,
                            charges: charges,
                            pocs: pocs,
                            files: files,
                            equipments: equipments,
                            rentals: rentals,
                            transferOrder: transferOrder
                        ).innerHTML
                        _ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                    }
                case .alert:
                    break
                case .addNote:
                    self.appendChild(
                        QuickMessageView(style: .light, order: data, notes: [], callback: { note in
                            
                        })
                    )
                case .date:
                    break
                case .adopt:
                    break
                case .finalize:
                    break
                case .cancel:
                    break
                }
            }
        })
    }

    func hideView(){
        
        var viewName =  ""
        
        var accountid: UUID? = nil
        
        if let id = self.account?.id {
            accountid = id
        }
        else if let id = self.order?.custAcct {
            accountid = id
        }
        
        guard let accountid else {
            return
        }
        
        var borderColor: Color = .white
        
        // is working in order
        if let order = self.order {
            
            if order.folio.contains("-") {
                let parts = order.folio.explode("-")
                if parts.count > 1 {
                    viewName = parts[1]
                }
            }
            else{
                viewName = order.folio
            }
            
            viewName = ("\(viewName) \(order.name)")
            
            borderColor = order.status.color
            
            
        }
        else if let account = self.account {
            viewName = account.folio
        }
        else{
            viewName = "NA"
        }
        
        let view = Div(viewName)
            .float(.left)
            .cursor(.pointer)
            .border(width: .medium, style: .solid, color: borderColor)
            .borderRadius(all: 12.px)
            .color(.white)
            .fontSize(23.px)
            .margin(all: 7.px)
            .padding(all: 7.px)
            .backgroundColor(.transparentBlack)
            .width(200.px)
            .class(.oneLineText)
            .onClick { div in
                self.display(.block)
                
                minViewDivRefrence.removeValue(forKey: accountid)
                
                div.remove()
            }
        
        minViewDivRefrence[accountid] = view
        
        WebApp.current.minimizedGrid.appendChild(view)
        
        self.display(.none)
        
    }

    // goten
    func startServiceOrder(account: CustAcct){
        
        let view = StartServiceOrder(
            custAcct: .init(
                id: account.id,
                folio: account.folio,
                businessName: account.businessName,
                costType: account.costType,
                type: account.type,
                firstName: account.firstName,
                lastName: account.lastName,
                mcc: account.mcc,
                mobile: account.mobile,
                email: account.email,
                street: account.street,
                colony: account.colony,
                city: account.city,
                state: account.state,
                zip: account.zip,
                country: account.country,
                autoPaySpei: account.autoPaySpei,
                autoPayOxxo: account.autoPayOxxo,
                fiscalProfile: account.fiscalProfile,
                fiscalRazon: account.fiscalRazon,
                fiscalRfc: account.fiscalRfc,
                fiscalRegime: account.fiscalRegime,
                fiscalZip: account.fiscalZip,
                cfdiUse: account.cfdiUse,
                CardID: account.CardID, 
                rewardsLevel: account.rewardsLevel,
                crstatus: account.crstatus, 
                isConcessionaire: account.isConcessionaire,
                highPriorityNotes: []
            )
        ) { orderid, _, cfiles in
            
            OrderCatchControler.shared.loadFolio(orderid: orderid) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                
                self.loadOrder(
                    account: account,
                    order: order,
                    notes: notes,
                    payments: payments,
                    charges: charges,
                    pocs: pocs,
                    files: files,
                    equipments: equipments,
                    rentals: rentals,
                    transferOrder: transferOrder,
                    orderHighPriorityNote: orderHighPriorityNote,
                    accountHighPriorityNote: accountHighPriorityNote,
                    tasks: tasks,
                    orderRoute: route,
                    loadFromCatch: loadFromCatch
                )
                
                self._orderView?.printOrder()
                
                //let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                //_ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                
            }
            
        }
        
        addToDom(view)
    }
}

