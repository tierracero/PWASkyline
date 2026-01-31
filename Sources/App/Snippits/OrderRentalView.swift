//
//  OrderRentalView.swift
//
//
//  Created by Victor Cantu on 4/25/22.
//

import Foundation
import TCFundamentals
import Web

class OrderRentalView: Div {
    
    override class var name: String { "div" }
    
    let unWorkableStatus: [CustFolioStatus] = [
        .canceled,
        .pending,
        .finalize,
        .archive,
        .collection
    ]
    
    @State var orderEditButton = "/skyline/media/pencil.png"
    @State var editMode = false
    
    @State var name = ""
    @State var ecoNumber = ""
    @State var soldPrice = ""
    @State var descr = ""
    
    var workedBy: UUID? = nil
    var deliveredBy: UUID? = nil
    
    @State var isReady: Bool = false
    @State var isPicked: Bool = false
    @State var isReadyDisabled: Bool = false
    @State var pendingPickupDisabled: Bool = false
    
    /// Used to see role back to original product description  user cnx changes to POCRental description
    var oriDescr = ""
    
    @State var descriptionIsHidden: Bool = true
    
    var orderView: OrderView
    var status: State<CustFolioStatus>
    var rental: CustPOCRentalsMin
    var hideControls: Bool
    init(
        orderView: OrderView,
        status: State<CustFolioStatus>,
        rental: CustPOCRentalsMin,
        hideControls: Bool
    ) {
        self.orderView = orderView
        self.status = orderView.$status
        self.rental = rental
        self.hideControls = hideControls
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Product Name
            Label("Producto")
                .color(.gray)
            
            Div().class(.clear).marginTop(1.px)
            
            Span(self.$name)
                .color(.lightGray)
                .fontSize(20.px)
            
            Div().class(.clear).marginTop(3.px)
            
            /// Numero Economico
            Label("Numero Economico")
                .color(.gray)
            
            Div().class(.clear).marginTop(1.px)
            
            Span(self.$ecoNumber)
                .color(.lightGray)
                .fontSize(20.px)
            
            Div().class(.clear).marginTop(3.px)
        }
        .width(33.percent)
        .float(.left)
        
