//
//  ToolProductAuditTrRow.swift
//  
//
//  Created by Victor Cantu on 8/28/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolProductAuditTrRow: Tr {
    
    override class var name: String { "tr" }
    
    var rowNumber: Int
    
    var item: CustPOCAuditItem
    
    var vendors: [API.custPOCV1.POCVendor]
    
    private var callback: ((
    ) -> ())
    
    init(
        rowNumber: Int,
        item: CustPOCAuditItem,
        vendors: [API.custPOCV1.POCVendor],
        callback: @escaping ((
        ) -> ())
    ) {
        self.rowNumber = rowNumber
        self.item = item
        self.vendors = vendors
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var isReady = false
    
    @State var cost = ""
    
    @State var price = ""
    
    @State var link1 = ""
    
    @State var link2 = ""
    
    @State var section = ""
    
    var pDir = ""
    
    lazy var avatar = Img()
        .src("skyline/media/tierraceroRoundLogoBlack.svg")
        .width(50.px)
        .height(50.px)
    
    lazy var costInput = InputText(self.$cost)
        .class(.textFiledLight)
        .disabled(true)
        .textAlign(.right)
        .width(83.px)
    
    lazy var priceInput = InputText(self.$price)
        .class(.textFiledLight)
        .textAlign(.right)
        .width(83.px)
    
    lazy var link1Input = TextArea(self.$link1)
        .fontSize(10.px)
        .disabled(true)
        .class(.textFiledLight)
        .height(45.px)
        .width(175.px)
    
    lazy var link2Input = TextArea(self.$link2)
        .fontSize(10.px)
        .class(.textFiledLight)
        .height(45.px)
        .width(175.px)
    
    var vendorRefrence: [UUID:Div] = [:]
    
    @DOM override var body: DOM.Content {
        Td(self.rowNumber.toString)
        Td{
            self.avatar
                .cursor(.pointer)
                .onClick {
                    
                    addToDom(MediaViewer(
                        relid: self.item.pocid,
                        type: .product,
                        url: "https://intratc.co/cdn/\(self.pDir)/",
                        files: [.init(
                            fileId: nil,
                            file: self.item.avatar,
                            avatar: self.item.avatar,
                            type: .image
                        )],
                        currentView: 0
                    ))
                    
                }
        }
        Td {
            Img()
                .src("/skyline/media/maximizeWindow.png")
                .margin(all: 3.px)
                .cursor(.pointer)
                .paddingTop(7.px)
                .float(.right)
                .width(18.px)
                .onClick {
                    _ = JSObject.global.openTab!( "https://google.com/search?q=" + self.item.name.replace(from: " ", to: "+") )
                }
            
            Div(self.item.name)
                .custom("width", "calc(100% - 24px)")
        }
        Td{
            self.costInput
        }
        Td{
            self.priceInput
        }
        Td{
            self.link1Input
        }
        Td{
            self.link2Input
        }
        Td{
            Div{
                Div{
                    Span("Sec")
                    Span(self.$section).float(.right)
                }
                
                
                Div{
                    Span("Unis")
                    Span(self.item.items.toString).float(.right)
                }
                
                Div().class(.clear).marginTop(3.px)
            }
            .custom("width", "calc(100% - 25px)")
            .float(.left)
            
            Div{
                Img()
                    .src("/skyline/media/pencil.png")
                    .margin(all: 3.px)
                    .cursor(.pointer)
                    .paddingTop(7.px)
                    .width(18.px)
                    .onClick {
                        addToDom(
                            ManagePOC(
                                leveltype: .all,
                                levelid: nil,
                                levelName: "",
                                pocid: self.item.pocid,
                                titleText: "",
                                quickView: false
                            ){ pocid, upc, brand, model, name, cost, price, avatar in
                                self.price = price.formatMoney
                            } deleted: {
                                self.remove()
                            }
                        )
                        
                    }
            }
            .width(23.px)
            .float(.right)
        }
        
        Td{
            Div(self.$isReady.map{ $0 ? "Listo" : "Guardar" })
                .backgroundColor(self.$isReady.map{ $0 ? .green : .orangeRed })
                .cursor(.pointer)
                .padding(top: 5.px, right: 10.px, bottom: 5.px, left: 10.px)
                .margin(top: 5.px, right: 3.px, bottom: 5.px, left: 0.px)
                .custom("width", "fit-content")
                .onClick(self.markAsReady)
                .borderRadius(all: 12.px)
                .color(.white)
        }
        .align(.center)
    }
    
    override func buildUI() {
        super.buildUI()
        
        cost = item.cost.formatMoney
        
        price = item.price.formatMoney
        
        link1 = item.link1
        
        link2 = item.link2
        
        isReady = item.isReady
        
        if !item.avatar.isEmpty {
            if let pDir = customerServiceProfile?.account.pDir {
                avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(item.avatar)")
            }
        }
        
        pDir = customerServiceProfile?.account.pDir ?? ""
        
        if !rowNumber.isEven {
            self.backgroundColor(.init(r: 240, g: 240, b: 240))
        }
        
//        vendors.forEach { vendor in
//
//            let _div = Div(vendor.vendorName)
//                .class(.uibutton, .oneLineText)
//                .overflow(.hidden)
//                .width(130.px)
//
//            vendorRefrence[vendor.vendorid] = _div
//
//            providerGrid.appendChild(_div)
//        }
        
        if let id = item.seccion {
            if let name = seccions[id]?.name {
                section = name
            }
        }
        
        
    }
    
    func markAsReady(){
        
        guard !cost.isEmpty else {
            showError(.errorGeneral, "Ingrese Costo")
            self.costInput.select()
            return
        }
        
        guard let _cost = Float(self.cost)?.toCents else{
            showError(.errorGeneral, "Ingrese Costo valido")
            self.costInput.select()
            return
        }
        
        guard !price.isEmpty else {
            showError(.errorGeneral, "Ingrese Precio")
            self.priceInput.select()
            return
        }
        
        guard let _price = Float(self.price.replace(from: ",", to: "").replace(from: "$", to: ""))?.toCents else{
            showError(.errorGeneral, "Ingrese Precio valido")
            self.priceInput.select()
            return
        }
        
//        guard !link1.isEmpty else {
//            showError(.errorGeneral, "Ingrese Costo")
//            //self.link1Input.select()
//            return
//        }

//        guard !link2.isEmpty else {
//            showError(.errorGeneral, "Ingrese Costo")
//            //self.link2Input.select()
//            return
//        }
        
        API.custPOCV1.savePOCAuditItem(
            itemid: item.auditid,
            cost: _cost,
            price: _price,
            link1: link1,
            link2: link2
        ) { resp in
            
            guard let resp = resp else {
                loadingView(show: false)
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                loadingView(show: false)
                showError(.errorGeneral, resp.msg)
                return
            }
            
            self.isReady = true
            
            self.callback()
            
        }
    }
}
