//
//  FiscalConceptDestinationView.swift
//
//
//  Created by Victor Cantu on 9/28/22.
//

import Foundation
// import SkylinePublicAPI
import TCFundamentals
import TCFireSignal
import Web

class FiscalConceptDestinationView: Div {
    
    override class var name: String { "div" }
    
    let pocid: UUID
    
    @State var units: Int64
    
    private var callback: ((
        _ selectedPlace: InventoryPlaceType,
        _ storeid: UUID?,
        _ storeName: String,
        _ custAccountId: UUID?,
        _ placeid: UUID?,
        _ placeName: String,
        _ bodid: UUID?,
        _ bodName: String,
        _ secid: UUID?,
        _ secName: String,
        _ units: Int64,
        _ series: [String]
    ) -> ())
    
    init(
        pocid: UUID,
        units: Int64,
        callback: @escaping ((
            _ selectedPlace: InventoryPlaceType,
            _ storeid: UUID?,
            _ storeName: String,
            _ custAccountId: UUID?,
            _ placeid: UUID?,
            _ placeName: String,
            _ bodid: UUID?,
            _ bodName: String,
            _ secid: UUID?,
            _ secName: String,
            _ units: Int64,
            _ series: [String]
        ) -> ())
    ) {
        self.pocid = pocid
        self.units = units
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var unitsToDisperse: String = ""
    
    @State var unitsToDisperseSubTitle: String = ""
    
    @State var selectedPlace: InventoryPlaceType? = nil
    
    /// Incase its going to a store  witch store will it be
    @State var selectedStoreId: UUID? = nil
    
    @State var selectedStoreName: String = ""
    
    var selectedBodId: UUID? = nil
    
    var preSelectedSectId: UUID? = nil
    
    @State var selectedBodIdListener: String = ""
    
    @State var selectedSecIdListener: String = ""
    
    @State var searchFolioString: String = ""
    
    @State var selectedBodegaName = ""
    
    /// Selected place EG: Order ID,  Store ID...
    var placeid: UUID? =  nil
    
    lazy var selecctionBox = Div()
        .margin(all: 3.px)
        .padding(all: 3.px)
    
    lazy var availableStoreBox = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .maxHeight(250.px)
        .overflow(.auto)
    
    lazy var unitsToDisperseField = InputText(self.$unitsToDisperse)
        .class(.textFiledBlackDark)
        .placeholder("0")
        .textAlign(.right)
        .width(50.px)
        .height(28.px)
        .onKeyDown { tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        }
        .onFocus { tf in
            tf.select()
        }
    
    lazy var bodegaSelect = Select(self.$selectedBodIdListener)
        .class(.textFiledBlackDark)
    
    lazy var sectionSelectDiv = Div()
    
    lazy var searchFolioField = InputText(self.$searchFolioString)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Ingrese Folio")
        .width(90.percent)
        .fontSize(23.px)
        .height(27.px)
        .onEnter { tf in
            self.searchFolio()
        }
    
    @DOM override var body: DOM.Content {
        
        /// Main Seccion
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$units.map{ ($0 == 1) ? "Ubicacion de 1 producto" : "Ubicacion de \($0.toString) productos" })
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            Div {
                Span("Colocar")
                    .marginRight(7.px)
                
                self.unitsToDisperseField
                    .marginRight(7.px)
                
                Span(self.$unitsToDisperse.map{
                    
                    guard let int = Int($0) else {
                        return "unidades"
                    }
                    
                    if int == 1 {
                        return "unidad"
                    }
                    else{
                        return "unidades"
                    }
                    
                })
                
            }
            .fontSize(23.px)
            .paddingBottom(3.px)
            
            Div().class(.clear)
            
            self.selecctionBox
            
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != nil })
        
        /// Store
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$unitsToDisperseSubTitle)
                    .color(.lightBlueText)
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                
            }
            .paddingBottom(3.px)
            .align(.left)
            
            Div().class(.clear)
            
            self.availableStoreBox
                .hidden(self.$selectedStoreId.map { $0 != nil })
             
            Div {
                
                Div{
                    
                    H2( self.$selectedStoreName )
                        .color(.white)
                    
                    Div().class(.clear).height(7.px)
                    
                    Div {
                        
                        Label("Bodega")
                            .fontSize(18.px)
                            .color(.gray)
                        
                        Div{
                            self.bodegaSelect
                                .width(90.percent)
                                .fontSize(23.px)
                                .height(28.px)
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear).height(7.px)
                    
                    
                    self.sectionSelectDiv
                    
                    Div().class(.clear).height(7.px)
                    
                    Div {
                        Div("Agregar")
                            .onClick {
                                
                                guard let _store = self.selectedStoreId else{
                                    showAlert(.alerta, "Seleccione Tienda")
                                    return
                                }
                                
                                guard let _bod = UUID(uuidString: self.selectedBodIdListener) else {
                                    showAlert(.alerta, "Seleccione Bodega")
                                    return
                                }
                                
                                guard let _sec = UUID(uuidString: self.selectedSecIdListener) else {
                                    showAlert(.alerta, "Seleccione Bodega")
                                    return
                                }
                                
                                self.callback(
                                    .store, // selectedPlace
                                    _store, // storeid
                                    self.selectedStoreName, // storeName
                                    nil, // custAccountId
                                    nil, // placeid
                                    "", // placeName
                                    _bod, // bodid
                                    (bodegas[_bod]?.name ?? "N/A"), // bodName
                                    _sec, // secid
                                    (seccions[_sec]?.name ?? "N/A"), // secName
                                    self.units, // units
                                    [] // series
                                )
                                
                                self.remove()
                            }
                        .class(.uibtnLargeOrange)
                    }
                    .align(.right)
                }
                
            }
            .hidden(self.$selectedStoreId.map { $0 == nil })
            
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != .store })
        
        /// Order
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$unitsToDisperseSubTitle)
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear).height(12.px)
            
            Div{
                Label("Ingrese Folio")
                    .color(.lightGray)
                    .fontSize(23.px)
                
                Div{
                    self.searchFolioField
                        
                }
            }
            .class(.section)
            
            Div().class(.clear).height(12.px)
            
            Div{
                Div("Buscar Folio")
                    .onClick {
                        self.searchFolio()
                    }
                .class(.uibtnLargeOrange)
            }
            .align(.right)
            
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != .order })
        
        /// Sold
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$unitsToDisperseSubTitle)
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != .sold })
        
        /// Merm
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$unitsToDisperseSubTitle)
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != .merm })
        
        /// Return to vendor
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                 
                H2(self.$unitsToDisperseSubTitle)
                    .maxWidth(90.percent)
                    .class(.oneLineText)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
            }
            .paddingBottom(3.px)
            
            Div().class(.clear)
        }
        .top(25.percent)
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .color(.white)
        .hidden(self.$selectedPlace.map { $0 != .returnToVendor })
         
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        $unitsToDisperse.listen {
            
            guard let int = Int64($0) else{
                self.unitsToDisperseSubTitle = "Ubicacion de \($0) productos"
                return
            }
            
            if int == 1 {
                self.unitsToDisperseSubTitle = "Ubicacion de \($0) productos"
            }
            else{
                self.unitsToDisperseSubTitle = "Ubicacion de \($0) productos"
            }
            
            self.units = int
            
        }
        
        stores.forEach { id, store in
            if id == custCatchStore {
                availableStoreBox.appendChild(
                    Div(store.name)
                        .class(.uibtnLargeOrange)
                        .width(97.percent)
                        .onClick {
                            self.selectStore(storeid: id, storeName: store.name)
                        }
                )
            }
        }
        
        stores.forEach { id, store in
            if id != custCatchStore {
                availableStoreBox.appendChild(
                    Div(store.name)
                        .class(.uibtnLarge)
                        .width(97.percent)
                        .onClick {
                            self.selectStore(storeid: id, storeName: store.name)
                        }
                )
            }
        }
        
        InventoryPlaceType.allCases.forEach { type in
            selecctionBox.appendChild(
                Div(type.description)
                    .class(.uibtnLarge)
                    .width(97.percent)
                    .onClick {
                        self.proccessUnits(type: type)
                    }
            )
        }
        
        unitsToDisperse = units.toString
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        self.unitsToDisperseField.select()
        
    }
    
    func proccessUnits(type: InventoryPlaceType) {
        
        guard let _units = Int64(unitsToDisperse) else{
            showAlert(.alerta, "Ingrese una cantidad valida")
            self.unitsToDisperseField.select()
            return
        }
        
        if _units > units {
            showAlert(.alerta, "Ingrese menos unidades, no tiene \(_units.toString) unidades")
            self.unitsToDisperseField.select()
            return
        }
        
        if _units < units {
            showAlert(.alerta, "Ingrese mas de una unidad")
            self.unitsToDisperseField.select()
            return
        }
        
        guard self.units > 0 else {
            showAlert(.alerta, "Ingrese una cantidad valida")
            self.unitsToDisperseField.select()
            return
        }
        
        switch type {
        case .store:
            
            if stores.count == 1 {
                
                guard let store = stores.first?.value else {
                    return
                }
                
                self.selectStore(storeid: store.id, storeName: store.name)
            }
            
            self.selectedPlace = type
            
        case .order:
            self.selectedPlace = type
            self.searchFolioField.select()
        case .sold:
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme que va marcar como vendido.",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        
                        self.callback(
                            .sold, // selectedPlace
                            custCatchStore, // storeid
                            "", // storeName
                            nil, // custAccountId
                            nil, // placeid
                            "", // placeName
                            nil, // bodid
                            "", // bodName
                            nil, // secid
                            "", // secName
                            self.units, // units
                            [] // series
                        )
                        
                        self.remove()
                    }
                }
            ))
            
        case .merm:
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme que va marcar como mermado.",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        
                        self.callback(
                            .merm, // selectedPlace
                            custCatchStore, // storeid
                            "", // storeName
                            nil, // custAccountId
                            nil, // placeid
                            "", // placeName
                            nil, // bodid
                            "", // bodName
                            nil, // secid
                            "", // secName
                            self.units, // units
                            [] // series
                        )
                        
                        self.remove()
                    }
                }
            ))
            
        case .returnToVendor:
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme que va regrear vendedor.",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        
                        self.callback(
                            .returnToVendor, // selectedPlace
                            custCatchStore, // storeid
                            "", // storeName
                            nil, // custAccountId
                            nil, // placeid
                            "", // placeName
                            nil, // bodid
                            "", // bodName
                            nil, // secid
                            "", // secName
                            self.units, // units
                            [] // series
                        )
                        
                        self.remove()
                    }
                }
            ))
            
        case .missingFromVendor:
            
            addToDom(ConfirmView(
                type: .yesNo,
                title: "Confirme Accion",
                message: "Confirme faltante del vendedor.",
                callback: { isConfirmed, comment in
                    if isConfirmed {
                        
                        self.callback(
                            .missingFromVendor, // selectedPlace
                            custCatchStore, // storeid
                            "", // storeName
                            nil, // custAccountId
                            nil, // placeid
                            "", // placeName
                            nil, // bodid
                            "", // bodName
                            nil, // secid
                            "", // secName
                            self.units, // units
                            [] // series
                        )
                        
                        self.remove()
                    }
                }
            ))
        case .concession:
            
            showAlert(.alerta, "Las consesiones aun no son soportadas")
            return
            
        case .unconcession:
            
            showAlert(.alerta, "Las consesiones aun no son soportadas")
            return
            
        }
        
    }
    
    func selectStore( storeid: UUID, storeName: String) {
        
        /// The store is not same so i will only add to oder since reciving store must decide where it fisicly goes
        if storeid != custCatchStore {
            
            self.callback(
                .store, // selectedPlace
                storeid, // storeid
                storeName, // storeName
                nil, // custAccountId
                nil, // placeid
                "", // placeName
                nil, // bodid
                "Por Eligir", // bodName
                nil, // secid
                "Por Eligir", // secName
                self.units, // units
                [] // series
            )
            
            self.remove()
        }
        /// will load place since  it goes in the order
        else{
            
            loadingView(show: true)
            
            API.custPOCV1.getPOCBodSec(pocid: pocid, storeid: custCatchStore) { resp in
            
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.generalError, "No se obtuvo data de la respuesta")
                    return
                }
                
                self.preSelectedSectId = data.section
                
                var bods: [CustStoreBodegasSinc] = []
                
                bodegas.forEach { bodid, bodData in
                    if bodData.custStore == custCatchStore {
                        bods.append(bodData)
                    }
                }
                
                var _selectedBodegaId: UUID? = nil
                
                if bods.count == 1 {
                    _selectedBodegaId = bods.first?.id
                }
                else if data.bodega != nil {
                    _selectedBodegaId = data.bodega
                }
                
                bods.forEach { bod in
                    
                    let opt = Option(bod.name)
                        .value(bod.id.uuidString)
                    
                    if let _sel = _selectedBodegaId {
                        if _sel ==  bod.id {
                            
                            self.selectedBodIdListener = _sel.uuidString
                            
                            opt.selected(true)
                            
                        }
                    }
                    
                    self.bodegaSelect.appendChild(opt)
                    
                }
                
                self.selectedStoreId = custCatchStore
                
                self.selectedStoreName = storeName
                
                if let bod = bods.first {
                    
                    let sectionSelectField = SectionSelectField(
                        storeid: custCatchStore,
                        storeName: stores[custCatchStore]?.name ?? "",
                        bodid: bod.id,
                        bodName: bod.name,
                        callback: { section in
                            
                            guard let storeid = self.selectedStoreId else {
                                showError(.unexpectedResult, "No se encontro id de tienda, refresque e intente de nuevo.")
                                return
                            }
                            
                            guard let bodid = UUID(uuidString: self.selectedBodIdListener) else {
                                showError(.unexpectedResult, "No se encontro id de la bodega, refresque e intente de nuevo.")
                                return
                            }
                            
                            guard let bodega = bodegas[bodid] else {
                                showError(.unexpectedResult, "No se encontro id de la bodega, refresque e intente de nuevo.")
                                return
                            }
                            
                            self.callback(
                                .store, // selectedPlace
                                storeid, // storeid
                                self.selectedStoreName, // storeName
                                nil, // custAccountId
                                nil, // placeid
                                "", // placeName
                                bodid, // bodid
                                bodega.name, // bodName
                                section.id, // secid
                                section.name, // secName
                                self.units, // units
                                [] // series
                            )
                            
                            self.remove()
                        
                    })
                    
                    self.sectionSelectDiv.appendChild(Div{
                        Label("Seccion")
                            .paddingTop(11.px)
                            .width(30.percent)
                            .marginLeft(5.px)
                            .marginTop(2.px)
                            .float(.left)
                            .color(.gray)
                        
                        Div{
                            sectionSelectField
                        }
                        .marginLeft(35.percent)
                        .paddingTop(5.px)
                    })
                }
            }
        }
    }
    
    func searchFolio() {
        
        var term = searchFolioString
            .purgeSpaces
            .pseudo
        
        if searchFolioString.isEmpty {
            showAlert( .alerta, "Ingrese Folio")
            return
        }
        
        if !term.contains("-") {
            term = "-\(term)"
        }
        
        loadingView(show: true)
        
        API.custOrderV1.searchFolio(
            term: term,
            accountid: nil,
            tag1: nil,
            tag2: nil,
            tag3: nil,
            tag4: nil,
            description: nil,
            startAt: nil,
            endAt: nil
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError( .generalError, .unexpenctedMissingPayload)
                return
            }
            
            guard let order = data.orders.first else {
                showError( .generalError, "No se localizo folio, revice de nuevo.")
                return
            }
            
            self.callback(
                .order, // selectedPlace
                custCatchStore, // storeid
                "Pendiente elegir tienda", // storeName
                order.custAcct, // custAccountId
                order.id, // placeid
                order.folio, // placeName
                nil, // bodid
                "", // bodName
                nil, // secid
                "", // secName
                self.units, // units
                [] // series
            )
            
            self.remove()
            
        }
    }
}
