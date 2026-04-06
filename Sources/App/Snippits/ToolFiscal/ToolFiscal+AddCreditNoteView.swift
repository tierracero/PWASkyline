//
//  ToolFiscal+AddCreditNoteView.swift
//  
//
//  Created by Victor Cantu on 10/21/26.
// searchAccountFiscal

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolFiscal.AddCreditNoteView {
    
    enum CreditReason: String, CaseIterable {
        case `return`
        case discount

        var description: String {
            switch self {
                case .return:
                    return "Regreso de Mercacian"
                case .discount:
                    return "Descuento Monetario"
            }
        }

    }
}

extension ToolFiscal {
       
    class AddCreditNoteView: Div {
        
        override class var name: String { "div" }
        
        /// Fiscal Documnet
        var doc: FIAccountsServices
        
        let account: CustAcctFiscal
        
        private let callback: (
            _ item: FIAccountsServices
        ) -> Void

        init(
            doc: FIAccountsServices,
            account: CustAcctFiscal,
            callback: @escaping (
                _ item: FIAccountsServices
            ) -> Void
        ) {
            self.doc = doc
            self.account = account
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        
        @State var comment = ""

        @State var creditReasonSelectListener = ""
        
        var creditReason: CreditReason? = nil
        
        lazy var creditReasonSelect = Select(self.$creditReasonSelectListener){
            Option("- Seleccione Motivo -")
                .value("")
        }
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .borderRadius(7.px)
        .width(100.percent)
        .fontSize(23.px)
        .float(.right)
        
        @State var amount = ""

        lazy var amountField = InputText(self.$amount)
            .placeholder("0.00")
            .class(.textFiledBlackDarkLarge)
            .width(90.percent)
            .marginLeft(3.px)
            .fontSize(23.px)
            .height(36.px)
            .onKeyDown({ tf, event in
                guard let _ = Double(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
        
        @DOM override var body: DOM.Content {

            Div{
                Div{
                    
                    /// Header
                    Div{
                        
                        Img()
                            .closeButton(.uiView2)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("+ Agergar Nota de Credito")
                            .color(.white)

                        Div{
                            Div{
                                /// ``Selccioe motivo``
                                Label("Motivo")
                                    .marginBottom(12.px)
                                    .fontSize(18.px)
                                    .color(.gray)
                                
                                self.creditReasonSelect
                            }
                            .width(50.percent)
                            .float(.left)

                            Div{
                                
                                Label("Cantidad de Credito")
                                    .marginBottom(12.px)
                                    .fontSize(18.px)
                                    .color(.gray)

                                self.amountField

                            }
                            .width(50.percent)
                            .float(.left)

                            Div().clear(.both)

                        }
                        
                        Label("Comentarios")
                            .marginBottom(12.px)
                            .fontSize(18.px)
                            .color(.gray)
                        
                        TextArea(self.$comment)
                            .class(.textFiledBlackDarkLarge)
                            .placeholder("Ingrese la razon por la que se solicita la cancelacion...")
                            .padding(all: 12.px)
                            .marginBottom(7.px)
                            .width(95.percent)
                            .fontSize(18.px)
                            .height(70.px)
                        
                        Div{
                            Div("Agregar")
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    
                                    self.addCredit()
                                }
                        }
                        .align(.right)
                        
                    }
                    .marginBottom(7.px)
                    
                }
                .backgroundColor(.backGroundGraySlate)
                .custom("left", "calc(50% - 250px)")
                .custom("top", "calc(50% - 200px)")
                .borderRadius(all: 24.px)
                .position(.absolute)
                .padding(all: 7.px)
                .width(500.px)
            }

            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .color(.white)
            .left(0.px)
            .top(0.px)

        }

        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            color(.white)
            left(0.px)
            top(0.px)

            $creditReasonSelectListener.listen {
                self.creditReason =  CreditReason(rawValue: $0)
            }

            CreditReason.allCases.forEach {
                creditReasonSelect.appendChild(Option($0.description).value($0.rawValue))
            }

        }
    
        func addCredit() {


            guard let creditReason else {
                showError(.generalError, "Seleccione motivo de ajuste")
                return
            }

            guard let amount = Double(amount), amount > 0 else {
                showError(.generalError, "Seleccione motivo de ajuste")
                self.amountField.select()
                return
            }

            loadingView(show: true)

            API.fiscalV1.creditNote(
                id: doc.id,
                credit: Int64(amount * 100) ,
                description: creditReason.description,
                comment: self.comment,
                storeId: custCatchStore
            ){ resp in

                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                self.callback(payload)

                self.remove()

            }

        }
    }

}