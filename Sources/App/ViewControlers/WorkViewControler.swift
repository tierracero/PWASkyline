//
//  WorkViewControler.swift
//
//
//  Created by Victor Cantu on 2/17/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import WebSocketAPI
import MailAPICore
import FetchAPI
import Web

private enum WorkNavigationSelection: Equatable {
    case analytics
    case accounts
    case orders
    case followups
    case sales
    case trips
    case products
    case tools
}

private enum WorkStartupStep: CaseIterable, Hashable {
    case core
    case communications
    case workModules

    var title: String {
        switch self {
        case .core:
            return "NÚCLEO OPERATIVO"
        case .communications:
            return "COMUNICACIONES"
        case .workModules:
            return "MÓDULOS DE TRABAJO"
        }
    }
}

private enum WorkStartupState {
    case waiting
    case loading
    case online
    case failed
    case skipped

    var label: String {
        switch self {
        case .waiting:
            return "EN ESPERA"
        case .loading:
            return "CARGANDO"
        case .online:
            return "ONLINE"
        case .failed:
            return "ERROR"
        case .skipped:
            return "OMITIDO"
        }
    }

    var cssClass: String {
        switch self {
        case .waiting:
            return TCWorkDashboardClass.startupStateWaiting
        case .loading:
            return TCWorkDashboardClass.startupStateLoading
        case .online:
            return TCWorkDashboardClass.startupStateOnline
        case .failed:
            return TCWorkDashboardClass.startupStateFailed
        case .skipped:
            return TCWorkDashboardClass.startupStateSkipped
        }
    }

    var isTerminal: Bool {
        switch self {
        case .online, .failed, .skipped:
            return true
        case .waiting, .loading:
            return false
        }
    }
}

class WorkViewControler: PageController {
    
    let ws = WS()
    
    let viewid = UUID()
    
    var serviceIsActive = false
    
    var newOrderInProccess = false

    var tripViewIsLoaded = false

    var tripViewIsLoading = false
    
    /// Order List Catch
    var pending: [CustOrderLoadFolios] = []
    
    var pendingSpare: [CustOrderLoadFolios] = []
    
    var active: [CustOrderLoadFolios] = []
    
    var pendingPickup: [CustOrderLoadFolios] = []
    
    var inOrder: [CustOrderLoadFolios] = []
    
    var outOrder: [CustOrderLoadFolios] = []
    
    var inDelegate: [CustTranferManager] = []
    
    var outDelegate: [CustTranferManager] = []
    
    @State var username: String = ""
    
    @State var sideMenuIsHidden: Bool = false
    
    @State var cssIsLoaded = false
    
    @State var jsIsLoaded = false
    
    @State var searchTerm = ""
    
    @State var WSToken = ""
    
    @State var pmode: PanelMode? = nil

    @State private var selectedWorkNavigationItem: WorkNavigationSelection = .orders
    
    @State var serchPlaceHolder = ""

    private var startupStates: [WorkStartupStep: WorkStartupState] = [:]
    private var startupLabels: [WorkStartupStep: Span] = [:]
    private var startupValues: [WorkStartupStep: Div] = [:]
    private var startupSequenceIsCompleting = false
    
    lazy var sideMenu = SideMenuView { caller in
        self.sideMenuCaller(caller)
    }
    
    @State var userHerk = 0
    
    /// ``Left Side Bar COMMUNICATION``
    
    lazy var sideBar = Div()
        .class(.sideBar, Class(TCWorkDashboardClass.leftRail))
    
    lazy var comunicationBoxNewMessagesView = Div()
    
    lazy var comunicationBoxOldMessagesView = Div()

    private var communicationRefreshId = UUID()

    private lazy var communicationController = CommunicationCenterController(
        newMessagesView: self.comunicationBoxNewMessagesView,
        historicalMessagesView: self.comunicationBoxOldMessagesView
    ) { [weak self] message in
        self?.openCommunicationMessage(message)
    }

    private lazy var speechRecognitionControl = TCSpeechRecognitionFloatingButton()
    
    /// this box will contain Intant Messages and Mails

    lazy var communicationBox = Div {
        Div {
            Div().height(3.px)
            self.comunicationBoxNewMessagesView
            self.comunicationBoxOldMessagesView
        }
        .overflow(.auto)
    }
    .class(.communicationBox)
    
    /// ``Right Side Bar COMMUNICATION``
    
    /// [ username :  room token]
    var userChatToken: [String:String] = [:]
    
    /// [ RoomToken : BubbleView ]
    var chatBubbleRefrence: [String:IMChatBubbleView] = [:]
    
    /// [ RoomToken :  IMChatRoomView ]
//    var chatRoomRefrence: [String:IMChatRoomView] = [:]
    
    /// Pupulated by API.webSocketV1.custFetchUsers
    @State var privateChatList: [CustChatRoomProfile] = []
    
    @State var publicChatList: [CustChatRoomProfile] = []
    
    lazy var privateChatBoxInner = Div()
        .margin(all: 3.px)
        .fontSize(10.px)
        .hidden(self.$privateChatList.map{ $0.isEmpty } )
    
    lazy var privateChatBox = Div {
        
        self.privateChatBoxInner
        
        Div{
            Span(LString(
                .es("Seleccione a un colega para iniciar una conversación."),
                .en("Select a user to start conversation")
            )).color(.dimGray)
        }
        .overflow(.hidden)
        .margin(all: 3.px)
        .fontSize(10.px)
        .align(.center)
        .hidden(self.$privateChatList.map{ !$0.isEmpty } )
    }
    
    lazy var publicChatBoxInner = Div()
        .hidden(self.$publicChatList.map{ $0.isEmpty } )
        .margin(all: 3.px)
        .fontSize(10.px)
    
    lazy var publicChatBox = Div {
        
        self.publicChatBoxInner
        
        Div(LString(
            .es("No tiene chats publicos, promociona tu pagina!"),
            .en("No mesages. Promote your site for more engagement")
        ))
        .overflow(.hidden)
        .margin(all: 3.px)
        .fontSize(10.px)
        .color(.dimGray)
        .align(.center)
        .hidden(self.$publicChatList.map{ !$0.isEmpty } )
    }
    
    lazy var chatBar = Div {
        Div("Centro de mensajes")
            .fontSize(18.px)
            .fontWeight(.bold)

        Div {
            
            Div{
                Span("Nuevos")

                Span(self.communicationController.$unreadCount.map { count in
                    count > 99 ? "99+" : count.toString
                })
                .marginLeft(5.px)
                .padding(v: 1.px, h: 5.px)
                .borderRadius(all: 10.px)
                .backgroundColor(.blue)
                .color(.white)
                .fontSize(10.px)
                .hidden(self.communicationController.$unreadCount.map { $0 == 0 })
            }
            
            Div("Historial")
            .cursor(.default)
            .opacity(0.3)
            
            Div("Equipo")
            .cursor(.default)
            .opacity(0.3)

        }
        .class(Class(TCWorkDashboardClass.messageTabs))

        Div {
            self.communicationBox
        }
        .class(Class(TCWorkDashboardClass.messageBody))

        Div {
            Span("＋")
                .color(.lightBlueText)
                .fontSize(22.px)
            Span("Chat de Equipo")
        }
        .class(Class(TCWorkDashboardClass.messageAction))
        .cursor(.default)
        .opacity(0.3)
        .onClick {
            self.newPrivateChat()
        }

        Div {
            Img()
                .src("/skyline/media/documentation_icon.png")
                .width(20.px)
            Span("Documentación")
        }
        .class(Class(TCWorkDashboardClass.messageAction))
        .onClick {
            addToDom(SkylineDocumentationView())
        }

        Div {
            Img()
                .src("/images/bizRoundLogoWhite.svg")
                .width(20.px)
            Span("Ayuda")
        }
        .class(Class(TCWorkDashboardClass.messageAction))
        .onClick {
            addToDom(SkylineDocumentationView())
        }
    }
    .class(.chatBar, Class(TCWorkDashboardClass.messages))
    
    //lazy var chatRoom: IMChatRoomView? = nil
    
    lazy var chatRoomNew: IMSocialChatView? = nil
    
    /**
        `Special View Controles` minimize and maximize views
     */
    
    var searchHistoricalPurchaseView: SearchHistoricalPurchaseView? = nil
    
    var searchHistoricalPurchaseSubView: Div? = nil
    
    var storeProductManagerView: ProductManagerView? = nil
    
    var storeProductManagerSubView: Div? = nil
    
    var custTaskAuthorizationView: CustTaskAuthorizationView? = nil
    
    var posSubView: Div? = nil
    
    lazy var posView: SalePointView? = nil

    lazy var workTopIdentity = Div {
        
        Div {
            Img()
                .src("/skyline/media/notificationIcon.png")
                .class(Class(TCWorkDashboardClass.topIcon))

            Span(CatchControler.shared.$taskAlerts.map { alerts in
                alerts.count > 99 ? "99+" : alerts.count.toString
            })
                .fontSize(10.px)
                .color(.white)
                .backgroundColor(.blue)
                .borderRadius(all: 12.px)
                .padding(v: 2.px, h: 5.px)
                .position(.absolute)
                .right(-12.px)
                .top(-6.px)
                .hidden(CatchControler.shared.$taskAlerts.map { $0.isEmpty })
        }
        .position(.relative)
        .cursor(.pointer)
        .onClick {
            self.processAlertManager(manualLoad: true)
        }

        Img()
            .src("/skyline/media/icon_add_message.png")
            .class(Class(TCWorkDashboardClass.topIcon))
            .onClick {
                self.newPrivateChat()
            }

        Span(self.$username)
            .class(.oneLineText)
            .fontSize(14.px)
            .custom("max-width", "100px")

        Img()
            .src("/skyline/media/gear.png")
            .class(Class(TCWorkDashboardClass.topIcon))
            .onClick {
                self.sideMenuIsHidden = !self.sideMenuIsHidden
            }
    }
    .class(Class(TCWorkDashboardClass.topIdentity))

    lazy var workStatsView = Div {
        Div {
            Div("Pendientes")
                .class(Class(TCWorkDashboardClass.statLabel))
            Div(OrderCatchControler.shared.$pendingCount.map { $0.toString })
                .class(Class(TCWorkDashboardClass.statValue))
            Img()
                .src("/skyline/media/icon_pending@128.png")
                .class(Class(TCWorkDashboardClass.statIcon))
        }
        .class(Class(TCWorkDashboardClass.statCard))

        Div {
            Div("En proceso")
                .class(Class(TCWorkDashboardClass.statLabel))
            Div(OrderCatchControler.shared.$activeCount.map { $0.toString })
                .class(Class(TCWorkDashboardClass.statValue))
            Img()
                .src("/skyline/media/icon_active@128.png")
                .class(Class(TCWorkDashboardClass.statIcon))
        }
        .class(Class(TCWorkDashboardClass.statCard))

        Div {
            Div("Por vencer")
                .class(Class(TCWorkDashboardClass.statLabel))
            Div(OrderCatchControler.shared.$attentionCount.map { $0.toString })
                .class(Class(TCWorkDashboardClass.statValue))
            Img()
                .src("/skyline/media/icon_alert@128.png")
                .class(Class(TCWorkDashboardClass.statIcon))
        }
        .class(Class(TCWorkDashboardClass.statCard))

        Div {
            Div("Finalizadas")
                .class(Class(TCWorkDashboardClass.statLabel))
            Div(OrderCatchControler.shared.$finalizedCount.map { $0.toString })
                .class(Class(TCWorkDashboardClass.statValue))
            Img()
                .src("/skyline/media/icon-checkmark.svg")
                .class(Class(TCWorkDashboardClass.statIcon))
        }
        .class(Class(TCWorkDashboardClass.statCard))
    }
    .class(Class(TCWorkDashboardClass.stats))

    private lazy var startupProgressFill = Div()
        .class(Class(TCWorkDashboardClass.startupProgressFill))

