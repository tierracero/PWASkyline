//
//  SalePoint+DeleteSaleConfirmView.swift
//  
//
//  Created by Victor Cantu on 7/24/23.
//

import TCFundamentals
import Foundation
import Web

extension SalePointView {
    
    class DeleteSaleConfirmView: Div {
        
        let folio: String
        
        let total: Int64
        
        let createdBy: UUID
        
        private var callback: ((
            _ type: SaleCancelationType,
            _ reason: String,
            _ refundTo: UUID?
        ) -> ())
        
        init(
            folio: String,
            total: Int64,
            createdBy: UUID,
            callback: @escaping ((
                _ type: SaleCancelationType,
                _ reason: String,
                _ refundTo: UUID?
            ) -> ())
        ) {
            self.folio = folio
            self.total = total
            self.createdBy = createdBy
            self.callback = callback
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var typeListener = ""
        
        lazy var typeSelect = Select(self.$typeListener)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .fontSize(22.px)
            .height(34.px)
        
        @State var reason = ""
        
        @State var targetUserListener = ""
        
        lazy var targetUserSelect = Select(self.$targetUserListener)
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .fontSize(22.px)
            .height(34.px)
        
        @DOM override var body: DOM.Content {
            Div {
                
                // Top Tools
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Confirme Cancelación")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    H2(self.folio)
                        .color(.yellowTC)
                        .marginLeft(7.px)
                        .float(.left)
                    
                }
                .paddingBottom(3.px)
                
                Div().clear(.both)
                
                H3("Destino de la mercancia")
                    .color(.white)
                
                self.typeSelect
                
                H3("Escriba la razon de la cancelacion")
                    .color(.white)
                
                TextArea(self.$reason)
                    .placeholder("Razon por la cancelacion")
                    .class(.textFiledBlackDark)
                    .marginBottom(12.px)
                    .fontSize(22.px)
                    .height(34.px)
                    .height(80.px)
                
                if custCatchHerk > 3 {
                    
                    H3("Usuario Bonificado")
                        .color(.white)
                    
                    self.targetUserSelect
                    
                }
                
                Div{
                    Div("Cancelar")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.cancelDocument()
                        }
                }
                .align(.right)
                
            }
            .custom("left", "calc(50% - 274px)")
            .custom("top", "calc(50% - 175px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(500.px)
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            typeSelect.appendChild(
                Option("Seleccione disposición")
                    .value("")
            )
            
            SaleCancelationType.allCases.forEach { type in
                typeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            targetUserSelect.appendChild(
                Option("Seleccione Usuario")
                    .value("")
            )
            
            print("🟢  🟢  🟢  ")
            
            getUsers(storeid: nil, onlyActive: true) { users in
                users.forEach { user in
                    self.targetUserSelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                    
                    print("\(user.id.uuidString)  \(user.username)")
                }
            }
            
            if custCatchHerk > 3 {
                
                print("🟢  🟢  🟢  ")
                
                print(createdBy.uuidString)
                
                print(createdBy.uuidString.uppercased())
                
                targetUserListener = createdBy.uuidString.uppercased()
            }
            
        }
        
        func cancelDocument() {
            
            guard let type = SaleCancelationType(rawValue: typeListener) else {
                showError(.generalError, "Seleccione disposición de inventario.")
                return
            }
            
            reason = reason.purgeSpaces()
            
            if reason.isEmpty {
                showError(.generalError, "Incluya razon de cancelacion")
                return
            }
        
            let refundTo = UUID(uuidString: targetUserListener)
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme que cancelaciond eventa folio \(self.folio) por \(self.total.formatMoney)"){ isConfirm, _ in
                
                    if isConfirm {
                        
                        self.callback( type, self.reason, refundTo)
                        
                        self.remove()
                        
                    }
                }
            )
        }
    }
}


