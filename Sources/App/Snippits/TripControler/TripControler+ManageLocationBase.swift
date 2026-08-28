//
//  TripControler+ManageLocationBase.swift
//  
//
//  Created by Victor Cantu on 1/10/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

private func tripLocationDateInputValue(_ uts: Int64) -> String {

    let uts = uts + (60 * 60 * 6)

    let date = getDate(uts)
    let month = date.month < 10 ? "0\(date.month)" : date.month.toString
    let day = date.day < 10 ? "0\(date.day)" : date.day.toString

    return "\(date.year)-\(month)-\(day)"
}

private func tripLocationTimeInputValue(_ uts: Int64) -> String {
    
    let uts = uts + (60 * 60 * 6)

    let date = getDate(uts)
    let hour = date.hour < 10 ? "0\(date.hour)" : date.hour.toString
    let minute = date.minute < 10 ? "0\(date.minute)" : date.minute.toString

    return "\(hour):\(minute)"
}

private func tripLocationDateTimeInputUTS(
    date: String,
    time: String,
    timeZone: TimeZone = TimeZone(secondsFromGMT: -6 * 60 * 60) ?? .current
) -> Int64? {
    let dateParts = date.explode("-")
    let timeParts = time.explode(":")

    guard dateParts.count == 3 else { return nil }
    guard timeParts.count == 2 else { return nil }
    guard let year = Int(dateParts[0]) else { return nil }
    guard let month = Int(dateParts[1]) else { return nil }
    guard let day = Int(dateParts[2]) else { return nil }
    guard let hour = Int(timeParts[0]) else { return nil }
    guard let minute = Int(timeParts[1]) else { return nil }
    guard (month > 0 && month < 13) else { return nil }
    guard (day > 0 && day < 32) else { return nil }
    guard (hour >= 0 && hour < 24) else { return nil }
    guard (minute >= 0 && minute < 60) else { return nil }

    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute

    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone

    return calendar.date(from: components)?.timeIntervalSince1970.toInt64
}

class ManageLocationBase: Div {
    
    override class var name: String { "div" }
    
    var currentPlacementCount: Int
    
    private var callback: ((
        _ placement: CallbackType
    ) -> ())
    
    init(
        currentPlacementCount: Int,
        callback: @escaping ((
            _ placement: CallbackType
        ) -> ())
    ) {
        self.currentPlacementCount = currentPlacementCount
        self.callback = callback
        super.init()
    }
    