    lazy var startupOverlay = Div {
        Div()
            .class(Class(TCWorkDashboardClass.startupScan))

        Div {
            Div {
                Div()
                    .class(Class(TCWorkDashboardClass.startupRing))

                Img()
                    .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            }
            .class(Class(TCWorkDashboardClass.startupEmblem))

            Div("SKYLINE CONTROL")
                .class(Class(TCWorkDashboardClass.startupTitle))

            Div("SECUENCIA DE INICIO")
                .class(Class(TCWorkDashboardClass.startupCopy))

            Div {
                self.startupStatus(.core)
                self.startupStatus(.communications)
                self.startupStatus(.workModules)
            }
            .class(Class(TCWorkDashboardClass.startupStatuses))

            Div {
                self.startupProgressFill
            }
            .class(Class(TCWorkDashboardClass.startupProgress))
        }
        .class(Class(TCWorkDashboardClass.startupCore))
    }
    .class(Class(TCWorkDashboardClass.startupOverlay))
    .attribute("aria-hidden", "true")

    lazy var serviceContainer = Div{

        if linkedProfile.contains(.bizODS) || linkedProfile.contains(.bizFollowUp) {

            /// Buttons
            Div{

                Div{
                    Img()
                        .src("/skyline/media/history_setting_icon_orange.png")
                        .marginRight(18.px)
                        .marginLeft(18.px)
                        .cursor(.pointer)
                        .marginTop(7.px)
                        .height(28.px)
                        .onClick {
                            addToDom(ToolsView.HistorySettings.OrderProcessing())
                        }
                }
                .float(.left)

                OrderCatchControler.shared.listViewButton

                OrderCatchControler.shared.userViewButton
            
                OrderCatchControler.shared.calendarViewButton

                OrderCatchControler.shared.routeViewButton
                
                OrderCatchControler.shared.loadOrderStatusButton
                    .hidden(OrderCatchControler.shared.$macroViewType.map { $0 == .followUpView })
                    .float(.right)

                if linkedProfile.contains(.bizFollowUp) {
                    OrderCatchControler.shared.loadFollowUpsButton
                        .hidden(OrderCatchControler.shared.$macroViewType.map { $0 == .orderView })
                        .float(.right)
                }
                
                Div{
                    OrderCatchControler.shared.selectStoreMenuButton
                    .hidden(self.$userHerk.map{ $0 < 3 })
                }
                .hidden(OrderCatchControler.shared.$stores.map{ $0.count < 2 })
                .float(.right)
                
        /*

                Div("|")
                    .marginRight(7.px)
                    .fontSize(24.px)
                    .color(.white)
                    .float(.right)
                
                /// Delegate
                Div{
                    Img()
                        .src("/skyline/media/icon_delegate.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Delegar")
                }
                .onClick({
                    
                })
                .marginRight(12.px)
                .class(.uibtn)
                .float(.right)
                
                /// Transfer
                Div{
                    Img()
                        .src("/skyline/media/icon_trasfer.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Transferir")
                }
                .marginRight(7.px)
                .class(.uibtn)
                .float(.right)
                .onClick{
                    
                }
                
                /// Recive
                Div{
                    Img()
                        .src("/skyline/media/icon_recive.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Recibir")
                }
                .onClick({
                    
                })
                .marginRight(7.px)
                .class(.uibtn)
                .float(.right)
                */
            }
            .margin(all: 0.px)
            .class(Class(TCWorkDashboardClass.toolbar))
            .hidden(self.$pmode.map{ $0 != .serviceOrder })
            
            Div{
                
                Div{
                    Img()
                        .src("/skyline/media/reload.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Por Vencer")
                }
                .onClick({
                    
                })
                .class(.uibtn)
                .float(.right)
                
                /// Mis Ordenes
                Div{
                    
                    Img()
                        .src("/skyline/media/reload.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Vencidos")
                }
                .onClick({
                    
                })
                .class(.uibtn)
                .float(.right)
                
                Div{
                    Img()
                        .src("/skyline/media/reload.png")
                        .height(18.px)
                        .marginLeft(7.px)
                    
                    Span("Por Vencer")
                }
                .onClick({
                    
                })
                .class(.uibtn)
                .float(.right)
                
                
                Div().class(.clear)
                
            }
            .marginBottom(3.px)
            .marginRight(12.px)
            .marginLeft(12.px)
            .marginTop(7.px)
            .hidden(self.$pmode.map{ $0 != .clubMembership })

            self.workStatsView
                .hidden(self.$pmode.map { $0 != .serviceOrder })
            
            /// Grid
            Div{
                OrderCatchControler.shared.container
                    .class(Class(TCWorkDashboardClass.orderColumn))
                OrderCatchControler.shared.secondView
                    .class(Class(TCWorkDashboardClass.orderColumn))
            }
            .custom("height", "calc(100% - 176px)")
            .padding(top: 0.px, right: 12.px, bottom: 12.px, left: 12.px)
            .class(Class(TCWorkDashboardClass.orderGrid))
            
        }
        else if linkedProfile.contains(.bizPDV) {
            
            SalePointView(loadBy: nil, isSubView: true)
            
        }
        
        Div().clear(.both)
    }
    .custom("width", "calc(100% - 458px)")
    .custom("height", "calc(100% - 70px)")
    .backgroundColor(.transparent)
    .borderRadius(all: 0.px)
    .position(.absolute)
    .overflow(.hidden)
    .left(178.px)
    .top(70.px)
    .class(Class(TCWorkDashboardClass.workspace))
    .hidden(OrderCatchControler.shared.$macroViewType.map {
        $0 != .orderView && $0 != .followUpView
    })


    lazy var accountContainer = Div{

        /// Top Menu Buttons
        Div{

            Div{
                Img()
                    .src("/skyline/media/reload.png")
                    .height(18.px)
                    .marginRight(7.px)

                Span("Recargar")
            }
            .class(.uibtn)
            .float(.right)
            .onClick {
                OrderCatchControler.shared.loadAccounts(force: true)
            }
        }
        .margin(all: 0.px)
        .class(Class(TCWorkDashboardClass.toolbar))

        Div().clear(.both).height(7.px)

        /// Grid
        Div{
            OrderCatchControler.shared.accountContainer
                .class(Class(TCWorkDashboardClass.orderColumn))
            OrderCatchControler.shared.accountSecondContainer
                .class(Class(TCWorkDashboardClass.orderColumn))
        }
        .custom("height", "calc(100% - 67px)")
        .padding(top: 0.px, right: 12.px, bottom: 12.px, left: 12.px)
        .class(Class(TCWorkDashboardClass.orderGrid))


        Div().clear(.both)
    }
    .custom("width", "calc(100% - 458px)")
    .custom("height", "calc(100% - 70px)")
    .backgroundColor(.transparent)
    .borderRadius(all: 0.px)
    .position(.absolute)
    .overflow(.hidden)
    .left(178.px)
    .top(70.px)
    .class(Class(TCWorkDashboardClass.workspace))
    .hidden(OrderCatchControler.shared.$macroViewType.map {
        $0 != .accountView
    })


    /*
    lazy var followupContainer = Div()
         .custom("width", "calc(100% - 458px)")
        .custom("height", "calc(100% - 70px)")
        .backgroundColor(.transparent)
        .borderRadius(all: 0.px)
        .position(.absolute)
        .overflow(.hidden)
        .left(178.px)
        .top(70.px)
        .class(Class(TCWorkDashboardClass.workspace))
        .hidden(OrderCatchControler.shared.$macroViewType.map{ ( $0 != .followupView ) })
    */

    lazy var tripContainer = Div()
         .custom("width", "calc(100% - 458px)")
        .custom("height", "calc(100% - 70px)")
        .backgroundColor(.transparent)
        .borderRadius(all: 0.px)
        .position(.absolute)
        .overflow(.hidden)
        .left(178.px)
        .top(70.px)
        .class(Class(TCWorkDashboardClass.workspace))
        .hidden(OrderCatchControler.shared.$macroViewType.map{ ( $0 != .tripView ) })

    private func workNavigationItem(
        selection: WorkNavigationSelection?,
        icon: String,
        title: String,
        action: @escaping () -> Void
    ) -> Div {
        Div {
            Img()
                .src(icon)
                .class(Class(TCWorkDashboardClass.navIcon))
            Span(title)
                .fontSize(15.px)
        }
        .class(Class(TCWorkDashboardClass.navItem))
        .class(self.$selectedWorkNavigationItem.map { selected -> Class? in
            selected == selection
                ? Class(TCWorkDashboardClass.navItemActive)
                : nil
        })
        .onClick {

            if let selection {
                self.selectedWorkNavigationItem = selection
            }

            action()
        }
    }

    private func startupStatus(_ step: WorkStartupStep) -> Div {
        let indicator = Div()
            .class(Class(TCWorkDashboardClass.startupIndicator))
        let label = Span(WorkStartupState.waiting.label)
        let value = Div {
            indicator
            label
        }
        .class(
            Class(TCWorkDashboardClass.startupState),
            Class(WorkStartupState.waiting.cssClass)
        )

        startupLabels[step] = label
        startupValues[step] = value

        return Div {
            Span(step.title)
            value
        }
        .class(Class(TCWorkDashboardClass.startupStatus))
    }

    private func startDashboardStartupSequence() {
        startupSequenceIsCompleting = false

        WorkStartupStep.allCases.forEach {
            updateStartupStep($0, state: .waiting)
        }

        updateStartupStep(.core, state: .loading)

        Dispatch.asyncAfter(0.08) {
            self.removeClass(Class(TCWorkDashboardClass.startupRoot))
        }
    }

    private func updateStartupStep(
        _ step: WorkStartupStep,
        state: WorkStartupState
    ) {
        let allStateClasses = [
            TCWorkDashboardClass.startupStateWaiting,
            TCWorkDashboardClass.startupStateLoading,
            TCWorkDashboardClass.startupStateOnline,
            TCWorkDashboardClass.startupStateFailed,
            TCWorkDashboardClass.startupStateSkipped
        ]

        if let value = startupValues[step] {
            allStateClasses.forEach {
                value.removeClass(Class($0))
            }
            value.class(Class(state.cssClass))
        }

        if let label = startupLabels[step] {
            _ = label.innerText(state.label)
        }

        startupStates[step] = state

        let completedSteps = WorkStartupStep.allCases.filter {
            startupStates[$0]?.isTerminal == true
        }.count
        let progress = Double(completedSteps) / Double(WorkStartupStep.allCases.count)

        startupProgressFill.custom(
            "transform",
            "scaleX(\(progress))"
        )

        guard completedSteps == WorkStartupStep.allCases.count else {
            return
        }

        finishDashboardStartupSequence()
    }

    private func finishDashboardStartupSequence() {
        guard !startupSequenceIsCompleting else {
            return
        }

        startupSequenceIsCompleting = true

        Dispatch.asyncAfter(0.45) {
            self.startupOverlay.class(Class(TCWorkDashboardClass.startupComplete))
        }

        Dispatch.asyncAfter(0.95) {
            self.startupOverlay.remove()
        }
    }

    private func cancelPendingStartupSteps() {
        WorkStartupStep.allCases.forEach { step in
            guard startupStates[step]?.isTerminal != true else {
                return
            }
            updateStartupStep(step, state: .skipped)
        }
    }
    
