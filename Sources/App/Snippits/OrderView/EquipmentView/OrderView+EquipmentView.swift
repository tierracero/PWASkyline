//
//  OrderView+EquipmentView.swift
//
//
//  Created by Victor Cantu on 10/19/23.
//

import Foundation
import TCFundamentals
import Web

extension OrderView {
    
    class EquipmentView: Div {
        
        override class var name: String { "div" }
        
        var orderView: OrderView
        var status: State<CustFolioStatus>
        var isReady: State<Bool>
        var isPicked: State<Bool>
        var equipment: CustOrderLoadFolioEquipments
        var hideControls: Bool
        
        init(
            orderView: OrderView,
            status: State<CustFolioStatus>,
            isReady: State<Bool>,
            isPicked: State<Bool>,
            equipment: CustOrderLoadFolioEquipments,
            hideControls: Bool
        ) {
            self.orderView = orderView
            self.status = status
            self.isReady = isReady
            self.isPicked = isPicked
            self.equipment = equipment
            self.hideControls = hideControls
            
            super.init()
            
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        let unWorkableStatus: [CustFolioStatus] = [
            .canceled,
            .pending,
            .finalize,
            .archive,
            .collection
        ]
        
        let oparationalStatus: [CustFolioStatus] = [
            CustFolioStatus.active,
            CustFolioStatus.pendingSpare,
            CustFolioStatus.sideStatus
        ]
        
        @State var editMode = false
        
        @State var isDisabled = true
        
        var workedBy: UUID? = nil
        var deliveredBy: UUID? = nil
        
        @State var isReadyDisabled: Bool = false
        @State var pendingPickupDisabled: Bool = false
        
        @State var descriptionIsHidden: Bool = true
        
        ///Name of the Equpment
        var name = ""
        
        /**  `` General Input Items `` */
        
        @State var selectEquipmentField = ""
        
        @State var _idTag1: String = ""
        
        @State var _idTag2: String = ""
        
        @State var _tag1: String = ""
        
        @State var _tag2: String = ""
        
        @State var _tag3: String = ""
        
        @State var _tag4: String = ""
        
        @State var _tag5: String = ""
        
        @State var _tag6: String = ""
        
        @State var _descr: String = ""
        
        @State var _checkTag1: Bool = false
        
        @State var _checkTag2: Bool = false
        
        @State var _checkTag3: Bool = false
        
        @State var _checkTag4: Bool = false
        
        @State var _checkTag5: Bool = false
        
        @State var _checkTag6: Bool = false
        
        @State var diagnostic: String = ""
        
        @State var resolution: String = ""
        
        @State var equipmentStatus: CustFolioObjectsStatus = .unfixed
        
        var pendingSpareEvent: UUID? = nil
        
        lazy var idTag1 = InputText(self.$_idTag1)
            .autocomplete(.off)
            .placeholder(configServiceTags.idTagPlaceholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "idTag1"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var idTag2 = InputText(self.$_idTag2)
            .autocomplete(.off)
            .placeholder(configServiceTags.secondIDTagPlaceholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "idTag2"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag1 = InputText(self.$_tag1)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag1Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag1"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag2 = InputText(self.$_tag2)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag2Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag2"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag3 = InputText(self.$_tag3)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag3Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag3"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag4 = InputText(self.$_tag4)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag4Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag4"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag5 = InputText(self.$_tag5)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag5Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag5"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var tag6 = InputText(self.$_tag6)
            .autocomplete(.off)
            .placeholder(configServiceTags.tag6Placeholder)
            .class(.textFiledBlackDark)
            .width(93.percent)
            .onFocus {
                self.selectEquipmentField = "tag6"
            }
            .onBlur {
                self.selectEquipmentField = ""
            }
        
        lazy var descr = TextArea(self.$_descr)
            .placeholder(configServiceTags.tagDescrPlaceholder)
            .custom("width","calc(100% - 18px)")
            .placeholder("Nombre Producto")
            .class(.textFiledBlackDark)
            .width(93.percent)
            .fontSize(20.px)
            .height(100.px)
            .hidden(self.$editMode.map{!$0})
        
        lazy var diagnosticTextArea = TextArea(self.$diagnostic)
            .placeholder(configServiceTags.tagDescrPlaceholder)
            .custom("width","calc(100% - 18px)")
            .placeholder("Nombre Producto")
            .class(.textFiledBlackDark)
            .width(93.percent)
            .fontSize(20.px)
            .height(100.px)
            .hidden(self.$editMode.map{!$0})
        
        lazy var resolutionTextArea = TextArea(self.$resolution)
            .placeholder(configServiceTags.tagDescrPlaceholder)
            .custom("width","calc(100% - 18px)")
            .placeholder("Nombre Producto")
            .class(.textFiledBlackDark)
            .width(93.percent)
            .fontSize(20.px)
            .height(100.px)
            .hidden(self.$editMode.map{!$0})
        
        lazy var checkTag1 = InputCheckbox().toggle(self.$_checkTag1, self.$isDisabled){ bool in
            self._checkTag1 = !bool
        }
        
        lazy var checkTag2 = InputCheckbox().toggle(self.$_checkTag2, self.$isDisabled){ bool in
            self._checkTag2 = !bool
        }

        lazy var checkTag3 = InputCheckbox().toggle(self.$_checkTag3, self.$isDisabled){ bool in
            self._checkTag3 = !bool
        }
        
        lazy var checkTag4 = InputCheckbox().toggle(self.$_checkTag4, self.$isDisabled){ bool in
            self._checkTag4 = !bool
        }
        
        lazy var checkTag5 = InputCheckbox().toggle(self.$_checkTag5, self.$isDisabled){ bool in
            self._checkTag5 = !bool
        }
        
        lazy var checkTag6 = InputCheckbox().toggle(self.$_checkTag6, self.$isDisabled){ bool in
            self._checkTag6 = !bool
        }
        
        /**  `` /General Input Items `` */
        
        @DOM override var body: DOM.Content {
            
            Div{
                // IDTag1
                Div{
                    
                    Label(configServiceTags.idTagName)
                        .color(.gray)
                        .fontSize(10.px)
                    
                    Div(self.$_idTag1.map{ $0.isEmpty ? configServiceTags.idTagPlaceholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_idTag1.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.idTag1
                        .hidden(self.$editMode.map{ !$0 })
                        
                }
                
                // IDTag2
                Div {
                    Label(configServiceTags.secondIDTagName).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_idTag2.map{ $0.isEmpty ? configServiceTags.secondIDTagPlaceholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_idTag2.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.idTag2
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.secondIDTagRequiered)
                
                // Tag1
                Div {
                    Label(configServiceTags.tag1Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag1.map{ $0.isEmpty ? configServiceTags.tag1Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag1.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag1
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag1)
                
                // Tag2
                Div {
                    Label(configServiceTags.tag2Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag2.map{ $0.isEmpty ? configServiceTags.tag2Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag2.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag2
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag2)
                
                // Tag3
                Div {
                    Label(configServiceTags.tag3Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag3.map{ $0.isEmpty ? configServiceTags.tag3Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag3.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag3
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag3)
                
                // Tag4
                Div {
                    Label(configServiceTags.tag4Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag4.map{ $0.isEmpty ? configServiceTags.tag4Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag4.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag4
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag4)
                
                // Tag5
                Div {
                    Label(configServiceTags.tag5Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag5.map{ $0.isEmpty ? configServiceTags.tag5Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag5.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag5
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag5)
                
                // Tag6
                Div {
                    Label(configServiceTags.tag6Name).color(.gray)
                        .color(.gray)
                        .fontSize(10.px)
                      
                    Div(self.$_tag6.map{ $0.isEmpty ? configServiceTags.tag6Placeholder : $0 })
                        .class(.textFiledBlackDarkReadMode, .oneLineText)
                        .color(self.$_tag6.map{ $0.isEmpty ? .grayContrast : .goldenRod })
                        .hidden(self.$editMode)
                    
                    self.tag6
                        .hidden(self.$editMode.map{ !$0 })
                }
                .marginTop(1.px)
                .hidden(!configServiceTags.tag6)
                
            }
            .height(100.percent)
            .width(35.percent)
            .overflow(.auto)
            .float(.left)
            
            Div{
                
                Div{
                    
                    Div{
                    
                        /// checkTag1
                        Div{
                            Div{
                                self.checkTag1
                            }
                            .width(70.px)
                            .float(.left)
                            
                            Div(configServiceTags.checkTag1Name)
                                .color(.white)
                                .class( .oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                        }
                        .hidden(!configServiceTags.checkTag1)
                        .class(.oneHalf)
                        
                        /// checkTag2
                        Div{
                            Div{
                                self.checkTag2
                            }
                            .width(70.px)
                            .float(.left)
                            
                            Div(configServiceTags.checkTag2Name)
                                .color(.white)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            Div().class(.clear)
                        }
                        .hidden(!configServiceTags.checkTag2)
                        .class(.oneHalf)
                        
                        /// checkTag3
                        Div{
                            Div{
                                self.checkTag3
                            }
                            .width(70.px)
                            .float(.left)
                            Div(configServiceTags.checkTag3Name)
                                .color(.white)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            Div().class(.clear)
                        }
                        .hidden(!configServiceTags.checkTag3)
                        .class(.oneHalf)
                        
                        /// checkTag4
                        Div{
                            Div{
                                self.checkTag4
                            }
                            .width(70.px)
                            .float(.left)
                            
                            Div(configServiceTags.checkTag4Name)
                                .color(.white)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            Div().class(.clear)
                        }
                        .hidden(!configServiceTags.checkTag4)
                        .class(.oneHalf)
                        
                        /// checkTag5
                        Div{
                            Div{
                                self.checkTag5
                            }
                            .width(70.px)
                            .float(.left)
                            
                            Div(configServiceTags.checkTag5Name)
                                .color(.white)
                                .class( .oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            Div().class(.clear)
                        }
                        .hidden(!configServiceTags.checkTag5)
                        .class(.oneHalf)
                        
                        /// checkTag6
                        Div{
                            Div{
                                self.checkTag6
                            }
                            .width(70.px)
                            .float(.left)
                            
                            Div(configServiceTags.checkTag6Name)
                                .color(.white)
                                .class(.oneLineText)
                                .custom("width", "calc(100% - 70px)")
                                .float(.left)
                            
                            Div().class(.clear)
                        }
                        .hidden(!configServiceTags.checkTag6)
                        .class(.oneHalf)
                        
                        Div().class(.clear)
                        
                    }
                    .height(100.percent)
                    .width(60.percent)
                    .float(.left)
                    
                    /// Description
                    Div{
                        
                        Div(self.$_descr)
                            .hidden(self.$editMode.map{$0})
                            .marginBottom(7.px)
                            .color(.goldenRod)
                            .fontSize(18.px)
                        
                        Div{
                            Div("+ Agregar Diagnostico")
                                .hidden(self.$diagnostic.map{ !$0.isEmpty })
                                .textAlign(.center)
                                .class(.uibtnLarge)
                                .width(100.percent)
                                .onClick {
                                    addToDom(ConfirmationView(
                                        type: .yesNo,
                                        title: "Agregar Diagnostico",
                                        message: "Que prococo la situación o problema actual.",
                                        comments: .required,
                                        callback: { isConfirmed, comment in
                                            
                                            loadingView(show: true)
                                            
                                            API.custOrderV1.addEquipmentDiagnostic(
                                                equipmentId: self.equipment.id,
                                                comment: comment
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
                                                    
                                                    self.diagnostic = comment
                                                    
                                                    self.equipment.diagnostic = comment
                                                    
                                                    var cc = 0
                                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                        if  eq.id  == self.equipment.id {
                                                            equipmentsCatch[self.orderView.order.id]![cc] = self.equipment
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                }
                                        })
                                    )
                                }
                            
                            Div("DIAGNOSTICO:")
                                .hidden(self.$diagnostic.map{ $0.isEmpty })
                                .color(.gray)
                            
                            Div(self.$diagnostic)
                                .hidden(self.$diagnostic.map{ $0.isEmpty })
                                .marginBottom(3.px)
                                .color(.gray)
                                .fontSize(18.px)
                                .float(.left)
                        }
                        .hidden(self.$editMode.map{$0})
                        
                        Div().marginBottom(3.px)
                        
                        Div{
                            
                            Div("+ Agregar Resolucion")
                                .hidden(self.$resolution.map{ !$0.isEmpty })
                                .textAlign(.center)
                                .class(.uibtnLarge)
                                .width(100.percent)
                                .onClick {
                                    addToDom(ConfirmationView(
                                        type: .yesNo,
                                        title: "Agregar Resolucion",
                                        message: "Como fue resuelto o concluido",
                                        comments: .required,
                                        callback: { isConfirmed, comment in
                                            
                                            loadingView(show: true)
                                            
                                            API.custOrderV1.addEquipmentResolution(
                                                equipmentId: self.equipment.id,
                                                comment: comment) { resp in
                                                    loadingView(show: false)
                                                    
                                                    guard let resp else {
                                                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                                                        return
                                                    }
                                                    
                                                    guard resp.status == .ok else {
                                                        showError(.errorGeneral, resp.msg)
                                                        return
                                                    }
                                                    
                                                    self.resolution = comment
                                                    
                                                    self.equipment.resolution = comment
                                                    
                                                    var cc = 0
                                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                        if  eq.id  == self.equipment.id {
                                                            equipmentsCatch[self.orderView.order.id]![cc] = self.equipment
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                }
                                        })
                                    )
                                }
                            
                            Div("RESOLUCIOM:")
                                .hidden(self.$resolution.map{ $0.isEmpty })
                                .marginBottom(3.px)
                                .color(.gray)
                            
                            Div(self.$resolution)
                                .hidden(self.$resolution.map{ $0.isEmpty })
                                .marginBottom(3.px)
                                .color(.gray)
                                .fontSize(18.px)
                                .float(.left)
                            
                        }
                        .hidden(self.$editMode.map{$0})
                        
                        Span("Descripcion")
                            .hidden(self.$editMode.map{!$0})
                            .marginBottom(7.px)
                            .color(.yellowTC)
                        
                        self.descr
                        
                        Span("Diagnostico")
                            .hidden(self.$editMode.map{!$0})
                            .marginBottom(7.px)
                            .color(.yellowTC)
                        
                        self.diagnosticTextArea
                        
                        Span("Resolucion")
                            .hidden(self.$editMode.map{!$0})
                            .marginBottom(7.px)
                            .color(.yellowTC)
                        
                        self.resolutionTextArea
                        
                        
                    }
                    .height(99.percent)
                    .width(40.percent)
                    .overflow(.auto)
                    .float(.left)
                }
                .custom("height", "calc(100% - 58px)")
                
                Div{
                    
                    /// Ready Toggle
                    Div{
                        Label("Preparado")
                            .color(.lightGray)
                            .fontSize(14.px)
                        
                        Div().class(.clear).marginTop(1.px)
                        
                        Div{
                            InputCheckbox().toggleRental(self.isReady, self.$isReadyDisabled){ isCheked in
                                ///Flag isReady as TRUE
                                if !isCheked {
                                    
                                    if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                        
                                        loadingView(show: true)
                                        
                                        API.custOrderV1.equipmentReadyStatus(
                                            accountid: self.orderView.order.custAcct,
                                            orderid: self.orderView.order.id,
                                            orderFolio: self.orderView.order.folio,
                                            equipmentid: self.equipment.id,
                                            name: self.name,
                                            isReady: true
                                        ) { resp in
                                            
                                            loadingView(show: false)
                                            
                                            guard let resp else {
                                                showError(.errorDeCommunicacion, .serverConextionError)
                                                return
                                            }
                                            guard resp.status == .ok else{
                                                showError(.errorGeneral, resp.msg)
                                                return
                                            }
                                            
                                            self.isReady.wrappedValue = true
                                            
                                            var cc = 0
                                            equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                if eq.id  == self.equipment.id {
                                                    equipmentsCatch[self.orderView.order.id]![cc].workedBy = custCatchID
                                                }
                                                cc += 1
                                            })
                                            
                                            cc = 0
                                            self.orderView.equipments.forEach { eq in
                                                if eq.id  == self.equipment.id {
                                                    self.orderView.equipments[cc].workedBy = custCatchID
                                                }
                                                cc += 1
                                            }
                                            
                                        }
                                        
                                    }
                                    else{
                                        self.appendChild(
                                            ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: PREPARADO", callback: { confirmed,_ in
                                            if confirmed {
                                                loadingView(show: true)
                                                API.custOrderV1.equipmentReadyStatus(
                                                    accountid: self.orderView.order.custAcct,
                                                    orderid: self.orderView.order.id,
                                                    orderFolio: self.orderView.order.folio,
                                                    equipmentid: self.equipment.id,
                                                    name: self.name,
                                                    isReady: true
                                                ){ resp in
                                                    
                                                    loadingView(show: false)
                                                    
                                                    guard let resp = resp else {
                                                        showError(.errorDeCommunicacion, .serverConextionError)
                                                        return
                                                    }
                                                    guard resp.status == .ok else{
                                                        showError(.errorGeneral    , resp.msg)
                                                        return
                                                    }
                                                    
                                                    self.isReady.wrappedValue = true
                                                    
                                                    var cc = 0
                                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                        if eq.id  == self.equipment.id {
                                                            equipmentsCatch[self.orderView.order.id]![cc].workedBy = custCatchID
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                    cc = 0
                                                    self.orderView.equipments.forEach { eq in
                                                        if eq.id  == self.equipment.id {
                                                            self.orderView.rentals[cc].workedBy = custCatchID
                                                        }
                                                        cc += 1
                                                    }
                                                    
                                                    
                                                }
                                            }
                                        }))
                                    }
                                }
                                
                                /// Flag isReady as FALSE
                                else{
                                    /// Validad if user has permition to remove isReady flag
                                    if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                        self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: NO preparado", callback: { confirmed, _ in
                                            if confirmed {
                                                loadingView(show: true)
                                                API.custOrderV1.equipmentReadyStatus(
                                                    accountid: self.orderView.order.custAcct,
                                                    orderid: self.orderView.order.id,
                                                    orderFolio: self.orderView.order.folio,
                                                    equipmentid: self.equipment.id,
                                                    name: self.name,
                                                    isReady: false
                                                ){ resp in
                                                    loadingView(show: false)
                                                    
                                                    guard let resp = resp else {
                                                        showError(.errorDeCommunicacion, .serverConextionError)
                                                        return
                                                    }
                                                    guard resp.status == .ok else{
                                                        showError(.errorGeneral    , resp.msg)
                                                        return
                                                    }
                                                    
                                                    self.isReady.wrappedValue = false
                                                    
                                                    var cc = 0
                                                    rentalsCatch[self.orderView.order.id]?.forEach({ rental in
                                                        if rental.id  == self.equipment.id {
                                                            rentalsCatch[self.orderView.order.id]![cc].workedBy = nil
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                    cc = 0
                                                    self.orderView.rentals.forEach { rental in
                                                        if rental.id  == self.equipment.id {
                                                            self.orderView.rentals[cc].workedBy = nil
                                                        }
                                                        cc += 1
                                                    }
                                                }
                                            }
                                        }))
                                    }
                                    else{
                                        showAlert(.alerta, "No tiene permiso de  realizar esta accion, contatce a un \(getUsernameRoles(configStoreProcessing.restrictOrderClosing).description)")
                                    }
                                }
                                 
                            }
                        }
                        .align(.center)
                    }
                    .position(.relative)
                    .marginRight(7.px)
                    .marginLeft(7.px)
                    .float(.left)
                    .top(-7.px)
                    
                    /// PickUp Toggle
                    Div{
                        Label("Entregado")
                            .color(.lightGray)
                            .fontSize(14.px)
                        
                        Div().class(.clear).marginTop(1.px)
                        
                        Div{
                            InputCheckbox().toggleRental(self.isPicked, self.$pendingPickupDisabled){ isCheked in // self.pendingPickup = true
                                
                                ///Flag isReady as TRUE
                                if !isCheked {
                                    
                                    if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                        
                                        loadingView(show: true)
                                        
                                        API.custOrderV1.equipmentPickedStatus(
                                            accountid: self.orderView.order.custAcct,
                                            orderid: self.orderView.order.id,
                                            orderFolio: self.orderView.order.folio,
                                            equipmentid: self.equipment.id,
                                            name: self.name,
                                            pickedUp: true
                                        ){ resp in
                                            
                                            loadingView(show: false)
                                            
                                            guard let resp = resp else {
                                                showError(.errorDeCommunicacion, .serverConextionError)
                                                return
                                            }
                                            
                                            guard resp.status == .ok else{
                                                showError( .errorGeneral, resp.msg)
                                                return
                                            }
                                            
                                            guard let payload = resp.data else {
                                                showError( .unexpectedResult, .unexpenctedMissingPayload)
                                                return
                                            }
                                            
                                            self.isPicked.wrappedValue = true
                                            
                                            //self.orderView.accountView.loadOrders()
                                            self.orderView.order.pendingPickup = payload.pendingPickup
                                            orderCatch[self.orderView.order.id]?.pendingPickup = payload.pendingPickup
                                            
                                            var cc = 0
                                            equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                if eq.id == self.equipment.id {
                                                    equipmentsCatch[self.orderView.order.id]![cc].deliveredBy = custCatchID
                                                }
                                                cc += 1
                                            })
                                            
                                            cc = 0
                                            self.orderView.equipments.forEach { eq in
                                                if eq.id  == self.equipment.id {
                                                    self.orderView.equipments[cc].deliveredBy = custCatchID
                                                }
                                                cc += 1
                                            }
                                            
                                            OrderCatchControler.shared.updateParameter(self.orderView.order.id, .pendingPickup(payload.pendingPickup))
                                            
                                            self.orderView.status = payload.status
                                            
                                            //OrderCatchControler.shared.updateParameter(self.orderView.order.id, .orderStatus(payload.status))
                                            
                                            
                                        }
                                    }
                                    else{
                                        self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: ENTREGADO", callback: { confirmed, _ in
                                            if confirmed {
                                                loadingView(show: true)
                                                API.custOrderV1.equipmentPickedStatus(
                                                    accountid: self.orderView.order.custAcct,
                                                    orderid: self.orderView.order.id,
                                                    orderFolio: self.orderView.order.folio,
                                                    equipmentid: self.equipment.id,
                                                    name: self.name,
                                                    pickedUp: true
                                                ) { resp in
                                                    
                                                    loadingView(show: false)
                                                    
                                                    guard let resp = resp else {
                                                        showError(.errorDeCommunicacion, .serverConextionError)
                                                        return
                                                    }
                                                    
                                                    guard resp.status == .ok else {
                                                        showError(.errorGeneral, resp.msg)
                                                        return
                                                    }
                                                    
                                                    guard let payload = resp.data else {
                                                        showError( .unexpectedResult, .unexpenctedMissingPayload)
                                                        return
                                                    }
                                                    
                                                    //self.orderView.accountView.loadOrders()
                                                    self.orderView.order.pendingPickup = payload.pendingPickup
                                                    orderCatch[self.orderView.order.id]?.pendingPickup = payload.pendingPickup
                                                    self.orderView.status = payload.status
                                                    
                                                    self.isPicked.wrappedValue = true
                                                    
                                                    var cc = 0
                                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                        if eq.id  == self.equipment.id {
                                                            equipmentsCatch[self.orderView.order.id]![cc].deliveredBy = custCatchID
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                    cc = 0
                                                    self.orderView.rentals.forEach { eq in
                                                        if eq.id  == self.equipment.id {
                                                            self.orderView.equipments[cc].deliveredBy = custCatchID
                                                        }
                                                        cc += 1
                                                    }
                                                    
                                                    OrderCatchControler.shared.updateParameter(self.orderView.order.id, .pendingPickup(payload.pendingPickup))
                                                    
                                                }
                                            }
                                        }))
                                    }
                                }
                                /// Flag isReady as FALSE
                                else{
                                    /// Validad if user has permition to remove isReady flag
                                    if custCatchHerk >= configStoreProcessing.restrictOrderClosing {
                                        
                                        self.appendChild(ConfirmView(type: .yesNo, title: "Confirme", message: "Marcar como: NO entregado", callback: { confirmed, _ in
                                            
                                            if confirmed {
                                                
                                                loadingView(show: true)
                                                
                                                API.custOrderV1.equipmentPickedStatus(
                                                    accountid: self.orderView.order.custAcct,
                                                    orderid: self.orderView.order.id,
                                                    orderFolio: self.orderView.order.folio,
                                                    equipmentid: self.equipment.id,
                                                    name: self.name,
                                                    pickedUp: false
                                                ) { resp in
                                                    loadingView(show: false)
                                                    
                                                    guard let resp = resp else {
                                                        showError(.errorDeCommunicacion, .serverConextionError)
                                                        return
                                                    }
                                                    guard resp.status == .ok else{
                                                        showError(.errorGeneral, resp.msg)
                                                        return
                                                    }
                                                    
                                                    guard let payload = resp.data else {
                                                        showError( .unexpectedResult, .unexpenctedMissingPayload)
                                                        return
                                                    }
                                                    
                                                    self.isPicked.wrappedValue = false
                                                    
                                                    self.orderView.order.pendingPickup = payload.pendingPickup
                                                    //self.orderView.accountView.loadOrders()
                                                    orderCatch[self.orderView.order.id]?.pendingPickup = payload.pendingPickup
                                                    
                                                    var cc = 0
                                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                                        if eq.id  == self.equipment.id {
                                                            equipmentsCatch[self.orderView.order.id]![cc].deliveredBy = nil
                                                        }
                                                        cc += 1
                                                    })
                                                    
                                                    cc = 0
                                                    self.orderView.equipments.forEach { eq in
                                                        if eq.id  == self.equipment.id {
                                                            self.orderView.equipments[cc].deliveredBy = nil
                                                        }
                                                        cc += 1
                                                    }
                                                    
                                                    OrderCatchControler.shared.updateParameter(self.orderView.order.id, .pendingPickup(payload.pendingPickup))
                                                    
                                                    self.orderView.status = payload.status
                                                    
                                                }
                                            }
                                        }))
                                    }
                                    else{
                                        showAlert(.alerta, "No tiene permiso de  realizar esta accion, contatce a un \(getUsernameRoles(configStoreProcessing.restrictOrderClosing).description)")
                                    }
                                }
                            }
                        }
                        .align(.center)
                        
                    }
                    .position(.relative)
                    .float(.left)
                    .top(-7.px)
                    
                    Img()
                        .src("/skyline/media/cross.png")
                        .hidden(self.$editMode.map{!$0})
                        .marginRight(12.px)
                        .marginTop(7.px)
                        .cursor(.pointer)
                        .height(32.px)
                        .float(.right)
                        .onClick { img, event in
                            
                            self.editMode = false
                            
                            self._idTag1 = self.equipment.IDTag1
                            self._idTag2 = self.equipment.IDTag2
                            self._tag1 = self.equipment.tag1
                            self._tag2 = self.equipment.tag2
                            self._tag3 = self.equipment.tag3
                            self._tag4 = self.equipment.tag4
                            self._tag5 = self.equipment.tag5
                            self._tag6 = self.equipment.tag6
                            self._descr = self.equipment.tagDescr
                            self._checkTag1 = self.equipment.tagCheck1
                            self._checkTag2 = self.equipment.tagCheck2
                            self._checkTag3 = self.equipment.tagCheck3
                            self._checkTag4 = self.equipment.tagCheck4
                            self._checkTag5 = self.equipment.tagCheck5
                            self._checkTag6 = self.equipment.tagCheck6
                            self.diagnostic = self.equipment.diagnostic ?? ""
                            self.resolution = self.equipment.resolution ?? ""
                            
                        }
                        
                    Img()
                        .src(self.$editMode.map{ $0 ? "/skyline/media/diskette.png" : "/skyline/media/pencil.png"})
                        .marginRight(7.px)
                        .marginTop(7.px)
                        .cursor(.pointer)
                        .height(32.px)
                        .float(.right)
                        .onClick { img, event in
                            
                            /// Edit mode is on  qwill try to save
                            if self.editMode {
                                
                                var canSave = false
                                
                                if self._idTag1 != self.equipment.IDTag1 { canSave =  true }
                                if self._idTag2 != self.equipment.IDTag2 { canSave =  true }
                                if self._tag1 != self.equipment.tag1 { canSave =  true }
                                if self._tag2 != self.equipment.tag2 { canSave =  true }
                                if self._tag3 != self.equipment.tag3 { canSave =  true }
                                if self._tag4 != self.equipment.tag4 { canSave =  true }
                                if self._tag5 != self.equipment.tag5 { canSave =  true }
                                if self._tag6 != self.equipment.tag6 { canSave =  true }
                                if self._descr != self.equipment.tagDescr { canSave =  true }
                                if self._checkTag1 != self.equipment.tagCheck1 { canSave =  true }
                                if self._checkTag2 != self.equipment.tagCheck2 { canSave =  true }
                                if self._checkTag3 != self.equipment.tagCheck3 { canSave =  true }
                                if self._checkTag4 != self.equipment.tagCheck4 { canSave =  true }
                                if self._checkTag5 != self.equipment.tagCheck5 { canSave =  true }
                                if self._checkTag6 != self.equipment.tagCheck6 { canSave =  true }
                                if self.diagnostic != self.equipment.diagnostic { canSave = true }
                                if self.resolution != self.equipment.resolution { canSave = true }
                                
                                guard canSave else {
                                    self.editMode = false
                                    return
                                }
                                
                                loadingView(show: true)
                                
                                var _diagnostic: String? = nil
                                
                                if !self.diagnostic.isEmpty {
                                    _diagnostic = self.diagnostic
                                }
                                
                                var _resolution: String? = nil
                                
                                if !self.resolution.isEmpty {
                                    _resolution = self.resolution
                                }
                                
                                API.custOrderV1.saveFolioObjectDetail(
                                    id: self.equipment.id,
                                    IDTag1: self._idTag1,
                                    IDTag2: self._idTag2,
                                    tag1: self._tag1,
                                    tag2: self._tag2,
                                    tag3: self._tag3,
                                    tag4: self._tag4,
                                    tag5: self._tag5,
                                    tag6: self._tag6,
                                    tagCheck1: self._checkTag1,
                                    tagCheck2: self._checkTag2,
                                    tagCheck3: self._checkTag3,
                                    tagCheck4: self._checkTag4,
                                    tagCheck5: self._checkTag5,
                                    tagCheck6: self._checkTag6,
                                    diagnostic: _diagnostic,
                                    resolution: _resolution,
                                    tagDescr: self._descr
                                ) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp else {
                                        showError(.errorDeCommunicacion, .serverConextionError)
                                        return
                                    }
                                    
                                    guard resp.status == .ok else {
                                        showError(.errorGeneral, resp.msg)
                                        return
                                    }
                                    
                                    self.equipment.IDTag1 = self._idTag1
                                    self.equipment.IDTag2 = self._idTag2
                                    self.equipment.tag1 = self._tag1
                                    self.equipment.tag2 = self._tag2
                                    self.equipment.tag3 = self._tag3
                                    self.equipment.tag4 = self._tag4
                                    self.equipment.tag5 = self._tag5
                                    self.equipment.tag6 = self._tag6
                                    self.equipment.tagDescr = self._descr
                                    self.equipment.tagCheck1 = self._checkTag1
                                    self.equipment.tagCheck2 = self._checkTag2
                                    self.equipment.tagCheck3 = self._checkTag3
                                    self.equipment.tagCheck4 = self._checkTag4
                                    self.equipment.tagCheck5 = self._checkTag5
                                    self.equipment.tagCheck6 = self._checkTag6
                                    self.equipment.diagnostic = _diagnostic
                                    self.equipment.resolution = _resolution
                                    
                                    var cc = 0
                                    equipmentsCatch[self.orderView.order.id]?.forEach({ eq in
                                        if  eq.id  == self.equipment.id {
                                            equipmentsCatch[self.orderView.order.id]![cc] = self.equipment
                                        }
                                        cc += 1
                                    })
                                    
                                    self.editMode = false

                                }
                                
                                return
                            }
                            
                            self.editMode = true
                        }
                    
                    Div{
                        Div{
                            ///  Pendiente consumible
                            Div{
                                Img()
                                    .src("/skyline/media/icon_delegate.png")
                                    .marginRight(7.px)
                                    .marginLeft(12.px)
                                    .marginTop(7.px)
                                    .height(24.px)
                                
                                Div{
                                    Div("Pendiente")
                                    Div("Insumo")
                                }
                                .textAlign(.center)
                                .marginRight(7.px)
                                .fontSize(16.px)
                                .float(.right)
                            }
                            .marginRight(12.px)
                            .hidden(self.$equipmentStatus.map{ $0 != .onwork })
                            .class(.uibtn)
                            .float(.right)
                            .onClick { _ in
                                
                                addToDom(SendToPendingConsumable(
                                    orderId: self.orderView.order.id,
                                    equipmentId: self.equipment.id,
                                    lastCommunicationMethod: self.orderView.lastCommunicationMethod,
                                    callback: { newDate, manager in
                                        
                                        self.orderView.dueDate = newDate
                                        
                                        self.pendingSpareEvent = manager.id
                                        
                                        self.equipment.pendingSpare = manager
                                        
                                        self.equipmentStatus = .pendingConsumable
                                     
                                        OrderCatchControler.shared.updateParameter(self.orderView.order.id, .orderStatus(.pendingSpare))
                                        
                                        var equipments: [CustOrderLoadFolioEquipments] = []
                                        
                                        equipmentsCatch[self.orderView.order.id]?.forEach { equipment in
                                         
                                            if equipment.id == self.equipment.id {
                                                equipments.append(.init(
                                                    id: equipment.id,
                                                    createdAt: equipment.createdAt,
                                                    workedBy: equipment.workedBy,
                                                    deliveredBy: equipment.deliveredBy,
                                                    IDTag1: equipment.IDTag1,
                                                    IDTag2: equipment.IDTag2,
                                                    tag1: equipment.tag1,
                                                    tag2: equipment.tag2,
                                                    tag3: equipment.tag3,
                                                    tag4: equipment.tag4,
                                                    tag5: equipment.tag5,
                                                    tag6: equipment.tag6,
                                                    tagDescr: equipment.tagDescr,
                                                    tagCheck1: equipment.tagCheck1,
                                                    tagCheck2: equipment.tagCheck2,
                                                    tagCheck3: equipment.tagCheck3,
                                                    tagCheck4: equipment.tagCheck4,
                                                    tagCheck5: equipment.tagCheck5,
                                                    tagCheck6: equipment.tagCheck6,
                                                    pendingSpareEvent: manager.id,
                                                    pendingSpare: manager,
                                                    diagnostic: equipment.diagnostic,
                                                    resolution: equipment.resolution,
                                                    status: .pendingConsumable
                                                ))
                                            }
                                            else {
                                                equipments.append(equipment)
                                            }
                                        }
                                        
                                        equipmentsCatch[self.orderView.order.id] = equipments
                                        
                                    }
                                ))
                                
                            }
                        
                            ///  Confirm Purchase
                            Div{
                                Img()
                                    .src("/skyline/media/checkmark2.png")
                                    .marginRight(7.px)
                                    .marginLeft(12.px)
                                    .marginTop(7.px)
                                    .height(24.px)
                                
                                Div{
                                    Div("Confirmar")
                                    Div("Compra")
                                }
                                .textAlign(.center)
                                .marginRight(7.px)
                                .fontSize(16.px)
                                .float(.right)
                            }
                            .hidden(self.$equipmentStatus.map{ $0 != .pendingConsumable })
                            .marginRight(12.px)
                            .class(.uibtn)
                            .float(.right)
                            .onClick { _ in
                                
                                guard let maneger = self.equipment.pendingSpare else {
                                    showError(.unexpectedResult, "No se localizo id de la peticion, refresque. Si el error continua contacte a Soporte TC")
                                    return
                                }
                                
                                let view = ContinueFromPendingConsumable(
                                    orderId: self.orderView.order.id,
                                    equipmentId: self.equipment.id,
                                    maneger: maneger,
                                    lastCommunicationMethod: self.orderView.lastCommunicationMethod
                                ) { status in
                                    self.pendingSpareEvent = nil
                                    self.equipmentStatus = .onwork
                                    
                                   var equipments: [CustOrderLoadFolioEquipments] = []
                                   
                                   equipmentsCatch[self.orderView.order.id]?.forEach { equipment in
                                    
                                       if equipment.id == self.equipment.id {
                                           equipments.append(.init(
                                               id: equipment.id,
                                               createdAt: equipment.createdAt,
                                               workedBy: equipment.workedBy,
                                               deliveredBy: equipment.deliveredBy,
                                               IDTag1: equipment.IDTag1,
                                               IDTag2: equipment.IDTag2,
                                               tag1: equipment.tag1,
                                               tag2: equipment.tag2,
                                               tag3: equipment.tag3,
                                               tag4: equipment.tag4,
                                               tag5: equipment.tag5,
                                               tag6: equipment.tag6,
                                               tagDescr: equipment.tagDescr,
                                               tagCheck1: equipment.tagCheck1,
                                               tagCheck2: equipment.tagCheck2,
                                               tagCheck3: equipment.tagCheck3,
                                               tagCheck4: equipment.tagCheck4,
                                               tagCheck5: equipment.tagCheck5,
                                               tagCheck6: equipment.tagCheck6,
                                               pendingSpareEvent: nil,
                                               pendingSpare: equipment.pendingSpare,
                                               diagnostic: equipment.diagnostic,
                                               resolution: equipment.resolution,
                                               status: .onwork
                                           ))
                                       }
                                       else {
                                           equipments.append(equipment)
                                       }
                                   }
                                   
                                   equipmentsCatch[self.orderView.order.id] = equipments
                                   
                                    
                                    if self.status.wrappedValue != status {
                                       
                                        self.status.wrappedValue = status
                                        
                                        OrderCatchControler.shared.updateParameter(self.orderView.order.id, .orderStatus(status))
                                        
                                    }
                                    
                                    
                                }
                                
                                addToDom(view)
                            }
                            
                            ///  Cancel Purchase
                            Div{
                                Img()
                                    .src("/skyline/media/cross.png")
                                    .marginRight(7.px)
                                    .marginLeft(12.px)
                                    .marginTop(7.px)
                                    .height(24.px)
                                
                                Div{
                                    Div("Cancelar")
                                    Div("Compra")
                                }
                                .textAlign(.center)
                                .marginRight(7.px)
                                .fontSize(16.px)
                                .float(.right)
                            }
                            .hidden(self.$equipmentStatus.map{ $0 != .pendingConsumable })
                            .marginRight(7.px)
                            .class(.uibtn)
                            .float(.right)
                            .onClick { _ in
                                addToDom(ConfirmView(
                                    type: .yesNo,
                                    title: "Eliminar Compra",
                                    message: "Confirme que no se comprara insumo/refaccion.",
                                    requiersComment: true,
                                    callback: { isConfirmed, comment in
                                        
                                        guard let managerId = self.pendingSpareEvent else {
                                            showError(.unexpectedResult, "No se localizo id de la peticion, refresque. Si el error continua contacte a Soporte TC")
                                            return
                                        }
                                        
                                        loadingView(show: true)
                                        
                                        API.custOrderV1.pendingConsumableContinue(
                                            hasPurchase: false,
                                            orderId: self.orderView.order.id,
                                            equipmentId: self.equipment.id,
                                            managerId: managerId,
                                            vendorId: nil,
                                            documentId: nil,
                                            documentFolio: "",
                                            comment: comment,
                                            sendComm: false,
                                            lastCommunicationMethod: self.orderView.lastCommunicationMethod
                                        ) { resp in
                                            
                                            loadingView(show: false)
                                            
                                            guard let resp else {
                                                showError(.errorDeCommunicacion, .unexpenctedMissingPayload)
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
                                            
                                            self.pendingSpareEvent = nil
                                            
                                            self.equipmentStatus = .onwork
                                            
                                            if self.status.wrappedValue != payload.orderStatus {
                                               
                                                self.status.wrappedValue = payload.orderStatus
                                                
                                                orderCatch[self.orderView.order.id]?.status = payload.orderStatus
                                                
                                                OrderCatchControler.shared.updateParameter(self.orderView.order.id, .orderStatus(payload.orderStatus))
                                                
                                            }
                                            
                                            var equipments: [CustOrderLoadFolioEquipments] = []
                                           
                                            equipmentsCatch[self.orderView.order.id]?.forEach { equipment in
                                            
                                               if equipment.id == self.equipment.id {
                                                   equipments.append(.init(
                                                       id: equipment.id,
                                                       createdAt: equipment.createdAt,
                                                       workedBy: equipment.workedBy,
                                                       deliveredBy: equipment.deliveredBy,
                                                       IDTag1: equipment.IDTag1,
                                                       IDTag2: equipment.IDTag2,
                                                       tag1: equipment.tag1,
                                                       tag2: equipment.tag2,
                                                       tag3: equipment.tag3,
                                                       tag4: equipment.tag4,
                                                       tag5: equipment.tag5,
                                                       tag6: equipment.tag6,
                                                       tagDescr: equipment.tagDescr,
                                                       tagCheck1: equipment.tagCheck1,
                                                       tagCheck2: equipment.tagCheck2,
                                                       tagCheck3: equipment.tagCheck3,
                                                       tagCheck4: equipment.tagCheck4,
                                                       tagCheck5: equipment.tagCheck5,
                                                       tagCheck6: equipment.tagCheck6,
                                                       pendingSpareEvent: nil,
                                                       pendingSpare: equipment.pendingSpare,
                                                       diagnostic: equipment.diagnostic,
                                                       resolution: equipment.resolution,
                                                       status: .onwork
                                                   ))
                                               }
                                               else {
                                                   equipments.append(equipment)
                                               }
                                           }
                                           
                                            equipmentsCatch[self.orderView.order.id] = equipments
                                           
                                        }
                                        
                                    }
                                ))
                            }
                        }
                        .hidden(self.$editMode.map{$0})
                    }
                    .hidden(self.status.map{ ![
                        CustFolioStatus.active,
                        CustFolioStatus.pendingSpare,
                        CustFolioStatus.sideStatus
                    ].contains($0) })
                    .float(.right)
                    
                }
                .backgroundColor(r: 35, g: 39, b: 47)
                .borderRadius(12.px)
                .padding(all: 3.px)
                .marginLeft(7.px)
                .height(45.px)
                
            }
            .height(100.percent)
            .width(65.percent)
            .overflow(.auto)
            .float(.left)
            
        }
        
        override func buildUI() {
            super.buildUI()
            height(100.percent)
            width(100.percent)
            
            self.$editMode.listen {
                self.isDisabled = !$0
            }
            
            self.isReady.listen {
                if $0 {
                    self.pendingPickupDisabled = false
                }
                else {
                    self.pendingPickupDisabled = true
                }
            }
            
            self.isPicked.listen {
                if !$0 {
                    self.isReadyDisabled = false
                }
                else {
                    self.isReadyDisabled = true
                }
            }
            
            self.status.listen {
                
                if !self.unWorkableStatus.contains($0) {
                    /// cheke if it has been prepared
                    if let _ = self.equipment.workedBy {
                        
                        if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                            self.isReadyDisabled = true
                        }
                        else{
                            self.isReadyDisabled = false
                        }
                        
                        if let _ = self.equipment.deliveredBy {
                            if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                                self.pendingPickupDisabled = true
                            }
                            else{
                                self.pendingPickupDisabled = false
                            }
                        }
                    }
                    else {
                        
                        if $0 == .active {
                            self.equipmentStatus = .onwork
                        }
                        
                        self.isReadyDisabled = false
                        self.pendingPickupDisabled = true
                    }
                }
                
            }
            
            _idTag1 = equipment.IDTag1
            
            _idTag2 = equipment.IDTag2
            
            _tag1 = equipment.tag1
            
            _tag2 = equipment.tag2
            
            _tag3 = equipment.tag3
            
            _tag4 = equipment.tag4
            
            _tag5 = equipment.tag5
            
            _tag6 = equipment.tag6
            
            _descr = equipment.tagDescr
            
            _checkTag1 = equipment.tagCheck1
            
            _checkTag2 = equipment.tagCheck2
            
            _checkTag3 = equipment.tagCheck3
            
            _checkTag4 = equipment.tagCheck4
            
            _checkTag5 = equipment.tagCheck5
            
            _checkTag6 = equipment.tagCheck6
            
            diagnostic = equipment.diagnostic ?? ""
            
            resolution = equipment.resolution ?? ""
            
            equipmentStatus = equipment.status
            
            self.workedBy = self.equipment.workedBy
            self.deliveredBy = self.equipment.deliveredBy
            
            /// cheke if it has been prepared
            if let workedBy = self.equipment.workedBy {
                self.workedBy = workedBy
                self.isReady.wrappedValue = true
                if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                    self.isReadyDisabled = true
                }
            }
            else {
                self.isReady.wrappedValue = false
            }
            
            if let deliveredBy = self.equipment.deliveredBy {
                self.deliveredBy = deliveredBy
                self.isPicked.wrappedValue = true
                if custCatchHerk < configStoreProcessing.restrictOrderClosing {
                    self.pendingPickupDisabled = true
                }
            }
            else {
                self.isPicked.wrappedValue = false
            }
            
            if unWorkableStatus.contains(self.status.wrappedValue) {
                self.isReadyDisabled = true
                if self.isPicked.wrappedValue {
                    self.pendingPickupDisabled = true
                }
            }
            
            var nameCount = 0
            
            if !_tag1.isEmpty {
                name = _tag1
                nameCount += 1
            }
            
            if !_tag2.isEmpty {
                name += " \(_tag2)"
                nameCount += 1
            }
            if !_tag3.isEmpty && nameCount < 2 {
                name += " \(_tag3)"
                nameCount += 1
            }
            if !_tag4.isEmpty && nameCount < 2 {
                name += " \(_tag4)"
            }
            
        }
        
    }
}
