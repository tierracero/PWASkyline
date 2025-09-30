//
//  SearchChargeView.swift
//
//
//  Created by Victor Cantu on 7/8/22.
//
import Foundation
import TCFundamentals
import Web

class SearchChargeView: Div {
    
    override class var name: String { "div" }
    
    var name = ""
    
    var upc = "N/A"
    
    var cost: Int64 = 0
    
    let avatar = Img()
        .src("/skyline/media/512.png")
        .borderRadius(all: 12.px)
        .marginRight(7.px)
        .objectFit(.cover)
        .height(50.px)
        .width(50.px)
        .float(.left)
    
    let data: SearchChargeResponse
    
    /// cost_a, cost_b, cost_c
    let costType: CustAcctCostTypes
    
    private var callback: ((_ data: SearchChargeResponse) -> ())
    
    init(
        data: SearchChargeResponse,
        costType: CustAcctCostTypes,
        callback: @escaping ((_ data: SearchChargeResponse) -> ())
    ) {
        
        self.data = data
        
        self.costType = costType
        
        self.callback = callback
        
        name = data.n
            .replace(from: data.b, to: "")
            .replace(from: data.m, to: "")
        
        if !self.data.b.isEmpty {
            name = data.b
        }
        
        if !self.data.m.isEmpty {
            name = "\(data.m) \(name)"
        }
        
        name = name.purgeSpaces
        
        cost = data.p
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
        
    @DOM override var body: DOM.Content {
        
        self.avatar
            .float(.left)
        
        Div(self.name)
        .custom("width", "calc(100% - 200px)")
        .class(.twoLineText)
        .marginRight(7.px)
        .fontSize(18.px)
        .float(.left)
        
        Div{
            Div(self.cost.formatMoney)
                .class(.oneLineText)
                .marginTop(12.px)
                .color(.white)
        }
        .class(.oneLineText)
        .width(130.px)
        .align(.right)
        .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        self.class(.rowItem, .hiddeToolItem)
        
        margin(all: 7.px)
        
        onClick {
            self.callback(self.data)
        }
        
        switch data.t {
        case .service:
            if !data.a.isEmpty {
                avatar.load("contenido/thump_\(data.a)")
            }
        case .product:
            if !data.a.isEmpty {
                if let pDir = customerServiceProfile?.account.pDir {
                    avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(data.a)")
                }
            }
        case .manual:
            break
        case .rental:
            break
        }
        
    }
    
}
