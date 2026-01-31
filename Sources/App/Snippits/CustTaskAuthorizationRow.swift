//
//  CustTaskAuthorizationRow.swift
//  
//
//  Created by Victor Cantu on 4/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustTaskAuthorizationRow: Div {
    
    override class var name: String { "div" }
    
    let task: CustTaskAuthorizationManagerQuick
    
    private var callback: ((
    ) -> ())?
    
    init(
        task: CustTaskAuthorizationManagerQuick,
        callback: ((
        ) -> ())? = nil
    ) {
        self.task = task
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var buttonView = Div()
    
    @State var username = "..."
    
    @State var isLoading = false
    
    @DOM override var body: DOM.Content {
        
        Div{
            Span(self.task.alertType.description)
                .fontSize(18.px)
                .color(.gray)
            
            Span("\(getDate(self.task.createdAt).formatedLong) \(getDate(self.task.createdAt).time)")
                .fontSize(18.px)
                .float(.right)
                .color(.white)
            
            Span(self.$username)
                .color(.yellowTC)
                .marginRight(7.px)
                .fontSize(18.px)
                .float(.right)
        }
        .marginBottom(7.px)
        
        Div(self.task.requestMessage)
            .marginBottom(7.px)
            .whiteSpace(.initial)
            .fontSize(24.px)
            .color(.white)
        
        self.buttonView
            .marginBottom(7.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        self.class(.uibtnLarge)
            .width(97.percent)
            .cursor(.default)
        
        do {
            let data = try JSONEncoder().encode(task)
            
            print(String(data: data, encoding: .utf8)!)
            
        }
        catch {
            
        }
        
        /// SET PREVIEW BTN
        switch task.alertType {
        case .product:
            break
        case.purchase:
            break
        case .fiscal:
            buttonView.appendChild(
                Div("Ver Documento")
                .class(.uibtnLargeOrange)
                .float(.left)
                .onClick {
                    
                    guard let id = self.task.relId else {
                        return
                    }
                    
                    loadingView(show: true)

                    API.fiscalV1.loadDocument(docid: id) { resp in

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
                            self.remove()
                        }
                        
                        addToDom(view)

                    }
                    
                }
            )
        case .order, .orderCharge, .orderPayment:
            buttonView.appendChild(
                Div("Ver Orden")
                .class(.uibtnLargeOrange)
                .float(.left)
                .onClick {
                    
                    guard let id = self.task.relId else {
                        return
                    }
                    
                    OrderCatchControler.shared.loadFolio(orderid: id) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                        
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
                        
                         addToDom(accoutOverview)
                         
                        if let callback = self.callback {
                            callback()
                        }
                        
                    }
                    
                }
            )
            buttonView.appendChild(
                Div(self.task.relFolio ?? "")
                    .marginTop(16.px)
                    .marginLeft(7.px)
                    .color(.gray)
                    .float(.left)
            )
        case .sale:
            break
        case .budget:
            
            buttonView.appendChild(
                Div("Ver Orden")
                .class(.uibtnLargeOrange)
                .float(.left)
                .onClick {
                    
                    guard let budgetId = self.task.relId else {
                        return
                    }
                    
                    loadingView(show: true)
                    
                    API.custOrderV1.getBudgetRelatedOrder(
                        budgetId: budgetId
                    ) { resp in
                        
                        guard let resp else {
                            loadingView(show: false)
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else {
                            loadingView(show: false)
                            showError(.generalError, resp.msg)
                            return
                        }

                        guard let payload = resp.data else {
                            loadingView(show: false)
                            showError(.unexpectedResult, "No se obtuvo payload de data.")
                            return
                        }

                        OrderCatchControler.shared.loadFolio(orderid: payload.orderId) { account, order, notes, payments, charges, pocs, files, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                            
                            loadingView(show: false)
                            
                            if let callback = self.callback {
                                callback()
                            }
                            
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
                             
                            addToDom(accoutOverview)
                            
                        }
                    }
                }
            )
            
            buttonView.appendChild(
                Div(self.task.relFolio ?? "")
                    .marginTop(16.px)
                    .marginLeft(7.px)
                    .color(.gray)
                    .float(.left)
            )
        case .personalLone:
            break
        case .moneyTransfer:
            break
        case .changePrice:
            /// Manage by CustTaskAuthRequestWaitView
            break
        case .task:
            break
        }
        
        /// SET ACTION BUTTONS
        switch task.actionType {
        case .notify:
            
            buttonView.appendChild(
                Div{
                    
                    Img()
                        .src(self.$isLoading.map{ $0 ? "/skyline/media/loader.gif" : "/skyline/media/round.png" })
                        .marginRight( 7.px)
                        .width(16.px)
                    
                    Span("Ok")
                }
                    .cursor(self.$isLoading.map{ $0 ? .default : .pointer })
                    .class(.uibtnLargeOrange)
                    .float(.right)
                    .onClick {
                        
                        if self.isLoading {
                            return
                        }
                        
                        self.isLoading = true
                        
                        API.custAPIV1.CTAMResolve(
                            alertid: self.task.id,
                            action: .authorize,
                            responseMessage: ""
                        ) { resp in
                        
                            self.isLoading = false
                            
                            guard let resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.generalError, resp.msg)
                                return
                            }
                            
                            if let callback = self.callback {
                                callback()
                            }
                            
                            self.remove()
                            
                        }
                        
                    }
            )
            
        case .auth:
            
            buttonView.appendChild(
                Div{
                    Img()
                        .src(self.$isLoading.map{ $0 ? "/skyline/media/loader.gif" : "/skyline/media/cross.png" })
                        .marginRight( 7.px)
                        .width(16.px)
                    
                    Span("Denegar")
                }
                    .cursor(self.$isLoading.map{ $0 ? .default : .pointer })
                    .class(.uibtnLargeOrange)
                    .float(.right)
                    .onClick {
                        
                        if self.isLoading {
                            return
                        }
                        
                        self.isLoading = true
                        
                        API.custAPIV1.CTAMResolve(
                            alertid: self.task.id,
                            action: .denied,
                            responseMessage: ""
                        ) { resp in
                        
                            self.isLoading = false
                            
                            guard let resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.generalError, resp.msg)
                                return
                            }
                            
                            if let callback = self.callback {
                                callback()
                            }
                            self.remove()
                            
                        }
                        
                    }
            )
            
            buttonView.appendChild(
                Div{
                    Img()
                        .src(self.$isLoading.map{ $0 ? "/skyline/media/loader.gif" : "/skyline/media/round.png" })
                        .marginRight( 7.px)
                        .width(16.px)
                    
                    Span("Aprobar")
                }
                    .cursor(self.$isLoading.map{ $0 ? .default : .pointer })
                    .class(.uibtnLargeOrange)
                    .marginRight(12.px)
                    .float(.right)
                    .onClick {
                        
                        if self.isLoading {
                            return
                        }
                        
                        self.isLoading = true
                        
                        API.custAPIV1.CTAMResolve(
                            alertid: self.task.id,
                            action: .authorize,
                            responseMessage: ""
                        ) { resp in
                        
                            self.isLoading = false
                            
                            guard let resp else {
                                showError(.comunicationError, .serverConextionError)
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.generalError, resp.msg)
                                return
                            }
                            
                            if let callback = self.callback {
                                callback()
                            }
                            
                            self.remove()
                            
                        }
                        
                    }
            )
        case .task:
            break
        }
        
        buttonView.appendChild(
            Div().class(.clear)
        )
        
        getUserRefrence(id: .id(task.createdBy)) { user in
            self.username = "@" + (user?.username.explode("@").first ?? "N/A")
        }
        
    }
}

