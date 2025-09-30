//
//  OrderCatchControler.swift
//  
//
//  Created by Victor Cantu on 10/20/23.
//

import Foundation
import TCFundamentals
import Web

private var orderCatchControler = OrderCatchControler()

public class OrderCatchControler {
    
    static var shared: OrderCatchControler { orderCatchControler }
    
    @State var viewType: OrderViewType
    
    let ws = WS()
    
    init(){

        self.viewType = OrderViewType(rawValue: (WebApp.current.window.localStorage.string(forKey: "viewType") ?? "")) ?? .listView
        
        $viewType.listen {
            self.drawOrderView()
        }
        
        $loadOrderStatusType.listen {
            self.executeSearch()
        }
        
        $selectedStore.listen {
            if !self.selectedStoreFirstLoad {
                self.selectedStoreFirstLoad = true
                return
            }
            self.executeSearch()
        }
        
        WebApp.current.wsevent.listen {


            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event = event else {
                return
            }

            if event == .customerOrderStatusUpdate {
                if let payload = self.ws.customerOrderStatusUpdate($0) {
                    self.updateOrderStatus(payload.orderId, payload.status)
                }
            }
        }
    }
    
    /// Controls last time the orders where reloaded (manualy or cron trask). To avoid un neserary cron reloads
    private var lastSync: Int64 = 0
    
    @State var selectStoreMenuIsHidden = true
    
    @State var loadOrderStatusTypeIsHidden = true
    
    @State var stores: [CustStoreBasic] = []
    
    var selectedStoreFirstLoad = false
    
    @State var selectedStore: CustStoreBasic? = nil
    
    @State var selectedStatusFilter: CustFolioStatus? = nil
    
    @State var loadOrderStatusType: LoadOrderStatusType = .general
    
    @State var emailViewHeight: Int = 220
    
    /// Ordes that have not been adopted
    private var pending: [CustOrderLoadFolios] = []
    
    /// Ordes that have been adopted but awaiting  a spare parte
    private var pendingSpare: [CustOrderLoadFolios] = []
    
    private var active: [CustOrderLoadFolios] = []
    
    private var pendingPickup: [CustOrderLoadFolios] = []
    
    /// Orders that have ather status
    private var other: [CustOrderLoadFolios] = []
    
    private var inOrder: [CustOrderLoadFolios] = []
    
    private var outOrder: [CustOrderLoadFolios] = []
    
    private var inDelegate: [CustTranferManager] = []
    
    private var outDelegate: [CustTranferManager] = []
    
    private var routes: [CustOrderRoute] = []
    
    private var delete: [UUID] = []
    
    private var deleteDelegates: [UUID] = []
    
    /// [ CustOrder.id :  OrderRowView]
    private var orderRowViewRefrence: [UUID:OrderRowView] = [:]
    
    lazy var listViewButton = Img()
        .src("/skyline/media/icon_list.png")
        .class(self.$viewType.map{$0 == .listView ?  .iconBlue : .iconWhite})
        .marginLeft(18.px)
        .height(28.px)
        .onClick { img, event in
            if self.viewType == .listView { return }
            self.viewType = .listView
            img.removeClass(.iconWhite)
            WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
        }
    
    lazy var calendarViewButton = Img()
        .src("/skyline/media/icon_calendar.png")
        .class(self.$viewType.map{$0 == .calendarView ? .iconBlue : .iconWhite})
        .marginLeft(18.px)
        .height(28.px)
        .onClick { img, event in
            if self.viewType == .calendarView { return }
            self.viewType = .calendarView
            img.removeClass(.iconWhite)
            WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
        }
    
    lazy var userViewButton = Img()
        .src("/skyline/media/icon_user.png")
        .class(self.$viewType.map{$0 == .userView ? .iconBlue : .iconWhite})
        .marginLeft(18.px)
        .height(28.px)
        .onClick { img, event in
            if self.viewType == .userView { return }
            self.viewType = .userView
            img.removeClass(.iconWhite)
            WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
        }
    
    lazy var routeViewButton = Img()
        .src("/skyline/media/icon_route.png")
        .class(self.$viewType.map{$0 == .routeView ? .iconBlue : .iconWhite})
        .marginLeft(18.px)
        .height(28.px)
        .onClick { img, event in
            if self.viewType == .routeView { return }
            self.viewType = .routeView
            img.removeClass(.iconWhite)
            WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
        }
    
    lazy var addRouteButton = Div{
        Div{
            Img()
                .src("/skyline/media/addBlueIcon.png")
                .marginRight(12.px)
                .marginLeft(12.px)
                .marginTop(9.px)
                .height(33.px)
                .width(33.px)
        }
        .align(.center)
        
        Div("Ruta")
            .fontSize(14.px)
            .align(.center)
        
    }
        .hidden(self.$viewType.map{ !($0 == .routeView) })
        .class(.uibtn, .roundBlue)
        .borderRadius(50.percent)
        .position(.absolute)
        .cursor(.pointer)
        .bottom(20.px)
        .right(75.px)
        .height(67.px)
        .width(67.px)
        .onClick {
            self.creteNewRoute()
        }
    
    lazy var emailViewControler = EmailViewControler(mode: .default, switchMode: { mode in
        switch mode {
        case .minimized:
            self.firstView.custom("height", "calc(100% - 42px)")
            self.emailViewHeight = 35
        case .default:
            self.firstView.custom("height", "calc(100% - 227px)")
            self.emailViewHeight = 220
        case .maximized:
            break
        }
    })
        .height(self.$emailViewHeight.map{ $0.px})
        .class(.roundGrayBlackDark)
        .marginTop(5.px)
    
    lazy var firstView = Div()
        .custom("height", "calc(100% - 227px)")
        .overflow(.auto)
        .class(.roundGrayBlackDark)
    
