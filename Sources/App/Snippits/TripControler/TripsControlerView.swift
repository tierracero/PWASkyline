//
// TripsControlerView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

struct TripControlGridItem: Hashable {
    let item: CustCommercialTripControlQuick

    static func == (lhs: TripControlGridItem, rhs: TripControlGridItem) -> Bool {
        lhs.item.id == rhs.item.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(item.id)
    }
}

class TripsControlerView: Div {
    
    override class var name: String { "div" }

    init(
        items: [CustCommercialTripControlQuick],
        lastTripsRequestExecutedAt: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.items = items
        self.lastTripsRequestExecutedAt = lastTripsRequestExecutedAt
        super.init()

        self.processItems()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var items: [CustCommercialTripControlQuick] = []

    @State var pendingItems: [CustCommercialTripControlQuick] = []

    @State var inProgressItems: [CustCommercialTripControlQuick] = []

    @State var completedItems: [CustCommercialTripControlQuick] = []

    @State var cancelledItems: [CustCommercialTripControlQuick] = []

    @State private var pendingGridItems: [TripControlGridItem] = []

    @State private var inProgressGridItems: [TripControlGridItem] = []

    @State private var completedGridItems: [TripControlGridItem] = []

    @State private var cancelledGridItems: [TripControlGridItem] = []

    @State var selectedTripsTypeLabel = "Actuales"

    @State var tripTypeMenuViewIsHidden = true

    private static let tripsRefreshInterval: TimeInterval = 60 * 60

    private var selectedTripsType: CustCommercialTripsComponents.GetTripsType = .current

    private var lastTripsRequestExecutedAt = Date().timeIntervalSince1970

    private var refreshScheduleVersion = 0

    private var isMounted = false

    private var tripsRequestIsInFlight = false

    private lazy var pendingItemsView = ForEach(self.$pendingGridItems) { item in
        self.tripCard(item.item, accent: "#ff9f1a")
    }

    private lazy var inProgressItemsView = ForEach(self.$inProgressGridItems) { item in
        self.tripCard(item.item, accent: "#13b5ea")
    }

    private lazy var completedItemsView = ForEach(self.$completedGridItems) { item in
        self.tripCard(item.item, accent: "#23ba3a")
    }

    private lazy var cancelledItemsView = ForEach(self.$cancelledGridItems) { item in
        self.tripCard(item.item, accent: "#d94949")
    }

    lazy var tripTypeMenu = Div()
        .hidden(self.$tripTypeMenuViewIsHidden)
        .custom("background", "rgba(4, 18, 34, 0.98)")
        .custom("border", "1px solid var(--tc-work-border)")
        .position(.absolute)
        .borderRadius(all: 9.px)
        .padding(all: 6.px)
        .marginTop(42.px)
        .width(220.px)
        .zIndex(22)

    lazy var tripTypeButton = Div {

        Span(self.$selectedTripsTypeLabel)

        Div {
            Img()
                .src(self.$tripTypeMenuViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png" })
                .class(.iconWhite)
                .paddingTop(7.px)
                .width(18.px)
        }
        .borderLeft(width: .thin, style: .solid, color: .gray)
        .paddingRight(3.px)
        .paddingLeft(7.px)
        .marginLeft(7.px)
        .float(.right)

        Div().class(.clear)
    }
    .padding(v: 8.px, h: 12.px)
    .fontSize(16.px)
    .class(.uibtn)
    .float(.left)
    .onClick { _, event in
        self.tripTypeMenuViewIsHidden = !self.tripTypeMenuViewIsHidden
        event.stopPropagation()
    }

    lazy var addTripButton = Div("＋ Viaje")
        .class(.uibtn)
        .padding(v: 8.px, h: 14.px)
        .fontSize(16.px)
        .color(.lightBlueText)
        .marginRight(7.px)
        .marginTop(0.px)
        .float(.right)
        .onClick {

            self.searchCustomer()
            
        }


    @DOM override var body: DOM.Content {
        Div()
            .hidden(self.$tripTypeMenuViewIsHidden)
            .backgroundColor(.transparentBlack)
            .height(100.percent)
            .width(100.percent)
            .position(.fixed)
            .left(0.px)
            .top(0.px)
            .zIndex(20)
            .onClick {
                self.tripTypeMenuViewIsHidden = true
            }

        Div {
            Div {
                Img()
                    .src("/skyline/media/commercial_trip.png")
                    .width(30.px)
                    .height(30.px)
                    .marginRight(10.px)

                Div {
                    Div("Control de viajes")
                        .fontSize(18.px)
                        .fontWeight(.bold)
                    Div("Gestión comercial y Carta Porte")
                        .fontSize(11.px)
                        .color(.gray)
                }
            }
            .display(.flex)
            .custom("align-items", "center")
            .float(.left)

            self.addTripButton

            Div {
                self.tripTypeButton
                self.tripTypeMenu
            }
            .position(.relative)
            .marginRight(7.px)
            .float(.right)
            .zIndex(21)

            Div().class(.clear)
        }
        .class(Class(TCWorkDashboardClass.toolbar))

        Div {
            self.tripStatCard(
                label: "Pendientes",
                value: self.$pendingItems.map { $0.count.toString },
                icon: "/skyline/media/icon_pending@128.png",
                accent: "#ff9f0a"
            )

            self.tripStatCard(
                label: "En proceso",
                value: self.$inProgressItems.map { $0.count.toString },
                icon: "/skyline/media/icon_active@128.png",
                accent: "#13b5ea"
            )

            self.tripStatCard(
                label: "Cancelados",
                value: self.$cancelledItems.map { $0.count.toString },
                icon: "/skyline/media/icon_alert@128.png",
                accent: "#ff633f"
            )

            self.tripStatCard(
                label: "Finalizados",
                value: self.$completedItems.map { $0.count.toString },
                icon: "/skyline/media/icon-checkmark.svg",
                accent: "#72d84a"
            )
        }
        .class(Class(TCWorkDashboardClass.stats))

        Div {
            Div {
                self.tripStatusSection(
                    title: self.$pendingItems.map { "Pendientes  \($0.count)" },
                    itemsView: self.pendingItemsView,
                    isEmpty: self.$pendingItems.map { $0.isEmpty },
                    noItemsLabel: "Sin viajes pendientes",
                    accent: "#ff9f0a"
                )

                self.tripStatusSection(
                    title: self.$cancelledItems.map { "Cancelados  \($0.count)" },
                    itemsView: self.cancelledItemsView,
                    isEmpty: self.$cancelledItems.map { $0.isEmpty },
                    noItemsLabel: "Sin viajes cancelados",
                    accent: "#ff633f"
                )
            }
            .class(Class(TCWorkDashboardClass.orderColumn))
            .display(.flex)
            .custom("flex-direction", "column")
            .custom("gap", "8px")
            .padding(all: 8.px)
            .overflow(.hidden)

            Div {
                self.tripStatusSection(
                    title: self.$inProgressItems.map { "En proceso  \($0.count)" },
                    itemsView: self.inProgressItemsView,
                    isEmpty: self.$inProgressItems.map { $0.isEmpty },
                    noItemsLabel: "Sin viajes en proceso",
                    accent: "#13b5ea"
                )

                self.tripStatusSection(
                    title: self.$completedItems.map { "Finalizados  \($0.count)" },
                    itemsView: self.completedItemsView,
                    isEmpty: self.$completedItems.map { $0.isEmpty },
                    noItemsLabel: "Sin viajes finalizados",
                    accent: "#72d84a"
                )
            }
            .class(Class(TCWorkDashboardClass.orderColumn))
            .display(.flex)
            .custom("flex-direction", "column")
            .custom("gap", "8px")
            .padding(all: 8.px)
            .overflow(.hidden)
        }
        .class(Class(TCWorkDashboardClass.orderGrid))
    }
    
    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        width(100.percent)
        height(100.percent)
        position(.relative)
        overflow(.hidden)
        
        tripTypeMenu.appendChild(
            tripTypeMenuItem(
                label: "Actuales",
                type: .current
            )
        )

        FiscalTripFollowupStatus.allCases.forEach { status in
            tripTypeMenu.appendChild(
                tripTypeMenuItem(
                    label: status.description,
                    type: .status(status)
                )
            )
        }

        tripTypeMenu.appendChild(Div().height(7.px))

    }

    func processItems(_ items: [CustCommercialTripControlQuick]){
        self.items = items
        self.processItems()
    }

    func processItems(){
        
        var pendingItems: [CustCommercialTripControlQuick] = []

        var inProgressItems: [CustCommercialTripControlQuick] = []

        var completedItems: [CustCommercialTripControlQuick] = []

        var cancelledItems: [CustCommercialTripControlQuick] = []

        items.forEach { item in
            switch item.status {
                case .pending:
                pendingItems.append(item)
                case .inProgress:
                inProgressItems.append(item)
                case .completed:
                completedItems.append(item)
                case .cancelled:
                cancelledItems.append(item)
            }
        }

        self.pendingItems = pendingItems
        self.inProgressItems = inProgressItems
        self.completedItems = completedItems
        self.cancelledItems = cancelledItems
        self.pendingGridItems = pendingItems.map{ TripControlGridItem(item: $0) }
        self.inProgressGridItems = inProgressItems.map{ TripControlGridItem(item: $0) }
        self.completedGridItems = completedItems.map{ TripControlGridItem(item: $0) }
        self.cancelledGridItems = cancelledItems.map{ TripControlGridItem(item: $0) }
        
    }

    func loadTrips(
        type: CustCommercialTripsComponents.GetTripsType,
        label: String
    ) {
        requestTrips(
            type: type,
            label: label,
            showLoadingView: true
        )
    }

    private func requestTrips(
        type: CustCommercialTripsComponents.GetTripsType,
        label: String,
        showLoadingView: Bool
    ) {
        guard !tripsRequestIsInFlight else { return }

        tripsRequestIsInFlight = true
        selectedTripsType = type
        self.tripTypeMenuViewIsHidden = true
        self.selectedTripsTypeLabel = label
        recordTripsRequestExecution()

        if showLoadingView {
            loadingView(show: true)
        }

        API.custCommercialTrips.getTrips(
            accountId: nil,
            type: type
        ) { resp in
            self.tripsRequestIsInFlight = false

            if showLoadingView {
                loadingView(show: false)
            }

            guard let resp = resp else {
                if showLoadingView {
                    showError(.comunicationError, .serverConextionError)
                }
                return
            }

            guard resp.status == .ok else {
                if showLoadingView {
                    showError(.generalError, resp.msg)
                }
                return
            }

            guard let payload = resp.data else {
                if showLoadingView {
                    showError(.unexpectedResult, .payloadDecodError)
                }
                return
            }

            self.processItems(payload.items)
        }
    }

    private func recordTripsRequestExecution() {
        lastTripsRequestExecutedAt = Date().timeIntervalSince1970
        scheduleNextTripsRefresh()
    }

    private func scheduleNextTripsRefresh() {
        guard isMounted else { return }

        refreshScheduleVersion += 1
        let scheduledVersion = refreshScheduleVersion
        let elapsed = Date().timeIntervalSince1970 - lastTripsRequestExecutedAt
        let delay = max(1, Self.tripsRefreshInterval - elapsed)

        Dispatch.asyncAfter(delay) { [weak self] in
            guard let self else { return }
            guard self.isMounted else { return }
            guard self.refreshScheduleVersion == scheduledVersion else { return }

            let elapsed = Date().timeIntervalSince1970 - self.lastTripsRequestExecutedAt
            guard elapsed >= Self.tripsRefreshInterval else {
                self.scheduleNextTripsRefresh()
                return
            }

            self.requestTrips(
                type: self.selectedTripsType,
                label: self.selectedTripsTypeLabel,
                showLoadingView: false
            )
        }
    }

    func tripTypeMenuItem(
        label: String,
        type: CustCommercialTripsComponents.GetTripsType
    ) -> Div {
        Div(label)
            .class(.uibtn)
            .width(90.percent)
            .marginTop(7.px)
            .onClick { _, event in
                self.loadTrips(type: type, label: label)
                event.stopPropagation()
            }
    }

    func tripStatCard(
        label: String,
        value: State<String>,
        icon: String,
        accent: String
    ) -> Div {
        Div {
            Div(label)
                .class(Class(TCWorkDashboardClass.statLabel))
            Div(value)
                .class(Class(TCWorkDashboardClass.statValue))
                .custom("color", accent)
            Img()
                .src(icon)
                .class(Class(TCWorkDashboardClass.statIcon))
        }
        .class(Class(TCWorkDashboardClass.statCard))
    }

    func tripStatusSection(
        title: State<String>,
        itemsView: BaseElement,
        isEmpty: State<Bool>,
        noItemsLabel: String,
        accent: String
    ) -> Div {
        Div {
            H2(title)
                .custom("color", accent)
                .fontSize(18.px)
                .marginTop(0.px)
                .marginBottom(8.px)

            itemsView
                .hidden(isEmpty)

            Div(noItemsLabel)
                .align(.center)
                .color(.gray)
                .fontSize(14.px)
                .padding(all: 18.px)
                .hidden(isEmpty.map{ !$0 })
        }
        .class(.roundGrayBlackDark)
        .custom("flex", "1 1 0")
        .custom("min-height", "0")
        .padding(all: 4.px)
        .overflow(.auto)
    }

    func tripCard(
        _ item: CustCommercialTripControlQuick,
        accent: String
    ) -> Div {
        
        let identifier = item.folio.isEmpty
            ? String(item.id.uuidString.prefix(8)).uppercased()
            : item.folio

        return VBox(.interactive) {
            Div {
                Div(identifier)
                    .fontSize(18.px)
                    .fontWeight(.bold)
                    .color(.white)
                    .class(.oneLineText)

                Div(item.status.description)
                    .fontSize(12.px)
                    .custom("color", accent)
                    .class(.oneLineText)
            }
            .custom("min-width", "0")

            Div {
                Div(getDate(item.createdAt).formatedShort)
                    .fontSize(12.px)
                    .color(.gray)
                    .class(.oneLineText)

                Div(item.name)
                    .fontSize(17.px)
                    .color(.white)
                    .class(.oneLineText)
                    .custom("font-weight", "700")

                Div(item.fiscalId == nil ? "Sin fiscal" : "Fiscal \(String(item.fiscalId!.uuidString.prefix(8)).uppercased())")
                    .fontSize(12.px)
                    .color(.lightBlueText)
                    .class(.oneLineText)
            }
            .custom("min-width", "0")

            Div("$\(item.balance.formatMoney)")
                .fontSize(16.px)
                .fontWeight(.bold)
                .color(.goldenRod)
                .textAlign(.right)
                .class(.oneLineText)
        }
        .class(.smallButtonBox)
        .display(.grid)
        .custom("grid-template-columns", "105px minmax(0, 1fr) auto")
        .custom("align-items", "center")
        .custom("gap", "10px")
        .padding(v: 9.px, h: 10.px)
        .onClick {
            TripViewBeta.loadAndPresent(tripId: item.id) { tripId, status in
                self.updateTripStatus(tripId: tripId, status: status)
            }
        }
        .marginBottom(8.px)
        .custom("border-left", "6px solid \(accent)")
    }

    func updateTripStatus(
        tripId: UUID,
        status: FiscalTripFollowupStatus
    ) {
        items = items.map { item in
            guard item.id == tripId else {
                return item
            }

            var updatedItem = item
            updatedItem.status = status
            return updatedItem
        }

        processItems()
    }


    /// Start New Service Order
    /// - Parameter orderType: order, rental, date
    func searchCustomer(){
        
        let seachBox = SearchCustomerView { term, results in
            
            // No Results Create Customer
            
            if results.isEmpty {
                addToDom(
                    
                    CreateNewCusomerView(
                        searchTerm: term,
                        custType: .general,
                        callback: { acctType, custType, searchTerm in
                            
                            let custDataView = CreateNewCustomerDataView(
                                acctType: acctType,
                                custType: custType,
                                orderType: .order,
                                searchTerm: searchTerm
                            ) { custAcct in
                                self.startTrip(custAcct)
                            }

                            addToDom(custDataView)
                            
                    })
                )
            }
            else{
                
                if results.count == 1 {
                    
                    guard let custAcct = results.first else {
                        showError(.unexpectedResult, "No se localizo registro de cliente.")
                        return
                    }

                    self.startTrip(custAcct)


                }
                else{
                    
                    let view = NewOrderMultipleAccountResults(accounts: results) { custAcct in
                        self.startTrip(custAcct)
                    }
                    
                    addToDom(view)
                    
                }
            }
        }
        
        addToDom(seachBox)
        
        seachBox.seachCustomerField.select()
        
    }
    func startTrip(_ account: CustAcctSearch) {

        loadingView(show: true)

        API.custCommercialTrips.components { resp in

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

            let view = CreateTripView(
                account: account,
                operadors: payload.operadors,
                insurances: payload.insurances,
                permits: payload.permits,
                vehicals: payload.vehicals,
                trailers: payload.trailers,
                merchendises: payload.merchendises,
                locations: payload.locations
            ) { resp in
                let trip = resp.trip

                let item = CustCommercialTripControlQuick(
                    id: trip.id,
                    createdAt: trip.createdAt,
                    accountId: resp.account.id,
                    name: resp.account.businessName,
                    balance: trip.balance,
                    fiscalId: trip.fiscalId,
                    status: trip.status
                )

                self.items.removeAll { $0.id == item.id }
                self.items.append(item)

                self.pendingItems.removeAll { $0.id == item.id }
                self.pendingItems.append(item)
                self.pendingGridItems = self.pendingItems.map {
                    TripControlGridItem(item: $0)
                }

                addToDom(TripViewBeta(
                    trip: resp
                ) { tripId, status in
                    self.updateTripStatus(tripId: tripId, status: status)
                })
            }

            addToDom(view)

        }

    }

    override func didAddToDOM() {
        super.didAddToDOM()

        isMounted = true
        scheduleNextTripsRefresh()
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

        isMounted = false
        refreshScheduleVersion += 1

        $items.removeAllListeners()
        $pendingItems.removeAllListeners()
        $inProgressItems.removeAllListeners()
        $completedItems.removeAllListeners()
        $cancelledItems.removeAllListeners()
        $pendingGridItems.removeAllListeners()
        $inProgressGridItems.removeAllListeners()
        $completedGridItems.removeAllListeners()
        $cancelledGridItems.removeAllListeners()
        $selectedTripsTypeLabel.removeAllListeners()
        $tripTypeMenuViewIsHidden.removeAllListeners()
    }

}
