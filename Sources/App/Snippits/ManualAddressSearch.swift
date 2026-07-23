//
//  ManualAddressSearch.swift
//
//
//  Created by Victor Cantu on 10/25/24.
//

import Foundation
import TCFundamentals
import Web

class ManualAddressSearch: Div {
    
    /// byCountry(Countries), byAddress(AddressItem)
    let loadBy: LoadType
    
    private var callback: ((
        _ result: ResultType
    ) -> ())
    
    init(
        _ loadBy: LoadType,
        callback: @escaping ((
            _ result: ResultType
        ) -> ())
    ) {
        self.loadBy = loadBy
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    @State var latitude = ""

    @State var longitude = ""

    @State var addManualCoordanetsIsHidden = true

    @State var addManualMultipleCoordanetsIsHidden = true
    
    @State var street = ""

    @State var settlement = ""

    @State var state = ""
    
    @State var city = ""

    @State var zip = ""
    
    @State var cities: [String] = []
    
    @State var settlementRefrence: [ String : PostalCodesMexicoItem ] = [:]
    
    @State var settlementCrossRefrence: [ String : PostalCodesMexicoItem ] = [:]
    
    var country: Countries = .mexico
    
    lazy var latitudeField = InputText(self.$latitude)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder("23.00001234")
        .autocomplete(.off)
        .color(.gray)

    lazy var longitudeField = InputText(self.$longitude)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .placeholder("-99.000001234")
        .autocomplete(.off)
        .color(.gray)

    lazy var countryField = InputText(self.country.description)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder(.city)
        .color(.gray)
    
    lazy var statesResultSelect = Select(self.$state)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Estado")
                .value("")
        }
    
