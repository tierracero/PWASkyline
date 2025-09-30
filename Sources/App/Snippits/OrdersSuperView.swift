//
//  OrdersSuperView.swift
//  
//
//  Created by Victor Cantu on 6/11/23.
//

import Foundation
import TCFundamentals
import Web

class OrdersSuperView: Div {
    
    override class var name: String { "div" }
    
    
    let workView: WorkViewControler
    
    init(
        workView: WorkViewControler
    ) {
        self.workView = workView
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var selectedStore = ""
    
    /// Order List Catch
    var pending: [CustOrderLoadFolios] = []
    
    var pendingSpare: [CustOrderLoadFolios] = []
    
    var active: [CustOrderLoadFolios] = []
    
    var pendingPickup: [CustOrderLoadFolios] = []
    
    var inOrder: [CustOrderLoadFolios] = []
    
    var outOrder: [CustOrderLoadFolios] = []
    
    var inDelegate: [CustTranferManager] = []
    
    var outDelegate: [CustTranferManager] = []
    
    lazy var firstView = Div()
        .custom("height", "calc(100% - 0px)")
        .overflow(.auto)
        .class( .roundGrayBlackDark, .oneHalf)
    
    lazy var secondView = Div()
        .custom("height", "calc(100% - 0px)")
        .overflow(.auto)
        .class( .roundGrayBlackDark, .oneHalf)
    
    lazy var storeSelect = Select(self.$selectedStore)
        .class(.textFiledBlackDarkLarge)
        .marginLeft(7.px)
        .fontSize(23.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H1("Ordenes por tienda")
                    .color(.lightBlueText)
                    .float(.left)
                
                self.storeSelect
                    .float(.left)
                
                Div().class(.clear)
            }
            
            Div{
                self.firstView
                self.secondView
            }
            .custom("height", "calc(100% - 73px)")
            .padding(all: 7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("height","calc(100% - 75px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(30.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        $selectedStore.listen {
            
            guard let storeid = UUID(uuidString: $0) else {
                return
            }
         
            self.loadOrder(storeid: storeid)
        }
        
        stores.forEach { id, store in
            
            storeSelect.appendChild(
                Option(store.name)
                    .value(id.uuidString)
            )
        }
        
        selectedStore = (stores.first?.value.id.uuidString ?? "")
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func loadOrder(storeid: UUID){
        
        print("⭐️  storeid.uuidString \(storeid.uuidString)")
        
        loadingView(show: true)
        
        API.custOrderV1.loadFolios(
            storeid: storeid,
            accountid: nil,
            current: [],
            curTrans: []
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
                showError(.errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            self.pending = data.pending
            self.pendingSpare = data.pendingSpare
            self.active = data.active
            self.pendingPickup = data.pendingPickup
            self.inOrder = data.inOrder
            self.outOrder = data.outOrder
            self.inDelegate = data.inDelegate
            self.outDelegate = data.outDelegate
            
            self.drawOrderView()
            
        }
        
    }
    
    func drawOrderView(){
        
        firstView.innerHTML = ""
        
        secondView.innerHTML = ""
        
        /// View One
        if !pending.isEmpty {
            
            self.firstView.appendChild(
                H2(CustFolioStatus.pending.description)
                    .color(CustFolioStatus.pending.color)
            )
                
            pending.forEach { data in
                firstView.appendChild(orderRowView(data))
            }
        }
        if !pendingSpare.isEmpty {
            
            firstView.appendChild(
                H2(CustFolioStatus.pendingSpare.description)
                    .color(CustFolioStatus.pendingSpare.color)
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
                H2(CustFolioStatus.active.description)
                    .color(CustFolioStatus.active.color)
            )
            
            active.forEach { data in
                secondView.appendChild(self.orderRowView(data))
            }
            
        }
        if !pendingPickup.isEmpty {
            
            secondView.appendChild(
                H2(CustFolioStatus.finalize.description)
                    .color(CustFolioStatus.finalize.color)
            )
            
            pendingPickup.forEach { data in
                secondView.appendChild(self.orderRowView(data))
            }
            
        }
    }
    
    func orderRowView(_ data: CustOrderLoadFolios) -> Div {
        
        OrderRowView(data: data, callback: { action in
            
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
                        
                        self.appendChild(accoutOverview)
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
                    
                    accoutOverview.loadOrder(id: orderid) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                        
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
                    tasksCatch[orderid] = loadOrderResponse.tasks
                    accountHighPriorityNoteCatch[orderid] = loadOrderResponse.accountHighPriorityNote
                    if let route = loadOrderResponse.route {
                        custOrderRouteCatch[orderid] = route
                    }
                    if let transferOrder = loadOrderResponse.transferOrder {
                        transferOrderCatch[orderid] = transferOrder
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
    
}
