//
//  InventoryControlView.swift
//  
//
//  Created by Victor Cantu on 10/5/22.
//

import Foundation
import TCFundamentals
import Web

class InventoryControlView: Div {
    
    override class var name: String { "div" } 
    
    let control: CustFiscalInventoryControl
    let items: [CustPOCInventoryQuick]
    let pocs: [CustPOCQuick]
    let places: [CustPOCStoragePlace]
    let notes: [CustGeneralNotesQuick]
    let fromStore: CustStoreBasic
    let toStore: CustStoreBasic?
    
    private var hasRecived: (() -> ())
    
    private var hasIngressed: (() -> ())
    
    init(
        control: CustFiscalInventoryControl,
        items: [CustPOCInventoryQuick],
        pocs: [CustPOCQuick],
        places: [CustPOCStoragePlace],
        notes: [CustGeneralNotesQuick],
        fromStore: CustStoreBasic,
        toStore: CustStoreBasic?,
        hasRecived: @escaping (() -> ()),
        hasIngressed: @escaping (() -> ())
    ) {
        self.control = control
        self.items = items
        self.pocs = pocs
        self.places = places
        self.notes = notes
        self.fromStore = fromStore
        self.toStore = toStore
        self.hasRecived = hasRecived
        self.hasIngressed = hasIngressed
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var pin = ""
    
    @State var isReceived = false
    
    @State var receivedByName = ""
    
    @State var closedByName = ""
    
    lazy var toStoreDiv = Div()
    
    lazy var notesDiv = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(200.px)
    
    lazy var confimationToolDiv = Div {
        H2("Confirmacion")
            .marginTop(7.px)
            .marginBottom(3.px)
            .color(.white)
        
        Div{
            Label("PIN")
                .fontSize(18.px)
                .color(.lightGray)
            
            Div(self.$pin.map{ $0.isEmpty ? "-- pendiente --" : $0 })
                .fontSize(18.px)
                .color(.lightGray)
                .align(.center)
        }
        .class(.section)
        
        Div().class(.clear)
        
        
        Div{
            Label("Recepcion")
                .fontSize(18.px)
                .color(.lightGray)
            
            Div(self.$receivedByName.map{ $0.isEmpty ? "" : $0 })
                .fontSize(18.px)
                .color(.lightGray)
                .align(.center)
        }
        .class(.section)
        
        Div().class(.clear)
        
        Div{
            Label("Ingreso")
                .fontSize(18.px)
                .color(.lightGray)
            
            Div(self.$closedByName.map{ $0.isEmpty ? "" : $0 })
                .fontSize(18.px)
                .color(.lightGray)
                .align(.center)
        }
        .class(.section)
        
        Div().class(.clear)
        
        self.confimationToolBtn
        
        Div().class(.clear)
        
    }
    
    lazy var confimationToolBtn = Div()
        .marginTop(18.px)
    
    lazy var itemGridTable = Table{
        Tr{
            Td("Unis.")
                .align(.center)
                .width(35.px)
            Td("Marca")
                .align(.center)
                .width(100.px)
            Td("Modelo")
                .align(.center)
                .width(100.px)
            Td("Descripcion")
            Td("Serie")
                .align(.center)
                .width(100.px)
            Td("Bodega")
                .align(.center)
                .width(120.px)
            Td("Section")
                .align(.center)
                .width(120.px)
        }
    }
        .width(100.percent)
        .color(.white)
    
    var itemRef: [InventoryControlItemView] = []
    
    @State var downloadDocumentViewIsHidden = true
    
    @DOM override var body: DOM.Content {
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                
                Div{
                    
                    Div{
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .height(18.px)
                            .marginLeft(7.px)
                        
                        Span("Imprimir")
                        
                        Div{
                            Img()
                                .src(self.$downloadDocumentViewIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                .class(.iconWhite)
                                .paddingTop(7.px)
                                .width(14.px)
                        }
                        .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                        .paddingRight(3.px)
                        .paddingLeft(7.px)
                        .marginLeft(7.px)
                        .float(.right)
                        
                        Div().clear(.both)
                    }
                    .class(.uibtn)
                    .onClick { _, event in
                        self.downloadDocumentViewIsHidden = !self.downloadDocumentViewIsHidden
                        event.stopPropagation()
                    }
                    
                    Div{
                        //
                        Div{
                            Span("Con Detalle")
                        }
                        .width(90.percent)
                        .marginTop(7.px)
                        .class(.uibtn)
                        .onClick {
                            downLoadInventoryControlOrders(id: self.control.id, detailed: true)
                        }
                        
                        Div{
                            Span("Sin Detalle")
                        }
                        .width(90.percent)
                        .marginTop(7.px)
                        .class(.uibtn)
                        .onClick {
                            downLoadInventoryControlOrders(id: self.control.id, detailed: false)
                        }
                        
                        Div().marginTop(7.px)
                    }
                    .hidden(self.$downloadDocumentViewIsHidden)
                    .backgroundColor(.transparentBlack)
                    .position(.absolute)
                    .borderRadius(12.px)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .top(42.px)
                    .zIndex(1)
                    .onClick { _, event in
                        self.downloadDocumentViewIsHidden = true
                        event.stopPropagation()
                    }
                    Div().clear(.both)

                }
                .marginRight(18.px)
                .marginTop(-4.px)
                .float(.right)
                
                if !self.control.isRecived && !self.control.isClosed {
                    
                    Div{
                        Img()
                            .src("/skyline/media/cross.png")
                            .marginLeft(7.px)
                            .height(18.px)
                        
                        Span("Cancelar")
                    }
                    .hidden(self.$receivedByName.map{ !$0.isEmpty })
                    .marginRight(18.px)
                    .marginTop(-4.px)
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        self.cancelDocument()
                    }
                }
                
                H2("Documeto de control de inventario \(self.control.disperseType.description.uppercased()): \(self.control.folio)")
                    .color(.lightBlueText)
            }
            .marginBottom(3.px)
            
            /// Left Grid
            Div{
                
                H2("Tienda Origen")
                    .marginTop(3.px)
                    .marginBottom(3.px)
                    .color(.white)
                
                Div(self.fromStore.name)
                    .class(.oneLineText)
                    .marginBottom(7.px)
                    .fontSize(23.px)
                    .color(.gray)
                
                Div(self.fromStore.street)
                    .class(.oneLineText)
                    .marginBottom(7.px)
                    .fontSize(18.px)
                    .color(.gray)
                
                Div("\(self.fromStore.colony) \(self.fromStore.city)")
                    .class(.oneLineText)
                    .marginBottom(7.px)
                    .fontSize(18.px)
                    .color(.gray)
                
                self.toStoreDiv
                
                self.confimationToolDiv
                
                
                H2("Notas")
                    .marginTop(3.px)
                    .marginBottom(7.px)
                    .color(.white)
                
                self.notesDiv
                
            }
            .custom("height", "calc(100% - 40px)")
            .overflow(.auto)
            .width(250.px)
            .float(.left)
            
            /// Right Grid
            Div{
                H2("Lista de mercancia")
                    .marginTop(3.px)
                    .marginBottom(3.px)
                    .color(.white)
                
                Div{
                    self.itemGridTable
                }
                .custom("height", "calc(100% - 45px)")
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .overflow(.auto)
            }
            .custom("height", "calc(100% - 40px)")
            .custom("width", "calc(100% - 257px)")
            .marginLeft(7.px)
            .float(.left)
            
        }
        .custom("height", "calc(100% - 100px)")
        .custom("width", "calc(100% - 100px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .left(50.px)
        .top(60.px)
    }
            
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        onClick {
            self.downloadDocumentViewIsHidden = true
        }
        
