//
//  OrderView.swift
//
//
//  Created by Victor Cantu on 4/23/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

struct LoadFileBase64Response: Codable {

    let result: String
    
    let name: String
    
    init(
        result: String,
        name: String
    ) {
        self.result = result
        self.name = name
    }
}

class OrderView: Div {
    
    override class var name: String { "div" }
    
    var accountView: AccoutOverview
    var order: CustOrderLoadFolioDetails
    var notes: [CustOrderLoadFolioNotes]
    var payments: [CustOrderLoadFolioPayments]
    var charges: [CustOrderLoadFolioCharges]
    var pocs: [CustPOCInventoryOrderView]
    var files: [CustOrderLoadFolioFiles]
    var equipments: [CustOrderLoadFolioEquipments]
    var rentals: [CustPOCRentalsMin]
    var transferOrder: CustTranferManager?
    var orderHighPriorityNote: [HighPriorityNote]
    var accountHighPriorityNote: [HighPriorityNote]
    @State var tasks: [CustTaskAuthorizationManagerQuick]
    let orderRoute: CustOrderRoute?
    var loadFromCatch: Bool
    
    init(
        accountView: AccoutOverview,
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
    ) {
        self.accountView = accountView
        self.order = order
        self.notes = notes
        self.payments = payments
        self.charges = charges
        self.pocs = pocs
        self.files = files
        self.equipments = equipments
        self.rentals = rentals
        self.transferOrder = transferOrder
        self.orderHighPriorityNote = orderHighPriorityNote
        self.accountHighPriorityNote = accountHighPriorityNote
        self.tasks = tasks
        self.orderRoute = orderRoute
        self.loadFromCatch = loadFromCatch
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    var smsTokens: [String] = []
    
    /// Equipment Id : isReady
    var equipmentReadyStatusRefrence: [UUID:State<Bool>] = [:]
    
    /// Equipment Id : isPickedUp
    var equipmentPickedStatusRefrence: [UUID:State<Bool>] = [:]
    
    @State var pendingPickups = 0
    
    @State var lastCommunicationMethod: MessagingCommunicationMethods? = nil
    
    /// Order Due / Date
    @State var dueDate: Int64?  = nil
    
    @State var budgetIcon = "/skyline/media/icon_list.png"
    
    @State var budgetStatus: CustBudgetManagerStatus? = nil
    
    @State var inAlert: Bool = false
    
    @State var isHighPriority: Bool = false
    
    @State var orderProject: UUID? = nil
    
    @State var statusMenuIsHidden: Bool = true
    
    /// Order Status
    @State var status: CustFolioStatus = .sideStatus
    
    /// If has multiple equipments this will controll current tap and equipment view
    @State var currentEquipment: UUID? = nil
    
    /// Finance
    var pays: Int64 = 0
    var chas: Int64 = 0
    var total: Int64 = 0
    
    @State var tpays = "$0.00"
    @State var tchars = "$0.00"
    @State var ttotal = "$0.00"
    
    ///  Name & Address
    @State var orderName = ""
    @State var mobile = ""
    @State var telephone = ""
    @State var email = ""
    
    @State var streetHolderIsHidden = true
    @State var colonyHolderIsHidden = true
    @State var cityHolderIsHidden = true
    @State var stateHolderIsHidden = true
    @State var countryHolderIsHidden = true
    @State var ziptHolderIsHidden = true
    
    @State var street = ""
    @State var colony = ""
    @State var city = ""
    @State var state = ""
    @State var country = ""
    @State var zip = ""
    
    @State var lat = ""
    @State var lon = ""
    
    @State var contratc: String? = nil
    
    @State var editMode: Bool = false
    
    @State var requierServiceAddress: Bool = false
    
    @State var onWorkUser: UUID? = nil
    
    @State var onWorkUsername = ""
    
    var chargesRefrence: [ UUID: OldChargeTrRow ] = [:]
    
    var rentalViewRefrence: [UUID:OrderRentalView] = [:]
    
    var equipmentViewRefrence: [UUID:EquipmentView] = [:]
    
    var fileViewCatch: [UUID:OrderImageView] = [:]
    
    lazy var fiscalView = Div()
    
    lazy var chargesTable = TBody()
    
    lazy var equipmentView = Div()
        .backgroundColor(r: 22, g: 25, b: 30)
        .padding(v: 0.px, h: 7.px)
        .borderRadius(12.px)
    
    lazy var filesGrid =  Div()
        .id(Id(stringLiteral: "filesGrid\(self.order.id.uuidString)"))
    
    lazy var createAtDiv = Div()
    
    lazy var dueAtDiv = Div()
    
    lazy var messageGrid = MessageGrid(
        style: .dark,
        orderid: self.order.id,
        accountid: self.order.custAcct,
        folio: self.order.folio,
        name: self.order.name,
        mobile: self.order.mobile,
        notes: self.notes,
        lastCommunicationMethod: self.$lastCommunicationMethod,
        callback: { note in
            
        })
    
    lazy var messageGridDiv = Div{
        self.messageGrid
    }
        .custom("height", "calc(100% - 30px)")
    .class(.twoThird)
    
    lazy var fileLoader: InputFile = InputFile()
        .id(Id(stringLiteral: "fileLoader\(self.order.id)"))
        .accept(["image/png", "image/gif", "image/jpeg", "application/pdf", "video/*", "video", "pages", "numbers", "key"])
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Equipments
            self.equipmentView
            .height(37.percent)
            .overflow(.auto)
            
            /// Notes and files
            Div{
                /// Notes
                self.messageGridDiv
                
                /// Files
                Div{
                    Div{
                        
                        self.fileLoader
                            .hidden(true)
                        
                        Img()
                            .onClick{ self.fileLoader.click() }
                            .src("/skyline/media/add.png")
                            .cursor(.pointer)
                            .float(.right)
                            .height(24.px)
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .float(.right)
                            .height(24.px)
                            .marginRight(12.px)
                        
                        H3("Archivos")
                            .color(.gray)
                    }
                    .marginTop(5.px)
                    
                    self.filesGrid
                        .custom("height", "calc(100% - 25px)")
                        .class(.roundGrayBlackDark)
                        .marginTop(7.px)
                        .overflow(.auto)
                    
                }
                .float(.right)
                .width(33.percent)
                .custom("height", "calc(100% - 33px)")
            }
            .height(40.percent)
            .marginRight(3.px)
            .marginLeft(3.px)
            .overflow(.auto)
            
            /// Charges
            Div{
                Div{
                    
                    /// Payment
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/coin.png")
                                .marginLeft(7.px)
                                .marginTop(3.px)
                                .height(20.px)
                        }
                        .float(.left)
                        
                        Span("Pago")
                    }
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        
                        let pv = AddPaymentFormView (
                            accountId: self.order.custAcct,
                            cardId: self.accountView.cardId,
                            currentBalance: self.total
                        ) { code, description, amount, provider, lastFour, auth, uts in
                            
                            loadingView(show: true)
                            
                            if code == .dineroElectronico {
                                self.proccessPaymentWithPoints(amount)
                            }
                            else {
                                self.proccessPayment(code, description, amount, provider, lastFour, auth, uts)
                            }
                            
                        }
                        
                        self.appendChild(pv)
                        
                        if self.total <= 0 {
                            pv.paymentDescription.select()
                        }
                        else {
                            pv.paymentInput.select()
                        }
                    }
                    