    init(
        item: FiscalLocationBase,
        currentPlacementCount: Int,
        callback: @escaping ((
            _ placement: CallbackType
        ) -> ())
    ) {
        self.currentPlacementCount = currentPlacementCount
        self.callback = callback

        self.id = item.id
        self.status = item.status
        self.placementType = item.placementType
        self.placementId = item.placementId
        self.rfc = item.rfc
        self.razon = item.razon
        self.date = tripLocationDateInputValue(item.uts)
        self.time = tripLocationTimeInputValue(item.uts)
        self.storeName = item.storeName
        self.street = item.street
        self.number = item.number
        self.colonie = item.colonie
        self.refrence = item.refrence
        self.state = item.state
        self.country = item.country
        self.zipCode = item.zipCode
        self.isHomeItem = item.placementType == .origen
        self.hasDestination = true

        super.init()


    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    @State var id: UUID? = nil

    var status: BasicStatus = .active
    
    @State var isHomeItem: Bool = true
    
    @State var hasDestination: Bool = false
    
    ///IDUbicacion
    @State var placementId: String = "DE\(Int.random(in: 100000...999999).toString)"
    /// TipoUbicacion
    /// origen, destino
    var placementType: TipoUbicacion = .destino
    /// RFCRemitenteDestinatario
    @State var rfc = ""
    /// NombreRemitenteDestinatario
    @State var razon = ""
    /// date component of FechaHoraSalidaLlegada
    @State var date = ""
    /// hour component of FechaHoraSalidaLlegada
    @State var time = ""
    /// NombreEstacion
    @State var storeName = ""
    /// Domicilio Calle
    @State var street = ""
    /// Domicilio NumeroExterior
    @State var number = ""
    // Domicilio Colonia
    @State var colonie = ""
    /// Domicilio Referencia
    @State var refrence = ""
    /// Domicilio Estado
    /// aguascalientes, bajaCalifornia, bajaCaliforniaSur...
    @State var state: CountryStatesMexico = .tamaulipas
    /// Domicilio Pais
    @State var country = "MEX"
    /// Domicilio CodigoPostal
    @State var zipCode = ""
    
    /// Distancia recorrida
    @State var distance = ""
    
    lazy var rfcField = InputText(self.$rfc)
        .placeholder("RFC")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var razonField = InputText(self.$razon)
        .placeholder("Razon Social")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var dateField = InputDate(self.$date)
        .placeholder("Fecha")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var timeField = InputTime(self.$time)
        .placeholder("HH:MM")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var storeNameField = InputText(self.$storeName)
        .placeholder("Nombre de la tienda")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var streetField = InputText(self.$street)
        .placeholder("Calle")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var numberField = InputText(self.$number)
        .placeholder("Numero")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var colonieField = InputText(self.$colonie)
        .placeholder("Colonia")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var refrenceField = InputText(self.$refrence)
        .placeholder("Edificio blanco con negro")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var stateSelect = Select()
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .onChange { event, select in
            
            if let state = CountryStatesMexico.allCases.first(where: { $0.code == select.value }) {
                self.state = state
            }
        }.onChange { event, select in
            
        }
    
    lazy var countrySelect = Select()
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        
    
    
    lazy var zipCodeField = InputText(self.$zipCode)
        .placeholder("87000")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var disctaceField = InputText(self.$distance)
        .placeholder("Kilometros")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                Div {
                    Img()
                        .src(self.$isHomeItem.map {
                            $0
                                ? "/skyline/media/icon_origin.png"
                                : "/skyline/media/icon_destination.png"
                        })
                        .class(.iconBlue)
                        .height(34.px)

                    H2(self.$isHomeItem.map { isHomeItem in
                        if self.id != nil {
                            return isHomeItem ? "0Editar Ubicacion de SALIDA" : "0Editar Ubicacion de ENTREGA"
                        }

                        return isHomeItem ? "0 Agregar Ubicacion de SALIDA" : "0Agregar Ubicacion de ENTREGA"
                    })
                        .margin(all: 0.px)
                        .class(Class(TCTripBetaClass.titleText))
                }
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-width", "0")

                Img()
                    .closeButton(.uiView1)
                    .class(Class(TCTripBetaClass.close))
                    .onClick{
                        if self.hasDestination {
                            self.remove()
                        }
                        else{
                            addToDom(ConfirmationView(type: .yesNo, title: "Configuracion sin terminar", message: "No se ha ingresado salida y destino de viaje\n¿Desea salir?", callback: { isConfirmed, comment in
                                if isConfirmed {
                                    self.remove()
                                }
                            }))
                        }
                    }
            }
            .class(Class(TCTripBetaClass.title))

            Div {

                Div{
                    Div("Nombre de la tienda")
                        .color(.gray)
                        .width(20.percent)
                        .float(.left)
                    
                    Div{
                        self.storeNameField
                    }
                    .color(.yellowTC)
                    .width(30.percent)
                    .float(.left)
                    
                    Div("Id Tienda")
                        .color(.gray)
                        .width(20.percent)
                        .align(.right)
                        .float(.left)
                
                    Div(self.$placementId)
                    .color(.yellowTC)
                    .width(20.percent)
                    .align(.right)
                    .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(3.px)
                
                Div {
                    Div(self.$isHomeItem.map{ $0 ? "RFC del Emisor" : "RFC del Receptor" })
                        .color(.yellowTC)
                        .width(25.percent)
                        .float(.left)
                    
                    Div(self.$isHomeItem.map{ $0 ? "Nombre del Emisor" : "Nombre del Receptor" })
                        .color(.yellowTC)
                        .width(35.percent)
                        .float(.left)
                    
                    Div("Fecha")
                        .color(.yellowTC)
                        .width(20.percent)
                        .float(.left)
                    
                    Div("Hora (24h)")
                        .color(.white)
                        .width(20.percent)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(3.px)
                
                Div {
                    
                    Div{
                        self.rfcField
                    }
                    .color(.white)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        self.razonField
                    }
                    .color(.white)
                    .width(35.percent)
                    .float(.left)
                    
                    
                    Div{
                        self.dateField
                    }
                    .color(.white)
                    .width(20.percent)
                    .float(.left)
                    
                    
                    Div{
                        self.timeField
                    }
                    .color(.white)
                    .width(20.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                }
                .marginBottom(7.px)
                
                H2(self.$isHomeItem.map{ $0 ? "Direccion de Salida" : "Direccion de Recepcion" })
                    .color(.white)
                
                Div {
                    Div("Calle")
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 25.percent : 22.percent })
                        .float(.left)
                    
                    Div("Numero")
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 15.percent : 12.percent })
                        .float(.left)
                    
