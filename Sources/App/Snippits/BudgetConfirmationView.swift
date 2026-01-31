//
//  BudgetConfirmationView.swift
//  
//
//  Created by Victor Cantu on 2/3/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class BudgetConfirmationView: Div {
    
    override class var name: String { "div" }
    
    let custAcct:  CustAcctSearch
    let comment: String
    let store: UUID
    let saleType: FolioTypes
    let kart: [SalePointObject]
    
    private var callback: ((
        _ type: BudgetType,
        _ budgetid: UUID,
        _ budgetfolio: String,
        _ fiscalProfile: UUID?
    ) -> ())
    
    init(
        custAcct: CustAcctSearch,
        comment: String,
        store: UUID,
        saleType: FolioTypes,
        kart: [SalePointObject],
        callback: @escaping ((
            _ type: BudgetType,
            _ budgetid: UUID,
            _ budgetfolio: String,
            _ fiscalProfile: UUID?
        ) -> ())
    ) {
        self.custAcct = custAcct
        self.comment = comment
        self.store = store
        self.saleType = saleType
        self.kart = kart
        self.callback = callback
        super.init()
    }
    
    @State var selectedFiscalProfileListener = ""
    
    lazy var selectedFiscalProfileSelect = Select(self.$selectedFiscalProfileListener)
        .body(content: {
            Option("Seleccione Perfil Fiscal (Opcional)")
                .value("")
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Seleccione tipo de presupuesto")
                    .color(.lightBlueText)
                
                Div().class(.clear).marginTop(7.px)
                
                if fiscalProfiles.count > 0 {
                
                    self.selectedFiscalProfileSelect
                    
                    Div().class(.clear).marginTop(7.px)
                }
                
                Div{
                    
                    Img()
                        .src("/skyline/media/icon_print.png")
                        .class(.iconWhite)
                        .marginRight(7.px)
                        .marginLeft(7.px)
                        .height(18.px)
                    
                    Span("Descargar e Imprimir")
                }
                .class(.uibtnLarge)
                .width(95.percent)
                .onClick {
                    self.requestBudget(.print)
                }
                
                Div().class(.clear).marginTop(7.px)
                
                Div{
                    
                    Img()
                        .src("/skyline/media/sendToMobile.png")
                        .class(.iconWhite)
                        .marginRight(7.px)
                        .marginLeft(7.px)
                        .height(18.px)
                    
                    Span("Enviar a movil \(self.custAcct.mobile)")
                }
                .class(.uibtnLarge)
                .width(95.percent)
                .onClick {
                    self.requestBudget(.send)
                }
                
                Div().class(.clear).marginTop(7.px)
                
            }
            .marginBottom(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(50.percent)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        fiscalProfiles.forEach { profile in
            selectedFiscalProfileSelect.appendChild(
                Option("\(profile.rfc) \(profile.razon)")
                    .value(profile.id.uuidString)
            )
        }
        
        
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func requestBudget(_ type: BudgetType) {
     
        loadingView(show: true)
        
        API.custPDVV1.createBudgetReport(
            fiscalProfile: UUID(uuidString: selectedFiscalProfileListener),
            budgetid: nil,
            custAcct: custAcct.id,
            comment: comment,
            store: store,
            saleType: saleType,
            saleObjects: kart.map{ $0.data }
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let id = resp.id else{
                showError(.unexpectedResult, "No se obtivo payload de data [id]")
                return
            }
            
            guard let folio = resp.folio else{
                showError(.unexpectedResult, "No se obtivo payload de data [folio]")
                return
            }
            
            showSuccess(.operacionExitosa, "Presupuesto creado \(folio)", .long)
            
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ")
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ")
            
            
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ")
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ")
            
            self.callback(type, id, folio,  UUID(uuidString: self.selectedFiscalProfileListener))
            
            self.remove()
            
        }
        
    }
    
}
extension BudgetConfirmationView {
    
    public enum BudgetType: String {
        case print
        case send
    }
    
}
