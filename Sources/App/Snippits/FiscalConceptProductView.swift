//
//  FiscalConceptProductView.swift
//  
//
//  Created by Victor Cantu on 5/7/23.
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptProductView: Div {
    
    override class var name: String { "div" }
    
    let pocid: UUID
    
    /// Price that is tn the fiscal document
    let documentPrice: Int64
    
    /// When you do changes to  soc create a call back to parent view
    private var isEdited: ((
        _ pocid: UUID,
        _ upc: String,
        _ brand: String,
        _ model: String,
        _ name: String,
        _ cost: Int64,
        _ price: Int64,
        _ avatar: String
    ) -> ())
    
    private var isSwaped: ((
    ) -> ())
    
    init(
        pocid: UUID,
        documentPrice: Int64,
        isEdited: @escaping ( (
            _ pocid: UUID,
            _ upc: String,
            _ brand: String,
            _ model: String,
            _ name: String,
            _ cost: Int64,
            _ price: Int64,
            _ avatar: String
        ) -> ()),

        isSwaped: @escaping ((
        ) -> ())
    ) {
        self.pocid = pocid
        self.documentPrice = documentPrice
        self.isEdited = isEdited
        self.isSwaped = isSwaped
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var avatar = Img()
        .src("skyline/media/512.png")
        .objectFit(.contain)
        .height(100.percent)
        .width(100.percent)
    
    @State var upc = ""
    
    @State var brand = ""
    
    @State var model = ""
    
    @State var name = ""
    
    @State var descr = ""
    
    @State var price: Int64 = 0
    
    @State var cost: Int64 = 0
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Producto Relacionado")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Div{
                self.avatar
            }
            .custom("height", "calc(100% - 77px)")
            .width(50.percent)
            .float(.left)
            
            Div{
                
                Div{
                    Div("POC/ SKU / UPC")
                        .color(.gray)
                    H2(self.$upc)
                        .marginBottom(12.px)
                        .color(.white)
                    
                    Div("Marca")
                        .color(.gray)
                    H2(self.$brand)
                        .marginBottom(12.px)
                        .color(.white)
                
                    Div("Modelo")
                        .color(.gray)
                    H2(self.$model)
                        .marginBottom(12.px)
                        .color(.white)
                
                    Div("Nombre")
                        .color(.gray)
                    H2(self.$name)
                        .marginBottom(12.px)
                        .color(.white)
                    
                    Div("Costo")
                        .color(.gray)
                    H2{
                        Span(self.$cost.map{ $0.formatMoney })
                            .marginRight(7.px)
                        
                        Span(self.documentPrice.formatMoney)
                            .color(self.$price.map{ (self.cost < self.documentPrice) ? .red : .lightGreen })
                    }
                        .marginBottom(12.px)
                        .color(.white)
                
                    Div("Price")
                        .color(.gray)
                    H2( self.$price.map{ $0.formatMoney } )
                        .marginBottom(12.px)
                        .color(.white)
                
                }
                .margin(all: 7.px)
            }
            .custom("height", "calc(100% - 77px)")
            .width(50.percent)
            .float(.left)
            
            Div().class(.clear)
            
            Div{
                Div{
                    
                    Div("Editar Producto")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(95.percent)
                        .marginTop(0.px)
                        .onClick {
                            
                            let view = ManagePOC(
                                leveltype: .all,
                                levelid: nil,
                                levelName: "",
                                pocid: self.pocid,
                                titleText: "",
                                quickView: true
                            ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                                self.upc = upc
                                self.brand = brand
                                self.model = model
                                self.name = name
                                self.cost = cost
                                self.price = price
                            } deleted: {
                                
                            }
                            
                            addToDom(view)
                        }
                }
                .width(50.percent)
                .float(.left)
                Div{
                    
                    Div("Cabiar Relacion de Producto")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(95.percent)
                        .marginTop(0.px)
                        .onClick {
                            self.isSwaped()
                            self.remove()
                        }
                }
                .width(50.percent)
                .float(.left)
                
                Div().clear(.both)
            }
            
        }
        .custom("left", "calc(50% - 374px)")
        .custom("top", "calc(50% - 274px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .height(500.px)
        .width(700.px)
    }
    
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        loadingView(show: true)
        
        API.custPOCV1.getPOC(id: self.pocid, full: false) { resp in
            
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
                showError(.errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            self.upc = payload.poc.upc
            
            self.brand = payload.poc.brand
            
            self.model = payload.poc.model
            
            self.name = payload.poc.name
            
            self.cost = payload.poc.cost
            
            self.price = payload.poc.pricea
            
            if !payload.poc.avatar.isEmpty{
                if let pDir = customerServiceProfile?.account.pDir {
                    self.avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(payload.poc.avatar)")
                }
            }
            
        }
    }
}