    @DOM override var body: DOM.Content {
        
        Link()
            .href("/skyline/css/main.css")
            .rel(.stylesheet)
            .onLoad { }
        
        Link()
            .href("/skyline/css/jcrop.css")
            .rel(.stylesheet)
            .onLoad { }
        
        Script()
            .src("/skyline/js/main.js")
            .type("text/javascript")
            .onLoad {
                VisualPerformanceSettings.apply()
            }

        Script()
            .src("/skyline/js/speechRecognition.js")
            .type("text/javascript")
            .onLoad { [weak self] in
                self?.speechRecognitionControl.refreshAvailability()
            }
        
        Script()
            .src("/js/socialjs.js")
            .type("text/javascript")
            .onLoad { }
        
        Script()
            .src("/skyline/js/jcrop.js")
            .type("text/javascript")
            .onLoad {
                VisualPerformanceSettings.apply()
            }
        
        Script()
            .src("/skyline/js/JsBarcode.all.min.js")
            .type("text/javascript")
            .onLoad {
                
            }
        
        Script()
            .src("https://tierracero.com/dev/skyline/js/QRCode.js")
            .type("text/javascript")
            .onLoad {
                
            }
        
        Script()
            .src("https://js.hcaptcha.com/1/api.js")
            .type("text/javascript")
            .async(true)
            .defer(true)
        
        // https://cdn.apple-mapkit.com/mk/5.44.0/mapkit.js
        Script()
            .src("https://cdn.apple-mapkit.com/mk/5.x.x/mapkit.js")
            .type("text/javascript")
        
        Div()
        .class(.blur, Class(TCWorkDashboardClass.background))
        .backgroundImage("skyline/media/bgBlueTech02.jpg")
        .width(100.percent)
        .height(100.percent) 
        .backgroundSize(all: .cover)

        self.startupOverlay
        
        // top Menu
        Div{
            Div{

                self.workTopIdentity
                
                Span()
                    .paddingRight(7.px)
                
                // Crear Cuenta
                Div{
                    Span("+")
                        .class(Class(TCWorkDashboardClass.actionPlus))
                    
                    Span("Cuenta")
                    
                }
                .class(.topBarButton)
                .onClick {
                    
                    addToDom(CreateNewCusomerView(
                        searchTerm: "",
                        custType: .general,
                        callback: { acctType, custType, searchTerm in
                            
                            let custDataView = CreateNewCustomerDataView(
                                acctType: acctType,
                                custType: custType,
                                orderType: .account,
                                searchTerm: ""
                            ) { account in
                                
                                loadAccountView(id: .id(account.id))
                                
                            }

                            addToDom(custDataView)
                            
                        }))
                    
                }

                Div{
                    Span("+")
                        .class(Class(TCWorkDashboardClass.actionPlus))
                    
                    Span("Seguimiento")
                    
                }
                .display(self.$pmode.map{ ($0 == .serviceOrder) ? .inlineBlock : .none })
                .class(.topBarButton)
                .onClick {
                    self.newOrderSearchCustomer(.followup)
                }

                // Punto de Venta
                if linkedProfile.contains(.bizPDV) {
                    Div{
                        Span("+")
                            .class(Class(TCWorkDashboardClass.actionPlus))
                        
                        Span("Venta")
                        
                    }
                    .class(.topBarButton)
                    .onClick {
                        self.openSalePoint()
                    }
                }
                
                // Nuevo folio
                // Punto de Venta
                if linkedProfile.contains(.bizODS) {
                    Div{
                        Span("+")
                            .class(Class(TCWorkDashboardClass.actionPlus))
                        
                        Span("Orden")
                        
                    }
                    .display(self.$pmode.map{ ($0 == .serviceOrder) ? .inlineBlock : .none })
                    .class(.topBarButton)
                    .onClick {
                        
                        if self.newOrderInProccess { return }
                        
                        self.newOrderInProccess = true
                        
                        if configStoreProcessing.moduleProfile.count == 1 {
                            if let orderType = configStoreProcessing.moduleProfile.first {
                                self.newOrderInProccess = false
                                self.newOrderSearchCustomer(orderType)
                            }
                        }
                        else{
                            addToDom(SelectNewOrderTypeView { orderType in
                                
                                self.newOrderInProccess = false
                                
                                guard let orderType = orderType else {
                                    return
                                }
                                
                                self.newOrderSearchCustomer(orderType)
                                
                            })
                        }
                        
                    }
                }
                
                Div{
                    
                    Div{
                        Div("Busqueda")
                        Div("Avanzada")
                    }
                    .paddingRight(7.px)
                    .paddingLeft(7.px)
                    .marginRight(3.px)
                    .marginLeft(3.px)
                    .marginTop(3.px)
                    .fontSize(14.px)
                    .color(.gray)
                    .float(.left)
                    
                }
                .marginRight(12.px)
                .marginTop(7.px)
                .float(.right)
                .class(.uibtn)
                .onClick {
                    
                    addToDom(AdvancesSearchViewControler(
                        searchTerm: self.searchTerm,
                        orders: [],
                        accounts: []
                    ))
                }
                
                Div {
                    InputButton()
                        .backgroundSize(h: 100.percent, v: 100.percent)
                        .backgroundImage("images/zoom.png")
                        .cursor(.pointer)
                        .class(.button)
                        .onClick {
                            self.searchFolio(false)
                        }

                    InputText(self.$searchTerm)
                        .placeholder(self.$serchPlaceHolder)
                        .onKeyUp({ tf, event in
                            var _term = tf.text.purgeSpaces

                            Dispatch.asyncAfter(0.37) {
                                if _term == tf.text {
                                    _term = _term.replace(from: "'", to: "-").replace(from: "`", to: "-")
                                    if _term.count > 8 && _term.contains("-") {

                                        if ignoredKeys.contains(tf.text) {
                                            return
                                        }

                                        if _term.hasPrefix("qr-") {
                                            return
                                        }

                                        self.searchFolio(false)

                                        Dispatch.asyncAfter(0.25) {
                                            self.searchTerm = ""
                                        }
                                    }
                                }
                            }
                        })
                        .onEnter {
                            self.searchFolio(false)
                        }

                    Img()
                        .src("/skyline/media/mobileScannerWhite.png")
                        .cursor(.pointer)
                        .onClick {
                            self.requestMobileScanner()
                        }
                }
                .class(Class(TCWorkDashboardClass.searchBox))
             
                Div().clear(.both)
                
            }
            .align(.left)
            .custom("width", "calc(100% - 24px)")
            
        }
        .align(.center)
        .custom("background", "rgba(3, 14, 29, 0.92)")
        .custom("-webkit-box-shadow", "0px 2px 15px #333333")
        .custom("box-shadow", "0px 2px 15px #333333")
        .custom("text-shadow", "1px 0 0 #666666")
        .custom("width", "calc(100% - 178px)")
        .height(70.px)
        .color(.white)
        .position(.absolute)
        .left(178.px)
        .top(0.px)
        .boxShadow(h: 0.px, v: 2.px, blur: 15.px, color: .hex(333333))
        .zIndex(999999990)
        .class(Class(TCWorkDashboardClass.topBar))
        .onClick {
            OrderCatchControler.shared.loadOrderStatusTypeIsHidden = true
            OrderCatchControler.shared.selectStoreMenuIsHidden = true
        }

        // Service Grid
        self.serviceContainer
        
        // Trip Contaier:
        self.tripContainer

        self.accountContainer

        // Side Bar
        self.sideBar
        
        self.chatBar
        
        /// side Menu
        self.sideMenu
        
        self.userLocationsButton
        
        OrderCatchControler.shared.addRouteButton

        OrderCatchControler.shared.selectStoreMenuBackgroung

        OrderCatchControler.shared.loadOrderStatusBackgroung

        self.speechRecognitionControl
        
        WebApp.current.loadingView
        
        WebApp.current.minimizedGrid
        
        WebApp.current.messageGrid
        
        self.sideMenu.fadeOut(time: 0, end:.hidden)
        
    }
    
    lazy var userLocationsButton = Div{
        Div{
            Img()
                .src("/skyline/media/user_location_icon.png")
                .marginRight(7.px)
                .marginLeft(7.px)
                .marginTop(7.px)
                .height(50.px)
                .width(50.px)
        }
        .align(.center)
    }
    .hidden( OrderCatchControler.shared.$viewType.map{ !($0 == .routeView) })
    .class(.uibtn, .roundGrayBlackDark)
    .borderRadius(50.percent)
    .position(.absolute)
    .cursor(.pointer)
    .bottom(97.px)
    .right(75.px)
    .height(62.px)
    .width(62.px)
    .onClick {
        
        loadingView.show()
        
        API.custRouteV1.userLocations { resp in
        
            loadingView.hide()
            
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
            
            let view = OrderRouteView.UserLocations(
                userLocations: payload.userLocations
            )
            
            addToDom(view)
            
        }
        
    }

