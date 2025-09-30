//
//  OrderView+OrderProject.swift
//
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderView {
    
    class OrderProject: Div {
        
        override class var name: String { "div" }
        
        public let project: CustOrderProjetcManager
        
        public let items: [API.custOrderV1.LoadOrderProjectItem]
        
        @State var charges: [CustOrderProjetcManagerCharge]
        
        public init(
            project: CustOrderProjetcManager,
            items: [API.custOrderV1.LoadOrderProjectItem],
            charges: [CustOrderProjetcManagerCharge]
        ) {
            self.project = project
            self.items = items
            self.charges = charges
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State fileprivate var currentView: CurrentView = .workMap
        
        var pendingItems: [API.custOrderV1.LoadOrderProjectItem] = []
        
        var activeItems: [API.custOrderV1.LoadOrderProjectItem] = []
        
        var inrevisionItems: [API.custOrderV1.LoadOrderProjectItem] = []
        
        var doneItems: [API.custOrderV1.LoadOrderProjectItem] = []
        
        var cancelItems: [API.custOrderV1.LoadOrderProjectItem] = []
        
        var chargesViewRefrence: [OrderProjectChargeView] = []
        
        var itemRefrence: [ UUID : OrderProjectItemView ] = [:]
        
        var estimatedUnits = "0"
        
        var estimatedCost = "0.00"
        
        var estimatedTotal = "0.00"
        
        @State var realUnits = "0"
        
        @State var realCost = "0.00"
        
        @State var realTotal = "0.00"
        
        lazy var chargesGrid = Div()
        
        lazy var pendingItemsView = Div()
        
        lazy var activeItemsView = Div()
        
        lazy var inrevisionItemsView = Div()
        
        lazy var doneItemsView = Div()
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    Div{
                        
                        H2("Mapa Operativo")
                            .backgroundColor(self.$currentView.map{ ($0 == .workMap) ? .black : .transparent})
                            .borderTopRightRadius(12.px)
                            .borderTopLeftRadius(12.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .fontSize(18.px)
                            .color(.white)
                            .float(.left)
                            .onClick {
                                self.currentView = .workMap
                            }
                    
                        H2("Finanzas")
                            .backgroundColor(self.$currentView.map{ ($0 == .charges) ? .black : .transparent})
                            .borderTopRightRadius(12.px)
                            .borderTopLeftRadius(12.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .fontSize(18.px)
                            .color(.white)
                            .float(.left)
                            .onClick {
                                self.currentView = .charges
                            }
                            
                    }
                    .float(.right)
                    
                    H2("Ver Proyecto")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                }
                
                Div().clear(.both)
                
                // MARK: Work Map view
                Div{
                    Div{
                        Div("Pendiente")
                            .width(25.percent)
                            .color(.white)
                            .float(.left)
                        
                        Div("Activo")
                            .width(25.percent)
                            .color(.white)
                            .float(.left)
                        
                        Div("En Revision")
                            .width(25.percent)
                            .color(.white)
                            .float(.left)
                        
                        Div("Terminado")
                            .width(25.percent)
                            .color(.white)
                            .float(.left)
                    }
                    
                    Div{
                        
                        self.pendingItemsView
                            .height(100.percent)
                            .width(25.percent)
                            .overflow(.auto)
                            .color(.white)
                            .float(.left)
                        
                        self.activeItemsView
                            .height(100.percent)
                            .width(25.percent)
                            .overflow(.auto)
                            .color(.white)
                            .float(.left)
                         
                        self.inrevisionItemsView
                            .height(100.percent)
                            .width(25.percent)
                            .overflow(.auto)
                            .color(.white)
                            .float(.left)
                        
                        self.doneItemsView
                            .height(100.percent)
                            .width(25.percent)
                            .overflow(.auto)
                            .color(.white)
                            .float(.left)
                        
                    }
                    .custom("height", "calc(100% - 35px)")
                    
                }
                .custom("height", "calc(100% - 30px)")
                .hidden(self.$currentView.map{ $0 != .workMap })
                
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/add.png")
                            .padding(all: 3.px)
                            .paddingRight(7.px)
                            .cursor(.pointer)
                            .float(.right)
                            .height(18.px)
                            .onClick { img, event in
                                
                                addToDom(AddNewOrderProjectChargeView(
                                    projectId: self.project.id,
                                    callback: { charge in
                                        
                                        
                                        let chargeView = OrderProjectChargeView(
                                            charge: charge
                                        ) {
                                            self.updateRealBalance()
                                        }
                                        
                                        self.chargesViewRefrence.append(chargeView)
                                        
                                        self.chargesGrid.appendChild(chargeView)
                                        
                                        self.updateRealBalance()
                                        
                                    })
                                )
                                
                            }
                        
                        H2("Cargos y gastos")
                            .color(.white)
                        
                    }
                    
                    Div{
                        
                        Div("Descripción")
                            .class(.oneLineText)
                            .width(40.percent)
                            .color(.gray)
                            .float(.left)
                        
                        Div("Unis Calc.")
                        .width(10.percent)
                        .align(.center)
                        .float(.left)
                        .color(.gray)
                        
                        Div("Cost Calc.")
                        .width(10.percent)
                        .align(.center)
                        .float(.left)
                        .color(.gray)
                        
                        Div("Total Calc")
                        .width(10.percent)
                        .align(.center)
                        .float(.left)
                        .color(.gray)
                        
                        Div("Unis Real")
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div("Cost Real")
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div("Total Real")
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div().clear(.both)
                    }
                    .marginBottom(3.px)
                    .marginTop(3.px)
                    Div{
                        self.chargesGrid
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        
                    }
                    .custom("height", "calc(100% - 90px)")
                    .overflow(.auto)
                    
                    // MARK: TOTALS
                    Div{
                        
                        Div()
                            .class(.oneLineText)
                            .width(40.percent)
                            .height(35.px)
                            .float(.left)
                        
                        Div(self.estimatedUnits)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.gray)
                        
                        Div(self.estimatedCost)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.gray)
                        
                        Div(self.estimatedTotal)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.gray)
                        
                        Div(self.$realUnits)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div(self.$realCost)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div(self.$realTotal)
                        .width(10.percent)
                        .align(.right)
                        .float(.left)
                        .color(.white)
                        
                        Div().clear(.both)
                    }
                }
                .custom("height", "calc(100% - 30px)")
                .hidden(self.$currentView.map{ $0 != .charges })
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(5% - 3.5px)")
            .custom("top", "calc(5% - 3.5px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(90.percent)
            .width(90.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.fixed)
            left(0.px)
            top(0.px)
            
            items.forEach { item in
                switch item.item.status {
                case .pending:
                    pendingItems.append(item)
                case .active:
                    activeItems.append(item)
                case .inrevsion:
                    inrevisionItems.append(item)
                case .aproved:
                    doneItems.append(item)
                case .canceled:
                    cancelItems.append(item)
                }
            }
            
            
            // MARK: PENDING
            pendingItems.forEach { item in
                
                let view = OrderProjectItemView(item: item.item, objects: item.objects){ status in
                    self.udpateItemBalance(itemId: item.item.id, status: status)
                }
                
                itemRefrence[item.item.id] = view
                
                pendingItemsView.appendChild(view)
            }
            
            // MARK: ACTIVE
            activeItems.forEach { item in
                
                let view = OrderProjectItemView(item: item.item, objects: item.objects){ status in
                    self.udpateItemBalance(itemId: item.item.id, status: status)
                }
                
                itemRefrence[item.item.id] = view
                
                activeItemsView.appendChild(view)
            }
            
            // MARK: INREVISION
            inrevisionItems.forEach { item in
                
                let view = OrderProjectItemView(item: item.item, objects: item.objects){ status in
                    self.udpateItemBalance(itemId: item.item.id, status: status)
                }
                
                itemRefrence[item.item.id] = view
                
                inrevisionItemsView.appendChild(view)
            }
            
            // MARK: DONE
            doneItems.forEach { item in
                
                let view = OrderProjectItemView(item: item.item, objects: item.objects){ status in
                    self.udpateItemBalance(itemId: item.item.id, status: status)
                }
                
                itemRefrence[item.item.id] = view
                
                doneItemsView.appendChild(view)
            }
            
            var _estimatedUnits: Int = 0
            
            var _estimatedCost: Int64 = 0
            
            var _estimatedTotal: Int64 = 0
            
            var _realUnits: Int = 0
            
            var _realCost: Int64 = 0
            
            var _realTotal: Int64 = 0
            
            charges.forEach { charge in
                
                _estimatedUnits += charge.estimatedUnits
                
                _estimatedCost += charge.estimatedCost
                
                _estimatedTotal += (charge.estimatedUnits.toInt64 * charge.estimatedCost)
                
                _realUnits += charge.realUnits
                
                _realCost += charge.realCost
                
                _realTotal += (charge.realUnits.toInt64 * charge.realCost)
                
                let chargeView = OrderProjectChargeView(
                    charge: charge
                ) {
                    self.updateRealBalance()
                }
                
                chargesViewRefrence.append(chargeView)
                
                chargesGrid.appendChild(chargeView)
                
                chargesGrid.appendChild(Div().clear(.both).height(7.px))
                
            }
            
            estimatedUnits = _estimatedUnits.toString
            
            estimatedCost = _estimatedCost.formatMoney
            
            estimatedTotal = _estimatedTotal.formatMoney
            
            realUnits = _realUnits.toString
            
            realCost = _realCost.formatMoney
            
            realTotal = _realTotal.formatMoney
            
        }
        
        func updateRealBalance() {
            
            var _realUnits: Int = 0
            
            var _realCost: Int64 = 0
            
            var _realTotal: Int64 = 0
            
            chargesViewRefrence.forEach{ view in
                
                realTotal = "0.00"
                
                guard let units = Int(view.realUnits.replace(from: ",", to: "")) else {
                    return
                }
                
                guard let cost = Double(view.realCost.replace(from: ",", to: ""))?.toInt64 else {
                    return
                }
                
                _realUnits += units
                
                _realCost += cost
                
                _realTotal += (units.toInt64 * cost)
                
            }
            
            realUnits = _realUnits.toString
            
            realCost = _realCost.toDouble.formatMoney
            
            realTotal = _realTotal.toDouble.formatMoney
            
            
        }
        
        func udpateItemBalance(itemId: UUID, status: CustOrderProjetcManagerItemStatus) {
            
            guard let view = itemRefrence[itemId] else {
                return
            }
            
            switch status {
            case .pending:
                break
            case .active:
                activeItemsView.appendChild(view)
            case .inrevsion:
                inrevisionItemsView.appendChild(view)
            case .aproved:
                doneItemsView.appendChild(view)
            case .canceled:
                break
            }
            
        }
    }
}

extension OrderView.OrderProject {
    
    fileprivate enum CurrentView {
        case workMap
        case charges
        //case details
    }
    
}
