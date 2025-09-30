//
//  CancelationConfirmView.swift
//
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import Web

/// This view will be used when their is only ``one item``  in the order, else a multiple item window will be used
/// This view asumes it was succesfully finished
class CancelationConfirmView: Div {
    
    override class var name: String { "div" }
    
    var type: FolioTypes
    var equipments: [CustOrderLoadFolioEquipments]
    var rentals: [CustPOCRentalsMin]
    private var callback: ((
        _ rentals: [CustPOCRentalsMin],
        _ equipments: [CustOrderLoadFolioEquipments]
    ) -> ())
    
    init(
        type: FolioTypes,
        rentals: [CustPOCRentalsMin],
        equipments: [CustOrderLoadFolioEquipments],
        callback: @escaping ((
            _ rentals: [CustPOCRentalsMin],
            _ equipments: [CustOrderLoadFolioEquipments]
        ) -> ())
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
        
        H1("Orden: \(configServiceTags.typeOfServiceObject.negativeTag)")
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
                            Div {
                                Strong("Entregado")
                            }
                            .fontSize(28.px)
                            .align(.center)
                            .padding(all: 7.px)
                        }
                        .class(.smallButtonBox)
                        .onClick {
                            
                            var _rentals: [CustPOCRentalsMin] = []
                            var _equipments: [CustOrderLoadFolioEquipments] = []
                            
                            if var obj = self.rentals.first {
                                obj.workedBy = (obj.workedBy == nil) ? custCatchID : obj.workedBy
                                obj.deliveredBy = (obj.deliveredBy == nil) ? custCatchID : obj.workedBy
                                _rentals.append(obj)
                            }
                            if var obj = self.equipments.first {
                                obj.workedBy = (obj.workedBy == nil) ? custCatchID : obj.workedBy
                                obj.deliveredBy = (obj.deliveredBy == nil) ? custCatchID : obj.workedBy
                                _equipments.append(obj)
                            }
                            
                            self.callback(_rentals, _equipments)
                            self.remove()
                        }
                        
                        Div()
                            .class(.clear)
                            .marginTop(12.px)
                        