                    /// charge
                    
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/price.png")
                                .marginLeft(7.px)
                                .marginTop(3.px)
                                .height(20.px)
                        }
                        .float(.left)
                        
                        Span("Cargo")
                    }
                    .class(.uibtn)
                    .float(.right)
                    .onClick { _ in
                        self.addCharge()
                    }
                    
                    if self.order.type == .folio {
                        /// Budget
                        Div{
                            
                            Div{
                                Img()
                                    .src(self.$budgetIcon)
                                    .marginLeft(7.px)
                                    .marginTop(3.px)
                                    .height(20.px)
                            }
                            .float(.left)
                            
                            Span("Presupuesto")
                        }
                        .class(.uibtn)
                        .float(.right)
                        .onClick {
                            self.openOrderBudget()
                        }
                    }
                    
                    H2("Cargos y Pagos")
                        .float(.left)
                        .color(.gray)
                    /*
                    Div{
                        
                        Img()
                            .src("/skyline/media/maximizeWindow.png")
                            .class(.iconWhite)
                            .marginLeft(7.px)
                            .cursor(.pointer)
                            .marginTop(7.px)
                            .height(18.px)
                            
                    }
                    .float(.left)
                    */
                    
                    Div().clear(.both)
                }
                
                Div().class(.clear).height(3.px)
                
                Div{

                    Table {
                        
                        THead {
                            Tr{
                                Td().width(20.px)
                                Td("Unis").width(50.px)
                                Td("Description")
                                Td("CUni").width(70.px)
                                Td("STotal").width(70.px)
                            }
                            .color(.lightGray)
                        }

                        self.chargesTable
                        
                    }
                    .width(100.percent)
                    .fontSize(18.px)
                    
                }
                .custom("width", "calc(100% - 240px)")
                .custom("height", "calc(100% - 46px)")
                .class(.roundGrayBlackDark)
                .padding(all: 3.px)
                .overflow(.auto)
                .float(.left)
                
                Div{
                    Div{
                        Span("T. Cargos")
                            .fontSize(12.px)
                            .color(.white)
                        Div().class(.clear).marginTop(7.px)
                        
                        
                        Span("T. Pagos")
                            .fontSize(12.px)
                            .color(.white)
                        Div().class(.clear).marginTop(7.px)
                        
                        Span("Balance")
                            .fontSize(12.px)
                            .fontWeight(.bolder)
                            .color(.white)
                        Div().class(.clear).marginTop(7.px)
                        
                    }
                    .align(.right)
                    .class(.oneHalf)
                    .padding(all: 3.px)
                    
                    Div{
                        Span(self.$tchars)
                            .color(.gray)
                        Div().class(.clear).marginTop(7.px)

                        Span(self.$tpays)
                            .color(.gray)
                        Div().class(.clear).marginTop(7.px)

                        Span(self.$ttotal)
                            .fontWeight(.bolder)
                            .color(.lightGray)
                        Div().class(.clear).marginTop(7.px)
                    }
                    .align(.left)
                    .class(.oneHalf)
                    .padding(all: 3.px)
                    
                    Div().clear(.both)
                    
                    /// Fiscal Document
                    self.fiscalView
                    .hidden(self.$status.map { ( $0 == .finalize || $0 == .canceled || $0 == .archive ) ? false : true })
                    
                }
                .float(.right)
                .fontSize(16.px)
                .width(220.px)
                
            }
            .height(23.percent)
            .marginRight(3.px)
            .overflow(.hidden)
            .marginLeft(3.px)
            .overflow(.auto)
        
        }
        .boxShadow(h: 1.px, v: 1.px, blur: 7.px, color: .black)
        .class(.roundGrayBlackDark, .twoThird)
        .custom("height", "calc(100% - 3px)")
        .padding(all: 0.px)
        
        Div {
            
            Div{
                
                Div{
                
                    Div{
                        
                        Img()
                            .src("/skyline/media/icons_alert.png")
                            .cursor(.pointer)
                            .float(.right)
                            .height(32.px)
                        
                        H4("Tareas Pendientes")
                            .color(.yellowTC)
                    }
                    
                    Div().clear(.both).height(3.px)
                    
                    ForEach(self.$tasks) { task in
                        TaskView(task: task) { taskId in
                            
                            var newTasks: [CustTaskAuthorizationManagerQuick] = []
                            
                            if let tasks = tasksCatch[self.order.id] {
                                tasks.forEach { task in
                                    if task.id == taskId {
                                        return
                                    }
                                    newTasks.append(task)
                                }
                            }
                            
                            tasksCatch[self.order.id] = newTasks
                            self.tasks = newTasks
                        }
                    }
                    
                    
                    Div().clear(.both).height(7.px)
                }
                .hidden(self.$tasks.map{ $0.isEmpty })
                .paddingRight(7.px)
                
                Div{
                    
                    Img()
                        .src(self.$isHighPriority.map{ $0 ? "/skyline/media/icons_high_priority.png" : "/skyline/media/icons_high_priority_off.png" })
                        .padding(all: 7.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .height(32.px)
                        .onClick {
                            
                            guard custCatchHerk >= 2 else {
                                return
                            }
                            
                            var title = "Marcar como Alta Prioridad"
                            
                            if self.isHighPriority {
                                title = "Remover Alta Prioridad"
                            }
                            
                            addToDom(
                                
                                ConfirmationView(
                                    type: .acceptDeny,
                                    title: title,
                                    message: "Confirme e ingrese el motivo del cambio.",
                                    comments: .requiredExemptFromHerk(4)
                                ) { isConfirmed, comment in
                                    
                                    if isConfirmed {
                                        
                                        loadingView(show: true)
                                        
                                        API.custOrderV1.highPrioritize(
                                            orderId: self.order.id,
                                            reason: comment,
                                            state: !self.isHighPriority
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
                                            
                                            OrderCatchControler.shared.updateParameter(self.order.id, .hightPriorityStatus(!self.isHighPriority))
                                            
                                            self.order.highPriority = !self.isHighPriority
                                            
                                            self.isHighPriority = !self.isHighPriority
                                            
                                        }
                                    }
                                    
                                }
                            )
                            
                        }
                    
                    Img()
                        .src(self.$inAlert.map{ $0 ? "/skyline/media/icons_alert.png" : "/skyline/media/icons_alert_off.png" })
                        .padding(all: 7.px)
                        .paddingRight(0.px)
                        .cursor(.pointer)
                        .height(32.px)
                        .onClick {
                            
                            var title = "Marcar con alerta"
                            
                            if self.inAlert {
                                title = "Remover alerta"
                            }
                            
                            addToDom(
                                
                                ConfirmationView(
                                    type: .acceptDeny,
                                    title: title,
                                    message: "Confirme e ingrese el motivo del cambio.",
                                    comments: .requiredExemptFromHerk(4)
                                ) { isConfirmed, comment in
                                    
                                    if isConfirmed {
                                        
                                        loadingView(show: true)
                                        
                                        API.custOrderV1.alerted(
                                            orderId: self.order.id,
                                            reason: comment,
                                            state: !self.inAlert
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
                                            
                                            OrderCatchControler.shared.updateParameter(self.order.id, .alertStatus(!self.inAlert))
                                            
                                            self.order.alerted = !self.inAlert
                                            
                                            self.inAlert = !self.inAlert
                                            
                                        }
                                    }
                                }
                            )
                        }
                    
                    Img()
                        .float(.right)
                        .cursor(.pointer)
                        .src("/skyline/media/cross.png")
                        .height(32.px)
                        .padding(all: 7.px)
                        .paddingRight(0.px)
                        .hidden(self.$editMode.map{!$0})
                        .onClick { img, event in
                            self.orderName = self.order.name
                            self.mobile = self.order.mobile
                            self.email = self.order.email
                            self.telephone = self.order.telephone
                            self.street = self.order.street
                            self.colony = self.order.colony
                            self.city = self.order.city
                            self.state = self.order.state
                            self.country = self.order.country
                            self.zip = self.order.zip
                            self.editMode = false
                        }
                    
                          
                    Img()
                        .float(.right)
                        .cursor(.pointer)
                        .src(self.$editMode.map{ $0 ? "/skyline/media/diskette.png" : "/skyline/media/pencil.png" })
                        .height(32.px)
                        .padding(all: 7.px)
                        .onClick { img, event in
                            
                            if self.editMode {
                                self.saveOrderDetails()
                                return
                            }
                            self.editMode = true
                        }
                                    
                   Div{
                       Div{
                           Img()
                               .src("/skyline/media/add.png")
                               .marginLeft(3.px)
                               .marginTop(7.px)
                               .height(20.px)
                       }
                       .float(.left)
                       
                       Span("Proyecto")
                   }
                   .hidden(self.$orderProject.map{ $0 != nil })
                   .class(.uibtn)
                   .float(.right)
                   .onClick {
                       self.addOrderProject()
                   }
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/star_yellow.png")
                                .marginLeft(3.px)
                                .marginTop(7.px)
                                .height(20.px)
                        }
                        .float(.left)
                        
                        Span("Ver Proyecto")
                        
                    }
                    .hidden(self.$orderProject.map{ $0 == nil })
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        
                        guard let orderProject = self.orderProject else {
                            showError(.unexpectedResult, "No selocalizo id del proyecto")
                            return
                        }
                        
                        API.custOrderV1.loadOrderProject(
                            projetcId: orderProject,
                            orderId: self.order.id
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
                            
                            let view = OrderProject(
                                project: payload.project,
                                items: payload.items,
                                charges: payload.charges
                            )
                            
                            addToDom(view)
                            
                            
                        }
                        
                    }
                    
                    
                   
                }
                
                Div().clear(.both).height(3.px)
                
                Div{
                    
                    Div{
                        
                        Span("Folio")
                            .marginRight(7.px)
                            .color(.gray)
                        
                        Span(self.order.folio)
                            .marginRight(7.px)
                            .color(.lightGray)
                        
                    }
                    .width(55.percent)
                    .float(.left)
                    
                    Div{
                        
                        if custCatchHerk >= 2 {
                            
                            Div{
                                
                                Div(self.$status.map{ $0.description })
                                    .custom("width", "calc(100% - 38px)")
                                    .color(self.$status.map{ $0.color})
                                    .class(.oneLineText)
                                    .float(.left)
                                 
                                 Div{
                                     Img()
                                         .src(self.$statusMenuIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                         .class(.iconWhite)
                                         .paddingTop(7.px)
                                         .opacity(0.5)
                                         .width(18.px)
                                 }
                                 .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                                 .hidden(self.$status.map{
                                     [
                                        CustFolioStatus.pending,
                                        CustFolioStatus.canceled,
                                        CustFolioStatus.finalize,
                                        CustFolioStatus.pendingSpare,
                                        CustFolioStatus.collection
                                     ].contains($0)
                                 })
                                 .paddingRight(3.px)
                                 .paddingLeft(7.px)
                                 .marginLeft(7.px)
                                 .float(.right)
                                 .width(18.px)
                                
                                 Div().clear(.both)
                                 
                             }
                            .width(91.percent)
                            .class(.uibtn)
                            .onClick {
                                
                                if [
                                    CustFolioStatus.pending,
                                    CustFolioStatus.canceled,
                                    CustFolioStatus.finalize,
                                    CustFolioStatus.pendingSpare,
                                    CustFolioStatus.collection
                                ].contains(self.status) {
                                   return
                                }
                                
                                self.statusMenuIsHidden = !self.statusMenuIsHidden
                            }
                            
                            Div{
                                
                                /// Pending
                                Div(CustFolioStatus.pending.description)
                                .hidden(self.$status.map{ $0 == .pending })
                                .color(CustFolioStatus.pending.color)
                                .class(.oneLineText)
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.changeOrderStatus(.pending)
                                    self.statusMenuIsHidden = true
                                    event.stopPropagation()
                                }
                                    
                                /// Active
                                Div(CustFolioStatus.active.description)
                                .hidden(self.$status.map{ $0 == .active })
                                .color(CustFolioStatus.active.color)
                                .class(.oneLineText)
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.changeOrderStatus(.active)
                                    self.statusMenuIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                /// Collections
                                Div(CustFolioStatus.saleWait.description)
                                .hidden(self.$status.map{ $0 == .saleWait })
                                .color(CustFolioStatus.saleWait.color)
                                .class(.oneLineText)
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.changeOrderStatus(.saleWait)
                                    self.statusMenuIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                /// Archive
                                Div(CustFolioStatus.archive.description)
                                .hidden(self.$status.map{ $0 == .archive })
                                .color(CustFolioStatus.archive.color)
                                .class(.oneLineText)
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.changeOrderStatus(.archive)
                                    self.statusMenuIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                /// Collections
                                Div(CustFolioStatus.collection.description)
                                .hidden(self.$status.map{ $0 == .collection })
                                .color(CustFolioStatus.collection.color)
                                .class(.oneLineText)
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.changeOrderStatus(.collection)
                                    self.statusMenuIsHidden = true
                                    event.stopPropagation()
                                }
                                
                                Div{
                                    
                                    Div(CustFolioStatus.finalize.description)
                                    .color(CustFolioStatus.finalize.color)
                                    .class(.oneLineText)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .class(.uibtn)
                                    .onClick { _, event in
                                        self.changeOrderStatus(.finalize)
                                        self.statusMenuIsHidden = true
                                        event.stopPropagation()
                                    }
                                    
                                    Div(CustFolioStatus.canceled.description)
                                    .color(CustFolioStatus.canceled.color)
                                    .class(.oneLineText)
                                    .width(90.percent)
                                    .marginTop(7.px)
                                    .class(.uibtn)
                                    .onClick { _, event in
                                        self.changeOrderStatus(.canceled)
                                        self.statusMenuIsHidden = true
                                        event.stopPropagation()
                                    }
                                    
                                }
                                .hidden(self.$status.map{ $0 != .archive })
                                
                                
                                Div().height(12.px)
                            }
                            .hidden(self.$statusMenuIsHidden)
                            .backgroundColor(.transparentBlack)
                            .position(.absolute)
                            .borderRadius(12.px)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .marginTop(7.px)
                            .width(200.px)
                            .zIndex(1)
                            .onClick { _, event in
                                event.stopPropagation()
                            }
                            
                        }
                        else {
                            
                            Div(self.$status.map{ $0.description })
                                .color(self.$status.map{ $0.color})
                                .class(.oneLineText)
                        }
                        
                    }
                    .width(45.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .marginBottom(7.px)
            
                Div().class(.clear)
                
                // Created At
                Div{
                    Div("Creado")
                    .class(.oneThird)
                    .color(.gray)
                    
                    self.createAtDiv
                        .align(.right)
                        .fontSize(26.px)
                        .class(.twoThird)
                }
                
                Div().class(.clear)
                
                // Date
                Div{
                    Div("Cita")
                        .color(.white)
                        .float(.left)
                    
                    // Request Date
                    
                    if self.order.type != .rental {
                        
                        self.dueAtDiv
                            .float(.right)
                            .cursor(.pointer)
                            .hidden( self.$dueDate.map{$0 == nil ? true : false} )
                            .onClick {
                                self.orderDate()
                            }
                        
                        Div{
                            Span("Agregar Cita")
                                .color(.skyBlue)
                                .float(.right)
                            
                            Img()
                                .src("/skyline/media/icon_calendar.png")
                                .class(.iconWhite)
                                .height(26.px)
                                .float(.right)
                                .paddingRight(12.px)
                            
                            Div().class(.clear)
                        }
                        .float(.right)
                        .hidden( self.$dueDate.map{$0 != nil ? true : false} )
                        .cursor(.pointer)
                        .onClick {
                            self.orderDate()
                        }
                    }
                    else{
                        self.dueAtDiv
                            .float(.right)
                    }
                    
                    Div().class(.clear)
                }
                .fontSize(28.px)
                .align(.right)
                
                // OnWork User
                Div{
                    Div("Operador")
                        .color(.white)
                        .float(.left)
                    
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/random.png")
                                .cursor(.pointer)
                                .marginTop(7.px)
                                .height(26.px)
                                .onClick {
                                    
                                    guard let store = self.order.store else {
                                        print("Order has no store id")
                                        return
                                    }
                                    
                                    addToDom(SelectCustUsernameView(
                                        type: .store(store),
                                        ignore: [],
                                        callback: { user in
                                            
                                            loadingView(show: true)
                                            
                                            API.custOrderV1.reassign(
                                                orderid: self.order.id,
                                                userid: user.id
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
                                                
                                                self.onWorkUser = user.id
                                                
                                                self.order.workedBy = user.id
                                                
                                                orderCatch[self.order.id]?.workedBy = user.id
                                                
                                            }
                                            
                                        })
                                    )
                                    
                                    // reassign
                                    
                                }
                        }
                        .paddingRight(12.px)
                        .float(.left)
                        
                        
                        Span(self.$onWorkUsername)
                    }
                    .float(.right)
                }
                .hidden(self.$onWorkUser.map{ $0 == nil })
                .fontSize(28.px)
                
                Div().class(.clear).marginBottom(7.px)
                
                /// Name Mobile
                Div {
                    H3("Contacto")
                        .fontSize(16.px)
                        .color(.gray)
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/usernameIconWhite.svg")
                            .height(18.px)
                            .paddingTop( 3.px)
                            .paddingRight(7.px)
                            .float(.left)
                            .opacity(0.5)
                            .hidden(self.$editMode.map{$0})
                        
                        Span(self.$orderName)
                            .hidden(self.$editMode.map{$0})
                            .marginBottom(7.px)
                            .color(.goldenRod)
                            .fontSize(22.px)
                            .float(.left)
                        
                        InputText(self.$orderName)
                            .placeholder("Nombre")
                            .custom("width","calc(100% - 45px)")
                            .leftImage(img: "/skyline/media/usernameIconWhite.svg")
                            .backgroundSize(h: 18.px, v: 18.px)
                            .class(.textFiledBlackDark)
                            .hidden(self.$editMode.map{!$0})
                            .height(31.px)
                    }
                    .class(.oneTwo, .oneLineText)
                    .paddingLeft(0.px)
                    
                    Div{
                        
                        Img()
                            .cursor(.pointer)
                            .src("/skyline/media/icon_mobile.png")
                            .hidden(self.$editMode.map{$0})
                            .class(.iconWhite)
                            .paddingRight(7.px)
                            .paddingTop( 3.px)
                            .height(18.px)
                            .float(.left)
                        
                        Span(self.$mobile)
                            .hidden(self.$editMode.map{$0})
                            .marginBottom(7.px)
                            .color(.goldenRod)
                            .fontSize(20.px)
                            .float(.left)
                        
                        InputText(self.$mobile)
                            .placeholder("834 123 1234")
                            .custom("width","calc(100% - 52px)")
                            .leftImage(img: "/skyline/media/icon_mobile_white.png")
                            .backgroundSize(h: 18.px, v: 18.px)
                            .class(.textFiledBlackDark)
                            .hidden(self.$editMode.map{!$0})
                            .height(31.px)
                    }
                    .class(.oneTwo, .oneLineText)
                    .paddingRight(0.px)
                }
                .marginBottom(7.px)
            
                Div().class(.clear)
                
                /// Telephone Email
                if !self.order.telephone.isEmpty || !self.order.email.isEmpty {
                    Div {
                        if !self.order.telephone.isEmpty {
                            Div{
                                
                                Img()
                                    .cursor(.pointer)
                                    .src("/skyline/media/icon_telephone.png")
                                    .class(.iconWhite)
                                    .height(18.px)
                                    .paddingTop( 3.px)
                                    .paddingRight(7.px)
                                    .float(.left)
                                    .hidden(self.$editMode.map{$0})

                                Span(self.$telephone)
                                    .fontSize(20.px)
                                    .float(.left)
                                    .hidden(self.$editMode.map{$0})
                                    .marginBottom(7.px)
                                
                                InputText(self.$telephone)
                                    .placeholder("834 123 1234")
                                    .custom("width","calc(100% - 45px)")
                                    .leftImage(img: "/skyline/media/icon_telephone_white.svg")
                                    .backgroundSize(h: 18.px, v: 18.px)
                                    .class(.textFiledBlackDark)
                                    .hidden(self.$editMode.map{!$0})
                                    .height(31.px)
                                
                            }
                            .class(.oneTwo, .oneLineText)

                        }
                        if !self.order.email.isEmpty {
                            Div{
                                Img()
                                    .cursor(.pointer)
                                    .src("/skyline/media/icon_email.png")
                                    .class(.iconWhite)
                                    .height(18.px)
                                    .paddingTop( 3.px)
                                    .paddingRight(7.px)
                                    .float(.left)
                                    .hidden(self.$editMode.map{$0})
                                    .marginBottom(7.px)
                                
                                Span(self.$email)
                                    .fontSize(20.px)
                                    .float(.left)
                                    .hidden(self.$editMode.map{$0})
                                    .marginBottom(7.px)
                                
                                InputText(self.$email)
                                    .placeholder("Correo Electronico")
                                    .custom("width","calc(100% - 52px)")
                                    .leftImage(img: "/skyline/media/icon_email_white.svg")
                                    .backgroundSize(h: 18.px, v: 18.px)
                                    .class(.textFiledBlackDark)
                                    .hidden(self.$editMode.map{!$0})
                                    .height(31.px)
                            }
                            .class(.oneTwo, .oneLineText)
                        }
                    }
                    .marginBottom(7.px)
                }
                
                if configStoreProcessing.rewardsPrograme != nil {
                    
                    Div().clear(.both).height(12.px)
                    
                    Div{
                        Div{
                            
                            Img()
                                .src("/skyline/media/activate_rewards_2.png")
                                .custom("width", "calc(100% - 24px)")
                        }
                        .width(50.percent)
                        .float(.left)
                        Div{
                            
                            Div{
                                Img()
                                    .float(.right)
                                    .cursor(.pointer)
                                    .src("/skyline/media/add.png")
                                    .height(18.px)
                                    .padding(all: 3.px)
                                    .paddingRight(0.px)
                                    .onClick { img, event in
                                        self.addLoyaltyCard(isRequiered: true) {
                                            /// No callback necesary
                                        }
                                    }
                                
                                Div("Tarjeta de Lealtad")
                                    .class(.oneLineText)
                                    .color(.darkOrange)
                                    .fontSize(18.px)
                            }
                            
                            Div().class(.clear)
                            
                            Div("Tarjeta de Puntos")
                                .class(.oneLineText, .textFiledBlackDark)
                                .color(Color(r: 81, g: 85, b: 94) )
                                .cursor(.pointer)
                                .fontSize(24.px)
                                .height(32.px)
                                .onClick {
                                    self.addLoyaltyCard(isRequiered: true){
                                        /// No callback is requiered
                                    }
                                }
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    .hidden(self.accountView.$cardId.map{ !$0.isEmpty })
                    
                    Div{
                        Div{
                            Div("Tarjeta de Lealtad")
                                .class(.oneLineText)
                                .color(.darkOrange)
                                .fontSize(18.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        Div{
                            
                            Div(self.accountView.$cardId.map{ $0 })
                                .class(.oneLineText, .textFiledBlackDark)
                                .color(.lightGray)
                                .cursor(.default)
                                .fontSize(24.px)
                                .height(32.px)
                                
                        }
                        .width(50.percent)
                        .float(.left)
                        
                    }
                    .hidden(self.accountView.$cardId.map{ $0.isEmpty })
                
                    Div().clear(.both).height(5.px)
                    
                }
                
                Div().clear(.both)
                
                Div{
                    Div{
                        Span("Encuestas Administración")
                            .fontSize(16.px)
                        Div().class(.clear).marginTop(7.px)
                        Div{
                            /// First Point
                            Div{
                                Div()
                                    .backgroundColor(.yellowContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Second Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Third Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Fourth Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Fivth Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            Div().clear(.both)
                            
                        }
                    }
                    .class(.oneHalf)
                    .borderRight(width: .thin, style: .solid, color: .gray)
                    
                    Div{
                        
                        Span("Encuestas Tecnico")
                            .fontSize(16.px)
                        Div().class(.clear).marginTop(7.px)
                        Div{
                            /// First Point
                            Div{
                                Div()
                                    .backgroundColor(.yellowContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Second Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Third Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Fourth Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            /// Fifth Point
                            Div{
                                Div()
                                    .backgroundColor(.grayContrast)
                                    .borderRadius(all: 9.px)
                                    .width(18.px)
                                    .height(18.px)
                            }
                            .width(20.percent)
                            .align(.center)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                    }
                    .class(.oneHalf)
                    
                    Div().clear(.both)
                }
                
                Div().class(.clear).marginTop(12.px)
                
                Div {
                    
                    Div{
                        
                        Span("Carta de Servicio")
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginRight(12.px)
                            .float(.right)
                            .height(24.px)
                    }
                    .hidden(self.$contratc.map{ $0 == nil })
                    .class(.uibtnLarge)
                    .width(95.percent)
                    .onClick {
                        
                        let file = ((self.order.contract ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                            .replace(from: "/", to: "%2f")
                            .replace(from: "+", to: "%2b")
                            .replace(from: "=", to: "%3d")
                        
                        let url = baseSkylineAPIUrl(ie: "downloadContract") +
                        "&orderId=" + self.order.id.uuidString +
                        "&documentId=" + file
                        
                        _ = JSObject.global.goToURL!(url)
                }
                    
                    Div{
                        Span("-- No hay Carta de Servicio")
                            .color(.gray)
                    }
                    .hidden(self.$contratc.map{ $0 != nil })
                    .align(.center)
                     
                }
                
                Div().class(.clear).marginTop(12.px)
                
                Div {
                    Img()
                        .float(.right)
                        .src("/skyline/media/zoom.png")
                        .class(.iconWhite)
                        .height(24.px)
                        .padding(all: 3.px)
                    
                    H2("Direccion de servicio")
                        .fontSize(24.px)
                        .marginTop(7.px)
                        .marginBottom(3.px)
                }
                .cursor(.pointer)
                .onClick { self.requierServiceAddress =  !self.requierServiceAddress }
                
                Div().class(.clear)
                
                Div{
                    
                    /// Map
                    Div{
                        Img()
                            .src("/skyline/media/orderMapRequest.jpeg")
                            .margin(all:7.px)
                            .opacity(0.5)
                            .borderRadius(all: 12.px)
                            .custom("width","calc(100% - 14px)")
                            .cursor(.pointer)
                            .onClick {
                                
                            }
                    }
                    .id(Id(stringLiteral: "mapkitjs"))
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// street
                    Div {
                        
                        Span(self.$street)
                            .color(.lightGray)
                            .fontSize(22.px)
                            .float(.left)
                            .hidden(self.$editMode.map{$0})
                            .marginBottom(7.px)
                        
                        Span("Calle y Numero")
                            .color(.rgb(81, 85,94))
                            .fontSize(22.px)
                            .float(.left)
                            .hidden(self.$streetHolderIsHidden.map{$0})
                            .marginBottom(7.px)
                        
                        InputText(self.$street)
                            .placeholder("Calle y Numero")
                            .custom("width","calc(100% - 18px)")
                            .class(.textFiledBlackDark)
                            .hidden(self.$editMode.map{!$0})
                            .height(31.px)
                        
                    }
                    .paddingLeft(0.px)
                    
                    Div().class(.clear)
                    
                    /// city colony
                    Div {
                        Div{
                            Span(self.$colony)
                                .color(.lightGray)
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$editMode.map{$0})
                                .marginBottom(7.px)
                            
                            Span("Colonia")
                                .color(.rgb( 81, 85, 94))
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$colonyHolderIsHidden.map{$0})
                                .marginBottom(7.px)
                            
                            InputText(self.$colony)
                                .placeholder("Colonia")
                                .custom("width","calc(100% - 18px)")
                                .class(.textFiledBlackDark)
                                .hidden(self.$editMode.map{!$0})
                                .height(31.px)
                        }
                        .class(.oneTwo, .oneLineText)
                        .paddingLeft(0.px)
                        
                        Div{
                            Span(self.$city)
                                .color(.lightGray)
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$editMode.map{$0})
                                .marginBottom(7.px)
                            
                            Span("Cudiad")
                                .color(.rgb( 81, 85, 94))
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$cityHolderIsHidden.map{$0})
                                .marginBottom(7.px)
                            
                            InputText(self.$city)
                                .placeholder("Cuidad")
                                .custom("width","calc(100% - 18px)")
                                .class(.textFiledBlackDark)
                                .hidden(self.$editMode.map{!$0})
                                .height(31.px)
                        }
                        .class(.oneTwo, .oneLineText)
                        .paddingRight(0.px)
                    }
                    .marginBottom(7.px)
                    
                    Div().class(.clear)
                    
                    ///state country zip
                    Div {
                        Div{
                            Span(self.$state)
                                .color(.lightGray)
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$editMode.map{$0})
                                .marginBottom(7.px)
                            
                            Span("Estado")
                                .color(.rgb( 81, 85, 94))
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$stateHolderIsHidden.map{$0})
                                .marginBottom(7.px)
                            
                            InputText(self.$state)
                                .placeholder("Estado")
                                .custom("width","calc(100% - 18px)")
                                .class(.textFiledBlackDark)
                                .hidden(self.$editMode.map{!$0})
                                .height(31.px)
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Span(self.$country)
                                .color(.lightGray)
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$editMode.map{$0})
                                .marginBottom(7.px)
                            
                            Span("Pais")
                                .color(.rgb( 81, 85, 94))
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$countryHolderIsHidden.map{$0})
                                .marginBottom(7.px)
                            
                            InputText(self.$country)
                                .placeholder("Pais")
                                .custom("width","calc(100% - 18px)")
                                .class(.textFiledBlackDark)
                                .hidden(self.$editMode.map{!$0})
                                .height(31.px)
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Span(self.$zip)
                                .color(.lightGray)
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$editMode.map{$0})
                                .marginBottom(7.px)
                            
                            Span("CP")
                                .color(.rgb( 81, 85, 94))
                                .fontSize(22.px)
                                .float(.left)
                                .hidden(self.$ziptHolderIsHidden.map{$0})
                                .marginBottom(7.px)
                            
                            InputText(self.$zip)
                                .placeholder("C.P.")
                                .custom("width","calc(100% - 18px)")
                                .class(.textFiledBlackDark)
                                .hidden(self.$editMode.map{!$0})
                                .height(31.px)
                        }
                        .width(33.percent)
                        .float(.left)
                    }
                    
                    Div().class(.clear)
                        .marginBottom(7.px)
                }
                .boxShadow(h: 2.px, v: 2.px, blur: 3.px, color: .grayBlackDark)
                .class(.roundGrayBlackDark)
                .hidden(self.$requierServiceAddress.map{!$0})
                
                Div().class(.clear).marginTop(24.px)
                
            }
            .custom("height", "calc(100% - 73px)") 
            .marginBottom(7.px)
            .overflow(.auto)
            
            /// Status View
            Div{
                     
                /// pending
                Div {
                    
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .margin(all: 7.px)
                        .class(.iconWhite)
                        .cursor(.pointer)
                        .height(35.px)
                        .float(.right)
                        .onClick {
                            self.printOrder()
                        }
                    
                    Div{
                        CustFolioStatus.pending.whiteIcon128
                            .class(.iconWhite)
                            .marginRight(7.px)
                            .height(28.px)
                        
                        Span("Adoptar")
                            .fontSize(28.px)
                            .color(.black)
                        
                    }
                    .backgroundColor(CustFolioStatus.pending.color)
                    .padding(all: 7.px)
                    .width(50.percent)
                    .borderRadius(all: 12.px)
                    .cursor(.pointer)
                    .onClick({ div, event in
                        self.appendChild(ConfirmView(type: .yesNo, title: "Adoptar Orden", message: "Confirme que va adoptar la orden", callback: { isConfirmed, _ in
                            
                            if isConfirmed {
                                
                                loadingView(show: true)
                                
                                API.custOrderV1.adopt(id: self.order.id) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp = resp else {
                                        showError(.errorDeCommunicacion, .serverConextionError)
                                        return
                                    }
                                    
                                    guard resp.status == .ok else{
                                        showError(.errorGeneral, resp.msg)
                                        return
                                    }
                                    
                                    self.onWorkUser = custCatchID
                                    
                                    OrderCatchControler.shared.updateParameter(self.order.id, .orderStatus(.active))
                                    
                                    self.status = .active
                                    
                                }
                                
                            }
                            
                        }))
                    })
                }
                .padding(all: 7.px)
                .align(.center)
                .hidden(self.$status.map{ $0 == .pending ? false : true  })
                
                /// active
                Div {
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/checkmark.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Span(configServiceTags.typeOfServiceObject.positiveTag)
                            .fontSize(24.px)
                    }
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        self.initiateOrderFinalization(force: false)
                    }
                    
                    Div{
                        Img()
                            .src("/skyline/media/cross.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Span(configServiceTags.typeOfServiceObject.negativeTag)
                            .fontSize(24.px)
                    }
                    .marginRight(7.px)
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        self.initiateOrderCancelation()
                    }
                    
                }
                .paddingTop(12.px)
                .hidden(self.$status.map { ( $0 == .pendingSpare || $0 == .active ) ? false : true })
                
                /// cnx fini
                Div {
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_pending_pickup@128.png")
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Span("Entregar")
                            .fontSize(24.px)
                    }
                    .hidden(self.$pendingPickups.map{ $0 <= 0 })
                    .float(.left)
                    .class(.uibtn)
                    .onClick {
                        self.pickupEquipment()
                    }
                    
                    /// Reactivate
                    Div{
                        
                        Img()
                            .src("/skyline/media/round.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Span("Reactivar")
                            .fontSize(24.px)
                    }
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        self.reactivate()
                    }
                    
                    Div().clear(.both)
                    
                }
                .paddingTop(12.px)
                .hidden(self.$status.map { ( $0 == .finalize || $0 == .canceled || $0 == .archive ) ? false : true })
                
                Div().clear(.both)
                
            }
            .boxShadow(h: 1.px, v: 1.px, blur: 7.px, color: .black)
            .borderRadius(12.px)
            .marginRight(7.px)
            .marginLeft(7.px)
            .overflow(.auto)
            .height(63.px)
            
        }
        //.custom("height", "calc(100% - 10px)")
        .custom("width", "calc(34% - 7px)")
        .height(100.percent)
        .marginLeft(3.px)
        .fontSize(24.px)
        .overflow(.auto)
        .float(.right)
        .color(.gray)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        width(100.percent)
        height(100.percent)
        
        dueAtDiv = Div{
            
            Span(self.$dueDate.map{ ($0 == nil) ? "" : "\(getDate($0!).formatedShort) \(getDate($0!).time)"} )
                .float(.right)
            
            Img()
                .src("/skyline/media/icon_calendar.png")
                .class(.iconWhite)
                .height(26.px)
                .float(.right)
                .paddingRight(12.px)
            
            Div().class(.clear)
            
        }
        .color(self.$dueDate.map {
            
            var divcolor: Color = .white
            
            guard let dd = $0 else {
                return divcolor
            }
            
            switch orderTimeMesure(uts: dd, type: .date).color {
            case .blue:
                break
            case .green:
                divcolor = .green
            case .orange:
                divcolor = .orange
            case .red:
                divcolor = .red
            }
            
            return divcolor
        })
        
        $status.listen {
            OrderCatchControler.shared.updateParameter( self.order.id, .orderStatus($0))
            self.accountView.orderStatus = $0
            self.statusMenuIsHidden = true
        }
        
        $budgetStatus.listen {
            switch $0 {
            case .budgetRequested:
                self.budgetIcon = "/skyline/media/icon_budgets_required.png"
            case .preparing, .pendingAproval:
                self.budgetIcon = "/skyline/media/icon_budgets_inprogress.png"
            case .prepared:
                self.budgetIcon = "/skyline/media/icon_budgets_ready.png"
            case .approved, .canceled, nil:
                self.budgetIcon = "/skyline/media/icon_budgets_add_white.png"
                self.order.budget = nil
                self.order.budgetRequest = nil
            }
        }
        
        $editMode.listen {
            
            /// Edit mode on
            if $0 {
                self.streetHolderIsHidden = true
                self.colonyHolderIsHidden = true
                self.cityHolderIsHidden = true
                self.stateHolderIsHidden = true
                self.countryHolderIsHidden = true
                self.ziptHolderIsHidden = true
            }
            /// Edit mode off
            else{
                
                self.streetHolderIsHidden = !self.street.isEmpty
                self.colonyHolderIsHidden = !self.colony.isEmpty
                self.cityHolderIsHidden = !self.city.isEmpty
                self.stateHolderIsHidden = !self.state.isEmpty
                self.countryHolderIsHidden = !self.country.isEmpty
                self.ziptHolderIsHidden = !self.zip.isEmpty
                
            }
            
        }
        
        $street.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.streetHolderIsHidden = true
                }
                else{
                    self.streetHolderIsHidden = false
                }
            }
            else{
                self.streetHolderIsHidden = true
            }
        }
        
        $colony.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.colonyHolderIsHidden = true
                }
                else{
                    self.colonyHolderIsHidden = false
                }
            }
            else{
                self.colonyHolderIsHidden = true
            }
        }
        
        $city.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.cityHolderIsHidden = true
                }
                else{
                    self.cityHolderIsHidden = false
                }
            }
            else{
                self.cityHolderIsHidden = true
            }
        }
        
        $state.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.stateHolderIsHidden = true
                }
                else{
                    self.stateHolderIsHidden = false
                }
            }
            else{
                self.stateHolderIsHidden = true
            }
        }
        
        $country.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.countryHolderIsHidden = true
                }
                else{
                    self.countryHolderIsHidden = false
                }
            }
            else{
                self.countryHolderIsHidden = true
            }
        }
        
        $zip.listen {
            if $0.isEmpty {
                if self.editMode {
                    self.ziptHolderIsHidden = true
                }
                else{
                    self.ziptHolderIsHidden = false
                }
            }
            else{
                self.ziptHolderIsHidden = true
            }
        }
        
        $onWorkUser.listen {
            
            if let userid = $0 {
                
                getUserRefrence(id: .id(userid)) { user in
                    
                    guard let user else {
                        self.onWorkUsername = String(userid.uuidString.suffix(12))
                        return
                    }
                    
                    if user.username.contains("@") {
                        self.onWorkUsername = "@\(user.username.explode("@").first ?? "")"
                    }
                    else {
                        self.onWorkUsername = String("\(user.firstName) \(user.lastName)".prefix(20))
                    }
                    
                }
            }
            
        }
        
        fileLoader.$files.listen {
            $0.forEach { file in
                self.loadMedia(file)
            }
        }
        
        accountView.$cardId.listen {
            acctMinCatch[self.order.id]?.CardID = $0
        }
        
        parseOrderData()
        
        if loadFromCatch {
            API.custOrderV1.loadOrder(
                identifier: .id(order.id),
                modifiedAt: order.modifiedAt
            ){ resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
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
                    
                    /// Order Detail Catch
                    acctMinCatch[self.order.id] = loadOrderResponse.account
                    orderCatch[self.order.id] = loadOrderResponse.order
                    notesCatch[self.order.id] = loadOrderResponse.notes
                    paymentsCatch[self.order.id] = loadOrderResponse.payments
                    chargesCatch[self.order.id] = loadOrderResponse.charges
                    pocsCatch[self.order.id] = loadOrderResponse.pocs
                    filesCatch[self.order.id] = loadOrderResponse.files
                    equipmentsCatch[self.order.id] = loadOrderResponse.equipments
                    rentalsCatch[self.order.id] = loadOrderResponse.rentals
                    if let transferOrder = loadOrderResponse.transferOrder {
                        transferOrderCatch[self.order.id] = transferOrder
                    }
                    if let route = loadOrderResponse.route {
                        custOrderRouteCatch[self.order.id] = route
                    }
                    
                    self.accountView.acctType = loadOrderResponse.account.type
                    self.accountView.cardId = loadOrderResponse.account.CardID
                    
                    self.order = loadOrderResponse.order
                    self.notes = loadOrderResponse.notes
                    self.payments = loadOrderResponse.payments
                    self.charges = loadOrderResponse.charges
                    self.pocs = loadOrderResponse.pocs
                    self.files = loadOrderResponse.files
                    self.equipments = loadOrderResponse.equipments
                    self.rentals = loadOrderResponse.rentals
                    self.transferOrder = loadOrderResponse.transferOrder
                    
                    self.parseOrderData()
                    
                }
                
            }
        }
        
        $pendingPickups.listen {
            print($0)
        }
        
        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            switch event {
            case .wsLocationUpdate:
                if let payload = self.ws.locationUpdate($0) {
                    if payload.order == self.order.id {
                        self.loadLocation(payload.lat, payload.lon)
                    }
                }
            case .asyncFileUpload:
                if let payload = self.ws.asyncFileUpload($0) {
                    
                    if let view = self.fileViewCatch[payload.eventid] {
                        
                        view.loadPercent = ""
                        
                        view.url = "https://\(custCatchUrl)/fileNet/\(payload.fileName)"
                        
                        view.custom("background-image", "url('\("https://\(custCatchUrl)/fileNet/\(payload.fileName)")')")
                        
                    }
                }
            case .asyncFileUpdate:
                if let payload = self.ws.asyncFileUpdate($0) {
                    
                    if let view = self.fileViewCatch[payload.eventId] {
                        
                        view.loadPercent = payload.message
                        
                    }
                }
            default:
                break
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        if !lat.isEmpty && !lon.isEmpty {
            loadLocation(lat, lon)
        }

    }
    
    func pickupEquipment(){
     
        if equipments.count > 1 {
            print("🗳️ Multiple Equipments")
            if pendingPickups == 1 {
                
                print("🗳️ pendingPickups 1")
                
                var equipment: CustOrderLoadFolioEquipments? = nil
                
                equipments.forEach { item in
                    if item.deliveredBy == nil {
                        equipment = item
                    }
                }
                
                guard let equipment else {
                    showError(.unexpectedResult, "Error 001 Contacta a Soporte TC")
                    return
                }
                
                pickupEquipment(equipment: equipment, force: false)
                
                return
                
            }
            
            let view = PickupEquipmentsView(
                equipmentPickedStatusRefrence: equipmentPickedStatusRefrence,
                equipments: equipments,
                accountid: self.order.custAcct,
                orderid: self.order.id,
                orderFolio: self.order.folio
            ) { equipment, callback in
                
                self.pickupEquipment(equipment: equipment, force: false)
                
            }
            
            addToDom(view)
            
        }
        else {
            
            print("🗳️ Single Equipments")
            
            guard let equipment = equipments.first else {
                return
            }
            
            pickupEquipment(equipment: equipment, force: false)
            
        }
        
    }
    
    func pickupEquipment(equipment: CustOrderLoadFolioEquipments, force: Bool) {
        
        var tt = 0
        
        equipments.forEach { eq in
            if eq.deliveredBy == nil {
                tt += 1
            }
        }
        
        /// Has reward progame and it not forced
        if let orderCloseInscriptionMode = configStoreProcessing.rewardsPrograme?.orderCloseInscriptionMode, !force {
            /// Last equipmet to pickUp
            
            if tt == 1 {
                
                switch orderCloseInscriptionMode {
                case .required, .recomended:
                    if self.accountView.cardId.isEmpty {
                        
                        if orderCloseInscriptionMode == .required {
                            showError(.errorGeneral, "Se requiere que incriba al cliente en el sistema de recompensas")
                        }
                        
                        self.addLoyaltyCard(isRequiered: orderCloseInscriptionMode == .required ){
                            self.pickupEquipment(equipment: equipment, force: true)
                        }
                        
                        return
                    }
                case .notrequired:
                    break
                case .optional:
                    break
                }
            }
        }
        
        guard let state = equipmentPickedStatusRefrence[equipment.id] else {
            return
        }
        
        loadingView(show: true)
        
        API.custOrderV1.equipmentPickedStatus(
            accountid: self.order.custAcct,
            orderid: self.order.id,
            orderFolio: self.order.folio,
            equipmentid: equipment.id,
            name: "\(equipment.tag1) \(equipment.tag2) \(equipment.tag3)",
            pickedUp: true
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
            
            state.wrappedValue = true
            
            var cc = 0
            
            equipmentsCatch[self.order.id]?.forEach({ eq in
                if eq.id  == equipment.id {
                    equipmentsCatch[self.order.id]![cc].deliveredBy = custCatchID
                }
                cc += 1
            })
            
            cc = 0
            self.equipments.forEach { eq in
                if eq.id  == equipment.id {
                    self.equipments[cc].deliveredBy = custCatchID
                }
                cc += 1
            }
        }
    }
    
    func addLoyaltyCard(isRequiered: Bool, callback: @escaping (() -> ()) ){
        
        guard self.accountView.acctType == .personal else {
            showError(.errorGeneral, "Lo sentimos las cuentas \(self.accountView.acctType.description) aun no es soportado.")
            return
        }
        
        let _callback = isRequiered ? nil : callback
        
        addToDom(AccountView.RequestSiweCard(
            accountId: self.order.custAcct,
            cc: .mexico,
            mobile: self.order.mobile,
            callback: { token, cardId, _ in
                
                self.smsTokens.append(token)
                
                addToDom(AccountView.ConfimeSiweCard(
                    custAcct: self.order.custAcct,
                    cc: .mexico,
                    mobile: self.order.mobile,
                    tokens: self.smsTokens,
                    cardId: cardId,
                    callback: { cardId in
                        
                        acctMinCatch[self.order.id]?.CardID = cardId
                        
                        self.accountView.cardId = cardId
                        
                        callback()
                        
                    }
                ))
                
            },
            bypassProgram: _callback
        ))
    }
    
    func printOrder(){

        if configStore.print.button == .direct {
            printOrderDirect()
        }
        else {
            
            let view = PrintPreView(order: self.order) {
                self.printOrderDirect()
            } sendDocument: {


                loadingView(show: true)

                API.custOrderV1.sendServiceOrder(orderId: self.order.id) { resp in

                    loadingView(show: false)

                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }

                    // TODO: ADD NOTE FROM PAYLOAD RESPONSE 

                    showSuccess(.operacionExitosa, "Recibo Enviado")

                }
            
            }

            addToDom(view)

        }

    }
    
    func printOrderDirect(){

        if configStore.print.document == .pdf {
            showSuccess(.operacionExitosa, "Descargando...")
            
            let url = printServiceOrder(orderid: self.order.id)
            
            _ = JSObject.global.goToURL!(url)
            
            return
        }
        
        let printBody = OrderPrintEngine(
            order: self.order,
            notes: self.notes,
            payments: self.payments,
            charges: self.charges,
            pocs: self.pocs,
            files: self.files,
            equipments: self.equipments,
            rentals:self.rentals,
            transferOrder: self.transferOrder
        ).innerHTML

        _ = JSObject.global.renderPrint!(
            custCatchUrl,
            self.order.folio,
            self.order.deepLinkCode,
            String(self.order.mobile.suffix(4)),
            printBody
        )

    }
    
    func parseOrderData(){
        
        inAlert = order.alerted
        
        isHighPriority = order.highPriority
        
        orderProject = order.project
        
        status = order.status
        
        budgetStatus = order.budget
        
        chargesTable.innerHTML = ""
        
        chargesRefrence.removeAll()
        
        total = 0
        chas = 0
        pays = 0
        
        charges.forEach { obj in
            
            let stotal = ((obj.price * obj.cuant) / 100)
            
            total += stotal
            chas += stotal
            
            let tr = OldChargeTrRow(
                isCharge: true,
                id: obj.id,
                name: obj.name,
                cuant: obj.cuant,
                price: obj.price,
                puerchaseOrder: false
            ) { viewId in
                
                self.editCharge(
                    viewId: viewId,
                    ids: [obj.id],
                    type: obj.type
                )
                
            }.color(.gray)
            
            chargesRefrence[tr.viewId] = tr
            
            chargesTable.appendChild (tr)
        }
        
        var pocsRefrence: [UUID: [Int64 : [CustPOCInventoryOrderView]]] = [:]
        
        pocs.forEach { obj in
            
            if let _ = pocsRefrence[obj.POC] {
                
                if let _ = pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)] {
                    pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)]?.append(obj)
                }
                else {
                    pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)] = [obj]
                }
                
            }
            else {
                pocsRefrence[obj.POC] = [(obj.soldPrice ?? 0) : [obj]]
            }
            
        }

        print("🟢  pocsRefrence")
        print("🟢  pocsRefrence")

        print(pocsRefrence)

        
        pocsRefrence.forEach { pocId, priceRefrence in
        
            priceRefrence.forEach { price, items in
            
                let soldPrice = price * items.count.toInt64
                
                total += soldPrice
                
                chas += soldPrice
                
                let tr = OldChargeTrRow(pocs: items) { viewId in
                    self.editPoc(viewId: viewId, ids: items.map{ $0.id })
                }
                    .color(.gray)
                
                chargesRefrence[tr.viewId] = tr
                
                chargesTable.appendChild(tr)
                
                
            }
            
            //let soldPrice = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +)
            
        }
        
        rentals.forEach { obj in
            
            total += obj.soldPrice
            
            chas += obj.soldPrice
            
            let tr = OldChargeTrRow(
                isCharge: true,
                id: obj.id,
                name: "\(obj.name.prefix(50)) \(obj.ecoNumber)",
                cuant: 100.toInt64,
                price: obj.soldPrice,
                puerchaseOrder: false
            ) { viewId in
                self.editRental(
                    viewId: viewId,
                    itemId: obj.id
                )
            }.color(.gray)
            
            chargesRefrence[tr.viewId] = tr
            
            chargesTable.appendChild (tr)
            
        }
        
        payments.forEach { obj in
            
            total -= obj.cost
            
            pays += obj.cost
            
            let tr = OldChargeTrRow(
                isCharge: false,
                id: obj.id,
                name: obj.description,
                cuant: 100.toInt64,
                price: obj.cost,
                puerchaseOrder: false
            ) { viewId in
                /// Payments cant be edited
                self.removePayment(
                    id: viewId,
                    name: obj.description,
                    amount: obj.cost
                )
            }.color(.gray)
            
            chargesRefrence[tr.viewId] = tr
            
            chargesTable.appendChild (tr)
            
        }
        
        self.filesGrid.innerHTML = ""
        
        files.forEach { file in
            
            let view = OrderImageView(
                id: file.id,
                name: file.file,
                url: "https://\(custCatchUrl)/fileNet/thump_\(file.avatar)"
            ) { id, name in
                
                addToDom(MediaViewer(
                    relid: self.order.id,
                    type: .orderFile,
                    url: "https://\(custCatchUrl)/fileNet/",
                    files: [
                        .init(
                            fileId: file.id,
                            file: file.file,
                            avatar: file.avatar,
                            type: file.type
                        )
                    ],
                    currentView: 0
                ){ //Delete callback
                    var files: [CustOrderLoadFolioFiles] = []
                    
                    self.files.forEach { parse in
                        if parse.id == file.id {
                            return
                        }
                        files.append(parse)
                    }
                    
                    self.files = files
                    
                    filesCatch[self.order.id] = self.files
                    
                    self.fileViewCatch.forEach { viewId, fileView in
                        
                        if fileView.id == id {
                            fileView.remove()
                        }
                        
                    }
                })
            }
            
            self.filesGrid.appendChild(view)
            
            self.fileViewCatch[view.viewId] = view
            
        }
        
        messageGrid.notes = notes
        
        messageGrid.loadMessages()
        
        equipmentViewRefrence.removeAll()
        equipmentView.innerHTML = ""
        
        self.pendingPickups = self.equipments.count
        
        switch order.type {
        case .folio:
            
            if equipments.count > 1 {
                /// currentEquipment
                
                let eqTabBtns = Div()
                    .height(35.px)
                
                let eqBody = Div()
                    .overflow(.auto)
                    .custom("height", "calc(100% - 40px)")
                
                equipments.forEach { eq in
                    
                    var count = 0
                    
                    var name = ""
                    
                    if !eq.tag1.isEmpty {
                        name = eq.tag1
                        count += 1
                    }
                    
                    if !eq.tag3.isEmpty {
                        name += " \(eq.tag3)"
                        count += 1
                    }
                    
                    if !eq.tag2.isEmpty {
                        name += " \(eq.tag2)"
                        count += 1
                    }
                    
                    if count < 3 && !eq.tag4.isEmpty{
                        name += " \(eq.tag4)"
                        count += 3
                    }
                    
                    eqTabBtns.appendChild(
                        
                        H2(name)
                            .backgroundColor(self.$currentEquipment.map{ ($0 == eq.id) ? .black : .transparent})
                            .borderTopRightRadius(12.px)
                            .borderTopLeftRadius(12.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .fontSize(18.px)
                            .color(.white)
                            .float(.left)
                            .onClick {
                                if self.currentEquipment == eq.id { return }
                                self.currentEquipment = eq.id
                            }
                        
                    )
                }
                
                equipments.forEach { eq in
                    
                    @State var isReady = false
                    
                    equipmentReadyStatusRefrence[eq.id] = $isReady
                    
                    @State var isPicked = false
                    
                    equipmentPickedStatusRefrence[eq.id] = $isPicked
                    
                    $isPicked.listen{
                        
                        print("🟡 pendingPickups \(self.pendingPickups)")
                        
                        print("🟢 State changed \($0.description)")
                        
                        if $0 {
                            self.pendingPickups -= 1
                        }
                        else {
                            self.pendingPickups += 1
                        }
                        
                        print("🟢 pendingPickups \(self.pendingPickups)")
                        
                    }
                    
                    let view = EquipmentView(
                        orderView: self,
                        status: $status,
                        isReady: $isReady,
                        isPicked: $isPicked,
                        equipment: eq,
                        hideControls: false
                    ).hidden($currentEquipment.map{$0 == eq.id ? false : true })
                    
                    equipmentViewRefrence[eq.id] = view
                    
                    eqBody.appendChild(view)
                    
                    
                }
                
                equipmentView.appendChild(eqTabBtns)
                equipmentView.appendChild(Div().class(.clear))
                equipmentView.appendChild(eqBody)
                
                currentEquipment = equipments.first?.id
            }
            else{
                
                if let eq = equipments.first {
                    
                    @State var isReady = false
                    
                    equipmentReadyStatusRefrence[eq.id] = $isReady
                    
                    @State var isPicked = false
                    
                    equipmentPickedStatusRefrence[eq.id] = $isPicked
                    
                    $isPicked.listen{
                        
                        print("🟡 pendingPickups \(self.pendingPickups)")
                        
                        print("🟢 State changed \($0.description)")
                        
                        if $0 {
                            self.pendingPickups -= 1
                        }
                        else {
                            self.pendingPickups += 1
                        }
                        
                        print("🟢 pendingPickups \(self.pendingPickups)")
                        
                    }
                    
                    let view = EquipmentView(
                        orderView: self,
                        status: $status,
                        isReady: $isReady,
                        isPicked: $isPicked,
                        equipment: eq,
                        hideControls: false
                    ).hidden($currentEquipment.map{$0 == eq.id ? false : true })
                    
                    equipmentViewRefrence[eq.id] = view
                    
                    equipmentView.appendChild(view)
                    
                    currentEquipment = eq.id
                    
                }
                
            }
            
        case .date:
            break
        case .sale:
            break
        case .rental:
            
            if rentals.count > 1 {
                /// currentEquipment
                let eqTabBtns = Div()
                    .height(35.px)
                
                let eqBody = Div()
                    .overflow(.auto)
                    .custom("height", "calc(100% - 40px)")
                
                self.rentals.forEach { rental in
                    eqTabBtns.appendChild(
                        Div(rental.ecoNumber)
                            .cursor(.pointer)
                            .float(.left)
                            .padding(all: 2.px)
                            .margin(all: 2.px)
                            .fontWeight($currentEquipment.map{$0 == rental.id ? .bolder : .normal})
                            .color($currentEquipment.map{$0 == rental.id ? .lightBlueText : .white})
                            .borderBottom(width: .thin, style: .solid, color: $currentEquipment.map{$0 == rental.id ? .lightBlueText : .transparent})
                            .onClick {
                                if self.currentEquipment == rental.id { return }
                                self.currentEquipment = rental.id
                            }
                    )
                }
                
                self.rentals.forEach { rental in
                    
                    let view = OrderRentalView(
                        orderView: self,
                        status: $status,
                        rental: rental,
                        hideControls: false
                    )
                        .hidden($currentEquipment.map{$0 == rental.id ? false : true })
                    
                    self.rentalViewRefrence[rental.id] = view
                    
                    eqBody.appendChild(view)
                }
                
                equipmentView.appendChild(eqTabBtns)
                equipmentView.appendChild(Div().class(.clear))
                equipmentView.appendChild(eqBody)
                
                currentEquipment = rentals.first?.id
                
            }
            else{
                if let rental = rentals.first {
                    
                    let view = OrderRentalView(
                        orderView: self,
                        status: $status,
                        rental: rental,
                        hideControls: false
                    ).hidden($currentEquipment.map{$0 == rental.id ? false : true })
                    
                    rentalViewRefrence[rental.id] = view
                    
                    equipmentView.appendChild(view)
                    
                    currentEquipment = rental.id
                    
                }
            }
            
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
        
        var _pendingPickups = 0
        
        equipments.forEach { equipment in
            
            print(equipment.deliveredBy)
            
            if equipment.deliveredBy == nil {
                _pendingPickups += 1
            }
        }
        
        self.pendingPickups = _pendingPickups
        
        onWorkUser = order.workedBy
        
        orderName = order.name
        mobile = order.mobile
        telephone = order.telephone
        email = order.email
        
        street = order.street
        colony = order.colony
        city = order.city
        state = order.state
        country = order.country
        zip = order.zip
        
        lat = order.lat
        
        lon = order.lon
        
        contratc = order.contract
        
        requierServiceAddress = configContactTags.requierServiceAddress
        
        var createAtDivColor: Color = .gray
        
        switch orderTimeMesure(uts: order.createdAt, type: .createdAt).color {
        case .blue:
            break
        case .green:
            createAtDivColor = .green
        case .orange:
            createAtDivColor = .orange
        case .red:
            createAtDivColor = .red
        }
        
        self.createAtDiv = Div(getDate(order.createdAt).formatedLong)
            .color(createAtDivColor)
        
        dueDate = order.dueDate
        
        lastCommunicationMethod = order.lastCommunicationMethod
        
        calcBalance()
        
        messageGrid.isPopup = true
        
        messageGrid.maximizeMsgView.onClick {
            self.messageGrid.isPopup = false
            
            var messageViewPopup = Div()
            
            messageViewPopup = Div{
                Div{
                    
                    Img()
                        .closeButton(.uiView1)
                        .onClick{
                            self.messageGrid.isPopup = true
                            
                            self.messageGridDiv.appendChild( self.messageGrid )
                            
                            _ = JSObject.global.scrollToBottom!("message_grid_\(self.messageGrid.orderid.uuidString.lowercased())")
                            
                            messageViewPopup.remove()
                            
                        }
                    
                    H1("Enviar Comentario")
                        .color(.lightBlueText)
                    
                    Div()
                        .class(.clear)
                    
                    Div{
                        self.messageGrid
                    }
                    .custom("height", "calc(100% - 45px)")
                    
                }
                    .padding(all: 12.px)
                    .width(50.percent)
                    .height(80.percent)
                    .position(.absolute)
                    .left(25.percent)
                    .top(10.percent)
                    .backgroundColor(.grayBlack)
                    .borderRadius(all: 24.px)
            }
            .class(.transparantBlackBackGround)
            .height(100.percent)
            .position(.absolute)
            .width(100.percent)
            .top(0.px)
            .left(0.px)
            .onClick { clic, event in
                event.stopPropagation()
            }
            
            addToDom(messageViewPopup)
            
            self.messageGrid.messageInput.select()
            
            _ = JSObject.global.scrollToBottom!("message_grid_\(self.messageGrid.orderid.uuidString.lowercased())")
            
        }
        
        fiscalView.innerHTML = ""
        
        if let fiscaldoc = order.fiscalDocumentID {
            
            fiscalView.appendChild(Div{
                Img()
                    .src("/skyline/media/attachment.png")
                    .height(24.px)
                    .marginRight(7.px)
                
                Span("Factura")
                    .fontSize(24.px)
            }
            .class(.uibtn)
            .onClick {
                
                loadingView(show: true)

                API.fiscalV1.loadDocument(docid: fiscaldoc) { resp in

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
                        showError(.unexpectedResult, "No se obtuvo payload de data.")
                        return
                    }

                    let view = ToolFiscalViewDocument(
                        type: payload.type,
                        doc: payload.doc,
                        reldocs: payload.reldocs,
                        account: payload.account
                    ) {
                        /// Document canceled
                        
                        self.fiscalView.innerHTML = ""
                        
                        self.fiscalView.appendChild(Div{
                            Img()
                                .src("/skyline/media/money_bag.png")
                                .height(24.px)
                                .marginRight(7.px)
                            
                            Span("Facturar")
                                .fontSize(24.px)
                        }
                            .marginLeft(0)
                            .class(.uibtn)
                            .onClick {
                                self.facturar()
                            })
                        
                    }
                    
                    addToDom(view)

                }
            
            })
            
        }
        else{
            fiscalView.appendChild(Div{
                Img()
                    .src("/skyline/media/money_bag.png")
                    .height(24.px)
                    .marginRight(7.px)
                
                Span("Facturar")
                    .fontSize(24.px)
            }
            .class(.uibtn)
            .marginLeft(0)
            .onClick {
                self.facturar()
            })
        }
        
        orderHighPriorityNote.forEach { note in
            
            if accountView.shownHighPriorityNotes.contains(note.id) {
                return
            }
            
            accountView.shownHighPriorityNotes.append(note.id)
            
            Dispatch.asyncAfter(0.5) {
                addToDom(ViewHighPriorityNote(
                    type: .order,
                    note: note,
                    folio: self.order.folio,
                    name: self.order.name
                ))
            }
        }
        
        accountHighPriorityNote.forEach { note in
            
            if accountView.shownHighPriorityNotes.contains(note.id) {
                return
            }
            
            accountView.shownHighPriorityNotes.append(note.id)
            
            Dispatch.asyncAfter(0.5) {
                addToDom(ViewHighPriorityNote(
                    type: .account,
                    note: note,
                    folio: self.accountView.account?.folio,
                    name: self.accountView.account?.firstName
                ))
            }
        }
        
    }
    
