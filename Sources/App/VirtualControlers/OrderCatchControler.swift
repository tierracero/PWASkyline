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
    
    @State var viewType: OrderViewMode

    /// orderView, followUpView, rentalView, dateView, tripView
    @State var macroViewType: MacroViewType = .orderView

    let ws = WS()
    
    @State var custCatchAccountType: TCAccountType

    init(){

        self.viewType = OrderViewMode(rawValue: (WebApp.current.window.localStorage.string(forKey: "viewType") ?? "")) ?? .listView

        let macroViewType = MacroViewType(rawValue: (WebApp.current.window.localStorage.string(forKey: "macroViewType") ?? "")) ?? .orderView

        self.custCatchAccountType = TCAccountType(rawValue: (WebApp.current.window.localStorage.string(forKey: "custCatchAccountType") ?? "") ) ?? .buisness

        switch macroViewType {
        case .accountView:
            self.macroViewType = .accountView
        case .followUpView:
            if !linkedProfile.contains(.bizFollowUp) {
                if linkedProfile.contains(.bizODS) {
                    self.macroViewType = .orderView
                }

            }
        case .orderView:
            if !linkedProfile.contains(.bizODS) {
                if linkedProfile.contains(.bizFollowUp) {
                    self.macroViewType = .followUpView
                }

            }
            case .tripView: 
                self.macroViewType = .tripView
        }

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

    /// Presentation-only counters used by the Work dashboard summary strip.
    @State var pendingCount = 0

    @State var activeCount = 0

    @State var attentionCount = 0

    @State var finalizedCount = 0
    
    /// Orders that have ather status
    private var other: [CustOrderLoadFolios] = []
    
    private var inOrder: [CustOrderLoadFolios] = []
    
    private var outOrder: [CustOrderLoadFolios] = []
    
    private var inDelegate: [CustTranferManager] = []
    
    private var outDelegate: [CustTranferManager] = []
    
    private var routes: [CustOrderRoute] = []
    
    private var delete: [UUID] = []
    
    private var deleteDelegates: [UUID] = []


    private enum OrderRowRenderOperation {
        case dashboard
        case search
        case route
    }

    private var orderRenderId = UUID()
    private var orderSearchId = UUID()
    private var followupRenderId = UUID()
    private var routeRenderId = UUID()
    private var favoriteAccountsRequestId = UUID()
    private var favoriteAccountsIsLoading = false
    private var favoriteAccountsHaveLoaded = false
    private var favoriteAccounts: [CustAcctQuick] = []
    
    /// [ CustOrder.id :  OrderRowView]
    private var orderRowViewRefrence: [ UUID : OrderRowView] = [:]

    private var followupRowViewRefrence: [ UUID : CustFollowUpRowView] = [:]

    private var orderSectionHeaders: [CustFolioStatus: H2] = [:]

    private var orderSectionCountViews: [CustFolioStatus: Span] = [:]
    
    lazy var listViewButtonImg = Img()
        .src("/skyline/media/icon_list.png")
        .class(self.$viewType.map{$0 == .listView ?  .iconBlue : .iconWhite})
        .marginBottom(3.px)
        .height(24.px)

    lazy var listViewButton = Div {
        self.listViewButtonImg
        Span("Lista")
    }
    .class(Class(TCWorkDashboardClass.toolbarPrimary))
    .class(self.$viewType.map { viewType in
        Class(viewType == .listView
            ? TCWorkDashboardClass.toolbarPrimaryActive
            : TCWorkDashboardClass.toolbarPrimaryInactive)
    })
    .display(self.$macroViewType.map {
        $0 == .followUpView ? .none : .inlineFlex
    })
    .onClick { img, event in
        if self.viewType == .listView { return }
        self.viewType = .listView
        self.listViewButtonImg.removeClass(.iconWhite)
        WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
    }
    
    
    lazy var calendarViewButtonImg = Img()
        .src("/skyline/media/icon_calendar.png")
        .class(self.$viewType.map{$0 == .calendarView ? .iconBlue : .iconWhite})
        .marginBottom(3.px)
        .height(24.px)

    lazy var calendarViewButton = Div {
        self.calendarViewButtonImg
        Span("Calendario")
    }
    .class(Class(TCWorkDashboardClass.toolbarPrimary))
    .class(self.$viewType.map { viewType in
        Class(viewType == .calendarView
            ? TCWorkDashboardClass.toolbarPrimaryActive
            : TCWorkDashboardClass.toolbarPrimaryInactive)
    })
    .display(self.$macroViewType.map {
        $0 == .followUpView ? .none : .inlineFlex
    })
    .onClick { 
        if self.viewType == .calendarView { return }
        self.viewType = .calendarView
        self.calendarViewButtonImg.removeClass(.iconWhite)
        WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
    }
    
    lazy var userViewButtonImg = Img()
        .src("/skyline/media/icon_user.png")
        .class(self.$viewType.map{$0 == .userView ? .iconBlue : .iconWhite})
        .marginBottom(3.px)
        .height(24.px)
        
    lazy var userViewButton = Div {
        self.userViewButtonImg
        Span("Usuario")
    }
    .class(Class(TCWorkDashboardClass.toolbarPrimary))
    .class(self.$viewType.map { viewType in
        Class(viewType == .userView
            ? TCWorkDashboardClass.toolbarPrimaryActive
            : TCWorkDashboardClass.toolbarPrimaryInactive)
    })
    .display(self.$macroViewType.map {
        $0 == .followUpView ? .none : .inlineFlex
    })
    .onClick { 
        if self.viewType == .userView { return }
        self.viewType = .userView
        self.userViewButtonImg.removeClass(.iconWhite)
        WebApp.current.window.localStorage.set( JSString(self.viewType.rawValue), forKey: "viewType")
    }
    
    lazy var routeViewButtonImg = Img()
        .src("/skyline/media/icon_route.png")
        .class(self.$viewType.map{$0 == .routeView ? .iconBlue : .iconWhite})
        .hidden(self.$custCatchAccountType.map{ $0 == .entrepreneur })
        .marginBottom(3.px)
        .height(24.px)
    

    lazy var routeViewButton = Div {
        self.routeViewButtonImg
        Span("Ruta")
    }
    .class(Class(TCWorkDashboardClass.toolbarPrimary))
    .class(self.$viewType.map { viewType in
        Class(viewType == .routeView
            ? TCWorkDashboardClass.toolbarPrimaryActive
            : TCWorkDashboardClass.toolbarPrimaryInactive)
    })
    .display(self.$macroViewType.map {
        $0 == .followUpView ? .none : .inlineFlex
    })
    .onClick {
        if self.viewType == .routeView { return }
        self.viewType = .routeView
        self.routeViewButtonImg.removeClass(.iconWhite)
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
        .custom("height", "calc(100% - \( (custCatchAccountType != .entrepreneur) ? "175" : "227" )px)")
        .overflow(.auto)
        .class(.roundGrayBlackDark)
    
    lazy var container = Div{
        self.firstView
        if self.custCatchAccountType != .entrepreneur {
            self.emailViewControler
        }
    }
    .custom("height", "calc(100% - 0px)")
    .overflow(.hidden)
    .class(.oneHalf)
    
    lazy var secondView = Div()
        .custom("height", "calc(100% - 0px)")
        .class(.roundGrayBlackDark, .oneHalf)
        .overflow(.auto)
    
    lazy var pendingOrderView = Div()

    lazy var activeOrderView = Div()

    lazy var finilizeOrderView = Div()

    lazy var pendingSpareOrderView = Div()

    lazy var selectStoreMenuBackgroung = Div()
        .hidden(self.$selectStoreMenuIsHidden)
        .id(.init("selectStoreMenuBackgroung"))
        .position(.fixed)
        .top(0.px)
        .left(0.px)
        .custom("width", "100vw")
        .custom("height", "100vh")
        .custom("background", "rgba(0, 7, 14, 0.77)")
        .custom("backdrop-filter", "blur(4px)")
        .custom("-webkit-backdrop-filter", "blur(4px)")
        .zIndex(999999991)
        .onClick { _, event in
            self.selectStoreMenuIsHidden = true
            event.stopPropagation()
        }

    lazy var loadOrderStatusBackgroung = Div()
        .hidden(self.$loadOrderStatusTypeIsHidden)
        .id(.init("loadOrderStatusBackgroung"))
        .position(.fixed)
        .top(0.px)
        .left(0.px)
        .custom("width", "100vw")
        .custom("height", "100vh")
        .custom("background", "rgba(0, 7, 14, 0.77)")
        .custom("backdrop-filter", "blur(4px)")
        .custom("-webkit-backdrop-filter", "blur(4px)")
        .zIndex(999999991)
        .onClick { _, event in
            self.loadOrderStatusTypeIsHidden = true
            event.stopPropagation()
        }

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
        .position(.relative)
        .zIndex(2)
        .onClick { _, event in
            self.loadOrderStatusTypeIsHidden = true
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
        .custom("top", "calc(100% + 6px)")
        .right(0.px)
        .width(250.px)
        .zIndex(3)
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    .position(.relative)
    .zIndex(self.$selectStoreMenuIsHidden.map { $0 ? 0 : 999999992 })
    
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
                 self.selectStoreMenuIsHidden = true
                 self.loadOrderStatusTypeIsHidden = !self.loadOrderStatusTypeIsHidden
                 event.stopPropagation()
             }
             Div().clear(.both)
             
         }
        .width(207.px)
        .class(.uibtn)
        .position(.relative)
        .zIndex(2)
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
        .id(.init("ViewOrderStatusMenu"))
        .hidden(self.$loadOrderStatusTypeIsHidden)
        .backgroundColor(.transparentBlack)
        .position(.absolute)
        .borderRadius(12.px)
        .padding(all: 3.px)
        .custom("top", "calc(100% + 6px)")
        .right(0.px)
        .width(207.px)
        .zIndex(3)
        .onClick { _, event in
            event.stopPropagation()
        }
    }
    .position(.relative)
    .zIndex(self.$loadOrderStatusTypeIsHidden.map { $0 ? 0 : 999999992 })

    lazy var loadFollowUpsButton = Div{
        
        Div{
            
            Div{
                Img()
                    .src("/skyline/media/reload.png")
                    .marginTop(5.px)
                    .height(18.px)
            }
            .marginLeft(7.px)
            .float(.left)
            
            Div("Seguiminetos")
                //.custom("width", "calc(100% - 70px)")
                .class(.oneLineText)
                .marginLeft(7.px)
                .fontSize(22.px)
                .float(.left)

            Div().clear(.both)
             
         }
        //.width(207.px)
        .class(.uibtn)
        .onClick { _, event in
            self.loadFollowups()
            event.stopPropagation()
        }

        /*

        https://tierracero.com/dev/skyline/api.php?token=1779772615UYe1mtw0fGfNMOKEUCmmBl1GytDbvX1C7IF6MC9gyIIsN0d3&user=vcantu01@tierracero.com&key=XBuHxkAYZHBUwnzysyXhu4pj8jY8cCVX3bwXqXv0dgg%3d&mid=%2boPlYEoYnKf8tbQ13pA8zQ%3d%3d&ie=createBudgetReport
        &firstName=Victor
        &lastName=Cantu
        &mobile=3318000077
        &type=print
        &id=E11CCF3B-CACC-4147-B62F-8C17144C60C0
        &pDir=kviU
        &fullDetail=true
        &deductedTaxes=false

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
        */

    }
    

    lazy var accountContainer = Div{

    }
    .custom("height", "calc(100% - 0px)")
    .overflow(.auto)

    lazy var accountSecondContainer = Div{

    }
    .custom("height", "calc(100% - 0px)")
    .overflow(.auto)

    /// Executes a search on acording set loadOrderStatusType values
    func executeSearch(){
        switch loadOrderStatusType {
        case .general:
            self.sincFolio(
                accountid: nil,
                current: [],
                curTrans: [],
                renderAsSearch: true
            )
        case .byState(let state):
            self.sincByState(state)
        case .byStatus(let status):
            self.sincByStatus(status)
        }
    }
    
    func sincByState(_ state: OrderState) {
        let searchId = UUID()
        orderSearchId = searchId

        loadingView(show: true)


        
        API.custOrderV1.loadOrdersByState(
            state: state,
            store: self.selectedStore?.id,
            account: nil
        ) { resp in
            guard searchId == self.orderSearchId else {
                return
            }

            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
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
            
            self.drawOrderView(operation: .search, renderId: searchId)
            
        }
        
    }
    
    func sincByStatus(_ status: CustFolioStatus) {
        let searchId = UUID()
        orderSearchId = searchId

        loadingView(show: true)
        
        API.custOrderV1.loadOrderByStatus(
            status: status,
            store: self.selectedStore?.id,
            account: nil
        ) { resp in
            guard searchId == self.orderSearchId else {
                return
            }

            loadingView(show: false)
            
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
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
            
            self.drawOrderView(operation: .search, renderId: searchId)
            
            
        }
    }
    
    func sincFolio(
        accountid: HybridIdentifier?,
        current: [APIStoreSincObject],
        curTrans: [APIStoreSincObject],
        initialLoad: Bool = false,
        renderAsSearch: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ){
        let requestId = UUID()
        if renderAsSearch {
            orderSearchId = requestId
        }
        
        if !initialLoad {
            loadingView(show: true)
        }

        API.custOrderV1.loadFolios(
            storeid: selectedStore?.id,
            accountid: accountid,
            current: current,
            curTrans: curTrans
        ) { resp in
            if renderAsSearch, requestId != self.orderSearchId {
                return
            }

            if !initialLoad {
                loadingView(show: false)
            }

            guard let resp else {
                completion?(false)
                showError(.comunicationError, "No se pudo comunicar con el servidor")
                return
            }
            
            guard resp.status == .ok else {
                completion?(false)
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                completion?(false)
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
            
            if renderAsSearch {
                self.drawOrderView(operation: .search, renderId: requestId)
            } else {
                self.drawOrderView()
            }

            completion?(true)
            
        }
    }
    
    func updateParameter(_ orderId: UUID, _ parameter: Parameter){
        
        switch parameter {
        case .budgetStatus(let custBudgetManagerStatus):
            orderCatch[orderId]?.budget = custBudgetManagerStatus
            if custBudgetManagerStatus == nil {
                orderCatch[orderId]?.budgetRequest = nil
            }
            orderRowViewRefrence[orderId]?.budget = custBudgetManagerStatus
        case .orderStatus(let custFolioStatus):
            let currentStatus = orderRowViewRefrence[orderId]?.data.status
                ?? orderInCurrentSnapshot(orderId)?.status

            guard currentStatus != custFolioStatus else {
                return
            }

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
            orderRowViewRefrence[orderId]?.alerted = isAlerted
            
        case .hightPriorityStatus(let isHighPriority):
            
            orderCatch[orderId]?.highPriority = isHighPriority
            orderRowViewRefrence[orderId]?.highPriority = isHighPriority
            
        case .pendingPickup(let isPendingPickup):
            break
        case .warrantyCards(let warrantyCards):
            orderCatch[orderId]?.warrantyCards = warrantyCards
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
        guard var order = orderRowViewRefrence[orderId]?.data
            ?? orderInCurrentSnapshot(orderId) else {
            return
        }

        guard order.status != custFolioStatus else {
            return
        }

        let existingView = orderRowViewRefrence[orderId]

        pending.removeAll { $0.id == orderId }
        active.removeAll { $0.id == orderId }
        pendingSpare.removeAll { $0.id == orderId }
        pendingPickup.removeAll { $0.id == orderId }
        other.removeAll { $0.id == orderId }

        order.status = custFolioStatus
        orderCatch[orderId]?.status = custFolioStatus

        switch custFolioStatus {
        case .pending:
            pending.append(order)
        case .active:
            active.append(order)
        case .pendingSpare:
            pendingSpare.append(order)
        case .canceled, .finalize:
            pendingPickup.append(order)
        case .archive, .collection, .sideStatus, .saleWait:
            break
        }

        refreshOrderCounters()

        guard macroViewType == .orderView else {
            return
        }

        if viewType == .listView {
            existingView?.remove()
            orderRowViewRefrence.removeValue(forKey: orderId)

            guard let target = listContainer(for: custFolioStatus) else {
                return
            }

            ensureListSectionMounted(for: custFolioStatus)
            // Indexed insertion resolves its anchor from SwifWeb's tracked child
            // list. Status changes can unmount a section during this callback,
            // leaving that anchor detached from the browser node.
            target.appendChild(orderRowView(order))
        } else if custFolioStatus == .archive
                    || custFolioStatus == .collection
                    || custFolioStatus == .sideStatus
                    || custFolioStatus == .saleWait {
            existingView?.remove()
            orderRowViewRefrence.removeValue(forKey: orderId)
        } else {
            existingView?.applyStatus(custFolioStatus)
        }
    }

    private func orderInCurrentSnapshot(_ orderId: UUID) -> CustOrderLoadFolios? {
        for orders in [pending, active, pendingSpare, pendingPickup, other] {
            if let order = orders.first(where: { $0.id == orderId }) {
                return order
            }
        }
        return nil
    }

    private func listContainer(for status: CustFolioStatus) -> Div? {
        switch status {
        case .pending:
            return pendingOrderView
        case .active:
            return activeOrderView
        case .pendingSpare:
            return pendingSpareOrderView
        case .canceled, .finalize:
            return finilizeOrderView
        case .archive, .collection, .sideStatus, .saleWait:
            return nil
        }
    }

    private func refreshOrderCounters() {
        let now = getNow()
        let dueSoonLimit = now + 259_200

        let countRequiringAttention: ([CustOrderLoadFolios]) -> Int = { orders in
            orders.reduce(into: 0) { count, order in
                guard let due = order.due,
                      due >= now,
                      due <= dueSoonLimit else {
                    return
                }
                count += 1
            }
        }

        pendingCount = pending.count
        activeCount = active.count
        attentionCount = countRequiringAttention(pending)
            + countRequiringAttention(pendingSpare)
            + countRequiringAttention(active)
        finalizedCount = pendingPickup.count

        updateListSectionCount(.pending, count: pending.count)
        updateListSectionCount(.pendingSpare, count: pendingSpare.count)
        updateListSectionCount(.active, count: active.count)
        updateListSectionCount(.finalize, count: pendingPickup.count)
    }

    private func updateListSectionCount(
        _ status: CustFolioStatus,
        count: Int
    ) {
        orderSectionCountViews[status]?.innerHTML = count.toString

        if count == 0 {
            orderSectionHeaders.removeValue(forKey: status)?.remove()
            orderSectionCountViews.removeValue(forKey: status)
            // Keep the section container out of both the browser tree and
            // SwifWeb's tracked children until it is mounted again.
            listContainer(for: status)?.remove()
        }
    }

    private func makeOrderSectionHeader(
        status: CustFolioStatus,
        count: Int
    ) -> H2 {
        let countView = Span(count.toString)
            .marginLeft(12.px)
            .opacity(0.5)
            .color(.gray)

        let header = H2{
            Span(status.description)
                .color(status.color)
            countView
        }
        .margin(all: 7.px)

        orderSectionHeaders[status] = header
        orderSectionCountViews[status] = countView
        return header
    }

    private func ensureListSectionMounted(
        for status: CustFolioStatus
    ) {
        let sectionStatus: CustFolioStatus
        let root: Div
        let sectionContainer: Div
        let count: Int

        switch status {
        case .pending:
            sectionStatus = .pending
            root = firstView
            sectionContainer = pendingOrderView
            count = pending.count
        case .pendingSpare:
            sectionStatus = .pendingSpare
            root = firstView
            sectionContainer = pendingSpareOrderView
            count = pendingSpare.count
        case .active:
            sectionStatus = .active
            root = secondView
            sectionContainer = activeOrderView
            count = active.count
        case .canceled, .finalize:
            sectionStatus = .finalize
            root = secondView
            sectionContainer = finilizeOrderView
            count = pendingPickup.count
        case .archive, .collection, .sideStatus, .saleWait:
            return
        }

        guard orderSectionHeaders[sectionStatus] == nil else {
            return
        }

        root.appendChild(
            makeOrderSectionHeader(
                status: sectionStatus,
                count: count
            )
        )
        root.appendChild(sectionContainer)
    }

    private func asyncAddOrder(
        renderId: UUID,
        operation: OrderRowRenderOperation,
        view: Div,
        rows: [CustOrderLoadFolios],
        index: Int = 0
    ) {

        guard isCurrentRender(renderId, operation: operation),
              rows.indices.contains(index) else {
            return
        }

        Dispatch.asyncAfter(index == 0 ? 0.01 : 0.03) {
            guard self.isCurrentRender(renderId, operation: operation),
                  rows.indices.contains(index) else {
                return
            }

            guard self.isCurrentRender(renderId, operation: operation) else {
                return
            }

            let item = self.orderRowView(rows[index])

            guard self.isCurrentRender(renderId, operation: operation) else {
                item.remove()
                return
            }

            if rows.count <= 35 {
                item.filter(.opacity(0))
            }
            view.appendChild(item)

            if rows.count <= 35 {
                item.fadeIn()
            }

            guard self.isCurrentRender(renderId, operation: operation) else {
                return
            }
            self.asyncAddOrder(
                renderId: renderId,
                operation: operation,
                view: view,
                rows: rows,
                index: index + 1
            )
        }

    }

    private func isCurrentRender(
        _ renderId: UUID,
        operation: OrderRowRenderOperation
    ) -> Bool {
        switch operation {
        case .dashboard:
            return renderId == orderRenderId
        case .search:
            return renderId == orderSearchId
        case .route:
            return renderId == routeRenderId
        }
    }

    func drawFollowupView( items: [CustFollowUp]) {

        macroViewType = .followUpView
        orderRenderId = UUID()
        orderSearchId = UUID()
        routeRenderId = UUID()

        pendingCount = 0
        activeCount = items.count
        attentionCount = 0
        finalizedCount = 0
                
        followupRowViewRefrence.forEach { id, view in
            view.remove()
        }

        followupRowViewRefrence.removeAll()

        orderRowViewRefrence.forEach { id, view in
            view.remove()
        }

        orderRowViewRefrence.removeAll()
        orderSectionHeaders.removeAll()
        orderSectionCountViews.removeAll()

        let renderId = UUID()
        followupRenderId = renderId
        
        firstView.innerHTML = ""
        container.removeClass(.oneHalf)
        container.removeClass(.oneThirdOrderGrid)
        
        secondView.innerHTML = ""
        secondView.removeClass(.oneHalf)
        secondView.removeClass(.twoThirdOrderGrid)
        
        pendingOrderView.innerHTML = ""
        activeOrderView.innerHTML = ""
        finilizeOrderView.innerHTML = ""
        pendingSpareOrderView.innerHTML = ""


        // MARK: ADD  Corresponding clases
        container.class(.oneHalf)

        secondView.class([.oneHalf, .roundGrayBlackDark])

        // LOAD DATA

        asyncAddFollowup(
            renderId: renderId,
            items: items
        )

    }

    private func asyncAddFollowup(
        renderId: UUID,
        items: [CustFollowUp],
        index: Int = 0
    ) {
        guard renderId == followupRenderId,
              items.indices.contains(index) else {
            return
        }

        Dispatch.asyncAfter(index == 0 ? 0.01 : 0.03) {
            guard renderId == self.followupRenderId,
                  items.indices.contains(index) else {
                return
            }

            let item = items[index]
            let view = self.followupRowView(data: item)

            guard renderId == self.followupRenderId else {
                view.remove()
                return
            }

            self.followupRowViewRefrence[item.id] = view

            if index.isEven {
                self.firstView.appendChild(view)
            } else {
                self.secondView.appendChild(view)
            }

            guard renderId == self.followupRenderId else {
                return
            }

            self.asyncAddFollowup(
                renderId: renderId,
                items: items,
                index: index + 1
            )
        }
    }

    func drawOrderView() {
        followupRenderId = UUID()
        orderSearchId = UUID()
        if viewType != .routeView {
            routeRenderId = UUID()
        }
        orderRenderId = UUID()
        drawOrderView(operation: .dashboard, renderId: orderRenderId)
    }

    private func drawOrderView(
        operation: OrderRowRenderOperation,
        renderId: UUID
    ){
        if operation == .search {
            orderRenderId = UUID()
            followupRenderId = UUID()
            routeRenderId = UUID()
        }
        
        macroViewType = .orderView

        refreshOrderCounters()

        // Clearing the two column roots already runs didRemoveFromDOM recursively.
        // Removing every row first would schedule an animation and timer per row,
        // only for the same subtree to be cleared immediately afterward.
        firstView.innerHTML = ""
        container.removeClass(.oneHalf)
        container.removeClass(.oneThirdOrderGrid)
        
        secondView.innerHTML = ""
        secondView.removeClass(.oneHalf)
        secondView.removeClass(.twoThirdOrderGrid)
        
        pendingOrderView.innerHTML = ""
        activeOrderView.innerHTML = ""
        finilizeOrderView.innerHTML = ""
        pendingSpareOrderView.innerHTML = ""

        followupRowViewRefrence.removeAll(keepingCapacity: true)
        orderRowViewRefrence.removeAll(keepingCapacity: true)
        orderSectionHeaders.removeAll(keepingCapacity: true)
        orderSectionCountViews.removeAll(keepingCapacity: true)

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
                    makeOrderSectionHeader(
                        status: .pending,
                        count: pending.count
                    )
                )
                    
                firstView.appendChild(pendingOrderView)

                asyncAddOrder(renderId: renderId, operation: operation, view: pendingOrderView, rows: pending) // pending


            }

            if !pendingSpare.isEmpty {
                
                firstView.appendChild(
                    makeOrderSectionHeader(
                        status: .pendingSpare,
                        count: pendingSpare.count
                    )
                )

                firstView.appendChild(pendingSpareOrderView)

                asyncAddOrder(renderId: renderId, operation: operation, view: pendingSpareOrderView, rows: pendingSpare)
                
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
                    makeOrderSectionHeader(
                        status: .active,
                        count: active.count
                    )
                )

                self.secondView.appendChild(activeOrderView)

                asyncAddOrder(renderId: renderId, operation: operation, view: activeOrderView, rows: active)

            }
            if !pendingPickup.isEmpty {
                
                secondView.appendChild(
                    makeOrderSectionHeader(
                        status: .finalize,
                        count: pendingPickup.count
                    )
                )

                secondView.appendChild(finilizeOrderView)
                
                asyncAddOrder(renderId: renderId, operation: operation, view: finilizeOrderView, rows: pendingPickup)

            }
            
            if orderCount > 0 {
                
                asyncAddOrder(renderId: renderId, operation: operation, view: secondView, rows: other)
                
            }
            else {
                
                var evenItems: [CustOrderLoadFolios] = []

                var oddItems: [CustOrderLoadFolios] = []

                var cc = 0

                self.other.forEach { item in
                    if cc.isEven {
                        evenItems.append(item)
                    }
                    else {
                        oddItems.append(item)
                    }
                    cc += 1
                }

                asyncAddOrder(renderId: renderId, operation: operation, view: firstView, rows: evenItems)

                asyncAddOrder(renderId: renderId, operation: operation, view: secondView, rows: oddItems)
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
            
            generalPayload.append(contentsOf: other)

            /// View One
            self.firstView.appendChild(H1("Sin Cita / Vencidos \(generalPayload.count.toString)").color(.white).marginBottom(7.px))
            self.asyncAddOrder(renderId: renderId, operation: operation, view: self.firstView, rows: generalPayload)

            /// View Two
            self.secondView.appendChild(OrderCalendarView(selectedDateStamp: "", __workMap: workMap, callback: { selectedDateStamp, uts, highPriority in
                
            }))
            
            
        case .userView:
        
            /// Set view layout
            container.class(.oneHalf)
            secondView.class([.oneHalf, .roundGrayBlackDark])
            
            getUsers(storeid: nil, onlyActive: false) { users in

                guard self.isCurrentRender(renderId, operation: operation),
                      self.viewType == .userView else {
                    return
                }
                
                let userRefrence = Dictionary(uniqueKeysWithValues: users.map{ value in ( value.id, value) })
                
                let userIdsByUsernameSorted = users
                    .sorted { $0.username < $1.username }
                    .map { $0.id }
                
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
                    
                    self.firstView.appendChild(self.pendingOrderView)
                        
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
                        
                        self.pendingOrderView.appendChild(
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

                        let userInnerView = Div()

                        self.pendingOrderView.appendChild(userInnerView)

                        self.asyncAddOrder(renderId: renderId, operation: operation, view: userInnerView, rows: items)

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

                    self.firstView.appendChild(self.pendingSpareOrderView)
                    
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

                        self.pendingSpareOrderView.appendChild(
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

                        let userInnerView = Div()

                        self.pendingSpareOrderView.appendChild(userInnerView)

                        self.asyncAddOrder(renderId: renderId, operation: operation, view: userInnerView, rows: items)
                        
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

                    self.secondView.appendChild(self.activeOrderView)
                    
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
                        
                        self.activeOrderView.appendChild(
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

                        let userInnerView = Div()

                        self.activeOrderView.appendChild(userInnerView)

                        self.asyncAddOrder(renderId: renderId, operation: operation, view: userInnerView, rows: items)
                        
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

                    self.secondView.appendChild(self.finilizeOrderView)
                    
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
                        
                        self.finilizeOrderView.appendChild(
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
                        
                        let userInnerView = Div()

                        self.finilizeOrderView.appendChild(userInnerView)

                        self.asyncAddOrder(renderId: renderId, operation: operation, view: userInnerView, rows: items)
                        
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
                    
                    var destinationIndex = 0

                    userIdsByUsernameSorted.forEach { userId in
                        
                        var userName = "USER_ND"
                    
                        if let udata = userRefrence[userId] {
                            userName =  "@" + (udata.username.explode("@").first ?? "\(udata.firstName) \(udata.lastName)")
                        }
                        
                        if orderCount > 0 {

                            if let orders = orderRefrence[userId] {

                                let destination = destinationIndex.isEven
                                    ? self.firstView
                                    : self.secondView

                                destination.appendChild(
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

                                let userInnerView = Div()
                                destination.appendChild(userInnerView)
                                self.asyncAddOrder(
                                    renderId: renderId,
                                    operation: operation,
                                    view: userInnerView,
                                    rows: orders
                                )
                                destinationIndex += 1
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

                                let userInnerView = Div()
                                self.secondView.appendChild(userInnerView)
                                self.asyncAddOrder(
                                    renderId: renderId,
                                    operation: operation,
                                    view: userInnerView,
                                    rows: orders
                                )
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
        let view = OrderRowView(data: data) {
            self.openOrder(data.id)
        }

        view.borderLeft(
            width: .thick,
            style: .solid,
            color: data.status.color
        )
        
        orderRowViewRefrence[data.id] = view
        
        return view
        
    }

    private func openOrder(_ orderId: UUID) {
        if let accountId = minViewOrderAccountRefrence[orderId] {
            if restoreExistingAccountView(
                accountId: accountId,
                orderId: orderId
            ) {
                return
            }

            if loadOrderIntoExistingAccountView(
                accountId: accountId,
                orderId: orderId
            ) {
                return
            }
        }

        loadOrderIntoNewAccountView(orderId: orderId)
    }

    private func restoreExistingAccountView(
        accountId: UUID,
        orderId: UUID
    ) -> Bool {
        guard let accountOverview = minViewAcctRefrence[accountId],
              accountOverview.order?.id == orderId else {
            return false
        }

        minViewDivRefrence[accountId]?.remove()
        minViewDivRefrence.removeValue(forKey: accountId)
        accountOverview.display(.block)
        accountOverview.load = .order
        return true
    }

    private func loadOrderIntoExistingAccountView(
        accountId: UUID,
        orderId: UUID
    ) -> Bool {
        guard let accountOverview = minViewAcctRefrence[accountId] else {
            return false
        }

        minViewDivRefrence[accountId]?.remove()
        minViewDivRefrence.removeValue(forKey: accountId)
        accountOverview.display(.block)

        accountOverview.loadOrder(id: orderId) {
            account,
            order,
            notes,
            payments,
            charges,
            pocs,
            files,
            contracts,
            equipments,
            rentals,
            transferOrder,
            orderHighPriorityNote,
            accountHighPriorityNote,
            tasks,
            route,
            loadFromCatch in
            accountOverview.loadOrder(
                account: account,
                order: order,
                notes: notes,
                payments: payments,
                charges: charges,
                pocs: pocs,
                files: files,
                contracts: contracts,
                equipments: equipments,
                rentals: rentals,
                transferOrder: transferOrder,
                orderHighPriorityNote: orderHighPriorityNote,
                accountHighPriorityNote: accountHighPriorityNote,
                tasks: tasks,
                orderRoute: route,
                loadFromCatch: loadFromCatch
            )
            accountOverview.load = .order
        }

        return true
    }

    private func loadOrderIntoNewAccountView(orderId: UUID) {
        loadFolio(orderid: orderId) {
            account,
            order,
            notes,
            payments,
            charges,
            pocs,
            files,
            contracts,
            equipments,
            rentals,
            transferOrder,
            orderHighPriorityNote,
            accountHighPriorityNote,
            tasks,
            route,
            loadFromCatch in
            let accountOverview = AccoutOverview(
                id: .id(order.custAcct)
            )

            accountOverview.loadOrder(
                account: account,
                order: order,
                notes: notes,
                payments: payments,
                charges: charges,
                pocs: pocs,
                files: files,
                contracts: contracts,
                equipments: equipments,
                rentals: rentals,
                transferOrder: transferOrder,
                orderHighPriorityNote: orderHighPriorityNote,
                accountHighPriorityNote: accountHighPriorityNote,
                tasks: tasks,
                orderRoute: route,
                loadFromCatch: loadFromCatch
            )

            minViewAcctRefrence[order.custAcct] = accountOverview
            addToDom(accountOverview)
        }
    }

    func followupRowView(data: CustFollowUp) -> CustFollowUpRowView {

        let view = CustFollowUpRowView(data) {

            loadingView(show: true)

            API.custFollowup.getItem(followupId: data.id) { resp in 

                loadingView(show: false)

                guard let resp else {
                    showError(.comunicationError, .unexpenctedMissingPayload)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                let followupView = ViewFollowup(
                    account: payload.account,
                    followup: payload.followup,
                    items: payload.items
                ) { closeType in

                    let account: CustAcctSearch = .init(
                            id: payload.account.id,
                            folio: payload.account.folio,
                            businessName: payload.account.businessName,
                            costType: payload.account.costType,
                            type: payload.account.type,
                            firstName: payload.account.firstName,
                            lastName: payload.account.lastName,
                            mcc: payload.account.mcc,
                            mobile: payload.account.mobile,
                            email: payload.account.email,
                            street: payload.account.street,
                            colony: payload.account.colony,
                            city: payload.account.city,
                            state: payload.account.state,
                            zip: payload.account.zip,
                            country: payload.account.country,
                            autoPaySpei: payload.account.autoPaySpei,
                            autoPayOxxo: payload.account.autoPayOxxo,
                            fiscalProfile: payload.account.fiscalProfile,
                            fiscalRazon: payload.account.fiscalRazon,
                            fiscalRfc: payload.account.fiscalRfc,
                            fiscalRegime: payload.account.fiscalRegime,
                            fiscalZip: payload.account.fiscalZip,
                            cfdiUse: payload.account.cfdiUse,
                            CardID: payload.account.CardID,
                            rewardsLevel: payload.account.rewardsLevel,
                            crstatus: payload.account.crstatus,
                            isConcessionaire: payload.account.isConcessionaire,
                            highPriorityNotes: []
                        )

                    switch closeType {
                    case .noIntrest:
                    break
                    case .toOrder:
                                            
                        let order = StartServiceOrder(custAcct: account) { id, shownHighPriorityNotes, cfiles in
                            
                            OrderCatchControler.shared.loadFolio(orderid: id) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                    
                                var files = files
                            
                                var currentFiles: [CustOrderLoadFolioFiles] = []
                                
                                if !cfiles.isEmpty {

                                    cfiles.forEach { file in
                                        currentFiles.append(.init(
                                            id: .init(),
                                            type: .image,
                                            file: file,
                                            avatar: file
                                        ))
                                    }

                                    files.append(contentsOf: currentFiles)

                                    OrderCatchControler.shared.updateParameter(id, .files(currentFiles))

                                }
                                            
                                OrderCatchControler.shared.updateParameter(id, .newOrder(.init(
                                    id: id,
                                    folio: order.folio,
                                    createdAt: order.createdAt,
                                    modifiedAt: order.modifiedAt,
                                    closedAt: order.closedAt,
                                    custAcct: order.custAcct,
                                    type: order.type,
                                    activeUser: order.workedBy ?? order.createdBy,
                                    name: order.name,
                                    mobile: order.mobile,
                                    address: "\(order.street) \(order.colony) \(order.state)",
                                    due: order.dueDate,
                                    alerted: order.alerted,
                                    fiscalDocumentStatus: .unrequest,
                                    budgetStatus: .pending,
                                    budget: nil,
                                    pendingPickup: order.pendingPickup,
                                    transferManagement: nil,
                                    highPriority: order.highPriority,
                                    description: order.description,
                                    smallDescription: order.smallDescription,
                                    balance: 0, // TODO: do proper calc
                                    productionTime: 0, // TODO: do proper calc
                                    route: order.route,
                                    status: order.status
                                )))
                                
                                let accoutOverview = AccoutOverview (
                                    id: .id(order.custAcct)
                                )
                                
                                accoutOverview.shownHighPriorityNotes.append(contentsOf: shownHighPriorityNotes)
                                
                                accoutOverview.loadOrder(
                                    account: account,
                                    order: order,
                                    notes: notes,
                                    payments: payments,
                                    charges: charges,
                                    pocs: pocs,
                                    files: files,
                                    contracts: contracts,
                                    equipments: equipments,
                                    rentals: rentals,
                                    transferOrder: transferOrder,
                                    orderHighPriorityNote: orderHighPriorityNote,
                                    accountHighPriorityNote: accountHighPriorityNote,
                                    tasks: tasks,
                                    orderRoute: route,
                                    loadFromCatch: loadFromCatch
                                )
                                
                                addToDom(accoutOverview)
                                
                                minViewAcctRefrence[order.custAcct] = accoutOverview
                                
                                accoutOverview._orderView?.printOrder()
                                
                            }
                            
                        }
                        
                        addToDom(order)

                    case .toPOS:
                        
                        let view = SalePointView(loadBy: .account(account))

                        addToDom(view)
                    }

                    self.followupRowViewRefrence[payload.followup.id]?.remove()
                    self.followupRowViewRefrence.removeValue(forKey: payload.followup.id)

                } onClosing: {
                    self.followupRowViewRefrence[payload.followup.id]?.remove()
                    self.followupRowViewRefrence.removeValue(forKey: payload.followup.id)
                }

                addToDom(followupView)

            }

        }
        
        followupRowViewRefrence[data.id] = view
        
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
            _ contracts: [CustPageContent],
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
                    
                    accoutOverview.loadOrder(id: orderid) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, orderRoute, loadFromCatch in
                        
                        accoutOverview.loadOrder(
                            account: account,
                            order: order,
                            notes: notes,
                            payments: payments,
                            charges: charges,
                            pocs: pocs,
                            files: files,
                            contracts: contracts,
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
            let contracts: [CustPageContent] = contractsCatch[orderid] ?? []
            let equipments: [CustOrderLoadFolioEquipments] = equipmentsCatch[orderid] ?? []
            let rentals: [CustPOCRentalsMin] = rentalsCatch[orderid] ?? []
            let orderHighPriorityNote: [HighPriorityNote] = orderHighPriorityNoteCatch[orderid] ?? []
            let accountHighPriorityNote: [HighPriorityNote] = accountHighPriorityNoteCatch[orderid] ?? []
            let tasks: [CustTaskAuthorizationManagerQuick] = tasksCatch[orderid] ?? []
            let transferOrder: CustTranferManager? = transferOrderCatch[orderid]
            let route: CustOrderRoute? = custOrderRouteCatch[orderid]
            
            loadingView(show: true)

            // A cache hit used to build the complete order view inside the click
            // event. Give the browser a frame to paint the loading state first.
            Dispatch.asyncAfter(0.05) {
                loadingView(show: false)

                callback(
                    account,
                    order,
                    notes,
                    payments,
                    charges,
                    pocs,
                    files,
                    contracts,
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
            
        }
        else{
            
            loadingView(show: true)
            
            API.custOrderV1.loadOrder(identifier: .id(orderid), modifiedAt: nil) { resp in
                
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
                    contractsCatch[orderid] = loadOrderResponse.contracts
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
                        loadOrderResponse.contracts,
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
        
        macroViewType = .orderView
        followupRenderId = UUID()

        orderRowViewRefrence.removeAll()

        let renderId = UUID()
        routeRenderId = renderId

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
        self.asyncAddOrder(
            renderId: renderId,
            operation: .route,
            view: self.firstView,
            rows: generalPayload
        )
        
        /// View Two
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
            guard renderId == self.routeRenderId,
                  self.viewType == .routeView else {
                return
            }

            let userRefrence: [ UUID: CustUsername ] = Dictionary(uniqueKeysWithValues: users.map{ ($0.id, $0) })

            self.asyncAddRoute(
                renderId: renderId,
                routes: self.routes,
                userRefrence: userRefrence
            )
        }
    }

    private func asyncAddRoute(
        renderId: UUID,
        routes: [CustOrderRoute],
        userRefrence: [UUID: CustUsername],
        index: Int = 0
    ) {
        guard renderId == routeRenderId,
              routes.indices.contains(index) else {
            return
        }

        Dispatch.asyncAfter(index == 0 ? 0.01 : 0.03) {
            guard renderId == self.routeRenderId,
                  routes.indices.contains(index) else {
                return
            }

            let route = routes[index]
            var supervisorUser = "N/A"

            if let uname = userRefrence[route.supervisor]?.username.explode("@").first {
                supervisorUser = "@\(uname)"
            }

            let view = self.routeItemRow(route, supervisorUser)

            guard renderId == self.routeRenderId else {
                view.remove()
                return
            }

            self.secondView.appendChild(view)

            guard renderId == self.routeRenderId else {
                return
            }

            self.asyncAddRoute(
                renderId: renderId,
                routes: routes,
                userRefrence: userRefrence,
                index: index + 1
            )
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
                        showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
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
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
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
        
        let payload = API.webSocketV1.CustomerOrderStatusUpdateNotification(
            event: "customerOrderStatusUpdate",
            payload: .init(
                connid: custCatchChatConnID,
                orderId: orderId,
                status: status
        ))
        
        do {
            
            let data = try JSONEncoder().encode(payload)
            
            guard let str = String(data: data, encoding: .utf8) else {
                showError(.generalError, "No se pudo enviar mensaje.")
                return
            }
            
            webSocket?.send(str)
            
        }
        catch {
            showError(.generalError, "🔴 No se pudo enviar mensaje 001")
            print(error)
        }
        
    }

    func loadAccounts(force: Bool = false) {
        self.macroViewType = .accountView

        if !force {
            if favoriteAccountsHaveLoaded {
                drawFavoriteAccounts(favoriteAccounts)
                return
            }

            if favoriteAccountsIsLoading {
                return
            }
        }

        let requestId = UUID()
        favoriteAccountsRequestId = requestId
        favoriteAccountsIsLoading = true

        loadingView(show: true)

        API.custAccountV1.favorite { resp in
            guard requestId == self.favoriteAccountsRequestId else {
                return
            }

            self.favoriteAccountsIsLoading = false
            loadingView(show: false)

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let favoriteAccounts = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.favoriteAccounts = favoriteAccounts
            self.favoriteAccountsHaveLoaded = true
            self.drawFavoriteAccounts(favoriteAccounts)
        }
    }

    private func drawFavoriteAccounts(_ favoriteAccounts: [CustAcctQuick]) {
        accountContainer.innerHTML = ""
        accountSecondContainer.innerHTML = ""

        guard !favoriteAccounts.isEmpty else {
            accountContainer.appendChild(
                Div("No hay cuentas favoritas")
                    .color(.gray)
                    .padding(all: 18.px)
                    .align(.center)
            )
            return
        }

        favoriteAccounts.enumerated().forEach { index, account in
            let row = AccountRowView(
                data: .init(
                    id: account.id,
                    folio: account.folio,
                    businessName: account.businessName,
                    firstName: account.firstName,
                    lastName: account.lastName,
                    street: account.street,
                    colony: account.colony,
                    city: account.city
                )
            ) { accountId in
                loadAccountView(id: .id(accountId))
            }

            if index % 2 == 0 {
                accountContainer.appendChild(row)
            } else {
                accountSecondContainer.appendChild(row)
            }
        }
    }

    func loadFollowups() {
        let requestId = UUID()
        followupRenderId = requestId

        loadingView(show: true)

        API.custFollowup.getItems(
            storeId: custCatchStore,
            userId: nil,
            status: nil
        ) { resp in
            guard requestId == self.followupRenderId else {
                return
            }

            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let followups = resp.data?.followups else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.drawFollowupView(items: followups)
            
        }
    }
    
}

extension OrderCatchControler {
    
    /// orderView, followUpView, rentalView, dateView, tripView
    enum MacroViewType: String {

        case accountView

        case orderView
        
        case followUpView

        //case rentalView

        //case dateView

        case tripView

    }
    
    enum LoadOrderStatusType: Equatable {
        
        case general
        
        case byState(OrderState)
        
        /// pending, active, pendingSpare, canceled, finalize, archive, collection, sideStatus
        case byStatus(CustFolioStatus)
        
        var description: String {
            switch self {
            case .general:
                return "Ordenes"
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
        case warrantyCards([String])
        case newOrder(CustOrderLoadFolios)
        case files([CustOrderLoadFolioFiles])
    }
    
}
