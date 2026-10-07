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
    
    var title = ""
    
    var subTitle = ""

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

        self.cost = data.p
        
        var name = data.n
        .lowercased()
        .purgeSpaces

        let brand = data.b
        .lowercased()
        .purgeSpaces

        let model = data.m
        .lowercased()
        .purgeSpaces

        let upc = data.u
        .lowercased()
        .purgeSpaces

        name = name
        .replace(from: brand, to: "")
        .replace(from: model, to: "")
        .replace(from: upc, to: "")
        
        if name.isEmpty {

            self.title = "\(brand) \(model)"

            if !self.title.isEmpty {
                self.subTitle  = upc
            }
            else {
                self.title  = upc
            }
            
        }
        else {

            if name.count > 7 {
                self.title = name
                self.subTitle = "\(upc) \(model) \(brand) "
            }
            else {
                self.title = "\(brand) \(name)"
                self.subTitle = "\(upc) \(model)"
            }

        }

        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
        
    @DOM override var body: DOM.Content {
        
        self.avatar
            .float(.left)
        
        Div {
            Div(self.title)
            .class(.twoLineText)
            .fontSize(20.px)
            .color(.white)

            Div(self.subTitle)
            .class(.twoLineText)
            .fontSize(16.px)
            .color(.gray)

        }
        .custom("width", "calc(100% - 200px)")
        .marginRight(7.px)
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
        case .inventory:
            break
        }
        
    }
    
}