    lazy var container = Div{
        self.firstView
        self.emailViewControler
    }
    .custom("height", "calc(100% - 0px)")
    .overflow(.hidden)
    .class(.oneHalf)
    
    lazy var secondView = Div()
        .custom("height", "calc(100% - 0px)")
        .class(.roundGrayBlackDark, .oneHalf)
        .overflow(.auto)
    
    lazy var selectStoreMenuButton = Div{
        
        Div{
            
            Div(self.$selectedStore.map{ $0?.name ?? "Todas las tienda" })
                .custom("width", "calc(100% - 45px)")
                .class(.oneLineText)
                .marginLeft(7.px)
                .fontSize(22.px)
                .float(.left)
             
             Div{
                 Img()
                     .src(self.$selectStoreMenuIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
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
            
             Div().clear(.both)
             
         }
        .width(207.px)
        .class(.uibtn)
        .onClick { _, event in
            self.selectStoreMenuIsHidden = !self.selectStoreMenuIsHidden
            event.stopPropagation()
        }
        
        Div{
            
            Div("Todas las Tiendas")
                .hidden(self.$selectedStore.map{ $0 == nil })
                .class(.oneLineText)
                .width(90.percent)
                .marginTop(7.px)
                .fontSize(20.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.selectedStore = nil
                    self.selectStoreMenuIsHidden = true
                    event.stopPropagation()
                }
            
            ForEach(self.$stores) { store in
                Div(store.name)
                    .hidden(self.$selectedStore.map{ store.id == $0?.id })
                    .class(.oneLineText)
                    .width(90.percent)
                    .marginTop(7.px)
                    .fontSize(20.px)
                    .class(.uibtn)
                    .onClick { _, event in
                        self.selectedStore = store
                        self.selectStoreMenuIsHidden = true
                        event.stopPropagation()
                    }
            }
            
            Div().height(12.px)
        }
        .hidden(self.$selectStoreMenuIsHidden)
        .backgroundColor(.transparentBlack)
        .position(.absolute)
        .borderRadius(12.px)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .marginTop(7.px)
        .width(250.px)
        .zIndex(1)
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    
    lazy var loadOrderStatusButton = Div{
        
        Div{
            
            Div{
                Img()
                    .src("/skyline/media/reload.png")
                    .marginTop(5.px)
                    .height(18.px)
            }
            .marginLeft(7.px)
            .float(.left)
            
            Div(self.$loadOrderStatusType.map{ $0.description })
                .custom("width", "calc(100% - 70px)")
                .class(.oneLineText)
                .marginLeft(7.px)
                .fontSize(22.px)
                .float(.left)
             
             Div{
                 Img()
                     .src(self.$loadOrderStatusTypeIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
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
                 self.loadOrderStatusTypeIsHidden = !self.loadOrderStatusTypeIsHidden
                 event.stopPropagation()
             }
             Div().clear(.both)
             
         }
        .width(207.px)
        .class(.uibtn)
        .onClick { _, event in
            self.executeSearch()
            event.stopPropagation()
        }
        
        Div{
            
            Div(LoadOrderStatusType.general.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .general })
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .general
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(OrderState.inBudget.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byState(.inBudget) })
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byState(.inBudget)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(OrderState.alerted.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byState(.alerted) })
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byState(.alerted)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(OrderState.highPriority.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byState(.highPriority) })
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byState(.highPriority)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(CustFolioStatus.saleWait.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byStatus(.saleWait) })
                .color(CustFolioStatus.saleWait.color)
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byStatus(.saleWait)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(CustFolioStatus.archive.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byStatus(.archive) })
                .color(CustFolioStatus.archive.color)
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byStatus(.archive)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(CustFolioStatus.finalize.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byStatus(.finalize) })
                .color(CustFolioStatus.finalize.color)
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byStatus(.finalize)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(CustFolioStatus.canceled.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byStatus(.canceled) })
                .color(CustFolioStatus.canceled.color)
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byStatus(.canceled)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div(CustFolioStatus.collection.description)
                .hidden(self.$loadOrderStatusType.map{ $0 == .byStatus(.collection) })
                .color(CustFolioStatus.collection.color)
                .class(.oneLineText)
                .width(90.percent)
                .fontSize(22.px)
                .marginTop(7.px)
                .class(.uibtn)
                .onClick { _, event in
                    self.loadOrderStatusType = .byStatus(.collection)
                    self.loadOrderStatusTypeIsHidden = true
                    event.stopPropagation()
                }
            
            Div().height(12.px)
            
        }
        .hidden(self.$loadOrderStatusTypeIsHidden)
        .backgroundColor(.transparentBlack)
        .position(.absolute)
        .borderRadius(12.px)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .marginTop(7.px)
        .width(207.px)
        .zIndex(1)
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    
    /// Executes a search on acording set loadOrderStatusType values
    func executeSearch(){
        switch loadOrderStatusType {
        case .general:
            self.sincFolio(
                accountid: nil,
                current: [],
                curTrans: []
            )
        case .byState(let state):
            self.sincByState(state)
        case .byStatus(let status):
            self.sincByStatus(status)
        }
    }
    
    func sincByState(_ state: OrderState) {
        
        loadingView(show: true)
        
        API.custOrderV1.loadOrdersByState(
            state: state,
            store: self.selectedStore?.id,
            account: nil
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
            
            guard let orders = resp.data?.orders else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.pending.removeAll()
            self.pendingSpare.removeAll()
            self.active.removeAll()
            self.pendingPickup.removeAll()
            self.other.removeAll()
            
            self.inOrder.removeAll()
            self.outOrder .removeAll()
            
            self.inDelegate.removeAll()
            self.outDelegate.removeAll()
            
            self.other = orders
            
            self.drawOrderView()
            
        }
        
    }
    
    func sincByStatus(_ status: CustFolioStatus) {
        
        loadingView(show: true)
        
        API.custOrderV1.loadOrderByStatus(
            status: status,
            store: self.selectedStore?.id,
            account: nil
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
            
            guard let orders = resp.data?.orders else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            
            self.pending.removeAll()
            self.pendingSpare.removeAll()
            self.active.removeAll()
            self.pendingPickup.removeAll()
            self.other.removeAll()
            
            self.inOrder.removeAll()
            self.outOrder .removeAll()
            
            self.inDelegate.removeAll()
            self.outDelegate.removeAll()
            
            switch status {
            case .pending:
                self.pending = orders
            case .active:
                self.active = orders
            case .pendingSpare:
                self.pendingSpare = orders
            case .canceled, .finalize:
                self.pendingPickup = orders
            case .archive, .collection, .sideStatus, .saleWait:
                self.other = orders
            }
            
            self.drawOrderView()
            
            
        }
    }
    
    func sincFolio(
        accountid: HybridIdentifier?,
        current: [APIStoreSincObject],
        curTrans: [APIStoreSincObject]
    ){
        loadingView(show: true)
        
        API.custOrderV1.loadFolios(
            storeid: selectedStore?.id,
            accountid: accountid,
            current: current,
            curTrans: curTrans
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servidor")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.pending = data.pending
            self.pendingSpare = data.pendingSpare
            self.active = data.active
            self.pendingPickup = data.pendingPickup
            
            self.other.removeAll()
            
            self.inOrder = data.inOrder
            self.outOrder = data.outOrder
            
            self.inDelegate = data.inDelegate
            self.outDelegate = data.outDelegate
            
            self.routes = data.routes
            
            self.drawOrderView()
            
        }
    }
    
    func updateParameter(_ orderId: UUID, _ parameter: Parameter){
        
        switch parameter {
        case .budgetStatus(let custBudgetManagerStatus):
            orderCatch[orderId]?.budget = custBudgetManagerStatus
            if custBudgetManagerStatus == nil {
                orderCatch[orderId]?.budgetRequest = nil
            }
            
            orderRowViewRefrence.forEach { id, view in
                if orderId == id {
                    view.budget = custBudgetManagerStatus
                }
            }

        case .orderStatus(let custFolioStatus):


            customerOrderStatusUpdate(orderId: orderId, status: custFolioStatus)

            updateOrderStatus(orderId, custFolioStatus)

        case .orderBalance(let balance):
            break
        case .orderDate(let date):
            break
        case .onWorkUser(let userId):
            break
        case .alertStatus(let isAlerted):
            
            orderCatch[orderId]?.alerted = isAlerted
            
            orderRowViewRefrence.forEach { id, view in
                if orderId == id {
                    view.alerted = isAlerted
                }
            }
            
            //drawOrderView()
            
        case .hightPriorityStatus(let isHighPriority):
            
            orderCatch[orderId]?.highPriority = isHighPriority
            
            orderRowViewRefrence.forEach { id, view in
                if orderId == id {
                    print("🟢  found view !!")
                    view.highPriority = isHighPriority
                }
            }
            
            //drawOrderView()
            
        case .pendingPickup(let isPendingPickup):
            break
        case .newOrder(let order):
            break
        case .files(let files):

            guard let _ = filesCatch[orderId] else {
                return
            }

            filesCatch[orderId]?.append(contentsOf: files)

        }
        
    }
    

    func updateOrderStatus(_ orderId: UUID, _ custFolioStatus: CustFolioStatus){
        
            var order: CustOrderLoadFolios? = nil
            
            var uiview: OrderRowView? = nil
            
            /// WEBSOCKET

            orderRowViewRefrence.forEach { id, view in
                if orderId == id {
                    order = view.data
                    uiview = view
                }
            }
            
            guard var order else {
                print("🟢 🟡   OrderCatchControler  No se localizo orden")
                return
            }
            
            if order.status == custFolioStatus {
                print("🟢 🟡  OrderCatchControler  same status")
                return
            }
            
            uiview?.remove()
            
            orderCatch[orderId]?.status = custFolioStatus        
            
            orderRowViewRefrence[order.id]?.data.status = custFolioStatus
            
            order.status = custFolioStatus
            
            var updated: [CustOrderLoadFolios] = []
            pending.forEach { _order in
                if _order.id == orderId {
                    return
                }
                updated.append(_order)
            }
            pending = updated
            
            updated = []
            print("active \(active.count)")
            active.forEach { _order in
                
                print("\(_order.id.uuidString) vs \(orderId.uuidString)")
                
                if _order.id == orderId {
                    return
                }
                updated.append(_order)
            }
            active = updated
            
            updated = []
            pendingSpare.forEach { _order in
                if _order.id == orderId {
                    return
                }
                updated.append(_order)
            }
            pendingSpare = updated
            
            updated = []
            pendingPickup.forEach { _order in
                if _order.id == orderId {
                    return
                }
                updated.append(_order)
            }
            pendingPickup = updated
            
            switch custFolioStatus {
            case .pending:
                print("💎 add to pending")
                pending.append(order)
            case .active:
                print("💎 add to active")
                active.append(order)
            case .pendingSpare:
                print("💎 add to pendingSpare")
                pendingSpare.append(order)
            case .canceled, .finalize:
                print("💎 add to pendingPickup")
                pendingPickup.append(order)
            case .archive, .collection, .sideStatus, .saleWait:
                return
            }
            
            self.drawOrderView()
            
    }

    func drawOrderView(){
        
        orderRowViewRefrence.forEach { id, view in
            view.remove()
        }
        
        firstView.innerHTML = ""
        container.removeClass(.oneHalf)
        container.removeClass(.oneThirdOrderGrid)
        
        secondView.innerHTML = ""
        secondView.removeClass(.oneHalf)
        secondView.removeClass(.twoThirdOrderGrid)
        
        let totalItems: Int = [
            pending.count,
            pendingSpare.count,
            active.count,
            pendingPickup.count,
            other.count,
            inOrder.count,
            outOrder.count
        ].reduce(0, +)
        
        if totalItems > 35 {
            loadingView(show: true)
        }
        
        let orderCount = [
            pending.count,
            pendingSpare.count,
            active.count,
            pendingPickup.count,
            inOrder.count,
            outOrder.count,
            outDelegate.count
        ].reduce(0, +)
        
        switch viewType {
        case .listView:
        
            /// Set view layout
            container.class(.oneHalf)
            secondView.class([.oneHalf, .roundGrayBlackDark])
            
            /// View One
            if !pending.isEmpty {
                
                self.firstView.appendChild(
                    H2{
                        Span(CustFolioStatus.pending.description)
                            .color(CustFolioStatus.pending.color)
                        
                        Span(self.pending.count.toString)
                            .marginLeft(12.px)
                            .opacity(0.5)
                            .color(.gray)
                    }
                        .margin(all: 7.px)
                )
                    
                pending.forEach { data in
                    firstView.appendChild(orderRowView(data))
                }
            }
            if !pendingSpare.isEmpty {
                
                firstView.appendChild(
                    H2{
                        Span(CustFolioStatus.pendingSpare.description)
                            .color(CustFolioStatus.pendingSpare.color)
                        
                        Span(self.pendingSpare.count.toString)
                            .marginLeft(12.px)
                            .opacity(0.5)
                            .color(.gray)
                    }
                        
                        .margin(all: 7.px)
                )
                
                pendingSpare.forEach { data in
                    firstView.appendChild(orderRowView(data))
                }
            }
            if !inOrder.isEmpty {
                
            }
            if !outOrder.isEmpty {
                
            }
            if !inDelegate.isEmpty {
                
            }
            if !outDelegate.isEmpty {
                
            }
            
            /// View Two
            if !active.isEmpty {
                
                self.secondView.appendChild(
                    H2{
                        Span(CustFolioStatus.active.description)
                            .color(CustFolioStatus.active.color)
                        
                        Span(self.active.count.toString)
                            .marginLeft(12.px)
                            .opacity(0.5)
                            .color(.gray)
                    }
                    .margin(all: 7.px)
                    
                )
                
                active.forEach { data in
                    secondView.appendChild(self.orderRowView(data))
                }
            }
            if !pendingPickup.isEmpty {
                
                secondView.appendChild(
                    H2{
                        Span(CustFolioStatus.finalize.description)
                            .color(CustFolioStatus.finalize.color)
                        
                        Span(self.pendingPickup.count.toString)
                            .marginLeft(12.px)
                            .opacity(0.5)
                            .color(.gray)
                    }
                    .margin(all: 7.px)
                )
                
                pendingPickup.forEach { data in
                    secondView.appendChild(self.orderRowView(data))
                }
            }
            
            if orderCount > 0 {
                
                self.other.forEach { item in
                    self.secondView.appendChild(self.orderRowView(item))
                }
                
            }
            else {
                var cc = 0
                self.other.forEach { item in
                    if cc.isEven {
                        self.firstView.appendChild(self.orderRowView(item))
                    }
                    else {
                        self.secondView.appendChild(self.orderRowView(item))
                    }
                    cc += 1
                }
            }
            
        case .calendarView:
            
            /// Set view layout
            secondView.removeClass(.roundGrayBlackDark)
            container.class(.oneThirdOrderGrid)
            secondView.class(.twoThirdOrderGrid)

            var generalPayload: [CustOrderLoadFolios] = []
            var workMap: [
                Int: [
                    Int: [
                        Int: [CustOrderLoadFolios]
                    ]
                ]
            ] = [:]
            
            let now = getNow()
            
            pending.forEach { order in
                if let due = order.due {
                    /// has date
                    if now < due {
                        
                        let date = getDate(due)
                        let day = date.day
                        let month = date.month
                        let year = date.year
                        
                        if let _ = workMap[year] {
                            if let _ = workMap[year]![month]{
                                if let _ = workMap[year]![month]![day] {
                                    workMap[year]![month]![day]!.append(order)
                                }
                                else{
                                    workMap[year]![month]![day] = [order]
                                }
                            }
                            else{
                                workMap[year]![month] = [ day: [order] ]
                            }
                        }
                        else {
                            workMap[year] = [
                                month: [ day: [order] ]
                            ]
                        }
                        
                    }
                    else{
                        /// This is alredy due  so it now part of general payload
                        generalPayload.append(order)
                    }
                }
                else {
                    /// General Payload
                    generalPayload.append(order)
                }
            }
            
            self.pendingSpare.forEach { order in
                if let due = order.due {
                    /// has date
                    if now < due {
                        
                        let date = getDate(due)
                        let day = date.day
                        let month = date.month
                        let year = date.year
                        
                        if let _ = workMap[year] {
                            if let _ = workMap[year]![month]{
                                if let _ = workMap[year]![month]![day] {
                                    workMap[year]![month]![day]!.append(order)
                                }
                                else{
                                    workMap[year]![month]![day] = [order]
                                }
                            }
                            else{
                                workMap[year]![month] = [ day: [order] ]
                            }
                        }
                        else{
                            workMap[year] = [
                                month: [ day: [order] ]
                            ]
                        }
                        
                    }
                    else{
                        /// This is alredy due  so it now part of general payload
                        generalPayload.append(order)
                    }
                }
                else {
                    /// General Payload
                    generalPayload.append(order)
                }
            }
            
            self.active.forEach { order in
                if let due = order.due {
                    /// has date
                    if now < due {
                        
                        let date = getDate(due)
                        let day = date.day
                        let month = date.month
                        let year = date.year
                        
                        if let _ = workMap[year] {
                            if let _ = workMap[year]![month]{
                                if let _ = workMap[year]![month]![day] {
                                    workMap[year]![month]![day]!.append(order)
                                }
                                else{
                                    workMap[year]![month]![day] = [order]
                                }
                            }
                            else{
                                workMap[year]![month] = [ day: [order] ]
                            }
                        }
                        else {
                            workMap[year] = [
                                month: [ day: [order] ]
                            ]
                        }
                        
                    }
                    else {
                        /// This is alredy due  so it now part of general payload
                        generalPayload.append(order)
                    }
                }
                else {
                    /// General Payload
                    generalPayload.append(order)
                }
            }
            
            self.pendingPickup.forEach { order in
                if let due = order.due {
                    /// has date
                    if now < due {
                        
                        let date = getDate(due)
                        let day = date.day
                        let month = date.month
                        let year = date.year
                        
                        if let _ = workMap[year] {
                            if let _ = workMap[year]![month]{
                                if let _ = workMap[year]![month]![day] {
                                    workMap[year]![month]![day]!.append(order)
                                }
                                else{
                                    workMap[year]![month]![day] = [order]
                                }
                            }
                            else{
                                workMap[year]![month] = [ day: [order] ]
                            }
                        }
                        else{
                            workMap[year] = [
                                month: [ day: [order] ]
                            ]
                        }
                        
                    }
                    else {
                        /// This is alredy due  so it now part of general payload
                        generalPayload.append(order)
                    }
                }
                else {
                    /// General Payload
                    generalPayload.append(order)
                }
            }
            
            self.firstView.appendChild(H1("Sin Cita / Vencidos \(generalPayload.count.toString)").color(.white).marginBottom(7.px))
            
            /// View One
            generalPayload.forEach { data in
                self.firstView.appendChild(self.orderRowView(data))
            }
            
            /// View Two
            self.secondView.appendChild(OrderCalendarView(selectedDateStamp: "", __workMap: workMap, callback: { selectedDateStamp, uts, highPriority in
                
            }))
            
            self.other.forEach { item in
                self.firstView.appendChild(self.orderRowView(item))
            }
            
        case .userView:
        
            /// Set view layout
            container.class(.oneHalf)
            secondView.class([.oneHalf, .roundGrayBlackDark])
            
            getUsers(storeid: nil, onlyActive: false) { users in
                
                let userRefrence = Dictionary(uniqueKeysWithValues: users.map{ value in ( value.id, value) })
                
                var userByName = users.map{ $0.username }.sorted()
                
                var userIdsByUsernameSorted: [UUID] = []
                
                userByName.forEach { username in
                    userRefrence.forEach { id, udata in
                        if username == udata.username {
                            userIdsByUsernameSorted.append(id)
                        }
                    }
                }
                
                /// View One
                if !self.pending.isEmpty {
                    
                    var orderRefrence: [UUID?:[CustOrderLoadFolios]] = [:]
                    
                    self.firstView.appendChild(
                        H2{
                            Span(CustFolioStatus.pending.description)
                                .color(CustFolioStatus.pending.color)
                            
                            Span(self.pending.count.toString)
                                .marginLeft(12.px)
                                .opacity(0.5)
                                .color(.gray)
                        }
                        .margin(all: 7.px)
                    )
                        
                    self.pending.forEach { data in
                        if let _ = orderRefrence[data.activeUser] {
                            orderRefrence[data.activeUser]?.append(data)
                        }
                        else {
                            orderRefrence[data.activeUser] = [data]
                        }
                    }
                    
                    orderRefrence.forEach { userId, items in
                        
                        var userName = "USER_ND"
                        
                        if let userId {
                            if let udata = userRefrence[userId] {
                                userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                            }
                        }
                        
                        self.firstView.appendChild(
                            Div{
                                
                                H2(items.count.toString)
                                    .marginLeft(7.px)
                                    .float(.right)
                                    .opacity(0.5)
                                    .color(.gray)
                                
                                H2(userName)
                                    .color(CustFolioStatus.pending.color)
                                    .float(.right)
                                
                                Div().clear(.both)
                                
                            }.margin(all: 7.px)
                        )
                        
                        items.forEach { item in
                            self.firstView.appendChild(self.orderRowView(item))
                        }
                    }
                    
                }
                if !self.pendingSpare.isEmpty {
                    
                    var orderRefrence: [UUID?:[CustOrderLoadFolios]] = [:]
                    
                    self.firstView.appendChild(
                        H2{
                            Span(CustFolioStatus.pendingSpare.description)
                                .color(CustFolioStatus.pendingSpare.color)
                            
                            Span(self.pendingSpare.count.toString)
                                .marginLeft(12.px)
                                .opacity(0.5)
                                .color(.gray)
                        }
                        .margin(all: 7.px)
                    )
                        
                    self.pendingSpare.forEach { data in
                        if let _ = orderRefrence[data.activeUser] {
                            orderRefrence[data.activeUser]?.append(data)
                        }
                        else {
                            orderRefrence[data.activeUser] = [data]
                        }
                    }
                    
                    orderRefrence.forEach { userId, items in
                        
                        var userName = "USER_ND"
                        
                        if let userId {
                            if let udata = userRefrence[userId] {
                                userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                            }
                        }
                        
                        self.firstView.appendChild(
                            Div{
                                
                                H2(items.count.toString)
                                    .marginLeft(7.px)
                                    .float(.right)
                                    .opacity(0.5)
                                    .color(.gray)
                                
                                H2(userName)
                                    .color(CustFolioStatus.pendingSpare.color)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }.margin(all: 7.px)
                        )
                        
                        items.forEach { item in
                            self.firstView.appendChild(self.orderRowView(item))
                        }
                    }
                    
                }
                if !self.inOrder.isEmpty {
                    
                }
                if !self.outOrder.isEmpty {
                    
                }
                if !self.inDelegate.isEmpty {
                    
                }
                if !self.outDelegate.isEmpty {
                    
                }
                
                /// View Two
                if !self.active.isEmpty {
                    
                    var orderRefrence: [UUID?:[CustOrderLoadFolios]] = [:]
                    
                    self.secondView.appendChild(
                        H2{
                            Span(CustFolioStatus.active.description)
                                .color(CustFolioStatus.active.color)
                            
                            Span(self.active.count.toString)
                                .marginLeft(12.px)
                                .opacity(0.5)
                                .color(.gray)
                        }
                        .margin(all: 7.px)
                    )
                    
                    self.active.forEach { data in
                        if let _ = orderRefrence[data.activeUser] {
                            orderRefrence[data.activeUser]?.append(data)
                        }
                        else {
                            orderRefrence[data.activeUser] = [data]
                        }
                    }
                    
                    orderRefrence.forEach { userId, items in
                        
                        var userName = "USER_ND"
                        
                        if let userId {
                            if let udata = userRefrence[userId] {
                                userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                            }
                        }
                        
                        self.secondView.appendChild(
                            Div{
                                
                                H2(items.count.toString)
                                    .marginLeft(7.px)
                                    .float(.right)
                                    .opacity(0.5)
                                    .color(.gray)
                                
                                H2(userName)
                                    .color(CustFolioStatus.active.color)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }.margin(all: 7.px)
                        )
                        
                        items.forEach { item in
                            self.secondView.appendChild(self.orderRowView(item))
                        }
                    }
                    
                }
                if !self.pendingPickup.isEmpty {
                    
                    var orderRefrence: [UUID?:[CustOrderLoadFolios]] = [:]
                    
                    self.secondView.appendChild(
                        
                        H2{
                            Span(CustFolioStatus.finalize.description)
                                .color(CustFolioStatus.finalize.color)
                            
                            Span(self.pendingPickup.count.toString)
                                .marginLeft(12.px)
                                .opacity(0.5)
                                .color(.gray)
                            
                            Div().clear(.both)
                        }
                        .margin(all: 7.px)
                    )
                    
                    self.pendingPickup.forEach { data in
                        if let _ = orderRefrence[data.activeUser] {
                            orderRefrence[data.activeUser]?.append(data)
                        }
                        else {
                            orderRefrence[data.activeUser] = [data]
                        }
                    }
                    
                    orderRefrence.forEach { userId, items in
                        
                        var userName = "USER_ND"
                        
                        if let userId {
                            if let udata = userRefrence[userId] {
                                userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                            }
                        }
                        
                        self.secondView.appendChild(
                            Div{
                                
                                H2(items.count.toString)
                                    .marginLeft(7.px)
                                    .float(.right)
                                    .opacity(0.5)
                                    .color(.gray)
                                
                                H2(userName)
                                    .color(CustFolioStatus.finalize.color)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }.margin(all: 7.px)
                        )
                        
                        items.forEach { item in
                            self.secondView.appendChild(self.orderRowView(item))
                        }
                    }
                    
                }
                
                if !self.other.isEmpty {
                    
                    var orderRefrence: [UUID?:[CustOrderLoadFolios]] = [:]
                    
                    self.other.forEach { item in
                        if let _ = orderRefrence[item.activeUser] {
                            orderRefrence[item.activeUser]?.append(item)
                        }
                        else {
                            orderRefrence[item.activeUser] = [item]
                        }
                    }
                    
                    userIdsByUsernameSorted.forEach { userId in
                        
                        var userName = "USER_ND"
                    
                        if let udata = userRefrence[userId] {
                            userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                        }
                        
                        if orderCount > 0 {
                            
                            var cc = 0
                            
                            if let orders = orderRefrence[userId] {
                                
                                if cc.isEven {
                                    self.firstView.appendChild(
                                        Div{
                                            H2(orders.count.toString)
                                                .marginLeft(7.px)
                                                .float(.right)
                                                .opacity(0.5)
                                                .color(.gray)
                                            
                                            H2(userName)
                                                .color(.white)
                                                .float(.right)
                                            
                                            Div().clear(.both)
                                        }.margin(all: 7.px)
                                    )
                                    orders.forEach { item in
                                        self.firstView.appendChild(self.orderRowView(item))
                                    }
                                    
                                }
                                else {
                                    self.secondView.appendChild(
                                        Div{
                                            H2(orders.count.toString)
                                                .marginLeft(7.px)
                                                .float(.right)
                                                .opacity(0.5)
                                                .color(.gray)
                                            
                                            H2(userName)
                                                .color(.white)
                                                .float(.right)
                                            
                                            Div().clear(.both)
                                        }.margin(all: 7.px)
                                    )
                                    orders.forEach { item in
                                        self.secondView.appendChild(self.orderRowView(item))
                                    }
                                }
                            }
                        }
                        else {
                            if let orders = orderRefrence[userId] {
                                self.secondView.appendChild(
                                    Div{
                                        H2(orders.count.toString)
                                            .marginLeft(7.px)
                                            .float(.right)
                                            .opacity(0.5)
                                            .color(.gray)
                                        
                                        H2(userName)
                                            .color(.white)
                                            .float(.right)
                                        
                                        Div().clear(.both)
                                    }.margin(all: 7.px)
                                )
                                orders.forEach { item in
                                    self.secondView.appendChild(self.orderRowView(item))
                                }
                            }
                        }
                    }
                }
                
            }
            
        case .routeView:
            drawRouteView()
        }
        
        if totalItems > 35 {
            loadingView(show: false)
        }
        
    }
    
    func orderRowView(_ data: CustOrderLoadFolios) -> OrderRowView {
        
        let view = OrderRowView(data: data, callback: { action in
            if let action {
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
                                
                                accoutOverview.load = .order
                                
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
                    
                    self.loadFolio(orderid: data.id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
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
                        
                        minViewAcctRefrence[order.custAcct] = accoutOverview
                        
                        addToDom(accoutOverview)
                    }
                case .print:
                    self.loadFolio(orderid: data.id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
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
                        _ = JSObject.global.renderPrint!(
                            custCatchUrl,
                            order.folio,
                            order.deepLinkCode,
                            String(order.mobile.suffix(4)),
                            printBody
                        )
                    }
                case .alert:
                    break
                case .addNote:
                    addToDom(QuickMessageView(style: .light, order: data, notes: [], callback: { note in
                        
                    }))
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
        
        orderRowViewRefrence[data.id] = view
        
        return view
        
    }
    
    func loadFolio(
        orderid: UUID,
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
        
        if let accountid = minViewOrderAccountRefrence[orderid] {
            /// Search if AccoutOverview is available
            if let accoutOverview = minViewAcctRefrence[accountid] {
                
                if accoutOverview.order?.id == orderid {
                    /// The current order is lodad only show
                    /// remove small button
                    minViewDivRefrence[accountid]?.remove()
                    ///  remove small button refrence
                    minViewDivRefrence.removeValue(forKey: accountid)
                    /// Show AccoutOverview
                    accoutOverview.display(.block)
                    
                    accoutOverview.load = .order
                    
                    return
                }
                else {
                    
                    /// Load Order
                    /// remove small button
                    minViewDivRefrence[accountid]?.remove()
                    ///  remove small button refrence
                    minViewDivRefrence.removeValue(forKey: accountid)
                    /// Show AccoutOverview
                    accoutOverview.display(.block)
                    
                    accoutOverview.loadOrder(id: orderid) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, orderRoute, loadFromCatch in
                        
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
                            orderRoute: orderRoute,
                            loadFromCatch: loadFromCatch
                        )
                        
                        accoutOverview.load = .order
                        
                    }
                    return
                }
            
            }
        }
        
        if let order = orderCatch[orderid] {
            
            guard let account = acctMinCatch[orderid] else {
                return
            }
            
            let notes: [CustOrderLoadFolioNotes] = notesCatch[orderid] ?? []
            let payments: [CustOrderLoadFolioPayments] = paymentsCatch[orderid] ?? []
            let charges: [CustOrderLoadFolioCharges] = chargesCatch[orderid] ?? []
            let pocs: [CustPOCInventoryOrderView] = pocsCatch[orderid] ?? []
            let files: [CustOrderLoadFolioFiles] = filesCatch[orderid] ?? []
            let equipments: [CustOrderLoadFolioEquipments] = equipmentsCatch[orderid] ?? []
            let rentals: [CustPOCRentalsMin] = rentalsCatch[orderid] ?? []
            let orderHighPriorityNote: [HighPriorityNote] = orderHighPriorityNoteCatch[orderid] ?? []
            let accountHighPriorityNote: [HighPriorityNote] = accountHighPriorityNoteCatch[orderid] ?? []
            let tasks: [CustTaskAuthorizationManagerQuick] = tasksCatch[orderid] ?? []
            let transferOrder: CustTranferManager? = transferOrderCatch[orderid]
            let route: CustOrderRoute? = custOrderRouteCatch[orderid]
            
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
                route,
                true
            )
            
        }
        else{
            
            loadingView(show: true)
            
            API.custOrderV1.loadOrder(identifier: .id(orderid), modifiedAt: nil) { resp in
                
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
                    showError(.unexpectedResult, .payloadDecodError)
                    return
                }
                
                switch payload {
                case .isUpdated:
                    break
                case .load(let loadOrderResponse):
                    
                    /// Order Detail Catch
                    acctMinCatch[orderid] = loadOrderResponse.account
                    orderCatch[orderid] = loadOrderResponse.order
                    notesCatch[orderid] = loadOrderResponse.notes
                    paymentsCatch[orderid] = loadOrderResponse.payments
                    chargesCatch[orderid] = loadOrderResponse.charges
                    pocsCatch[orderid] = loadOrderResponse.pocs
                    filesCatch[orderid] = loadOrderResponse.files
                    equipmentsCatch[orderid] = loadOrderResponse.equipments
                    rentalsCatch[orderid] = loadOrderResponse.rentals
                    orderHighPriorityNoteCatch[orderid] = loadOrderResponse.orderHighPriorityNote
                    accountHighPriorityNoteCatch[orderid] = loadOrderResponse.accountHighPriorityNote
                    tasksCatch[orderid] = loadOrderResponse.tasks
                    if let transferOrder = loadOrderResponse.transferOrder {
                        transferOrderCatch[orderid] = transferOrder
                    }
                    if let route = loadOrderResponse.route {
                        custOrderRouteCatch[orderid] = route
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
    
    func drawRouteView(){
        
        orderRowViewRefrence.removeAll()
        
        container.class(.oneHalf)
        secondView.class([.oneHalf, .roundGrayBlackDark])
        
        var generalPayload: [CustOrderLoadFolios] = []
        
        // MARK: HighPriority | Alerted Orders
        
        pending.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                generalPayload.append(order)
            }
        }
        
        pendingSpare.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                generalPayload.append(order)
            }
        }
        
        active.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                generalPayload.append(order)
            }
        }
        
        pendingPickup.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                generalPayload.append(order)
            }
        }
        
        // MARK: General Orders
        
        pending.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                return
            }
            generalPayload.append(order)
        }
        
        pendingSpare.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                return
            }
            generalPayload.append(order)
        }
        
        active.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                return
            }
            generalPayload.append(order)
        }
        
        pendingPickup.forEach { order in
            if let _ = order.route {
                return
            }
            if order.highPriority || order.alerted {
                return
            }
            generalPayload.append(order)
        }
        
        /// View One
        generalPayload.forEach { data in
            firstView.appendChild(self.orderRowView(data))
        }
        
        if routes.isEmpty {
            secondView.appendChild(Table().noResult(label: "🚚 No hay rutas creadas hasta el momento."))
            return
        }
        
        /// [ CustOrderRoute.id : [CustOrderLoadFolios] ]
        var routesItems: [ UUID : [CustOrderLoadFolios] ] = [:]
        
        /// [ CustOrderRoute.id : CustOrderRoute]
        let routeRefrence: [ UUID : CustOrderRoute ] = Dictionary.init(uniqueKeysWithValues: routes.map{ ($0.id, $0) })
        
        pending.forEach { order in
            
            guard let routeId = order.route else {
                return
            }
            
            if let _ = routesItems[routeId] {
                routesItems[routeId]?.append(order)
            }
            else {
                routesItems[routeId] = [order]
            }
            
        }
        
        pendingSpare.forEach { order in
            
            guard let routeId = order.route else {
                return
            }
            
            if let _ = routesItems[routeId] {
                routesItems[routeId]?.append(order)
            }
            else {
                routesItems[routeId] = [order]
            }
            
        }
        
        active.forEach { order in
            
            guard let routeId = order.route else {
                return
            }
            
            if let _ = routesItems[routeId] {
                routesItems[routeId]?.append(order)
            }
            else {
                routesItems[routeId] = [order]
            }
            
        }
        
        pendingPickup.forEach { order in
            
            guard let routeId = order.route else {
                return
            }
            
            if let _ = routesItems[routeId] {
                routesItems[routeId]?.append(order)
            }
            else {
                routesItems[routeId] = [order]
            }
            
        }
        
        getUsers(storeid: nil, onlyActive: false) { users in
        
            let userRefrence: [ UUID: CustUsername ] = Dictionary(uniqueKeysWithValues: users.map{ ($0.id, $0) })
        
            self.routes.forEach { route in
                
                var supervisorUser = "N/A"
                
                if let uname = userRefrence[route.supervisor]?.username.explode("@").first {
                    supervisorUser = "@\(uname)"
                }
                    
                let view = self.routeItemRow(route, supervisorUser)
                
                self.secondView.appendChild(view)
                
            }
            
        }
    }
    
    func routeItemRow(_ route: CustOrderRoute, _ supervisorUser: String) -> Div {
        
        let startingAt = getDate(route.startingRangeAt)
        
        return Div{
            
            Div{
                Span("RUTA")
                    .marginRight(7.px)
                    .color(.gray)
                Span(route.name)
                
                Span("\(startingAt.formatedLong) \(startingAt.time)")
                    .float(.right)
                Span("FECHA")
                    .marginRight(7.px)
                    .float(.right)
                    .color(.gray)
            }
            
            Div().clear(.both).height(3.px)
            
            Div("\(supervisorUser) Ordenes: \(route.routeItems.count)")
                .fontSize(16.px)
            
        }
            .custom("width", "calc(100% - 24px)")
            .class(.uibtnLarge)
            .onClick {
                
                loadingView(show: true)
                
                API.custRouteV1.load(
                    routeId: route.id
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
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
                    
                    let view = OrderRouteView.UpdateView(
                        route: payload.route,
                        items: payload.items,
                        orders: payload.orders,
                        userLocations: payload.userLocations
                    ) { routeId in
                        
                    }
                    
                    addToDom(view)
                    
                }
            }
    }
    
    func creteNewRoute(){
        
        let view = OrderRouteView.CreateView(
            orders: orderRowViewRefrence.map{ $0.value.data }
        ) { orderIds, route in
            
            orderIds.forEach { id in
                self.orderRowViewRefrence[id]?.remove()
                self.orderRowViewRefrence.removeValue(forKey: id)
            }
            
            getUsers(storeid: nil, onlyActive: false) { users in
                
                let userRefrence = Dictionary(uniqueKeysWithValues: users.map{ value in ( value.id, value) })
        
                var supervisorUser = "N/A"
                
                if let uname = userRefrence[route.supervisor]?.username.explode("@").first {
                    supervisorUser = "@\(uname)"
                }
                    
                let view = self.routeItemRow(route, supervisorUser)
                
                self.secondView.appendChild(view)
                
            }
            
            API.custRouteV1.load(
                routeId: route.id
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
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                let view = OrderRouteView.UpdateView(
                    route: payload.route,
                    items: payload.items,
                    orders: payload.orders,
                    userLocations: payload.userLocations
                ) { routeId in
                    
                }
                
                addToDom(view)
                
            }
            
        }
        
        addToDom(view)
        
    }
    
    func customerOrderStatusUpdate(orderId: UUID, status: CustFolioStatus ) {
        
        let payload = API.wsV1.CustomerOrderStatusUpdateNotification(
            event: "customerOrderStatusUpdate",
            payload: .init(
                connid: custCatchChatConnID,
                orderId: orderId,
                status: status
        ))
        
        do {
            
            let data = try JSONEncoder().encode(payload)
            
            guard let str = String(data: data, encoding: .utf8) else {
                showError(.errorGeneral, "No se pudo enviar mensaje.")
                return
            }
            
            webSocket?.send(str)
            
        }
        catch {
            showError(.errorGeneral, "🔴 No se pudo enviar mensaje 001")
            print(error)
        }
        
    }



}

extension OrderCatchControler {
    
    enum OrderViewType: String {
        case listView
        case calendarView
        case userView
        case routeView
    }
    
    enum LoadOrderStatusType: Equatable {
        
        case general
        
        case byState(OrderState)
        
        /// pending, active, pendingSpare, canceled, finalize, archive, collection, sideStatus
        case byStatus(CustFolioStatus)
        
        var description: String {
            switch self {
            case .general:
                return "Mis Ordenes"
            case .byState:
                return "Presupuestados"
            case .byStatus(let status):
                return status.description
            }
        }
        
    }
    
    enum Parameter {
        case budgetStatus(CustBudgetManagerStatus?)
        case orderStatus(CustFolioStatus)
        case orderBalance(Int64)
        case orderDate(Int64)
        case onWorkUser(UUID)
        case alertStatus(Bool)
        case hightPriorityStatus(Bool)
        case pendingPickup(Bool)
        case newOrder(CustOrderLoadFolios)
        case files([CustOrderLoadFolioFiles])
    }
    
}

