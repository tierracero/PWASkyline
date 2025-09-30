//
//  ReactivateConfirmOrderRentalView.swift
//
//
//  Created by Victor Cantu on 5/11/22.
//

import Foundation
import TCFundamentals
import Web

class ReactivateConfirmOrderRentalView: Div {
    
    override class var name: String { "div" }
    
    var reacts: [UUID:Bool] = [:]
    
    var type: FolioTypes
    var equipments: [CustOrderLoadFolioEquipments]
    var rentals: [CustPOCRentalsMin]
    private var callback: ((_ reacts: [UUID:Bool]) -> ())
    
    init(
        type: FolioTypes,
        rentals: [CustPOCRentalsMin],
        equipments: [CustOrderLoadFolioEquipments],
        callback: @escaping ((_ reacts: [UUID:Bool]) -> ())
    ) {
        self.type = type
        self.rentals = rentals
        self.equipments = equipments
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var confirmView = Div {
        
        Img()
            .closeButton(.uiView3)
            .onClick{
                self.remove()
            }
        
        H1("Reactivar Orden")
            .color(.lightBlueText)
        
        Div()
            .class(.clear)
            .marginTop(3.px)
        
    }
    
    @DOM override var body: DOM.Content {
        confirmView
        .padding(all: 12.px)
        .position(.absolute)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
            .zIndex(999999998)
        
        switch self.type {
        case .folio:
            
            if self.equipments.count == 0 || self.equipments.count == 1 {
                self.confirmView.appendChild(
                    Div{
                        
                        P("Confirme estado")
                            .fontSize(32.px)
                        
                        Div()
                            .class(.clear)
                            .marginTop(12.px)
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/round.png")
                                .height(24.px)
                                .marginRight(7.px)
                            
                            Span {
                                Strong("Reactivar")
                            }
                            .fontSize(26.px)
                            .padding(all: 7.px)
                        }
                        .align(.center)
                        .class(.smallButtonBox)
                        .onClick {
                            
                            var _reacts: [UUID:Bool] = [:]
                            
                            if var obj = self.equipments.first {
                                _reacts[obj.id] = true
                            }
                            
                            self.callback(_reacts)
                            self.remove()
                        }
                    }
                )
                
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
                
            }
            else if self.equipments.count > 1 && self.equipments.count <= 6 {
                
                self.confirmView.appendChild(
                    P("Seleccione regresos")
                        .fontSize(32.px)
                )
                
                self.confirmView.appendChild(
                    Div()
                        .class(.clear)
                        .marginTop(12.px)
                )
                
                self.confirmView.appendChild(
                    Div{
                        Div("No.Eco.").class(.oneHalf)
                        Div("Regresos").class(.oneHalf)
                        Div().class(.clear)
                    }
                )
                
                var cc = 0
                self.equipments.forEach { eq in
                    /// If ``true`` means  that  is already  set and not pickedup
                    @State var isPicked: Bool = true
                    @State var isPickedDisabeld: Bool = false
                    
                    self.reacts[eq.id] = true
                    
                    if let _ = eq.deliveredBy {
                        self.reacts[eq.id] = false
                        isPicked = false
                    }
                    
                    self.confirmView.appendChild(
                        Div {
                            Div("\(eq.tag1) \(eq.tag2)").class(.oneHalf)
                            /// Picked
                            Div{
                                InputCheckbox().toggleRental($isPicked, $isPickedDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isPicked = true
                                        self.reacts[eq.id] = true
                                    }
                                    else {
                                        isPicked = false
                                        self.reacts[eq.id] = false
                                    }
                                })
                            }.class(.oneHalf)
                            Div().class(.clear)
                        }
                    )
                    
                    cc += 1
                    
                }
                
                self.confirmView.appendChild(Div().class(.clear).marginTop(12.px))
                
                self.confirmView.appendChild(
                    Div{
                        Img()
                            .src("/skyline/media/round.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Strong("Reactivar")
                        .fontSize(28.px)
                    }
                    .align(.center)
                    .padding(all: 7.px)
                    .class(.smallButtonBox)
                    .onClick {
                        
                        var hasItem = false
                        
                        self.reacts.forEach { id, react in
                            if react {
                                hasItem = true
                            }
                        }
                        
                        if !hasItem {
                            showAlert(.alerta, "Seleccione que reactivar")
                            return
                        }
                        
                        self.callback(self.reacts)
                        self.remove()
                    }
                )
                
                confirmView
                    .left(35.percent)
                    .top(20.percent)
                    .width(30.percent)
            }
            else if self.equipments.count > 6 && self.equipments.count <= 14 {
                confirmView.appendChild(H1("La vista para \(self.equipments.count) servicios no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else if self.equipments.count > 15 && self.equipments.count <= 21 {
                confirmView.appendChild(H1("La vista para \(self.equipments.count) servicios no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else{
                confirmView.appendChild(H1("La vista para \(self.equipments.count) rentas no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            
        case .date:
             break
        case .sale:
            break
        case .rental:
            if self.rentals.count == 0 || self.rentals.count == 1 {
                self.confirmView.appendChild(
                    Div{
                        
                        P("Confirme estado")
                            .fontSize(32.px)
                        
                        Div()
                            .class(.clear)
                            .marginTop(12.px)
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/round.png")
                                .height(24.px)
                                .marginRight(7.px)
                            
                            Span {
                                Strong("Reactivar")
                            }
                            .fontSize(26.px)
                            .padding(all: 7.px)
                        }
                        .align(.center)
                        .class(.smallButtonBox)
                        .onClick {
                            
                            var _reacts: [UUID:Bool] = [:]
                            
                            if let obj = self.rentals.first {
                                _reacts[obj.id] = true
                            }
                            
                            self.callback(_reacts)
                            self.remove()
                        }
                    }
                )
                
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
                
            }
            else if self.rentals.count > 1 && self.rentals.count <= 6 {
                
                self.confirmView.appendChild(
                    P("Seleccione regresos")
                        .fontSize(32.px)
                )
                
                self.confirmView.appendChild(
                    Div()
                        .class(.clear)
                        .marginTop(12.px)
                )
                
                self.confirmView.appendChild(
                    Div{
                        Div("No.Eco.").class(.oneHalf)
                        Div("Regresos").class(.oneHalf)
                        Div().class(.clear)
                    }
                )
                
                var cc = 0
                self.rentals.forEach { rental in
                    /// If ``true`` means  that  is already  set and not pickedup
                    @State var isPicked: Bool = true
                    @State var isPickedDisabeld: Bool = false
                    
                    self.reacts[rental.id] = true
                    
                    if let _ = rental.deliveredBy {
                        self.reacts[rental.id] = false
                        isPicked = false
                    }
                    
                    self.confirmView.appendChild(
                        Div {
                            Div(rental.ecoNumber).class(.oneHalf)
                            /// Picked
                            Div{
                                InputCheckbox().toggleRental($isPicked, $isPickedDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isPicked = true
                                        self.reacts[rental.id] = true
                                    }
                                    else {
                                        isPicked = false
                                        self.reacts[rental.id] = false
                                    }
                                })
                            }.class(.oneHalf)
                            Div().class(.clear)
                        }
                    )
                    
                    cc += 1
                    
                }
                
                self.confirmView.appendChild(Div().class(.clear).marginTop(12.px))
                
                self.confirmView.appendChild(
                    Div{
                        Img()
                            .src("/skyline/media/round.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Strong("Reactivar")
                        .fontSize(28.px)
                    }
                    .align(.center)
                    .padding(all: 7.px)
                    .class(.smallButtonBox)
                    .onClick {
                        
                        var hasItem = false
                        
                        self.reacts.forEach { id, react in
                            if react {
                                hasItem = true
                            }
                        }
                        
                        if !hasItem {
                            showAlert(.alerta, "Seleccione que reactivar")
                            return
                        }
                        
                        print(self.reacts)
                        
                        self.callback(self.reacts)
                        self.remove()
                    }
                )
                
                confirmView
                    .left(35.percent)
                    .top(20.percent)
                    .width(30.percent)
            }
            else if self.rentals.count > 6 && self.rentals.count <= 14 {
                confirmView.appendChild(H1("La vista para \(self.rentals.count) rentas no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else if self.rentals.count > 15 && self.rentals.count <= 21 {
                confirmView.appendChild(H1("La vista para \(self.rentals.count) rentas no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else{
                confirmView.appendChild(H1("La vista para \(self.rentals.count) rentas no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
        case .mercadoLibre:
            break
        case .claroShop:
            break
        case .amazon:
            break
        case .ebay:
            break
        }
    }
}
