//
//  AddCartaPorteMerchendise.swift
//  
//
//  Created by Victor Cantu on 1/12/23.
//

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class AddCartaPorteMerchendise: Div {
    
    override class var name: String { "div" }
    
    var locations: [CartaPorteUbicacion]
    
    var merchandise: FiscalMercanciaItem?
    
    private var callback: ((
        _ merchandise: FiscalMercanciaItem
    ) -> ())
    
    init(
        locations: [CartaPorteUbicacion],
        merchandise: FiscalMercanciaItem?,
        callback: @escaping ((
            _ merchandise: FiscalMercanciaItem
        ) -> ())
    ) {
        
        self.locations = locations
        
        self.merchandise = merchandise
        
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// BienesTransp
    var fiscCode: String = ""
    var fiscCodeName: String = ""
    
    /// ClaveUnidad
    var fiscUnit: String = ""
    var fiscUnitName: String = ""
    
    /// Descripcion
    @State var descr: String = ""
    
    /// Cantidad 1.0
    @State var units: String = "0"
    
    ///PesoEnKg 1.0
    @State var kilograms: String = "0"
    
    /// MaterialPeligroso
    /// si, no
    @State var isDangerousMaterial: Bool = false
    @State var isDangerousDisabled: Bool = false
    @State var isDangerousToggleHidden: Bool = true
    @State var isDangerousIsHidden: Bool = true
    
    /// CveMaterialPeligroso
    @State var dangerousMaterialCode: String = ""
    var dangerousMaterialName: String = ""
    
    /// Embalaje
    @State var packagingType: String = ""
    var packagingName: String = ""
    
    /// IDOrigen
    @State var from: String = ""
    var fromId: String = ""
    var fromName: String = ""
    
    /// IDDestino
    @State var to: String = ""
    @State var toId: String = ""
    var toName: String = ""
    
    /// BienesTransp
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: .product) { data in
        
        
        self.fiscCode = data.c
        self.fiscCodeName = data.v
        
        if let dm = data.t {
            
            self.isDangerousDisabled = true
            
            if dm {
                
                self.isDangerousToggleHidden = true
                
                self.isDangerousMaterial = true
                self.isDangerousIsHidden = false
                
            }
            else {
                
                self.isDangerousToggleHidden = true
                
                self.isDangerousMaterial = false
                self.isDangerousIsHidden = true
            }
            
        }
        else{
            ///  can be dangerous
            
            print("⚠️  might be dangerous marirai")
            
            
            self.isDangerousMaterial = false
            
            self.isDangerousDisabled = false
            self.isDangerousToggleHidden = false
            
            self.isDangerousIsHidden = true
            
        }
        
        /*
         
         @State var isDangerousMaterial: Bool = false
         @State var isDangerousDisabled: Bool = false
         @State var isDangerousIsHidden: Bool = true
         */
        
        if let isDangerousMaterial = data.t {
            self.isDangerousMaterial = isDangerousMaterial
        }
        else{
            self.isDangerousMaterial = false
        }
        
    }
    
    /// ClaveUnidad
    lazy var fiscUnitField = FiscUnitPesoField(style: .dark, type: .product) { data in
        self.fiscUnit = data.c
        self.fiscUnitName = data.v
    }
    
    // lazy var isDangerousMaterialToggle = InputCheckbox().toggle(self.$isDangerousMaterial)
    
    lazy var isDangerousMaterialToggle = InputCheckbox().toggle(self.$isDangerousMaterial, self.$isDangerousDisabled) { tooggleState in
       
//        self.isDangerousMaterial = !tooggleState
//        print("⭐️  isDangerousMaterial  ⭐️")
//        print(self.isDangerousMaterial)
        
    }
    
    /// Descripcion
    lazy var descrField = InputText(self.$descr)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Descripcion de la mercancia")
        .height(31.px)
    
    /// Cantidad 1.0
    lazy var unitsField = InputText(self.$units)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .placeholder("Unidades")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .height(31.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    ///PesoEnKg 1.0
    lazy var kilogramsField = InputText(self.$kilograms)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .placeholder("Peso en Kilogramos")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .height(31.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
    
    /// MaterialPeligroso
    /// si, no
    lazy var isDangerousMaterialSelect = Select()
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    /// CveMaterialPeligroso
    lazy var dangerousMaterialCodeField = FiscDangerousMaterialField(style: .dark, type: .product) { data in
        self.dangerousMaterialCode = data.c
        self.dangerousMaterialName = data.v
    }
    
    /// Embalaje
    lazy var packagingTypeField = FiscPackagingField(style: .dark, type: .product) { data in
        self.packagingType = data.c
        self.packagingName = data.v
    }
    
    /// IDOrigen
    lazy var fromField = InputText(self.$from)
        .onFocus({ tf in
            tf.select()
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .disabled(true)
        .height(31.px)
    
    /// IDDestino
    lazy var toSelect = Select(self.$toId)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    /// PermSCT
    /// ``var permitTypeSelect``
    
    @DOM override var body: DOM.Content {
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Agregar Mercancia a Trasladar")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
                Div().class(.clear)
                
            }
           
            Div{
                
                Div("Description")
                    .width(25.percent)
                    .float(.left)
                
                
                Div("Unidades")
                    .width(12.5.percent)
                    .float(.left)
                
                
                Div("Peso (Kilos)")
                    .width(12.5.percent)
                    .float(.left)
                
                
                Div("Origen")
                    .width(25.percent)
                    .float(.left)
                
                Div("Destino")
                    .width(25.percent)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            .color(.white)
            
            Div{
                
                Div{
                    self.descrField
                }
                .width(25.percent)
                .float(.left)
                
                
                Div{
                    self.unitsField
                }
                .width(12.5.percent)
                .float(.left)
                
                
                Div{
                    self.kilogramsField
                }
                .width(12.5.percent)
                .float(.left)
                
                
                Div{
                    self.fromField
                }
                .width(25.percent)
                .float(.left)
                
                Div{
                    self.toSelect
                }
                .width(25.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            
            Div{
                
                Div("Unidad Fiscal")
                    .width(21.25.percent)
                    .float(.left)
                
                Div("Codigo Fiscal")
                    .width(21.25.percent)
                    .float(.left)
                
                Div("Material Peligoso")
                    .hidden(self.$isDangerousToggleHidden)
                    .width(15.percent)
                    .float(.left)
                
                Div("Clave M. P.")
                    .hidden(self.$isDangerousMaterial.map{ !$0 })
                    .width(21.25.percent)
                    .float(.left)
                
                Div("Tipo Embalaje")
                    .hidden(self.$isDangerousMaterial.map{ !$0 })
                    .width(21.25.percent)
                    .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            .color(.white)
            
            Div{
                
                Div{
                    self.fiscUnitField
                        .width(95.percent)
                }
                .width(21.25.percent)
                .float(.left)
                
                Div{
                    self.fiscCodeField
                        .width(95.percent)
                }
                .width(21.25.percent)
                .float(.left)
                
                Div{
                    self.isDangerousMaterialToggle
                        .marginRight(7.px)
                        .float(.right)
                }
                .hidden(self.$isDangerousToggleHidden)
                .width(15.percent)
                .align(.right)
                .float(.left)
                
                Div{
                    self.dangerousMaterialCodeField
                        .hidden(self.$isDangerousMaterial.map{ !$0 })
                        .width(95.percent)
                }
                .width(21.25.percent)
                .float(.left)
                
                Div{
                    self.packagingTypeField
                        .hidden(self.$isDangerousMaterial.map{ !$0 })
                        .width(95.percent)
                }
                .width(21.25.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            
            Div {
                Div("Agregar Mercancia")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addMerchandise()
                    }
            }
            .marginBottom(7.px)
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
        
        fiscCodeField.fiscCodeField.height(31.px)
        
        fiscUnitField.fiscUnitField.height(31.px)
        
        dangerousMaterialCodeField.fiscCodeField.height(31.px)
        
        packagingTypeField.fiscCodeField.height(31.px)
        
        toSelect.appendChild(
            Option("Seleccione Destino")
                .value("")
        )
        
        locations.forEach { place in
            if place.isHomeItem {
                self.from = place.placement.placementId + " " + place.placement.storeName
                self.fromId = place.placement.placementId
                self.fromName = place.placement.storeName
            }
            else {
                
                let opt = Option(place.placement.placementId + " " + place.placement.storeName)
                    .value(place.placement.placementId)
                    .onClick {
                        self.toName = place.placement.storeName
                    }
                
                if locations.count == 2 {
                    toId = place.placement.placementId
                    toName = place.placement.storeName
                    opt.selected(true)
                    
                }
                
                toSelect.appendChild(opt)
            }
        }
        
        descrField.select()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        
    }
    
    func addMerchandise(){
        
        guard !descr.isEmpty else {
            showError(.campoRequerido, .requierdValid("Descriopcion mercancia"))
            descrField.select()
            return
        }
        
        guard let _units = Float(units)?.toCents else{
            showError(.campoRequerido, "Ingrese Unidades")
            unitsField.select()
            return
        }
        
        guard _units > 0 else {
            showError(.campoRequerido, "Ingrese unidades valida")
            unitsField.select()
            return
        }
        
        guard let _kilos = Float(kilograms)?.toCents else{
            showError(.campoRequerido, "Ingrese Kilogramos")
            kilogramsField.select()
            return
        }
        
        
        guard _kilos > 0 else {
            showError(.campoRequerido, "Ingrese peso valida")
            kilogramsField.select()
            return
        }
        guard !toId.isEmpty else {
            showError(.campoRequerido, "Seleccione Destino")
            kilogramsField.select()
            return
        }
        
        guard !fiscCode.isEmpty else {
            showError(.campoRequerido, "Seleccione Destino")
            kilogramsField.select()
            return
        }
        
        guard !fiscUnit.isEmpty else {
            showError(.campoRequerido, "Seleccione Destino")
            kilogramsField.select()
            return
        }
        
        var isDangerous: IsMaterialPeligroso = .no
        
        if isDangerousMaterial {
            
            isDangerous = .si
            
            guard !dangerousMaterialCode.isEmpty else {
                showError(.campoRequerido, "Seleccione Codigo de Material Peligroso")
                kilogramsField.select()
                return
            }
            
            guard !packagingType.isEmpty else {
                showError(.campoRequerido, "Para el material peligroso debe incluir el tipo de embalaje")
                kilogramsField.select()
                return
            }
            
        }
        
        /*
         init(
             fiscCode: fiscCode,
             fiscUnit: fiscCode,
             description: descr,
             units: _units,
             kilograms: _kilos,
             isDangerousMatirial: isDangerous,
             dangerousMatirialCode: dangerousMaterialCode,
             packagingType: packagingType,
             from: fromId,
             fromStoreName: "",
             to: toId,
             toStoreName: ""
         )
         */
        
        callback(.init(
            id: .init(), 
            fiscCode: fiscCode,
            fiscCodeName: fiscCodeName,
            fiscUnit: fiscUnit,
            fiscUnitName: fiscUnitName,
            description: descr,
            units: _units,
            kilograms: _kilos,
            isDangerousMatirial: isDangerous,
            dangerousMatirialCode: dangerousMaterialCode,
            dangerousMatirialName: dangerousMaterialName,
            packagingType: packagingType,
            packagingName: packagingName,
            from: fromId,
            fromStoreName: fromName,
            to: toId,
            toStoreName: toName
        ))
        
        descrField.select()
        
        showSuccess(.operacionExitosa, "Agregado")
        
    }
    
}
