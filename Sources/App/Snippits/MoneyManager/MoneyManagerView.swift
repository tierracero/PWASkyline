//
//  MoneyManagerView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class MoneyManagerView: Div {
    
    override class var name: String { "div" }
    
    @DOM override var body: DOM.Content {
        //Select Code
        Div{
            
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    if custCatchHerk > 1 {
                        
                        Div("Auditar")
                            .marginRight(12.px)
                            .marginTop(-7.px)
                            .fontSize(20.px)
                            .float(.right)
                            .class(.uibtn)
                            .onClick {
                                addToDom(AuditView())
                            }
                    }
                    
                    
                    Div("Historial")
                        .marginRight(12.px)
                        .marginTop(-7.px)
                        .fontSize(20.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            addToDom(HistoryView())
                        }
                    
                    H2("Dinero y Cortes")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().height(7.px)
                
                Div{
                    Img()
                        .src("/skyline/media/coin.png")
                        .marginRight(12.px)
                        .height(24.px)
                        .width(24.px)
                        
                    if custCatchHerk > 1 {
                        
                        Strong("Otorgar Dinero / Gastos")
                            .fontSize(36.px)
                            .color(.white)
                    }
                    else {
                        
                        Strong("Reportar Gastos")
                            .fontSize(36.px)
                            .color(.white)
                    }
                    
                }
                .custom("width", "calc(100% - 12px)")
                .class(.uibtnLarge)
                .onClick {
                    addToDom(FinancialServicesView())
                }
                
                Div().height(7.px)
                
                Div{
                    Img()
                        .src("/skyline/media/security.png")
                        .marginRight(12.px)
                        .height(24.px)
                        .width(24.px)
                        
                    Strong("Corte Caja/Banco")
                        .fontSize(36.px)
                        .color(.white)
                }
                .custom("width", "calc(100% - 12px)")
                .class(.uibtnLarge)
                .onClick {
                    
                    addToDom(NewDailyCutView(
                        type: .bankDeposit,
                        user: API.custAPIV1.UserList(
                            id: custCatchID,
                            user: custCatchUser,
                            name: custCatchUser
                        )
                    ))
                    
                }
                
                
                Div().height(7.px)
                
                Div{
                    Img()
                        .src("/skyline/media/spreadsheet.png")
                        .marginRight(12.px)
                        .height(24.px)
                        .width(24.px)
                        
                    Strong("Recbir Corte")
                        .fontSize(36.px)
                        .color(.white)
                }
                .custom("width", "calc(100% - 12px)")
                .class(.uibtnLarge)
                .onClick {
                    
                    addToDom(
                        NewDailyCutView.NewDailyCutSelectUserView { user in
                            addToDom(
                                NewDailyCutView(
                                    type: .generalTransfer,
                                    user: user
                                )
                            )
                        }
                    )
                    
                }
                
            }
            .padding(all: 12.px)
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
    }
    
    
}
