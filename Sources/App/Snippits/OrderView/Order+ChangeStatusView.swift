//
//  Order+ChangeStatusView.swift
//
//
//  Created by Victor Cantu on 10/27/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class ChangeStatusView: Div {
        
        override class var name: String { "div" }
        
        let status: CustFolioStatus
        
        let folio: String
        
        let name: String
        
        private var callback: ((
            _ reason: String,
            _ dueDate: Int64?
        ) -> ())
        
        init(
            status: CustFolioStatus,
            folio: String,
            name: String,
            callback: @escaping (
                _ reason: String,
                _ dueDate: Int64?
            ) -> Void
        ) {
            self.status = status
            self.folio = folio
            self.name = name
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var reason = ""
        
        @State var date = ""
        
        lazy var reasonField = TextArea(self.$reason)
           .placeholder("Ingrese razon por el cambio.")
           .custom("width","calc(100% - 24px)")
           .class(.textFiledBlackDark)
           .height(120.px)
        
        lazy var dateField = InputText(self.$date)
           .custom("width","calc(100% - 24px)")
           .placeholder("DD/MM/AAAA")
           .class(.textFiledBlackDark)
           .height(31.px)
        
        @DOM override var body: DOM.Content {
            /* Select Code */
            Div{
                
                Div{
                    
                    /* Header */
                    Div {
                        
                        Img()
                            .closeButton(.subView)
                            .onClick {
                                self.remove()
                            }
                        
                        H2("Cambiar Estatus")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    Div("\(self.folio) \(self.name)")
                        .class(.oneLineText)
                        .fontSize(24.px)
                        .color(.white)
                    
                    Div().height(7.px)
                    
                    Label("Ingrese Motivo")
                    
                    Div().height(3.px)
                    
                    self.reasonField
                    
                    if self.status == .saleWait {
                        
                        Label("Ingrese Fecha de siguinte contacto")
                        
                        Div().height(3.px)
                        
                        self.dateField
                        
                        Div().height(7.px)
                        
                    }
                    
                    Div(self.status.description)
                        .custom("width", "calc(100% - 12px)")
                        .textAlign(.center)
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.changeStatus()
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
        
        func changeStatus(){
            
            if reason.isEmpty {
                showError(.campoRequerido, "Ingrese razon del cambio.")
                return
            }
            
            var dueDate: Int64? = nil
            
            if status == .saleWait {
                guard let uts = parseDate(date: date, time: "16:00") else {
                    return
                }
                dueDate = uts
            }
            
            callback(reason, dueDate)
            
            self.remove()
            
        }
        
    }
}