        Div{
            
            Label("Precio")
                .color(.gray)
            
            Div().class(.clear).marginTop(1.px)
            
            Span(self.$soldPrice)
                .color(.lightGray)
                .fontSize(20.px)
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                Div{
                    Label("Preparado")
                        .color(.gray)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    Div{
                        InputCheckbox().toggleRental(self.$isReady, self.$isReadyDisabled){ isCheked in
                            ///Flag isReady as TRUE
                            if !isCheked {
                                
                                if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                    
                                    loadingView(show: true)
                                    
                                    API.custOrderV1.rentalReadyStatus(
                                        accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, isReady: true) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp = resp else {
                                            showError(.comunicationError, .serverConextionError)
                                            return
                                        }
                                        guard resp.status == .ok else{
                                            showError(.generalError    , resp.msg)
                                            return
                                        }
                                        
                                        self.isReady = true
                                        
                                        var cc = 0
                                        rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                            if rental.id  == self.rental.id {
                                                rentalsCatch[self.orderView.order.id]![cc].workedBy = custCatchID
                                            }
                                            cc += 1
                                        })
                                        
                                        cc = 0
                                        self.orderView.rentals.forEach { rental in
                                            if rental.id  == self.rental.id {
                                                self.orderView.rentals[cc].workedBy = custCatchID
                                            }
                                            cc += 1
                                        }
                                        
                                    }
                                }
                                
                                self.appendChild(
                                    ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: PREPARADO", callback: { confirmed, _ in
                                    if confirmed {
                                        loadingView(show: true)
                                        API.custOrderV1.rentalReadyStatus(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, isReady: true) { resp in
                                            
                                            loadingView(show: false)
                                            
                                            guard let resp = resp else {
                                                showError(.comunicationError, .serverConextionError)
                                                return
                                            }
                                            guard resp.status == .ok else{
                                                showError(.generalError    , resp.msg)
                                                return
                                            }
                                            
                                            self.isReady = true
                                            
                                            var cc = 0
                                            rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                                if rental.id  == self.rental.id {
                                                    rentalsCatch[self.orderView.order.id]![cc].workedBy = custCatchID
                                                }
                                                cc += 1
                                            })
                                            
                                            cc = 0
                                            self.orderView.rentals.forEach { rental in
                                                if rental.id  == self.rental.id {
                                                    self.orderView.rentals[cc].workedBy = custCatchID
                                                }
                                                cc += 1
                                            }
                                            
                                            
                                        }
                                    }
                                }))
                                return
                            }
                            /// Flag isReady as FALSE
                            else{
                                /// Validad if user has permition to remove isReady flag
                                if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                    self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: NO preparado", callback: { confirmed, _ in
                                        if confirmed {
                                            loadingView(show: true)
                                            API.custOrderV1.rentalReadyStatus(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, isReady: false) { resp in
                                                loadingView(show: false)
                                                
                                                guard let resp = resp else {
                                                    showError(.comunicationError, .serverConextionError)
                                                    return
                                                }
                                                guard resp.status == .ok else{
                                                    showError(.generalError    , resp.msg)
                                                    return
                                                }
                                                
                                                self.isReady = false
                                                
                                                var cc = 0
                                                rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                                    if rental.id  == self.rental.id {
                                                        rentalsCatch[self.orderView.order.id]![cc].workedBy = nil
                                                    }
                                                    cc += 1
                                                })
                                                
                                                cc = 0
                                                self.orderView.rentals.forEach { rental in
                                                    if rental.id  == self.rental.id {
                                                        self.orderView.rentals[cc].workedBy = nil
                                                    }
                                                    cc += 1
                                                }
                                            }
                                        }
                                    }))
                                }
                                else{
                                    showAlert(.alerta, "No tiene permiso de  realizar esta accion, contatce a un \(getUsernameRoles(configStoreProcessing.restrictOrderClosing).description)")
                                }
                            }
                        }
                    }
                    .align(.center)
                }
                .class(.oneHalf)
                
                Div{
                    Label("Entregado")
                        .color(.gray)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    Div{
                        InputCheckbox().toggleRental(self.$isPicked, self.$pendingPickupDisabled){ isCheked in // self.pendingPickup = true
                            ///Flag isReady as TRUE
                            if !isCheked {
                                
                                if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                    loadingView(show: true)
                                    API.custOrderV1.rentalPickedStatus(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, pickedUp: true) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp = resp else {
                                            showError(.comunicationError, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else{
                                            showError(.generalError    , resp.msg)
                                            return
                                        }
                                        
                                        self.isPicked = true
                                        
                                        var cc = 0
                                        rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                            if rental.id  == self.rental.id {
                                                rentalsCatch[self.orderView.order.id]![cc].deliveredBy = custCatchID
                                            }
                                            cc += 1
                                        })
                                        
                                        cc = 0
                                        self.orderView.rentals.forEach { rental in
                                            if rental.id  == self.rental.id {
                                                self.orderView.rentals[cc].deliveredBy = custCatchID
                                            }
                                            cc += 1
                                        }
                                        
                                    }
                                    
                                }
                                else{
                                    
                                    self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: ENTREGADO", callback: { confirmed, _ in
                                        if confirmed {
                                            loadingView(show: true)
                                            API.custOrderV1.rentalPickedStatus(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, pickedUp: false) { resp in
                                                
                                                loadingView(show: false)
                                                
                                                guard let resp = resp else {
                                                    showError(.comunicationError, .serverConextionError)
                                                    return
                                                }
                                                
                                                guard resp.status == .ok else {
                                                    showError(.generalError    , resp.msg)
                                                    return
                                                }
                                                
                                                self.isPicked = true
                                                
                                                var cc = 0
                                                rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                                    if rental.id  == self.rental.id {
                                                        rentalsCatch[self.orderView.order.id]![cc].deliveredBy = custCatchID
                                                    }
                                                    cc += 1
                                                })
                                                
                                                cc = 0
                                                self.orderView.rentals.forEach { rental in
                                                    if rental.id  == self.rental.id {
                                                        self.orderView.rentals[cc].deliveredBy = custCatchID
                                                    }
                                                    cc += 1
                                                }
                                                
                                            }
                                        }
                                    }))
                                }
                                
                            }
                            /// Flag isReady as FALSE
                            else{
                                /// Validad if user has permition to remove isReady flag
                                if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                    self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: NO entregado", callback: { confirmed, _ in
                                        if confirmed {
                                            loadingView(show: true)
                                            API.custOrderV1.rentalPickedStatus(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, orderFolio: self.orderView.order.folio, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, pickedUp: false) { resp in
                                                loadingView(show: false)
                                                
                                                guard let resp = resp else {
                                                    showError(.comunicationError, .serverConextionError)
                                                    return
                                                }
                                                guard resp.status == .ok else{
                                                    showError(.generalError    , resp.msg)
                                                    return
                                                }
                                                
                                                self.isPicked = false
                                                
                                                var cc = 0
                                                rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                                    if rental.id  == self.rental.id {
                                                        rentalsCatch[self.orderView.order.id]![cc].deliveredBy = nil
                                                    }
                                                    cc += 1
                                                })
                                                
                                                cc = 0
                                                self.orderView.rentals.forEach { rental in
                                                    if rental.id  == self.rental.id {
                                                        self.orderView.rentals[cc].deliveredBy = nil
                                                    }
                                                    cc += 1
                                                }
                                                
                                            }
                                        }
                                    }))
                                }
                                else{
                                    showAlert(.alerta, "No tiene permiso de  realizar esta accion, contatce a un \(getUsernameRoles(configStoreProcessing.restrictOrderClosing).description)")
                                }
                            }
                            
                        }
                    }
                    .align(.center)
                    
                }
                .class(.oneHalf)
            }
            .hidden(self.hideControls)
            
        }
        .width(33.percent)
        .float(.left)
        
        Div{
            
            Img()
                .src(self.$orderEditButton)
                .height(18.px)
                .float(.right)
                .cursor(.pointer)
                .onClick { img, event in
                    
                    if self.editMode {
                        
                        guard self.descr != self.oriDescr else {
                            self.orderEditButton = "/skyline/media/pencil.png"
                            self.editMode = false
                            return
                        }
                        
                        loadingView(show: true)
                        
                        API.custOrderV1.saveRentalDetail(accountid: self.orderView.order.custAcct, orderid: self.orderView.order.id, rentalid: self.rental.id, ecoNumber: self.rental.ecoNumber, description: self.descr) { resp in
                            
                            loadingView(show: false)
                            
                            guard let resp = resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.generalError, resp.msg)
                                return
                            }
                            
                            var cc = 0
                            rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                if rental.id  == self.rental.id {
                                    rentalsCatch[self.orderView.order.id]![cc].description = self.descr
                                }
                                cc += 1
                            })
                            
                            self.oriDescr = self.descr
                            
                            self.orderEditButton = "/skyline/media/pencil.png"
                            self.editMode = false

                        }
                        
                        return
                    }
                    
                    self.orderEditButton = "/skyline/media/diskette.png"
                    self.editMode = true
                }
            
            Img()
                .src("/skyline/media/cross.png")
                .marginRight(12.px)
                .height(18.px)
                .float(.right)
                .cursor(.pointer)
                .hidden(self.$editMode.map{!$0})
                .onClick { img, event in
                    
                    self.descr = self.oriDescr
                    self.orderEditButton = "/skyline/media/pencil.png"
                    self.editMode = false
                }
            
            Span(self.$descr)
                .color(.lightGray)
                .fontSize(20.px)
                .float(.left)
                .hidden(self.$editMode.map{$0})
                .marginBottom(3.px)
            
            TextArea(self.$descr)
                .fontSize(18.px)
                .placeholder("Nombre Producto")
                .custom("width","calc(100% - 18px)")
                .class(.textFiledBlackDark)
                .width(70.percent)
                .height(100.percent)
                .hidden(self.$editMode.map{!$0})
            
        }
        .width(33.percent)
        .height(100.percent)
        .overflow(.auto)
        .float(.left)
    }
    
    override func buildUI() {
        super.buildUI()
        height(100.percent)
        width(100.percent)
        
        self.$isReady.listen {
            if $0 {
                self.pendingPickupDisabled = false
            }
            else {
                self.pendingPickupDisabled = true
            }
        }
        
        self.$isPicked.listen {
            if !$0 {
                self.isReadyDisabled = false
            }
            else {
                self.isReadyDisabled = true
            }
        }
        
        self.status.listen {
            if !self.unWorkableStatus.contains($0) {
                
                if let workedBy = self.rental.workedBy {
                    if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                        self.isReadyDisabled = true
                    }
                    else{
                        self.isReadyDisabled = false
                    }
                    
                    if let deliveredBy = self.rental.deliveredBy {
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            self.pendingPickupDisabled = true
                        }
                        else{
                            self.pendingPickupDisabled = false
                        }
                    }
                }
                else {
                    self.isReadyDisabled = false
                    self.pendingPickupDisabled = true
                }
                
            }
        }
        
        self.name = self.rental.name
        self.ecoNumber = self.rental.ecoNumber
        self.soldPrice = self.rental.soldPrice.formatMoney
        self.descr = self.rental.description
        
        self.workedBy = self.rental.workedBy
        self.deliveredBy = self.rental.deliveredBy
        
        /// cheke if it has been prepared
        if let workedBy = self.rental.workedBy {
            self.workedBy = workedBy
            self.isReady = true
            if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                self.isReadyDisabled = true
            }
        }
        else {
            self.isReady = false
        }
        
        if let deliveredBy = self.rental.deliveredBy {
            self.deliveredBy = deliveredBy
            self.isPicked = true
            if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                self.pendingPickupDisabled = true
            }
        }
        else {
            self.isPicked = false
        }
        
        if unWorkableStatus.contains(self.status.wrappedValue) {
            self.isReadyDisabled = true
            if self.isPicked {
                self.pendingPickupDisabled = true
            }
        }
        
        self.oriDescr = self.rental.description
        
    }
}

