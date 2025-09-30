//
//  RewardsView.swift
//
//
//  Created by Victor Cantu on 2/16/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import TaecelAPICore
import Web

class RewardsView: PageController {
    
    override class var name: String { "div" }
    
    let accountId: UUID
    
    let mobile: String
    
    let cardId: String
    
    @State var points: Int
    
    init(
        accountId: UUID,
        mobile: String,
        cardId: String,
        points: Int
    ) {
        self.accountId = accountId
        self.mobile = mobile
        self.cardId = cardId
        self.points = points
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// airTime, packages, services, giftCards buttons
    lazy var rewardCategorie = Div()
    
    /// airTime, packages, services, giftCards
    @State var categorie: TaecelAPICore.Categorie? = nil
    
    /// waterBill, catalog, electricBill, cableBill, taxes, communicationBill, gasBill, busTickes, telvia, netweyInternet, other
    @State var subCategorie: TaecelAPICore.SubCategorie? = nil
    
    @State var categories: [TaecelAPICore.CategoriesItem] = []
    
    @State var subCategories: [TaecelAPICore.SubCategorie] = []
    
    var productCategorie: TaecelAPICore.CategoriesItem? = nil
    
    @State var products: [TaecelAPICore.ProductItem] = []
    
    @DOM override var body: DOM.Content {
     
        Div{
            
            Div{
                Img()
                    .closeButton(.view)
                    .hidden(self.$subCategories.map{ !$0.isEmpty })
                    .onClick {
                        self.remove()
                    }
                
                Img()
                    .src("/skyline/media/arrowBaclk_yellow.png")
                    .hidden(self.$subCategories.map{ $0.isEmpty })
                    .marginRight(12.px)
                    .float(.right)
                    .width(24.px)
                    .onClick {
                        self.subCategories.removeAll()
                        self.categorie = nil
                    }
                
                Div {
                    H2("⭐️ Recompensas")
                        .marginRight(7.px)
                        .color(.white)
                        .float(.left)
                    
                    H2(self.$points.map{ "\($0.toString) pts" })
                        .marginTop(4.px)
                        .color(.yellowTC)
                        .float(.left)
                    
                }
                .custom("width", "calc(100% - 70px)")
                .class(.oneLineText)
                .float(.left)
                
                Div().clear(.both)
            }
            
            Div{
                /// self.categorie = item
                self.rewardCategorie
                    .hidden(self.$subCategories.map{ !$0.isEmpty })
                
                Div{
                    ForEach(self.$subCategories) { subCategorie in
                        Div{
                            Span(subCategorie.description)
                                .fontSize(36.px)
                                .color(.white)
                        }
                            .class(.uibtnLarge)
                            .width(95.percent)
                            .onClick({ _, event in
                                self.subCategorie = subCategorie
                                //getRewardsSubCategories
                                event.stopPropagation()
                            })
                    }
                }
                .hidden(self.$subCategories.map{ $0.isEmpty })
            }
            .custom("height", "calc(100% - 35px)")
            .overflow(.auto)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left","calc(50% - 214px)")
        .custom("top","calc(50% - 289px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(500.px)
        .width(450.px)
     
        Div{
            Div{
                
                Div{
                    
                    Img()
                        .src("/skyline/media/arrowBaclk_yellow.png")
                        .marginRight(12.px)
                        .float(.right)
                        .width(24.px)
                        .onClick {
                            self.subCategories.removeAll()
                            self.categorie = nil
                        }
                    
                    Div{
                        
                        H2(self.$categorie.map{ "⭐️ \($0?.description ?? "")" })
                            .marginRight(7.px)
                            .float(.left)
                            .color(.white)
                        
                        H2(self.$points.map{ "\($0.toString) pts" })
                            .marginTop(4.px)
                            .color(.yellowTC)
                            .float(.left)
                        
                    }
                    .custom("width", "calc(100% - 70px)")
                    .class(.oneLineText)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                
                Div{
                    ForEach(self.$categories) { categorie in
                        
                        Div{
                            Span(categorie.name)
                                .fontSize(36.px)
                                .color(.white)
                        }
                            .class(.uibtnLarge)
                            .width(95.percent)
                            .onClick {
                                self.getProducts(carrierId: categorie.carrierId)
                            }
                        
                    }
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(50% - 214px)")
            .custom("top","calc(50% - 289px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(500.px)
            .width(450.px)
        }
        .hidden(self.$categories.map{ $0.isEmpty })
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
        Div{
            Div{
                
                Div{
                    
                    Img()
                        .src("/skyline/media/arrowBaclk_yellow.png")
                        .marginRight(12.px)
                        .float(.right)
                        .width(24.px)
                        .onClick {
                            self.productCategorie = nil
                            self.products.removeAll()
                        }
                    
                    Div{
                        
                        H2(self.$categorie.map{ "⭐️ \($0?.description ?? "")" })
                            .marginRight(7.px)
                            .float(.left)
                            .color(.white)
                        
                        H2(self.$points.map{ "\($0.toString) pts" })
                            .marginTop(4.px)
                            .color(.yellowTC)
                            .float(.left)
                        
                    }
                    .custom("width", "calc(100% - 70px)")
                    .class(.oneLineText)
                    .float(.left)
                    
                }
                
                Div().clear(.both)
                
                Div{
                    
                    ForEach(self.$products) { product in
                        Div{
                            
                            Span({ product.name.isEmpty ? product.carrierName : product.name }())
                            
                            Span( product.amount.toInt.toString )
                                .marginLeft(7.px)
                            
                            Span( ((product.amount + (self.productCategorie?.transactionFee ?? 0.0)) * 2 ).rounded().formatMoney + " pts")
                                .color(.yellowTC)
                                .float(.right)
                            
                            Div().clear(.both)
                            
                            Div(product.description)
                                .class(.twoLineText)
                                .fontSize(16.px)
                                .color(.white)
                            
                            Div().clear(.both)
                            
                            Span("\(product.validity)")
                                .fontSize(14.px)
                                .color(.gray)

                        }
                        .class(.uibtnLarge)
                        .width(95.percent)
                        .onClick {
                            
                            guard let categorie = self.productCategorie else {
                                print("❌ categorie not seta")
                                return
                            }
                            
                            print("🟢  add To dom")
                            
                            addToDom(RequestView(
                                accountId: self.accountId,
                                cardId: self.cardId,
                                mobile: self.mobile,
                                product: product,
                                categorie: categorie,
                                points: self.$points
                            ))
                            
                        }
                    }
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(50% - 214px)")
            .custom("top","calc(50% - 289px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(500.px)
            .width(450.px)
        }
        .hidden(self.$products.map{ $0.isEmpty })
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        TaecelAPICore.Categorie.allCases.forEach { item in
            
            if item.isRewardsAvailable {
                rewardCategorie.appendChild(
                    
                    Div{
                        Span(item.description)
                            .fontSize(36.px)
                            .color(.white)
                        
                        Div().height(7.px).clear(.both)
                        
                        Span(item.helpText)
                            .fontSize(16.px)
                            .color(.gray)
                        
                    }
                        .class(.uibtnLarge)
                        .width(95.percent)
                        .onClick {
                            self.categorie = item
                        }
                )
            }
            
        }
        
        $categorie.listen {
            
            self.categories = []
            
            guard let categorie = $0 else{
                return
            }
            
            self.getRewardsCategories()
            
        }
        
        $subCategorie.listen {
            
            // self.subCategories = []
            
            guard let subCategorie = $0 else {
                return
            }
            
            self.getRewardsSubCategories()
            
        }
        
    }
    
    func getRewardsCategories(){
        
        guard let categorie else {
            showError(.errorGeneral, "Seleccione Categoria")
            return
        }
        
        var rewards = true
        
        switch categorie {
        case .airTime, .packages:
            break
        case .services:
            
            var subCategories: [TaecelAPICore.SubCategorie] = []
            
            TaecelAPICore.SubCategorie.allCases.forEach { subCategorie in
                if !subCategorie.isRewardsAvailable {
                    subCategories.append(subCategorie)
                }
            }
            
            self.subCategories = subCategories.sorted { $0.description < $1.description }
            
            rewards = false
            
            return
        case .giftCards:
            
            var subCategories: [TaecelAPICore.SubCategorie] = []
            
            TaecelAPICore.SubCategorie.allCases.forEach { subCategorie in
                if subCategorie.isRewardsAvailable {
                    subCategories.append(subCategorie)
                }
            }
            
            self.subCategories = subCategories.sorted { $0.description < $1.description }
            
            return
        }
        
        loadingView(show: true)
        
        API.rewardsV1.getCategorie(
            categorie: categorie,
            subCategorie: nil,
            rewards: rewards
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
            
            guard let categories = resp.data else {
                showError(.errorGeneral, "un expencted missing payload")
                return 
            }

            self.categories = categories
            
        }
    }
    
    func getRewardsSubCategories(){
        
        guard let categorie else {
            showError(.errorGeneral, "Seleccione Categoria")
            return
        }
        
        guard let subCategorie else {
            showError(.errorGeneral, "Seleccione Sub Categoria")
            return
        }
    
        loadingView(show: true)
        
        API.rewardsV1.getCategorie(
            categorie: categorie,
            subCategorie: subCategorie,
            rewards: categorie != .services
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
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.categories = data
            
        }
    }
    
    
    
    func getProducts(carrierId: String) {
        
        if carrierId.isEmpty {
            showError(.errorGeneral, "Falta CarrierId")
            return
        }
        
        loadingView(show: true)
        
        API.rewardsV1.getProducts(
            carrierId: carrierId
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

            self.productCategorie = payload.categorie
            
            self.products = payload.products
            
        }
    }
    
}