        isReceived = control.isRecived
        
        if let toStore = toStore {
            
            self.toStoreDiv.appendChild(
                H2("Tienda Destino")
                    .marginTop(3.px)
                    .marginBottom(7.px)
                    .color(.white)
            )

            self.toStoreDiv.appendChild(
                Div(toStore.name)
                    .marginBottom(7.px)
                    .fontSize(23.px)
                    .color(.gray)
            )
            
            self.toStoreDiv.appendChild(
                Div(toStore.street)
                    .marginBottom(7.px)
                    .fontSize(18.px)
                    .color(.gray)
            )
            
            self.toStoreDiv.appendChild(
                Div("\(toStore.colony) \(toStore.city)")
                    .marginBottom(7.px)
                    .fontSize(18.px)
                    .color(.gray)
            )
            
        }
        
        notes.forEach { note in
            
            let date = getDate(note.createdAt)
            
            @State var uname = ""
            
            if let uid = note.createdBy {
                getUserRefrence(id: .id(uid)) { user in
                    if let user = user {
                        
                        if let prefix = user.username.explode("@").first {
                            uname = "@\(prefix)"
                        }
                        else{
                            uname = "\(user.firstName) \(user.lastName)"
                        }
                        
                    }
                }
            }
            
            self.notesDiv.appendChild(Div{
                
                Div{
                    Span(date.formatedLong)
                    Span($uname)
                        .float(.right)
                }
                .margin(all: 3.px)
                .fontSize(14.px)
                .color(.gray)
                
                Div(note.activity)
                    .fontSize(14.px)
                    .margin(all: 3.px)
                    .color(.white)
                
            }.marginBottom(3.px))
        }
        
