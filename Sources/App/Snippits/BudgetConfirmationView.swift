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
    
    @State var custAcct: CustAcctSearch?
    let comment: String
    let store: UUID
    let saleType: FolioTypes
    let kart: [SalePointObject]
    
    private var callback: ((
        _ type: BudgetType,
        _ budgetid: UUID,
        _ budgetfolio: String,
        _ fiscalProfile: UUID?,
        _ showTaxes: Bool,
        _ custAcct: CustAcctSearch
    ) -> ())
    
    init(
        custAcct: CustAcctSearch?,
        comment: String,
        store: UUID,
        saleType: FolioTypes,
        kart: [SalePointObject],
        callback: @escaping ((
            _ type: BudgetType,
            _ budgetid: UUID,
            _ budgetfolio: String,
            _ fiscalProfile: UUID?,
            _ showTaxes: Bool,
            _ custAcct: CustAcctSearch
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

    lazy var firstNameField = InputText( self.$custAcct.map{ $0?.firstName ?? "" } )
        .custom("width", "calc(100% - 30px)")
        .placeholder("Primer Nombre")
        .class(.textFiledBlackDark)
        .disabled(true)
    
    lazy var lastNameField = InputText( self.$custAcct.map{ $0?.lastName ?? "" } )
        .custom("width", "calc(100% - 30px)")
        .placeholder("Primer Apellido")
        .class(.textFiledBlackDark)
        .disabled(true)


    @State var showTaxes: Bool = false
    
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Ingrese información de presupuesto")
                    .color(.lightBlueText)
                
                Div().class(.clear).marginTop(7.px)
                
                Div{

                    Div("Seleccionar cliente")
                    .custom("width", "calc(100% - 32px)")
                    .class(.uibtnLargeOrange)
                    .margin(all: 12.px)
                    .align(.center)
                    .onClick {

                        self.selectCustomer()
                    
                    }

                }
                .hidden(self.$custAcct.map{ $0 != nil })
                
                Div{

                    if fiscalProfiles.count > 0 {
                    
                        H2("Perfil de facturacion ")
                            .color(.lightBlueText)
                        
                        Div()
                            .marginTop(3.px)
                            .class(.clear)
                        
                        self.selectedFiscalProfileSelect
                        
                        Div().class(.clear).marginTop(7.px)
                    }
                    
                    Div{

                        H2("Datos del Cliente")
                            .color(.lightBlueText)
                        
                        Div().marginTop(3.px).class(.clear)
                        
                        Div{
                            
                            Span("Primer Nombre")
                                .color(.white)
                                Div().marginTop(3.px).class(.clear)
                            
                            self.firstNameField
                            
                            Div().class(.clear)
                            
                        }
                        .class(.oneTwo)
                        
                        Div{
                            
                            Span("Primer Apellido")
                                .color(.white)

                            Div().marginTop(3.px).class(.clear)
                            
                            self.lastNameField
                            
                            Div().class(.clear)
                        }
                        .class(.oneTwo)
                        
                        Div().class(.clear).marginTop(7.px)
                        
                    }

                    
                    Div().marginTop(3.px).class(.clear)
                    
                    Div {

                    }
                    .width(50.percent)
                    .height(35.px)
                    .float(.left)

                    Div {
                        InputCheckbox(self.$showTaxes)
                        .id(.init("showTaxes"))
                        Label("IVA Desglosado")
                        .for("showTaxes")
                        .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().marginTop(3.px).class(.clear)

                    H2("Selccione Opción")
                        .color(.lightBlueText)
                    
                    Div().marginTop(3.px).class(.clear)
                    
                    Div {
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
                        .width(90.percent)
                        .onClick {
                            self.requestBudget(.print)
                        }
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/sendToMobile.png")
                                .class(.iconWhite)
                                .marginRight(7.px)
                                .marginLeft(7.px)
                                .height(18.px)
                            
                            Span(self.$custAcct.map{ "Enviar a movil \($0?.mobile ?? "")" })
                        }
                        .hidden(self.$custAcct.map{ ($0?.mobile ?? "" ).isEmpty })
                        .class(.uibtnLarge)
                        .width(90.percent)
                        .onClick {
                            self.requestBudget(.send)
                        }
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().class(.clear).marginTop(7.px)

                
                }
                .hidden(self.$custAcct.map{ $0 == nil })

                Div().class(.clear).marginTop(7.px)
                
            }
            .marginBottom(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("top", "calc(50% - 124px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        
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

        if custAcct == nil {
            selectCustomer()
        }
    }
    
    func requestBudget(_ type: BudgetType) {
        
        guard let custAcct else {
            showError(.generalError, "No se localizo cuenta del cliente")
            return
        }

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

            Console.clear()
            
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎")
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎")
            
            
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            print(self.selectedFiscalProfileListener)
            
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎")
            print("⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎   ⭐️   💎")
            


            self.callback(type, id, folio,  UUID(uuidString: self.selectedFiscalProfileListener), self.showTaxes, custAcct)
            
            self.remove()
            
        }
        
    }
    
     func selectCustomer(){
        
            let view = SearchCustomerQuickView { account in
                self.custAcct = account
            } create: { term in
                /// No customer, create cuatomer.
                addToDom(CreateNewCusomerView(
                    searchTerm: term,
                    custType: .general,
                    callback: { acctType, custType, searchTerm in
                        
                        let custDataView = CreateNewCustomerDataView(
                            acctType: acctType,
                            custType: custType,
                            orderType: nil,
                            searchTerm: searchTerm
                        ) { account in
                            self.custAcct = account
                        }

                        self.appendChild(custDataView)
                        
                    }))
            }

            addToDom(view)
            
    }

}
extension BudgetConfirmationView {
    
    public enum BudgetType: String {
        case print
        case send
    }
    
}
