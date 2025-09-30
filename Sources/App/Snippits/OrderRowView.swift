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
    
    var folio = ""
    var typeOrder = ""
    var icon = Img()
        .rowDefaultImage128
        .height(35.px)
        .class(.iconWhite)
        .marginTop(7.px)
    
    @State var uname = "..."
    
    @State var createDate = "..."
    @State var timeElaps = "..."
    @State var balance = "..."
    
    
    @State var alerted: Bool = false
    
    @State var highPriority: Bool = false
    
    @State var budget: CustBudgetManagerStatus? = nil
    
    @State var budgetIcon = ""
    
    var data: CustOrderLoadFolios
    
    private var callback: ((_ action: OrderAction?) -> ())
    ///OrderAction
    init(
        data: CustOrderLoadFolios,
        callback: @escaping ((_ action: OrderAction?) -> ())
    ) {
        self.data = data
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var dateView = Div()
    
    lazy var quickTools = Div()
        .custom("width", "calc(100% - 12px)")
        .marginRight( 7.px)
        .marginLeft( 7.px)
        .overflow(.hidden)
        .maxHeight(0.px)
        .align(.right)
    
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
                    self.icon
                        .paddingTop(3.px)
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
                        
                        Span(self.$createDate)
                            .paddingRight(7.px)
                        
                        Strong(self.$timeElaps)
                            .color(.black)
                        
                        Strong(self.$balance)
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
                        .fontSize(14.px)
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
            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.77))
            
            Div().clear(.both)
            
            self.quickTools
                
            
            Div().class(.clear)
            
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        /// Adjust View
        self.class(.smallButtonBox)
        backgroundColor(self.data.status.color)
        
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
        
        onClick {
            self.callback(.open)
        }
        
        if data.folio.contains("-") {
            let parts = data.folio.explode("-")
            if parts.count > 1 {
                folio = parts[1]
            }
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
        
        icon = self.data.status.whiteIcon128
            .width(28.px)
        
        quickTools.appendChild(Div().marginTop(7))
        
        switch self.data.status {
        case .pending:
            self.quickTools.appendChild(
                Div("Adoptar")
                    .border(width: .thin, style: .solid, color: .white)
                    .color(.white).float(.left)
                    .paddingTop(3.px)
                    .paddingBottom(3.px)
                    .paddingLeft(7.px)
                    .paddingRight(7.px)
                    .borderRadius(all: 7.px)
                    .onClick{ div, event in
                        print("adoptme!!")
                        self.callback(.adopt)
                        event.stopPropagation()
                    }
            )
        case .active:
            break
        case .pendingSpare:
            break
        case .canceled:
            break
        case .finalize:
            break
        case .archive:
            break
        case .collection:
            break
        case .sideStatus:
            break
        case .saleWait:
            break
        }
        
        switch self.data.type{
        case .folio:
            typeOrder = "S"
        case .date:
            typeOrder = "C"
        case .sale:
            typeOrder = "V"
        case .rental:
            typeOrder = "R"
        case .mercadoLibre:
            typeOrder = "M"
        case .claroShop:
            typeOrder = "CS"
        case .amazon:
            typeOrder = "A"
        case .ebay:
            typeOrder = "E"
        }
        
        /// Alert
        self.quickTools.appendChild(
            Img()
                .src("/skyline/media/icon_alert.png")
                .width(28.px)
                .marginLeft(12.px)
                .class(.iconWhite)
                .onClick({ img, event in
                    self.callback(.alert)
                    event.stopPropagation()
                })
        )
        
        /// Date
        if data.type != .rental {
            self.quickTools.appendChild(
                Img()
                    .src("/skyline/media/icon_add_date.png")
                    .width(28.px)
                    .marginLeft(12.px)
                    .class(.iconWhite)
                    .onClick({ img, event in
                        self.callback(.date)
                        event.stopPropagation()
                    })
            )
        }
        
        /// New Message
        self.quickTools.appendChild(
            Img()
                .src("/skyline/media/icon_add_message.png")
                .width(28.px)
                .marginLeft(12.px)
                .class(.iconWhite)
                .onClick({ img, event in
                    self.callback(.addNote)
                    event.stopPropagation()
                })
        )
        
        /// Print
        self.quickTools.appendChild(
            Img()
                .src("/skyline/media/icon_print.png")
                .width(28.px)
                .marginLeft(12.px)
                .class(.iconWhite)
                .onClick({ img, event in
                    self.callback(.print)
                    event.stopPropagation()
                })
        )
        
        if let activeUser = data.activeUser {
            getUserRefrence(id: .id(activeUser)) { user in
                
                guard let user = user else {
                    return
                }
                
                self.uname = user.firstName
                
                if user.username.contains("@") {
                    if let _user = user.username.explode("@").first {
                        self.uname = "@\(_user)"
                    }
                }
                
            }
        }
        
        if let dueDate = data.due {
            let calc = orderTimeMesure(uts: dueDate, type: .date)
            
            let _div = Div(calc.timeString)
                .fontSize(24.px)
            
            switch calc.color {
            case .blue:
                break
            case .green:
                _div.color(.green)
            case .orange:
                _div.color(.orange)
            case .red:
                _div.color(.red)
            }
            
            self.dateView = _div
            
        }
        
        let _calc = orderTimeMesure(uts: self.data.createdAt, type: .createdAt)
        
        let date = getDate(self.data.createdAt)
        
        createDate = date.formatedLong
        
        timeElaps = _calc.timeString
        
        balance = "$\( self.data.balance.formatMoney)"
        
        alerted = data.alerted
        
        highPriority = data.highPriority
        
        budget = data.budget
        
    }
}

