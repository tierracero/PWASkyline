//
// TripsControlerView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FollowupControler: Div {
    
    override class var name: String { "div" }

    init(
        items: [CustCommercialTripControlQuick]
    ) {
        self.items = items
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
        .backgroundColor(.transparentBlack)
        .position(.absolute)
        .borderRadius(all: 12.px)
        .padding(all: 3.px)
        .marginTop(38.px)
        .width(220.px)
        .zIndex(2)

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
    .padding(all: 3.px)
    .fontSize(23.px)
    .class(.uibtn)
    .float(.left)
    .onClick { _, event in
        self.tripTypeMenuViewIsHidden = !self.tripTypeMenuViewIsHidden
        event.stopPropagation()
    }

    lazy var addTripButton = Div{
        Span("+ Viaje")
    }
        .class(.uibtnLargeOrange)
        .marginRight(7.px)
        .marginTop(0.px)
        .fontSize(23.px)
        .float(.right)
        .onClick {

            self.searchCustomer()
            
        }


    @DOM override var body: DOM.Content {

        // MARK : move to header
            Div {

                Div()
                .hidden(self.$tripTypeMenuViewIsHidden)
                .backgroundColor(.transparentBlack)
                .height(100.percent)
                .width(100.percent)
                .position(.fixed)
                .left(0.px)
                .top(0.px)
                .onClick {
                    self.tripTypeMenuViewIsHidden = true
                }

                Div {

                    self.tripTypeButton

                    self.tripTypeMenu

                }
                .position(.relative)
                .marginRight(7.px)
                .float(.right)

                self.addTripButton
                                
                H2("Control de Viajes")
                    .color(.lightBlueText)
                    .marginRight(12.px)
                
                Div().class(.clear)

            }
        /// Move to container 
            Div().class(.clear).height(7.px)

            Div {
                Div {
                    self.tripStatusSection(
                        title: self.$pendingItems.map{ "Pendiente \($0.count)" },
                        itemsView: self.pendingItemsView,
                        isEmpty: self.$pendingItems.map{ $0.isEmpty },
                        noItemsLabel: "Sin viajes pendientes",
                        accent: "#ff9f1a"
                    )

                    self.tripStatusSection(
                        title: self.$inProgressItems.map{ "En Proceso \($0.count)" },
                        itemsView: self.inProgressItemsView,
                        isEmpty: self.$inProgressItems.map{ $0.isEmpty },
                        noItemsLabel: "Sin viajes en proceso",
                        accent: "#13b5ea"
                    )
                }
                .custom("min-width", "0")
                .custom("height", "100%")
                .overflow(.auto)

                Div {
                    self.tripStatusSection(
                        title: self.$completedItems.map{ "Completados \($0.count)" },
                        itemsView: self.completedItemsView,
                        isEmpty: self.$completedItems.map{ $0.isEmpty },
                        noItemsLabel: "Sin viajes completados",
                        accent: "#23ba3a"
                    )

                    self.tripStatusSection(
                        title: self.$cancelledItems.map{ "Cancelados \($0.count)" },
                        itemsView: self.cancelledItemsView,
                        isEmpty: self.$cancelledItems.map{ $0.isEmpty },
                        noItemsLabel: "Sin viajes cancelados",
                        accent: "#d94949"
                    )
                }
                .custom("min-width", "0")
                .custom("height", "100%")
                .overflow(.auto)
            }
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("height", "calc(100% - 35px)")
            .display(.grid)
            .display(.grid)
            .custom("gap", "12px")

            
    }
    
    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        
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
        self.tripTypeMenuViewIsHidden = true
        self.selectedTripsTypeLabel = label

        loadingView(show: true)

        API.custCommercialTrips.getTrips(
            accountId: nil,
            type: type
        ) { resp in

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

            self.processItems(payload.items)
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

    func tripStatusSection(
        title: State<String>,
        itemsView: BaseElement,
        isEmpty: State<Bool>,
        noItemsLabel: String,
        accent: String
    ) -> Div {
        VBox {
            H2(title)
                .custom("color", accent)
                .fontSize(24.px)
                .marginTop(0.px)
                .marginBottom(7.px)

            itemsView
                .hidden(isEmpty)

            Table().noResult(label: noItemsLabel)
                .hidden(isEmpty.map{ !$0 })
        }
        .custom("height", "calc(50% - 12px)")
        .marginBottom(12.px)
    }

    func tripCard(
        _ item: CustCommercialTripControlQuick,
        accent: String
    ) -> Div {
        VBox(.interactive) {
            Div {
                Div(item.folio)
                    .fontSize(22.px)
                    .color(.white)
                    .class(.oneLineText)

                Div(item.status.description)
                    .fontSize(13.px)
                    .color(.white)
                    .class(.oneLineText)
            }
            .float(.left)
            .width(110.px)
            .paddingRight(7.px)

            Div {
                Div("$\(item.balance.formatMoney)")
                    .float(.right)
                    .fontSize(16.px)
                    .color(.goldenRod)
                    .marginLeft(7.px)

                Div(getDate(item.createdAt).formatedShort)
                    .fontSize(14.px)
                    .color(.white)
                    .class(.oneLineText)

                Div(item.name)
                    .fontSize(21.px)
                    .color(.white)
                    .class(.oneLineText)
                    .custom("font-weight", "700")

                Div(item.fiscalId == nil ? "Sin fiscal" : "Fiscal \(String(item.fiscalId!.uuidString.prefix(8)).uppercased())")
                    .fontSize(14.px)
                    .color(.lightBlueText)
                    .class(.oneLineText)
            }
            .custom("margin-left", "117px")

            Div().class(.clear)
        }
        .onClick {
            TripViewBeta.loadAndPresent(tripId: item.id) { tripId, status in
                self.updateTripStatus(tripId: tripId, status: status)
            }
        }
        .marginBottom(7.px)
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

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

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