        if !control.isClosed {
            //self.confimationToolDiv.app
        }
        
        if let id = control.receivedBy {
            
            getUserRefrence(id: .id(id)) { user in
                
                guard let user = user else {
                    return
                }
                
                if let uname = user.username.explode("@").first {
                    self.receivedByName = "@\(uname)"
                }
                else{
                    self.receivedByName = "\(user.firstName) \(user.lastName)"
                }

            }
        }
        
        if let id = control.closedBy {
            getUserRefrence(id: .id(id)) { user in
                guard let user = user else {
                    return
                }
                
                if let uname = user.username.explode("@").first {
                    self.closedByName = "@\(uname)"
                }
                else{
                    self.closedByName = "\(user.firstName) \(user.lastName)"
                }

            }
        }
        
        switch self.control.disperseType {
        case .store:
            
            if let _toStore = toStore {
                
                if _toStore.id == custCatchStore {
                    
                    if !control.isRecived {
                        
                        self.confimationToolBtn.appendChild(
                            Div("Recibir Mercancia")
                                .class(.uibtnLargeOrange)
                                .marginRight(12.px)
                                .width(95.percent)
                                .marginTop(-7.px)
                                .align(.center)
                                .onClick {
                                    self.reciveMerch()
                                }
                        )
                        
                    }
                    else if !control.isClosed {
                        
                        self.confimationToolBtn.appendChild(
                            
                            Div("Ingresar Mercancia")
                                .class(.uibtnLargeOrange)
                                .marginRight(12.px)
                                .width(95.percent)
                                .marginTop(-7.px)
                                .align(.center)
                                .onClick {
                                    self.saveMerch()
                                }
                        )
                        
                    }
                }
                
            }
            
        case .order, .concession, .unconcession:
            break
        case .sold, .merm, .returnToVendor, .missingFromVendor:
            
            if !control.isClosed {
                
                if custCatchHerk > 3 {
                    
                    self.confimationToolBtn.appendChild(
                        Div("Autorizar Documento")
                            .class(.uibtnLargeOrange)
                            .marginRight(12.px)
                            .marginTop(-7.px)
                            .onClick {
                                self.authDocument()
                            }
                    )
                }
            }
        }
        
        pin = control.confirmationPin
        
        /// POC Id /  Item
        var itemref: [UUID:[CustPOCInventoryQuick]] = [:]
        
        /// POC Id /  Item
        var placeref: [UUID:CustPOCStoragePlace] = [:]
        
        var pocref: [UUID:CustPOCQuick] = [:]
        
        items.forEach { item in
            if let _ = itemref[item.POC] {
                itemref[item.POC]?.append(item)
            }
            else{
                itemref[item.POC] = [item]
            }
        }
        
        places.forEach { place in
            placeref[place.poc] = place
        }
        
        pocs.forEach { poc in
            pocref[poc.id] = poc
        }
        
        itemref.forEach { pocid, items in
            
            guard let poc = pocref[pocid] else{
                return
            }
            
            let pf = placeref[pocid]
            
            print("pf?.bodid")
            print(pf?.bodid ?? "N/A")
            print("pf?.secid ")
            print(pf?.secid ?? "N/A")
            
            let view = InventoryControlItemView(
                poc: poc,
                items: items.map{ $0.id},
                store: toStore?.id,
                bod: pf?.bodid ?? items.first?.custStoreBodegas,
                sec: pf?.secid ?? items.first?.custStoreSecciones,
                closedByName: self.$closedByName
            )
            
            self.itemRef.append(view)
            
            self.itemGridTable.appendChild(view)
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $pin.removeAllListeners()
    }
    
