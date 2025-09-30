//
//  Budget+Credit.swift
//  
//
//  Created by Victor Cantu on 6/29/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension BudgetView {
    
    class Credit: Div {
        
        let budgetId: UUID
        
        let credit: Int64?
        
        let creditExpireAt: Int64?
        
        private var callback: ((
            _ credit: Int64?,
            _ creditExpireAt: Int64?
        ) -> ())
        
        init(
            budgetId: UUID,
            credit: Int64?,
            creditExpireAt: Int64?,
            callback: @escaping ((
                _ credit: Int64?,
                _ creditExpireAt: Int64?
            ) -> ())
        ) {
            self.budgetId = budgetId
            self.credit = credit
            self.creditExpireAt = creditExpireAt
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var creditListener: String = ""
        
        @State var creditExpireAtListener: String = ""
        
        lazy var creditField = InputText(self.$creditListener)
            .custom("width","calc(100% - 12px)")
            .class(.textFiledBlackDark)
            .placeholder("0.00")
            .textAlign(.right)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onFocus { tf in
                tf.select()
            }
        
        lazy var creditExpireAtField = InputText(self.$creditExpireAtListener)
            .custom("width","calc(100% - 12px)")
            .class(.textFiledBlackDark)
            .placeholder("DD/MM/AAAA")
            .textAlign(.right)
            .height(31.px)
            .onFocus { tf in
                tf.select()
            }
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    H2({ (self.credit == nil) ? "Agregar Bonificación" : "Editar Bonificación" }())
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(7.px)
                
                Label("Cantidad del bonificacion")
                    .color(.lightGray)
                
                Div().class(.clear).height(3.px)
                
                self.creditField
                
                Div().class(.clear).height(7.px)
                
                Label("Vigencia de la bonificacion")
                    .color(.lightGray)
                
                Div().class(.clear).height(3.px)
                
                self.creditExpireAtField
                
                Div().class(.clear).height(7.px)
                
                Div{
                    
                    if self.creditExpireAt != nil {
                        Div{
                            
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginRight(7.px)
                                .height(18.px)
                            
                            Span("Eliminar")
                            
                        }
                        .class(.uibtnLarge)
                        .marginTop(0.px)
                        .float(.left)
                        .onClick {
                            self.removeCredit()
                        }
                    }
                    
                    Div{
                        
                        Img()
                            .src({ (self.creditExpireAt == nil) ? "/skyline/media/add.png" : "/skyline/media/cross.png" }())
                            .height(18.px)
                            .marginRight(7.px)
                        
                        Span({ (self.creditExpireAt == nil) ? "Agregar" : "Actualizar" }())
                        
                    }
                    .class(.uibtnLarge)
                    .onClick {
                        self.addCredit()
                    }
                }
                .align(.right)
                
            }
            .custom("right", "calc(50% - 200px)")
            .custom("top", "calc(50% - 100px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(207.px)
            .width(400.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            if let creditExpireAt {
                creditExpireAtListener = getDate(creditExpireAt).dateStamp
            }
            else {
                creditExpireAtListener = getDate((getNow() + (60 * 60 * 24 * 20))).dateStamp
            }
            
            creditListener = (credit ?? 0).formatMoney
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            creditField.select()
        }
        
        func addCredit(){
            
            guard let expireAt = parseDate(date: creditExpireAtListener, time: "23:59") else {
                return
            }
            
            guard let credit = Double(creditListener)?.toCents else {
                showError(.errorGeneral, "Ingrese una cantidad valida")
                return
            }
            
            guard credit > 0 else {
                showError(.errorGeneral, "Ingrese una cantidad mayor a cero")
                return
            }
            
            loadingView(show: true)
            
            API.custOrderV1.addCreditToBudget(
                budgetId: budgetId,
                credit: credit,
                expireAt: expireAt
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
                
                self.callback(credit, expireAt)
                
                self.remove()
                
            }
        }
        
        func removeCredit() {
            
            addToDom(ConfirmationView(
                type: .yesNo,
                title: "Remover Credto",
                message: "Confirme que desea eliminar el credito al presupuesto",
                callback: { isConfirmed, comment in
                    
                    if isConfirmed {
                        
                        loadingView(show: true)
                        
                        API.custOrderV1.removeCreditFromBudget(
                            budgetId: self.budgetId
                        ){ resp in
                            
                            loadingView(show: false)
                            
                            guard let resp else {
                                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                                return
                            }
                            
                            guard resp.status == .ok else {
                                showError(.errorGeneral, resp.msg)
                                return
                            }
                            
                            self.callback(nil, nil)
                            
                            self.remove()
                            
                        }
                    }
                })
            )
        }
    }
}