    lazy var cityResultSelect = Select(self.$city)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Cuidad")
                .value("")
        }
    
    lazy var settlementResultSelect = Select(self.$settlement)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Colonia")
                .value("")
        }
    
    lazy var multipleResultsContainer = Div()

    @DOM override var body: DOM.Content {

        Div{
            // MARK:  header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }

                Div{
                    Span("+ Coordenadas")
                    .margin(all: 3.px)
                }
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.addCoordanets()
                }
                
                H2("Buscar Dirección").color(.lightBlueText)
                
                Div().class(.clear).marginTop(12.px)
                
            }
            
            // MARK: body
            
            H2("Pais")
            Div().clear(.both).height(3.px)
            self.countryField
            Div().clear(.both).height(7.px)
            
            H2("Estado")
            Div().clear(.both).height(3.px)
            self.statesResultSelect
            Div().clear(.both).height(7.px)
            
            Div{
                
                H2("Cuidad")
                Div().clear(.both).height(3.px)
                self.cityResultSelect
                Div().clear(.both).height(7.px)
                
                Div{
                    
                    H2("Asentamiento")
                    Div().clear(.both).height(3.px)
                    self.settlementResultSelect
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        Div("Seleccionar")
                            .custom("width", "calc(100% - 14px)")
                            .class(.uibtnLargeOrange)
                            .align(.center)
                            .onClick {
                                
                                guard let zipCodeData = self.settlementCrossRefrence[self.settlement] else {
                                    print("🔴 zipCodeData")
                                    return
                                }
                                
                                guard let state = CountryStatesMexico(rawValue: self.state) else {
                                    print("🔴 city")
                                    return
                                }
                                
                                self.callback(.address(.init(
                                    settlement: self.settlement,
                                    city: (zipCodeData.city ?? zipCodeData.county),
                                    state: state.description,
                                    zip: zipCodeData.code,
                                    country: self.country
                                )))
                                
                                self.remove()
                                
                            }
                    }
                    .hidden(self.$settlement.map{ $0.isEmpty })

                }
                
            }
            .hidden(self.$cities.map{ $0.isEmpty })
            
        }
        .custom("left", "calc(50% - 262px)")
        .custom("top", "calc(50% - 212px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .padding(all: 12.px)
        .position(.absolute)
        .width(500.px)

        Div {

            Div {
                
                // MARK: header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.addManualCoordanetsIsHidden = true
                        }

                    H1("Ingresar Coordenadas").color(.lightBlueText)
                    
                    Div().class(.clear).marginTop(12.px)

                }

                H2("Latitud")
                Div().clear(.both).height(3.px)
                self.latitudeField
                Div().clear(.both).height(7.px)

                H2("Longitud")
                Div().clear(.both).height(3.px)
                self.longitudeField
                Div().clear(.both).height(7.px)

                Div {
                    Div("Ingresar Coordenadas")
                        .custom("width", "calc(100% - 14px)")
                        .class(.uibtnLargeOrange)
                        .align(.center)
                        .onClick {

                            guard let latitude = Double(self.latitude.purgeSpaces) else {
                                showError(.generalError, "Latitud invalida")
                                return
                            }

                            guard let longitude = Double(self.longitude.purgeSpaces) else {
                                showError(.generalError, "Longitud invalida")
                                return
                            }

                            self.loadCoordanets(latitude: latitude, longitude: longitude)
                            
                        }
                }
                    
            }
            .custom("left", "calc(50% - 212px)")
            .custom("top", "calc(50% - 252px)")
            .borderRadius(all: 24.px)
            .backgroundColor(.white)
            .padding(all: 12.px)
            .position(.absolute)
            .width(400.px)

        }
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        .hidden(self.$addManualCoordanetsIsHidden)

        Div {
            Div {

                // MARK: header
                Div {
                    
                    Img()
                        .closeButton(.view)
                        .onClick {
                            self.addManualMultipleCoordanetsIsHidden = true
                        }

                    H1("Ingresar Coordenadas").color(.lightBlueText)
                    
                    Div().class(.clear).marginTop(12.px)

                }

                Div {
                    self.multipleResultsContainer
                }
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .height(250.px)

            }
        }
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        .hidden(self.$addManualMultipleCoordanetsIsHidden)

    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        CountryStatesMexico.allCases.forEach { state in
            statesResultSelect.appendChild(
                Option(state.description)
                    .value(state.rawValue)
            )
        }
        
        $state.listen {
            self.getCities()
        }
        
        $city.listen {
            self.getSettlements()
        }
        
        switch loadBy {
        case .byCountry(let country):
            
            guard country == .mexico else {
                showError(.invalidField, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
                self.remove()
                return
            }
            
            state = CountryStatesMexico.tamaulipas.rawValue
            
        case .byAddress(let address):
            loadByAddress(address)
        }
        
    }
    
    func loadByAddress(_ address: AddressItem){
        
        var stateString = address.state.purgeSpaces.pseudo
        
        if stateString.isEmpty {
            stateString = CountryStatesMexico.tamaulipas.rawValue
        }
        
        guard let thisState = CountryStatesMexico(rawValue: stateString) else {
            return
        }
        
        state = thisState.rawValue
        
    }
    
    func getCities(){
        
        city = ""
        
        settlement = ""
        
        cities.removeAll()
        
        cityResultSelect.innerHTML = ""
        
        guard let state = CountryStatesMexico(rawValue: state) else {
            print("🔴 failed to initate CountryStatesMexico from string \(state)")
            return
        }
        
        loadingView(show: true)
        
        API.v1.getGEOCities(
            state: state
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.generalError, "Unexpected missing payload.")
                return
            }

            self.cityResultSelect.appendChild(Option("Seleccione Cuidad").value(""))
            
            data.forEach { item in
                
                let name = item.city ?? item.county
                
                if self.cities.contains(name) {
                    return
                }
                
                self.cities.append(name)
                
            }
            
            
            self.cities.sort()
            
            self.cities.forEach { name in
                self.cityResultSelect.appendChild(
                    Option(name).value(name)
                )
            }
            
            switch self.loadBy {
            case .byCountry:
                if state == .tamaulipas {
                    print("🟢 TAMAULIPAS")
                    self.city = "Ciudad Victoria"
                }
            case .byAddress(let addressItem):
             
                //data
                let currentCity = addressItem.city
                
                // MARK PURGE
                print("currentCity \(currentCity)")
                
                var purgedParts: [String] = []
                
                let ignoreList = ["de","la","los","las", "del", "el"]
                
                // los olivos de mamá
                let parts = currentCity.pseudo.purgeSpaces.explode(" ")
                
                // olivos mama
                parts.forEach { part in
                    if ignoreList.contains(part) {
                        return
                    }
                    purgedParts.append(part)
                }
                
                print("purgedParts")
                
                print(purgedParts)
                
                print("start parsing data")
                
                /// [PostalCodesMexico]
                let codes = data
                
                /// list of citie names
                var items: [String] = []
                
                var itemsRrefrence: [String:PostalCodesMexicoItem] = [:]
                
                codes.forEach { code in
                    
                    let city = code.city ?? code.county
                    
                    if items.contains(city) {
                        return
                    }
                    
                    items.append(city)
                    
                    itemsRrefrence[city] = code
                }
                
                items.sort()
                
                var hasSelectedCity = false
                
                /// Parse Items, each item is a settlement
                items.forEach { item in
                    
                    let purgedItem = item.pseudo.purgeSpaces
                    
                    /// Purged parts of the current settment that i have EG: ["olivos", ["mama"]]
                    purgedParts.forEach { purgedPart in
                        
                        if purgedItem.contains(purgedPart) {
                            guard let code = itemsRrefrence[item] else {
                                return
                            }
                            if hasSelectedCity {
                               return
                            }
                            self.city = item
                            hasSelectedCity = true
                        }
                    }
                }
            }
        }
    }
    
    func getSettlements(){
        
        settlement = ""
        
        settlementResultSelect.innerHTML = ""
        
        settlementRefrence.removeAll()
        
        settlementCrossRefrence.removeAll()
        
        settlementResultSelect.appendChild(
            Option("Seleccionar Asentamineto")
                .value("")
        )
        
        guard let state = CountryStatesMexico(rawValue: state) else {
            print("🔴 failed to initate CountryStatesMexico from string \(state)")
            return
        }
        
        if city.isEmpty {
            return
        }
        
        loadingView(show: true)
        
        API.v1.getGEOColonies(
            state: state,
            city: city
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            var settlements: [String] = []
            
            data.forEach { item in
                
                self.settlementRefrence["\(item.settlement) | \(item.settlementType.description)"] = item
                
                self.settlementCrossRefrence["\(item.settlementType.description) \(item.settlement)"] = item
                
                if settlements.contains("\(item.settlement) | \(item.settlementType.description)") {
                    return
                }
                
                settlements.append("\(item.settlement) | \(item.settlementType.description)")
            }
            
            settlements.sort()
            
            settlements.forEach { settlementName in
                
                guard let code = self.settlementRefrence[settlementName] else {
                    return
                }
                
                self.settlementResultSelect.appendChild(
                    Option("\(code.settlement) | \(code.settlementType.description)")
                        .value("\(code.settlementType.description) \(code.settlement)")
                )
            }
            
            switch self.loadBy {
            case .byCountry:
                break
            case .byAddress(let addressItem):
                
                let currentSettlement = addressItem.colony
                
                let codes = data
                
                var items: [String] = []
                
                var itemsRrefrence: [String:PostalCodesMexicoItem] = [:]
                
                var itemsIdRefrence: [UUID:PostalCodesMexicoItem] = [:]
                
                ///[ PostalCodesMexico.id : Int]
                var acuracyRefrence: [UUID:Int] = [:]
                
                codes.forEach { code in
                    
                    let settlement = "\(code.settlementType.description) \(code.settlement)"
                    
                    if items.contains(settlement) {
                        return
                    }
                    
                    items.append(settlement)
                    
                    itemsRrefrence[settlement] = code
                    
                    itemsIdRefrence[code.id] = code
                }
                
                items.sort()
                
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
                
                // Parse Items, each item is a settlement
                items.forEach { item in
                    
                    let purgedItem = item.pseudo.purgeSpaces
                    
                    // Purged parts of the current settment that i have EG: ["olivos", ["mama"]]
                    purgedParts.forEach { purgedPart in
                        
                        let purgedItemParts = purgedItem.explode(" ")
                        
                        purgedItemParts.forEach { purgedItem in
                            
                            if purgedItem == purgedPart {
                                print("🟢 purgedPart [EQUALS]: \(purgedPart)")
                                guard let code = itemsRrefrence[item] else {
                                    return
                                }
                                
                                if let cc = acuracyRefrence[code.id] {
                                    acuracyRefrence[code.id] = (cc + 4)
                                }
                                else {
                                    acuracyRefrence[code.id] = 4
                                }
                            }
                            else if (purgedItem.hasPrefix(purgedPart.prefix(2)) && purgedItem.hasSuffix(purgedPart.suffix(2))) {
                                print("🟢 purgedPart [PRE-SUFF]: \(purgedPart)")
                                guard let code = itemsRrefrence[item] else {
                                    return
                                }
                                
                                if let cc = acuracyRefrence[code.id] {
                                    acuracyRefrence[code.id] = (cc + 3)
                                }
                                else {
                                    acuracyRefrence[code.id] = 3
                                }
                            }
                            else if (purgedItem.hasPrefix(purgedPart.prefix(2)) && purgedItem.hasSuffix(purgedPart.suffix(1))) {
                                print("🟢 purgedPart [PRE-SUFF]: \(purgedPart)")
                                guard let code = itemsRrefrence[item] else {
                                    return
                                }
                                
                                if let cc = acuracyRefrence[code.id] {
                                    acuracyRefrence[code.id] = (cc + 2)
                                }
                                else {
                                    acuracyRefrence[code.id] = 2
                                }
                            }
                            else if purgedItem.contains(purgedPart) {
                                print("🟢 purgedPart [CONTAINS]: \(purgedPart)")
                                guard let code = itemsRrefrence[item] else {
                                    return
                                }
                                
                                if let cc = acuracyRefrence[code.id] {
                                    acuracyRefrence[code.id] = (cc + 1)
                                }
                                else {
                                    acuracyRefrence[code.id] = 1
                                }
                                
                            }
                        }
                    }
                }
            
                Console.clear()
                
                var acuracyReverseRefrence: [Int: UUID] = [:]
                
                var acuracyReverseKeys: [Int] = []
                
                acuracyRefrence.forEach { id, cc in
                    acuracyReverseKeys.append(cc)
                    acuracyReverseRefrence[cc] = id
                }
                
                acuracyReverseKeys.sort()
                
                guard let firstCount = acuracyReverseKeys.last else {
                    return
                }
                
                acuracyReverseRefrence.forEach { cc, item in
                    print(cc)
                }
                
                guard let id = acuracyReverseRefrence[firstCount] else {
                    return
                }
                
                guard let item = itemsIdRefrence[id] else {
                    return
                }
                
                self.settlement = "\(item.settlementType.description) \(item.settlement)"
                
            }
        }
    }

    func addCoordanets() {
        addManualCoordanetsIsHidden = false
    }

    func loadCoordanets(latitude: Double, longitude: Double) {
        
        print("🟡 reverse geocode coordinates")
        
        loadingView(show: true)
        
        API.v1.jwt { token in
            
            loadingView(show: false)

            guard let token else {
                showError(.comunicationError, "No se pudo cargar token")
                return
            }
            
            let _ = JSObject.global.initiateMapReverseGeocode!(token, latitude, longitude, JSOneshotClosure { args in
                
                if let payload = args.first?.string {
                    self.processReverseGeocodeMapResponse(payload, latitude, longitude)
                }
                
                return .undefined
            }.jsValue)
        }
    }
    
    func processReverseGeocodeMapResponse(_ json: String, _ latitude: Double, _ longitude: Double) {
        
        Console.clear()

        print(json)

        guard let data = json.data(using: .utf8) else {
            showError(.unexpectedResult, "No se pudo crear data de dirección del mapa")
            return
        }
        
        do {
            
            let payload = try JSONDecoder().decode(ReverseGeocodeMapResponse.self, from: data)
            
            guard payload.status == "ok" else {
                showError(.generalError, payload.msg ?? "No se pudo localizar dirección con esas coordenadas.")
                return
            }
            
            guard let addresses = payload.addresses, let address = addresses.first else {
                showError(.generalError, "No se localizaron direcciones con esas coordenadas.")
                return
            }
            
            if addresses.count > 1 {

                self.multipleResultsContainer.innerHTML = ""

                addresses.forEach { address in

                    let streetValue = (address.street?.isEmpty == false ? address.street : [address.streetName, address.streetNumber].compactMap { value in
                        guard let value, !value.isEmpty else { return nil }
                        return value
                    }.joined(separator: " ")) ?? ""
                    
                    let colonyValue = address.colony ?? ""
                    
                    let cityValue = address.city ?? ""
                    
                    let stateValue = address.state ?? ""
                    
                    let countryValue = Countries(rawValue: (address.country ?? "")) ?? .mexico
                    
                    let zipValue = address.zip ?? ""

                    let view = Div("")
                    .marginBottom(7.px)
                    .width(95.percent)
                    .class(.uibtn)
                    .onClick {

                        self.callback(.coordinates(
                            .init(
                                latitude: latitude,
                                longitude: longitude,
                                street: streetValue,
                                settlement: colonyValue,
                                city: cityValue,
                                state: stateValue,
                                zip: zipValue,
                                country: countryValue
                            )
                        ))

                        self.remove()
                    }

                    self.multipleResultsContainer.appendChild(view)
                }

                return
            }

            for (index, address) in addresses.enumerated() {
                print("🗺 Posible dirección \(index + 1): \(address.printableAddress)")
            }
            
            let streetValue = address.street?.isEmpty == false ? address.street : [address.streetName, address.streetNumber].compactMap { value in
                guard let value, !value.isEmpty else { return nil }
                return value
            }.joined(separator: " ")
            
            if let streetValue, !streetValue.isEmpty {
                street = streetValue
            }
            
            if let colony = address.colony, !colony.isEmpty {
                self.settlement = colony
            }
            
            if let city = address.city, !city.isEmpty {
                self.city = city
            }
            
            if let state = address.state, !state.isEmpty {
                self.state = state
            }
            
            if let country = address.country, !country.isEmpty {
                if let value = Countries(rawValue: country) {
                    self.country = value
                }
            }
            
            if let zip = address.zip, !zip.isEmpty {
                self.zip = zip
            }

            self.callback(.coordinates(
                .init(
                    latitude: latitude,
                    longitude: longitude,
                    street: self.street,
                    settlement: self.settlement,
                    city: self.city,
                    state: self.state,
                    zip: self.zip,
                    country: self.country
                )
            ))

            self.remove()
            
            
        } catch {
            showError(.unexpectedResult, "No se pudo decodificar dirección de coordenadas.")
            return
        }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $state.removeAllListeners()
        $city.removeAllListeners()
        $settlement.removeAllListeners()
        $cities.removeAllListeners()
        $settlementRefrence.removeAllListeners()
        $settlementCrossRefrence.removeAllListeners()
    }
    
}

extension ManualAddressSearch {
    
    struct AddressItem {
        
        let orderId: UUID

        let colony: String

        let city: String

        let state: String

        let country: String
        
        init(
            orderId: UUID,
            colony: String,
            city: String,
            state: String,
            country: String
        ) {
            self.orderId = orderId
            self.colony = colony
            self.city = city
            self.state = state
            self.country = country
        }
        
    }
    
    /// byCountry(Countries), byAddress(AddressItem)
    enum LoadType {
        case byCountry(Countries)
        
        case byAddress(AddressItem)
        
    }

    public struct AddressResult {

        let settlement: String

        let city: String

        let state: String

        let zip: String

        let country: Countries

    }

    public struct CoordinateResult {

        let latitude: Double

        let longitude: Double

        let street: String

        let settlement: String

        let city: String

        let state: String

        let zip: String

        let country: Countries

    }

    enum ResultType {

        case address(AddressResult)

        case coordinates(CoordinateResult)
    }
    
}