    /// Used to process `CustFiscalInventoryControl`.disperseType: `InventoryPlaceType`.store AKA: Tranfer Inventorie
    func reciveMerch() {
        
        addToDom(ConfirmView(
            type: .yesNo,
            title: "Recibir Mercancia",
            message: "Confirme Accion",
            callback: { isConfirmed, comment in
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.reciveTransferInventory(
                        docid: self.control.id
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        if resp.status != .ok {
                            showError(.campoRequerido, resp.msg)
                            return
                        }
                        
                        guard let _pin = resp.folio else{
                            showError(.campoRequerido, "No se obtuvo PIN de confirmacion")
                            return
                        }
                        
                        self.pin = _pin
                        
                        self.isReceived = true
                        
                        self.receivedByName = "@\(custCatchUser.explode("@").first ?? custCatchUser)"
                        
                        addToDom( ConfirmView(type: .ok, title: "Inventario Aceptado", message: "PIN de confirmacion:\n\(self.pin)", callback: { isConfirmed, comment in
                            
                        }))
                        
                        self.confimationToolBtn.innerHTML = ""
                        
                        self.confimationToolBtn.appendChild(
                            
                            Div("Ingresar Mercancia")
                                .class(.uibtnLargeOrange)
                                .marginRight(12.px)
                                .width(95.percent)
                                .marginTop(-7.px)
                                .align(.center)
                                .onClick {
                                    self.saveMerch()
                                }
                        )
                        
                        if self.toStore?.id == custCatchStore {
                            self.hasRecived()
                        }
                        
                    }
                }
            })
        )
        
    }
    
    /// Used to process `CustFiscalInventoryControl`.disperseType: `InventoryPlaceType`.store AKA: Tranfer Inventorie
    func saveMerch(){
        
        var objs: [API.custPOCV1.SaveTransferInventoryObject] = []
        
        var hasError: Bool = false
        
        //InventoryControlItemView
        
        itemRef.forEach { item in
            
            guard let bod = item.bodid else {
                hasError = true
                showError(.campoRequerido, "Seleccione bodega para: \(item.poc.name) \(item.poc.model)")
                return
            }
            
            guard let sec = item.secid else {
                hasError = true
                showError(.campoRequerido, "Seleccione seccion para: \(item.poc.name) \(item.poc.model)")
                return
            }
            
            objs.append(.init(
                pocid: item.poc.id,
                name: "\(item.poc.name) \(item.poc.model)".purgeSpaces,
                ids: item.items,
                bod: bod,
                sec: sec
            ))
        }
        
        if hasError {
            return
        }
        
        addToDom(ConfirmView(
            type: .yesNo,
            title: "Ingresar Mercancia",
            message: "Confirme Accion",
            callback: { isConfirmed, comment in
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.saveTransferInventory(
                        docid: self.control.id,
                        items: objs,
                        storeid: custCatchStore
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        if resp.status != .ok {
                            showError(.campoRequerido, resp.msg)
                            return
                        }
                        
                        self.closedByName = "@\(custCatchUser.explode("@").first ?? custCatchUser)"
                        
                        self.confimationToolBtn.innerHTML = ""
                        
                        if self.toStore?.id == custCatchStore {
                            self.hasIngressed()
                        }
                        
                    }
                }
            })
        )
            
        
    }
    
    /// Used to process `CustFiscalInventoryControl`.disperseType: `InventoryPlaceType`.sold, `InventoryPlaceType`.merm, `InventoryPlaceType`.returnToVendor, `InventoryPlaceType`.missingFromVendor
    func authDocument() {
        
        addToDom(ConfirmView(
            type: .yesNo,
            title: "Autorizar Documemto",
            message: "Confirme que este documeto esta correcto",
            callback: { isConfirmed, comment in
                if isConfirmed {
                    
                    var objs: [API.custPOCV1.AuthTransferInventoryObject] = []
                    
                    self.itemRef.forEach { item in
                        
                        objs.append(.init(
                            name: "\(item.poc.name) \(item.poc.model)".purgeSpaces,
                            ids: item.items
                        ))
                        
                    }
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.authTransferInventory(
                        docid: self.control.id,
                        items: objs,
                        place: .merm
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        if resp.status != .ok {
                            showError(.campoRequerido, resp.msg)
                            return
                        }
                        
                        guard let _pin = resp.folio else{
                            showError(.campoRequerido, "No se obtuvo PIN de confirmacion")
                            return
                        }
                        
                        self.pin = _pin
                        
                        addToDom( ConfirmView(type: .ok, title: "Documento Aceptado", message: "PIN de confirmacion:\n\(self.pin)", callback: { isConfirmed, comment in
                            
                        }))
                    }
                }
            }))
    }
    
    func cancelDocument() {
        
        addToDom(ConfirmView(
            type: .acceptDeny,
            title: "Confirme Cancelacion",
            message: "Desea cancelar la tranferencia, esta acción no puede ser revertida.",
            requiersComment: true, callback: { isConfirmed, reason in
                
                if reason.isEmpty {
                    showError(.errorGeneral, "Ingrese rason por la cancelación")
                    return
                }
                
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.cancelTransferInventory(
                        docid: self.control.id,
                        reason: reason
                    ) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }
                        
                        if resp.status != .ok {
                            showError(.campoRequerido, resp.msg)
                            return
                        }
                        
                        self.hasIngressed()
                        
                        self.remove()
                        
                    }
                    
                }
            }
        ))
    }
    
}
