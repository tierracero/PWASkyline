//
//  OrderRouteView+SelectOrderView.swift
//
//
//  Created by Victor Cantu on 11/3/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderRouteView{

    class SelectOrderView: Div {
        
        override class var name: String { "div" }
        
        @State var selectedOrderFolio: String?
        
        var currentOrderIds: [UUID]
        
        private var callback: ((
            _ item: API.custRouteV1.OrderRouteItem
        ) -> ())
        
        init(
            selectedOrderFolio: String?,
            currentOrderIds: [UUID],
            callback: @escaping ((
                _ item: API.custRouteV1.OrderRouteItem
            ) -> ())
        ) {
            self.selectedOrderFolio = selectedOrderFolio
            self.currentOrderIds = currentOrderIds
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var searchOrderString = ""
        
        @State var searchOrderHasNoResults = false
        
        @State var searchOrderError: String? = nil
        
        lazy var searchOrderField = InputText(self.$searchOrderString)
            .custom("width","calc(100% - 24px)")
            .placeholder("Folio de Orden")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onEnter {
                self.searchOrder()
            }
        
        @State var multipleOrderIsHidden = true
        
        @State var selectedOrderIsHidden = true
        
        @State var multipleAddressResultIsHidden = true
        
        var order: CustOrder? = nil
        
        @State var orders: [CustOrder] = []
        
        @State var linkedLocations: [AppleMap] = []
        
        @State var currentLocation: AppleMap.Coordinate? = nil
        
        @State var street: String = ""

        @State var colony: String = ""

        @State var city: String = ""

        @State var state: String = ""

        @State var country: String = ""

        @State var zip: String = ""

        var latitude: String = ""

        var longitude: String = ""
        
        @State var loadByZipCode: Bool = false
        
        @State var mapIsLoaded: Bool = false
        
        lazy var streetField = InputText(self.$street)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Calle y número")
            .class(.textFiledLightLarge)
            .placeholder(.streetNumber)
            .autocomplete(.off)
            .onEnter {
                self.loadMap()
            }
        
        lazy var colonySelect = Select(self.$colony)
            .custom("width", "calc(100% - 18px)")
            .class(.textFiledLightLarge)
            .height(37.px)
            .body {
                Option("Seleccione Colonia")
                    .value("")
            }
        
        lazy var colonyField = InputText(self.$colony)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Colonia")
            .class(.textFiledLightLarge)
            
        lazy var cityField = InputText(self.$city)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Ciudad")
            .class(.textFiledLightLarge)
            
        lazy var stateField = InputText(self.$state)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Estado")
            .class(.textFiledLightLarge)
        
        lazy var countryField = InputText(self.$country)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Pais")
            .class(.textFiledLightLarge)
            .placeholder(.streetNumber)
            .autocomplete(.off)
        
        lazy var zipField = InputText(self.$zip)
            .custom("width", "calc(100% - 18px)")
            .placeholder("Codigo Postal")
            .class(.textFiledLightLarge)
            .placeholder(.streetNumber)
            .autocomplete(.off)
            .disabled(true)
        
        let mapId = callKey(32)
        
        lazy var mapContainer = Div{
            Table().noResult(label: "📍 Carge dirección para visualizar.")
        }
        .id(.init(stringLiteral: self.mapId))
        .custom("height","calc(100% - 90px)")
        .width(60.percent)
        .float(.left)
        
        lazy var latInput = InputText()
            .id(.init(stringLiteral: "latInput\(self.mapId)"))
            .hidden(true)
        
        lazy var lonInput = InputText()
            .id(.init(stringLiteral: "lonInput\(self.mapId)"))
            .hidden(true)
        
        @DOM override var body: DOM.Content {
            
            self.latInput
            
            self.lonInput
            
            Div{
                
                // MARK: Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Buscar Orden")
                        .color(.lightBlueText)
                }
                
                Div().class(.clear).marginTop(7.px)
                
                // MARK: Body
                self.searchOrderField
                
                Div().class(.clear).marginTop(7.px)
                    .hidden(self.$searchOrderError.map{ $0 == nil })
                
                Div(self.$searchOrderError.map{ $0 ?? "N/A" })
                    .hidden(self.$searchOrderError.map{ $0 == nil })
                    .color(.white)
                
                Div().class(.clear).marginTop(7.px)
                
                Div{
                    Div("Buscar Orden")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.searchOrder()
                        }
                }
                .align(.right)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 274px)")
            .custom("top", "calc(50% - 174px)")
            .borderRadius(all: 24.px)
            .padding(all: 12.px)
            .position(.absolute)
            .width(500.px)
            
            Div{
                
                Div{
                    
                    Div{
                        
                        Img()
                            .closeButton(.view)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("Seleccionar Orden")
                            .color(.lightBlueText)
                    }
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    ForEach(self.$orders){ order in
                        Div {
                            Div("\(order.folio) \(order.name)")
                        }
                        .class(.uibtnLarge)
                        .onClick {
                            
                            self.order = order
                            
                            self.loadOrderDetail(order: order)
                            
                        }
                    }
                    .maxHeight(300.px)
                    .overflow(.auto)
                    
                }
                .backgroundColor(.backGroundGraySlate)
                .borderRadius(all: 24.px)
                .padding(all: 12.px)
                .position(.absolute)
                .width(50.percent)
                .left(25.percent)
                .top(24.percent)
                
            }
            .hidden(self.$multipleOrderIsHidden)
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
            
            Div{
                
                Div{
                    
                    Div{
                        
                        Img()
                            .closeButton(.view)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("Confirmar direccion")
                            .color(.lightBlueText)
                    }
                    
                    Div().class(.clear).height(7.px)
                
                    Div{
                        
                        Label("Calle y numero")
                            .color(.gray)
                        Div().class(.clear).height(3.px)
                        self.streetField
                        
                        Div().class(.clear).height(7.px)
                        
                        Label("Colonia")
                            .color(.gray)
                        Div().class(.clear).height(3.px)
                        
                        self.colonyField
                            .hidden(self.$loadByZipCode)
                        
                        self.colonySelect
                            .hidden(self.$loadByZipCode.map{ !$0 })
                            
                        Div().class(.clear).height(7.px)
                        
                        Label("Ciudad")
                            .color(.gray)
                        Div().class(.clear).height(3.px)
                        self.cityField
                        Div().class(.clear).height(7.px)
                        
                        Label("Estado")
                            .color(.gray)
                        Div().class(.clear).height(3.px)
                        self.stateField
                        Div().class(.clear).height(7.px)
                        
                        Div{
                            Label("Codigo Postal")
                                .color(.gray)
                            Div().class(.clear).height(3.px)
                            self.zipField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Label("Pais")
                                .color(.gray)
                            Div().class(.clear).height(3.px)
                            self.countryField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).height(7.px)
                        
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    self.mapContainer
                    
                    Div().class(.clear).height(7.px)
                    
                    Div{
                        Div("Agregar Orden")
                            .hidden(self.$mapIsLoaded)
                            .class(.uibtnLargeOrange)
                            .cursor(.default)
                            .float(.right)
                            .opacity(0.3)
                        
                        Div("Agregar Orden")
                            .hidden(self.$mapIsLoaded.map{ !$0 })
                            .class(.uibtnLargeOrange)
                            .float(.right)
                            .onClick {
                                if !self.mapIsLoaded {
                                    return
                                }
                                self.addLocation()
                            }
                        
                        Div("Cargar Mapa")
                            .marginRight(12.px)
                            .class(.uibtnLarge)
                            .float(.right)
                            .onClick {
                                self.loadMap()
                            }
                            
                        Div().class(.clear)
                        
                    }
                     
                }
                .backgroundColor(.backGroundGraySlate)
                .custom("left", "calc(50% - 424px)")
                .borderRadius(all: 24.px)
                .padding(all: 12.px)
                .position(.absolute)
                .top(15.percent)
                .height(466.px)
                .width(800.px)
                
            }
            .hidden(self.$selectedOrderIsHidden)
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
            
            Div{
                Div{
                    Div{
                        
                        Img()
                            .closeButton(.view)
                            .onClick{
                                self.linkedLocations.removeAll()
                                self.multipleAddressResultIsHidden = true
                            }
                        
                        H2("Seleccionar Direccion")
                            .color(.lightBlueText)
                    }
                    
                    Div().class(.clear).marginTop(7.px)
                
                    ForEach(self.$linkedLocations){ loc in
                        
                        Div{
                            Span(loc.formattedAddress ?? "\(loc.name) \(loc.locality) \(loc.postCode)")
                        }
                            .custom("width","calc(100% - 24px)")
                            .class(.uibtnLarge, .twoLineText)
                            .onClick {
                                self.addLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                            }
                        
                    }
                    .width(100.percent)
                    .maxHeight(300.px)
                    .overflow(.auto)
                    
                }
                .backgroundColor(.backGroundGraySlate)
                .borderRadius(all: 24.px)
                .padding(all: 12.px)
                .position(.absolute)
                .width(50.percent)
                .left(25.percent)
                .top(24.percent)
                
            }
            .hidden(self.$multipleAddressResultIsHidden)
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            if let selectedOrderFolio {
                
                searchOrderString = selectedOrderFolio
                
                searchOrder()
                
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            searchOrderField.select()
            
        }
        
        func searchOrder(){
            
            if searchOrderString.isEmpty {
                searchOrderField
                return
            }
            
            searchOrderError = nil
            
            loadingView(show: true)
            
            API.custOrderV1.search(
                term: searchOrderString,
                onlyActive: true
            ) { resp in
                
                Console.clear()
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
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
                
                if payload.orders.isEmpty {
                    self.searchOrderError = "⚠️ No hay resultados"
                }
                
                var orders: [CustOrder] = []
                
                payload.orders.forEach { order in
                    if self.currentOrderIds.contains(order.id) {
                        return
                    }
                    
                    orders.append(order)
                    
                }
                
                if orders.isEmpty {
                    
                    if payload.orders.count == 1 {
                        
                        guard let order = payload.orders.first else {
                            self.searchOrderError = "⚠️ No hay resultados compatibles. o ya esta agregado a la ruta"
                            return
                        }
                        
                        if self.currentOrderIds.contains(order.id) {
                            self.searchOrderError = "⚠️ Esta orden ya esta en la ruta."
                        }
                        else {
                            self.searchOrderError = "⚠️ No hay resultados compatibles"
                        }
                        
                    }
                    else {
                        self.searchOrderError = "⚠️ No hay resultados compatibles."
                    }
                    
                    
                }
                
                print("🟢 payload.orders \(orders.count)")
                
                if orders.count == 1 {
                    print("💎  found one order")
                    guard let order = orders.first else {
                        print("🔴  found one order")
                        return
                    }
                    
                    self.order = order
                    
                    self.loadOrderDetail(order: order)
                    return
                }
                
                self.orders = orders
                
            }
        }
        
        func loadOrderDetail(order: CustOrder) {
            
            if !order.lat.isEmpty && !order.lon.isEmpty {
                
                print("found lat and lon")
                
                guard let latitude = Double(order.lat) else {
                    return
                }
                
                guard let longitude = Double(order.lon) else {
                    return
                }
                
                callback(.init(
                    orderId: order.id,
                    folio: order.folio,
                    name: order.name,
                    street: order.street,
                    colony: order.colony,
                    city: order.city,
                    state: order.state,
                    country: order.country,
                    zip: order.zip,
                    latitude: latitude,
                    longitude: longitude
                ))
                
                self.remove()
                
                return
            }
            
            if !order.zip.isEmpty {
                searchPostalCode(order: order)
                return
            }
            
            let view = ManualAddressSearch(.byAddress(.init(
                orderId: order.id,
                colony: order.colony,
                city: order.city,
                state: order.state,
                country: order.country.isEmpty ? "mexico" : order.country
            ))) { settlement, city, state, zip, country in
                
                self.street = order.street
                
                self.colony = settlement

                self.city = city

                self.state = state

                self.country = country.description

                self.zip = zip
                
                self.searchOrderString = ""
                
                self.selectedOrderIsHidden = false
                
            }
            
            addToDom(view)
            
        }
        
        func searchPostalCode(order: CustOrder){
            
            let code = order.zip.purgeSpaces
            
            if code.count < 4 {
                showError(.campoInvalido, "Ingrese un codigo postal minimo de cuatro digitos")
                return
            }
            
            guard let country = Countries(rawValue: (country.isEmpty ? "mexico" :  country) ), country == .mexico else {
                showError(.campoInvalido, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
                return
            }
            
            API.v1.searchZipCode(
                code: code,
                country: country
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
                
                guard let codes = resp.data else {
                    showError(.errorGeneral, "unexpected missing payload")
                    return
                }

                if codes.isEmpty {
                    showError(.errorGeneral, "No se localizo información, intente unn codigo nuevo o un ingreso manual.")
                }
                
                guard let state = codes.first?.state else {
                    showError(.errorGeneral, "Se le localizo el estado en la peticion")
                    return
                }
                
                self.colonySelect.innerHTML = ""
                
                self.colonySelect.appendChild(Option("Seleccione Colonia").value(""))
                
                var items: [String] = []
                
                var itemsRrefrence: [ String : PostalCodesMexicoItem ] = [:]
                
                codes.forEach { code in
                    
                    if items.contains(code.settlement) {
                        return
                    }
                    
                    items.append(code.settlement)
                    
                    itemsRrefrence[code.settlement] = code
                    
                }
                
                items.sort()
                
                items.forEach { item in
                    
                    guard let code = itemsRrefrence[item] else {
                        return
                    }
                    
                    self.colonySelect.appendChild(
                        Option(code.settlement)
                            .value("\(code.settlementType) \(code.settlement)")
                    )
                }
                
                self.colony = ""
                
                let currentSettlement = order.colony.purgeSpaces
                
                if !currentSettlement.isEmpty {
                    
                    print("currentSettlement \(currentSettlement)")
                    
                    var purgedParts: [String] = []
                    
                    let ignoreList = ["de","la","los","las", "del", "el"]
                    
                    // los olivos de mamá
                    let parts = currentSettlement.pseudo.purgeSpaces.explode(" ")
                    
                    // olivos mama
                    parts.forEach { part in
                        if ignoreList.contains(part) {
                            return
                        }
                        purgedParts.append(part)
                    }
                    
                    print("purgedParts")
                    
                    print(purgedParts)
                    
                    /// Parse Items, each item is a settelment
                    items.forEach { item in
                        
                        let purgedItem = item.pseudo.purgeSpaces
                        
                        /// Purged parts of the current settment that i have EG: ["olivos", ["mama"]]
                        purgedParts.forEach { purgedPart in
                            
                            if purgedItem.contains(purgedPart) {
                                guard let code = itemsRrefrence[item] else {
                                    return
                                }
                                self.colony = "\(code.settlementType) \(code.settlement)"
                            }
                            
                        }
                        
                    }
                }
                
                self.street = order.street
                
                self.state = state.description
                
                self.city = codes.first?.city ?? ""
                
                self.zip = code
                
                self.selectedOrderIsHidden = false
                
                self.loadByZipCode = true
                
                self.streetField.select()
                
                self.country = country.description
                
            }
        }
        
        func loadMap(){
            
            print("🟡 init map")
            
            if street.isEmpty {
                showError(.campoRequerido, "Ingese Calle y Numero")
                streetField.select()
                return
            }
            
            if colony.isEmpty {
                showError(.campoRequerido, "Ingrese Colonia")
                colonyField.select()
                return
            }

            if city.isEmpty {
                showError(.campoRequerido, "Ingrese Cuidad")
                cityField.select()
                return
            }

            if state.isEmpty {
                showError(.campoRequerido, "Ingrese Estado")
                stateField.select()
                return
            }

            if zip.isEmpty {
                showError(.campoRequerido, "Ingrese Codigo Postal")
                zipField.select()
                return
            }

            if country.isEmpty {
                countryField.select()
                showError(.campoRequerido, "Ingrese Pais")
                return
            }
            
            loadingView(show: true)
            
            API.v1.jwt { token in
                
                guard let token else {
                    loadingView(show: false)
                    showError(.errorDeCommunicacion, "No se pudo cargar token")
                    return
                }
            
                self.mapContainer.innerHTML = ""
                
                // "Arroyo Carrizal, Luis Echeverria, 87060 Victoria, Tamps., México
                let _ = JSObject.global.initiateSingleMap!(self.mapId, token, "\(self.street), \(self.colony), \(self.zip) \(self.city), \(self.state), \(self.country)", JSOneshotClosure { args in
                    
                    loadingView(show: false)
                    
                    if let payload = args.first?.string {
                        self.processMapResponse(payload)
                    }
                    
                    
                    return .undefined
                }.jsValue, JSClosure { args in
                    
                    print("🟢  0001 ")
                    
                    print(args)
                    
                    if let payload = args.first?.string {
                        print("🟢  0002 ")
                        self.processMapUpdate(payload)
                    }
                    
                    print("🟢  0003 ")
                    
                    return .undefined
                }.jsValue)
            }
        }
        
        func processMapResponse(_ json: String ){
           
            guard let data = json.data(using: .utf8) else {
                showError(.unexpectedResult, "No se pudo crear data de hilo")
                return
            }
            
            do {
                
                let payload = try JSONDecoder().decode([AppleMap].self, from: data)
                
                if payload.isEmpty {
                    showError(.errorGeneral, "no hay resultado")
                    return
                }
                
                if payload.count > 1 {
                
                    self.linkedLocations = payload
                    
                    self.multipleAddressResultIsHidden = false
                    
                    return
                }
                
                mapIsLoaded = true
                
            } catch {
                showError(.unexpectedResult, "No se pudo decodificar data inicial de mapa")
                return
            }
            
            
        }
        
        func processMapUpdate(_ json: String){
            
             guard let data = json.data(using: .utf8) else {
                 showError(.unexpectedResult, "No se pudo crear data de hilo")
                 return
             }
             
            do {
                currentLocation = try JSONDecoder().decode(AppleMap.Coordinate.self, from: data)
            }
            catch {
                showError(.unexpectedResult, "No se pudo decodificar data de cordenadas de mapa.")
                return
            }
        }
        
        func addLocation(latitude: Double? = nil, longitude: Double? = nil){
        
            var latitude = latitude
            
            var longitude = longitude
            
            if latitude == nil || longitude == nil {
                
                if let currentLocation {
                    latitude = currentLocation.latitude
                    longitude = currentLocation.longitude
                }
                
            }
            
            guard let latitude else {
                print("🔴 FAIL TO GET  LAT")
                return
            }
            
            guard let longitude else {
                print("🔴 FAIL TO GET  LON")
                return
            }
            
            guard let order else {
                print("🔴 FAIL TO GET  ORDER")
                return
            }
            
            
            print("🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  ")
            
            print("latitude \(latitude)")
            
            print("longitude \(longitude)")
            
            callback(.init(
                orderId: order.id,
                folio: order.folio,
                name: order.name,
                street: street,
                colony: colony,
                city: city,
                state: state,
                country: country,
                zip: zip,
                latitude: latitude,
                longitude: longitude
            ))
            
            self.remove()
            
            
        }
        
    }
}
