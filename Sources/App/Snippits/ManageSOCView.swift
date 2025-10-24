//
//  ManageSOCView.swift
//  
//
//  Created by Victor Cantu on 4/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class ManageSOCView: Div {
    
    override class var name: String { "div" }
    
    ///dep, cat, line, main, all
    var type: CustProductType
    
    var levelid: UUID?
    
    var levelName: String
    
    @State var socid: UUID?
    
    let titleText: String
    
    /// Wether it will show all the tooks for creation or not
    let quickView: Bool
    
    /// When you do changes to  soc create a call back to parent view
    private var edited: ((
        _ socid: UUID,
        _ name: String,
        _ price: Int64,
        _ avatar: String
    ) -> ())
    
    private var created: ((
        _ soc: CustSOCQuick
    ) -> ())

    private var delete: ((
        _ id: UUID
    ) -> ())
    
    init(
        type: CustProductType,
        levelid: UUID?,
        levelName: String,
        socid: UUID?,
        titleText: String,
        /// Wether it will show all the tooks for creation or not
        quickView: Bool,
        edited: @escaping ( (
            _ socid: UUID,
            _ name: String,
            _ price: Int64,
            _ avatar: String
        ) -> ()),
        created: @escaping ( (
            _ soc: CustSOCQuick
        ) -> ()),
        delete: @escaping ( (
            _ id: UUID
        ) -> ())
    ) {
        self.type = type
        self.levelid = levelid
        self.levelName = levelName
        self.socid = socid
        self.titleText = titleText
        self.quickView = quickView
        self.edited = edited
        self.created = created
        self.delete = delete
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var thisCodeLevelListener = ""
    
    @State var thisCodeLevel: SOCCodeLevel = .master
    
    @State var relationCodeLevel: SOCCodeLevel = .slave
    
    @State var viewMode: ViewMode = .general
    
    @State var notes: [CustGeneralNotesQuick] = []
    
    @State var files: [GeneralFile] = []
    
    @State var relatedCodes: [CustSOCQuick] = []
    
    //@State var id: UUID? = nil
    
    /// If activated in customer billing accout, not aplicable  service order.
    @State var autoExpireAt = ""
    
    /// SOCCodeType
    /// charge, adjustment, recuring, membership
    @State var socCodeTypeListener = SOCCodeType.charge.rawValue
    
    var fiscCode: String = ""
    var fiscCodeDescription: String = ""
    
    var fiscUnit: String = ""
    var fiscUnitDescription: String = ""
    
    /// Ex revGenEx - regision General
    @State var efect: [CustSOCCodeStratergy] = []
    
    @State var saleAction: [CustSaleActionQuick] = []
    
    /// Modifing taxes to be suported
    //public var taxes: String
    /// Related to CustSaleAction
    @State var operationalObject: [CustSOCActionOperationalObjectQuick] = []
    
    /// Related to CustSaleAction
    @State var serviceAction: [CustSaleActionQuick] = []
    
    /// Related to CustDocumentSupport
    @State var documents: [UUID] = []
    
    @State var name: String = ""
    
    @State var code: String = ""
    
    @State var smallDescription: String = ""
    
    @State var descr: String = ""
    
    @State var productionTime = "0"
    
    @State var productionCost = "0"
    
    @State var cost = ""
    
    @State var pricea = ""
    
    @State var priceb = ""
    
    @State var pricec = ""
    
    @State var pricep = ""
    
    @State var inPromo = false
    
    /// ComisionBy
    /// amount, percent
    @State var comisionBy = ComisionBy.amount.rawValue
    
    @State var comisionAmount = "0"
    
    /// CreateODS
    /// If activated in customer billing accout, not aplicable  service order.
    /// daily, weekly, monthly, bymonthly, trimester, forthmester, semester, yearly, manual
    @State var createOds = ""
    
    /// If activated in customer billing accout, not aplicable  service order.
    @State var createOdsValues: [String] = []
    
    @State var accessCodes: [String] = []
    
    @State var icon: String = ""
    
    @State var avatar: String = ""
    
    /// UsernameRoles
    @State var level = UsernameRoles.general.rawValue
    
    @State var insumos = ""
    
    ///GeneralStatus
    @State var status = ""
    
    @State var editImage: Bool = true
    
    @State var avatarUrl = "/skyline/media/tierraceroRoundLogoWhite.svg"
    
    @State var selectedAvatar = ""
    
    @State var autoCalcCost: Bool = (WebApp.current.window.localStorage.string(forKey: "autoCalcCost_\(custCatchID.uuidString)") ?? "true") == "true"
    @State var totalTaxes: Float = 0
    
    var taxModifire: Float = 0
    var costSubTotal: Float = 0
    var paidTaxes: Float = 0
    
    @State var costTaxText = ""
    @State var priceaTaxText = ""
    @State var pricebTaxText = ""
    @State var pricecTaxText = ""
    @State var pricepTaxText = ""
    
    lazy var costTaxDiv = Div(self.$costTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$costTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var priceaTaxDiv = Div(self.$priceaTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$priceaTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricebTaxDiv = Div(self.$pricebTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricebTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricecTaxDiv = Div(self.$pricecTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricecTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var priceprTaxDiv = Div(self.$pricepTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricepTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var nameField = InputText(self.$name)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Nombre")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var codeField = InputText(self.$code)
        .custom("width", "calc(100% - 75px)")
        .class(.textFiledBlackDark)
        .placeholder("COUN01")
        .disabled(true)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var smallDescriptionField = TextArea(self.$smallDescription)
        .class(.textFiledBlackDark)
        .placeholder("Descripcion Comercial")
        .width(90.percent)
        .height(70.px)
        
    lazy var descriptionField = TextArea(self.$descr)
        .class(.textFiledBlackDark)
        .placeholder("Descripcion Tecnica")
        .width(90.percent)
        .height(70.px)
        
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: .service) { data in
        self.fiscCode = data.c
        self.fiscCodeDescription = data.v
    }
    

    lazy var fiscUnitField = FiscUnitField(style: .dark, type: .service) { data in
        self.fiscUnit = data.c
        self.fiscUnitDescription = data.v
    }
    
    lazy var costField = InputText(self.$cost)
        .custom("width", "calc(100% - 16px)")
        .disabled(self.$autoCalcCost)
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var priceaField = InputText(self.$pricea)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var pricebField = InputText(self.$priceb)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var pricecField = InputText(self.$pricec)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var pricepField = InputText(self.$pricep)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var autoExpireAtField = InputText(self.$autoExpireAt)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("0")
        .textAlign(.right)
        .height(28.px)
        .onKeyDown({ tf, event in
            guard let _ = Float(event.key) else {
                if !ignoredKeys.contains(event.key) {
                    event.preventDefault()
                }
                return
            }
        })
        .onFocus { tf in
            tf.select()
        }
    
    lazy var levelSelect = Select(self.$level)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    lazy var fileInput = InputFile()
        .multiple(self.$editImage.map{ !$0 })
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) // , "video/*"
        .display(.none)
    
    lazy var socImageContainer = Div()
        .id(Id(stringLiteral: "socImageContainer"))
    
    lazy var imageAvatar = Img()
        .src("/skyline/media/tierraceroRoundLogoWhite.svg")
    
    lazy var taxedGrid = Div()
        .class(.roundDarkBlue)
        .maxHeight(150.px)
        .minHeight(45.px)
        .overflow(.auto)
    
    @State var noteText = ""
    
    lazy var notesGrid = Div()
    
    lazy var noteField = InputText(self.$noteText)
        .custom("width", "calc(100% - 150px)")
        .class(.textFiledBlackDark)
        .placeholder("Agregar Nota...")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var productionTimeField = InputText(self.$productionTime)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("0")
        .disabled(true)
        .height(28.px)
    
    lazy var productionCostField = InputText(self.$productionCost)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("0")
        .disabled(true)
        .height(28.px)
    
    lazy var createODSSelect = Select(self.$createOds)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    lazy var comisionBySelect = Select(self.$comisionBy)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(28.px)

    lazy var comisionAmountField = InputText(self.$comisionAmount)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("0")
        .disabled(true)
        .height(28.px)
    
    lazy var socCodeTypeSelect = Select(self.$socCodeTypeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    @State var taxes: Tax = .init(trasladados: nil, retenidos: nil)
    
    var imageRefrence: [UUID:ImagePOCContainer] = [:]
    
    lazy var thisCodeLevelSelect = Select(self.$thisCodeLevelListener)
        .disabled(self.$relatedCodes.map{ !$0.isEmpty })
        .custom("width", "calc(100% - 75px)")
        .class(.textFiledBlackDark)
        .height(28.px)

    var saleActionRefrence: [UUID : ServiceAccionRow] = [:]

    lazy var saleActionDiv = Div()

    var serviceActionRefrence: [UUID : ServiceAccionRow] = [:]

    lazy var serviceActionDiv = Div()

    @DOM override var body: DOM.Content {
        
        /// Product Detail View
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                
                H2( self.$socid.map{ ($0 == nil) ? "Crear Servicio" : "Editar Servicio" } )
                    .color(.lightBlueText)
                    .float(.left)
                
                H2(self.$socid.map{ ($0 == nil) ? "Crear en \(self.titleText)" : self.titleText })
                    .marginLeft(12.px)
                    .color(.gray)
                    .float(.left)
                
                Div().class(.clear)
            }
            
            Div {
                
                /// Titile
                H2{
                    
                    Span("Fotos y videos")
                    
                    InputCheckbox().toggle(self.$editImage)
                        .float(.right)
                        .marginTop(-5.px)
                        .marginRight(7.px)
                    
                    Span("Editar Imagenes")
                        .fontSize(21.px)
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.right)
                    
                }.color(.lightBlueText)
                
                Div().class(.clear)
                
                /// Media View Grid
                Div {
                    
                    self.imageAvatar
                        .padding(all: self.$selectedAvatar.map{ $0.isEmpty ? 7.px : 0.px})
                        .width(self.$selectedAvatar.map{ $0.isEmpty ? 250.px : 264.px})
                        .height(self.$selectedAvatar.map{ $0.isEmpty ? 250.px : 264.px})
                    
                }
                .align(.center)
                .class(.oneHalf, .roundDarkBlue)
                .padding(all: 0.px)
                .overflow(.hidden)
                .height(264.px)
                
                /// Media Upload Grid
                Div {
                    
                    self.fileInput
                    
                    Div{
                        
                        Div{
                            Div{
                                Img()
                                    .src("/skyline/media/upload2.png")
                                    .margin(all: 3.px)
                                    .height(18.px)
                            }
                            .float(.left)
                            
                            Span("Subir Foto/Video")
                                .fontSize(18.px)
                            
                            Div().class(.clear)
                            
                        }
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            self.fileInput.click()
                        }
                        
                        Div().class(.clear)
                        
                    }
                    .marginBottom( 7.px)
                    
                    self.socImageContainer
                        .custom("height", "calc(100% - 41px)")
                        .class(.roundDarkBlue)
                        .padding(all: 4.px)
                        .overflow(.auto)
                    
                }
                .marginLeft(7.px)
                .class(.oneHalf)
                .height(250.px)
                
                Div().class(.clear).height(7.px)
                
                H2{
                    Span("Costo y Precios")
                    
                    InputCheckbox().toggle(self.$autoCalcCost)
                        .float(.right)
                        .marginTop(-5.px)
                        .marginRight(7.px)
                    
                    Span("Auto calcular")
                        .fontSize(21.px)
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.right)
                    
                    Div("- 16%")
                    .color(.darkOrange)
                    .marginRight(7.px)
                    .fontSize(16.px)
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        
                    }
                    
                    Div("+ 16%")
                    .color(.chartreuse)
                    .fontSize(16.px)
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        
                    }
                    
                    
                }.color(.lightBlueText)
                
                Div().class(.clear).height(3.px)
                
                Div{
                    
                    /// Cost
                    Div{
                        Label{
                            Div("Costo")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Que costo el producto")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.costField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Price A
                    Div{
                        Label{
                            Div("Precio A")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Costo al Publico")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.priceaField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Price B
                    Div{
                        Label{
                            Div("Precio B")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Medio Mayoreo")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.pricebField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Price C
                    Div{
                        Label{
                            Div("Precio C")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Costo Mayoreo")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.pricecField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Price P
                    Div{
                        Label{
                            Div("Precio Promo")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Costo Promocional")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.pricepField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                }
                .class(.roundDarkBlue)
                .marginRight(2.percent)
                .padding(all: 3.px)
                .width(49.percent)
                .float(.left)
                
                Div{
                    
                    self.costTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    self.priceaTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    self.pricebTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    self.pricecTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    self.priceprTaxDiv
                    
                    
                }
                .width(45.percent)
                .float(.left)
                
                Div().class(.clear).height(7.px)
                
                H2{
                    
                    Img()
                        .src("/skyline/media/add.png")
                        .marginRight(3.px)
                        .cursor(.pointer)
                        .float(.right)
                        .width(28.px)
                        .onClick {
                            
                            guard let codeType =  SOCCodeType(rawValue: self.socCodeTypeListener) else {
                                return
                            }
                            
                            addToDom(AddEfectView(
                                codeType: codeType,
                                currentEfect: self.efect
                            ){ efect in
                                self.efect.append(efect)
                            })
                        }
                    
                    Span("Efectos")
                    
                }.color(.lightBlueText)
                
                Div().class(.clear).height(3.px)
                
                Div {
                 
                    ForEach(self.$efect) { efect in
                        Div{
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginRight(7.px)
                                .height(18.px)
                                .float(.right)
                                .onClick {
                                    var _efects: [CustSOCCodeStratergy] = []
                                    
                                    self.efect.forEach { _efect in
                                        
                                        if _efect == efect {
                                            return
                                        }
                                        
                                        _efects.append(_efect)
                                        
                                    }
                                    
                                    self.efect = _efects
                                    
                                }
                            
                            Span(efect.description)
                            
                        }
                        .width(90.percent)
                        .marginTop(7.px)
                        .class(.uibtn)
                    }
                    
                }
                .class(.roundGrayBlackDark)
                .padding(all: 3.px)
                .margin(all: 3.px)
                .overflow(.auto)
                .height(150.px)
                
                Div().class(.clear).marginTop(12.px)
                
            }
            .custom("height", "calc(100% - 40px)")
            .overflow(.auto)
            .class(.oneHalf)
            
            Div {
                
                Div{
                    
                    H2("Datos del Servicio").color(.lightBlueText)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    Div{
                        Label("Codigo del Producto").color(.lightGray)
                        
                        Div().class(.clear).marginTop(3.px)
                        
                        self.codeField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Label("Nivel de Codigo").color(.lightGray)
                        Div().class(.clear).marginTop(3.px)
                        H2(self.$thisCodeLevel.map{ $0.description })
                            .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    Label("Nombre del Servicio").color(.lightGray)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.nameField
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Div{
                        /// Small Descriotion
                        Label("Descripcion Corta").color(.lightGray)
                        Div{
                            self.smallDescriptionField
                        }
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        /// General Descriotion
                        Label("Descripción").color(.lightGray)
                        Div {
                            self.descriptionField
                        }
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    Div{
                        /// fiscCode
                        Label("Codigo Producto Fiscal").color(.lightGray)
                        self.fiscCodeField
                            .position(.relative)
                            
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        /// fiscUnit
                        Label("Codigo Unidad Fiscal").color(.lightGray)
                        self.fiscUnitField
                            .position(.relative)
                            
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginTop(12.px)
                    
                    /// Taxes
                    Div{
                        Label{
                            Img()
                                .src("/skyline/media/add.png")
                                .marginRight(3.px)
                                .cursor(.pointer)
                                .float(.right)
                                .width(28.px)
                                .onClick {
                                    
                                }
                            Span("Impuestos")
                        }.color(.lightGray)
                        self.taxedGrid
                    }
                    .custom("width", "calc(100% - 7px)")
                    .class(.section)
                        
                    Div().class(.clear).marginTop(3.px)
                
                    /// Buttons
                    Div{
                        
                        H3("General")
                            .backgroundColor(self.$viewMode.map{ ($0 == .general) ? .black : .transparent})
                            .borderTopRightRadius(7.px)
                            .borderTopLeftRadius(7.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.viewMode =  .general
                            }
                        
                        H3("Acciones")
                            .backgroundColor(self.$viewMode.map{ ($0 == .actions) ? .black : .transparent})
                            .borderTopRightRadius(7.px)
                            .borderTopLeftRadius(7.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.viewMode =  .actions
                            }
                        
                        H3("Docs")
                            .backgroundColor(self.$viewMode.map{ ($0 == .documents) ? .black : .transparent})
                            .borderTopRightRadius(7.px)
                            .borderTopLeftRadius(7.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.viewMode =  .documents
                            }
                        
                        H3("Notas")
                            .backgroundColor(self.$viewMode.map{ ($0 == .notes) ? .black : .transparent})
                            .hidden(self.$socid.map{ $0 == nil })
                            .borderTopRightRadius(7.px)
                            .borderTopLeftRadius(7.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.viewMode = .notes
                            }
                        
                        /// relatedCodes
                        H3("Codigos")
                            .backgroundColor(self.$viewMode.map{ ($0 == .relatedCodes) ? .black : .transparent})
                            .hidden(self.$socid.map{ $0 == nil })
                            .borderTopRightRadius(7.px)
                            .borderTopLeftRadius(7.px)
                            .marginRight(12.px)
                            .padding(all:7.px)
                            .cursor(.pointer)
                            .float(.left)
                            .onClick {
                                self.viewMode = .relatedCodes
                            }
                        
                    }
                    
                    Div().class(.clear)
                    
                    /// General
                    Div {
                        /// Tipo de Comicion
                        Div{
                            Label("Tipo de Comision")
                                .color(.gray)
                            
                            self.comisionBySelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        /// Cantidad de comision
                        Div{
                            Label(self.$comisionBy.map{ ($0 == "amount") ? "Cantidad de Comision" : "Porcentaje de Comision" })
                                .color(.gray)
                            
                            self.comisionAmountField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(7.px)
                        
                        /// Nivel de Acceso
                        Div{
                            Label("Nivel de accesso")
                                .color(.gray)
                            
                            self.levelSelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        /// Tipo de orden de servicio
                        Div{
                            Label("Tipo Orden de Servicio")
                                .color(.gray)
                            
                            self.createODSSelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(7.px)
                        
                        /// Auto Expiracion
                        Div{
                            Label("Auto Expiracion")
                                .color(.gray)
                            
                            self.autoExpireAtField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        /// Tipo de orden de servicio
                        Div{
                            Label("Tipo de Codigo")
                                .color(.gray)
                            
                            self.socCodeTypeSelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).marginBottom(7.px)
                        
                        /// Elementos Operacionales
                        Div{
                            Img()
                                .float(.right)
                                .cursor(.pointer)
                                .src("/skyline/media/add.png")
                                .height(28.px)
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .onClick {
                                    addToDom(ServiceOperationalObjectsView(
                                        currentIds: self.operationalObject.map{ $0.id }
                                    ) { object in
                                        
                                        print("⭐️  add  operationalObject")
                                        
                                        self.operationalObject.append(object)
                                    })
                                }
                            
                            H2("Elementos Operacionales")
                        }
                        .marginBottom(7.px)
                        
                        Div{
                            ForEach(self.$operationalObject){ object in
                                
                                ServiceActionOperationalRow(
                                    showEditControler: false,
                                    object: object,
                                    removed: {
                                        
                                        var _operationalObject: [CustSOCActionOperationalObjectQuick] = []
                                        
                                        self.operationalObject.forEach { _object in
                                            if _object.id == object.id {
                                                return
                                            }
                                            _operationalObject.append(_object)
                                        }
                                        
                                        self.operationalObject = _operationalObject
                                        
                                    },
                                    edited: { element in
                                        
                                        var _operationalObject: [CustSOCActionOperationalObjectQuick] = []
                                        
                                        self.operationalObject.forEach { _object in
                                            if _object.id == element.id {
                                                _operationalObject.append(element)
                                                
                                            }
                                            _operationalObject.append(_object)
                                        }
                                        
                                        self.operationalObject = _operationalObject
                                        
                                    }
                                )
                                
                            }
                            .hidden(self.$operationalObject.map{ $0.isEmpty })
                            .id(Id(stringLiteral: "saleAction"))
                            
                            Table().noResult(label: "No hay cargos operacionales")
                                .hidden(self.$operationalObject.map{ !$0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .marginBottom(12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .height(170.px)
                        .overflow(.auto)
                        
                        Div().class(.clear).marginBottom(7.px)
                        
                    }
                    .hidden(self.$viewMode.map{ ($0 != .general) })
                    .class(.roundGrayBlackDark)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop( 0.px)
                    
                    /// Actions
                    Div{
                        
                        Div{
                            Label("Timepo de Produccion")
                                .color(.lightGray)
                                .marginBottom(3.px)
                            
                            self.productionTimeField
                                .marginBottom(7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Label("Costo de Produccion")
                                .color(.lightGray)
                                .marginBottom(3.px)
                            
                            self.productionCostField
                                .marginBottom(7.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear)
                        
                        /// Acciones de Venta
                        Div{
                            Img()
                                .float(.right)
                                .cursor(.pointer)
                                .src("/skyline/media/add.png")
                                .height(28.px)
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .onClick {
                                    addToDom(ServiceAccionsView(
                                        type: .saleAction,
                                        currentIds: self.saleAction.map{ $0.id },
                                        callback: { action in
                                            
                                            self.saleAction.append(action)

                                            let view = ServiceAccionRow(
                                                type: .saleAction,
                                                action: action,
                                                removed: { 
                                                    self.removeSaleAction(action.id)
                                                }
                                            )

                                            self.saleActionDiv.appendChild(view)

                                            self.saleActionRefrence[action.id] = view

                                        }
                                    ))
                                }
                            
                            H2("Acciones de Venta")
                        }
                        .marginBottom(7.px)
                        
                        Div{
                            /*
                            ForEach(self.$saleAction){ action in
                                
                                ServiceAccionRow(
                                    type: .saleAction,
                                    action: action,
                                    removed: { 
                                        self.removeSaleAction(action.id)
                                    }
                                )

                            }
                            */
                            self.saleActionDiv
                            .hidden(self.$saleAction.map{ $0.isEmpty })
                            .id(Id(stringLiteral: "saleAction"))
                            
                            Table().noResult(label: "No hay acciones de ventas 🗂")
                                .hidden(self.$saleAction.map{ !$0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .marginBottom(12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .height(170.px)
                        .overflow(.auto)
                        
                        /// Acciones de Servicio
                        Div{
                            Img()
                                .float(.right)
                                .cursor(.pointer)
                                .src("/skyline/media/add.png")
                                .height(28.px)
                                .padding(all: 3.px)
                                .paddingRight(0.px)
                                .onClick {
                                    addToDom(ServiceAccionsView(
                                        type: .serviceAction,
                                        currentIds: self.saleAction.map{ $0.id },
                                        callback: { action in

                                            self.serviceAction.append(action)

                                            let view = ServiceAccionRow(
                                                type: .serviceAction,
                                                action: action,
                                                removed: { 
                                                    self.removeSaleAction(action.id)
                                                }
                                            )

                                            self.serviceActionDiv.appendChild(view)

                                            self.serviceActionRefrence[action.id] = view

                                        }
                                    ))
                                }
                            
                            H2("Acciones de Servicio")
                        }
                        .marginBottom(7.px)
                        
                        Div{
                            /*
                            ForEach(self.$serviceAction){ action in
                                
                                ServiceAccionRow(
                                    type: .serviceAction,
                                    action: action,
                                    removed: {
                                        self.removeServiceAction(action.id)
                                    }
                                )
                                
                            }
                            */
                            self.serviceActionDiv
                            .hidden(self.$serviceAction.map{ $0.isEmpty })
                            .id(Id(stringLiteral: "serviceAction"))
                            
                            Table().noResult(label: "No hay acciones de servicio 🗂")
                                .hidden(self.$serviceAction.map{ !$0.isEmpty })
                        }
                        .class(.roundDarkBlue)
                        .marginBottom(12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .height(170.px)
                        .overflow(.auto)
                        
                    }
                    .hidden(self.$viewMode.map{ ($0 != .actions) })
                    .class(.roundGrayBlackDark)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop( 0.px)
                    
                    /// Documentos
                    Div {
                        Table().noResult(label: "Los documentos aun no son soportados 🤕")
                    }
                    .hidden(self.$viewMode.map{ ($0 != .documents) })
                    .class(.roundGrayBlackDark)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop( 0.px)
                    .height(250.px)
                    
                    /// Notes
                    Div{
                        Div{
                            ForEach(self.$notes) {
                                QuickMessageObject(isEven: false, note: $0)
                            }
                            .hidden(self.$notes.map{ $0.isEmpty })
                            
                            Table().noResult(label: "No hay notas 📗")
                                .hidden(self.$notes.map{ !$0.isEmpty })
                        }
                        .padding(all: 3.px)
                        .class(.roundBlue)
                        .margin(all: 3.px)
                        .overflow(.auto)
                        .height(200.px)
                        
                        Div().class(.clear)
                        
                        Div("Agregar Comentarios")
                            .fontSize(12.px)
                            .color(.white)
                        
                        Div()
                            .class(.clear)
                            .marginBottom(3.px)
                        
                        Div{
                            
                            self.noteField
                                .onEnter {
                                    self.addNote()
                                }
                            
                            Span(" Agergar Nota ")
                                .marginLeft(7.px)
                                .class(.uibtn)
                                .width(100.px)
                                .onClick {
                                    self.addNote()
                                }
                            
                        }
                        .marginBottom(12.px)
                        
                    }
                    .hidden(self.$viewMode.map{ ($0 != .notes) })
                    .class(.roundGrayBlackDark)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop( 0.px)
                    
                    /// related SOCs
                    Div{
                        
                        /// Tipo de Comicion
                        Div{
                            Label("Tipo de relacion")
                                .color(.lightBlueText)
                                .fontSize(24.px)
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        /// Tipo de Comicion
                        Div{
                            
                            Img()
                                .src("/skyline/media/add.png")
                                .marginRight(3.px)
                                .cursor(.pointer)
                                .float(.right)
                                .width(28.px)
                                .onClick {
                                    self.addRelatedCode()
                                }
                            
                            self.thisCodeLevelSelect
                            
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().class(.clear).height(3.px)
                        
                        Div{
                            
                            ForEach(self.$relatedCodes) { soc in
                                @State var name = soc.name
                                
                                return Div{
                                    Img()
                                        .src("/skyline/media/cross.png")
                                        .marginRight(7.px)
                                        .height(18.px)
                                        .float(.right)
                                        .onClick {
                                            
                                            addToDom(ConfirmationView(
                                                type: .yesNo,
                                                title: "Remover relacion",
                                                message: "Confirm que desea remover \(soc.name)",
                                                callback: { isConfimed, _ in
                                            
                                                    if isConfimed {
                                                        
                                                        
                                                        guard let socId = self.socid else {
                                                            return
                                                        }
                                                        
                                                        loadingView(show: true)
                                                        
                                                        API.custSOCV1.removeRelatedCode(
                                                            currentId: socId,
                                                            targetId: soc.id
                                                        ) { resp in
                                                            
                                                            loadingView(show: false)
                                                            
                                                            guard let resp else {
                                                                showError(.errorDeCommunicacion, .serverConextionError)
                                                                return
                                                            }
                                                            
                                                            guard resp.status == .ok else {
                                                                showError(.errorGeneral, resp.msg)
                                                                return
                                                            }
                                                            
                                                            var _relatedCodes: [CustSOCQuick] = []
                                                            
                                                            self.relatedCodes.forEach { code in
                                                                if code.id == soc.id {
                                                                    return
                                                                }
                                                                _relatedCodes.append(code)
                                                            }
                                                            
                                                            self.relatedCodes = _relatedCodes
                                                            
                                                        }
                                                    }
                                                }
                                            ))
                                            
                                        }
                                    
                                    Div($name)
                                        .custom("width","calc(100% - 28px)")
                                        .class(.oneLineText)
                                        .fontSize(18.px)
                                        .float(.left)
                                    
                                    Div().clear(.both)
                                }
                                .width(95.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick {
                                    
                                    let view = ManageSOCView(
                                        type: .main,
                                        levelid: nil,
                                        levelName: "",
                                        socid: soc.id,
                                        titleText: "",
                                        quickView: false
                                    ) { socid, newname, price, avatar in
                                        name = newname
                                    } created: { _ in
                                        // no accion nedes
                                    } delete: { id in
                                        print(" 🟢  🗳️  delete 003")

                                        var relatedCodes: [CustSOCQuick] = []
                                        
                                        self.relatedCodes.forEach { code in
                                            if code.id == soc.id {
                                                return
                                            }
                                            relatedCodes.append(code)
                                        }
                                        
                                        self.relatedCodes = relatedCodes
                                        
                                    }
                                    
                                    addToDom(view)
                                    
                                }
                            }
                            .hidden(self.$relatedCodes.map{ $0.isEmpty })
                            
                            Table().noResult(label: "No hay codigos relacionados 🐼")
                                .hidden(self.$relatedCodes.map{ !$0.isEmpty })
                            
                        }
                        .padding(all: 3.px)
                        .class(.roundBlue)
                        .margin(all: 3.px)
                        .overflow(.auto)
                        .height(200.px)
                        
                        Div().class(.clear)
                        
                    }
                    .hidden(self.$viewMode.map{ ($0 != .relatedCodes) })
                    .class(.roundGrayBlackDark)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginTop( 0.px)
                    
                    Div().class(.clear).marginTop(12.px)
                    
                }
                .custom("height", "calc(100% - 36px)")
                .marginBottom(7.px)
                .overflow(.auto)
                
                Div().clear(.both)
                
                Div{
                    /// DELETE
                    Div{
                        Div{
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginTop(7.px)
                                .height(18.px)
                        }
                        .marginRight(7.px)
                        .float(.left)
                        
                        Span("Eliminar")
                            .fontSize(18.px)
                        
                    }
                    .hidden(self.$socid.map{ ($0 == nil) })
                    .class(.uibtnLarge)
                    .marginRight(18.px)
                    .marginTop(0.px)
                    .float(.left)
                    .onClick {
                        addToDom(ConfirmationView(
                            type: .yesNo,
                            title: "Eliminar Servicio",
                            message: "¿Confirme que desea eliminar el codigo?",
                            callback: { isConfirmed, comment in
                                if isConfirmed {
                                    self.deleteSOC()
                                }
                            }))
                    }
                    
                    /// SAVE CHANGES
                    Div{
                        Div{
                            Img()
                                .src(self.$socid.map{ ($0 == nil) ? "/skyline/media/add.png" : "/skyline/media/diskette.png" })
                                .marginTop(7.px)
                                .height(18.px)
                        }
                        .marginRight(7.px)
                        .float(.left)
                        
                        Span(self.$socid.map{ ($0 == nil) ? "Crear Servicio" : "Guardar Cambio" })
                            .fontSize(18.px)
                        
                    }
                    .class(.uibtnLargeOrange)
                    .marginRight(18.px)
                    .marginTop(0.px)
                    .float(.right)
                    .onClick {
                        self.saveSOC()
                    }
                }
            }
            .custom("height", "calc(100% - 45px)")
            .marginLeft(16.px)
            .class(.oneHalf)
            
        }
        .custom("height", "calc(100% - 110px)")
        .custom("left", "calc(50% - 575px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(1150.px)
        .color(.white)
        .top(70.px)
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        $name.listen {
            self.createCodeName()
        }
        
        $relationCodeLevel.listen {
            switch $0 {
            case .master:
                self.thisCodeLevel = .slave
            case .slave:
                self.thisCodeLevel = .master
            }
        }
        
        $thisCodeLevelListener.listen {
            if let code = SOCCodeLevel(rawValue: $0) {
                self.relationCodeLevel = code
            }
        }
        
        fileInput.$files.listen {
            
            if let file = $0.first {
                self.loadMedia(file)
            }
        }
        
        $selectedAvatar.listen {
            
            if $0.isEmpty {
                self.imageAvatar
                    .load("/skyline/media/tierraceroRoundLogoWhite.svg")
                return
            }
            
            var _path = ""
            
            if self.socid == nil {
                _path = "https://\(custCatchUrl)/iCatch/"
            }
            else{
                if let pDir = customerServiceProfile?.account.pDir {
                    _path = "https://intratc.co/cdn/\(pDir)/"
                }
            }
            
            self.imageAvatar
                .load("\(_path)thump_\($0)")
            
            if let socid = self.socid {
                self.edited( socid, self.name, (Float(self.pricea.replace(from: ",", to: "")) ?? 0).toCents, $0)
            }
        }
        
        $taxes.listen {
            
            if let _taxes = self.taxes.retenidos {
                if let tax = _taxes.isr {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "ISR \(tax.amount.formatMoney)", type: "[R]", factor: tax.factor) )
                }
                if let tax = _taxes.iva {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "IVA \(tax.amount.formatMoney)", type: "[R]", factor: tax.factor) )
                }
                if let tax = _taxes.ieps {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "IEPS \(tax.amount.formatMoney)", type: "[R]", factor: tax.factor) )
                }
            }
            
            if let _taxes = self.taxes.trasladados {
                if let tax = _taxes.isr {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "ISR \(tax.amount.formatMoney)", type: "[T]", factor: tax.factor) )
                }
                if let tax = _taxes.iva {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "IVA \(tax.amount.formatMoney)", type: "[T]", factor: tax.factor) )
                }
                if let tax = _taxes.ieps {
                    self.totalTaxes += Float(tax.amount)
                    self.taxedGrid.appendChild(self.taxItemObject(text: "IEPS \(tax.amount.formatMoney)", type: "[T]", factor: tax.factor) )
                }
            }
            
        }
        
        $autoCalcCost.listen {
            WebApp.current.window.localStorage.set( JSString($0 ? "true" : "false"), forKey: "autoCalcCost_\(custCatchID.uuidString)")
        }
        
        $operationalObject.listen {
            self.calcInternalCost()
        }
        
        $saleAction.listen {
            self.calcInternalCost()
        }
        
        $serviceAction.listen {
            self.calcInternalCost()
        }
        
        $cost.listen {
            
            var val = $0.replace(from: ",", to: "")
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(val)?.toCents else {
                return
            }
            
            self.createCodeName()
            
            self.taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000
            
            self.costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100

            self.paidTaxes = ((_cost.fromCents - self.costSubTotal) * 100).rounded() / 100
            
            self.costTaxText = "\(self.costSubTotal.formatMoney) [\(self.paidTaxes.formatMoney)]"
            
            if self.autoCalcCost {
                
                let sugestedPrices = PriceRanger.getSugestedPrice(
                    cost: _cost,
                    ranges: configStoreProcessing.servicePriceRange
                )
                
                self.pricea = sugestedPrices.pricea.formatMoney
                
                self.priceb = sugestedPrices.priceb.formatMoney
                
                self.pricec = sugestedPrices.pricec.formatMoney
                
                self.pricep = sugestedPrices.pricec.formatMoney
                
            }
            
        }
        
        $pricea.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val)?.toCents else {
                return
            }
            
            //let _taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000

            let _costSubTotal = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let _paidTaxes = ((_price.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subRevenue = _price - _cost
            
            /// with out tax
            let subTotalRevenue = (((subRevenue.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let subTotalRevenueTax = ((subRevenue.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            self.priceaTaxText = "\(((subTotalRevenue + _paidTaxes) - subTotalRevenueTax).formatMoney) " +
            "[\(subTotalRevenueTax.formatMoney)]"
            
        }
        
        $priceb.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val)?.toCents else {
                return
            }
            
            //let _taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000

            let _costSubTotal = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let _paidTaxes = ((_price.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subRevenue = _price - _cost
            
            /// with out tax
            let subTotalRevenue = (((subRevenue.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let subTotalRevenueTax = ((subRevenue.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            self.pricebTaxText = "\(((subTotalRevenue + _paidTaxes) - subTotalRevenueTax).formatMoney) " +
            "[\(subTotalRevenueTax.formatMoney)]"
            
        }
        
        $pricec.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val)?.toCents else {
                return
            }
            
            //let _taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000

            let _costSubTotal = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let _paidTaxes = ((_price.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subRevenue = _price - _cost
            
            /// with out tax
            let subTotalRevenue = (((subRevenue.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let subTotalRevenueTax = ((subRevenue.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            self.pricecTaxText = "\(((subTotalRevenue + _paidTaxes) - subTotalRevenueTax).formatMoney) " +
            "[\(subTotalRevenueTax.formatMoney)]"
            
        }
        
        $pricep.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val)?.toCents else {
                return
            }
            
            //let _taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000

            let _costSubTotal = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let _paidTaxes = ((_price.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subRevenue = _price - _cost
            
            /// with out tax
            let subTotalRevenue = (((subRevenue.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            let subTotalRevenueTax = ((subRevenue.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            self.pricepTaxText = "\(((subTotalRevenue + _paidTaxes) - subTotalRevenueTax).formatMoney) " +
            "[\(subTotalRevenueTax.formatMoney)]"
            
        }
        
        UsernameRoles.allCases.forEach { role in
            
            let option = Option(role.description)
                .value(role.rawValue)
            
            if role.value > custCatchHerk {
                option.disabled(true)
            }
            
            levelSelect.appendChild(option)
            
        }
        
        SOCCodeLevel.allCases.forEach { level in
            thisCodeLevelSelect.appendChild(Option(level.description)
                .value(level.rawValue))
        }
        
        createODSSelect.appendChild(
            Option("Seleccione Opcion")
                .value("")
        )
        
        CreateODS.allCases.forEach { item in
            createODSSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        ComisionBy.allCases.forEach { item in
            comisionBySelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        /// charge, adjustment, recuring, membership
        SOCCodeType.allCases.forEach { item in
            socCodeTypeSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        taxes = .init(
           trasladados: .init(
               isr: nil,
               iva: .init(factor: .tasa, amount: 0.16),
               ieps: nil
           ),
           retenidos: nil
        )
        
        fiscCodeField.fiscCodeField.height(28.px)
        
        fiscUnitField.fiscUnitField.height(28.px)
        
        if let socid {
            loadSOCData(socid: socid)
        }

    }
    
    func calcInternalCost(){
        
        var totalCost: Int64 = 0
        
        var totalTime: Int64 = 0
        
        operationalObject.forEach { item in
            totalCost += (item.productionCost.fromCents * item.productionUnits.fromCents).toCents
            
            totalCost += (item.productionLevel.value.fromCents * item.productionTime.fromCents).toCents
            
            totalTime = item.productionTime
        }
        
        saleAction.forEach { item in
            totalCost += (item.productionTime.fromCents * item.workforceLevel.value.fromCents).toCents
            totalTime += item.workforceLevel.value
        }
        
        serviceAction.forEach { item in
            totalCost += (item.productionTime.fromCents * item.workforceLevel.value.fromCents).toCents
            totalTime += item.workforceLevel.value
        }
        
        cost = totalCost.formatMoney
        
    }
    
    func addRelatedCode() {
        
        var currentCodes: [UUID] = self.relatedCodes.map{ $0.id }
        
        guard let socId = self.socid else {
            return
        }
        
        currentCodes.append(socId)
        
        addToDom(SearchSOCQuickView(excludIds: currentCodes){ soc in
            self.addRelatedCodeAction(force: false, soc: soc)
        })
    }
    
    func addRelatedCodeAction(force: Bool, soc: CustSOCQuick){
        
        guard let socId = self.socid else {
            return
        }
        
        loadingView(show: true)
        
        var type: API.custSOCV1.AddRelatedCodeType = .asMaster
        
        switch self.relationCodeLevel {
        case .master:
            break
        case .slave:
            type = .asSlave
        }
        
        API.custSOCV1.addRelatedCode(
            force: force,
            type: type,
            currentId: socId,
            targetId: soc.id
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError( .unexpectedResult, "Error al obtener payload de data.")
                return
            }
            
            switch payload {
            case .success:
                
                self.relatedCodes.append(soc)
                
            case .actionRequired(let message):
                addToDom(ConfirmationView(
                    type: .yesNo,
                    title: "Confirmación Requerida",
                    message: message,
                    callback: { isConfirmed, comment in
                        if isConfirmed {
                            self.addRelatedCodeAction(force: true, soc: soc)
                        }
                    }
                ))
            }
        }
    }
    
    func createCodeName(){
        
        self.code = ""
        
        if name.isEmpty {
            return
        }
        let ignoredWords: [String] = ["DE","LA", "LOS", "LAS", "O"]
        
        var value = name.pseudo.purgeSpaces.uppercased().filter("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ".contains)
        
        let unPurgedParts = value.explode(" ")
        
        var parts: [String] = []
        
        var prefix = 3
        
        unPurgedParts.forEach { part in
            if ignoredWords.contains(part) {
                return
            }
            parts.append(part)
        }
        
        print("unPurgedParts")
        print(unPurgedParts.count)
        print(unPurgedParts)
        
        print("parts")
        print(parts.count)
        print(parts)
        
        if parts.count > 2 {
            prefix = 2
        }
        
        parts.forEach { part in
            
            if let _int = Int(part) {
                self.code += part
            }
            else {
                self.code += part.uppercased().prefix(prefix)
            }
        }
        
        var hasPriceSuffix = false
        
        if let lastPart = parts.last {
            if let int = Double(lastPart)?.rounded() {
                if let cost = Double(self.pricea.replace(from: ",", to: ""))?.rounded() {
                    hasPriceSuffix = true
                    if cost != int {
                        self.code += Int(cost).toString
                    }
                }
                else {
                    hasPriceSuffix = true
                    self.code += Int(int).toString
                }
            }
        }
        
        if !hasPriceSuffix {
            if let cost = Double(self.pricea.replace(from: ",", to: ""))?.rounded() {
                self.code += Int(cost).toString
            }
        }
    }
    
    func loadSOCData(socid: UUID) {
        
        loadingView(show: true)
        
        API.custSOCV1.getSOC(socid: socid) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError( .unexpectedResult, "Error al obtener payload de data.")
                return
            }
            
            let currentAutoCalcCost = ((WebApp.current.window.localStorage.string(forKey: "autoCalcCost_\(custCatchID.uuidString)") ?? "true") == "true")
            
            self.autoCalcCost = false
            
            self.autoExpireAt = payload.soc.autoExpireAt?.toString ?? ""
            self.name = payload.soc.name
            self.code = payload.soc.name
            self.smallDescription = payload.soc.smallDescription
            self.descr = payload.soc.description
            
            self.socCodeTypeListener = payload.soc.codeType.rawValue
            
            self.fiscCode = payload.soc.fiscCode
            self.fiscCodeDescription = payload.fiscCode
            self.fiscCodeField.fiscCodeField.text = "\(self.fiscCode) \(payload.fiscCode)"
            self.fiscCodeField.fiscCodeField.class(.isOk)
            self.fiscCodeField.currentCode = self.fiscCode
            self.fiscCodeField.fiscCodeIsSelected = true
            
            self.fiscUnit = payload.soc.fiscUnit
            self.fiscUnitDescription = payload.fiscUnit
            self.fiscUnitField.fiscUnitField.text = "\(self.fiscUnit) \(payload.fiscUnit)"
            self.fiscUnitField.fiscUnitField.class(.isOk)
            self.fiscUnitField.currentCode = self.fiscUnit
            self.fiscUnitField.fiscUnitIsSelected = true
            
            self.cost = payload.soc.cost.formatMoney.replace(from: ",", to: "")
            self.pricea = payload.soc.pricea.formatMoney.replace(from: ",", to: "")
            self.priceb = payload.soc.priceb.formatMoney.replace(from: ",", to: "")
            self.pricec = payload.soc.pricec.formatMoney.replace(from: ",", to: "")
            self.pricep = payload.soc.pricep.formatMoney.replace(from: ",", to: "")
            
            self.productionTime = payload.soc.productionTime.formatMoney.replace(from: ",", to: "")
            
            self.productionCost = payload.soc.productionCost.formatMoney.replace(from: ",", to: "")
            
            self.notes = payload.notes
            
            self.efect = payload.soc.efect
            
            self.operationalObject = payload.soc.operationalObject
            
            self.saleAction = payload.soc.saleAction
            
            self.serviceAction = payload.soc.serviceAction
            
            self.comisionBy = payload.soc.comisionBy.rawValue
            
            self.comisionAmount = payload.soc.comisionAmount.toString
            
            self.createOds = payload.soc.createOds?.rawValue ?? ""
            
            self.level = payload.soc.level.rawValue
            
            switch payload.soc.codeLevel{
            case .master:
                self.thisCodeLevelListener = SOCCodeLevel.slave.rawValue
            case .slave:
                self.thisCodeLevelListener = SOCCodeLevel.master.rawValue
            }
            
            self.relatedCodes =  payload.relatedCodes
            
            if !payload.soc.avatar.isEmpty {
                self.imageAvatar.load("https://\(custCatchUrl)/contenido/\(payload.soc.avatar)")
            }
            
            self.autoCalcCost = currentAutoCalcCost
           
           // self.saleAction
            payload.soc.saleAction.forEach { action in

                let view = ServiceAccionRow(
                    type: .saleAction,
                    action: action,
                    removed: { 
                        self.removeSaleAction(action.id)
                    }
                )

                self.saleActionDiv.appendChild(view)

                self.saleActionRefrence[action.id] = view

            }

            payload.soc.serviceAction.forEach { action in

                let view = ServiceAccionRow(
                    type: .saleAction,
                    action: action,
                    removed: { 
                        self.removeServiceAction(action.id)
                    }
                )

                self.serviceActionDiv.appendChild(view)

                self.serviceActionRefrence[action.id] = view

            }

        }
    }
    
    func loadMedia(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        let view: ImagePOCContainer = .init(
            type: .img,
            mediaid: nil,
            pocid: self.socid,
            file: nil,
            image: nil,
            width: 0,
            description: "",
            height: 0,
            selectedAvatar: $selectedAvatar
        ) { viewid, mediaid, path, originalImage, originalWidth, originalHeight, isAvatar in
            self.startEditImage(
                viewid,
                mediaid,
                path,
                originalImage,
                originalWidth,
                originalHeight,
                isAvatar
            )
        } imAvatar: { name in
            self.selectedAvatar = name
        } removeMe: { viewid in
            self.imageRefrence.removeValue(forKey: viewid)
        }
        
        imageRefrence[view.viewid] = view
        
        xhr.onLoadStart {
            self.socImageContainer.appendChild(view)
            _ = JSObject.global.scrollToBottom!("pocImageContainer")
        }
        
        xhr.onError { jsValue in
            showError(.errorDeCommunicacion, .serverConextionError)
            self.imageRefrence.removeValue(forKey: view.viewid)
            //self.uploadPercent = ""
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            view.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.errorGeneral, .serverConextionError + " 001")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.errorGeneral, .serverConextionError + " 002")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadMediaResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.imageRefrence.removeValue(forKey: view.viewid)
                    view.remove()
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, "No se pudo cargar datos")
                    self.imageRefrence.removeValue(forKey: view.viewid)
                    view.remove()
                    return
                }
                
                view.mediaid = data.id
                view.width = data.width
                view.height = data.height
                view.loadImage(data.avatar, edit: self.editImage)
                
                var hasAvatar = false
                
                self.imageRefrence.forEach { _, view in
                    if view.isAvatar {
                        hasAvatar = true
                    }
                }
                
                if !hasAvatar {
                    print("🟢  i dont have avatar ")
                    view.setAsAvatar(image:data.avatar)
                }
                else{
                    print("🟡  i do have avatar ")
                }
                
            } catch {
                showError(.errorGeneral, .serverConextionError + " 003")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            let event = ProgressEvent(_event.jsEvent)
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
        }
        
        xhr.onProgress { event in
            print("⭐️  002")
            print(event)
        }
        
        let formData = FormData()
        
        formData.append("file", file, filename: file.name)
        
        if let id = self.socid?.uuidString {
            formData.append("socid", id)
        }
        
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadMedia")
        
        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web,
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        xhr.send(formData)
        
    }
    
    func startEditImage(
        _ viewid: UUID,
        _ mediaid: UUID?,
        _ path: String,
        _ originalImage: String,
        _ originalWidth: Int,
        _ originalHeight: Int,
        _ isAvatar: Bool
    ){
        
        let editor = ImageEditor(
            eventid: viewid,
            to: .service,
            relid: socid,
            subId: nil,
            isAvatar: isAvatar,
            mediaid: mediaid,
            path: path,
            originalImage: originalImage,
            originalWidth: originalWidth,
            originalHeight: originalHeight
        ) { 
            if let view = self.imageRefrence[viewid] {
                view.loadImage( "/skyline/media/tierraceroRoundLogoWhite.svg" )
            }
        }
        
        addToDom(editor)
        
    }
    
    func taxItemObject(text: String, type: String, factor: TaxFactor) -> Section {
        Section {
            Span(text)
            
            Span(type)
                .marginRight(7.px)
                .float(.right)
            
            Span(factor.rawValue)
                .marginRight(7.px)
                .float(.right)
        }
        .custom("width", "calc(100% - 20px)")
        .class(.uibtnLarge)
        .marginBottom(7.px)
        .marginTop(0.px)
    }
    
    func saveSOC() {
        
        name = name.purgeSpaces
        
         //Modelo
         if name.isEmpty {
             showError(.campoRequerido, "Ingrese modelo o nombre del produsto")
             return
         }
         //smallDescription
         if smallDescription.isEmpty {
             showError(.campoRequerido, "Requiere descripcion corta")
             return
         }
         //fiscode
         if fiscCode.isEmpty {
             showError(.campoRequerido, "Codigo fiscal")
             return
         }
         //fiscunit
         if fiscUnit.isEmpty {
             showError(.campoRequerido, "Unidad Fiscal")
             return
         }
         //cost i
        
        guard let _cost = Float(cost.replace(from: ",", to: "")) else {
            showError(.campoRequerido, "Costo Interno Requerido")
            return
        }
        
        guard let _pricea = Float(pricea.replace(from: ",", to: "")) else {
            showError(.campoRequerido, "Precio A Requerido")
            return
        }
        
        if priceb.isEmpty { priceb = pricea }
        
        if pricec.isEmpty { pricec = priceb }
        
        if pricep.isEmpty { pricep = priceb }
        
        guard let _priceb = Float(priceb.replace(from: ",", to: "")) else {
            showError(.formatoInvalido, "Precio Medio Mayore Requerido")
            return
        }
        
        guard let _pricec = Float(pricec.replace(from: ",", to: "")) else {
            showError(.formatoInvalido, "Precio Mayore Requerido")
            return
        }
        
        guard let _pricep = Float(pricep.replace(from: ",", to: "")) else {
            showError(.formatoInvalido, "Precio Promocional Requerido")
            return
        }
        
        guard let _productionCost = Float(productionCost)?.toCents else {
            showError(.formatoInvalido, "Precio Promocional Requerido")
            return
        }
        
        var hasLoadedAllImages = true
        
        imageRefrence.forEach { id, item in
            
            guard let image = item.image else {
                hasLoadedAllImages = false
                return
            }
            
            files.append(.init(
                file: image,
                files: [image],
                width: item.width,
                height: item.height
            ))
        }
        
        if !hasLoadedAllImages {
            showAlert(.alerta, "Espere a que todas las imagenes se cargen por favor")
            return
        }
        
        var saleActionsTime: Int = 0
        var saleActionsCost: Int64 = 0
        var saleActionsPoints: Int = 0
        
        saleAction.forEach { item in
            saleActionsTime += item.productionTime.toInt
            saleActionsCost += ( item.productionTime.toFloat * item.workforceLevel.value.fromCents ).toCents
            saleActionsPoints += Int( item.productionTime.toFloat * item.productionLevel.value.fromCents )
        }
        
        var serviceActionsTime: Int = 0
        var serviceActionsCost: Int64 = 0
        var serviceActionsPoints: Int = 0
        
        saleAction.forEach { item in
            serviceActionsTime += item.productionTime.toInt
            serviceActionsCost += ( item.productionTime.toFloat * item.workforceLevel.value.fromCents ).toCents
            serviceActionsPoints += Int( item.productionTime.toFloat * item.productionLevel.value.fromCents )
        }
        
        let serviceLevel = UsernameRoles(rawValue: level) ?? .general
        
        guard let _comisionBy = ComisionBy(rawValue: comisionBy) else{
            showError(.campoInvalido, "Seleccione comision valido")
            return
        }
        
        guard let _comisionAmount = Int(comisionAmount) else{
            showError(.campoInvalido, "Monto de comision invalida")
            return
        }
        
        guard let socCodeType = SOCCodeType(rawValue: socCodeTypeListener) else {
            showError(.campoInvalido, "Seleccione tipo de codigo a seleccionar")
            return
        }
        
        var unCompatibleCode: CustSOCCodeStratergy? = nil
        
        var unCompatibleReason = ""
        
        /// Check code compatibility
        efect.forEach { efect in
            
            if !efect.compatibility.contains(socCodeType) {
                unCompatibleCode = efect
                unCompatibleReason = "El codigo es compatibe con un Codigo de Servicio tipo \(socCodeType.description)"
                return
            }
            
            if !efect.available {
                unCompatibleCode = efect
                unCompatibleReason = "Este codigo no esta disponible aun, si le interesa usar lo contacte a Soporte TC"
                return
            }
        }
        
        if let unCompatibleCode {
            showError(.errorGeneral, "El EFECTO \(unCompatibleCode.description.uppercased()) es incompatible")
            showError(.errorGeneral, unCompatibleReason)
            return
        }
        
        loadingView(show: true)
        
        if let socid {
             
            API.custSOCV1.updateSOC(
                id: socid,
                serviceType: socCodeType,
                serviceLevel: serviceLevel,
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeDescription,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitDescription,
                autoExpireAt: Int(autoExpireAt),
                name: name,
                smallDescription: smallDescription,
                description: descr,
                productionCost: _productionCost.fromCents,
                cost: _cost,
                pricea: _pricea,
                priceb: _priceb,
                pricec: _pricec,
                pricep: _pricep,
                operationalObject: operationalObject.map{ $0.id },
                saleActions: saleAction.map{ $0.id },
                saleActionsTime: saleActionsTime,
                saleActionsCost: saleActionsCost,
                saleActionsPoints: saleActionsPoints,
                serviceActions: serviceAction.map{ $0.id },
                serviceActionsTime: serviceActionsTime,
                serviceActionsCost: serviceActionsCost,
                serviceActionsPoints: serviceActionsPoints,
                comisionBy: _comisionBy,
                comision: _comisionAmount,
                inPromo: inPromo,
                createOds: false,
                efect: self.efect
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                self.edited(socid, self.name, _pricea.toCents, self.selectedAvatar)
                
                showSuccess(.operacionExitosa, "SOC Actualizado")
                
            }
            
        }
        else {
            
            API.custSOCV1.createSOC(
                type: type,
                typeid: levelid,
                typeName: levelName,
                codeLevel: .master,
                codeType: socCodeType,
                serviceLevel: serviceLevel,
                fiscCode: fiscCode,
                fiscCodeName: fiscCodeDescription,
                fiscUnit: fiscUnit,
                fiscUnitName: fiscUnitDescription,
                autoExpireAt: Int(autoExpireAt),
                name: name,
                code: code,
                smallDescription: smallDescription,
                description: descr,
                productionCost: _productionCost,
                cost: _cost.toCents,
                pricea: _pricea.toCents,
                priceb: _priceb.toCents,
                pricec: _pricec.toCents,
                pricep: _pricep.toCents,
                operationalObject: operationalObject.map{ $0.id },
                saleActions: saleAction.map{ $0.id },
                saleActionsTime: saleActionsTime,
                saleActionsCost: saleActionsCost,
                saleActionsPoints: saleActionsPoints,
                serviceActions: serviceAction.map{ $0.id },
                serviceActionsTime: serviceActionsTime,
                serviceActionsCost: serviceActionsCost,
                serviceActionsPoints: serviceActionsPoints,
                comisionBy: _comisionBy,
                comision: _comisionAmount,
                inPromo: inPromo,
                createOds: false,
                efect: self.efect
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let soc = resp.data else {
                    showError(.unexpectedResult, "Erro al obtener payload de data")
                    return
                }
                
                self.created(soc)
                
                self.socid = soc.id
                
                showSuccess(.operacionExitosa, "SOC Creado")
                
                self.remove()
            }
            
        }
    }
    
    func addNote() {
     
        if noteText.isEmpty {
            return
        }
        
        guard let socid else{
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.addNote(
            relType: .service,
            rel: socid,
            type: .autoNota,
            activity: noteText
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let note = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }
            
            self.noteText = ""
            
            self.notes.append(note)
            
        }
    }
    
    /*

    var saleActionRefrence: [UUID : ServiceAccionRow] = [:]

    lazy var saleActionDiv = Div()

    var serviceActionRefrence: [UUID : ServiceAccionRow] = [:]

    lazy var serviceActionDiv = Div()
    */

    func removeSaleAction(_ id: UUID) {
        
        var actions: [CustSaleActionQuick] = []
        
        saleAction.forEach { action in
            
            if action.id == id  {
                return
            }
            
            actions.append(action)
        }
        
        saleAction = actions

        if let view = saleActionRefrence[id] {
            view.remove()
        }
         
         saleActionRefrence.removeValue(forKey: id)

    }
    
    func removeServiceAction(_ id: UUID) {
        
        var actions: [CustSaleActionQuick] = []
        
        serviceAction.forEach { action in
            
            if action.id == id  {
                return
            }
            actions.append(action)
        }
        
        serviceAction = actions
        
        if let view = serviceActionRefrence[id] {
            view.remove()
        }
         
         serviceActionRefrence.removeValue(forKey: id)
         
    }
    
    func deleteSOC(){

        guard let socid else {
            return
        }
        
        loadingView(show: true)
        
        Console.clear()

        print("x001")

        API.custSOCV1.deleteSOC(
            socId: socid
        ) { resp in
            
            print("x002")

            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            print("x003")

            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
         
            print("x004")

            self.delete(socid)

            self.remove()
            
        }
    }
    
}

extension ManageSOCView {
    enum ViewMode {
        case general
        case actions
        case documents
        case notes
        case relatedCodes
    }
}