    override func buildUI() {
        super.buildUI()

        TCWorkDashboardTheme.install()
        self.class(Class(TCWorkDashboardClass.root))
        self.class(Class(TCWorkDashboardClass.startupRoot))
        
        if let str = WebApp.current.window.localStorage.string(forKey: "linkedProfile") {
            if let data = str.data(using: .utf8) {
                do {
                    linkedProfile = try JSONDecoder().decode([PanelConfigurationObjects].self, from: data)
                }
                catch { }
            }
        }
        
        title = "Tierra Cero | Skyline"
        metaDescription = "Bienvenidos!!"
        id("body")
        
        height(100.percent)
        width(100.percent)
        
        Window.shared.document.addEventListener(.keyUp) { event in
            guard let key = event.jsEvent.object?.key else { return }
            if key.description.lowercased() == "escape" {
                _ = JSObject.global.closeUIView!()
            }
        }
        
        WebApp.current.wsevent.listen {
            guard self.isInDOM else { return }
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event = event else {
                return
            }
            print("⚡️ EVENT \(event)")
            switch event {
            case .pong:
                _ = self.ws.pong($0)
            case .welcome:
                
                if let _ = self.ws.welcome($0) {
                    print("⚡️ Welcome")
                    
                    /// load chat rooms
                    API.webSocketV1.custFetchUsers { resp in
                        
                        guard let resp else {
                            return
                        }
                        
                        guard let data = resp.data else {
                            return
                        }
                        do {
                            let data = try JSONEncoder().encode(resp)
                            print(String(data: data, encoding: .utf8)!)
                        }
                        catch {}
                        
                        /// Load the Room Profiles to this list, to use as refrence  to load char rooms.
                        self.privateChatList = data.roomsProfile
                        
                        self.publicChatList = data.publicRoomsProfile
                        
                        data.publicRoomsProfile.forEach { room in
                            
                            if let _ = self.chatBubbleRefrence[room.token] {
                                return
                            }
                            
                            let view = IMChatBubbleView(
                                data: room
                            ) { room in
                                
                                if let _room = self.chatRoomNew {
                                    print("i have room")
                                    
                                    switch _room.roomid {
                                    case .id(let id):
                                        if id == room.id {
                                            return
                                        }
                                    case .folio(let token):
                                        if token == room.token {
                                            return
                                        }
                                    }
                                    
                                    if self.chatRoomNew != nil {
                                        self.chatRoomNew?.remove()
                                    }
                                    
                                    self.chatRoomNew = IMSocialChatView(
                                        roomType: room.type,
                                        profileType: .general,
                                        roomid: .folio(room.token),
                                        name: room.nick,
                                        avatar: room.avatar,
                                        callback: { chatIsArchived in
                                            if chatIsArchived {
                                                self.chatBubbleRefrence[room.token]?.remove()
                                                self.chatBubbleRefrence.removeValue(forKey: room.token)
                                            }
                                            self.chatRoomNew = nil
                                        }, sentMessage: { room, message, lastMessageAt in
                                            
                                            self.chatBubbleRefrence[room.token]?.message = message
                                            self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                            
                                        })
                                    
                                    addToDom(self.chatRoomNew!)
                                    
                                    Dispatch.asyncAfter(0.5) {
                                        //dragElement("chatWindows")
                                    }
                                    
                                }
                                else {
                                    
                                    self.chatRoomNew = IMSocialChatView(
                                        roomType: room.type,
                                        profileType: room.profileType,
                                        roomid: .folio(room.token),
                                        name: room.nick,
                                        avatar: room.avatar,
                                        callback: { chatIsArchived in
                                            if chatIsArchived {
                                                self.chatBubbleRefrence[room.token]?.remove()
                                                self.chatBubbleRefrence.removeValue(forKey: room.token)
                                            }
                                            self.chatRoomNew = nil
                                            
                                        }, sentMessage: { room, message, lastMessageAt in
                                            
                                            self.chatBubbleRefrence[room.token]?.message = message
                                            self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                            
                                        })
                                    
                                    addToDom(self.chatRoomNew!)
                                }
                                 
                            }
                            
                            /// Bubble refrens
                            self.chatBubbleRefrence[room.token] = view
                            
                            /// Chats Array `I think i have no use other than  know howmany convs i have `
                            self.publicChatList.append(room)
                            
                            self.publicChatBoxInner.appendChild(view)
                            
                        }

                    }
                    
                }
                else{
                    
                }
            case .custFetchUsersResponse:
                break
            case .requestUserToChatResponse:
                
                if let payload = self.ws.requestUserToChat($0) {
                    
                    let custChatRoomProfile = payload.custChatRoomProfile
                 
                    if let room = self.chatRoomNew {
                        
                        var sameRoom = false
                        
                        switch room.roomid {
                        case .id(let id):
                            if id == custChatRoomProfile.id {
                                sameRoom = true
                            }
                        case .folio(let token):
                            if token == custChatRoomProfile.token {
                                sameRoom = true
                            }
                        }
                        
                        // i have chat room must make sure its the same
                        if sameRoom {
                            
                            if let message = payload.message {
                                
                                /// Same Id  so will print to room
                                // 1) update chat bubble
                                self.chatBubbleRefrence[custChatRoomProfile.token]?.updateLastMessage(
                                    msg: message,
                                    showBubble: false
                                )
                                
                                // 2) to current chat room
                                self.chatRoomNew?.addMessageToGrid(message)
                                
                                // 3) notify status update
                                self.ws.confirmMessageRead(
                                    custChatRoomProfile.token,
                                    token: message.mid
                                )
                            }
                            
                            
                        }
                        else{
                            
                            if let message = payload.message {
                                
                                /// Get Show in chat bubble
                                /// Room is not the same, update / show bubble
                                self.chatBubbleRefrence[custChatRoomProfile.token]?.updateLastMessage(
                                    msg: message,
                                    showBubble: true
                                )
                                
                                self.ws.confirmMessageRecived(
                                    custChatRoomProfile.token,
                                    token: message.mid
                                )
                            }
                            
                        }
                    
                    }
                    else {
                        /// No room opened, update / show bubble
                        
                        guard let message = payload.message else {
                            return
                        }
                        
                        self.chatBubbleRefrence.forEach { roomid, _ in
                            print(roomid + " VS " + custChatRoomProfile.token)
                        }
                        
                        
                        if let _ = self.chatBubbleRefrence[custChatRoomProfile.token] {
                            print("🟢 bubble")
                            self.chatBubbleRefrence[custChatRoomProfile.token]?.updateLastMessage(
                                msg: message,
                                showBubble: true
                            )
                        }
                        else {
                            print("🔴 bubble")
                            
                            let view = IMChatBubbleView(
                                data: custChatRoomProfile
                            ) { room in
                                
                                if let _room = self.chatRoomNew {
                                    print("i have room")
                                    
                                    switch _room.roomid {
                                    case .id(let id):
                                        if id == room.id {
                                            return
                                        }
                                    case .folio(let token):
                                        if token == room.token {
                                            return
                                        }
                                    }
                                    
                                    if self.chatRoomNew != nil {
                                        self.chatRoomNew?.remove()
                                    }
                                    
                                    self.chatRoomNew = IMSocialChatView(
                                        roomType: room.type,
                                        profileType: .general,
                                        roomid: .folio(room.token),
                                        name: room.nick,
                                        avatar: room.avatar,
                                        callback: { chatIsArchived in
                                            if chatIsArchived {
                                                self.chatBubbleRefrence[room.token]?.remove()
                                                self.chatBubbleRefrence.removeValue(forKey: room.token)
                                            }
                                            self.chatRoomNew = nil
                                        }, sentMessage: { room, message, lastMessageAt in
                                            
                                            self.chatBubbleRefrence[room.token]?.message = message
                                            self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                            
                                        })
                                    
                                    addToDom(self.chatRoomNew!)
                                    
                                    Dispatch.asyncAfter(0.5) {
                                        //dragElement("chatWindows")
                                    }
                                    
                                }
                                else {
                                    
                                    self.chatRoomNew = IMSocialChatView(
                                        roomType: room.type,
                                        profileType: room.profileType,
                                        roomid: .folio(room.token),
                                        name: room.nick,
                                        avatar: room.avatar,
                                        callback: { chatIsArchived in
                                            if chatIsArchived {
                                                self.chatBubbleRefrence[room.token]?.remove()
                                                self.chatBubbleRefrence.removeValue(forKey: room.token)
                                            }
                                            self.chatRoomNew = nil
                                            
                                        }, sentMessage: { room, message, lastMessageAt in
                                            
                                            self.chatBubbleRefrence[room.token]?.message = message
                                            self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                            
                                        })
                                    
                                    addToDom(self.chatRoomNew!)
                                }
                                 
                            }
                            
                            /// Bubble refrens
                            self.chatBubbleRefrence[custChatRoomProfile.token] = view
                            
                            /// Chats Array `I think i have no use other than  know howmany convs i have `
                            self.publicChatList.append(custChatRoomProfile)
                            
                            self.publicChatBoxInner.appendChild(view)
                            
                        }
                        
                        self.chatRoomNew = IMSocialChatView(
                            roomType: custChatRoomProfile.type,
                            profileType: custChatRoomProfile.profileType,
                            roomid: .folio(custChatRoomProfile.token),
                            name: custChatRoomProfile.nick,
                            avatar: custChatRoomProfile.avatar,
                            callback: { chatIsArchived in
                                if chatIsArchived {
                                    self.chatBubbleRefrence[custChatRoomProfile.token]?.remove()
                                    self.chatBubbleRefrence.removeValue(forKey: custChatRoomProfile.token)
                                }
                                self.chatRoomNew = nil
                            }, sentMessage: { room, message, lastMessageAt in
                                
                                self.chatBubbleRefrence[room.token]?.message = message
                                self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                
                            })
                        
                        addToDom(self.chatRoomNew!)
                        
                        
                    }
                    
                }
                 
            case .iAmWritingNotification:
                break
            case .reciveMessage:
                
                if let payload = self.ws.reciveMessage($0){
                    
                    /// Their is a chat room opend
                    if let room = self.chatRoomNew {
                        // i have chat room must make sure its the same
                        
                        var isSameRoom = false
                        
                        switch room.roomid {
                        case .id( let id):
                            if payload.roomid == id {
                                isSameRoom = true
                            }
                        case .folio(let token):
                            if payload.roomToken == token {
                                isSameRoom = true
                            }
                        }
                        
                        if isSameRoom {
                            
                            /// Same Id  so will print to room
                            print("002")
                            // 1) update chat bubble
                            self.chatBubbleRefrence[payload.roomToken]?.updateLastMessage(msg: payload.message, showBubble: false)
                            
                            // 2) to current chat room
                            self.chatRoomNew?.addMessageToGrid(payload.message)
                            
                            // 3) notify status update
                            self.ws.confirmMessageRead(payload.roomToken, token: payload.message.mid)
                            
                        }
                        else{
                            print("003")
                            
                            /// Get Show in chat bubble
                            /// Room is not the same, update / show bubble
                            self.chatBubbleRefrence[payload.roomToken]?.updateLastMessage(msg: payload.message, showBubble: true)
                            
                            self.ws.confirmMessageRecived(payload.roomToken, token: payload.message.mid)
                            
                        }
                         
                    }
                    /// Their is no chat room opened
                    else {
                        print("004")
                        
                        /// Their is bubble, update
                        if let _ = self.chatBubbleRefrence[payload.roomToken] {
                            
                            self.chatBubbleRefrence[payload.roomToken]?.updateLastMessage(msg: payload.message, showBubble: true)
                            
                            self.ws.confirmMessageRecived(payload.roomToken, token: payload.message.mid)
                            
                        }
                        /// No bububle  pull data and create bubble
                        else {
                            
                            API.webSocketV1.getChatRoom(
                                roomid: .folio(payload.roomToken)
                            ) { resp in
                                
                                guard let resp else {
                                    showError(.comunicationError, .serverConextionError)
                                    return
                                }

                                guard resp.status == .ok else {
                                    showError(.generalError, resp.msg)
                                    return
                                }

                                guard let payload = resp.data else {
                                    showError(.unexpectedResult, "No se obtuvo payload de data.")
                                    return
                                }
                                
                                let view = IMChatBubbleView(
                                    data: payload
                                ) { room in
                                    
                                    if let _room = self.chatRoomNew {
                                        print("i have room")
                                        
                                        switch _room.roomid {
                                        case .id(let id):
                                            if id == room.id {
                                                return
                                            }
                                        case .folio(let token):
                                            if token == room.token {
                                                return
                                            }
                                        }
                                        
                                        if self.chatRoomNew != nil {
                                            self.chatRoomNew?.remove()
                                        }
                                        
                                        self.chatRoomNew = IMSocialChatView(
                                            roomType: room.type,
                                            profileType: .general,
                                            roomid: .folio(room.token),
                                            name: room.nick,
                                            avatar: room.avatar,
                                            callback: { chatIsArchived in
                                                if chatIsArchived {
                                                    self.chatBubbleRefrence[room.token]?.remove()
                                                    self.chatBubbleRefrence.removeValue(forKey: room.token)
                                                }
                                                self.chatRoomNew = nil
                                            }, sentMessage: { room, message, lastMessageAt in
                                                
                                                self.chatBubbleRefrence[room.token]?.message = message
                                                self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                                
                                            })
                                        
                                        addToDom(self.chatRoomNew!)
                                        
                                        Dispatch.asyncAfter(0.5) {
                                            //dragElement("chatWindows")
                                        }
                                        
                                    }
                                    else {
                                        
                                        self.chatRoomNew = IMSocialChatView(
                                            roomType: room.type,
                                            profileType: room.profileType,
                                            roomid: .folio(room.token),
                                            name: room.nick,
                                            avatar: room.avatar,
                                            callback: { chatIsArchived in
                                                if chatIsArchived {
                                                    self.chatBubbleRefrence[room.token]?.remove()
                                                    self.chatBubbleRefrence.removeValue(forKey: room.token)
                                                }
                                                self.chatRoomNew = nil
                                                
                                            }, sentMessage: { room, message, lastMessageAt in
                                                
                                                self.chatBubbleRefrence[room.token]?.message = message
                                                self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                                                
                                            })
                                        
                                        addToDom(self.chatRoomNew!)
                                    }
                                     
                                }
                                
                                /// Bubble refrens
                                self.chatBubbleRefrence[payload.token] = view
                                
                                /// Chats Array `I think i have no use other than  know howmany convs i have `
                                self.publicChatList.append(payload)
                                
                                self.publicChatBoxInner.appendChild(view)
                                
                            }
                        }
                        
                    }
                    
                }
                else{
                    print("005")
                }
                
            case .updateMessageStatus:

                if let payload = self.ws.updateMessageStatus($0){
                    
                    print("updateMessageStatus 001")
                    
                    if let room = self.chatRoomNew {
                        print("updateMessageStatus 002")
                        // i have chat room must make sure its the same
                        if room.roomAccountToken == payload.roomToken {
                            print("updateMessageStatus 003")
                            
                            
                            self.chatRoomNew?.updateMessageStatus(payload)
                        }
                    }
                }
                else{
                    print("updateMessageStatus ❌1")
                }
            case .NewChatRoomNotification:
                
                if let payload = self.ws.newChatRoom($0){
                    self.privateChatList.append(payload.room)
                }
                else{
                    
                }
            case .NotifyLoginNotification:
                
                if let payload = self.ws.notifyLogin($0){
                    if let chatToken = self.userChatToken[payload.username] {
                        print("⚡️  NotifyLoginNotification  chatToken \(chatToken)")
                        if let _ = self.chatBubbleRefrence[chatToken] {
                            self.chatBubbleRefrence[chatToken]?.isActive = true
                        }
                        else{
                            print("❌  NotifyLoginNotification chatBubbleRefrence")
                        }
                    }
                    else{
                        print("❌  NotifyLoginNotification chatToken")
                    }
                }
                else{
                    print("❌  NotifyLoginNotification payload")
                }
            case .NotifyLogoutNotification:
                
                if let payload = self.ws.notifyLogout($0) {
                    if let chatToken = self.userChatToken[payload.username] {
                        print("⚡️  NotifyLogoutNotification  chatToken \(chatToken)")
                        if let _ = self.chatBubbleRefrence[chatToken] {
                            self.chatBubbleRefrence[chatToken]?.isActive = false
                        }
                        else{
                            
                            print("❌  NotifyLogoutNotification chatBubbleRefrence")
                        }
                    }
                    else{
                        print("❌  NotifyLogoutNotification chatToken")
                    }
                }
                
            case .alertStatusUpdate:
                
                if let payload = self.ws.alertStatusUpdate($0){
                    self.communicationController.updateStatus(
                        conversationId: payload.orderid,
                        status: payload.status
                    )
                }
                
            case .asyncCustMessageSent:
                if let payload = self.ws.asyncCustMessageSent($0){
                    
                    if payload.fromMe { return }
                    
                    //var status: CustAlertRefrenceStatus = .new
                    
                    /// Search If their is a acctid refrence (user order id)
                    if let accountid = minViewOrderAccountRefrence[payload.rel] {
                        /// I have foun the `accountid`, Search if `AccoutOvervVew` is available
                        if let accoutOverview = minViewAcctRefrence[accountid] {
                            /// Their is `ViewAcct` open, ;ets cheke it on the order
                            if accoutOverview.order?.id == payload.rel {
                                /// ther `order` that is loaded is the same that the `note` is intended to,
                                /// will modifi note status and  push it to UI
                                //status = .viewed

                                accoutOverview._orderView?.messageGrid.reciveMessage(note: payload.note)

                            }
                        }
                    }
                    
                    var userid: HybridIdentifier? = nil
                    
                    if let createdBy = payload.note.createdBy {
                        userid = .id(createdBy)
                    }
                    
                    let message = API.custAPIV1.LoadMessaging(
                        id: payload.note.id,
                        orderid: payload.rel,
                        type: .message, // CustAlertRefrenceType
                        subType: .order,
                        folio: payload.folio,
                        lastMessageAt: payload.note.createdAt,
                        userid: userid,
                        name: payload.name,
                        avatar: "",
                        activity: payload.note.activity,
                        status: .new
                    )

                    self.communicationController.upsert(message)
                    
                }
            case .asyncFileUpload:
                break
            case .asyncFileUpdate:
                break
            case .asyncFileOCR:
                break
            case .asyncRemoveBackground:
                break
            case .asyncCropImage:
                break
            case .waMsgStatusUpdate:
                /*
               if let payload = self.ws.waMsgStatusUpdate($0){

                   print("⚠️ Compleat function ⚠️ ")
                   print("⚠️ Compleat function ⚠️ ")

                   // tengo que buscar en la refs de laceunta y ver  si ezta abierto la venta y actualizar

               }
               else{

               }
               */
                    break
            case .NotifyAddFacebookProfile:
                /// This will be managed  by  ``SocialManagerAddProfileView``
                return
            case .NotifyAddYoutubeProfile:
                break
            case .NotifyAddMercadoLibreProfile:
                break
            case .metaNewMessengerPayload:
                
                if let payload = self.ws.metaNewMessengerPayload($0){
                    // their is an Active Chat Room
                    if let chatRoomNew = self.chatRoomNew {
                        // Get Active Char Room id
                        
                        if let roomAccountId = chatRoomNew.roomAccountId {
                            // The message target id is the sale room id
                            if payload.socialAccount == roomAccountId {
                                
                                chatRoomNew.addMessageToGrid(payload.message)
                                return
                            }
                            
                        }
                    }
                    
                    if let alert = payload.alert {
                        self.communicationController.upsert(alert)
                    }
                }
                
            case .addSocialReaction:
                break
            case .removeSocialReaction:
                break
            case .confirmSentMessage:
                
                if let payload = self.ws.confirmSentMessage($0) {
                    
                    if let chatRoomNew = self.chatRoomNew {
                        
                        if let roomAccountToken = chatRoomNew.roomAccountToken {
                            
                            if payload.roomToken == roomAccountToken {
                                
                                chatRoomNew.confimedRecivedMessage(
                                    sincToken: payload.sincToken,
                                    mid: payload.mid
                                )
                                
                            }
                            
                        }
                    }
                }
                else {
                    
                }
            case .requestMobileCamaraComplete:
                break
            case .requestMobileCamaraFail:
                break
            case .requestMobileCamaraInitiate:
                break
            case .requestMobileCamaraProgress:
                break
            case .requestMobileScannerComplete:
                
                if let payload = self.ws.requestMobileScannerComplete($0) {
                    
                    guard self.viewid == payload.eventid else {
                        print("🔴  requestMobileScannerComplete view missmatch")
                        print(self.viewid.uuidString + " VS " + payload.eventid.uuidString)
                        return
                    }
                    
                    // searchFolio
                    let text = payload.text
                    print("🟢  sat.gob.")

                    if text.contains("/c/") {
                        
                        let parts = text.explode("/c/")
                        
                        var code = parts.last ?? ""
                        
                        if !code.hasPrefix("qr-") {
                            code = "qr-\(code)"
                        }

                        self.searchTerm = code

                    }
                    else if !text.contains("http") {
                        
                        if !text.containCaracter(what: "-", where: 4) {
                            return
                        }
                        
                        self.searchFolio( false, text)
                        
                    }
                    else if text.contains("http") {
                        
                        if text.contains( "sat.gob.mx") {
                            
                            /**
                             https://verificacfdi.facturaelectronica.sat.gob.mx/default.aspx?
                             id=F72D2ECA-25B6-43C3-9BE5-2DEBFFA7E96F&
                             re=TRA9001086M0&
                             rr=CUSE8006061Q1&
                             tt=8655.010000&fe=Qv8pXQ==
                             */
                            
                            guard let url = URLComponents(string: text) else {
                                return
                            }
                        
                            guard let id = UUID(uuidString: (url.queryItems?.first(where: { $0.name == "id" })?.value ?? "")) else {
                                showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                                return
                            }
                            
                            guard let emisor = url.queryItems?.first(where: { $0.name == "re" })?.value else {
                                showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                                return
                            }
                            
                            guard let receptor = url.queryItems?.first(where: { $0.name == "rr" })?.value else {
                                showAlert(.alerta, "Formato no soportado, no se localizo id del documento")
                                return
                            }
                            
                            let profiles = fiscalProfiles.map{ $0.rfc }
                            
                            if profiles.contains(emisor) {
                                
                                loadingView.show()

                                API.fiscalV1.loadDocument(docid: id) { resp in

                                    loadingView.hide()

                                    guard let resp else {
                                        showError(.comunicationError, .serverConextionError)
                                        return
                                    }

                                    guard resp.status == .ok else {
                                        showError(.generalError, resp.msg)
                                        return
                                    }

                                    guard let payload = resp.data else {
                                        showError(.unexpectedResult, "No se obtuvo payload de data.")
                                        return
                                    }

                                    if payload.doc.tipoDeComprobante == .pago {
                                        showError(.generalError, "Documentos de pagos aun no son soportados.")
                                    }
                                    
                                    let view = ToolFiscalViewDocument(
                                        type: payload.type,
                                        doc: payload.doc,
                                        reldocs: payload.reldocs,
                                        account: payload.account
                                    ) {
                                        /// Document canceled
                                        self.remove()
                                    }
                                    
                                    addToDom(view)

                                }
                            
                            }
                            else if profiles.contains(receptor) {
                                addToDom(ToolReciveSendInventory(loadid: id))
                            }
                            else {
                                showError(.generalError, "Este documento no pertenece a ningun perfil fiscal de la ceunta")
                            }
                            
                        }
                        else {
                            showAlert(.alerta, "Formato no soportado, si cree que es un error, contacta a Soporte TC")
                        }
                    }
                    else {
                        self.searchTerm = text
                    }
                }
            
            case .requestMobileCamaraCancel:
                break
            case .requestMobileCamaraSelected:
                break
            case .requestMobileOCRComplete:
                break
            case .custTaskAuthRequest:
                
                if let payload = self.ws.custTaskAuthRequest($0) {
                    
                    addToDom(CustTaskAuthRequestView(
                        task: payload
                    ))
                }
                
            case .custTaskDenied:
                if let payload = self.ws.custTaskDenied($0) {
                    
                    if payload.alertType == .changePrice {
                        /// Manages in difrent viewf
                        return
                    }
                    
                }
            case .custTaskAuthoroized:
                
                if let payload = self.ws.custTaskAuthoroized($0) {
                    
                    if payload.alertType == .changePrice {
                        /// Manages in difrent view
                        return
                    }
                    
                }
                
            case .sendToMobile:
                
                if let payload = self.ws.sendToMobile($0) {

                    switch payload.type {
                    case .payment:
                        break
                    case .blog:
                        break
                    case .order:
                        
                        OrderCatchControler.shared.loadFolio(
                            orderid: payload.objid
                        ) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                            
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
                            
                            minViewAcctRefrence[order.custAcct] = accoutOverview
                            
                            addToDom(accoutOverview)
                            
                        }
                        
                    case .account:
                        loadAccountView(id: .id(payload.objid))
                    case .cupon:
                        break
                    case .sale:
                        break
                    case .product:
                        
                        let view = ManagePOC(
                            leveltype: CustProductType.all,
                            levelid: nil,
                            levelName: "",
                            pocid: payload.objid,
                            titleText: "",
                            quickView: false
                        ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                            
                        } deleted: { 
                            
                        }
                        
                        addToDom(view)
                        
                    case .scanner, .ocr, .paymentOrder, .paymentAccount, .paymentSale, .authTask,  .notifyTask, .social, .orderFiles, .orderMessage, .orderSendToUser, .customerMessage, .tierraceroMessage, .papacontadorMessage, .useCamaraForProduct, .useCamaraForOrder, .useCamaraForUser, .debugMode, .useCamaraForAsset, .useCamaraForOCR:
                        break
                    }
                    
                }
                
            case .whatsAppLoadingScreen:
                break
            case .whatsAppQR:
                break
            case .whatsAppAuthenticated:
                break
            case .whatsAppAuthFailure:
                break
            case .whatsAppReady:
                break
            case .whatsAppDisconnected:
                break
            case .waMsgReactionUpdate:
                break
            case .wsLocationUpdate:
                break
            case .customerOrderStatusUpdate:
                break
            }
            
            WebApp.current.wsevent.wrappedValue = ""
        }
        
