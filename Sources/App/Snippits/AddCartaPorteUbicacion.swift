//
//  AddCartaPorteUbicacion.swift
//  
//
//  Created by Victor Cantu on 1/10/23.
//

import Foundation
import TCFundamentals
import Web

class AddCartaPorteUbicacion: Div {
    
    override class var name: String { "div" }
    
    var currentPlacementCount: Int
    
    private var callback: ((
        _ placement: FiscalLocationItem
    ) -> ())
    
    init(
        currentPlacementCount: Int,
        callback: @escaping ((
            _ placement: FiscalLocationItem
        ) -> ())
    ) {
        self.currentPlacementCount = currentPlacementCount
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
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
    @State var state: MexicanStates = .tamaulipas
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
    
    lazy var dateField = InputText(self.$date)
        .placeholder("DD/MM/AAAA")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var timeField = InputText(self.$time)
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
            
            if let state = MexicanStates(rawValue: select.value) {
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
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        if self.hasDestination {
                            self.remove()
                        }
                        else{
                            addToDom(ConfirmView(type: .yesNo, title: "Configuracion sin terminar", message: "No se ha ingresado salida y destino de viaje\n¿Desea salir?", callback: { isConfirmed, comment in
                                if isConfirmed {
                                    self.remove()
                                }
                            }))
                        }
                    }
                
                H2(self.$isHomeItem.map{ $0 ? "Agregar Ubicacion de SALIDA" : "Agregar Ubicacion de ENTREGA" })
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
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
                Div(self.$isHomeItem.map{ $0 ? "Agregar punto de Salida" : "Agregar punto de Recepcion" })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addPlace()
                    }
            }
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(80.percent)
        .left(10.percent)
        .top(25.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        
        if currentPlacementCount == 0 {
            placementId = "OR\(Int.random(in: 100000...999999).toString)"
            placementType = .origen
            
            isHomeItem = true
            hasDestination = false
        }
        else if currentPlacementCount == 1 {
            isHomeItem = false
            hasDestination = false
        }
        else{
            hasDestination = true
        }
        
        // stateSelect
        
        MexicanStates.allCases.forEach { state in
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
    }
    
    func addPlace(){
        
        guard !storeName.isEmpty else {
            showError(.campoRequerido, "Nombre de la tienda")
            return
        }
        
        guard !rfc.isEmpty else {
            showError(.campoRequerido, "RFC")
            return
        }
        
        guard !razon.isEmpty else {
            showError(.campoRequerido, "Razon Social")
            return
        }
        
        guard !date.isEmpty else {
            showError(.campoRequerido, "Ingrese fecha de envio/recepcion")
            return
        }
        
        if !date.contains("/") {
            
            print("001 date \(date)")
            
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        let dateParts = date.explode("/")
        
        if dateParts.count != 3 {
            print("002 date \(date)")
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard let day = Int(dateParts[0]) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Dia invalido, ingrese un dia valido entre 1 y el 31", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard (day > 0 && day < 32) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Dia invalido, ingrese un dia valido entre 1 y el 31.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard let month = Int(dateParts[1]) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Mes invalido, ingrese un mes valido entre 1 y el 12.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard (month > 0 && month < 13) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Mes invalido, ingrese un mes valido entre 1 y el 12.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard let year = Int(dateParts[2]) else {
            return
        }
        
        guard year >= Date().year else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Año invalido, ingrese un año igual o mayor que al presente.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard !time.isEmpty else {
            showError(.campoRequerido, "Ingrese hora de envio/recepcion")
            return
        }
        
        
        if !time.contains(":") {
            addToDom(ConfirmView(type: .ok, title: "Formato de hora invalida", message: "La hora debe de tener el siguente formato:\nHH:MM", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        let hourParts = time.explode(":")
        
        
        if hourParts.count != 2 {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "La hora debe de tener el siguente formato:\nHH:MM", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard let hour = Int(hourParts[0]) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Hora invalido, ingrese una hora valido entre 1 y el 24", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard (hour >= 0 && hour < 25) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Hora invalido, ingrese una hora valido entre 1 y el 24.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard let min = Int(hourParts[1]) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Minuto invalido, ingrese un minito valido entre 0 y el 59", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        guard (min >= 0 && min < 60) else {
            addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida", message: "Minuto invalido, ingrese un minito valido entre 0 y el 59.", callback: { isConfirmed, comment in
                
            }))
            return
        }
        
        var comps = DateComponents() // <1>
        comps.day = day
        comps.month = month
        comps.year = year
        comps.hour = hour
        comps.minute = min
        
        guard let uts = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
            showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
            return
        }
        
        guard !zipCode.isEmpty else {
            showError(.campoRequerido, "Ingrese Codigo Postal")
            return
        }
        
        let distance = Float(distance)?.toCents
        
        if placementType == .destino {
            if distance == nil {
                showError(.campoRequerido, "Ingrese distancia recorrida del punto anterior")
                return
            }
        }
        
        callback(.init(
            id: .init(),
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
            distance: distance
        ))
        
        self.placementType = .destino
        
        self.placementId = "DE\(Int.random(in: 100000...999999).toString)"
        
        self.rfc = ""
        self.razon = ""
        self.date = ""
        self.time = ""
        self.storeName = ""
        self.street = ""
        self.number = ""
        self.colonie = ""
        self.refrence = ""
        self.zipCode = ""
        self.rfcField.text = ""
        self.razonField.text = ""
        self.dateField.text = ""
        self.timeField.text = ""
        self.storeNameField.text = ""
        self.streetField.text = ""
        self.numberField.text = ""
        self.colonieField.text = ""
        self.refrenceField.text = ""
        self.zipCodeField.text = ""
        
        self.storeNameField.select()

        currentPlacementCount += 1
        
        if currentPlacementCount == 1 {
            isHomeItem = false
            hasDestination = false
        }
        else{
            hasDestination = true
        }
        
        showSuccess(.operacionExitosa, "Agregado")
        
    }
}
    
