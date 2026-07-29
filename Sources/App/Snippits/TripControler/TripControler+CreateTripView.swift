//
// TripControler+CreateTripView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateTripView: Div {
    
    override class var name: String { "div" }

    let account: CustAcctSearch

    var operadors: [CustCommercialTripOperador]

    var insurances: [CustCommercialTripInsurance]

    var permits: [CustCommercialTripPermit]

    var vehicals: [CustCommercialTripVehical]

    var trailers: [CustCommercialTripTrailer]
    
    var merchendises: [FiscalMercanciaBase]
    
    var baseLocationsOrigin: [FiscalLocationBase] = []

    var baseLocationsDestination: [FiscalLocationBase] = []

    private let callback: (
        _ result: API.custCommercialTrips.GetTripResponse
    ) -> Void

    init(
        account: CustAcctSearch,
        operadors: [CustCommercialTripOperador],
        insurances: [CustCommercialTripInsurance],
        permits: [CustCommercialTripPermit],
        vehicals: [CustCommercialTripVehical],
        trailers: [CustCommercialTripTrailer],
        merchendises: [FiscalMercanciaBase],
        locations: [FiscalLocationBase],
        callback: @escaping (
            _ result: API.custCommercialTrips.GetTripResponse
        ) -> Void
    ) {
        self.account = account
        self.operadors = operadors
        self.insurances = insurances
        self.permits = permits
        self.vehicals = vehicals
        self.trailers = trailers
        self.merchendises = merchendises
        self.callback = callback
        
        super.init()

        locations.forEach { location in 
            if location.placementType == .origen {
                baseLocationsOrigin.append(location)
            }
            else {
                baseLocationsDestination.append(location)
            }
        }

    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var operador: CustCommercialTripOperador? = nil
    @State var permit: CustCommercialTripPermit? = nil
    @State var vehical: CustCommercialTripVehical? = nil
    @State var trailerOne: CustCommercialTripTrailer? = nil
    @State var trailerTwo: CustCommercialTripTrailer? = nil
    @State var civilInsurance: CustCommercialTripInsurance? = nil
    @State var ambientInsurance: CustCommercialTripInsurance? = nil
    @State var payloadInsurance: CustCommercialTripInsurance? = nil
    @State var merchendise: [FiscalMercanciaItem] = []
    @State var locations: [FiscalLocationItem] = []

    @State var balance: String = ""

    @State var odometerInitial = ""

    @State var odometerFinal = ""

    @State var requierTrailer: Bool = false

    @State var autoForm: Bool = true 

    @DOM override var body: DOM.Content {
        VPopUp(.full) {

            VTitle("Crear Nuevo Viaje") {

                USmallButton("Crear Viaje")
                    .custom("background", "var(--tc-beta-orange)")
                    .custom("color", "#151719")
                    .onClick {
                        self.createTrip()
                    }
            } onClose: {
                self.remove()
            }

            VBodyGrid {

                VGrid(.full) {
                    VBox(.raised) {
                        Div {
                            H2(self.account.businessName)
                                .margin(all: 0.px)
                                .fontSize(22.px)
                                .color(.white)

                            Div("Cuenta \(self.account.folio) · RFC \(self.account.fiscalRfc)")
                                .marginTop(4.px)
                                .class(.oneLineText)
                                .color(.gray)
                        }
                        .overflow(.hidden)

                        UField("Costo del viaje") {
                            UTextField(self.$balance)
                                .placeholder("0.00")
                                .onFocus { field in
                                    field.select()
                                }
                        }

                        Div {
                            UField("Odómetro inicial", required: false) {
                                UTextField(self.$odometerInitial)
                                    .placeholder("Opcional")
                                    .onFocus { field in
                                        field.select()
                                    }
                            }

                            UField("Odómetro final", required: false) {
                                UTextField(self.$odometerFinal)
                                    .placeholder("Opcional")
                                    .onFocus { field in
                                        field.select()
                                    }
                            }
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                        .custom("gap", "10px")
                    }
                    .display(.grid)
                    .custom("grid-template-columns", "minmax(240px, 1fr) minmax(190px, 280px)")
                    .custom("align-items", "center")
                    .custom("gap", "24px")
                }

                VGrid(.twoThirds) {
                    VBox {
                        Div {
                            UTitle("Ruta del viaje")

                            USmallButton("Agregar ubicación")
                                .onClick {
                                    self.addDestination()
                                }
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "minmax(0, 1fr) auto")
                        .custom("align-items", "center")
                        .custom("gap", "10px")

                        self.destinationGrid
                    }

                    VBox {
                        Div {
                            UTitle("Mercancía a trasladar")

                            USmallButton("Agregar mercancía")
                                .onClick {
                                    self.addMerchendise()
                                }
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "minmax(0, 1fr) auto")
                        .custom("align-items", "center")
                        .custom("gap", "10px")

                        self.mercaciaGrid
                    }

                }

                VGrid(.oneThird) {
                    self.operadorPanel
                    self.vehicalPanel
                    self.insurancePanel
                    self.trailerPanel
                }
            
            }
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()

        self.selectOperador()

    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        
        position(.fixed)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

        $vehical.listen { item in

            self.requierTrailer = item?.requierTrailer ?? false

            if !self.requierTrailer {
                self.trailerOne = nil
                self.trailerTwo = nil
            }

        }

        $locations.listen { locations in
            self.destinationGrid.innerHTML = ""

            locations.enumerated().forEach { index, location in
                self.destinationGrid.appendChild(
                    CartaPorteUbicacion(
                        placement: location,
                        canRemove: index == locations.count - 1,
                        edit: { item in
                            self.manageLocationItem(item, isEditing: true)
                        }
                    ) { id in
                        guard self.locations.last?.id == id else { return }
                        self.locations.removeLast()
                    }
                )
            }
        }

        $merchendise.listen { merchendise in
            self.mercaciaGrid.innerHTML = ""

            merchendise.forEach { item in
                self.mercaciaGrid.appendChild(
                    CartaPorteMerchendise(merchadise: item) { id in
                        self.merchendise.removeAll { $0.id == id }
                    }
                )
            }
        }

    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

        $operador.removeAllListeners()
        $permit.removeAllListeners()
        $vehical.removeAllListeners()
        $trailerOne.removeAllListeners()
        $trailerTwo.removeAllListeners()
        $civilInsurance.removeAllListeners()
        $ambientInsurance.removeAllListeners()
        $payloadInsurance.removeAllListeners()
        $merchendise.removeAllListeners()
        $locations.removeAllListeners()
        $balance.removeAllListeners()
        $odometerInitial.removeAllListeners()
        $odometerFinal.removeAllListeners()
        $requierTrailer.removeAllListeners()
    }

    lazy var destinationGrid = Div()
        .custom("min-height", "190px")
        .custom("max-height", "360px")
        .custom("margin-top", "12px")
        .custom("background", "var(--tc-beta-surface-deep)")
        .border(width: .thin, style: .solid, color: .gray)
        .borderRadius(all: 10.px)
        .overflow(.auto)

    lazy var mercaciaGrid = Div()
        .custom("min-height", "190px")
        .custom("max-height", "360px")
        .custom("margin-top", "12px")
        .custom("background", "var(--tc-beta-surface-deep)")
        .border(width: .thin, style: .solid, color: .gray)
        .borderRadius(all: 10.px)
        .overflow(.auto)
    
    lazy var operadorPanel = VBox {
        
        Div {

            Div{

                Img()
                    .src("/skyline/media/add.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.selectOperador()
                    }

            }
            .float(.right)

            UTitle("Operador")
                .float(.left)

        }
        
        Div().clear(.both).height(3.px)
        
        Div{

            self.operadorSelectButton

            self.operadorSelectedView

        }
        .overflow(.auto)

    }
    .overflow(.hidden)

    lazy var vehicalPanel = VBox {


        Div {
            Div{
                Img()
                    .src("/skyline/media/add.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.selectVehical()
                    }
            }
            .float(.right)

            UTitle("Vehículo y permiso")
                .float(.left)

        }
        
        Div().clear(.both).height(3.px)
        
        Div{

            self.vehicalSelectButton
            self.vehicalSelectedView

        }
        .overflow(.auto)

    }
    .overflow(.hidden)

    lazy var insurancePanel = VBox {
        
        Div {

            UTitle("Pólizas de seguro")

        }
        
        Div().clear(.both).height(3.px)
        
        Div {

            Div{
                Img()
                    .src("/skyline/media/add.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.selectInsurance(.civil)
                    }
            }
            .float(.right)

            Label("Civil").color(.white)

        }
        
        self.civilInsuranceSelectButton
        self.civilInsuranceSelectedView

        Div().class(.clear).height(7)

        Div {

            Div{
                Img()
                    .src("/skyline/media/add.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.selectInsurance(.ambient)
                    }
            }
            .float(.right)

            Label("Ambiental").color(.white)

        }
        
        self.ambientInsuranceSelectButton
        self.ambientInsuranceSelectedView

        Div().class(.clear).height(7.px)

        Div {

            Div{
                Img()
                    .src("/skyline/media/add.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick {
                        self.selectInsurance(.payload)
                    }
            }
            .float(.right)

            Label("Carga").color(.white)

        }
        self.payloadInsuranceSelectButton
        self.payloadInsuranceSelectedView
    }
    .overflowX(.hidden)
    .overflowY(.auto)

    lazy var trailerPanel = VBox {

        UTitle("Remolques")
        
        Div().clear(.both).height(3.px)

        Table {
            Tr {
                Td {

                    Div("Este vehiculo no requiere remolque")
                    .color(.gray)
                    .fontSize(14.px)

                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .hidden(self.$requierTrailer)

        Div {
            Label("Remolque 1")
                .color(.white)
            self.trailerOneSelectButton
            self.trailerOneSelectedView

            Div().class(.clear).height(8.px)

            Label("Remolque 2")
                .color(.white)
            self.trailerTwoSelectButton
            self.trailerTwoSelectedView
        }
        .hidden(self.$requierTrailer.map { !$0 })
    }
    .overflow(.auto)

    lazy var operadorSelectButton = Table {
        Tr{
            Td {
                Div("Seleccione Operador")
                .padding(all: 5.px)
                .class(.uibtn)
                .onClick {
                    self.selectOperador()
                }
            }
            .verticalAlign(.middle)
            .align(.center)
        }
    }
    .hidden(self.$operador.map { $0 != nil })
    .height(100.percent)
    .width(100.percent)

    lazy var operadorSelectedView = Div {

        Div {
            Div("Editar")
            .class(.uibtn)
            .float(.right)
            .onClick {
                guard let item = self.operador else { return }
                self.manageOperador(item)
            }

            Label("Tipo de Operador")
                .color(.white)    
        }
        

        Div(self.$operador.map { $0?.operadorType.description ?? "Seleccione operador" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")

        Div().clear(.both).height(7)

        Label("Nombre del Operador")
            .color(.white)

        Div(self.$operador.map { $0?.operadorName ?? "Seleccione operador" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")

        Div().clear(.both).height(7)

        Label("RFC del Operador")
            .color(.white)

        Div(self.$operador.map { $0?.operadorRfc ?? "Seleccione operador" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")

        Div().class(.clear).height(7.px)

        Label("Licencia del Operador")
            .color(.white)

        Div(self.$operador.map { $0?.operadorLicens ?? "Seleccione operador" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")

        Div().class(.clear).height(7.px)

        Label("Telefono del Operador")
            .color(.white)

        Div(self.$operador.map { $0?.operadorMobile ?? "Seleccione operador" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")
    }
    .overflowX(.hidden)
    .overflowY(.auto)
    .hidden(self.$operador.map { $0 == nil })

    lazy var vehicalSelectButton = Table {
        Tr{
            Td {
                Div("Seleccione Vehiculo")
                    .padding(all: 5.px)
                    .class(.uibtn)
                    .onClick {
                        self.selectVehical()
                    }
            }
            .verticalAlign(.middle)
            .align(.center)
        }
    }
    .hidden(self.$vehical.map { $0 != nil })
    .height(100.percent)
    .width(100.percent)
    
    lazy var vehicalSelectedView = Div {

        Div("Editar")
            .class(.uibtn)
            .float(.right)
            .onClick {
                guard let item = self.vehical else { return }
                self.manageVehical(item)
            }

        Label("Placas / Modelo de Vehiculo")
            .color(.white)

        Div(self.$vehical.map { item in
            guard let item else { return "Seleccione vehiculo" }
            return "\(item.vehicalLicensePlate) / \(item.vehicalYearModel)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

        Div().class(.clear).height(8.px)

        Div{
            Label("Tipo de Permiso / Transporte")
            .marginBottom(7.px)
                .color(.white)
                .hidden(self.$permit.map { $0 != nil })
        }
        self.permitSelectButton
        self.permitSelectedView
    }
    .overflowX(.hidden)
    .overflowY(.auto)
    .hidden(self.$vehical.map { $0 == nil })

    lazy var permitSelectButton = Div("Seleccione Permiso / Transporte")
        .padding(all: 5.px)
        .class(.uibtn)
        .hidden(self.$permit.map { $0 != nil })
        .onClick {
            self.selectPermit()
        }

    lazy var permitSelectedView = Div {
        Div{
            Div("Editar")
                .class(.uibtn)
                .float(.right)
                .onClick {
                    guard let item = self.permit else { return }
                    self.managePermit(item)
                }

            Label("Tipo de Permiso / Transporte")
                .color(.white)

        }
            
        Div().class(.clear).height(3.px)

        Div(self.$permit.map { $0?.permitTypeName ?? "Seleccione permiso" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")

        Div().class(.clear).height(7.px)

        Label("Numero de Permiso")
            .color(.white)

        Div(self.$permit.map { $0?.permitNumber ?? "Seleccione permiso" })
            .class(.textFiledBlackDark, .oneLineText)
            .custom("width", "calc(100% - 16px)")
            .height(31.px)
            .custom("padding-left", "8px")
            .custom("padding-right", "8px")
    }
    .hidden(self.$permit.map { $0 == nil })

    lazy var civilInsuranceSelectButton = Div {
        Div("Seleccione Polisa Civil")
        .padding(all: 5.px)
        .class(.uibtn)
        .onClick {
            self.selectInsurance(.civil)
        }
    }
    .align(.center)
    .hidden(self.$civilInsurance.map { $0 != nil })

    lazy var civilInsuranceSelectedView = Div {
        Div {

            Div("Editar")
                .class(.uibtn)
                .float(.right)
                .onClick {
                    guard let item = self.civilInsurance else { return }
                    self.manageInsurance(.civil, item: item)
                }

            Label("Polisa Civil")
                .color(.white)
        }

        Div().class(.clear).height(3.px)

        Div(self.$civilInsurance.map { item in
            guard let item else { return "Seleccione polisa" }
            return "\(item.provider) | \(item.policyNumber)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

    }
    .hidden(self.$civilInsurance.map { $0 == nil })

    lazy var ambientInsuranceSelectButton = Div {
        Div("Seleccione Polisa Ambiental")
        .padding(all: 5.px)
        .class(.uibtn)
        .onClick {
            self.selectInsurance(.ambient)
        }
    }
    .align(.center)
    .hidden(self.$ambientInsurance.map { $0 != nil })

    lazy var ambientInsuranceSelectedView = Div {
        Div {
            Div("Editar")
                .class(.uibtn)
                .float(.right)
                .onClick {
                    guard let item = self.ambientInsurance else { return }
                    self.manageInsurance(.ambient, item: item)
                }
                
            Label("Polisa Ambiental")
                .color(.white)
        }

        Div().class(.clear).height(3.px)

        Div(self.$ambientInsurance.map { item in
            guard let item else { return "Seleccione polisa" }
            return "\(item.provider) | \(item.policyNumber)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

    }
    .hidden(self.$ambientInsurance.map { $0 == nil })

    lazy var payloadInsuranceSelectButton = Div {
        Div("Seleccione Polisa Carga")
        .padding(all: 5.px)
        .class(.uibtn)
        .hidden(self.$payloadInsurance.map { $0 != nil })
        .onClick {
            self.selectInsurance(.payload)
        }
    }
    .align(.center)

    lazy var payloadInsuranceSelectedView = Div{

        Div {
            Div("Editar")
                .class(.uibtn)
                .float(.right)
                .onClick {
                    guard let item = self.payloadInsurance else { return }
                    self.manageInsurance(.payload, item: item)
                }

            Label("Polisa Carga")
                .color(.white)
        }

        Div().class(.clear).height(3.px)


        Div(self.$payloadInsurance.map { item in
            guard let item else { return "Seleccione polisa" }
            return "\(item.provider) | \(item.policyNumber)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

    }
    .hidden(self.$payloadInsurance.map { $0 == nil })

    lazy var trailerOneSelectButton = Div("Seleccione Remolque 1")
        .padding(all: 5.px)
        .class(.uibtn)
        .hidden(self.$trailerOne.map { $0 != nil })
        .onClick {
            self.selectTrailer(.one)
        }

    lazy var trailerOneSelectedView = Div {
        Div("Editar")
            .class(.uibtn)
            .float(.right)
            .onClick {
                guard let item = self.trailerOne else { return }
                self.manageTrailer(item, placement: .one)
            }

        Div().class(.clear).height(3.px)

        Div(self.$trailerOne.map { item in
            guard let item else { return "Seleccione Remolque 1" }
            return "\(item.name) | \(item.series)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

    }
    .hidden(self.$trailerOne.map { $0 == nil })

    lazy var trailerTwoSelectButton = Div("Seleccione Remolque 2")
        .padding(all: 5.px)
        .class(.uibtn)
        .hidden(self.$trailerTwo.map { $0 != nil })
        .onClick {
            self.selectTrailer(.two)
        }

    lazy var trailerTwoSelectedView = Div {
        Div("Editar")
            .class(.uibtn)
            .float(.right)
            .onClick {
                guard let item = self.trailerTwo else { return }
                self.manageTrailer(item, placement: .two)
            }

        Div().class(.clear).height(3.px)

        Div(self.$trailerTwo.map { item in
            guard let item else { return "Seleccione Remolque 2" }
            return "\(item.name) | \(item.series)"
        })
        .class(.textFiledBlackDark, .oneLineText)
        .custom("width", "calc(100% - 16px)")
        .height(31.px)
        .custom("padding-left", "8px")
        .custom("padding-right", "8px")

    }
    .hidden(self.$trailerTwo.map { $0 == nil })

    enum TrailerPlacement {
        case one
        case two
    }

    func manageOperador(_ item: CustCommercialTripOperador? = nil) {
        if let item {
            addToDom(TripControlerManageOperator(item: item) { result in
                self.handleOperador(result)
            })
        } else {
            addToDom(TripControlerManageOperator { result in
                self.handleOperador(result)



            })
        }
    }

    func manageVehical(_ item: CustCommercialTripVehical? = nil) {
        if let item {
            addToDom(TripControlerManageVehical(item: item) { result in
                self.handleVehical(result)
            })
        } else {
            addToDom(TripControlerManageVehical { result in
                self.handleVehical(result)
            })
        }
    }

    func managePermit(_ item: CustCommercialTripPermit? = nil) {
        if let item {
            addToDom(TripControlerManagePermit(item: item) { result in
                self.handlePermit(result)
            })
        } else {
            addToDom(TripControlerManagePermit { result in
                self.handlePermit(result)
            })
        }
    }

    func manageInsurance(_ type: ComertialTripInsuranceType, item: CustCommercialTripInsurance? = nil) {
        if let item {
            addToDom(TripControlerManageInsurance(item: item) { result in
                self.handleInsurance(result, selectedType: type)
            })
        } else {
            addToDom(TripControlerManageInsurance(type: type) { result in
                self.handleInsurance(result, selectedType: type)
            })
        }
    }

    func manageTrailer(_ item: CustCommercialTripTrailer? = nil, placement: TrailerPlacement? = nil) {
        if let item {
            addToDom(TripControlerManageTrailer(item: item) { result in
                self.handleTrailer(result, placement: placement)
            })
        } else {
            addToDom(TripControlerManageTrailer { result in
                self.handleTrailer(result, placement: placement)
            })
        }
    }

    /// origen, destino
    func manageDestination() {
        addToDom(ManageLocationBase(currentPlacementCount: locations.count) { result in
            self.handleDestination(result)
        })
    }

    func manageMerchendise(_ item: FiscalMercanciaBase? = nil) {
        guard locations.contains(where: { $0.placementType == .origen }),
              locations.contains(where: { $0.placementType == .destino }) else {
            showError(.requiredField, "Agregue Origen y Destino antes de agregar mercancia")
            return
        }

        if let item {
            addToDom(TripControlerManageMerchendiseBase(item: item) { result in
                self.handleMerchendiseBase(result)
            })
        } else {
            addToDom(TripControlerManageMerchendiseBase { result in
                self.handleMerchendiseBase(result)
            })
        }
    }

    func configureMerchendise(_ item: FiscalMercanciaBase) {
        addToDom(AddCartaPorteMerchendise(
            locations: locations,
            merchandise: merchendiseItem(from: item),
            dismissAfterSave: true
        ) { result in
            if let index = self.merchendise.firstIndex(where: { $0.id == result.id }) {
                self.merchendise[index] = result
            } else {
                self.merchendise.append(result)
            }
        })
    }

    func handleMerchendiseBase(
        _ result: TripControlerManageMerchendiseBase.CallbackType
    ) {
        switch result {
        case .create(let item), .update(let item):
            if let index = merchendises.firstIndex(where: { $0.id == item.id }) {
                merchendises[index] = item
            } else {
                merchendises.append(item)
            }

            configureMerchendise(item)

        case .delete(let id):
            merchendises.removeAll { $0.id == id }
            merchendise.removeAll { $0.id == id }
        }
    }

    func addLocation(_ item: FiscalLocationBase) {
        locations.append(locationItem(from: item))
    }

    func manageLocationItem(
        _ item: FiscalLocationItem,
        isEditing: Bool = false
    ) {
        addToDom(ManageLocationItem(item: item, isEditing: isEditing) { updatedItem in
            if isEditing {

                guard let index = self.locations.firstIndex(where: { $0.id == updatedItem.id }) else {
                    return
                }

                self.locations[index] = updatedItem
            } else {
                self.locations.append(updatedItem)

                if self.locations.count < 2 {
                    self.addDestination()
                }

            }
        })
    }

    func configureLocation(_ item: FiscalLocationBase) {
        manageLocationItem(locationItem(from: item))
    }

    func locationItem(
        from item: FiscalLocationBase,
        existing: FiscalLocationItem? = nil
    ) -> FiscalLocationItem {
        FiscalLocationItem(
            id: item.id,
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
            zipCode: item.zipCode,
            position: existing?.position ?? locations.count,
            comertialTripControlId: nil,
            distance: existing?.distance
        )
    }

    func merchendiseItem(from item: FiscalMercanciaBase) -> FiscalMercanciaItem {
        let origin = locations.first(where: { $0.placementType == .origen })
        let destination = locations.last(where: { $0.placementType == .destino })

        return FiscalMercanciaItem(
            id: item.id,
            fiscCode: item.fiscCode,
            fiscCodeName: item.fiscCodeName,
            fiscUnit: item.fiscUnit,
            fiscUnitName: item.fiscUnitName,
            description: item.description,
            units: item.units,
            kilograms: item.kilograms,
            isDangerousMatirial: item.isDangerousMatirial,
            dangerousMatirialCode: item.dangerousMatirialCode,
            dangerousMatirialName: item.dangerousMatirialName,
            packagingType: item.packagingType,
            packagingName: item.packagingName,
            comertialTripControlId: nil,
            from: origin?.placementId ?? "",
            fromStoreName: origin?.storeName ?? "",
            to: destination?.placementId ?? "",
            toStoreName: destination?.storeName ?? ""
        )
    }

    func upsertBaseLocation(_ item: FiscalLocationBase) {
        switch item.placementType {
        case .origen:
            baseLocationsDestination.removeAll { $0.id == item.id }

            if let index = baseLocationsOrigin.firstIndex(where: { $0.id == item.id }) {
                baseLocationsOrigin[index] = item
            } else {
                baseLocationsOrigin.append(item)
            }
        case .destino:
            baseLocationsOrigin.removeAll { $0.id == item.id }

            if let index = baseLocationsDestination.firstIndex(where: { $0.id == item.id }) {
                baseLocationsDestination[index] = item
            } else {
                baseLocationsDestination.append(item)
            }
        }
    }

    func handleDestination(_ result: ManageLocationBase.CallbackType) {
        switch result {
        case .create(let item):
            upsertBaseLocation(item)
            addLocation(item)
        case .update(let item):
            upsertBaseLocation(item)

            if let index = locations.firstIndex(where: { $0.id == item.id }) {
                locations[index] = locationItem(from: item, existing: locations[index])
            }
        case .delete(let id):
            baseLocationsOrigin.removeAll { $0.id == id }
            baseLocationsDestination.removeAll { $0.id == id }
            locations.removeAll { $0.id == id }
        }
    }

    func handleOperador(_ result: TripControlerManageOperator.CallbackType) {
        switch result {
        case .create(let item), .update(let item):
            if let index = operadors.firstIndex(where: { $0.id == item.id }) {
                operadors[index] = item
            } else {
                operadors.append(item)
            }

            operador = item
        case .delete(let id):
            operadors.removeAll { $0.id == id }

            if operador?.id == id {
                operador = nil
            }
        }
    }

    func handleVehical(_ result: TripControlerManageVehical.CallbackType) {
        switch result {
        case .create(let item), .update(let item):
            if let index = vehicals.firstIndex(where: { $0.id == item.id }) {
                vehicals[index] = item
            } else {
                vehicals.append(item)
            }

            vehical = item
            requierTrailer = item.requierTrailer

            if !item.requierTrailer {
                trailerOne = nil
                trailerTwo = nil
            }
        case .delete(let id):
            vehicals.removeAll { $0.id == id }

            if vehical?.id == id {
                vehical = nil
                trailerOne = nil
                trailerTwo = nil
            }
        }
    }

    func handlePermit(_ result: TripControlerManagePermit.CallbackType) {
        switch result {
        case .create(let item), .update(let item):
            if let index = permits.firstIndex(where: { $0.id == item.id }) {
                permits[index] = item
            } else {
                permits.append(item)
            }

            permit = item
        case .delete(let id):
            permits.removeAll { $0.id == id }

            if permit?.id == id {
                permit = nil
            }
        }
    }

    func handleInsurance(
        _ result: TripControlerManageInsurance.CallbackType,
        selectedType: ComertialTripInsuranceType
    ) {
        switch result {
        case .create(let item), .update(let item):
            if let index = insurances.firstIndex(where: { $0.id == item.id }) {
                insurances[index] = item
            } else {
                insurances.append(item)
            }

            switch selectedType {
            case .civil:
                civilInsurance = item
            case .ambient:
                ambientInsurance = item
            case .payload:
                payloadInsurance = item
            }
        case .delete(let id):
            insurances.removeAll { $0.id == id }

            if civilInsurance?.id == id {
                civilInsurance = nil
            }

            if ambientInsurance?.id == id {
                ambientInsurance = nil
            }

            if payloadInsurance?.id == id {
                payloadInsurance = nil
            }
        }
    }

    func handleTrailer(
        _ result: TripControlerManageTrailer.CallbackType,
        placement: TrailerPlacement?
    ) {
        switch result {
        case .create(let item), .update(let item):
            if let index = trailers.firstIndex(where: { $0.id == item.id }) {
                trailers[index] = item
            } else {
                trailers.append(item)
            }

            switch placement {
            case .one:
                trailerOne = item
            case .two:
                trailerTwo = item
            case nil:
                if trailerOne?.id == item.id {
                    trailerOne = item
                }

                if trailerTwo?.id == item.id {
                    trailerTwo = item
                }
            }
        case .delete(let id):
            trailers.removeAll { $0.id == id }

            if trailerOne?.id == id {
                trailerOne = nil
            }

            if trailerTwo?.id == id {
                trailerTwo = nil
            }
        }
    }

    func selectOperador() {
        addToDom(TripControlerAddElement(
            title: "Seleccione Operador",
            items: operadors, 
            titleForItem: { "\($0.operadorType.description): \($0.operadorName)" },
            subtitleForItem: { "RFC \($0.operadorRfc) | Licencia \($0.operadorLicens) | Tel. \($0.operadorMobile)" },
            callback: { item in
                
                self.operador = item

                if self.vehical == nil {
                    Dispatch.asyncAfter(0.2) {
                        self.selectVehical()
                    }
                }
            },
            create: {
                self.manageOperador()
            }
        ))
    }

    func selectVehical() {
        addToDom(TripControlerAddElement(
            title: "Seleccione Vehiculo",
            items: vehicals,
            titleForItem: { "\($0.vehicalTypeName) \($0.vehicalType)" },
            subtitleForItem: { "Placas \($0.vehicalLicensePlate) | Modelo \($0.vehicalYearModel) | Peso \($0.vehicalWeight)" },
            callback: { item in

                self.vehical = item
                self.requierTrailer = item.requierTrailer

                if !item.requierTrailer {
                    self.trailerOne = nil
                    self.trailerTwo = nil
                }

                if self.permit == nil {
                    Dispatch.asyncAfter(0.2) {
                        self.selectPermit()
                    }
                }

            },
            create: {
                self.manageVehical()
            }
        ))
    }

    func selectPermit() {
        addToDom(TripControlerAddElement(
            title: "Seleccione Permiso",
            items: permits,
            titleForItem: { $0.permitTypeName },
            subtitleForItem: { "Permiso \($0.permitTypeName) \($0.permitNumber)" },
            callback: { item in

                self.permit = item

                if
                self.civilInsurance == nil &&
                self.ambientInsurance == nil &&
                self.payloadInsurance == nil
                {
                    Dispatch.asyncAfter(0.2) {
                        self.selectInsurance(.civil)
                    }
                }
            },
            create: {
                self.managePermit()
            }
        ))
    }

    func selectInsurance(_ type: ComertialTripInsuranceType) {
        addToDom(TripControlerAddElement(
            title: "Seleccione Polisa \(type.description)",
            items: insurances.filter { $0.type == type },
            titleForItem: { $0.provider },
            subtitleForItem: { "Polisa \($0.policyNumber) | Monto \($0.insuredAmount)" },
            callback: { item in
                switch type {
                case .civil:
                    self.civilInsurance = item
                case .ambient:
                    self.ambientInsurance = item
                case .payload:
                    self.payloadInsurance = item
                }

                if self.requierTrailer && self.trailerOne == nil {
                    self.selectTrailer(.one)
                }

            },
            create: {
                self.manageInsurance(type)
            }
        ))
    }

    func selectTrailer(_ placement: TrailerPlacement) {
        addToDom(TripControlerAddElement(
            title: placement == .one ? "Seleccione Remolque 1" : "Seleccione Remolque 2",
            items: trailers,
            titleForItem: { $0.name },
            subtitleForItem: { "\($0.type.description) | Series \($0.series)" },
            callback: { item in
                switch placement {
                case .one:
                    self.trailerOne = item
                case .two:
                    self.trailerTwo = item
                }
            },
            create: {
                self.manageTrailer(placement: placement)
            }
        ))
    }

    func addDestination() {

        if locations.isEmpty {
            addToDom(TripControlerAddElement(
                title: "Agergar Origen",
                items: baseLocationsOrigin, 
                titleForItem: { "\($0.placementId) \($0.storeName)" },
                subtitleForItem: { "\($0.colonie) \($0.state)" },
                callback: { item in
                    
                    self.configureLocation(item)


                },
                create: {
                    self.manageDestination()
                }
            ))
        }
        else {
            addToDom(TripControlerAddElement(
                title: "Agergar Destino",
                items: baseLocationsDestination, 
                titleForItem: { "\($0.placementId) \($0.storeName)" },
                subtitleForItem: { "\($0.colonie) \($0.state)" },
                callback: { item in
                    self.configureLocation(item)
                },
                create: {
                    self.manageDestination()
                }
            )) 
        }

    }

    func addMerchendise() {
        guard locations.contains(where: { $0.placementType == .origen }),
              locations.contains(where: { $0.placementType == .destino }) else {
            showError(.requiredField, "Agregue Origen y Destino antes de agregar mercancia")
            return
        }

        

        addToDom(TripControlerAddElement(
            title: "Seleccione Mercancia",
            items: merchendises, 
            titleForItem: { "\($0.fiscCode) \($0.description)" },
            subtitleForItem: { "Unidad \($0.fiscUnitName) | Peso \($0.kilograms.fromCents.toString) kg" },
            callback: { item in
                self.configureMerchendise(item)
            },
            create: {
                self.manageMerchendise()
            }
        ))
    }

    func createTrip() {

        guard let operador else {
            showError(.requiredField, "Seleccione operador")
            return
        }

        guard let vehical else {
            showError(.requiredField, "Seleccione vehiculo")
            return
        }

        guard let permit else {
            showError(.requiredField, "Seleccione permiso")
            return
        }

        if requierTrailer && trailerOne == nil && trailerTwo == nil {
            showError(.requiredField, "Seleccione por lo menos un remolque")
            return
        }

        guard let balance = Double(balance)?.toCents else {
            showError(.requiredField, "Ingrese costo de viaje")
            return
        }

        let odometerInitialValue: Int64?
        if odometerInitial.purgeSpaces.isEmpty {
            odometerInitialValue = nil
        }
        else if let value = Int64(odometerInitial.purgeSpaces), value >= 0 {
            odometerInitialValue = value
        }
        else {
            showError(.invalidFormat, "El odómetro inicial debe ser un número entero válido")
            return
        }

        let odometerFinalValue: Int64?
        if odometerFinal.purgeSpaces.isEmpty {
            odometerFinalValue = nil
        }
        else if let value = Int64(odometerFinal.purgeSpaces), value >= 0 {
            odometerFinalValue = value
        }
        else {
            showError(.invalidFormat, "El odómetro final debe ser un número entero válido")
            return
        }

        if let odometerInitialValue,
           let odometerFinalValue,
           odometerFinalValue < odometerInitialValue {
            showError(.invalidFormat, "El odómetro final no puede ser menor al inicial")
            return
        }

        guard locations.contains(where: { $0.placementType == .origen }),
              locations.contains(where: { $0.placementType == .destino }) else {
            showError(.requiredField, "Agregue Origen y Destino")
            return
        }

        guard !merchendise.isEmpty else {
            showError(.requiredField, "Agregue por lo menos una mercancia")
            return
        }

        if let trailerOne, let trailerTwo, trailerOne.id == trailerTwo.id {
            showError(.requiredField, "Seleccione remolques diferentes")
            return
        }

        let hasDangerousMaterial = merchendise.contains {
            $0.isDangerousMatirial == .si
        }

        let trailerIds = [trailerOne?.id, trailerTwo?.id].compactMap { $0 }

        let tripLocations = locations.map {
            CustCommercialTripsComponents.TripLocation(
                locationId: $0.id,
                distance: $0.distance
            )
        }

        let tripMerchandise = merchendise.map {
            CustCommercialTripsComponents.TripMerchandise(
                merchandiseId: $0.id,
                from: $0.from,
                fromStoreName: $0.fromStoreName,
                to: $0.to,
                toStoreName: $0.toStoreName
            )
        }

        loadingView(show: true)

        API.custCommercialTrips.createTrip(
            accountId: account.id,
            operadorId: operador.id,
            vehicalId: vehical.id,
            permitId: permit.id,
            hasDangerousMaterial: hasDangerousMaterial,
            insuranceCivilId: civilInsurance?.id,
            insuranceAmbientId: ambientInsurance?.id,
            insurancePayloadId: payloadInsurance?.id,
            remolques: trailerIds,
            locations: tripLocations,
            merchandise: tripMerchandise,
            balance: balance,
            odometerInitial: odometerInitialValue,
            odometerFinal: odometerFinalValue
        ) { resp in
            loadingView(show: false)

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
            

            self.callback(payload)
            showSuccess(.operacionExitosa, "Viaje creado")
            self.remove()
        }

    }

}