        $sideMenuIsHidden.listen {
            if $0 {
                self.sideMenu.fadeOut( end:.hidden)
                //    .display(.none)
                //    .filter(.opacity(0))
            }
            else{
                self.sideMenu.fadeIn(begin: .display(.block))
                //    .display(.block)
                //    .filter(.opacity(100))
            }
        }
        
        $pmode.listen {
            
            if let mode = $0 {
                switch mode {
                case .serviceOrder:
                    self.serchPlaceHolder = "Buscar Orden/Renta"
                case .dates:
                    self.serchPlaceHolder = "Buscar Cita/Cuenta"
                case .accounts:
                    self.serchPlaceHolder = "Buscar Cliente/Cuenta"
                case .clubMembership:
                    self.serchPlaceHolder = "Buscar Cliente/Cuenta"
                }
            }
        }
        
        rendered( )

    }
    
    override func didAddToDOM() {
        super.didAddToDOM()

        loadingView.hide()
        startDashboardStartupSequence()
        
        WebApp.current.document.head.body {
            
            Script()
                .src("https://code.jquery.com/jquery-3.7.1.js")
                .type("text/javascript")
                .onLoad {
                    print("https://code.jquery.com/jquery-3.7.1.js  🟢")
                }
            
            Script()
                .src("https://code.jquery.com/ui/1.14.1/jquery-ui.js")
                .type("text/javascript")
                .onLoad {
                    print("https://code.jquery.com/ui/1.14.1/jquery-ui.js  🟢")
                }
        }
        
        loadBasicConfiguration(
            firtsLoad: true,
            internalCommunicationsCompletion: { [weak self] in
                self?.initAlertManager()
            }
        ) { status in
        
            guard let status else {
                self.updateStartupStep(.core, state: .failed)
                self.cancelPendingStartupSteps()
                
                _ = JSObject.global.goToURL!("login")
                
                Dispatch.asyncAfter(0.25) {
                    loadingView.hide()
                }
                
                return
            }
            
            if status == .hotline {
                self.updateStartupStep(.core, state: .online)
                self.cancelPendingStartupSteps()
                _ = JSObject.global.goToURL!("hotline")
                return
            }

            self.updateStartupStep(.core, state: .online)
            
            self.userHerk = custCatchHerk
            
            self.pmode = panelMode
            
            self.loadConfiguration(loadCommunications: false)

            self.updateStartupStep(.workModules, state: .loading)
            
            OrderCatchControler.shared.sincFolio(
                accountid: nil,
                current: [],
                curTrans: [],
                initialLoad: true
            ) { succeeded in
                self.updateStartupStep(
                    .workModules,
                    state: succeeded ? .online : .failed
                )
            }

            self.updateStartupStep(.communications, state: .loading)

            self.loadCommMessages { succeeded in
                self.updateStartupStep(
                    .communications,
                    state: succeeded ? .online : .failed
                )
            }
            
            OrderCatchControler.shared.emailViewControler.loadView()
            
        }
        
    }
    
    func sessionControl(){
        
        if let lastCheckAt = Int64(WebApp.current.window.localStorage.string(forKey: "sessionControl") ?? "") {
            let interval = getNow() - lastCheckAt
            
            if interval < 10799 {
                return
            }
            
        }
        
        loadBasicConfiguration { status in
        
            guard let status else {
                _ = JSObject.global.goToURL!("login")
                return
            }
            
            if status == .hotline {
                _ = JSObject.global.goToURL!("hotline")
                return
            }
             
            WebApp.current.window.localStorage.set(getNow(), forKey: "sessionControl")
            
        }
    }

    override func didRemoveFromDOM() {
        communicationRefreshId = UUID()
        communicationController.shutdown()
        speechRecognitionControl.shutdown()
        super.didRemoveFromDOM()
    }
    
    func loadConfiguration(loadCommunications: Bool = true){
        
        serviceIsActive = true
        
        let parts = custCatchUser.split(separator: "@")
        
        username = String(parts[0])
        
        sideBar.innerHTML = ""

        sideBar.appendChild(
            Div {
                Img()
                    .src("/skyline/media/logoTierraCeroLongWhite.svg")
            }
            .class(Class(TCWorkDashboardClass.brand))
        )

        let navigation = Div()
            .class(Class(TCWorkDashboardClass.navigation))

        navigation.appendChild(
            workNavigationItem(
                selection: .analytics,
                icon: "/skyline/media/report-icon.png",
                title: "Estadistícas"
            ) {
                addToDom(AnaliticsView(asMainView: false, notification: nil))
            }
        )

        navigation.appendChild(
            workNavigationItem(
                selection: nil,
                icon: "/skyline/media/icon-fiscal.png",
                title: "Facturacíon"
            ) {
                addToDom(ToolFiscal(
                    loadType: .manual,
                    folio: nil,
                    callback: { id, folio, pdf, xml in

                    })
                )
            }
        )

        navigation.appendChild(
            workNavigationItem(
                selection: nil,
                icon: "/skyline/media/icon-money.png",
                title: "Finanzas"
            ) {
                addToDom(MoneyManagerView())
            }
        )

        navigation.appendChild(
            workNavigationItem(
                selection: .accounts,
                icon: "/skyline/media/account.png",
                title: "Cuentas"
            ) {
                OrderCatchControler.shared.loadAccounts()
            }
        )

        navigation.appendChild(
            workNavigationItem(
                selection: .orders,
                icon: "/skyline/media/service_order.png",
                title: "Ordenes"
            ) {
                OrderCatchControler.shared.drawOrderView()
            }
        )

        navigation.appendChild(
            workNavigationItem(
                selection: .followups,
                icon: "/skyline/media/followup.png",
                title: "Seguimientos"
            ) {
                OrderCatchControler.shared.loadFollowups()
            }
        )
        
        navigation.appendChild(
            workNavigationItem(
                selection: .trips,
                icon: "/skyline/media/commercial_trip.png",
                title: "Viajes"
            ) {
                self.loadTripView()
            }
        )


        sideBar.appendChild(navigation)
        
        self.$privateChatList.listen {
            
            self.privateChatBoxInner.innerHTML = ""
            
            $0.forEach { room in
                
                let view = IMChatBubbleView(data: room) { _room in
                    
                    /*
                    switch room.roomid {
                    case .id(let id):
                        if id == _room.id {
                            return
                        }
                    case .folio(let token):
                        if token == _room.token {
                            return
                        }
                    }
                    */
                    
                    if self.chatRoomNew != nil {
                        self.chatRoomNew?.remove()
                    }
                    
                    self.chatRoomNew = IMSocialChatView(
                        roomType: _room.type,
                        profileType: .general,
                        roomid: .folio(room.token),
                        name: _room.nick,
                        avatar: _room.avatar,
                        callback: { chatIsArchived in
                            if chatIsArchived {
                                self.chatBubbleRefrence[room.token]?.remove()
                                self.chatBubbleRefrence.removeValue(forKey: room.token)
                            }
                            self.chatRoomNew = nil
                        }, sentMessage: { room, message, lastMessageAt in
                            
                            
                            self.chatBubbleRefrence[room.token]?.message = message
                            self.chatBubbleRefrence[room.token]?.lastMessageAt = lastMessageAt
                            
                            
                        })
                    
                    addToDom(self.chatRoomNew!)
                    
                    Dispatch.asyncAfter(0.5) {
                        //dragElement("chatWindows")
                    }
                    
                }
                
                var counterUser: UUID? = nil
                
                room.members.forEach { id in
                    if id == custCatchID { return }
                    counterUser = id
                }
                
                if let counterUser = counterUser {
                    getUserRefrence(id: .id(counterUser)) { user in
                        
                        guard let user = user else {
                            return
                        }
                        
                        self.userChatToken[user.username] = room.token
                    }
                }
                
                self.chatBubbleRefrence[room.token] = view
                
                self.privateChatBoxInner.appendChild(view)
                
            }
            
        }
        
        if custCatchHerk > 3 {
            
            API.custAPIV1.accountBalance { resp in
                
                loadingView.hide()
                
                guard let resp else{
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, .unexpectedError("No se localizo data de la respueta"))
                    return
                }
                
                accountBalance = payload
                
                ///   When was user last notified of balanc
                let lastNotification = (Int64(WebApp.current.window.localStorage.string(forKey: "dueIn_\(payload.dueIn.rawValue)") ?? "0") ?? 0.toInt64)
                
                let secondsSinceLastNotification = getNow() - lastNotification
                
                
                switch payload.dueIn {
                case .due:
                    let threeDays = (60 * 60 * 24 * 3)
                    if secondsSinceLastNotification > threeDays {
                        /// Recordatorio / Anunciar saldo venido
                        WebApp.current.window.localStorage.set(getNow(), forKey: "dueIn_\(payload.dueIn.rawValue)")
                        let view = AnaliticsView(asMainView: false, notification: .dueAlert(dueIn: payload.dueIn))
                        Dispatch.asyncAfter(1.0) {
                            addToDom(view)
                        }
                    }
                case .today:
                    let twoDays = (60 * 60 * 24 * 2)
                    if secondsSinceLastNotification > twoDays {
                        /// saldo venido vencido
                        WebApp.current.window.localStorage.set(getNow(), forKey: "dueIn_\(payload.dueIn.rawValue)")
                        let view = AnaliticsView(asMainView: false, notification: .dueAlert(dueIn: payload.dueIn))
                        Dispatch.asyncAfter(1.0) {
                            addToDom(view)
                        }
                    }
                case .threeDays:
                    let fourDays = (60 * 60 * 24 * 4)
                    if secondsSinceLastNotification > fourDays {
                        /// saldo venido vencido
                        WebApp.current.window.localStorage.set(getNow(), forKey: "dueIn_\(payload.dueIn.rawValue)")
                        let view = AnaliticsView(asMainView: false, notification: .dueAlert(dueIn: payload.dueIn))
                        Dispatch.asyncAfter(1.0) {
                            addToDom(view)
                        }
                    }
                case .sevenDays:
                    let tenDays = (60 * 60 * 24 * 10)
                    if secondsSinceLastNotification > tenDays {
                        /// saldo venido vencido
                        WebApp.current.window.localStorage.set(getNow(), forKey: "dueIn_\(payload.dueIn.rawValue)")
                        let view = AnaliticsView(asMainView: false, notification: .dueAlert(dueIn: payload.dueIn))
                        Dispatch.asyncAfter(1.0) {
                            addToDom(view)
                        }
                    }
                case .moreThanSevenDays:
                    /// No notification requeres
                    break
                case .current:
                    /// No notification requeres
                    break
                }
            }
            
        }
        
        if loadCommunications {
            loadCommMessages()
        }
        
    }
    
    func loadCommMessages(completion: ((Bool) -> Void)? = nil){
        let refreshId = UUID()
        communicationRefreshId = refreshId
        let request = communicationController.beginRequest()

        API.custAPIV1.loadMessaging { resp in
            guard self.communicationController.isCurrentRequest(request.id) else {
                completion?(false)
                return
            }

            guard let resp = resp else {
                completion?(false)
                return
            }

            guard self.communicationController.replaceSnapshot(
                resp,
                requestId: request.id,
                startingAt: request.revision
            ) else {
                completion?(false)

                guard refreshId == self.communicationRefreshId else {
                    return
                }

                Dispatch.asyncAfter(0.5) {
                    guard refreshId == self.communicationRefreshId else {
                        return
                    }

                    self.loadCommMessages()
                }
                return
            }

            getWebsocketTokens()

            completion?(true)

            /// Reload every 15 min
            Dispatch.asyncAfter(600) {
                guard refreshId == self.communicationRefreshId else {
                    return
                }

                self.loadCommMessages()
            }
        }
    }
    
    /// Start New Service Order
    /// - Parameter orderType: order, rental, date
    func newOrderSearchCustomer(_ orderType: CustOrderProfiles){
        
        let seachBox = SearchCustomerView { term, results in
            
            // No Results Create Customer
            
            if results.isEmpty {
                addToDom(
                    
                    // TODO: if  cust has preselected chose account must show proper UI else account type selector
                    
                    CreateNewCusomerView(
                        searchTerm: term,
                        custType: .general,
                        callback: { acctType, custType, searchTerm in
                            
                            let custDataView = CreateNewCustomerDataView(
                                acctType: acctType,
                                custType: custType,
                                orderType: orderType,
                                searchTerm: searchTerm
                            ) { custAcct in
                                
                                switch orderType {
                                case .order:
                                    
                                    let order = StartServiceOrder(custAcct: custAcct) { id, shownHighPriorityNotes, cfiles in
                                        
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

                                            /* load Folio with auto print true*/
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
                                            
                                            /*
                                            let printBody = OrderPrintEngine(
                                                order: order,
                                                notes: notes,
                                                payments: payments,
                                                charges: charges,
                                                pocs: pocs,
                                                files: files,
                                                contracts: contracts,
                                                equipments: equipments,
                                                rentals: rentals,
                                                transferOrder: transferOrder
                                            ).innerHTML
                                            _ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                            */
                                        }
                                        
                                    }
                                    addToDom(order)
                                    
                                case .rental:

                                    let order = StartRentalOrder(custAcct: custAcct) { id in
                                        
                                        OrderCatchControler.shared.loadFolio(orderid: id) {account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                                            
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
                                                tasks:tasks,
                                                orderRoute: route,
                                                loadFromCatch: loadFromCatch
                                            )
                                            
                                            addToDom(accoutOverview)
                                            
                                            minViewAcctRefrence[order.custAcct] = accoutOverview
                                            
                                            let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                                            _ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                            
                                        }
                                        
                                    }
                                    addToDom(order)
                                case .date:
                                    break
                                case .account:
                                    loadAccountView(id: .id(custAcct.id))
                                case .followup:
                                    self.startFollowup(custAcct, custAcct.highPriorityNotes)
                                }
                            }

                            addToDom(custDataView)
                            
                    })
                )
            }
            else{
                
                if results.count == 1 {
                    
                    let custAcct = results.first!
                    
                    switch orderType {
                    case .order:
                        
                        let order = StartServiceOrder(custAcct: custAcct) { id, shownHighPriorityNotes, cfiles in
                            
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
                                
                                //let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                                //_ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                
                            }
                            
                        }
                        addToDom(order)

                    case .rental:

                        let order = StartRentalOrder(custAcct: custAcct) { id in
                            
                            OrderCatchControler.shared.loadFolio(orderid: id) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                            
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
                                
                                let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                                _ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                
                            }
                            
                        }
                        addToDom(order)

                    case .date:
                        break
                    case .account:
                        loadAccountView(id: .id(custAcct.id))
                    case .followup:

                    /// CustAcctSearch
                        self.startFollowup(custAcct, custAcct.highPriorityNotes)
                    }
                }
                else{
                    
                    let view = NewOrderMultipleAccountResults(accounts: results) { custAcct in
                        switch orderType {
                        case .order:
                            let order = StartServiceOrder(custAcct: custAcct) { id, shownHighPriorityNotes, cfiles in
                                
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
                                    
                                    //let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                                    //_ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                    
                                }
                                
                            }
                            addToDom(order)
                        case .rental:
                            let order = StartRentalOrder(custAcct: custAcct) { id in
                                
                                OrderCatchControler.shared.loadFolio(orderid: id) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                                
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
                                    
                                    let printBody = OrderPrintEngine(order: order, notes: notes, payments: payments, charges: charges, pocs: pocs, files: files, equipments: equipments, rentals: rentals, transferOrder: transferOrder).innerHTML
                                    _ = JSObject.global.renderPrint!(custCatchUrl, order.folio, order.deepLinkCode, String(order.mobile.suffix(4)), printBody)
                                    
                                }
                                
                            }
                            addToDom(order)
                        case .date:
                            break
                        case .account:
                            loadAccountView(id: .id(custAcct.id))
                        case .followup:
                            break
                        }
                    }
                    
                    addToDom(view)
                    
                }
            }
        }
        
        addToDom(seachBox)
        
        seachBox.seachCustomerField.select()
        
    }
    
    func sideMenuCaller(_ caller: String) {
        
        sideMenuIsHidden = true
        
        if caller == "tradesa_trip_control" {
            selectedWorkNavigationItem = .trips
            loadTripView()
        }
        else if caller == "delegate"{
            
        }
        else if caller == "config"{
            addToDom(ToolsView())
        }
        else if caller == "logout"{

            loadingView.show()

            API.authV1.customerLogout { _ in
                killSession()
                Dispatch.asyncAfter(1) {
                    _ = JSObject.global.goToLogin!()
                }
            }
        }
        else if caller == "storeAndProducts"{
            
            if let storeProductManagerView {
                print("🤖  storeProductManagerView in catch")
                storeProductManagerSubView?.remove()
                storeProductManagerSubView = nil
                storeProductManagerView.display(.block)
                addToDom(storeProductManagerView)
                return
            }
            
            let view = ProductManagerView {
                print("🤖  storeProductManagerView in remove")
                self.storeProductManagerView?.remove()
                self.storeProductManagerView = nil
            } minimize: {
                print("🤖  storeProductManagerView in minimize")
                guard let storeProductManagerView = self.storeProductManagerView else {
                    print("🤖  storeProductManagerView in minimize  🔴")
                    return
                }
                
                storeProductManagerView.display(.none)
                
                let subView = Div{
                    Div{
                        Img()
                            .src("/skyline/media/star_yellow.png")
                            .marginTop(3.px)
                            .width(22.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Span("Productos")
                        .color(.white)
                    
                }
                    .border(width: .medium, style: .solid, color: .slateGray)
                    .custom("width", "fit-content")
                    .backgroundColor(.grayBlack)
                    .borderRadius(all: 12.px)
                    .class(.oneLineText)
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .cursor(.pointer)
                    .fontSize(23.px)
                    .color(.white)
                    .float(.left)
                    .onClick {
                        
                        self.storeProductManagerSubView?.remove()
                        self.storeProductManagerSubView = nil
                        
                        if let storeProductManagerView = self.storeProductManagerView {
                            storeProductManagerView.display(.block)
                            addToDom(storeProductManagerView)
                        }
                        else{
                            
                        }
                    }
                
                self.storeProductManagerSubView = subView
                
                WebApp.current.minimizedGrid.appendChild(subView)
            }

            storeProductManagerView = view

            addToDom(view)
            
        }
        else if caller == "historicalPriceSearch"{
            
            if let searchHistoricalPurchaseView {
                searchHistoricalPurchaseSubView?.remove()
                searchHistoricalPurchaseSubView = nil
                searchHistoricalPurchaseView.display(.block)
                addToDom(searchHistoricalPurchaseView)
                return
            }
            
            let view = SearchHistoricalPurchaseView {
                self.searchHistoricalPurchaseView?.remove()
            } minimize: {
                
                guard let searchHistoricalPurchaseView = self.searchHistoricalPurchaseView else {
                    return
                }
                
                searchHistoricalPurchaseView.display(.none)
                
                let subView = Div{
                    Div{
                        Img()
                            .src("/skyline/media/zoom.png")
                            .marginTop(3.px)
                            .width(22.px)
                    }
                    .marginRight(7.px)
                    .float(.left)
                    
                    Span("Buscar en Compras")
                        .color(.white)
                    
                }
                    .border(width: .medium, style: .solid, color: .slateGray)
                    .custom("width", "fit-content")
                    .backgroundColor(.grayBlack)
                    .borderRadius(all: 12.px)
                    .class(.oneLineText)
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .cursor(.pointer)
                    .fontSize(23.px)
                    .color(.white)
                    .float(.left)
                    .onClick {
                        self.searchHistoricalPurchaseSubView?.remove()
                        self.searchHistoricalPurchaseSubView = nil
                        if let searchHistoricalPurchaseView = self.searchHistoricalPurchaseView {
                            searchHistoricalPurchaseView.display(.block)
                            addToDom(searchHistoricalPurchaseView)
                        }
                    }
                
                self.searchHistoricalPurchaseSubView = subView
                
                WebApp.current.minimizedGrid.appendChild(subView)
            }
            
            searchHistoricalPurchaseView = view
            addToDom(view)
        }
    }
    
    func searchFolio(_ advancedSearch: Bool,_ _term: String? = nil){
        
        var term = searchTerm.purgeSpaces
        
        if let _term {
            term  = _term
        }
        
        minimizeAccountViews()
        
        if term.isEmpty {
            return
        }
        
        if term.count > 7 && term.contains("-") {
           
            let prefix = String(term.prefix(2))
            
            if let type: CustFolioSequenceTableType = CustFolioSequenceTableType(rawValue: prefix) {
                
                switch type {
                case .folio:
                    
                    loadingView.show()
                    
                    API.custOrderV1.loadOrder(identifier: .folio(term), modifiedAt: nil) { resp in
                        
                        loadingView.hide()
                        
                        guard let resp = resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else{
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
                            minimizeAccountViews()
                            
                            let id = loadOrderResponse.order.id
                            
                            /// Order Detail Catch
                            acctMinCatch[id] = loadOrderResponse.account
                            orderCatch[id] = loadOrderResponse.order
                            notesCatch[id] = loadOrderResponse.notes
                            paymentsCatch[id] = loadOrderResponse.payments
                            chargesCatch[id] = loadOrderResponse.charges
                            pocsCatch[id] = loadOrderResponse.pocs
                            filesCatch[id] = loadOrderResponse.files
                            contractsCatch[id] = loadOrderResponse.contracts
                            equipmentsCatch[id] = loadOrderResponse.equipments
                            rentalsCatch[id] = loadOrderResponse.rentals
                            orderHighPriorityNoteCatch[id] = loadOrderResponse.orderHighPriorityNote
                            tasksCatch[id] = loadOrderResponse.tasks
                            accountHighPriorityNoteCatch[id] = loadOrderResponse.accountHighPriorityNote
                            
                            if let transferOrder = loadOrderResponse.transferOrder {
                                transferOrderCatch[id] = transferOrder
                            }
                            
                            if let route = loadOrderResponse.route {
                                custOrderRouteCatch[id] = route
                            }
                            
                            let accoutOverview = AccoutOverview (
                                id: .id(loadOrderResponse.order.custAcct)
                            )
                            
                            accoutOverview.loadOrder(
                                account: loadOrderResponse.account,
                                order: loadOrderResponse.order,
                                notes: loadOrderResponse.notes,
                                payments: loadOrderResponse.payments,
                                charges: loadOrderResponse.charges,
                                pocs: loadOrderResponse.pocs,
                                files: loadOrderResponse.files,
                                contracts: loadOrderResponse.contracts,
                                equipments: loadOrderResponse.equipments,
                                rentals: loadOrderResponse.rentals,
                                transferOrder: loadOrderResponse.transferOrder,
                                orderHighPriorityNote: loadOrderResponse.orderHighPriorityNote,
                                accountHighPriorityNote: loadOrderResponse.accountHighPriorityNote,
                                tasks: loadOrderResponse.tasks,
                                orderRoute: loadOrderResponse.route,
                                loadFromCatch: false
                            )
                             
                            addToDom(accoutOverview)
                             
                            minViewAcctRefrence[loadOrderResponse.order.custAcct] = accoutOverview
                             
                        }
                    }
                    
                case .account:
                    
                    loadAccountView(id: .folio(term))
                    
                case .user:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .sale:
                    
                    let view = SalePointView.DetailView(saleId: .folio(term))
                    
                    addToDom(view)
                    
                case .general:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .purchOrder:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .pickupOrder:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .payment:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .adjustment:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .charge:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .credit:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .card:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .budget:
                    
                    let salePoint = SalePointView(loadBy: .budget(.folio(term)))
                    
                    addToDom(salePoint)
                    
                    
                case .budgetOrder:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .siwe:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .transferOrder:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .moneyManager:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .rental:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .vendor:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .transferInventory:
                    
                    loadingView.show()
                    
                    API.custPOCV1.getTransferInventory(identifier: .folio(term)) { resp in
                        
                        loadingView.hide()
                        
                        guard let resp = resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else{
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        guard let data = resp.data else {
                            showError(.unexpectedResult, "No se pudo obtener documento")
                            return
                        }
                        
                        addToDom(InventoryControlView(
                            control: data.control,
                            items: data.items,
                            pocs: data.pocs,
                            places: data.places,
                            notes: data.notes,
                            fromStore: data.fromStore,
                            toStore: data.toStore,
                            hasRecived: {
                                
                            },
                            hasIngressed: {
                                
                            })
                        )
                        
                    }
                    
                case .manualInventory:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                    
                case .qrCode:

                    loadingView.show()
                    
                    API.custOrderV1.getWarrantyCard(id: .code(term)) { resp in

                        guard let resp = resp else {
                            loadingView.hide()
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else {
                            loadingView.hide()
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        guard let payload = resp.data else {
                            loadingView.hide()
                            showError(.unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }
                        
                        // let type = payload.card.type

                        guard let id: UUID = payload.card.orderId else {
                            loadingView.hide()
                            showError(.unexpectedResult, "Esta tarejeta no esta activa")
                            return
                        }
                            
                        API.custOrderV1.loadOrder(identifier: .id(id), modifiedAt: nil) { resp in
                            
                            loadingView.hide()
                            
                            guard let resp = resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }

                            guard resp.status == .ok else{
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
                                minimizeAccountViews()
                                
                                let id: UUID = loadOrderResponse.order.id
                                
                                /// Order Detail Catch
                                acctMinCatch[id] = loadOrderResponse.account
                                orderCatch[id] = loadOrderResponse.order
                                notesCatch[id] = loadOrderResponse.notes
                                paymentsCatch[id] = loadOrderResponse.payments
                                chargesCatch[id] = loadOrderResponse.charges
                                pocsCatch[id] = loadOrderResponse.pocs
                                filesCatch[id] = loadOrderResponse.files
                                contractsCatch[id] = loadOrderResponse.contracts
                                equipmentsCatch[id] = loadOrderResponse.equipments
                                rentalsCatch[id] = loadOrderResponse.rentals
                                orderHighPriorityNoteCatch[id] = loadOrderResponse.orderHighPriorityNote
                                tasksCatch[id] = loadOrderResponse.tasks
                                accountHighPriorityNoteCatch[id] = loadOrderResponse.accountHighPriorityNote
                                
                                if let transferOrder = loadOrderResponse.transferOrder {
                                    transferOrderCatch[id] = transferOrder
                                }
                                
                                if let route = loadOrderResponse.route {
                                    custOrderRouteCatch[id] = route
                                }
                                
                                let accoutOverview = AccoutOverview (
                                    id: .id(loadOrderResponse.order.custAcct)
                                )
                                
                                accoutOverview.loadOrder(
                                    account: loadOrderResponse.account,
                                    order: loadOrderResponse.order,
                                    notes: loadOrderResponse.notes,
                                    payments: loadOrderResponse.payments,
                                    charges: loadOrderResponse.charges,
                                    pocs: loadOrderResponse.pocs,
                                    files: loadOrderResponse.files,
                                    contracts: loadOrderResponse.contracts,
                                    equipments: loadOrderResponse.equipments,
                                    rentals: loadOrderResponse.rentals,
                                    transferOrder: loadOrderResponse.transferOrder,
                                    orderHighPriorityNote: loadOrderResponse.orderHighPriorityNote,
                                    accountHighPriorityNote: loadOrderResponse.accountHighPriorityNote,
                                    tasks: loadOrderResponse.tasks,
                                    orderRoute: loadOrderResponse.route,
                                    loadFromCatch: false
                                )
                                
                                addToDom(accoutOverview)
                                
                                minViewAcctRefrence[loadOrderResponse.order.custAcct] = accoutOverview
                                
                            }
                        }
                        


                    }

                case .fiscalCancelationRequest:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .financialServices:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                case .followup: 
                    break
                case .comertialTrip:
                    showAlert(.alerta, "\(type.description) aun no es soportado")
                }
                
                return
            }
            
        }
        
        if let _ = Int64(term) {
            
            if term.count < 4 {
                showError(.invalidFormat, "Al buscar por numero debe incluir cuatro digitos por lo menos")
                return
            }
            
        }
        else {
            
            if term.count < 3 {
                showError(.invalidFormat, "Al buscar por numero debe incluir por lo menos 3 caracteres")
                return
            }
            
        }
        
        loadingView.show()
        
        API.custOrderV1.searchFolio(
            term: term,
            accountid: nil,
            tag1: nil,
            tag2: nil,
            tag3: nil,
            tag4: nil,
            description: nil,
            startAt: nil,
            endAt: nil
        ){ resp in
            
            loadingView.hide()
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
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

            let orders = data.orders
            
            let accounts = data.accounts
            
            if (orders.count == 1) && accounts.isEmpty {
                
                minimizeAccountViews()
                
                guard let order = orders.first else {
                    return
                }
                
                OrderCatchControler.shared.loadFolio(orderid: order.id) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                    
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
                     
                }
                
                return
            }
            
            if orders.isEmpty && (accounts.count == 1) {
                
                guard let account = accounts.first else {
                    return
                }
                
                loadAccountView(id: .id(account.id))
                
                return
            }
            
            addToDom(AdvancesSearchViewControler(
                searchTerm: self.searchTerm,
                orders: orders,
                accounts: accounts
            ))
            
        }
    }
    
    private func openCommunicationMessage(
        _ data: API.custAPIV1.LoadMessaging
    ) {
        switch data.subType {
            case .sale:
                break
            case .order:
                
                guard let orderid = data.orderid else {
                    showError(.unexpectedResult, "No se encontro ID de la Orden en la peticion")
                    return
                }
                
                OrderCatchControler.shared.loadFolio(
                    orderid: orderid
                ) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                    
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
                    
                    minViewAcctRefrence[order.custAcct] = accoutOverview
                    
                    addToDom(accoutOverview)
                    
                }
                
            case .account, .merca, .ebay, .amz:
                break
            case .facebook, .instagram, .twitter, .chat, .telegram, .whatsapp:
                
                guard let profileType = data.subType.profileType else {
                    showError(.unexpectedResult, "No se localizo (tipo de) perfil \(data.subType.description.uppercased())")
                    return
                }
                
                // TODO: update pocees to add  data.roomid: Sytring
                
                guard let roomid = data.orderid else {
                    debugPrint("🔴  fail to get ROOMID")
                    return
                }
                
                let view = IMSocialChatView(
                    roomType: .social,
                    profileType: profileType,
                    roomid: .id(roomid),
                    name: data.name,
                    avatar: data.avatar ?? ""
                ) { chatIsArchived in
                    if chatIsArchived {
                        
                    //    self.chatBubbleRefrence[room.token]?.remove()
                    //    self.chatBubbleRefrence.removeValue(forKey: room.token)
                    }
                    self.chatRoomNew = nil
                } sentMessage: { room, message, lastMessageAt in

                }

                // Remove previus view
                self.chatRoomNew?.remove()
                self.chatRoomNew = nil
                
                // Replace new view
                self.chatRoomNew = view
                
                addToDom(view)
                
        }
    }
    
    func requestMobileScanner() {
        API.custAPIV1.requestMobileCamara(
            type: .scanner,
            connid: custCatchChatConnID,
            eventid: self.viewid,
            relatedid: nil,
            relatedfolio: "",
            multipleTakes: false
        ) { resp in
            loadingView.hide()

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
        }
    }

    func openSalePoint() {
        if let view = self.posView {
            view.display(.block)
            self.posSubView?.remove()
            self.posSubView = nil
            return
        }

        let salePoint = SalePointView(loadBy: nil) {
            self.posView?.remove()
            self.posView = nil
        } minimizeView: {
            let subView = Div {
                Div {
                    Img()
                        .src("/skyline/media/star_yellow.png")
                        .marginTop(3.px)
                        .width(22.px)
                }
                .marginRight(7.px)
                .float(.left)

                Span("PDV")
                    .color(.white)
            }
            .border(width: .medium, style: .solid, color: .slateGray)
            .custom("width", "fit-content")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 12.px)
            .class(.oneLineText)
            .padding(all: 7.px)
            .margin(all: 7.px)
            .cursor(.pointer)
            .fontSize(23.px)
            .color(.white)
            .float(.left)
            .onClick {
                self.posSubView?.remove()
                self.posSubView = nil

                if let view = self.posView {
                    view.display(.block)
                }
            }

            self.posSubView = subView
            WebApp.current.minimizedGrid.appendChild(subView)
            self.posView?.display(.none)
        }

        self.posView = salePoint

        addToDom(salePoint)
    }

    func newPrivateChat() {
        
        var currentIDs: [UUID] = []
        
        privateChatList.forEach { prof in
            if prof.type == .userToUser {
                prof.members.forEach { id in
                    if id != custCatchID {
                        currentIDs.append(id)
                    }
                }
            }
            
        }
        
        addToDom(
            StartNewChat(currentChatIds: currentIDs, callback: { room in
                self.privateChatList.append(room)
            })
        )
        
    }
    
    func initAlertManager(){
        ///alertManagerConfiguration
        
        let executedAt = alertManagerConfiguration.executedAt
        
        /// hourly, byHourly, biDaily, startingOperation, byTen, byTwelve, byFifteen, byEighteen, desctive
        let frequency = alertManagerConfiguration.frequency
        
        /// low, medium, high
        let level = alertManagerConfiguration.level
        
        let lastExecution = getNow() - executedAt
        
        var process = false
        
        switch frequency {
        case .hourly:
            
            let interval = 3600
            
            if lastExecution > interval {
                process = true
            }
            
        case .byHourly:
            
            let interval = 7200
            
            if lastExecution > interval {
                process = true
            }
            
        case .biDaily:
            
            let interval = 14000
            
            if lastExecution > interval {
                process = true
            }
            
        case .startingOperation:
            
            let hour = getDate(executedAt).hour - 6
            
            if hour > 7 && (lastExecution > 40000) {
                process = true
            }
            
        case .byTen:
            
            let hour = getDate(executedAt).hour - 6
            
            if hour > 10 && (lastExecution > 40000) {
                process = true
            }
            
        case .byTwelve:
            
            let hour = getDate(executedAt).hour - 6
            
            if hour > 12 && (lastExecution > 40000) {
                process = true
            }
            
        case .byFifteen:
            
            let hour = getDate(executedAt).hour - 6
            
            if hour > 15 && (lastExecution > 40000) {
                process = true
            }
            
        case .byEighteen:
            
            let hour = getDate(executedAt).hour - 6
            
            if hour > 18 && (lastExecution > 40000) {
                process = true
            }
            
        case .deactive:
            /// No alert to display only manual
            return
        }
        
        if process {
           
            processAlertManager(manualLoad: false)
            
        }
        
        // Re execute @ 59 min
        Dispatch.asyncAfter(3540) {
            self.initAlertManager()
        }
        
    }
    
    func processAlertManager(manualLoad: Bool){
        
        if manualLoad {
            loadingView.show()
        }
        
        API.custAPIV1.notifications { resp in
            
            if manualLoad {
                loadingView.hide()
            }
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            /// ``NOT Manual Load``
            if !manualLoad {
             
                print("💎 ALERT_AUTOLOAD 💎")
                
                var levels: [CustTaskAuthorizationManagerAlertLevel]
                
                switch alertManagerConfiguration.level {
                case .low:
                    levels = [.low,.medium,.high]
                case .medium:
                    levels = [.medium,.high]
                case .high:
                    levels = [.high]
                }
                
                var alerts: [CustTaskAuthorizationManagerQuick] = []
                
                data.forEach { alert in
                    if levels.contains(alert.alertLevel) {
                        alerts.append(alert)
                    }
                }
                
                if alerts.isEmpty {
                    return
                }
                
                self.custTaskAuthorizationView?.remove()
                
                self.custTaskAuthorizationView = nil
                
                self.custTaskAuthorizationView = CustTaskAuthorizationView(alerts: alerts)
                
                addToDom(self.custTaskAuthorizationView!)
                
                return
            }
            
            self.custTaskAuthorizationView?.remove()
            
            self.custTaskAuthorizationView = nil
            
            self.custTaskAuthorizationView = CustTaskAuthorizationView(alerts: data)
            
            addToDom(self.custTaskAuthorizationView!)
            
        }
    }
    
    func startFollowup(_ account: CustAcctSearch, _ highPriorityNotes: [HighPriorityNote]?) {

        let view = CreateNewFollowup(
            custAcct: account,
            highPriorityNotes: highPriorityNotes
        )

        addToDom(view)
        
    }

    func loadTripView() {

        if tripViewIsLoaded {
            OrderCatchControler.shared.macroViewType = .tripView
            return
        }

        guard !tripViewIsLoading else { return }

        tripViewIsLoading = true

        loadingView.show()

        let tripsRequestExecutedAt = Date().timeIntervalSince1970

        API.custCommercialTrips.getTrips(
            accountId: nil,
            type: .current
        ) { resp in
            self.tripViewIsLoading = false
            loadingView.hide()

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

            self.tripViewIsLoaded = true

            let view = TripsControlerView(
                items: payload.items,
                lastTripsRequestExecutedAt: tripsRequestExecutedAt
            )

            self.tripContainer.appendChild(view)
            OrderCatchControler.shared.macroViewType = .tripView
        }

    }

}

extension WorkViewControler {
   
    enum OrderViewType:String {
        case listView
        case calendarView
    }
    
    enum SmallChatViewType: String {
        case chat
        case mail
    }

}

func loadAccountView( id: HybridIdentifier) {
    
    switch id {
    case .id(let accountid):
        
        loadAccountView(id: accountid)
        
    case .folio(let folio):
        
        var accountFound = false
        
        minViewAcctRefrence.forEach { id, accountView in
            
            if accountFound {
                return
            }
            
            if let account = accountView.account {
                
                accountFound = true
                
                if account.folio == folio {
                    accountFound = true
                    loadAccountView(id: account.id)
                    
                }
                
            }
        }
        
        if accountFound {
            return
        }
        
        let accoutOverview = AccoutOverview (
           id: .folio(folio)
        )
        
        accoutOverview.loadAccout() { account in
            minViewAcctRefrence[account.id] = accoutOverview
        }
        
        addToDom(accoutOverview)
         
    }
    
}

func loadAccountView( id accountid : UUID) {
    
    if let accoutOverview = minViewAcctRefrence[accountid] {
        
        /// remove small button
        minViewDivRefrence[accountid]?.remove()
        
        ///  remove small button refrence
        minViewDivRefrence.removeValue(forKey: accountid)
        
        /// Show AccoutOverview
        accoutOverview.display(.block)
        
        accoutOverview.loadAccout()
        
        return
    }
    
    let accoutOverview = AccoutOverview (
        id: .id(accountid)
    )
    
    minViewAcctRefrence[accountid] = accoutOverview
    
    accoutOverview.loadAccout()
    
    addToDom(accoutOverview)
}

func minimizeAccountViews(_ keepOpen: UUID? = nil){
    
    minViewAcctRefrence.forEach { id, view in
        if id == keepOpen {
            return
        }
    
        if minViewDivRefrence[id] == nil {
            /// min div was not found window not iminimized
            view.hideView()
        }
    }
}
