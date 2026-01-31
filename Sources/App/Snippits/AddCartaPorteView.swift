//
//  AddCartaPorteView.swift
//  
//
//  Created by Victor Cantu on 1/10/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddCartaPorteView: Div {
    
    override class var name: String { "div" }
    
    @State var cartaPorte: FiscalCartaPorte?
    
    var loadHistory: Bool
    
    private var callback: ((
        _ cartaPorte: FiscalCartaPorte?
    ) -> ())
    
    
    init(
        cartaPorte: FiscalCartaPorte?,
        loadHistory: Bool,
        callback: @escaping ((
            _ cartaPorte: FiscalCartaPorte?
        ) -> ())
    ) {
        self.cartaPorte = cartaPorte
        self.loadHistory = loadHistory
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // TipoOperador
    
    /// Operador  ``FiguraTransporte``
    /// TipoOperador
    @State var operadorType = ""
    
    /// `NombreFigura`
    /// Atributo requerido para registrar el nombre de la figura de transporte que interviene en el traslado de los bienes y/o mercancías.
    public var operadorName = ""
    
    /// RFCFigura
    @State var operadorRfc = ""
    
    /// NumLicencia
    @State var operadorLicens = ""
    
    lazy var operadorTypeSelect = Select(self.$operadorType)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var operadorLicensField = InputText(self.$operadorLicens)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Licencia Operador")
        .height(31.px)
    
    /// Vehiculo ``IdentificacionVehicular``
    /// `ConfigVehicular`
    var vehicalType = ""
    
    var vehicalTypeName = ""
    
    @State var vehicalWeight = "0"
    
    /// `PlacaVM`
    @State var vehicalLicensePlate = ""
    /// `AnioModeloVM`
    @State var vehicalYearModel = ""
    
    /// PermSCT
    /// TipoPermiso
    @State var permitType = ""
    
    /// NumPermisoSCT
    @State var permitNumber = ""
    
    lazy var vehicalTypeField = FiscAutotrasportTypeField(style: .dark, type: .product) { code in
        
        print("⭐️  vehicalTypeField  ⭐️")
        print(code)
        self.vehicalType = code.c
        self.vehicalTypeName = code.v
        
        if let remolqueRequierd = code.t {
            self.remolqueRequierd = remolqueRequierd
            self.remolqueView = .primerRemolque
        }
        else{
            self.remolqueRequierd = false
            self.remolqueView = nil
        }
        
    }
    
    lazy var vehicalLicensePlateField = InputText(self.$vehicalLicensePlate)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Placas")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    lazy var vehicalYearModelField = InputText(self.$vehicalYearModel)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("2004")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    lazy var vehicalWeightField = InputText(self.$vehicalWeight)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("2004")
        .height(31.px)
        .onFocus({ tf in
            tf.select()
        })
    
    lazy var permitTypeSelect = Select(self.$permitType)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var permitNumberField = InputText(self.$permitNumber)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("# Permiso")
        .height(31.px)
    
    /// Seguro ``AseguraRespCivil``
    
    @State var hasDangerousMatirial: Bool = false
    
    /// Name of ashurance company `AseguraRespCivil`
    @State var insuranceCivilProvider = ""
    
    /// Number of plocy `PolizaRespCivil`
    @State var insuranceCivilNumber = ""
    
    /// Name of ashurance company `AseguraMedAmbiente`
    @State var insuranceAmbinetProvider = ""
    
    /// Number of plocy `PolizaMedAmbiente`
    @State var insuranceAmbinetNumber = ""
    
    /// Name of ashurance company `AseguraCarga`
    @State var insurancePayloadProvider = ""
    
    /// Number of plocy `PolizaCarga`
    @State var insurancePayloadNumber = ""
    
    /// Amount of insurace `PrimaSeguro`
    @State var insuranceAmount = "0"
    
    lazy var insuranceCivilProviderField = InputText(self.$insuranceCivilProvider)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Proveedor Poliza Civil")
        .height(31.px)
    
    lazy var insuranceCivilNumberField = InputText(self.$insuranceCivilNumber)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Numero Poliza Civil")
        .height(31.px)
    
    lazy var insuranceAmbinetProviderField = InputText(self.$insuranceAmbinetProvider)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Provedor Piliza Ambental")
        .height(31.px)
    
    lazy var insuranceAmbinetNumberField = InputText(self.$insuranceAmbinetNumber)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Numero Piliza Ambental")
        .height(31.px)
    
    lazy var insurancePayloadProviderField = InputText(self.$insurancePayloadProvider)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Provedor Piliza Carga")
        .height(31.px)
    
    lazy var insurancePayloadNumberField = InputText(self.$insurancePayloadNumber)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Numero Piliza Carga")
        .height(31.px)
    
    lazy var insuranceAmountField = InputText(self.$insuranceAmount)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Monto Asegurado")
        .height(31.px)
    
    /// ``Remolques`` TipoRemolque

    @State var remolqueRequierd: Bool = false
    
    @State var tipoRemolqueA = ""
    
    @State var plcacasRemolqueA = ""
    
    @State var tipoRemolqueB = ""
    
    @State var plcacasRemolqueB = ""
    
    @State var remolqueView: RemolqueView? = nil
    
    lazy var tipoRemolqueASelect = Select(self.$tipoRemolqueA)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var plcacasRemolqueAField = InputText(self.$plcacasRemolqueA)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("# de placas")
        .height(31.px)
    
    lazy var tipoRemolqueBSelect = Select(self.$tipoRemolqueB)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var plcacasRemolqueBField = InputText(self.$plcacasRemolqueB)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("# de placas")
        .height(31.px)
    
    /// `Informacion General`
    @State var locations: [CartaPorteUbicacion] = []

    @State var merchandise: [FiscalMercanciaItem] = []
    
    lazy var merchandiseGrid = Div() {
        
    }
    .custom("height", "calc(100% - 40px)")
    .padding(all: 3.px)
    .margin(all: 3.px)
    .class(.roundBlue)
    .overflow(.auto)
    
    lazy var destinationGrid = Div() {
        
    }
    .custom("height", "calc(100% - 40px)")
    .padding(all: 3.px)
    .margin(all: 3.px)
    .class(.roundBlue)
    .overflow(.auto)
    
    lazy var remolqueDiv = Div {
        
        Div{
            
            Span("Remolque 1")
                .color(self.$remolqueView.map({ ($0 == .primerRemolque) ? .lightBlueText : .white }))
                .marginRight(7.px)
                .cursor(.pointer)
                .onClick {
                    self.remolqueView = .primerRemolque
                }
            
            Span("Remolque 2")
                .color(self.$remolqueView.map({ ($0 == .segundoRemolque) ? .lightBlueText : .white }))
                .cursor(.pointer)
                .onClick {
                    self.remolqueView = .segundoRemolque
                }
        }
        
        Div{
            
            Div{
                Label("Tipo de Remolque")
                    .color(.white)
                
                Div{
                    self.tipoRemolqueASelect
                }
            }
            .class(.section)

            Div().class(.clear)
            
            Div{
                Label("Placas Remolque")
                    .color(.white)
                
                Div{
                    self.plcacasRemolqueAField
                }
            }
            .class(.section)
        }
        .hidden(self.$remolqueView.map{ $0 != .primerRemolque })
        
        Div{
            
            Div{
                Label("Tipo de Remolque")
                    .color(.white)
                
                Div{
                    self.tipoRemolqueBSelect
                }
            }
            .class(.section)

            Div().class(.clear)
            
            Div{
                Label("Placas Remolque")
                    .color(.white)
                
                Div{
                    self.plcacasRemolqueBField
                }
            }
            .class(.section)
        }
        .hidden(self.$remolqueView.map{ $0 != .segundoRemolque })
        
    }
        .hidden( self.$remolqueRequierd.map({ !$0 }) )

    lazy var merchDiv = Div {
        Div{
            
            Img()
                .float(.right)
                .cursor(.pointer)
                .src("/skyline/media/add.png")
                .height(18.px)
                .padding(all: 3.px)
                .paddingRight(0.px)
                .marginRight(7.px)
                .onClick {
                    self.addMerchandise()
                }
            
            H2("Mercancia a trasladar")
                .marginBottom(3.px)
                .color(.white)
        }
        
        self.merchandiseGrid
    }
    .custom("height","calc(100% - 290px)")
    .width(50.percent)
    .float(.left)
    
    lazy var locatiosDiv = Div {
        Div{
            
            Img()
                .float(.right)
                .cursor(.pointer)
                .src("/skyline/media/add.png")
                .height(18.px)
                .padding(all: 3.px)
                .marginRight(7.px)
                .align(.right)
                .onClick {
                    self.addLocations()
                }
            
            H2("Destinos")
                .marginBottom(3.px)
                .color(.white)
            
        }
        
        self.destinationGrid
    }
    .custom("height","calc(100% - 290px)")
    .width(50.percent)
    .float(.left)
    
    lazy var operadorRfcField = FiscOperatorField { name, rfc, licence in
        self.operadorName = name
        self.operadorRfc = rfc
        self.operadorLicens = licence
    }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agregar Carta Porte")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
            
            /// General container
            Div{
                
                /// Transportistas
                Div {
                    H3("Operador")
                        .color(.lightBlueText)
                        .marginBottom(3.px)
                    
                    Label("Tipo de Operador")
                        .marginBottom(3.px)
                    self.operadorTypeSelect
                        .marginBottom(3.px)
                    
                    Div{
                        
                        Img()
                            .float(.right)
                            .cursor(.pointer)
                            .src("/skyline/media/add.png")
                            .height(18.px)
                            .padding(all: 3.px)
                            .paddingRight(0.px)
                            .marginRight(7.px)
                            .onClick {
                                self.addOperator()
                            }
                        
                        Label("RFC del Operador")
                            .marginBottom(3.px)
                    }
                    
                    self.operadorRfcField
                        .marginBottom(3.px)
                    
                    Label("Licencia del Operador")
                        .marginBottom(3.px)
                    
                    self.operadorLicensField
                        .marginBottom(3.px)
                        .disabled(true)
                }
                .width(20.percent)
                .color(.white)
                .float(.left)
                
                /// Autotransporte
                Div {
                    
                    H3("Vehiculo")
                        .color(.lightBlueText)
                        .marginBottom(3.px)
                    
                    Label("Tipo de Vehiculo")
                        .marginBottom(3.px)
                    
                    self.vehicalTypeField
                        .marginBottom(3.px)
                    
                    Div{
                        Label("Placas/ Modelo de Vehiculo")
                            .marginBottom(3.px)
                        
                        Div().class(.clear)
                        
                        Div {
                            self.vehicalLicensePlateField
                                .marginBottom(3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div {
                            self.vehicalYearModelField
                                .marginBottom(3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    
                    Div{
                        Label("Tipo y Numero de Permiso")
                            .marginBottom(3.px)
                        
                        Div().class(.clear)
                        
                        Div{
                            self.permitTypeSelect
                                .marginBottom(3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.permitNumberField
                                .marginBottom(3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div{
                        Label("Peso (T)")
                            .marginBottom(3.px)
                        
                        Div().class(.clear)
                        
                        Div {
                            self.vehicalWeightField
                                .marginBottom(3.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div {
                            
                        }
                        .width(50.percent)
                        .height(35.px)
                        .float(.left)
                        
                        Div().class(.clear)
                    }
                    
                    
                }
                .width(20.percent)
                .color(.white)
                .float(.left)
                
                /// Polisa Vehicular
                Div {
                    
                    H3("Polisas de seguro")
                        .color(.lightBlueText)
                        .marginBottom(3.px)
                    
                    Div{
                        Label("Civil, Proveedor")
                            .color(.white)
                        
                        Div{
                            self.insuranceCivilProviderField
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear)
                    
                    Div{
                        Label("Civil, Numero")
                            .color(.white)
                        
                        Div{
                            self.insuranceCivilNumberField
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear)
                    
                    Div{
                        Label("Ambiental, Proveedor")
                            .color(.white)
                        
                        Div{
                            self.insuranceAmbinetProviderField
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear)
                    
                    Div{
                        Label("Ambiental, Numero")
                            .color(.white)
                        
                        Div{
                            self.insuranceAmbinetNumberField
                        }
                    }
                    .class(.section)
                                        
                }
                .width(30.percent)
                .color(.white)
                .float(.left)
                
                /// Polisa Ambinetal
                Div {
                    
                    Div()
                        .marginBottom(3.px)
                        .height(23.px)
                    
                    Div{
                        Label("Carga, Proveedor")
                            .color(.white)
                        
                        Div{
                            self.insurancePayloadProviderField
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear)
                    
                    Div{
                        Label("Carga, Numero")
                            .color(.white)
                        
                        Div{
                            self.insurancePayloadNumberField
                        }
                    }
                    .class(.section)

                    Div().class(.clear)
                    
                    self.remolqueDiv
                    
                    Div().class(.clear)
                    
                }
                .width(30.percent)
                .color(.white)
                .float(.left)
                
                Div().class(.clear)
            }
            .height(200.px)
            
            Div().class(.clear)
            
            /// Merch
            self.merchDiv
            
            /// Places
            self.locatiosDiv
            
            Div().class(.clear)
            
            Div {
                
                Div("Eliminar Carta Porte")
                    .class(.uibtnLarge)
                    .marginRight(12.px)
                    .marginTop(0.px)
                    .float(.left)
                    .onClick {
                        addToDom(ConfirmView(type: .yesNo, title: "Elimiar Carta Porte", message: "Confirme eliminacion de carta porte. Esta accion no se puede deshacer", callback: { isConfirmed, comment in
                            if isConfirmed {
                                self.callback(nil)
                                self.remove()
                            }
                        }))
                    }
                    .hidden(self.$cartaPorte.map{ ($0 == nil) })
                
                Div {
                    
                    Img()
                        .src("/skyline/media/history_color.png" )
                        .marginRight(3.px)
                        .marginLeft(3.px)
                        .height(18.px)
                    
                    Span("Historicas")
                    
                }
                .class(.uibtnLarge)
                .marginTop(0.px)
                .float(.left)
                .onClick {
                    self.loadHistorical()
                }
                
                Div(self.$cartaPorte.map{ ($0 == nil) ? "Agergar Carta Porte" : "Guardar Carta Porte" })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addCartaPorte()
                    }
            }
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .width(95.percent)
        .left(2.5.percent)
        .top(10.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        $merchandise.listen {
            
            self.hasDangerousMatirial = false
            
            self.merchandiseGrid.innerHTML = ""
            
            $0.forEach { merchadise in
                
                let view = CartaPorteMerchendise(merchadise: merchadise) { id in
                    
                    var _merchandise: [FiscalMercanciaItem] = []
                 
                    self.merchandise.forEach { item in
                        if item.id == id {
                            return
                        }
                        _merchandise.append(item)
                    }
                    
                    self.merchandise = _merchandise
                    
                }
                
                self.merchandiseGrid.appendChild(view)
                
                if merchadise.isDangerousMatirial == .si {
                    self.hasDangerousMatirial = true
                }
                
            }
            
        }
        
        vehicalTypeField.fiscUnitField.height(31.px)
        
        operadorType = TipoOperador.operador.rawValue
        
        TipoOperador.allCases.forEach { type in
            operadorTypeSelect.appendChild(Option(type.description)
                .value(type.rawValue))
        }
        
        permitTypeSelect.appendChild(Option("Seleccione")
            .value(""))
        
        TipoPermiso.allCases.forEach { type in
            permitTypeSelect.appendChild(Option(type.description)
                .value(type.rawValue))
        }
        
        tipoRemolqueASelect.appendChild(Option("Seleccione")
            .value(""))
        
        tipoRemolqueBSelect.appendChild(Option("Seleccione")
            .value(""))
        
        TipoRemolque.allCases.forEach { type in
            
            tipoRemolqueASelect.appendChild(Option(type.description)
                .value(type.rawValue))
            
            tipoRemolqueBSelect.appendChild(Option(type.description)
                .value(type.rawValue))
            
        }
        
        $remolqueRequierd.listen {
            if $0 {
                self.merchDiv
                    .custom("height","calc(100% - 307px)")
                
                self.locatiosDiv
                    .custom("height","calc(100% - 307px)")
            }
            else {
                self.merchDiv
                    .custom("height","calc(100% - 290px)")
                
                self.locatiosDiv
                    .custom("height","calc(100% - 290px)")
            }
        }
        
        loadCartaPorte()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        if cartaPorte == nil {
            
            if loadHistory {
                self.loadHistorical()
            }
            else{
                
                addToDom(AddCartaPorteUbicacion(currentPlacementCount: self.locations.count){ location  in
                    self.addLocation(location)
                })
                
            }
        }
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func loadCartaPorte(){
        
        guard let cartaPorte else {
            return
        }
        
        merchandise = cartaPorte.merchandise
        
        cartaPorte.locations.forEach { placement in
            
            let view = CartaPorteUbicacion(placement: placement) { id in
                
                print("❌ 001")
                
                var _locations: [CartaPorteUbicacion] = []
                
                self.locations.forEach { location in
                    
                    print(location.placement.id.uuidString + " VS " + id.uuidString)
                    
                    if location.placement.id == id {
                        return
                    }
                    _locations.append(location)
                }
                
                self.locations = _locations
                
                self.reloadDestinations()
                
            }
            
            locations.append(view)
            
            destinationGrid.appendChild(view)
        }
        
        operadorType = cartaPorte.operadorType.rawValue
        
        operadorRfcField.term = "\(cartaPorte.operadorRfc) \(cartaPorte.operadorName)"
        
        operadorName = cartaPorte.operadorName
        
        operadorRfc = cartaPorte.operadorRfc
        
        operadorLicens = cartaPorte.operadorLicens
        
        vehicalType = cartaPorte.vehicalType
        
        vehicalTypeName = cartaPorte.vehicalTypeName
        
        vehicalTypeField.fiscUnitField.class(.isOk)
        
        vehicalTypeField.fiscUnitField.text = "\(vehicalType) \(vehicalTypeName)"
        
        vehicalTypeField.currentCode = vehicalType
        
        vehicalLicensePlate = cartaPorte.vehicalLicensePlate
        
        vehicalYearModel = cartaPorte.vehicalYearModel
        
        vehicalWeight = cartaPorte.vehicalWeight.toString
        
        permitType = cartaPorte.permitType.rawValue
        
        permitNumber = cartaPorte.permitNumber
        
        insuranceCivilProvider = cartaPorte.insuranceCivilProvider
        
        insuranceCivilNumber = cartaPorte.insuranceCivilNumber
        
        insuranceAmbinetProvider = cartaPorte.insuranceAmbinetProvider
        
        insuranceAmbinetNumber = cartaPorte.insuranceAmbinetNumber
        
        insurancePayloadProvider = cartaPorte.insurancePayloadProvider
        
        insurancePayloadNumber = cartaPorte.insurancePayloadNumber
        
        insuranceAmount = cartaPorte.insuranceAmount.formatMoney
        
        if cartaPorte.remolques.count > 0 {
            
            remolqueRequierd = true
            
            remolqueView = .primerRemolque
            
            if cartaPorte.remolques.count == 1 {
                if let remolque = cartaPorte.remolques.first {
                    tipoRemolqueA = remolque.type.rawValue
                    plcacasRemolqueA = remolque.licensPlates
                }
            }
            else if cartaPorte.remolques.count == 2 {
                if let remolque = cartaPorte.remolques.first {
                    tipoRemolqueA = remolque.type.rawValue
                    plcacasRemolqueA = remolque.licensPlates
                }
                if let remolque = cartaPorte.remolques.last {
                    tipoRemolqueB = remolque.type.rawValue
                    plcacasRemolqueB = remolque.licensPlates
                }
            }
               
        }
        
    }
    
    func reloadDestinations() {
        
        destinationGrid.innerHTML = ""
        
        locations.forEach { view in
            destinationGrid.appendChild(view)
        }
        
    }
    
    func loadHistorical() {
        
        loadingView(show: true)
        
        API.fiscalV1.getCartaPorteHistory { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            let view = AddCartaPorteFromHistoryView(cartaPortes: data) { cartaPorte in
                
                self.cartaPorte = cartaPorte
                
                self.callback(cartaPorte)
                
                self.loadCartaPorte()
                
            }
            
            addToDom(view)
        }
    }
    
    func addOperator () {
        
        let view = CartaPorteOperator { `operator` in
            self.operadorRfcField.operators.append(`operator`)
            self.operadorRfcField.addCodeResult(operator:  `operator`)
            self.operadorName = `operator`.name
            self.operadorRfc = `operator`.rfc
            self.operadorLicens = `operator`.licence
        }
        
        addToDom(view)
        
    }
    
    
    func addLocation (_ location: FiscalLocationItem) {
        let view = CartaPorteUbicacion(placement: location) { id in
            
            print("❌ 002")
            
            var _locations: [CartaPorteUbicacion] = []
            
            self.locations.forEach { location in
                
                if location.placement.id == id {
                    return
                }
                
                _locations.append(location)
                
            }
            
            self.locations = _locations
            
            self.reloadDestinations()
            
        }
        locations.append(view)
        destinationGrid.appendChild(view)
    }
    
    func addLocations (){
        addToDom(AddCartaPorteUbicacion(currentPlacementCount: self.locations.count){ location in
            self.addLocation(location)
        })
    }
    
    func addMerchandise(){
        
        guard self.locations.count > 1 else {
            addToDom(ConfirmView(type: .ok, title: "Ubicaciones Requeridas", message: "Primero agregue ubicación de salida y llegada.", callback: { _ , _ in
                self.addLocations()
            }))
            return
        }
        
        addToDom(AddCartaPorteMerchendise(
            locations: self.locations,
            merchandise: nil,
            callback: { merchandise in
            
            print("🟢   merchandise   🟢")
            print(merchandise)
            
            self.merchandise.append(merchandise)
        }))
    }
    
    func addCartaPorte(){
        
        if merchandise.isEmpty {
            showError(.generalError, "Agrege mercancia")
            addMerchandise()
            return
        }
        
        if locations.count < 2 {
            showError(.generalError, "Agregue ubicaciones.")
            addLocations()
            return
        }
        
        guard let _operadorType = TipoOperador(rawValue: operadorType) else {
            showError(.generalError, "Seleccione tipo de operador")
            return
        }
        
        guard !operadorName.isEmpty else {
            operadorRfcField.codeField.select()
            showError(.generalError, "Ingrese Nombre del Operador")
            return
        }
        
        guard !operadorRfc.isEmpty else {
            operadorRfcField.codeField.select()
            showError(.generalError, "Ingrese RFC del Operador")
            return
        }
        
        guard !operadorLicens.isEmpty else {
            operadorLicensField.select()
            showError(.generalError, "Ingrese Nombre/Razon del Operador")
            return
        }
        
        guard !vehicalType.isEmpty else {
            showError(.generalError, "Seleccione tipo de vehiculo")
            vehicalTypeField.fiscUnitField.select()
            return
        }
        
        guard !vehicalLicensePlate.isEmpty else {
            showError(.generalError, "Ingrese placas del vehiculo")
            vehicalLicensePlateField.select()
            return
        }
        
        guard !vehicalYearModel.isEmpty else {
            showError(.generalError, "Ingrese Año (modelo) del vehiculo")
            vehicalYearModelField.select()
            return
        }
        
        guard let _ = Int(vehicalYearModel) else {
            showError(.generalError, "Ingrese Año (modelo) valido del vehiculo")
            vehicalYearModelField.select()
            return
        }
        
        guard vehicalYearModel.count == 4 else {
            showError(.generalError, "Ingrese Año (modelo) valido del vehiculo")
            vehicalYearModelField.select()
            return
        }
        
        guard let vehicalWeight = Double(vehicalWeight) else {
            showError(.generalError, "Ingrese Año (modelo) valido del vehiculo")
            vehicalYearModelField.select()
            return
        }
        
        
        guard let _permitType = TipoPermiso(rawValue: permitType) else {
            showError(.generalError, "Seleccione tipo de permiso")
            return
        }
        
        guard !permitNumber.isEmpty else {
            showError(.generalError, "Ingrese numero de permiso")
            permitNumberField.select()
            return
        }
        
        var remolques: [FiscalRemolque] = []
        
        if let _tipoRemolqueA = TipoRemolque(rawValue: tipoRemolqueA) {
            
            if plcacasRemolqueA.isEmpty {
                showError(.generalError, "Ingrese placas del remolque A")
                plcacasRemolqueAField.select()
                return
            }
            
            remolques.append(FiscalRemolque(
                type: _tipoRemolqueA,
                name: _tipoRemolqueA.description,
                licensPlates: plcacasRemolqueA
            ))
            
        }
        
        if let _tipoRemolqueB = TipoRemolque(rawValue: tipoRemolqueB) {
            
            if plcacasRemolqueB.isEmpty {
                showError(.generalError, "Ingrese placas del remolque B")
                plcacasRemolqueBField.select()
                return
            }
            
            remolques.append(FiscalRemolque(
                type: _tipoRemolqueB,
                name: _tipoRemolqueB.description,
                licensPlates: plcacasRemolqueB
            ))
        }
        
        if remolqueRequierd && remolques.isEmpty {
            showError(.requiredField, "Para el tipo de vehiculo: \(vehicalType.description.uppercased()) se requiere que ingrese por lo menos un remolque.")
            return
        }
        
        
        if hasDangerousMatirial {
            
            if insuranceAmbinetProvider.isEmpty {
                showError(.generalError, "Poliza ambinetal requerida con Material Peligroso")
                insuranceAmbinetProviderField.select()
                return
            }
            
            if insuranceAmbinetNumber.isEmpty {
                insuranceAmbinetNumberField.select()
                return
            }
            
        }
        
        callback(.init(
            operadorType: _operadorType,
            operadorName: operadorName,
            operadorRfc: operadorRfc.purgeSpaces.pseudo.uppercased(),
            operadorLicens: operadorLicens.uppercased(),
            vehicalType: vehicalType,
            vehicalTypeName: vehicalTypeName,
            vehicalLicensePlate: vehicalLicensePlate,
            vehicalYearModel: vehicalYearModel, 
            vehicalWeight: vehicalWeight,
            permitType: _permitType,
            permitTypeName: _permitType.description,
            permitNumber: permitNumber,
            hasDangerousMatirial: hasDangerousMatirial,
            insuranceCivilProvider: insuranceCivilProvider,
            insuranceCivilNumber: insuranceCivilNumber,
            insuranceAmbinetProvider: insuranceAmbinetProvider,
            insuranceAmbinetNumber: insuranceAmbinetNumber,
            insurancePayloadProvider: insurancePayloadProvider,
            insurancePayloadNumber: insurancePayloadNumber,
            insuranceAmount: 0,
            remolques: remolques,
            locations: locations.map{ $0.placement },
            merchandise: merchandise
        ))
        
        self.remove()
        
    }
    
}

extension AddCartaPorteView {
    
    public enum RemolqueView: String {
        case primerRemolque
        case segundoRemolque
    }
    
}