                    Div("Refrence")
                        .color(.white)
                        .width(25.percent)
                        .width(self.$isHomeItem.map{ $0 ? 25.percent : 22.percent })
                        .float(.left)
                    
                    Div("State")
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 20.percent : 17.percent })
                        .float(.left)
                    
                    Div("Codigo Postal")
                        .color(.yellowTC)
                        .width(self.$isHomeItem.map{ $0 ? 15.percent : 12.percent })
                        .float(.left)
                    
                    Div("Distancia")
                        .hidden(self.$isHomeItem.map{ $0 })
                        .color(.yellowTC)
                        .width(12.5.percent)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(3.px)
                
                Div {
                    
                    Div{
                        self.streetField
                    }
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 25.percent : 22.percent })
                        .float(.left)
                    
                    Div{
                        self.numberField
                    }
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 15.percent : 12.percent })
                        .float(.left)
                    
                    Div{
                        self.refrenceField
                    }
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 25.percent : 22.percent })
                        .float(.left)
                    
                    Div{
                        self.stateSelect
                    }
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 20.percent : 17.percent })
                        .float(.left)
                    
                    Div{
                        self.zipCodeField
                    }
                        .color(.white)
                        .width(self.$isHomeItem.map{ $0 ? 15.percent : 12.percent })
                        .float(.left)
                    
                    Div{
                        self.disctaceField
                    }
                        .hidden(self.$isHomeItem.map{ $0 })
                        .width(12.5.percent)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(7.px)
                
                Div{
                    Div("Eliminar")
                        .class(.uibtn)
                        .onClick {
                            self.deleteItem()
                        }
                        .hidden(self.$id.map{ ($0 == nil) })

                    Div(self.$isHomeItem.map { isHomeItem in
                        if self.id != nil {
                            return "Guardar Cambios"
                        }

                        return isHomeItem ? "Agregar punto de Salida" : "Agregar punto de Recepcion"
                    })
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.addPlace()
                        }
                }
                .class(Class(TCTripBetaClass.titleActions))
                .custom("margin-top", "12px")

            }
            .class(
                Class(TCTripBetaClass.box),
                Class(TCTripBetaClass.boxRaised)
            )
            .custom("display", "flex")
            .custom("flex-direction", "column")
            .custom("gap", "10px")
            .custom("min-height", "0")
            .custom("overflow", "auto")
            .custom("box-sizing", "border-box")
            .padding(all: 12.px)
        }
        .class(
            Class(TCTripBetaClass.popUpPanel),
            Class(TCTripBetaClass.popUpPanelFitContent)
        )
        .position(.absolute)
        .width(70.percent)
        .left(15.percent)
        .top(30.percent)
    }
    
    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        self.class(Class(TCTripBetaClass.popUp))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")
        
        if id != nil {
            isHomeItem = placementType == .origen
            hasDestination = true
        }
        else if currentPlacementCount == 0 {
            placementId = "OR\(Int.random(in: 100000...999999).toString)"
            placementType = .origen
            
            isHomeItem = true
            hasDestination = false
        }
        else if currentPlacementCount == 1 {
            placementType = .destino
            isHomeItem = false
            hasDestination = false
        }
        else{
            placementType = .destino
            isHomeItem = false
            hasDestination = true
        }
        
        // stateSelect
        
        CountryStatesMexico.allCases.forEach { state in
            let opt = Option(state.description)
                .value(state.code)
            
            if state == self.state {
                opt.selected(true)
            }
            
            stateSelect.appendChild(opt)
            
        }
        
    }
    
    override func didAddToDOM() {
        
        super.didAddToDOM()
        
        self.storeNameField.select()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $id.removeAllListeners()
        $isHomeItem.removeAllListeners()
        $hasDestination.removeAllListeners()
        $placementId.removeAllListeners()
        $rfc.removeAllListeners()
        $razon.removeAllListeners()
        $date.removeAllListeners()
        $time.removeAllListeners()
        $storeName.removeAllListeners()
        $street.removeAllListeners()
        $number.removeAllListeners()
        $colonie.removeAllListeners()
        $refrence.removeAllListeners()
        $state.removeAllListeners()
        $country.removeAllListeners()
        $zipCode.removeAllListeners()
        $distance.removeAllListeners()
    }
    
    func addPlace() {
        guard !storeName.purgeSpaces.isEmpty else {
            showError(.requiredField, "Nombre de la tienda")
            storeNameField.select()
            return
        }

        guard !rfc.purgeSpaces.isEmpty else {
            showError(.requiredField, "RFC")
            rfcField.select()
            return
        }

        guard !razon.purgeSpaces.isEmpty else {
            showError(.requiredField, "Razon Social")
            razonField.select()
            return
        }

        guard !date.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese fecha de envio/recepcion")
            dateField.select()
            return
        }

        guard !time.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese hora de envio/recepcion")
            timeField.select()
            return
        }

        guard let uts = tripLocationDateTimeInputUTS(date: date, time: time) else {
            showError(.requiredField, "Ingrese fecha y hora validas")
            dateField.select()
            return
        }

        guard !zipCode.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese Codigo Postal")
            zipCodeField.select()
            return
        }

        let item = FiscalLocationBase(
            id: id ?? UUID(),
            placementType: placementType,
            placementId: placementId,
            rfc: rfc.purgeSpaces.uppercased().replace(from: " ", to: ""),
            razon: razon.pseudo.purgeSpaces.uppercased(),
            uts: uts,
            storeName: storeName.pseudo.purgeSpaces.uppercased(),
            street: street.pseudo.purgeSpaces.uppercased(),
            number: number.pseudo.purgeSpaces.uppercased(),
            colonie: colonie.pseudo.purgeSpaces.uppercased(),
            refrence: refrence.pseudo.purgeSpaces.uppercased(),
            state: state,
            country: country,
            zipCode: zipCode.purgeSpaces,
            status: status
        )

        loadingView.show()

        if let id {
            API.custCommercialTrips.updateLocation(
                id: id,
                placementType: item.placementType,
                placementId: item.placementId,
                rfc: item.rfc,
                razon: item.razon,
                uts: item.uts,
                storeName: item.storeName,
                street: item.street,
                number: item.number,
                colonie: item.colonie,
                refrence: item.refrence,
                state: item.state,
                country: item.country,
                zipCode: item.zipCode
            ) { resp in
                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.update(item))
                self.remove()
            }

            return
        }

        API.custCommercialTrips.createLocation(
            placementType: item.placementType,
            placementId: item.placementId,
            rfc: item.rfc,
            razon: item.razon,
            uts: item.uts,
            storeName: item.storeName,
            street: item.street,
            number: item.number,
            colonie: item.colonie,
            refrence: item.refrence,
            state: item.state,
            country: item.country,
            zipCode: item.zipCode
        ) { resp in
            loadingView.hide()

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.callback(.create(payload.item))
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Ubicacion",
            message: "Confirme que desea eliminar esta ubicacion."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView.show()

            API.custCommercialTrips.deleteLocation(locationId: id) { resp in
                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.delete(id))
                self.remove()
            }
        })
    }
}
    

extension ManageLocationBase {

    enum CallbackType {
        case create(FiscalLocationBase)
        case update(FiscalLocationBase)
        case delete(UUID)
    }

}