/*
        /// POC Data
        _ poc: CustPOC,
        _ cost: Int64,
        _ costType: CustAcctCostTypes,
        _ units: Int64,
        _ items: [CustPOCInventoryMin],
        _ storeid: UUID,
        _ isWarenty: Bool,
        _ internalWarenty: Bool?,
        _ generateRepositionOrder: Bool?,
        _ soldObjectFrom: SoldObjectFrom
*/

    func addCharge() {

        var socIds: [UUID] = []
        
        self.charges.forEach { charge in
            
            guard charge.type == .service else {
                return
            }
            
            guard let id = charge.codeid else {
                return
            }
            
            socIds.append(id)
        }
        
        let addChargeFormView = AddChargeFormView(
            accountId: self.order.custAcct,
            allowManualCharges: true,
            allowWarrantyCharges: true,
            socCanLoadAction: true,
            costType: self.accountView.account?.costType ?? .cost_a, 
            currentSOCMasters: socIds
        ){ id, isWarenty, internalWarenty in
            
            let view = ConfirmProductView(
                accountId: self.order.custAcct,
                costType: .cost_a,
                pocid: id,
                selectedInventoryIDs: [],
                blockPurchaseOrders: false,
                isWarenty: isWarenty,
                internalWarenty: internalWarenty
            ) { poc, price, costType, units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder, soldObjectFrom in
                
                /// internal, external
                var warenty: SoldObjectWarenty? = nil

                if isWarenty, let internalWarenty {
                    warenty = internalWarenty ? .internal : .external
                }

                guard let storeid = self.order.store else {
                    showError(.errorGeneral, "No se localizo tenda para venta")
                    return
                }

                loadingView(show: true)
                                                
                API.custOrderV1.addCharge(
                    orderId: self.order.id,
                    item: .product(.init(
                        description: "\(poc.upc) \(poc.name) \(poc.model)".purgeSpaces,
                        pocId: poc.id,
                        from: soldObjectFrom,
                        units: .units(items.count),
                        price: price,
                        warenty: warenty
                    ))
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
                    
                    var pocs:[CustPOCInventoryOrderView] = []
                    
                    items.forEach { item in
                        pocs.append(.init(
                            id: item.id,
                            POC: poc.id,
                            soldType: .order,
                            custStore: storeid,
                            custStoreBodegas: item.custStoreBodegas,
                            custStoreSecciones: item.custStoreSecciones,
                            comision: 0,
                            points: 0,
                            premierPoints: 0,
                            series: item.series,
                            warentSelfTo: nil,
                            warentFabricTo: nil,
                            soldPrice: price,
                            name: poc.name,
                            brand: poc.brand,
                            model: poc.model,
                            status: .sold
                        ))
                    }
                    
                    let tr = OldChargeTrRow(pocs: pocs) { viewId in
                        self.editPoc(viewId: viewId, ids: items.map{ $0.id })
                    }
                        .color(.gray)
                    
                    self.chargesRefrence[tr.viewId] = tr
                    
                    self.chargesTable.appendChild(tr)
                
                    items.forEach { item in
                        
                        let obj: CustPOCInventoryOrderView = .init(
                            id: item.id,
                            POC: poc.id,
                            soldType: .order,
                            custStore: storeid,
                            custStoreBodegas: item.custStoreBodegas,
                            custStoreSecciones: item.custStoreSecciones,
                            comision: 0,
                            points: 0,
                            premierPoints: 0,
                            series: item.series,
                            warentSelfTo: nil,
                            warentFabricTo: nil,
                            soldPrice: price,
                            name: poc.name,
                            brand: poc.brand,
                            model: poc.model, 
                            status: .sold
                        )
                        
                        pocsCatch[self.order.id]?.append(obj)
                        
                        self.pocs.append(obj)
                        
                    }
                    
                    if items.isEmpty {
                        showSuccess(.operacionExitosa, "Producto agregado, refreque el folio para ver los cambios")
                    }
                    
                    self.calcBalance()
                    
                }
            

            }
            
            self.appendChild(view)
            
        }
        addSoc: { soc, codeType, isWarenty, internalWarenty in
            
            //service, product, manual, payment
            var type: API.custOrderV1.AddChargeType = .manual(.init(
                fiscCode: soc.fiscCode,
                fiscUnit: soc.fiscUnit,
                description: soc.description,
                units: soc.units.fromCents.toInt,
                price: soc.price,
                cost: soc.cost
            ))
            
            if let socId = soc.id {
                //showAlert(.alerta, "Contacte a Soporte TC ya que el protocolo completo aun no es soportado.")
                type = .service(.init(
                    id: socId,
                    units: soc.units.fromCents.toInt,
                    price: soc.price
                ))

            }
            
            loadingView(show: true)
            
            API.custOrderV1.addCharge(
                    orderId: self.order.id,
                    item: type
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

                guard let id = resp.id else {
                    showError(.errorGeneral, "No se pudo obtenr id del producto")
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                var price = soc.price
                
                if codeType == .adjustment{
                    price = (price * -1)
                }
                
                    let tr = OldChargeTrRow(
                        isCharge: true,
                        id: id,
                        name: soc.description,
                        cuant: 100,
                        price: price,
                        puerchaseOrder: false
                    ) { viewId in
                        
                        self.editCharge(
                        viewId: viewId,
                        ids: [id],
                        type: (soc.id == nil) ? .manual : .service
                        )
                        
                    }.color(.gray)
                    
                self.chargesRefrence[tr.viewId] = tr
                    
                self.chargesTable.appendChild (tr)
                    
                let obj: CustOrderLoadFolioCharges = .init(
                    id: id,
                    codeid: soc.id,
                    type: (soc.id == nil) ? .manual : .service,
                    name: soc.description,
                    cuant: soc.units,
                    price: price,
                    status: .unbilled
                )
                
                chargesCatch[self.order.id]?.append(obj)
                
                self.charges.append(obj)
                
                self.calcBalance()
                
                payload.addedEfects.forEach { efect in
                    
                    switch efect {
                    case .mediaContatacLocation:
                        break
                    case .highPriority:
                        OrderCatchControler.shared.updateParameter(self.order.id, .hightPriorityStatus(true))
                        self.order.highPriority = true
                        self.isHighPriority = true
                    }
                    
                }
            }
            
        }
        addItem: { item, warenty in

            loadingView(show: true)

            API.custAPIV1.pocInventoryDetails(
                id: item.i
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
                    showError( .unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                loadingView(show: true)

                let view = ConfirmProductItemView(
                    poc: item,
                    item: payload.prod,
                    warenty: warenty
                ) { item in
                    
                    API.custOrderV1.addCharge(
                        orderId: self.order.id,
                        item: .product(item)
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
                            showError( .unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }

                    }

                }

                addToDom(view)
                           
            }
        }
        self.appendChild(addChargeFormView)
        
        addChargeFormView.searchTermInput.select()
        
    }


    // MARK: Charges Modification
    func removeCharge(viewId: UUID, id: UUID, name: String, amount: Int64) {
        self.appendChild(
            ConfirmView(
                type: .yesNo,
                title: "Eliminar Cargo",
                message: "Confirme eliminacion de:\n\(name) $\(amount.formatMoney)",
                callback: { confirmed, _ in
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.removeCharge(
                        orderId: self.order.id,
                        orderFolio: self.order.folio,
                        chargeId: id
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok  else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }

                        guard let payload = resp.data else {
                            showError(.unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }
                        
                        if !payload.auth {
                            showAlert(.alerta, "Se ha solicitado remover el cargo")
                        }
                        
                        var _charges: [CustOrderLoadFolioCharges] = []
                        
                        if let tr = self.chargesRefrence[id] {
                            tr.remove()
                            self.chargesRefrence.removeValue(forKey: id)
                        }
                        
                        self.charges.forEach { obj in
                            if obj.id == id {
                                return
                            }
                            _charges.append(obj)
                        }
                        
                        self.charges = _charges
                        
                        chargesCatch[self.order.id] = _charges
                        
                        self.calcBalance()
                        
                        payload.removedEfects.forEach { efect in
                            
                            switch efect {
                            case .mediaContatacLocation:
                                break
                            case .highPriority:
                                OrderCatchControler.shared.updateParameter(self.order.id, .hightPriorityStatus(false))
                                self.order.highPriority = false
                                self.isHighPriority = false
                                
                            }
                            
                        }
                        
                        guard let view = self.chargesRefrence[viewId] else {
                            showError(.errorGeneral, "No localizo cargo a remover")
                            return
                        }
                        
                        view.remove()
                        
                    }
                })
        )
    }
    
    func editCharge(viewId: UUID, ids: [UUID], type: ChargeType) {
        
        self.appendChild(EditChargePOCView(
            type: type,
            viewId: viewId,
            ids: ids,
            orderId: self.order.id,
            callback: { ids, units, cost, price, name, fiscCode, fiscUnit in
                
                var _charges: [CustOrderLoadFolioCharges] = []
                
                self.charges.forEach { obj in
                    
                    if ids.contains(obj.id) {
                        
                        _charges.append(
                            .init(
                                id: obj.id,
                                codeid: obj.codeid,
                                type: obj.type,
                                name: name,
                                cuant: units,
                                price: price,
                                status: obj.status
                            )
                        )
                        
                        return
                    }
                    
                    _charges.append(obj)
                    
                }
                
                self.charges = _charges

                chargesCatch[self.order.id] = _charges
                
                self.calcBalance()
                
                self.chargesRefrence[viewId]?.name = name
                self.chargesRefrence[viewId]?.cuantString = units.formatMoney
                self.chargesRefrence[viewId]?.priceString = price.formatMoney
                self.chargesRefrence[viewId]?.total = price.formatMoney
                
            },
            delete: { ids, name, amount in
                
                guard let id = ids.first else {
                    return
                }
                
                self.removeCharge(
                    viewId: viewId,
                    id: id,
                    name: name,
                    amount: amount
                )
            }
        ))
    }
    
    // MARK: POCs Modification
    func removePoc(viewId: UUID, ids: [UUID], name: String, amount: Int64) {
        self.appendChild(
            ConfirmView(
                type: .yesNo,
                title: "Eliminar Producto",
                message: "Confirme eliminacion de:\n\(name) $\(amount.formatMoney)",
                callback: { confirmed, _ in
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.removePoc(
                        orderId: self.order.id,
                        orderFolio: self.order.folio,
                        ids: ids
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok  else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }

                        var _pocs: [CustPOCInventoryOrderView] = []
                        
                        if let tr = self.chargesRefrence[viewId] {
                            tr.remove()
                            self.chargesRefrence.removeValue(forKey: viewId)
                        }
                        
                        self.pocs.forEach { obj in
                            
                            if ids.contains(obj.id) {
                                return
                            }
                            _pocs.append(obj)
                        }
                        
                        self.pocs = _pocs
                        
                        pocsCatch[self.order.id] = _pocs
                        
                        self.calcBalance()
                        
                    }
                })
        )
    }
    
    func editPoc(viewId: UUID, ids: [UUID]) {
        
        self.appendChild(EditChargePOCView(
            type: .product,
            viewId: viewId,
            ids: ids,
            orderId: self.order.id,
            callback: { id, _ , _, price, name, _, _ in
                
                var _pocs: [CustPOCInventoryOrderView] = []
                
                self.pocs.forEach { obj in
                    
                    if ids.contains(obj.id) {
                        _pocs.append(
                            .init(
                                id: obj.id,
                                POC: obj.POC,
                                soldType: obj.soldType,
                                custStore: obj.custStore,
                                custStoreBodegas: obj.custStoreBodegas,
                                custStoreSecciones: obj.custStoreSecciones,
                                comision: obj.comision,
                                points: obj.points,
                                premierPoints: obj.premierPoints,
                                series: obj.series,
                                warentSelfTo: obj.warentSelfTo,
                                warentFabricTo: obj.warentFabricTo,
                                soldPrice: price,
                                name: name,
                                brand: obj.brand,
                                model: obj.model,
                                status: obj.status
                            )
                        )
                        return
                    }
                    
                    _pocs.append(obj)
                    
                }
                
                self.pocs = _pocs
                
                pocsCatch[self.order.id] = _pocs
                
                self.calcBalance()
                
                self.chargesRefrence[viewId]?.name = name
                self.chargesRefrence[viewId]?.priceString = price.formatMoney
                self.chargesRefrence[viewId]?.total = price.formatMoney
            },
            delete: { ids, name, price in
                self.removePoc(
                    viewId: viewId,
                    ids: ids,
                    name: name,
                    amount: price
                )
            }
        ))
    }
    
    func removeRental(id: UUID, name: String, amount: Int64) {
        self.appendChild(
            ConfirmView(
                type: .yesNo,
                title: "Eliminar Cargo de Renta",
                message: "Confirme eliminacion de:\n\(name) $\(amount.formatMoney)",
                callback: { confirmed, _ in
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.removeRental(
                        orderId: self.order.id,
                        orderFolio: self.order.folio,
                        itemId: id
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok  else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }

                        var _rentals: [CustPOCRentalsMin] = []
                        
                        if let tr = self.chargesRefrence[id] {
                            tr.remove()
                            self.chargesRefrence.removeValue(forKey: id)
                        }
                        
                        self.rentals.forEach { obj in
                            if obj.id == id {
                                return
                            }
                            _rentals.append(obj)
                        }
                        
                        self.rentals = _rentals
                        
                        rentalsCatch[self.order.id] = _rentals
                        
                        self.calcBalance()
                        
                    }
                    
                })
        )
    }
    
    func editRental(viewId: UUID, itemId: UUID) {
        /*
        self.appendChild(EditChargePOCView(
            type: .rental,
            viewId: viewId,
            ids: [itemId],
            orderId: self.order.id,
            callback: { viewId, _, cost, price, name, fiscCode, fiscUnit in
                
                guard let view = self.chargesRefrence[viewId] else {
                    showError(.errorGeneral, "No localizo cargo a remover")
                    return
                }
                
                guard let id = view.id else {
                    showError(.errorGeneral, "No localizo id cargo a remover")
                    return
                }
                
                var _rentals: [CustPOCRentalsMin] = []
                
                self.rentals.forEach { obj in
                    if obj.id == id {
                        _rentals.append(
                            .init(
                                id: id,
                                startAt: obj.startAt,
                                endAt: obj.endAt,
                                workedBy: obj.workedBy,
                                deliveredBy: obj.deliveredBy,
                                custPOCRental: obj.custPOCRental,
                                custPOCRentalInventory: obj.custPOCRentalInventory,
                                name: name,
                                description: obj.description,
                                ecoNumber: obj.ecoNumber,
                                soldPrice: price,
                                deliveryType: obj.deliveryType,
                                deliveryId: obj.deliveryId,
                                status: obj.status
                            )
                        )
                        return
                    }
                    _rentals.append(obj)
                }
                
                self.rentals = _rentals
                
                rentalsCatch[self.order.id] = _rentals
                
                self.calcBalance()
                
                self.chargesRefrence[id]?.name = name
                self.chargesRefrence[id]?.priceString = price.formatMoney
                self.chargesRefrence[id]?.total = price.formatMoney
                
            },
            delete: { id, name, price in
                
                self.removeRental(id: id, name: name, amount: price)
                
            }
        ))
         */
    }
    
    func removePayment(id: UUID, name: String, amount: Int64) {
        
        guard let view = chargesRefrence[id] else {
            showError(.errorGeneral, "No localizo cargo a remover")
            return
        }
        
        guard let id = view.id else {
            showError(.errorGeneral, "No localizo id cargo a remover")
            return
        }
        
        self.appendChild(
            ConfirmView(
                type: .yesNo,
                title: "Eliminar Pago",
                message: "Confirme eliminacion de:\n\(name) $\(amount.formatMoney)",
                callback: { confirmed, _ in
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.removePayment(
                        orderId: self.order.id,
                        orderFolio: self.order.folio,
                        paymentId: id
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok  else {
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        var _payments: [CustOrderLoadFolioPayments] = []
                        
                        if let tr = self.chargesRefrence[view.viewId] {
                            tr.remove()
                            self.chargesRefrence.removeValue(forKey: view.viewId)
                        }
                        
                        self.payments.forEach { obj in
                            if obj.id == id {
                                return
                            }
                            _payments.append(obj)
                        }
                        
                        self.payments = _payments
                        
                        paymentsCatch[self.order.id] = _payments
                        
                        self.calcBalance()
                    }
                    
                })
        )
    }
    
    func calcBalance(){
        
        total = 0
        pays = 0
        chas = 0
        
        charges.forEach { obj in
            total += ((obj.price * obj.cuant) / 100)
            chas += ((obj.price * obj.cuant) / 100)
        }
        
        pocs.forEach { obj in
            total += (obj.soldPrice ?? 0)
            chas += (obj.soldPrice ?? 0)
        }
        
        rentals.forEach { obj in
            total += obj.soldPrice
            chas += obj.soldPrice
        }
        
        payments.forEach { obj in
            total -= obj.cost
            pays += obj.cost
        }
        
        self.tpays = pays.formatMoney
        self.tchars = chas.formatMoney
        self.ttotal = total.formatMoney
        
    }
    
    func orderDate(){
    
        let invalidStatus: [CustFolioStatus] = [
            .canceled,
            .finalize,
            .collection,
            .archive
        ]
        
        if invalidStatus.contains(self.order.status) {
            return
        }
        
        var selectedDateStamp = ""
        
        if let due = self.order.dueDate {
            let uts = getDate(due)
            selectedDateStamp = "\(uts.year)/\(uts.month)/\(uts.day)"
        }
        
        self.appendChild(
            
            SelectCalendarDate(
                type: .folio,
                selectedDateStamp: selectedDateStamp,
                currentSelectedDates: []
            ) { _, uts, _ in
                
                loadingView(show: true)
                
                API.custOrderV1.update(
                    orderid: self.order.id,
                    uts: Int64(uts),
                    sendComm: true,
                    lastCommunicationMethod: nil) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        guard resp.status == .ok else{
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        showSuccess(.operacionExitosa, "Cita Actualizada")
                        
                        self.order.dueDate = Int64(uts)
                        
                        self.dueDate = Int64(uts)

                        if let _ = orderCatch[self.order.id] {
                            orderCatch[self.order.id]!.dueDate = Int64(uts)
                        }
                    }
            }
        )
        
    }
    
    func saveOrderDetails(){
        
        if self.orderName.isEmpty {
            showError(.errorGeneral, .requierdValid("nombre"))
            return
        }
        
        if self.mobile.isEmpty {
            showError(.errorGeneral, .requierdValid("movil"))
            return
        }
        
        let (isValid, reason) = isValidPhone(self.mobile)
        
        if !isValid {
            showError(.formatoInvalido, reason)
            return
        }
        
        if !self.telephone.isEmpty {
            let (isValid, reason) = isValidPhone(self.telephone)
            if !isValid {
                showError(.formatoInvalido, reason)
                return
            }
        }
        
        if !self.email.isEmpty {
            if !isValidEmail(self.email) {
                showError(.formatoInvalido, "Ingrese un correo valido")
                return
            }
        }
        
        loadingView(show: false)
        
        API.custOrderV1.saveOrderDetail(
            orderid: self.order.id,
            name: self.orderName,
            mobile: self.mobile,
            telephone: self.telephone,
            email: self.email,
            street: self.street,
            colony: self.colony,
            city: self.city,
            state: self.state,
            country: self.country,
            zip: self.zip
        ) { resp in
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }

            self.editMode = false
            showSuccess(.operacionExitosa, "Datos Actulizados")
            
            if let _ = orderCatch[self.order.id] {
                self.order.name = self.orderName
                orderCatch[self.order.id]!.name = self.orderName
                
                self.order.mobile = self.mobile
                orderCatch[self.order.id]!.mobile = self.mobile
                
                self.order.telephone = self.telephone
                orderCatch[self.order.id]!.telephone = self.telephone
                
                self.order.email = self.email
                orderCatch[self.order.id]!.email = self.email
                
                self.order.street = self.street
                orderCatch[self.order.id]!.street = self.street
                
                self.order.colony = self.colony
                orderCatch[self.order.id]!.colony = self.colony
                
                self.order.city = self.city
                orderCatch[self.order.id]!.city = self.city
                
                self.order.state = self.state
                orderCatch[self.order.id]!.state = self.state
                
                self.order.country = self.country
                orderCatch[self.order.id]!.country = self.country
                
                self.order.zip = self.zip
                orderCatch[self.order.id]!.zip = self.zip
            }
            
        }
    }
    
    func finilizeOrder(){
        
        let equipments: [API.custOrderV1.FinalizeEquipment] = self.equipments.map {
            .init(
                id: $0.id,
                description: "\($0.tag1) \($0.tag2) \($0.tag3)".purgeSpaces,
                status: $0.status,
                workedBy: $0.workedBy,
                deliveredBy: $0.deliveredBy
            )
        }
        
        let rentals: [API.custOrderV1.RentalEquipment] = self.rentals.map {
            .init(
                id: $0.id,
                custPOCRental: $0.custPOCRental,
                name: $0.name,
                description: $0.description,
                ecoNumber: $0.ecoNumber,
                workedBy: $0.workedBy,
                deliveredBy: $0.deliveredBy
            )
        }
        
        loadingView(show: true)
        
        API.custOrderV1.finalize(
            orderid: self.order.id,
            equipments: equipments,
            rentals: rentals, 
            sendComm: true,
            lastCommunicationMethod: lastCommunicationMethod
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

            guard let data = resp.data else  {
                showError(.errorGeneral, "Un expected missing payload")
                return
            }

            self.status = data.status
            
            orderCatch[self.order.id]?.status = data.status
            orderCatch[self.order.id]?.modifiedAt = data.modifiedAt
            equipmentsCatch[self.order.id] = self.equipments
            rentalsCatch[self.order.id] = self.rentals
            notesCatch[self.order.id]?.append(contentsOf: data.notes)
            
            if data.sentToCredit {
                // TODO: no se que XD
            }
            
        }
    }
    
    func cancelOrder(){
    
        let equipments: [API.custOrderV1.FinalizeEquipment] = self.equipments.map {
            .init(
                id: $0.id,
                description: "\($0.tag1) \($0.tag2) \($0.tag3)".purgeSpaces,
                status: $0.status,
                workedBy: $0.workedBy,
                deliveredBy: $0.deliveredBy
            )
        }
        
        let rentals: [API.custOrderV1.RentalEquipment] = self.rentals.map {
            .init(
                id: $0.id,
                custPOCRental: $0.custPOCRental,
                name: $0.name,
                description: $0.description,
                ecoNumber: $0.ecoNumber,
                workedBy: $0.workedBy,
                deliveredBy: $0.deliveredBy
            )
        }
        
        loadingView(show: true)
        
        API.custOrderV1.cancel(orderid: self.order.id, equipments: equipments, rentals: rentals, sendComm: true, lastCommunicationMethod: lastCommunicationMethod) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
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
            
            self.status  = .finalize
            
            orderCatch[self.order.id]?.status = .finalize
            orderCatch[self.order.id]?.modifiedAt = data.modifiedAt
            equipmentsCatch[self.order.id] = self.equipments
            rentalsCatch[self.order.id] = self.rentals
            notesCatch[self.order.id]?.append(contentsOf: data.notes)
            
            if data.sentToCredit {
                // TODO: no se que XD
            }
            
        }
        
    }
    
    func finilizeOrderService(_ pendingPickup: Bool){
        
    }
    
    func finilizeOrderRental(_ pendingPickup: Bool, rentals: [CustPOCRentalsMin], orderView: OrderView){
        
    }
    
    func initiateOrderCancelation(){
        switch self.order.type {
        case .folio:
            
            self.appendChild(CancelationConfirmView( type: self.order.type, rentals: self.rentals, equipments: self.equipments){ rentals, equipments in
                
                self.equipments = equipments
                
                equipments.forEach { eq in
                    
                    self.equipmentViewRefrence[eq.id]?.workedBy = eq.workedBy
                    if let _ = eq.workedBy {
                        self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = true
                        self.equipmentReadyStatusRefrence[eq.id]?.wrappedValue = true
                    }
                    else{
                        self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = false
                        self.equipmentReadyStatusRefrence[eq.id]?.wrappedValue = false
                    }
                    
                    self.equipmentViewRefrence[eq.id]?.deliveredBy = eq.deliveredBy
                    if let _ = eq.deliveredBy {
                        self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = true
                        self.equipmentPickedStatusRefrence[eq.id]?.wrappedValue = true
                    }
                    else{
                        self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = false
                        self.equipmentPickedStatusRefrence[eq.id]?.wrappedValue = false
                    }
                    
                }
                
                self.cancelOrder()
            })
        case .date:
            break
        case .sale:
            break
        case .rental:
            
            self.appendChild(CancelationConfirmView( type: self.order.type, rentals: self.rentals, equipments: self.equipments){ rentals, equipments in
                
                self.rentals = rentals
                
                rentals.forEach { rental in
                    
                    self.rentalViewRefrence[rental.id]?.workedBy = rental.workedBy
                    if let _ = rental.workedBy {
                        self.rentalViewRefrence[rental.id]?.isReady = true
                    }
                    else{
                        self.rentalViewRefrence[rental.id]?.isReady = false
                    }
                    
                    self.rentalViewRefrence[rental.id]?.deliveredBy = rental.deliveredBy
                    if let _ = rental.deliveredBy {
                        self.rentalViewRefrence[rental.id]?.$isPicked.wrappedValue = true
                    }
                    else{
                        self.rentalViewRefrence[rental.id]?.$isPicked.wrappedValue = false
                    }
                    
                }
                
                self.cancelOrder()
            })
            
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
    }
    
    /// This function will evaluate what type of an order we are dealing with and if has multiple elements (equipments, retals, items, etc...) and use a direct confirmation of multiple object view.
    func initiateOrderFinalization(force: Bool, equipments: [CustOrderLoadFolioEquipments]? = nil, rentals: [CustPOCRentalsMin]? = nil){
        
        print("🐼 001")
        
        if let equipments {
            
            self.equipments = equipments
            
            equipments.forEach { eq in
                
                self.equipmentViewRefrence[eq.id]?.workedBy = eq.workedBy
                if let _ = eq.workedBy {
                    self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = true
                }
                else{
                    self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = false
                }
                
                self.equipmentViewRefrence[eq.id]?.deliveredBy = eq.deliveredBy
                if let _ = eq.deliveredBy {
                    self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = true
                }
                else{
                    self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = false
                }
                
            }
            
            self.finilizeOrder()
            
            return
        }
        print("🐼 002")
        
        print(self.order.type.rawValue)
        
        switch self.order.type {
        case .folio:
        
            print("🐼 003")
            
            self.appendChild(FinalizeConfirmView(
                type: self.order.type,
                rentals: self.rentals,
                equipments: self.equipments
            ){ rentals, equipments in
                
                var pickedUp = true
                
                /// Parcong to find final picked up state
                equipments.forEach { eq in
                    if eq.deliveredBy == nil {
                        pickedUp = false
                    }
                }
                
                if pickedUp && self.accountView.acctType == .personal {
                    
                    if let orderCloseInscriptionMode = configStoreProcessing.rewardsPrograme?.orderCloseInscriptionMode {
                        
                        print("⭐️ orderCloseInscriptionMode: \(orderCloseInscriptionMode.description)")
                        
                        switch orderCloseInscriptionMode {
                        case .required, .recomended:
                            if self.accountView.cardId.isEmpty {
                                
                                if orderCloseInscriptionMode == .required {
                                    showError(.errorGeneral, "Se requiere que incriba al cliente en el sistema de recompensas")
                                }
                                
                                self.addLoyaltyCard(isRequiered: orderCloseInscriptionMode == .required) {
                                    self.initiateOrderFinalization(force: true, equipments: equipments, rentals: rentals)
                                }
                                
                                return
                            }
                        case .notrequired:
                            break
                        case .optional:
                            break
                        }
                        
                    }
                    
                }
                
                self.equipments = equipments
                
                equipments.forEach { eq in
                    
                    self.equipmentViewRefrence[eq.id]?.workedBy = eq.workedBy
                    if let _ = eq.workedBy {
                        self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = true
                    }
                    else{
                        self.equipmentViewRefrence[eq.id]?.isReady.wrappedValue = false
                    }
                    
                    self.equipmentViewRefrence[eq.id]?.deliveredBy = eq.deliveredBy
                    if let _ = eq.deliveredBy {
                        self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = true
                    }
                    else{
                        self.equipmentViewRefrence[eq.id]?.isPicked.wrappedValue = false
                    }
                    
                }
                
                self.finilizeOrder()
                
            })
            
        case .date:
            break
        case .sale:
            
            self.finilizeOrder()
            
        case .rental:
            
            self.appendChild(FinalizeConfirmView( type: self.order.type, rentals: self.rentals, equipments: self.equipments){ rentals, equipments in
                
                var pickedUp = true
                
                self.rentals = rentals
                
                rentals.forEach { rental in
                    
                    self.rentalViewRefrence[rental.id]?.workedBy = rental.workedBy
                    if let _ = rental.workedBy {
                        self.rentalViewRefrence[rental.id]?.isReady = true
                    }
                    else{
                        self.rentalViewRefrence[rental.id]?.isReady = false
                    }
                    
                    self.rentalViewRefrence[rental.id]?.deliveredBy = rental.deliveredBy
                    if let _ = rental.deliveredBy {
                        self.rentalViewRefrence[rental.id]?.$isPicked.wrappedValue = true
                    }
                    else{
                        self.rentalViewRefrence[rental.id]?.$isPicked.wrappedValue = false
                        pickedUp = false
                    }
                    
                }
                
                if pickedUp {
                    
                    if let orderCloseInscriptionMode = configStoreProcessing.rewardsPrograme?.orderCloseInscriptionMode {
                        
                        switch orderCloseInscriptionMode {
                        case .required, .recomended:
                            if self.accountView.cardId.isEmpty {
                                
                                if orderCloseInscriptionMode == .required {
                                    showError(.errorGeneral, "Se requiere que incriba al cliente en el sistema de recompensas")
                                }
                                
                                self.addLoyaltyCard( isRequiered: orderCloseInscriptionMode == .required){
                                    self.finilizeOrder()
                                }
                                
                                return
                            }
                        case .notrequired:
                            break
                        case .optional:
                            break
                        }
                        
                    }
                }
                
                self.finilizeOrder()
            })
            
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
    }
    
    func facturar(){
        
        loadingView(show: true)
        
        API.custAccountV1.load(id: .id(self.order.custAcct)) { resp in
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, "No se obtuvo datos de la cuenta.")
                return
            }
            
            guard let account = resp.data?.custAcct else {
                showError(.unexpectedResult, "No se localizo cuenta")
                return
            }
            
            let view = ToolFiscal(
                loadType: .order(id: self.order.id),
                folio: self.order.folio,
                callback: { id, folio, pdf, xml in
                    
                    self.fiscalView.innerHTML = ""
                    
                    self.fiscalView.appendChild(Div{
                        Img()
                            .src("/skyline/media/attachment.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Span("Factura")
                            .fontSize(24.px)
                    }
                    .class(.uibtn)
                    .onClick {
                        
                        loadingView(show: true)

                        API.fiscalV1.loadDocument(docid: id) { resp in

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
                                showError(.unexpectedResult, "No se obtuvo payload de data.")
                                return
                            }

                            let view = ToolFiscalViewDocument(
                                type: payload.type,
                                doc: payload.doc,
                                reldocs: payload.reldocs,
                                account: payload.account
                            ) {
                                /// Document canceled
                                
                                self.fiscalView.innerHTML = ""
                                
                                self.fiscalView.appendChild(Div{
                                    Img()
                                        .src("/skyline/media/money_bag.png")
                                        .height(24.px)
                                        .marginRight(7.px)
                                    
                                    Span("Facturar")
                                        .fontSize(24.px)
                                }
                                    .marginLeft(0)
                                    .class(.uibtn)
                                    .onClick {
                                        self.facturar()
                                    })
                                
                            }
                            
                            addToDom(view)

                        }
                    
                    })
                    
                })
            
            view.reciver = .init(
                id: account.id,
                folio: account.folio,
                businessName: account.businessName,
                firstName: account.firstName,
                lastName: account.lastName,
                mcc: account.mcc,
                mobile: account.mobile,
                email: account.email,
                autoPaySpei: account.autoPaySpei,
                autoPayOxxo: account.autoPayOxxo,
                fiscalProfile: account.fiscalProfile,
                fiscalRazon: account.fiscalRazon,
                fiscalRfc: account.fiscalRfc,
                fiscalRegime: account.fiscalRegime,
                fiscalZip: account.fiscalZip,
                cfdiUse: account.cfdiUse,
                fiscalPOCFirstName: account.fiscalPOCFirstName,
                fiscalPOCLastName: account.fiscalPOCLastName,
                fmcc: account.fmcc,
                fiscalPOCMobile: account.fiscalPOCMobile,
                fiscalPOCMobileValidaded: account.fiscalPOCMailValidaded,
                fiscalPOCMail: account.fiscalPOCMail,
                fiscalPOCMailValidaded: account.fiscalPOCMailValidaded,
                crstatus: account.crstatus, 
                isConcessionaire: account.isConcessionaire
            )
            
            addToDom(view)
        }
        
    }
    
    func reactivate(){
        
        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
            showAlert(.alerta, "No tiene permiso para reactivar orden.")
            return
        }
        
        switch self.order.type {
        case .folio:
            self.appendChild(ReactivateConfirmOrderRentalView(type: self.order.type, rentals: self.rentals, equipments: self.equipments){ reacts in
                self.reactivateAct(reacts)
            })
        case .date:
            break
        case .sale:
            break
        case .rental:
            self.appendChild(ReactivateConfirmOrderRentalView(type: self.order.type, rentals: self.rentals, equipments: self.equipments){ reacts in
                self.reactivateAct(reacts)
            })
            
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
        
    }
    
    func reactivateAct(_ payload: [UUID: Bool]){
        
        var objs: [API.custOrderV1.ReactivateObject] = []
        
        var ids: [UUID] = []
        
        payload.forEach { id, react in
            if react {
                ids.append(id)
            }
        }
        
        switch self.order.type {
        case .folio:
            self.equipments.forEach { obj in
                if ids.contains(obj.id) {
                    objs.append(.init(id: obj.id, description: "\(obj.tag1) \(obj.tag2) \(obj.tag3)".purgeSpaces))
                }
            }
        case .date:
            break
        case .sale:
            break
        case .rental:
            
            self.rentals.forEach { obj in
                if ids.contains(obj.id) {
                    objs.append(.init(id: obj.id, description: "\(obj.ecoNumber) \(obj.name)"))
                }
            }
            
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
        
        loadingView(show: true)
        
        API.custOrderV1.reactivate(ids: objs, orderid: self.order.id, sendComm: true) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            switch self.order.type {
            case .folio:
                
                var cc = 0
                
                self.equipments.forEach { obj in
                    
                    if ids.contains(obj.id) {
                        self.equipments[cc].deliveredBy = nil
                    }
                    
                    if let _ = self.equipmentViewRefrence[obj.id] {
                        self.equipmentViewRefrence[obj.id]?.deliveredBy = nil
                        self.equipmentViewRefrence[obj.id]?.isPicked.wrappedValue = false
                    }
                    
                    cc += 1
                }
                
            case .date:
                break
            case .sale:
                break
            case .rental:
                
                var cc = 0
                
                self.rentals.forEach { obj in
                    
                    if ids.contains(obj.id) {
                        self.rentals[cc].deliveredBy = nil
                    }
                    
                    if let _ = self.rentalViewRefrence[obj.id] {
                        self.rentalViewRefrence[obj.id]?.deliveredBy = nil
                        self.rentalViewRefrence[obj.id]?.isPicked = false
                    }
                    
                    cc += 1
                }
                
            case .mercadoLibre:
                break
            case .claroShop:
                break
            case .amazon:
                break
            case .ebay:
                break
            }
            
            self.status = .active
            
            self.order.status = .active
            
            orderCatch[self.order.id]?.status = .active
            
            orderCatch[self.order.id]?.modifiedAt = getNow()
            
        }
    }
    
    // folio cambiado a finalizado, error en desarollo de logica TIM:24rnlaCm7  vcantu01
    func changeOrderStatus(_ newStatus: CustFolioStatus) {
        
        switch newStatus {
        case .pending:
            break
        case .active:
            break
        case .pendingSpare:
            showError(.errorGeneral, "Funcion no sopotada")
            return
            return
        case .canceled:
            showError(.errorGeneral, "Funcion no sopotada")
            
        case .finalize:
            if self.status != .archive {
                showError(.errorGeneral, "Funcion no sopotada")
                return
            }
        case .archive:
            break
        case .collection:
            break
        case .sideStatus:
            if self.status != .archive {
                showError(.errorGeneral, "Funcion no sopotada")
                return
            }
            return
        case .saleWait:
            break
        }
        
        if let _ = order.transferManagement {
            showError(.errorGeneral, "Funcion no sopotada")
        }
    
        let confirm = ChangeStatusView(
            status: newStatus,
            folio: self.order.folio,
            name: self.order.name
        ) { reason, dueDate in
            
            loadingView(show: true)
            
            API.custOrderV1.changeStatus(
                orderId: self.order.id,
                reason: reason,
                status: newStatus,
                dueDate: dueDate
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
                
                self.status = newStatus
                
                self.order.status = newStatus
                
            }
        }
        
        addToDom(confirm)
    }
    
    func openOrderBudget(){
        
        addToDom(BudgetView(
            accountId: order.custAcct,
            budgetStatus: self.$budgetStatus,
            costType: self.accountView.account?.costType ?? .cost_a,
            orderid: self.order.id,
            customerName: orderName,
            customerMobile: mobile
        ){ items in
            
            items.charges.forEach { charge in
                self.charges.append(.init(
                    id: charge.id,
                    codeid: charge.SOC,
                    type: (charge.SOC == nil) ? .manual : .service,
                    name: charge.name,
                    cuant: charge.cuant,
                    price: charge.price,
                    status: charge.status
                ))
            }
            
            self.pocs.append(contentsOf: items.pocs)
            
            items.charges.forEach { obj in
                
                let stotal = ((obj.price * obj.cuant) / 100)
                
                self.total += stotal
                self.chas += stotal
                
                let tr = OldChargeTrRow(
                    isCharge: true,
                    id: obj.id,
                    name: obj.name,
                    cuant: obj.cuant,
                    price: obj.price,
                    puerchaseOrder: false
                ) { viewId in
                    self.editCharge(
                        viewId: viewId, 
                        ids: [obj.id],
                        type: (obj.SOC == nil) ? .manual : .service
                    )
                }.color(.gray)
                
                self.chargesRefrence[tr.viewId] = tr
                
                self.chargesTable.appendChild (tr)
            }
            
            var pocsRefrence: [UUID: [Int64 : [CustPOCInventoryOrderView]]] = [:]
            
            items.pocs.forEach { obj in
                
                if let _ = pocsRefrence[obj.POC] {
                    
                    if let _ = pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)] {
                        pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)]?.append(obj)
                    }
                    else {
                        pocsRefrence[obj.POC]?[(obj.soldPrice ?? 0)] = [obj]
                    }
                    
                }
                else {
                    pocsRefrence[obj.POC] = [(obj.soldPrice ?? 0) : [obj]]
                }
                
            }
            
            pocsRefrence.forEach { pocId, priceRefrence in
            
                priceRefrence.forEach { price, items in
                
                    let soldPrice = price * items.count.toInt64
                    
                    self.total += soldPrice
                    
                    self.chas += soldPrice
                    
                    let tr = OldChargeTrRow(pocs: items) { viewId in
                        self.editPoc(viewId: viewId, ids: items.map{ $0.id })
                    }
                        .color(.gray)
                    
                    self.chargesRefrence[tr.viewId] = tr
                    
                    self.chargesTable.appendChild(tr)
                    
                }
            }
            
            self.calcBalance()
            
        } addNote: { note in
            self.messageGrid.reciveMessage(note: note)
        })
    }
    
    func loadMedia(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        let view = OrderImageView(
            id: nil,
            name: "",
            url: "skyline/media/tierraceroRoundLogoWhite.svg") { id, name in
        }
        
        fileViewCatch[view.viewId] = view
        
        xhr.onLoadStart {
            self.filesGrid.appendChild(view)
            _ = JSObject.global.scrollToBottom!("filesGrid\(self.order.id.uuidString)")
        }
        
        xhr.onError { jsValue in
            showError(.errorDeCommunicacion, .serverConextionError)
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            view.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.errorGeneral, .serverConextionError + " 001")
                view.remove()
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.errorGeneral, .serverConextionError + " 002")
                view.remove()
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    view.remove()
                    return
                }
                
                guard let mode = resp.data else {
                    showError(.errorGeneral, "No se pudo cargar datos")
                    view.remove()
                    return
                }
                
                switch mode {
                case .processing(let payload):
                    
                    view.id = payload.id
                    
                case .processed(let payload):
                    
                    if let id = payload.mediaid {
                        view.id = id
                    }
                    
                    switch payload.type {
                    case .image:
                        view.url = "https://\(custCatchUrl)/fileNet/\(payload.fileName)"
                        view.custom("background-image", "url('\("https://\(custCatchUrl)/fileNet/\(payload.fileName)")')")
                    case .video:
                        //view.poster = "https://\(custCatchUrl)/fileNet/\(payload.fileName)"
                        //view.videoSrc = "https://\(custCatchUrl)/fileNet/thump_\(payload.fileName)"
                        view.url = "https://\(custCatchUrl)/fileNet/\(payload.fileName)"
                        view.custom("background-image", "url('\("https://\(custCatchUrl)/fileNet/\(payload.fileName)")')")
                    case .audio:
                        break
                    case .pdf:
                        break
                    case .doc, .pages, .numbers, .keynote, .xml:
                        view.url = "https://\(custCatchUrl)/fileNet/\(payload.fileName)"
                    case .ptt:
                        break
                    case .general:
                        break
                    }
                    
                }
                
            } catch {
                showError(.errorGeneral, .serverConextionError + " 003")
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        /*
        formData.append("file", file, filename: file.name)

        formData.append("accountid", self.order.custAcct.uuidString)
        
        formData.append("orderid", self.order.id.uuidString)
        
        formData.append("orderFolio", self.order.folio)
        */
        
        formData.append("eventid", view.viewId.uuidString)
        
        formData.append("to", ImagePickerTo.order.rawValue)
        
        formData.append("id", self.order.id.uuidString)
        
        formData.append("folio", self.order.folio)

        formData.append("file", file, filename: file.name)
        
        formData.append("fileName", file.name)

        formData.append("connid", custCatchChatConnID)
        
        formData.append("remoteCamera", false.description)
        
        //xhr.open(method: "POST", url: "https://intratc.co/api/custOrder/v1/saveFile")
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadManager")
        
        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web, 
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        xhr.send(formData)
        
    }
    
    func loadLocation(_ lat: String,_ lon: String){
        _ = JSObject.global.initmap!( "control.\(custCatchUrl)" , lat, lon, "Cliente")
    }
    
    func proccessPayment(_ code: FiscalPaymentCodes, _ description: String, _ amount: Float, _ provider: String, _ lastFour: String, _ auth: String, _ uts: Int64?){
        
        API.custOrderV1.addPayment(
            orderid: order.id,
            storeId: custCatchStore,
            fiscCode: code,
            description: description,
            cost: amount,
            provider: provider,
            lastFour: lastFour,
            auth: auth
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
                showError(.errorGeneral, resp.msg)
                return
            }
            
            let obj: CustOrderLoadFolioPayments = .init(
                id: payload.paymentId,
                folio: payload.paymentFolio,
                type: .payment,
                cost: amount.toCents,
                ref: "",
                description: description,
                auth: auth,
                status: BillingStatus.unbilled
            )
            
            let tr = OldChargeTrRow(
                isCharge: false,
                id: obj.id,
                name: obj.description,
                cuant: 100.toInt64,
                price: obj.cost,
                puerchaseOrder: false
                
            ) { viewId in
                /// Payments cant be edited
                self.removePayment(
                    id: viewId,
                    name: obj.description,
                    amount: obj.cost
                )
            }.color(.gray)
            
            self.chargesRefrence[tr.viewId] = tr
            
            self.chargesTable.appendChild (tr)
            
            paymentsCatch[self.order.id]?.append(obj)
            
            self.payments.append(obj)
            
            self.calcBalance()
            
            self.status = payload.status
            
            OrderCatchControler.shared.updateParameter(self.order.id, .orderStatus(payload.status))
            
        }
    }
    
    func proccessPaymentWithPoints( _ amount: Float){

        if accountView.cardId.isEmpty {
            showError(.errorGeneral, "No se activado una tarjeta de recompensas.")
        }
        
        loadingView(show: true)
        
        API.rewardsV1.payWithPoints(
            cardId: accountView.cardId,
            points: amount.toInt,
            relationType: .order,
            relationId: self.order.id
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
            
            let obj: CustOrderLoadFolioPayments = .init(
                id: payload.paymentId,
                folio: payload.paymentFolio,
                type: .adjustment,
                cost: amount.toCents,
                ref: "",
                description: "Pago con Puntos de Recompensa",
                auth: "",
                status: BillingStatus.unbilled
            )
            
            let tr = OldChargeTrRow(
                isCharge: false,
                id: obj.id,
                name: obj.description,
                cuant: 100.toInt64,
                price: obj.cost,
                puerchaseOrder: false
            ) { viewId in
                /// Payments cant be edited
                self.removePayment(
                    id: viewId,
                    name: obj.description,
                    amount: obj.cost
                )
            }.color(.gray)
            
            self.chargesRefrence[tr.viewId] = tr
            
            self.chargesTable.appendChild (tr)
            
            paymentsCatch[self.order.id]?.append(obj)
            
            self.payments.append(obj)
            
            self.calcBalance()
            
            self.status = payload.status ?? .active
            
            OrderCatchControler.shared.updateParameter(self.order.id, .orderStatus(self.status))
            
        }
    }
    
    func addOrderProject(){
        
        let view = AddOrderProject(
            accountId: self.order.custAcct,
            orderId: self.order.id,
            storeId: self.order.store ?? custCatchStore
        ) { id in
            self.orderProject = id
        }
        
        addToDom(view)
        
    }
    
}
