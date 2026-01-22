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
        _ settlement: String,
        _ city: String,
        _ state: String,
        _ zip: String,
        _ country: Countries
    ) -> ())
    
    init(
        _ loadBy: LoadType,
        callback: @escaping ((
            _ settlement: String,
            _ city: String,
            _ state: String,
            _ zip: String,
            _ country: Countries
        ) -> ())
    ) {
        self.loadBy = loadBy
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var state = ""
    
    @State var city = ""
    
    @State var settelment = ""
    
    @State var cities: [String] = []
    
    @State var settelmentRefrence: [ String : PostalCodesMexicoItem ] = [:]
    
    @State var settelmentCrossRefrence: [ String : PostalCodesMexicoItem ] = [:]
    
    var country: Countries = .mexico
    
    lazy var countryField = InputText(self.country.description)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .autocomplete(.off)
        .placeholder(.city)
        .cursor(.pointer)
        .disabled(true)
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
    
    lazy var settelmentResultSelect = Select(self.$settelment)
        .custom("width", "calc(100% - 18px)")
        .class(.textFiledLightLarge)
        .height(37.px)
        .body {
            Option("Seleccione Colonia")
                .value("")
        }
    
    @DOM override var body: DOM.Content {
        Div{
            // MARK:  header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H1("Buscar Direccion").color(.lightBlueText)
                
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
                    self.settelmentResultSelect
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        Div("Seleccionar")
                            .custom("width", "calc(100% - 14px)")
                            .class(.uibtnLargeOrange)
                            .align(.center)
                            .onClick {
                                
                                Console.clear()
                                
                                print(self.settelmentRefrence)
                                
                                print("- - - - - - - - - - - - -")
                                
                                print(self.settelment)
                                
                                guard let zipCodeData = self.settelmentCrossRefrence[self.settelment] else {
                                    print("🔴 zipCodeData")
                                    return
                                }
                                
                                guard let state = CountryStatesMexico(rawValue: self.state) else {
                                    print("🔴 city")
                                    return
                                }
                                
                                self.callback(
                                    self.settelment,
                                    (zipCodeData.city ?? zipCodeData.county),
                                    state.description,
                                    zipCodeData.code,
                                    self.country
                                )
                                
                                self.remove()
                                
                            }
                    }
                    .hidden(self.$settelment.map{ $0.isEmpty })
                }
                //.hidden(self.$cities.map{ $0.isEmpty })
                
            }
            .hidden(self.$cities.map{ $0.isEmpty })
            
        }
        .custom("left", "calc(50% - 212px)")
        .custom("top", "calc(50% - 212px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .padding(all: 12.px)
        .position(.absolute)
        .width(400.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
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
                showError(.campoInvalido, "Lo sentimos este servicio solo esta disponible para Mexico. Es posible que necesite corregir su ortografia o haga un ingreso manual.")
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
        
        settelment = ""
        
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
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.errorGeneral, "Unexpected missing payload.")
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
                
                /// Parse Items, each item is a settelment
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
        
        settelment = ""
        
        settelmentResultSelect.innerHTML = ""
        
        settelmentRefrence.removeAll()
        
        settelmentCrossRefrence.removeAll()
        
        settelmentResultSelect.appendChild(
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
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            var settelments: [String] = []
            
            data.forEach { item in
                
                self.settelmentRefrence["\(item.settlement) | \(item.settlementType.description)"] = item
                
                self.settelmentCrossRefrence["\(item.settlementType.description) \(item.settlement)"] = item
                
                if settelments.contains("\(item.settlement) | \(item.settlementType.description)") {
                    return
                }
                
                settelments.append("\(item.settlement) | \(item.settlementType.description)")
            }
            
            settelments.sort()
            
            settelments.forEach { settelmentName in
                
                guard let code = self.settelmentRefrence[settelmentName] else {
                    return
                }
                
                self.settelmentResultSelect.appendChild(
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
                
                /// Parse Items, each item is a settelment
                items.forEach { item in
                    
                    let purgedItem = item.pseudo.purgeSpaces
                    
//                    print("💎 💎  purgedItem: \(purgedItem)  💎 💎 ")
                    
                    /// Purged parts of the current settment that i have EG: ["olivos", ["mama"]]
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
                
                self.settelment = "\(item.settlementType.description) \(item.settlement)"
                
            }
        }
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
    
}