                        Div{
                            Div {
                                Strong("Pendiente Entrega")
                            }
                            .fontSize(26.px)
                            .padding(all: 7.px)
                            .align(.center)
                        }
                        .class(.smallButtonBox)
                        .onClick {
                            
                            var _rentals: [CustPOCRentalsMin] = []
                            var _equipments: [CustOrderLoadFolioEquipments] = []
                            
                            if var obj = self.rentals.first {
                                obj.workedBy = (obj.workedBy == nil) ? custCatchID : obj.workedBy
                                obj.deliveredBy = nil
                                _rentals.append(obj)
                            }
                            if var obj = self.equipments.first {
                                obj.workedBy = (obj.workedBy == nil) ? custCatchID : obj.workedBy
                                obj.deliveredBy = nil
                                _equipments.append(obj)
                            }
                            
                            self.callback(_rentals, _equipments)
                            self.remove()
                        }
                        .hidden(self.equipments.first?.deliveredBy != nil)
                    }
                )
                
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
                
            }
            else if self.equipments.count > 1 && self.equipments.count <= 6 {
                
                self.confirmView.appendChild(
                    P("Confirme estado")
                        .fontSize(32.px)
                )
                
                self.confirmView.appendChild(
                    Div()
                        .class(.clear)
                        .marginTop(12.px)
                )
                
                self.confirmView.appendChild(
                    Div{
                        Div("No.Eco.").class(.oneThird)
                        Div("Preparado").class(.oneThird)
                        Div("Entregado").class(.oneThird)
                        Div().class(.clear)
                    }
                )
                
                var cc = 0
                self.equipments.forEach { eq in
                    
                    let thisCount = cc
                    @State var isReady: Bool = true
                    @State var isReadyDisabeld: Bool = false
                    var isReadyPreLoaded: Bool = false
                    @State var isPicked: Bool = false
                    @State var isPickedDisabeld: Bool = false
                    
                    if eq.workedBy == nil {
                        self.equipments[thisCount].workedBy = custCatchID
                    }
                    else{
                        isReadyPreLoaded = true
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            isReadyDisabeld = true
                        }
                    }
                    
                    if let _ = eq.deliveredBy {
                        isPicked = true
                        isReadyDisabeld = true
                        
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            isPickedDisabeld = true
                        }
                        
                    }
                    
                    self.confirmView.appendChild(
                        Div {
                            Div("\(eq.tag1) \(eq.tag2)").class(.oneThird)
                            /// Preparado
                            Div{
                                InputCheckbox().toggleRental($isReady, $isReadyDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isReady = true
                                        isPickedDisabeld = false
                                        self.equipments[thisCount].workedBy = custCatchID
                                    }
                                    else{
                                        isReady = false
                                        isReadyDisabeld = false
                                        isPickedDisabeld = true
                                        self.equipments[thisCount].workedBy = nil
                                    }
                                })
                            }.class(.oneThird)
                            /// Picked
                            Div{
                                InputCheckbox().toggleRental($isPicked, $isPickedDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isPicked = true
                                        isReadyDisabeld = true
                                        self.equipments[thisCount].deliveredBy = custCatchID
                                    }
                                    else{
                                        if !isPickedDisabeld {
                                            isPicked = false
                                            if isReadyPreLoaded {
                                                if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                                                    isReadyDisabeld = true
                                                }
                                                else{
                                                    isReadyDisabeld = false
                                                }
                                            }
                                            else{
                                                isReadyDisabeld = false
                                            }
                                            
                                            self.equipments[thisCount].deliveredBy = nil
                                        }
                                    }
                                })
                            }.class(.oneThird)
                            Div().class(.clear)
                        }
                    )
                    
                    cc += 1
                    
                }
                
                self.confirmView.appendChild(Div().class(.clear).marginTop(12.px))
                
                self.confirmView.appendChild(
                    Div{
                        
                        Img()
                            .src("/skyline/media/checkmark.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Strong(configServiceTags.typeOfServiceObject.positiveTag)
                        .fontSize(28.px)
                        
                    }
                        .align(.center)
                        .padding(all: 7.px)
                        .class(.smallButtonBox)
                        .onClick {
                            self.callback(self.rentals, self.equipments)
                            self.remove()
                        }
                )
                
                confirmView
                    .left(35.percent)
                    .top(20.percent)
                    .width(30.percent)
            }
            else if self.equipments.count > 6 && self.equipments.count <= 14 {
                confirmView.appendChild(H1("La vista para \(self.rentals.count) servicios no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else if self.equipments.count > 15 && self.equipments.count <= 21 {
                confirmView.appendChild(H1("La vista para \(self.rentals.count) servicios no esta habilita. Contacte a Soporte TC"))
                confirmView
                    .left(35.percent)
                    .top(30.percent)
                    .width(30.percent)
            }
            else{
                confirmView.appendChild(H1("La vista para \(self.rentals.count) servicios no esta habilita. Contacte a Soporte TC"))
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
                            Div {
                                if self.equipments.first?.deliveredBy != nil {
                                    Strong("Canceler")
                                }
                                else{
                                    Strong("Entregado")
                                }
                            }
                            .fontSize(28.px)
                            .align(.center)
                            .padding(all: 7.px)
                        }
                        .class(.smallButtonBox)
                        .onClick {
                            self.callback(self.rentals, self.equipments)
                            self.remove()
                        }
                         
                        Div()
                            .class(.clear)
                            .marginTop(12.px)
                        
                        Div{
                            Div {
                                Strong("Pendiente Entrega")
                            }
                            .fontSize(26.px)
                            .padding(all: 7.px)
                            .align(.center)
                        }
                        .class(.smallButtonBox)
                        .onClick {
                            
                            var _rentals: [CustPOCRentalsMin] = []
                            var _equipments: [CustOrderLoadFolioEquipments] = []
                            
                            if var obj = self.rentals.first {
                                obj.workedBy = custCatchID
                                obj.deliveredBy = custCatchID
                                _rentals.append(obj)
                            }
                            if var obj = self.equipments.first {
                                obj.workedBy = custCatchID
                                obj.deliveredBy = custCatchID
                                _equipments.append(obj)
                            }
                            
                            self.callback(_rentals, _equipments)
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
                    P("Confirme estado")
                        .fontSize(32.px)
                )
                
                self.confirmView.appendChild(
                    Div()
                        .class(.clear)
                        .marginTop(12.px)
                )
                
                self.confirmView.appendChild(
                    Div{
                        Div("No.Eco.").class(.oneThird)
                        Div("Preparado").class(.oneThird)
                        Div("Entregado").class(.oneThird)
                        Div().class(.clear)
                    }
                )
                
                var cc = 0
                self.rentals.forEach { rental in
                    let thisCount = cc
                    @State var isReady: Bool = true
                    @State var isReadyDisabeld: Bool = false
                    var isReadyPreLoaded: Bool = false
                    @State var isPicked: Bool = false
                    @State var isPickedDisabeld: Bool = false
                    
                    if  rental.workedBy == nil {
                        self.rentals[thisCount].workedBy = custCatchID
                    }
                    else{
                        isReadyPreLoaded = true
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            isReadyDisabeld = true
                        }
                    }
                    
                    if let _ = rental.deliveredBy {
                        isPicked = true
                        isReadyDisabeld = true
                        
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            isPickedDisabeld = true
                        }
                        
                    }
                    
                    self.confirmView.appendChild(
                        Div {
                            Div(rental.ecoNumber).class(.oneThird)
                            /// Preparado
                            Div{
                                InputCheckbox().toggleRental($isReady, $isReadyDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isReady = true
                                        isPickedDisabeld = false
                                        self.rentals[thisCount].workedBy = custCatchID
                                    }
                                    else{
                                        isReady = false
                                        isReadyDisabeld = false
                                        isPickedDisabeld = true
                                        self.rentals[thisCount].workedBy = nil
                                    }
                                })
                            }.class(.oneThird)
                            /// Picked
                            Div{
                                InputCheckbox().toggleRental($isPicked, $isPickedDisabeld, callback: { isChecked in
                                    if !isChecked {
                                        isPicked = true
                                        isReadyDisabeld = true
                                        self.rentals[thisCount].deliveredBy = custCatchID
                                    }
                                    else{
                                        if !isPickedDisabeld {
                                            isPicked = false
                                            if isReadyPreLoaded {
                                                if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                                                    isReadyDisabeld = true
                                                }
                                                else{
                                                    isReadyDisabeld = false
                                                }
                                            }
                                            else{
                                                isReadyDisabeld = false
                                            }
                                            
                                            self.rentals[thisCount].deliveredBy = nil
                                        }
                                    }
                                })
                            }.class(.oneThird)
                            Div().class(.clear)
                        }
                    )
                    
                    cc += 1
                    
                }
                
                self.confirmView.appendChild(Div().class(.clear).marginTop(12.px))
                
                self.confirmView.appendChild(
                    Div{
                        
                        Img()
                            .src("/skyline/media/checkmark.png")
                            .height(24.px)
                            .marginRight(7.px)
                        
                        Strong(configServiceTags.typeOfServiceObject.positiveTag)
                        .fontSize(28.px)
                    }
                        .align(.center)
                        .padding(all: 7.px)
                        .class(.smallButtonBox)
                        .onClick {
                            self.callback(self.rentals, self.equipments)
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
