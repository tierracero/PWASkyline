//
//  OrderRowView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import Web

class OrderRowView: Div {
    
    override class var name: String { "div" }
    
    let folio: String

    let typeOrder: String
    
    @State var uname = "..."
    
    let createDate: String

    let timeElaps: String

    let balance: String
    
    @State var alerted: Bool = false
    
    @State var highPriority: Bool = false
    
    @State var budget: CustBudgetManagerStatus? = nil
    
    @State var budgetIcon = ""
    
    var data: CustOrderLoadFolios

    @State private var statusColor: Color
    
    private var callback: () -> Void

    init(
        data: CustOrderLoadFolios,
        callback: @escaping () -> Void
    ) {
        self.data = data
        self.callback = callback
        self.statusColor = data.status.color
        self.folio = Self.formattedFolio(data.folio)
        self.typeOrder = Self.orderTypeLabel(data.type)
        self.createDate = getDate(data.createdAt).formatedLong
        self.timeElaps = orderTimeMesure(
            uts: data.createdAt,
            type: .createdAt
        ).timeString
        self.balance = "$\(data.balance.formatMoney)"
        self.dateView = Self.makeDateView(data.due)
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let dateView: Div
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Folio / Status Details
            Div{
                H2(self.folio)
                Div{
                    H2(self.typeOrder)
                        .textAlign(.center)
                        .width(28.px)
                        .height(28.px)
                        .borderRadius(all: 24.px)
                        .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.5))
                        .marginTop(3.px)
                        .marginLeft(7.px)
                        .float(.left)
                        .hidden(configStoreProcessing.moduleProfile.count == 1)
                        .color(.black)
                }
                Div().class(.clear)

                Div(self.$uname)
                    .class(.oneLineText)
                    .paddingTop(3.px)
            }
            .color(.white)
            .align(.center)
            .float(.left)
            .width(80.px)
            
            /// General 0Details  and Alerts
            Div{
                /// General Details
                Div{
                    Div{
                        
                        Span(self.createDate)
                            .paddingRight(7.px)
                        
                        Strong(self.timeElaps)
                            .color(.black)
                        
                        Strong(self.balance)
                            .float(.right)
                        
                    }
                    .color(.gray)
                    
                    Div(self.data.description.replace(from: "\n", to: " "))
                        .class(.oneLineText)
                        .marginBottom(3.px)
                        .fontWeight(.bolder)
                        .fontSize(24.px)
                        .marginTop(3.px)
                    
                    Div(self.data.smallDescription)
                        .class(.oneLineText)
                        .marginBottom(3.px)
                        .color(.grayBlack)
                        .fontSize(16.px)
                    
                    if !self.data.address.isEmpty {
                        Div(self.data.address)
                            .class(.oneLineText)
                            .fontSize(16.px)
                            .color(.gray)
                    }
                    
                }
                .custom("width", "calc(100% - 130px)")
                .float(.left)
                
                /// Visial ControlersUser and Folio
                Div{
                    Div{
                        
                        Img()
                            .src("/skyline/media/icons_high_priority.png")
                            .hidden(self.$highPriority.map{ !$0 })
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Img()
                            .src("/skyline/media/icons_alert.png")
                            .hidden(self.$alerted.map{ !$0 })
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Img()
                            .src(self.$budgetIcon)
                            .hidden(self.$budget.map{ $0 == nil })
                            .height(24.px)
                        
                    }
                    
                    Div(self.data.name)
                        .class(.twoLineText)
                        .fontSize(20.px)
                        .color(.black)
                    
                    self.dateView
                        .fontSize(20.px)
                        .class(.oneLineText)
                }
                .align(.right)
                .float(.right)
                .width(125.px)
                
            }
            .float(.right)
            .custom("width", "calc(100% - 92px)")
            .class(.smallButtonBox)
            .border(width: .thin, style: .solid, color: self.$statusColor.map{  $0 ?? .white})
            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.77))
            
            Div().class(.clear)
            
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        /// Adjust View
        self.class(.smallButtonBox)
        backgroundColor(self.data.status.color)

        /*
        onMouseOver {
            self.quickTools
                .maxHeight(500.px)
                .custom("transition", "all 1200ms ease-in-out 300ms")
        }
        
        onMouseLeave {
            self.quickTools
                .maxHeight(0.px)
                .transitionDelay(.milliseconds(6000))
                .custom("transition", "max-height 1ms ease-in-out")
        }
        */

        onClick {
            self.callback()
        }
        
        $budget.listen {
            switch $0 {
            case .budgetRequested:
                self.budgetIcon = "/skyline/media/icon_budgets_required.png"
            case .preparing:
                self.budgetIcon = "/skyline/media/icon_budgets_inprogress.png"
            case .prepared, .pendingAproval:
                self.budgetIcon = "/skyline/media/icon_budgets_ready.png"
            case .approved, .canceled, nil:
                 break
            }
        }
        
        if let activeUser = data.activeUser {

            getUserRefrence(id: .id(activeUser)) { user in
                
                guard let user = user else {
                    return
                }
                
                self.uname = user.username.explode("@").first ?? user.firstName
                
            }
        }
        
        alerted = data.alerted
        
        highPriority = data.highPriority
        
        budget = data.budget
        
    }

    func applyStatus(_ status: CustFolioStatus) {
        data.status = status
        statusColor = status.color
        backgroundColor(status.color)
        borderLeft(
            width: .thick,
            style: .solid,
            color: status.color
        )
    }

    private static func formattedFolio(_ folio: String) -> String {
        guard folio.contains("-") else {
            return ""
        }

        let parts = folio.explode("-")
        return parts.count > 1 ? parts[1] : folio
    }

    private static func orderTypeLabel(
        _ type: FolioTypes
    ) -> String {
        switch type {
        case .folio:
            return "S"
        case .date:
            return "C"
        case .sale:
            return "V"
        case .rental:
            return "R"
        case .mercadoLibre:
            return "M"
        case .claroShop:
            return "CS"
        case .amazon:
            return "A"
        case .ebay:
            return "E"
        }
    }

    private static func makeDateView(_ dueDate: Int64?) -> Div {
        guard let dueDate else {
            return Div()
        }

        let calculation = orderTimeMesure(uts: dueDate, type: .date)
        let view = Div(calculation.timeString)
            .fontSize(24.px)

        switch calculation.color {
        case .blue:
            break
        case .green:
            view.color(.green)
        case .orange:
            view.color(.orange)
        case .red:
            view.color(.red)
        }

        return view
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $uname.removeAllListeners()
        $alerted.removeAllListeners()
        $highPriority.removeAllListeners()
        $budget.removeAllListeners()
        $budgetIcon.removeAllListeners()
    }
}
