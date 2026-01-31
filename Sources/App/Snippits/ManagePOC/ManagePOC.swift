//
//  ManagePOC.swift
//  
//
//  Created by Victor Cantu on 9/17/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class ManagePOC: Div {
    
    override class var name: String { "div" }
    
    ///dep, cat, line, main, all
    var leveltype: CustProductType
    
    var levelid: UUID?
    
    var levelName: String
    
    @State var pocid: UUID?
    
    @State var titleText: String
    
    /// Wether it will show all the tooks for creation or not
    let quickView: Bool
    
    /// When you do changes to  soc create a call back to parent view
    private var callback: ((
        _ pocid: UUID,
        _ upc: String,
        _ brand: String,
        _ model: String,
        _ name: String,
        _ cost: Int64,
        _ price: Int64,
        _ avatar: String,
        _ reqSeries: Bool
    ) -> ())
    
    private var deleted: ((
    ) -> ())
    
    init(
        leveltype: CustProductType,
        levelid: UUID?,
        levelName: String,
        pocid: UUID?,
        titleText: String,
        /// Wether it will show all the tooks for creation or not
        quickView: Bool,
        callback: @escaping ( (
            _ pocid: UUID,
            _ upc: String,
            _ brand: String,
            _ model: String,
            _ name: String,
            _ cost: Int64,
            _ price: Int64,
            _ avatar: String,
            _ reqSeries: Bool
        ) -> ()),
        deleted: @escaping ( (
        ) -> ())
        
    ) {
        self.leveltype = leveltype
        self.levelid = levelid
        self.levelName = levelName
        self.pocid = pocid
        self.titleText = titleText
        self.callback = callback
        self.quickView = quickView
        self.deleted = deleted
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let ws = WS()
    
    let viewid = UUID()
    
    @State var totalInventoryCount = 0
    
    @State var currentView: CurrrentView = .inventory
    
    @State var currentThirdPartyStore: ThirdPartyStores? = nil
    
    @State var selectBrandViewIsHidden = true
    @State var selectedBrand: String = ""
    @State var brandCount: Int = 0
    
    @State var depname = ""
    @State var catname = ""
    @State var linename = ""
    @State var store: UUID? = nil
    
    @State var upc: String = ""
    @State var productType: String = ""
    @State var productSubType: String = ""
    @State var brand: String = ""
    @State var model: String = ""
    @State var pseudoModel: String = ""
    @State var name: String = ""
    
    @State var tagOne: String = ""
    @State var tagTwo: String = ""
    @State var tagThree: String = ""
    
    @State var smallDescription: String = ""
    @State var descr: String = ""
    @State var fiscCode: String = ""
    @State var fiscUnit: String = ""
    @State var cost: String = ""
    @State var pricea: String = ""
    @State var priceb: String = ""
    @State var pricec: String = ""
    @State var pricep: String = ""
    @State var pricecr: String = ""
    @State var inCredit: Bool = false
    @State var downPay: String = ""
    @State var monthToPay: String = ""
    ///BreakType
    @State var breakType: String = BreakType.nobreak.rawValue
    @State var breakOne: String = ""
    @State var breakOneText: String = ""
    @State var breakTwo: String = ""
    @State var breakTwoText: String = ""
    @State var breakThree: String = ""
    @State var breakThreeText: String = ""
    @State var minInventory: String = ""
    @State var promo: Bool = false
    @State var providers: [UUID] = []
    @State var appliedTo: [String] = []
    @State var files: [GeneralFile] = []
    @State var comision: String = ""
    @State var points: String = ""
    @State var premier: String = ""
    @State var codes: [String] = []
    @State var warentySelf: String = ""
    @State var warentyProvider: String = ""
    
    @State var highlight: Bool = false
    @State var reqSeries: Bool = false
    @State var maximize: Bool = false
    @State var level: String = "1"
    @State var series: [String] = []
    
    @State var status: GeneralStatus = .active
    
    /// ItemConditions
    @State var conditions: String = ""
    
    @State var editImage: Bool = true
    @State var avatar = "/skyline/media/tierraceroRoundLogoWhite.svg"
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
    
    @State var pricecrTaxText = ""
    @State var pricecrDownPayText = ""
    @State var pricecrMothsText = ""
    
    lazy var costTaxDiv = Div(self.$costTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$costTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .marginBottom(5.px)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var priceaTaxDiv = Div{
        Img()
            .src( "/skyline/media/info2.png" )
            .padding(all: 3.px)
            .paddingLeft(7.px)
            .cursor(.pointer)
            .float(.right)
            .height(24.px)
            .onClick {
                self.loadRevenueDetail(.pricea)
            }
        
        Span(self.$priceaTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        
    }
        .color(self.$priceaTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricebTaxDiv = Div{
        Img()
            .src( "/skyline/media/info2.png" )
            .padding(all: 3.px)
            .paddingLeft(7.px)
            .cursor(.pointer)
            .float(.right)
            .height(24.px)
            .onClick {
                self.loadRevenueDetail(.priceb)
            }
        
        Span(self.$pricebTaxText.map{ $0.isEmpty ? "0.00" : $0 })
    }
        .color(self.$pricebTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricecTaxDiv = Div{
        Img()
            .src( "/skyline/media/info2.png" )
            .padding(all: 3.px)
            .paddingLeft(7.px)
            .cursor(.pointer)
            .float(.right)
            .height(24.px)
            .onClick {
                self.loadRevenueDetail(.pricec)
            }
        
        Span(self.$pricecTaxText.map{ $0.isEmpty ? "0.00" : $0 })
    }
        .color(self.$pricecTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode)
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
    
    lazy var pricecrTaxDiv = Div(self.$pricecrTaxText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricecrTaxText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricecrDownPayDiv = Div(self.$pricecrDownPayText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricecrDownPayText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var pricecrMothsDiv = Div(self.$pricecrMothsText.map{ $0.isEmpty ? "0.00" : $0 })
        .color(self.$pricecrMothsText.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .class(.textFiledBlackDarkReadMode, .oneLineText)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginBottom(5.px)
        .marginTop(5.px)
        .fontSize(20.px)
    
    lazy var brandField = Div(self.$brand.map { $0.isEmpty ? "Marca" : $0 })
        .color(self.$brand.map { ($0.isEmpty) ? .init(r: 119, g: 119, b: 119) : .white })
        .class(.textFiledBlackDark)
        .borderRadius(all: 7.px)
        .paddingLeft(7.px)
        .cursor(.pointer)
        .fontSize(18.px)
        .height(28.px)
    
    lazy var modelField = InputText(self.$model)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Modelo")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }

    lazy var pseudoModelField = InputText(self.$pseudoModel)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Modelo")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var upcField = InputText(self.$upc)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("7500000000001")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var tagOneField = InputText(self.$tagOne)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder(configStoreProduct.tagOne)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var tagTwoField = InputText(self.$tagTwo)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder(configStoreProduct.tagTwo)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var tagThreeField = InputText(self.$tagThree)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder(configStoreProduct.tagThree)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var productTypeField = Div(self.$productType.map{ $0.isEmpty ? "Celular Aceite Libro" : $0 })
    .color(self.$productType.map{ $0.isEmpty ? .grayContrast : .lightGray })
    .class(.textFiledBlackDark, .oneLineText)
    .marginBottom(5.px)
    .textAlign(.left)
    .paddingTop(3.px)
    .cursor(.pointer)
    .marginTop(5.px)
    .fontSize(20.px)
    .onClick {
        self.selectProductType()
    }
    
    lazy var productSubTypeField = Div(self.$productSubType.map{ $0.isEmpty ? "iPhone Motor Terror" : $0 })
        .backgroundColor(self.$productType.map{ $0.isEmpty ? .init(r: 29, g: 32, b: 38, a: 0.5) : .init(r: 29, g: 32, b: 38) })
        .color(self.$productSubType.map{ $0.isEmpty ? .grayContrast : .lightGray })
        .cursor(self.$productType.map{ $0.isEmpty ? .default : .pointer })
        .class(.textFiledBlackDark, .oneLineText)
        .marginBottom(5.px)
        .textAlign(.left)
        .paddingTop(3.px)
        .marginTop(5.px)
        .fontSize(20.px)
        .onClick {
            
            if self.productType.isEmpty {
                return
            }
            
            self.selectProductSubType()
        }
    
    lazy var nameField = InputText(self.$name)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .placeholder("Nombre")
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
        
    lazy var fiscCodeField = FiscCodeField(style: .dark, type: .product) { data in
        self.fiscCode = data.c
    }

    lazy var fiscUnitField = FiscUnitField(style: .dark, type: .product) { data in
        self.fiscUnit = data.c
    }
    
    lazy var costField = InputText(self.$cost)
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
    
    lazy var pricecrField = InputText(self.$pricecr)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0.00")
        .textAlign(.right)
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
    
    lazy var inCreditBox = InputCheckbox().toggle(self.$inCredit)
    
    lazy var downPayField = InputText(self.$downPay)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0 - 100")
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
    
    lazy var monthToPayField = InputText(self.$monthToPay)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("1")
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
    
    ///BreakType
    lazy var breakTypeSelect = Select(self.$breakType)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    lazy var breakOneField = InputText(self.$breakOne)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0 - 99")
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
    
    lazy var breakOneTextField = InputText(self.$breakOneText)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("10")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var breakTwoField = InputText(self.$breakTwo)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("100 - 299")
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
    
    lazy var breakTwoTextField = InputText(self.$breakTwoText)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("15")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var breakThreeField = InputText(self.$breakThree)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("300")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var breakThreeTextField = InputText(self.$breakThreeText)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("20")
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
    
    lazy var minInventoryField = InputText(self.$minInventory)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("0")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    lazy var promoBox = InputCheckbox().toggle(self.$promo)
    
    //appliedTo: [String]
    
    //files: [GeneralFile]
    
    lazy var comisionField = InputText(self.$comision)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("5%")
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
    
    lazy var pointsField = InputText(self.$points)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("100")
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
    
    lazy var premierField = InputText(self.$premier)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("5%")
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
    
    //codes: [String]
    lazy var warentySelfField = InputText(self.$warentySelf)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("En días")
        .height(28.px)
        .textAlign(.right)
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
    
    lazy var warentyProviderField = InputText(self.warentyProvider)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("En meses")
        .height(28.px)
        .textAlign(.right)
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
    
    lazy var highlightBox = InputCheckbox().toggle(self.$highlight)
    
    lazy var reqSeriesBox = InputCheckbox().toggle(self.$reqSeries)
    
    lazy var maximizeBox = InputCheckbox().toggle(self.$maximize)
    
    lazy var levelSelect = Select(self.$level)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    lazy var selectedBrandField = InputText(self.$selectedBrand)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .placeholder("Ingrese Marca")
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
        .onKeyUp { tf, event in
            self.loadBrands()
        }
    
    lazy var brandGrid = Div()
        .custom("height", "calc(100% - 70px)")
        .class(.roundDarkBlue)
        .overflow(.auto)
    
    lazy var noBrandGrid = Div {
        Table{
            Tr{
                Td{
                    Div{
                        
                        Span("No hay marcas registradas")
                        Br()
                        Br()
                        Span("Ingrese marca para crear la...")
                    }
                    .hidden(self.$selectedBrand.map{ !$0.isEmpty })
                    .color(.white)
                    
                    Div( self.$selectedBrand.map{ "Crear marca: \( $0.capitalizingFirstLetters(true) )" } )
                        .class(.uibtnLargeOrange)
                        .custom("width", "calc(100% - 21px)")
                        .hidden(self.$selectedBrand.map{ $0.isEmpty })
                        .onClick {
                            self.createBrand()
                        }
                }
                .align(.center)
                .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(100.percent)
    }
        .custom("height", "calc(100% - 70px)")
        .class(.roundDarkBlue)
    
    lazy var fileInput = InputFile()
        .multiple(self.$editImage.map{ !$0 })
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"]) //, "video/*", ".heic"
        .display(.none)
    
    lazy var pocImageContainer = Div()
        .id(Id(stringLiteral: "pocImageContainer"))
    
    lazy var imageAvatar = Img()
        .src("/skyline/media/tierraceroRoundLogoWhite.svg")
    
    lazy var taxedGrid = Div()
        .class(.roundDarkBlue)
        .maxHeight(150.px)
        .minHeight(45.px)
        .overflow(.auto)
    
    lazy var providerGrid = Div()
        .class(.roundDarkBlue)
        .maxHeight(150.px)
        .width(95.percent)
        .minHeight(70.px)
        .overflow(.auto)
    
    lazy var tagsGrid = Div()
        .class(.roundDarkBlue)
        .maxHeight(150.px)
        .width(95.percent)
        .minHeight(70.px)
        .overflow(.auto)
    
    /// ItemConditions
    lazy var conditionsSelect = Select(self.$conditions)
        .body{
            Option("Seleccione Estado")
                .value("")
        }
        .class(.textFiledBlackDark)
        .height(28.px)
        .width(200.px)
    
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
    
    @State var taxes: Tax = .init(trasladados: nil, retenidos: nil)
    
    var imageRefrence: [UUID:ImagePOCContainer] = [:]
    
    var vendors: [CustVendorsMin] = []
    
    var vendorViews: [UUID:Div] = [:]
    
    var tagsViews: [String:Div] = [:]
    
    lazy var inventoryDiv = Div{
        Table {
            Tr{
                Td("El inventario no se adminstra en una creacion express")
                    .align(.center)
                    .verticalAlign(.middle)
            }
        }
        .width(100.percent)
        .height(200.px)
    }
    
    /// The inventory of what store is being viewed
    @State var selectedInventoryView: String = ""
    
    /// Container  incase no inventory storage has  been selected  but teh decide to add
    var bodSecContainerRefrence: [UUID:Div] = [:]
    
    lazy var selectedInventoryCountView = Div()
    
    lazy var selectedInventorySelect = Select(self.$selectedInventoryView)
        .class(.textFiledBlackDark)
        .height(28.px)
        .width(200.px)
    
    /// On creation of new  POC
    @State var bodegaSelectObserver = ""
    
    /// On creation of new  POC
    var sectionid: UUID? = nil
    
    /// On creation of new  POC
    var sectionName = ""
    
    /// On creation of new  POC
    /// In creation of a new product, the items it currently poses
    @State var currentNewInventory = ""
    
    /// On creation of new  POC
    lazy var bodegaSelect = Select(self.$bodegaSelectObserver)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .height(28.px)
    
    /// On creation of new  POC
    lazy var currentNewInventoryField = InputText(self.$currentNewInventory)
        .placeholder("Inventario actual")
        .class(.textFiledBlackDark)
        .width(50.percent)
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
    
    /// Store ID : CustStoreSeccionesSinc
    var storeInventorySelectedSeccion: [UUID : CustStoreSeccionesSinc] = [:]
    /// Store ID : CustStoreSeccionesSinc
    var storeInventorySelectedBodega: [UUID : CustStoreBodegasSinc] = [:]
    
    @State var misplacedInventory: [CustPOCInventoryIDSale] = []
    
    var storageControles: [POCStorageControlView] = []

    var enremateControler: Enremate? = nil
    
    var claroShopControler: ClaroShop? = nil
    
    var mercadolibreControler: Mercadolibre? = nil
    
    var amazonControler: Amazon? = nil
    
    var ebayControler: EBay? = nil
    
    lazy var enremateDiv = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(270.px)
    
    lazy var claroshopDiv = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(270.px)
    
    lazy var mercadolibreDiv = Div()
        .body(content: {
            Div{
                Table{
                    Tr{
                        Td{
                            Span("⚠️ No ha configurado el perfil de Mercado Libre")
                            Div().clear(.both).height(7.px)
                            Div("+ Agregar Perfil")
                                .hidden(MercadoLibreControler.shared.$profile.map{ $0 == nil })
                                .class(.uibtnLargeOrange)
                                .onClick {
                                    self.addMercadoLibreProfile()
                                }
                            
                        }
                        .verticalAlign(.middle)
                        .align(.center)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }.height(200.px)
        })
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(270.px)
    
    lazy var amazonDiv = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(270.px)
    
    lazy var ebayDiv = Div()
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .overflow(.auto)
        .height(270.px)
    
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
                
                Img()
                    .src("/skyline/media/sendToMobile.png")
                    .hidden(self.$pocid.map{ $0 == nil })
                    .marginRight(12.px)
                    .marginTop(-3.px)
                    .class(.iconWhite)
                    .float(.right)
                    .height(30.px)
                    .onClick {
                        
                        guard let pocid = self.pocid else {
                            return
                        }
                        
                        addToDom(SelectCustUsernameView(
                            type: .all,
                            ignore: [custCatchID],
                            callback: { user in
                                
                                loadingView(show: true)
                                
                                API.custAPIV1.sendToMobile(
                                    type: .product,
                                    targetUser: user.username,
                                    objid: pocid,
                                    smallDescription: "",
                                    description: ""
                                ) { resp in
                                    
                                    loadingView(show: false)
                                    
                                    guard let resp else {
                                        showError(.comunicationError, .unexpenctedMissingPayload)
                                        return
                                    }
                                    
                                    guard resp.status == .ok else {
                                        showError(.generalError, resp.msg)
                                        return
                                    }
                                    
                                    showSuccess(.operacionExitosa, "Elemento Enviado")
                                    
                                }
                            }))
                    }
                
                
                Img()
                    .src("/skyline/media/notificationIcon.png")
                    .hidden(self.$pocid.map{ $0 == nil })
                    .marginLeft(12.px)
                    .cursor(.pointer)
                    .float(.right)
                    .height(30.px)
                    .onClick {
                        
                        guard let pocid = self.pocid else {
                            return
                        }
                        
                        addToDom(RequestTastView(
                            type: .product,
                            relationId: pocid,
                            relationFolio: nil,
                            relationName: (self.model + " " + self.name).purgeSpaces
                        ){
                            
                        })
                    }
                
                H2( self.$pocid.map{ ($0 == nil) ? "Crear Producto" : "Editar Producto" } )
                    .color(.lightBlueText)
                    .float(.left)
                
                H2( self.$pocid.map{ ($0 == nil) ? "Crear en \(self.titleText)" : "Editar \(self.titleText)" } )
                    .hidden(self.$titleText.map{ $0.isEmpty })
                    .marginLeft(12.px)
                    .color(.goldenRod)
                    .float(.left)
                
                Div{
                    Div("Departamento")
                        .color(.lightGray)
                        .fontSize(12.px)
                    
                    H4(self.$depname.map{ "\($0)" })
                        .color(.goldenRod)
                }
                .hidden(self.$depname.map{ $0.isEmpty })
                .marginLeft(12.px)
                .float(.left)
                
                Div{
                    Div("Categoria")
                        .color(.lightGray)
                        .fontSize(12.px)
                    
                    H4( self.$catname.map{ "\($0)" })
                        .color(.goldenRod)
                }
                .hidden(self.$catname.map{ $0.isEmpty })
                .marginLeft(12.px)
                .float(.left)
                
                Div{
                    Div("Linea")
                        .color(.lightGray)
                        .fontSize(12.px)
                    
                    H4( self.$linename.map{ "\($0)" })
                        .color(.goldenRod)
                }
                .hidden(self.$linename.map{ $0.isEmpty })
                .marginLeft(12.px)
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
                        .src(self.avatar)
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
                            
                            Img()
                                .src("/skyline/media/mobileCamara.png")
                                .class(.iconWhite)
                                .marginLeft( 3.px)
                                .cursor(.pointer)
                                .height(28.px)
                                .onClick {
                                    
                                    loadingView(show: true)
                                    
                                    let view: ImagePOCContainer = .init(
                                        type: .img,
                                        mediaid: nil,
                                        pocid: self.pocid,
                                        file: nil,
                                        image: nil,
                                        width: 0,
                                        description: "",
                                        height: 0,
                                        selectedAvatar: self.$selectedAvatar
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
                                    
                                    self.imageRefrence[view.viewid] = view
                                    
                                    API.custAPIV1.requestMobileCamara(
                                        type: .useCamaraForProduct,
                                        connid: custCatchChatConnID,
                                        eventid: view.viewid,
                                        relatedid: self.pocid,
                                        relatedfolio: "",
                                        multipleTakes: !self.editImage
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
                                        
                                        showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
                                        
                                    }
                                }
                        }
                        .float(.left)
                        
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
                    
                    self.pocImageContainer
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
                    Span("Precios")
                    
                    InputCheckbox().toggle(self.$autoCalcCost)
                        .float(.right)
                        .marginTop(-5.px)
                        .marginRight(7.px)
                    
                    Span("Auto Calc")
                        .fontSize(21.px)
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.right)
                    
                    Div("Calc Manual")
                        .color(.lightBlueText)
                        .marginRight(7.px)
                        .fontSize(16.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            var val = self.cost.replace(from: ",", to: "")
                            
                            if val.isEmpty {
                                val = "0"
                            }
                            
                            guard let _cost = Double(val)?.toCents else {
                                return
                            }
                            
                            addToDom(ToolsView.CalculateManualPrice(cost: _cost){ _pricea, _priceb, _pricec in
                                
                                self.pricea = _pricea.formatMoney
                                self.priceb = _priceb.formatMoney
                                self.pricec = _pricec.formatMoney
                                self.pricep = _pricec.formatMoney
                                
                            })
                        }
                    
                    Div("- 16%")
                        .color(.darkOrange)
                        .marginRight(7.px)
                        .fontSize(16.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            var val = self.cost.replace(from: ",", to: "")
                            
                            if val.isEmpty {
                                val = "0"
                            }
                            
                            guard let _cost = Double(val) else {
                                return
                            }
                            
                            self.cost = (_cost - (_cost * Double(0.16))).formatMoney
                            
                        }
                    
                    Div("+ 16%")
                        .color(.chartreuse)
                        .fontSize(16.px)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            var val = self.cost.replace(from: ",", to: "")
                            
                            if val.isEmpty {
                                val = "0"
                            }
                            
                            guard let _cost = Double(val) else {
                                return
                            }
                            
                            self.cost = (_cost + (_cost * Double(0.16))).formatMoney
                            
                        }
                    
                    
                }.color(.lightBlueText)
                
                Div().class(.clear).height(3.px)
                
                Div{
                    
                    // MARK: Product Cost
                    Div{
                        Div("Que costo el producto")
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .height(18.px)
                            .color(.white)
                        
                        Div().class(.clear)
                        
                        Div{
                            Div("Costo")
                                .color(.lightGray)
                                .marginRight(3.px)
                                .fontSize(24.px)
                        }
                        .width(60.percent)
                        .float(.left)
                        
                        Div{
                            self.costField
                        }
                        .width(40.percent)
                        .float(.left)
                        
                    }
                    
                    Div{Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark)}.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    // MARK: Price A
                    Div{
                        
                        Div("Costo al Publico")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(18.px)
                        .color(.white)
                        
                        Div().class(.clear)
                        
                        Div{
                            Div("Precio A")
                                .color(.lightGray)
                                .marginRight(3.px)
                                .fontSize(24.px)
                        }
                        .width(60.percent)
                        .float(.left)
                        
                        Div{
                            self.priceaField
                        }
                        .width(40.percent)
                        .float(.left)
                        
                    }
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    // MARK: Price B
                    Div{
                        Div("Medio Mayoreo")
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .height(18.px)
                            .color(.white)
                        
                        Div().class(.clear)
                        
                        Div{
                            Div("Precio B")
                                .color(.lightGray)
                                .marginRight(3.px)
                                .fontSize(24.px)
                        }
                        .width(60.percent)
                        .float(.left)
                        
                        Div{
                            self.pricebField
                        }
                        .width(40.percent)
                        .float(.left)
                        
                    }
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    // MARK: Price C
                    Div{
                        
                        Div("Costo Mayoreo")
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .height(18.px)
                            .color(.white)
                        
                        Div().class(.clear)
                    
                        Div{
                            Div("Precio C")
                                .color(.lightGray)
                                .marginRight(3.px)
                                .fontSize(24.px)
                        }
                        .width(60.percent)
                        .float(.left)
                        
                        Div{
                            self.pricecField
                        }
                        .width(40.percent)
                        .float(.left)
                    }
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    // MARK: Price C
                    Div{
                        
                        Div("Costo Promocional")
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .height(18.px)
                            .color(.white)
                     
                        Div().class(.clear)
                        
                        Div{
                            Div("Precio Promo")
                                .color(.lightGray)
                                .marginRight(3.px)
                                .fontSize(24.px)
                        }
                        .width(60.percent)
                        .float(.left)
                        
                        Div{
                            self.pricepField
                        }
                        .width(40.percent)
                        .float(.left)
                    }
                    
                }
                //.class(.roundDarkBlue)
                .marginRight(2.percent)
                .padding(all: 3.px)
                .width(49.percent)
                .float(.left)
                
                Div{
                    
                    Div("Sub Total + IVA")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(12.px)
                        .color(.white)
                    
                    self.costTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    Div("Ganacia")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(12.px)
                        .color(.white)
                 
                    self.priceaTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    Div("Ganacia")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(12.px)
                        .color(.white)
                    
                    self.pricebTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    Div("Ganacia")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(12.px)
                        .color(.white)
                    
                    self.pricecTaxDiv
                    
                    Div{ Div().height(1.px).marginRight(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    Div("Ganacia")
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .height(12.px)
                        .color(.white)
                    
                    self.priceprTaxDiv
                    
                    
                }
                .width(45.percent)
                .float(.left)
                
                Div().class(.clear).height(7.px)
                
                H2{
                    Span("Venta a Credito")
                    
                    InputCheckbox().toggle(self.$inCredit)
                        .float(.right)
                        .marginTop(-5.px)
                        .marginRight(7.px)
                    
                    Span("Activar")
                        .fontSize(21.px)
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.right)
                    
                    
                }.color(.lightBlueText)
                
                Div().class(.clear).height(3.px)
                
                Div{
                    
                    /// Credit Cost
                    Div{
                        Label{
                            Div("Precio")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Que precio a credito")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.pricecrField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Down Payment
                    Div{
                        Label{
                            Div("Enganche")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("% de anticipo")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.downPayField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                    /// Month to pay
                    Div{
                        Label{
                            Div("Meses de pago")
                                .color(.lightGray)
                                .marginRight(3.px)
                            Div().class(.clear)
                            Div("Cuantas mensualidades")
                                .class(.oneLineText)
                                .fontSize(12.px)
                                .color(.gray)
                        }
                    }
                    .width(60.percent)
                    .float(.left)
                    
                    Div{
                        self.monthToPayField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    
                }
                .class(.roundDarkBlue)
                .marginRight(2.percent)
                .padding(all: 3.px)
                .width(49.percent)
                .float(.left)
                
                Div{
                    
                    self.pricecrTaxDiv
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    self.pricecrDownPayDiv
                    Div{ Div().height(1.px).marginLeft(20.percent).backgroundColor(.grayBlackDark) }.class(.clear).marginBottom(6.px).paddingTop(4.px)
                    self.pricecrMothsDiv
                }
                .width(45.percent)
                .float(.left)
                
                Div().class(.clear).height(7.px)
                
                H2{
                    Span("Agregados")
                    
                }.color(.lightBlueText)
                
                Div().class(.clear).height(3.px)
                
                Div {
                
                    /// Level
                    Div{
                        Label{
                            Span("Nivel")
                                .color(.lightGray)
                            
                            //Span("Que nivel de usuarios puede tener acceso")
                        }
                        Div{
                            self.levelSelect
                        }
                    }
                    .class(.section)
                    
                    Div().class(.clear)
                    
                    /// Comision
                    Div{
                        Label("Comision")
                            .marginTop(7.px)
                    }
                    .width(60.percent)
                    .paddingTop(4.px)
                    .float(.left)
                    Div{
                        self.comisionField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// Points
                    Div{
                        Label("Pnts. de Prod.")
                    }
                    .width(60.percent)
                    .paddingTop(4.px)
                    .float(.left)
                    Div{
                        self.pointsField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// Rewards
                    Div{
                        Label("Recompensa")
                    }
                    .width(60.percent)
                    .paddingTop(4.px)
                    .float(.left)
                    Div{
                        self.premierField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                }
                .marginRight(2.percent)
                .width(48.percent)
                .float(.left)
                
                Div {
                    
                    /// Highlight
                    Div{
                        Label("Destacado")
                            .color(.lightGray)
                    }
                    .width(60.percent)
                    .paddingTop(7.px)
                    .float(.left)
                    Div{
                        self.highlightBox
                            .float(.right)
                    }
                    .align(.right)
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// PowerSale
                    Div{
                        Label("Power Sale")
                            .color(.lightGray)
                    }
                    .width(60.percent)
                    .paddingTop(7.px)
                    .float(.left)
                    Div{
                        self.maximizeBox
                            .float(.right)
                    }
                    .align(.right)
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// Serie Requerida
                    Div{
                        Label("Serie Requerida")
                            .color(.lightGray)
                    }
                    .width(60.percent)
                    .paddingTop(7.px)
                    .float(.left)
                    Div{
                        self.reqSeriesBox
                            .float(.right)
                    }
                    .align(.right)
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// Internal Warenty
                    Div{
                        Label("Garantia Interna")
                            .color(.lightGray)
                    }
                    .width(60.percent)
                    .float(.left)
                    Div{
                        self.warentySelfField
                    }
                    .width(40.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginBottom(7.px)
                    
                    /// External Warenty
                    Div{
                        Label("Garantia Externa")
                            .color(.lightGray)
                    }
                    .width(60.percent)
                    .float(.left)
                    Div{
                        self.warentyProviderField
                    }
                    .align(.right)
                    .width(40.percent)
                    .float(.left)
                    
                    
                }
                .width(49.percent)
                .float(.left)
                
                Div().class(.clear).marginTop(3.px)
                
                /// Providers
                Div{
                    Span("Provedores")
                        .color(.lightGray)
                    
                    Img()
                        .src("/skyline/media/add.png")
                        .marginRight(7.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(24.px)
                        .onClick {
                            addToDom(SearchVendorView(loadBy: nil, callback: { vendor in
                                self.addVendor(id: vendor.id, name: "\(vendor.rfc) \(vendor.businessName)")
                            }))
                        }
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.providerGrid
                    
                }
                .width(50.percent)
                .float(.left)
                
                /// Tags
                Div{
                    Span("Etiquetas")
                        .color(.lightGray)
                    
                    Img()
                        .src("/skyline/media/add.png")
                        .marginRight(3.px)
                        .cursor(.pointer)
                        .float(.right)
                        .height(24.px)
                        .onClick {
                            addToDom(AddTagView(currentTags: self.appliedTo, callback: { tag in
                                self.addTag(tag: tag)
                            }))
                        }
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    self.tagsGrid
                }
                .width(50.percent)
                .float(.left)
                
                Div().class(.clear).marginTop(7.px)
                
                
            }
            .custom("height", "calc(100% - 40px)")
            .overflow(.auto)
            .class(.oneHalf)
            
            Div {
                Div{
                    
                    H2("Datos del Producto").color(.lightBlueText)
                    
                    Div().class(.clear).marginTop(3.px)
                    
                    Div{
                        H2("Estado").color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        self.conditionsSelect
                    }
                    .width(50.percent)
                    .float(.left)
                
                    Div().class(.clear).height(7.px)
                    
                    /// Product Type
                    Div{
                        Div{
                            Label("Tipo")
                                .color(.lightGray)
                                .marginRight(3.px)
                            
                            Label("[R]").color(.red)
                        }
                        
                        Div{
                            self.productTypeField
                        }
                        .custom("width", "calc(100% - 7px)")
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    /// Product SubType sipermitrina
                    Div{
                        
                        Div{
                            Label("Sub Tipo (opcional)").color(.lightGray)
                        }
                        
                        Div{
                            self.productSubTypeField
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).height(7.px)
                    
                    /// Brand, UPC /SKU / POC
                    Div{
                        /// Brand
                        Label("Marca").color(.lightGray)
                        Div{
                            self.brandField
                                .onClick {
                                    self.getBrands()
                                }
                        }
                        .custom("width", "calc(100% - 7px)")
                        
                        Div().class(.clear).height(7.px)
                        
                        /// UPC /SKU / POC
                        Div{
                            
                            Img()
                                .src("/skyline/media/icon_print.png")
                                .marginRight(12.px)
                                .class(.iconWhite)
                                .float(.right)
                                .height(24.px)
                                .onClick {
                                    
                                    guard let pocid = self.pocid else {
                                        return
                                    }
                                    
                                    guard let pricea = Float(self.pricea.replace(from: ",", to: ""))?.toCents else {
                                        showError(.invalidFormat, "Ingrese  \"Precio Publico\" valido para usar esta herramienta.")
                                        self.priceaField.select()
                                        return
                                    }
                                            
                                    
                                    if self.upc.isEmpty {
                                        showError(.requiredField, "Ingrese \"SKU / UPC / POC\" para usar esta herramienta")
                                        self.upcField.select()
                                        return
                                    }
                                    
                                    addToDom(PrintBarcodes(barodes: [.init(
                                        id: pocid,
                                        upc: self.upc,
                                        brand: self.brand,
                                        model: self.model,
                                        name: self.name,
                                        price: pricea
                                    )]))
                                }
                                .hidden(self.$pocid.map { $0 == nil })
                            
                            Label("SKU / UPC / POC").color(.lightGray)
                        }
                        
                        Div{
                            self.upcField
                                .onBlur {
                                    self.storeFreeUPC()
                                }
                        }
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    /// Model, Name
                    Div{
                        
                        /// Model
                        Label("Modelo").color(.lightGray)
                        
                        Div{
                            self.modelField
                                .onBlur {
                                    self.storeFreeModel()
                                }
                        }
                        
                        Div().class(.clear).height(3.px)
                        
                        /// Name
                        Label("Pseudo Modelo").color(.lightGray)
                        Div{
                            self.pseudoModelField
                        }
                        
                        Div().class(.clear).marginTop(3.px)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    

                    Div().class(.clear).height(7.px)
                    

                    /// Name
                    Label("Nombre").color(.lightGray)
                    Div{
                        self.nameField
                    }
                    
                    Div().class(.clear).height(7.px)
                    
                    /* configStoreProduct */
                    
                    if !configStoreProduct.tagOne.isEmpty || !configStoreProduct.tagTwo.isEmpty  || !configStoreProduct.tagThree.isEmpty {
                    
                        Div {
                            
                            if !configStoreProduct.tagOne.isEmpty {
                                
                                Div{
                                    
                                    Label(configStoreProduct.tagOne).color(.lightGray)
                                    
                                    Div().class(.clear).height(3.px)
                                    
                                    Div{
                                        self.tagOneField
                                    }
                                    
                                    Div().class(.clear).marginTop(3.px)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                            }
                            
                            if !configStoreProduct.tagTwo.isEmpty {
                                
                                Div{
                                    
                                    Label(configStoreProduct.tagTwo).color(.lightGray)
                                    
                                    Div().class(.clear).height(3.px)
                                    
                                    Div{
                                        self.tagTwoField
                                    }
                                    
                                    Div().class(.clear).marginTop(3.px)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                            }
                            
                            if !configStoreProduct.tagThree.isEmpty {
                                
                                Div{
                                    
                                    Label(configStoreProduct.tagThree).color(.lightGray)
                                    
                                    Div().class(.clear).height(3.px)
                                    
                                    Div{
                                        self.tagThreeField
                                    }
                                    
                                    Div().class(.clear).marginTop(3.px)
                                    
                                }
                                .width(50.percent)
                                .float(.left)
                            }
                            
                        }
                        
                        Div().class(.clear).height(7.px)
                        
                    }
                    
                    /// Small Descriotion
                    Div{
                        Label("Descripcion Corta").color(.lightGray)
                        Div{
                            self.smallDescriptionField
                        }
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    /// General Descriotion
                    Div{
                        /// General Descriotion
                        Label("Descripcion").color(.lightGray)
                        Div{
                            self.descriptionField
                        }
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).height(7.px)
                    
                    /// fiscCode
                    Div{
                        Label("Codigo Producto Fiscal").color(.lightGray)
                        self.fiscCodeField
                            .position(.relative)
                            
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    /// fiscUnit
                    Div{
                        Label("Codigo Unidad Fiscal").color(.lightGray)
                        self.fiscUnitField
                            .position(.relative)
                            
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear).marginTop(7.px)
                    
                    /// Taxes
                    Div{
                        Label{
                            Img()
                                .src("/skyline/media/add.png")
                                .marginRight(3.px)
                                .cursor(.pointer)
                                .float(.right)
                                .width(35.px)
                                .onClick {
                                    
                                }
                            Span("Impuestos")
                        }.color(.lightGray)
                        self.taxedGrid
                    }
                    .custom("width", "calc(100% - 7px)")
                    .class(.section)
                    
                    Div().class(.clear).marginTop(3.px)
                
                    if (customerServiceProfile?.profile ?? []).contains(.thirdPartyOnlineStores) {
                        
                        H2("Tiendas de Terceros").color(.lightBlueText)
                        
                        /// Inventory and Notes Header
                        Div{
                            
                            H2("Mercado Libre")
                                .backgroundColor(self.$currentThirdPartyStore.map{ ($0 == .mercadolibre) ? .black : .transparent})
                                .borderTopRightRadius(12.px)
                                .borderTopLeftRadius(12.px)
                                .marginRight(12.px)
                                .padding(all:7.px)
                                .cursor(.pointer)
                                .fontSize(18.px)
                                .float(.left)
                                .onClick {
                                    self.currentThirdPartyStore = .mercadolibre
                                }
                            
                            Div().class(.clear)
                        }
                        
                        self.enremateDiv
                            .hidden(self.$currentThirdPartyStore.map{ $0 != .enremate })
                        
                        self.claroshopDiv
                            .hidden(self.$currentThirdPartyStore.map{ $0 != .claroshop })
                        
                        self.mercadolibreDiv
                            .hidden(self.$currentThirdPartyStore.map{ $0 != .mercadolibre })
                        
                        self.amazonDiv
                            .hidden(self.$currentThirdPartyStore.map{ $0 != .amazon })
                        
                        self.ebayDiv
                            .hidden(self.$currentThirdPartyStore.map{ $0 != .ebay })
                        
                        Div().class(.clear).height(7.px)
                    
                    }
                    
                    
                    if self.pocid == nil {
                        H2("Inventario")
                            .color(.lightBlueText)
                    }
                    else{
                        
                        /// Inventory and Notes Header
                        Div{
                            
                            Div{
                                
                                Img()
                                    .src("/skyline/media/alert.png")
                                    .marginLeft(7.px)
                                    .height(18.px)
                                
                                Span("Error Inventario")
                            }
                                .hidden(self.$misplacedInventory.map{ $0.isEmpty })
                                .class(.uibtnLargeOrange)
                                .float(.right)
                                .onClick {
                                    addToDom(ConfirmView(type: .ok, title: "Modulo no activo", message: "Este modulo no esa activo contacte a Soprte TC para activar este modulo y compober su inventario", callback: { isConfirmed, comment in
                                        
                                    }))
                                }
                            
                            H2("Inventario")
                                .backgroundColor(self.$currentView.map{ ($0 == .inventory) ? .black : .transparent})
                                .borderTopRightRadius(12.px)
                                .borderTopLeftRadius(12.px)
                                .marginRight(12.px)
                                .padding(all:7.px)
                                .cursor(.pointer)
                                .fontSize(18.px)
                                .float(.left)
                                .onClick {
                                    self.currentView = .inventory
                                }
                        
                            H2("Notas")
                                .backgroundColor(self.$currentView.map{ ($0 == .notes) ? .black : .transparent})
                                .borderTopRightRadius(12.px)
                                .borderTopLeftRadius(12.px)
                                .marginRight(12.px)
                                .padding(all:7.px)
                                .cursor(.pointer)
                                .fontSize(18.px)
                                .float(.left)
                                .onClick {
                                    self.currentView = .notes
                                }
                                
                            Div().class(.clear)
                        }
                        
                    }
                    
                    self.inventoryDiv
                    .hidden(self.$currentView.map{ ($0 != .inventory) })
                    .custom("width", "calc(100% - 7px)")
                    .class(.roundGrayBlackDark)
                    .minHeight(250.px)
                    
                    if self.pocid != nil {
                        
                        Div{
                            Div{
                                self.notesGrid
                            }
                            .padding(all: 3.px)
                            .class(.roundBlue)
                            .margin(all: 3.px)
                            .overflow(.auto)
                            .height(250.px)
                            
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
                        .hidden(self.$currentView.map{ ($0 != .notes) })
                        .custom("width", "calc(100% - 7px)")
                        .class(.roundGrayBlackDark)
                        
                    }
                    
                    Div().class(.clear).marginTop(12.px)
                    
                }
                .custom("height", "calc(100% - 20px)")
                .marginBottom(7.px)
                .overflow(.auto)
                
                Div{
                    
                    Div{
                        Img()
                            .src(self.$pocid.map{ ($0 == nil) ? "/skyline/media/add.png" : "/skyline/media/diskette.png" })
                            .height(18.px)
                            .marginRight(7.px)
                        
                        Span(self.$pocid.map{ ($0 == nil) ? "Crear Producto" : "Guardar Cambio" })
                            .color(.darkOrange)
                            .fontSize(18.px)
                        
                    }
                    .marginRight(18.px)
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        self.savePoc()
                    }
                    
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/icon_pending@128.png")
                                .height(18.px)
                                .marginRight(7.px)
                            
                            Span("Pausar")
                                .color(.darkOrange)
                                .fontSize(18.px)
                            
                        }
                        .hidden(self.$pocid.map{ ($0 == nil) })
                        .marginRight(18.px)
                        .class(.uibtn)
                        .float(.left)
                        .onClick {
                            self.pausePoc()
                        }
                        
                        if custCatchHerk > 1 {
                            Div{
                                Img()
                                    .src("/skyline/media/cross.png")
                                    .height(18.px)
                                    .marginRight(7.px)
                                
                                Span("Eliminar")
                                    .color(.darkOrange)
                                    .fontSize(18.px)
                                
                            }
                            .hidden(self.$pocid.map{ ($0 == nil) })
                            .marginRight(18.px)
                            .class(.uibtn)
                            .float(.left)
                            .onClick {
                                self.deletePoc()
                            }
                        }
                        
                        Div().clear(.both)
                        
                    }
                    .hidden(self.$status.map{ ($0 != .active) })
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/round.png")
                                .height(18.px)
                                .marginRight(7.px)
                            
                            Span("reactivar")
                                .color(.darkOrange)
                                .fontSize(18.px)
                            
                        }
                        .hidden(self.$pocid.map{ ($0 == nil) })
                        .marginRight(18.px)
                        .class(.uibtn)
                        .float(.left)
                        .onClick {
                            self.activatePOC()
                        }
                        
                    }
                    .hidden(self.$status.map{ ($0 != .suspended) })
                    .float(.left)
                    
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
        .top(45.px)
        
        /// Select Brand View
        Div{
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView4)
                        .onClick{
                            self.selectBrandViewIsHidden = true
                        }
                    
                    H2("Selecciona Marca")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                
                self.selectedBrandField
                    .marginBottom(7.px)
                
                self.brandGrid
                    .hidden(self.$brandCount.map { $0  == 0})
                
                self.noBrandGrid
                    .hidden(self.$brandCount.map { $0 > 0})
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(50.percent)
            .width(40.percent)
            .left(30.percent)
            .top(25.percent)
            
        }
        .custom("height", "calc(100% - 110px)")
        .custom("left", "calc(50% - 575px)")
        .class(.transparantBlackBackGround)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(1150.px)
        .color(.white)
        .top(45.px)
        .hidden(self.$selectBrandViewIsHidden)
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        fiscCodeField.fiscCodeField.height(28.px)
        
        fiscUnitField.fiscUnitField.height(28.px)
        
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
            
            if self.pocid == nil {
                _path = "https://\(custCatchUrl)/iCatch/"
            }
            else{
                if let pDir = customerServiceProfile?.account.pDir {
                    _path = "https://intratc.co/cdn/\(pDir)/"
                }
            }
            
            self.imageAvatar
                .load("\(_path)thump_\($0)")
            
            if let pocid = self.pocid {
                self.callback( pocid, self.upc, self.brand, self.model, self.name, (Float(self.cost.replace(from: ",", to: "")) ?? 0).toCents, (Float(self.pricea.replace(from: ",", to: "")) ?? 0).toCents, $0, self.reqSeries)
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
            
            if $0 {
                
                var val = self.cost.replace(from: ",", to: "")
                
                if val.isEmpty {
                    val = "0"
                }
                
                guard let _cost = Double(val)?.toCents else {
                    return
                }
                let sugestedPrices = PriceRanger.getSugestedPrice(
                    cost: _cost,
                    ranges: configStoreProcessing.productPriceRange
                )
                
                self.pricea = sugestedPrices.pricea.formatMoney
                
                self.priceb = sugestedPrices.priceb.formatMoney
                
                self.pricec = sugestedPrices.pricec.formatMoney
                
                self.pricep = sugestedPrices.pricec.formatMoney
                
            }
            
        }
        
        $cost.listen {
            
            var val = $0.replace(from: ",", to: "")
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Double(val)?.toCents else {
                return
            }
            
            print("💎  totalTaxes \(self.totalTaxes)")
            print("💎  totalTaxes \(self.totalTaxes)")
            print("💎  totalTaxes \(self.totalTaxes)")
            
            self.taxModifire = ((((self.totalTaxes + 1.0) * 0.25) * 100.0) * 100000).rounded() / 100000
            
            self.costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100

            self.paidTaxes = ((_cost.fromCents - self.costSubTotal) * 100).rounded() / 100
            
            self.costTaxText = "\(self.costSubTotal.formatMoney) (\(self.paidTaxes.formatMoney))"
            
            if self.autoCalcCost {
                
                let sugestedPrices = PriceRanger.getSugestedPrice(
                    cost: _cost,
                    ranges: configStoreProcessing.productPriceRange
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
            
            guard let _price = Float(val.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            let _costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let _paidTaxes = ((_cost.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subTotalRevenue = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let pricePaidTax = ((_price.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            let taxDiffrance = pricePaidTax - _paidTaxes
            
            // 4900 = (5900 - 1000)
            let revenue = (_price.fromCents - _cost.fromCents) - taxDiffrance
            
            self.priceaTaxText = revenue.formatMoney
            
        }
        
        $priceb.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            let _costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let _paidTaxes = ((_cost.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subTotalRevenue = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let pricePaidTax = ((_price.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            let taxDiffrance = pricePaidTax - _paidTaxes
            
            // 4900 = (5900 - 1000)
            let revenue = (_price.fromCents - _cost.fromCents) - taxDiffrance
            
            self.pricebTaxText = revenue.formatMoney
            
        }
        
        $pricec.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            let _costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let _paidTaxes = ((_cost.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subTotalRevenue = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let pricePaidTax = ((_price.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            let taxDiffrance = pricePaidTax - _paidTaxes
            
            // 4900 = (5900 - 1000)
            let revenue = (_price.fromCents - _cost.fromCents) - taxDiffrance
            
            self.pricecTaxText = revenue.formatMoney
            
        }
        
        $pricep.listen {
            
            var val = $0
            
            if val.isEmpty {
                val = "0"
            }
            
            guard let _cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            guard let _price = Float(val.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            let _costSubTotal = (((_cost.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let _paidTaxes = ((_cost.fromCents - _costSubTotal) * 100).rounded() / 100
            
            let subTotalRevenue = (((_price.fromCents * 25.0) / self.taxModifire) * 100).rounded() / 100
            
            let pricePaidTax = ((_price.fromCents - subTotalRevenue) * 100).rounded() / 100
            
            let taxDiffrance = pricePaidTax - _paidTaxes
            
            // 4900 = (5900 - 1000)
            let revenue = (_price.fromCents - _cost.fromCents) - taxDiffrance
            
            self.pricepTaxText = revenue.formatMoney
            
        }
        
        $pricecr.listen {
            
            guard let _price = Float(($0.isEmpty) ? "0" : $0.replace(from: ",", to: "")) else{
                return
            }
            
            let _costSubTotal = (((_price * 25.0) / self.taxModifire) * 100).rounded() / 100
            let _paidTaxes = ((_price - _costSubTotal) * 100).rounded() / 100
            
            self.pricecrTaxText = "\(_costSubTotal.formatMoney) [\(_paidTaxes.formatMoney)]"
            
            self.calcCredit()
        }
        
        $downPay.listen {
            self.calcCredit()
        }
        
        $monthToPay.listen {
            self.calcCredit()
        }
        
        $reqSeries.listen { isRequired in
            self.storageControles.forEach { view in
                view.reqSeries = isRequired
            }
        }

        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event else {
                return
            }
            
            switch event {
            case .requestMobileCamaraComplete:
                
                if let payload = self.ws.requestMobileCamaraComplete($0) {
                    
                    if let view = self.imageRefrence[payload.eventid] {
                        
                        view.loadPercent = ""
                        
                        view.mediaid = payload.id
                        
                        view.width = payload.width
                        
                        view.height = payload.height
                        
                        view.file = payload.file
                        
                        view.image = payload.avatar
                        
                        view.loadImage(payload.avatar, edit: self.editImage)
                        
                        var hasAvatar = false
                        
                        self.imageRefrence.forEach { _, view in
                            if view.isAvatar {
                                hasAvatar = true
                            }
                        }
                        
                        if !hasAvatar {
                            view.setAsAvatar(image: payload.avatar)
                        }
                        
                    }
                }
            case .requestMobileCamaraFail:
                if let payload = self.ws.requestMobileCamaraFail($0) {
                    
                    if  let view = self.imageRefrence[payload.eventid] {
                        self.imageRefrence.removeValue(forKey: view.viewid)
                        view.remove()
                    }
                    
                }
            case .requestMobileCamaraInitiate:
                if let payload = self.ws.requestMobileCamaraInitiate($0) {
                    
                    if  let view = self.imageRefrence[payload.eventid] {
                        
                        self.pocImageContainer.appendChild(view)
                        
                        _ = JSObject.global.scrollToBottom!("pocImageContainer")
                        
                    }
                    
                }
            case .requestMobileCamaraProgress:
                
                guard let payload = self.ws.requestMobileCamaraProgress($0) else {
                    return
                }
                
                guard let view = self.imageRefrence[payload.eventid] else {
                    return
                }
                
                view.loadPercent = "\(payload.percent.toString)%"
                
            case .asyncFileUpload:
                
                if let payload = self.ws.asyncFileUpload($0) {
                    
                    if let view = self.imageRefrence[payload.eventid] {

                        view.isLoaded = true
                        
                        view.loadPercent = ""
                        
                        view.mediaid = payload.mediaid
                        
                        view.width = payload.width
                        
                        view.height = payload.height
                        
                        var edit = self.editImage
                        
                        if payload.type != .image {
                            edit = false
                        }
                        
                        view.file = payload.fileName
                        
                        view.image = payload.fileName
                        
                        view.loadImage(payload.avatar, edit: edit)
                        
                        var hasAvatar = false
                        
                        self.imageRefrence.forEach { _, view in
                            if view.isAvatar {
                                hasAvatar = true
                            }
                        }
                        
                        if !hasAvatar {
                            view.setAsAvatar(image: payload.avatar)
                        }
                        
                    }
                }
                
            case .asyncFileUpdate:
                
                guard let payload = self.ws.asyncFileUpdate($0) else {
                    return
                }
                
                guard let view = self.imageRefrence[payload.eventId] else {
                    return
                }
                
                view.loadPercent = payload.message
                
            case .asyncFileOCR:
                break
            case .asyncCropImage:
                
                guard let payload = self.ws.asyncCropImage($0) else {
                    return
                }
                guard let view = self.imageRefrence[payload.eventid] else {
                    return
                }
                
                view.isLoaded = true
                
                view.loadPercent = ""
                
                view.file = payload.fileName
                
                view.image = payload.fileName
                
                view.loadImage( payload.fileName )
                
                if view.isAvatar {
                    self.selectedAvatar = payload.fileName
                    view.isAvatar = true
                }
            default:
                break
            }
        }
        
        UsernameRoles.allCases.forEach { role in
            let option = Option(role.description)
                .value(role.value.toString)
            
            if role.value > custCatchHerk {
                option.disabled(true)
            }
            levelSelect.appendChild(option)
        }
        
        ItemConditions.allCases.forEach { item in
            conditionsSelect.appendChild(
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
        
        if pocid == nil && quickView == false {
            /// draw add inventory  only one seleccion
            inventoryDiv.innerHTML = ""
            
            var bods: [CustStoreBodegasSinc] = []
            
            bodegas.forEach { id, bod in
                if bod.custStore == custCatchStore {
                    
                    bods.append(bod)
                    
                    bodegaSelect.appendChild(
                        Option(bod.name)
                            .value(bod.id.uuidString)
                    )
                }
            }
            
            guard let bodega = bods.first else {
                showError(.generalError, "No se localizo bodega de la tienda. Refresque o asegurese que su configuracion sea la correcta.")
                return
            }
            
            bodegaSelectObserver = bodega.id.uuidString
            
            let sectionSelectField = SectionSelectField(
                storeid: custCatchStore,
                storeName: stores[custCatchStore]?.name ?? "",
                bodid: bodega.id,
                bodName: bodega.name,
                callback: { section in
                    
                    self.sectionid = section.id
                    
                    self.sectionName = section.name
                    
                })
            
            inventoryDiv.appendChild(Div{
                /// bodega
                Div{
                    Label("Bogeda")
                        .color(.gray)
                    Div{
                        self.bodegaSelect
                    }
                }
                .class(.section)
                
                /// seccion
                Div{
                    Label("Seccion")
                        .paddingTop(11.px)
                        .width(30.percent)
                        .marginLeft(5.px)
                        .marginTop(2.px)
                        .float(.left)
                        .color(.gray)
                    
                    Div{
                        sectionSelectField
                            .position(.relative)
                    }
                    .marginLeft(35.percent)
                    .paddingTop(5.px)
                }
                
                /// units
                Div{
                    Label("Unidades Actuales")
                        .color(.gray)
                    
                    Div{
                        self.currentNewInventoryField
                    }
                }
                .class(.section)
            })
        }
        
        if let pocid {
            
            loadingView(show: true)
            
            API.custPOCV1.getPOC(
                id: pocid,
                full: true
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError( .comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError( .generalError, resp.msg)
                    return
                }

                guard let payload = resp.data else {
                    showError( .unexpectedResult, "No se obtuvo payload de respuesta.")
                    return
                }
                
                self.loadPOCData(payload: payload)
             
            }
        }
        
        if (customerServiceProfile?.profile ?? []).contains(.thirdPartyOnlineStores) {
            currentThirdPartyStore = .mercadolibre
        }
    }
    
    override func didAddToDOM() {
        if pocid == nil {
            getBrands()
        }
    }

    func loadPOCData(payload data: CustPOCComponents.GetPOCReponse) {
        
        if let id = data.poc.custStoreLines {
            levelid = id
            levelName = data.custLine
            leveltype = .line
        }
        else if let id = data.poc.custStoreCats {
            levelid = id
            levelName = data.custCat
            leveltype = .cat
        }
        else if let id = data.poc.custStoreDeps {
            levelid = id
            levelName = data.custDep
            leveltype = .dep
        }
        else{
            levelName = "-Sin Departamento-"
            leveltype = .main
        }
        
        depname = data.custDep
        
        catname = data.custCat
        
        linename = data.custLine
        
        conditions = data.poc.conditions.rawValue
        
        selectedBrand = data.poc.brand

        upc = data.poc.upc
        
        tagOne = data.poc.tagOne
        
        tagTwo = data.poc.tagTwo
        
        tagThree = data.poc.tagThree
        
        productType = data.poc.productType
        
        productSubType = data.poc.productSubType
        
        if !upc.isEmpty {
            upcField.class(.isOk)
        }
        
        brand = data.poc.brand
        
        model = data.poc.model

        pseudoModel = (data.poc.pseudoModel.isEmpty ? ( Date().year.toString.suffix(2) + "-" + callKey(3) + "-" + callKey(4) ) : data.poc.pseudoModel)
        
        if !model.isEmpty {
            modelField.class(.isOk)
        }
        
        name = data.poc.name
        smallDescription = data.poc.smallDescription
        descr = data.poc.description
        
        fiscCode = data.poc.fiscCode
        
        fiscCodeField.fiscCodeField.text = "\(fiscCode) \(data.fiscCode)"
        fiscCodeField.fiscCodeField.class(.isOk)
        fiscCodeField.currentCode = fiscCode
        fiscCodeField.fiscCodeIsSelected = true
        
        fiscUnit = data.poc.fiscUnit
        
        fiscUnitField.fiscUnitField.text = "\(fiscUnit) \(data.fiscUnit)"
        fiscUnitField.fiscUnitField.class(.isOk)
        fiscUnitField.currentCode = fiscUnit
        fiscUnitField.fiscUnitIsSelected = true

        print("🟡 001")

        cost = data.poc.cost.formatMoney.replace(from: ",", to: "")
        pricea = data.poc.pricea.formatMoney.replace(from: ",", to: "")
        priceb = data.poc.priceb.formatMoney.replace(from: ",", to: "")
        pricec = data.poc.pricec.formatMoney.replace(from: ",", to: "")
        pricep = data.poc.pricep.formatMoney.replace(from: ",", to: "")
        pricecr = data.poc.pricecr.formatMoney.replace(from: ",", to: "")

        print("🟡 002")

        inCredit = data.poc.inCredit

        downPay = data.poc.downPay.formatMoney

        monthToPay =  data.poc.monthToPay.formatMoney

        breakType = data.poc.breakType.rawValue
        breakOne = data.poc.breakOne.toString
        breakOneText = data.poc.breakOneText
        breakTwo = data.poc.breakTwo.toString
        breakTwoText = data.poc.breakTwoText
        breakThree = data.poc.breakThree.toString
        breakThreeText = data.poc.breakThreeText
        
        minInventory = data.poc.minInventory.toString
        print("🟡 002c")
        /// this will populated on a forEach
        /// providers = data.poc.providers
        
        /// this will populated on a forEach
        /// appliedTo = data.poc.appliedTo
        
        comision = data.poc.comision?.toString ?? ""
        
        points = data.poc.points?.toString ?? ""
        
        premier = data.poc.premier?.toString ?? ""


        print("🟡 002d")


        codes = data.poc.codes
        warentySelf = data.poc.warentySelf.toString
        warentyProvider = data.poc.warentyProvider.toString
        
        highlight = data.poc.highlight
        
        reqSeries = data.poc.reqSeries
        
        maximize = data.poc.maximize
        
        level = data.poc.level.toString
        

        print("🟡 003")


        data.images.forEach { image in
            
            if image.width == 0 || image.height == 0 {
                
                API.custAPIV1.correctImageSizeRegistration(
                    type: .product,
                    relid: data.poc.id,
                    fileid: image.id,
                    fileName: image.avatar
                ) { resp in
                    
                    guard let resp else {
                        return
                    }
                    
                    guard resp.status == .ok else {
                        return
                    }
                    
                    guard let size = resp.data else{
                        return
                    }
                    
                    let view: ImagePOCContainer = .init(
                        type: image.type,
                        mediaid: image.id ,
                        pocid: self.pocid,
                        file: image.file,
                        image: image.avatar,
                        width: size.width,
                        description: image.description,
                        height: size.height,
                        selectedAvatar: self.$selectedAvatar
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
                    
                    self.imageRefrence[view.viewid] = view
                    
                    self.pocImageContainer.appendChild(view)
                    
                    if image.isAvatar {
                        self.selectedAvatar = image.avatar
                        view.isAvatar = true
                    }
                    
                }
            }
            else{
                
                let view: ImagePOCContainer = .init(
                    type: image.type,
                    mediaid: image.id ,
                    pocid: self.pocid,
                    file: image.file,
                    image: image.avatar,
                    width: image.width,
                    description: image.description,
                    height: image.height,
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
                
                self.pocImageContainer.appendChild(view)
                
                if image.isAvatar {
                    self.selectedAvatar = image.avatar
                    view.isAvatar = true
                }
                
            }
        }
        
        status = data.poc.status
        
        var cc = 0
        
        data.notes.forEach { note in
            let view = QuickMessageObject(isEven: cc.isEven, note: note)
            notesGrid.appendChild(view)
            cc += 1
        }



        print("🟡 004")


        data.vendors.forEach { vendor in
            self.addVendor(id: vendor.id, name: "\(vendor.businessName) \(vendor.rfc)")
        }
        
        data.poc.appliedTo.forEach { tag in
            self.addTag(tag: tag)
        }
        
        /// StoreID : CustStoreProductSection
        var bodSecRefrence: [UUID:CustStoreProductSection] = [:]
        
        data.secs.forEach { sec in
            bodSecRefrence[sec.storeid] = sec
        }
        

        print("🟡 005")


        inventoryDiv.innerHTML = ""
        
        inventoryDiv.appendChild(Div{
            
            Div{
                
                H3("Total de inventario:")
                    .color(.goldenRod)
                    .float(.left)
                
                Span(self.$totalInventoryCount.map{ $0.toString } )
                    .fontSize(18.px)
                    .float(.right)
                    .color(.goldenRod)
                
            }
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                H3("Ver inventario de:")
                    .color(.white)
                    .float(.left)
                
                self.selectedInventorySelect
                    .float(.right)
                
                self.selectedInventoryCountView
                    .marginRight(7.px)
                    .fontSize(23.px)
                    .float(.right)
                    .color(.white)
                
            }
            
            Div().class(.clear).marginBottom(7.px)
            
        }.margin(all: 7.px))
        

        print("🟡 006")


        let storsIds: [UUID] = stores.map{ $0.key }
        
        var itemsStoreRefrence: [UUID:[CustPOCInventoryIDSale]] = [:]
        
        data.generalInventory.forEach { item in
            
            if !storsIds.contains(item.custStore){
                misplacedInventory.append(item)
                return
            }
            
            if let _ = itemsStoreRefrence[item.custStore] {
                itemsStoreRefrence[item.custStore]?.append(item)
            }
            else{
                itemsStoreRefrence[item.custStore] = [item]
            }
            
        }
        
        print("🟡 007")

        stores.forEach { storeid, store in
            
            @State var count: Int = 0
            
            /// This var is not need sonce only one bodega per store is going to be permited for the moment
            /// in the future it is posible  we may activated
            //@State var bodegaObserver = ""
            
            let option = Option(store.name)
                .value(store.id.uuidString)
            
            if storeid == custCatchStore {
                option.selected(true)
            }
            
            self.selectedInventorySelect.appendChild(option)
            
            selectedInventoryCountView.appendChild(
                Span($count.map{ $0.toString })
                    .hidden(self.$selectedInventoryView.map{ $0 != storeid.uuidString })
            )
            if let storagePlace = bodSecRefrence[storeid] {
                
                let items: [CustPOCInventoryIDSale] = itemsStoreRefrence[storeid] ?? []
                
                totalInventoryCount += items.count
                
                loadStorageView(
                    storeid: storeid,
                    store: store,
                    storagePlace: storagePlace,
                    countListener: $count,
                    items: items
                )
            }
            else{
                let view = Div{
                    Table{
                        Tr{
                            Td{
                                Span("Seleccionar Bodega / Seccion a \(store.name)")
                                Div("Seleccionar Almacen")
                                    .custom("max-width", "calc(100% - 21px)")
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        
                                        addToDom(POCAddStorageView(
                                            pocid: data.poc.id,
                                            storeid: store.id,
                                            storeName: store.name,
                                            callback: { storagePlace, items in
                                                
                                                guard let container = self.bodSecContainerRefrence[storeid] else{
                                                    showError(.unexpectedResult, "Refreaque la pnatalla para cagar la nueva seccion.")
                                                    return
                                                }
                                                
                                                guard let pocid = self.pocid else {
                                                    showError(.unexpectedResult, "No se localizo  id del producto refreaque la pnatalla para cagar la nueva seccion.")
                                                    return
                                                }
                                                let view = POCStorageControlView(
                                                    pocid: pocid,
                                                    pocName: "\(self.upc) \(self.name) \(self.model)".purgeSpaces,
                                                    reqSeries: self.reqSeries,
                                                    storeId: storeid,
                                                    store: store,
                                                    storagePlace: storagePlace,
                                                    countListener: $count,
                                                    items: items)
                                                { bodega in
                                                    self.storeInventorySelectedBodega[storeid] = bodega
                                                } updateSeccion: { section in
                                                    self.storeInventorySelectedSeccion[storeid] = section
                                                } updateInventoryCount: { units in
                                                    self.totalInventoryCount += units
                                                }

                                                container.innerHTML = ""
                                                
                                                container.appendChild(
                                                    view
                                                    .hidden(self.$selectedInventoryView.map{ $0 != storeid.uuidString })
                                                    .custom("height", "calc(100% - 35px)")
                                                )
                                                
                                                self.storageControles.append(view)
                                                
                                            }))
                                    }
                            }
                            .align(.center)
                            .verticalAlign(.middle)
                        }
                    }
                    .width(100.percent)
                    .height(100.percent)
                }
                    .hidden(self.$selectedInventoryView.map{ $0 != storeid.uuidString })
                    .height(100.percent)
                
                self.bodSecContainerRefrence[storeid] = view
                
                self.inventoryDiv.appendChild(view)
                
            }
        }
        
        print("🟡 008")

        selectedInventoryView = custCatchStore.uuidString
        
        print("🟡 008")

        if (customerServiceProfile?.profile ?? []).contains(.thirdPartyOnlineStores) {
            
            mercadolibreDiv.innerHTML = ""
            
            if let _ = MercadoLibreControler.shared.profile, let productProfile = data.mercadoLibre {
                
                mercadolibreControler = Mercadolibre(
                    productType: self.$productType,
                    productSubType: self.$productSubType,
                    brand: self.$brand,
                    model: self.$model,
                    name: self.$name,
                    mercadoLibre: productProfile
                )
                
                mercadolibreDiv.appendChild(mercadolibreControler!)
            }
            else {
                
                mercadolibreDiv.appendChild(Div{
                    Table{
                        Tr{
                            Td{
                                Span("⚠️ No ha configurado el perfil de Mercado Libre")
                                Div().clear(.both).height(7.px)
                                Div("+ Agregar Perfil")
                                    .hidden(MercadoLibreControler.shared.$profile.map{ $0 == nil })
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        self.addMercadoLibreProfile()
                                    }
                                
                            }
                            .verticalAlign(.middle)
                            .align(.center)
                        }
                    }
                    .height(100.percent)
                    .width(100.percent)
                }.height(200.px))
            }
            
        }
    
        print("🟢 009")



    }
    
    func addMercadoLibreProfile(){
        
        guard let profile = MercadoLibreControler.shared.profile else {
            showError(.unexpectedResult, "No se ha conectado a Mercado Libre.")
            return
        }
        
        mercadolibreDiv.innerHTML = ""
        
        mercadolibreControler = Mercadolibre(
            productType: self.$productType,
            productSubType: self.$productSubType,
            brand: self.$brand,
            model: self.$model,
            name: self.$name,
            mercadoLibre: .init(
                productId: nil,
                categoryId: nil,
                inventoryId: nil,
                siteId: profile.siteId,
                autoPause: false,
                saleStatus: .active,
                price: .pricea,
                allowInPromoPrice: false
            )
        )
        
        mercadolibreDiv.appendChild(mercadolibreControler!)
    }
    
    func loadStorageView( storeid: UUID, store: CustStore, storagePlace: CustStoreProductSection, countListener: State<Int>, items: [CustPOCInventoryIDSale]){
        
        guard let pocid = self.pocid else {
            showError(.unexpectedResult, "No se localizo  id del producto refreaque la pnatalla para cagar la nueva seccion.")
            return
        }
        
        let view = POCStorageControlView(
            pocid: pocid,
            pocName: "\(self.upc) \(self.name) \(self.model)".purgeSpaces,
            reqSeries: self.reqSeries,
            storeId: storeid,
            store: store,
            storagePlace: storagePlace,
            countListener: countListener,
            items: items)
        { bodega in
            self.storeInventorySelectedBodega[storeid] = bodega
        } updateSeccion: { section in
            self.storeInventorySelectedSeccion[storeid] = section
        } updateInventoryCount: { units in
            self.totalInventoryCount += units
        }

        inventoryDiv.appendChild(
            view
            .hidden(self.$selectedInventoryView.map{ $0 != storeid.uuidString })
            .custom("height", "calc(100% - 35px)")
        )
        
        self.storageControles.append(view)
        
    }
    
    func loadMedia(_ file: File) {
        
        let fileSize = (file.size / 1000 / 1000)

        if file.type.contains("video") || file.type.contains("image") {
            if  fileSize > 30 {
                showError(.generalError, "No se pueden subir archivoa de mas de 30 mb")

                return 
            }
        }

        let xhr = XMLHttpRequest()
        
        let view: ImagePOCContainer = .init(
            type: .img,
            mediaid: nil,
            pocid: self.pocid,
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
        
        xhr.onLoadStart { event in
            self.pocImageContainer.appendChild(view)
            _ = JSObject.global.scrollToBottom!("pocImageContainer")
        }
        
        xhr.onError { jsValue in
            showError(.comunicationError, .serverConextionError)
            //self.uploadPercent = ""
            self.imageRefrence.removeValue(forKey: view.viewid)
            view.remove()
        }
        
        xhr.onLoadEnd {
            
            print("⭐️ onLoadEnd 001")
            
            view.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                showError(.generalError, .serverConextionError + " 001")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                showError(.generalError, .serverConextionError + " 002")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    self.imageRefrence.removeValue(forKey: view.viewid)
                    view.remove()
                    return
                }
                
                guard let process = resp.data else {
                    showError(.generalError, "No se pudo cargar datos")
                    self.imageRefrence.removeValue(forKey: view.viewid)
                    view.remove()
                    return
                }
                
                switch process {
                case .processing(_):
                    
                    view.loadPercent = "processando..."
                    view.chekUploadState(wait: 7)
                    
                case .processed(let payload):
                    
                    guard let mediaid = payload.mediaid else {
                        showAlert(.alerta, "Fotosubida pero no se pudo cargar, refresque y preporte el error a Soporte TC")
                        return
                    }
                    
                    view.mediaid = mediaid
                    view.width = payload.width
                    view.height = payload.height
                    
                    view.file = payload.avatar
                    
                    view.image = payload.avatar
                    
                    view.loadImage(payload.avatar, edit: self.editImage)
                    
                    var hasAvatar = false
                    
                    self.imageRefrence.forEach { _, view in
                        if view.isAvatar {
                            hasAvatar = true
                        }
                    }
                    
                    if !hasAvatar {
                        print("🟢  i dont have avatar ")
                        view.setAsAvatar(image: payload.avatar)
                    }
                    else{
                        print("🟡  i do have avatar ")
                    }
                    
                }
                
            }
            catch {
                showError(.generalError, .serverConextionError + " 003")
                self.imageRefrence.removeValue(forKey: view.viewid)
                view.remove()
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            
            let event = ProgressEvent(_event.jsEvent)
            
            view.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
            print("PROGRESS 002 \(view.loadPercent)")
            
        }
        
        xhr.onProgress { event in
            print("⭐️ onProgress 002")
            print(event.loaded)
            print(event.total)
        }
        
        let fileName =  safeFileName(name: file.name, to: nil, folio: nil)
        
        let formData = FormData()
        
        formData.append("file", file, filename: fileName)
        
        xhr.open(method: "POST", url: "https://intratc.co/api/cust/v1/uploadManager")
        
        xhr.setRequestHeader("eventid", view.viewid.uuidString)
        
        xhr.setRequestHeader("to", ImagePickerTo.product.rawValue)
        
        if let id = self.pocid?.uuidString {
            xhr.setRequestHeader("id", id)
        }
        
        xhr.setRequestHeader("fileName", fileName)
        
        xhr.setRequestHeader("connid", custCatchChatConnID)
        
        xhr.setRequestHeader("remoteCamera", false.description)
        
        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
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
            to: .product,
            relid: pocid,
            subId: nil,
            isAvatar: isAvatar,
            mediaid: mediaid,
            path: path,
            originalImage: originalImage,
            originalWidth: originalWidth,
            originalHeight: originalHeight
        ) { 
            if let view = self.imageRefrence[viewid] {
                view.loadPercent = "Trabajando"
                view.isLoaded = false
                view.chekCropState(wait: 7)
            }
        }
        
        
        addToDom(editor)
    }
    
    func getBrands() {
        
        if !brands.isEmpty {
            loadBrands()
            
            selectedBrandField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.getBrands { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            brands = data
            
            self.loadBrands()
            
            self.selectedBrandField.select()
        }
        
    }
    
    func loadBrands() {
        
        brandCount = brands.count
        
        selectBrandViewIsHidden = false
        
        brandGrid.innerHTML = ""
        
        if selectedBrand.isEmpty {
            brands.forEach { brand in
                brandGrid.appendChild(
                    Div(brand.brand)
                        .custom("width", "calc(100% - 21px)")
                        .class(.uibtnLarge)
                        .onClick {
                            self.selectBrand(brand.brand)
                        }
                )
            }
        }
        else {
            
            var includedIds: [UUID] = []
            
            brands.forEach { brand in
                
                if brand.brand.lowercased().hasPrefix(selectedBrand.lowercased()) {
                    
                    includedIds.append(brand.id)
                    
                    brandGrid.appendChild(
                        Div(brand.brand)
                            .custom("width", "calc(100% - 21px)")
                            .class(.uibtnLarge)
                            .onClick {
                                self.selectBrand(brand.brand)
                            }
                    )
                    
                }
                
            }
            
            brands.forEach { brand in
                
                if includedIds.contains(brand.id) { return }
                
                if brand.brand.lowercased().contains(selectedBrand.lowercased()) {
                    
                    includedIds.append(brand.id)
                    
                    brandGrid.appendChild(
                        Div(brand.brand)
                            .custom("width", "calc(100% - 21px)")
                            .class(.uibtnLarge)
                            .onClick {
                                self.selectBrand(brand.brand)
                            }
                    )
                }
            }
            
            if includedIds.isEmpty {
                
                brandGrid.appendChild(
                    Table{
                        Tr{
                            Td{
                                
                                Div( self.$selectedBrand.map{ "Crear marca: \( $0.capitalizingFirstLetters(true) )" } )
                                    .custom("max-width", "calc(100% - 21px)")
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        self.createBrand()
                                    }
                            }
                            .align(.center)
                            .verticalAlign(.middle)
                        }
                    }
                    .width(100.percent)
                    .height(100.percent)
                )
                
            }
            
        }
    }
    
    func selectBrand(_ _brand: String) {
        
        selectedBrand = ""
        
        selectBrandViewIsHidden = true
        
        brand = _brand
        
        modelField.select()
        
        storeFreeModel()
        
    }
    
    func storeFreeModel() {
        
        if model.isEmpty { return }
        
        modelField
            .removeClass(.isOk)
            .removeClass(.isNok)
            .class(.isLoading)
        
        API.custAPIV1.storeFreeModel(
            code: model,
            brand: brand,
            isRental: false,
            id: pocid
        ) { resp in
            
            loadingView(show: false)
            
            self.modelField
                .removeClass(.isOk)
                .removeClass(.isNok)
                .removeClass(.isLoading)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            if data.free {
                self.modelField
                    .class(.isOk)
            }
            else{
                self.modelField
                    .class(.isNok)
            }
        }
    }
    
    func storeFreeUPC() {
        
        if upc.isEmpty { return }
        
        upcField
            .removeClass(.isOk)
            .removeClass(.isNok)
            .class(.isLoading)
        
        API.custAPIV1.storeFreeUPC(
            code: upc,
            brand: brand,
            isRental: false,
            id: pocid
        ) { resp in
            
            loadingView(show: false)
            
            self.upcField
                .removeClass(.isOk)
                .removeClass(.isNok)
                .removeClass(.isLoading)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            if data.free {
                self.upcField
                    .class(.isOk)
            }
            else{
                self.upcField
                    .class(.isNok)
            }
        }
    }
    
    func createBrand() {
        
        if selectedBrand.isEmpty {
            return
        }
        
        self.appendChild(ConfirmView(
            type: .yesNo,
            title: "Crear Marca",
            message: "Confirm creacion de:\n\"\(selectedBrand.capitalizingFirstLetters(true))\"") { isConfirmed, comment in
                if isConfirmed {
                    
                    loadingView(show: true)
                    
                    API.custPOCV1.addBrands(brand: self.selectedBrand.capitalizingFirstLetters(true)) { resp in
                        
                        loadingView(show: false)
                        
                        guard let resp = resp else {
                            showError(.comunicationError, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok else{
                            showError(.generalError, resp.msg)
                            return
                        }
                        
                        guard let data = resp.data else {
                            showError(.unexpectedResult, .unexpenctedMissingPayload)
                            return
                        }
                        
                        
                        guard let brandid = data.id else{
                            showError(.unexpectedResult, "No se puede obtener id de la marca. Contacte a Soporte TC")
                            return
                        }
                        
                        if !data.brandExist {
                            brands.append(.init(
                                id: brandid,
                                modifiedAt: data.modifiedAt,
                                brand: data.brand
                            ))
                        }
                        
                        self.selectBrand(data.brand)
                    }
                }
            }
        )
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
    
    func calcCredit(){

        pricecrDownPayText =  ""
        pricecrMothsText = ""
        
        guard let _price = Float((pricecr.isEmpty) ? "0" : pricecr) else{
            return
        }
        
        guard var _downpay = Float((downPay.isEmpty) ? "0" : downPay) else{
            return
        }
        
        if _downpay < 0 {
            _downpay = 0.0
        }
        
        if _downpay > 100 {
            _downpay = 100.0
        }
        
        guard let _mrp = Float((monthToPay.isEmpty) ? "0" : monthToPay) else{
            return
        }
        
        if _downpay <= 0 {
            return
        }
        
        let downPaymet = (_price * (_downpay / 100.0)).rounded()
        
        pricecrDownPayText = "\(downPaymet.formatMoney) Enganche"
        
        if _mrp <= 0 {
            return
        }
        
        let balance = _price - downPaymet
        
        pricecrMothsText =  "\((balance / _mrp).formatMoney) Mensualidades"
        
    }
    
    func savePoc() {
         
        if upc.isEmpty{
            upc = "7\(getNow().toString)"
        }

         //Modelo
         if model.isEmpty && name.isEmpty {
             showError(.requiredField, "Ingrese modelo o nombre del producto")
             return
         }
        
        //Modelo
         if pseudoModel.isEmpty {
             pseudoModel = generatePseudoModel()
         }
         
         //fiscode
         if fiscCode.isEmpty {
             showError(.requiredField, "Codigo fiscal")
             return
         }
        
         //fiscunit
         if fiscUnit.isEmpty {
             showError(.requiredField, "Unidad Fiscal")
             return
         }
         //cost i
        
        guard let _cost = Float(cost.replace(from: ",", to: "")) else {
            showError(.requiredField, "Costo Interno Requerido")
            return
        }
        
        guard let _pricea = Float(pricea.replace(from: ",", to: "")) else {
            showError(.requiredField, "Precio A Requerido")
            return
        }
        
        if priceb.isEmpty { priceb = pricea }
        
        if pricec.isEmpty { pricec = priceb }
        
        if pricep.isEmpty { pricep = priceb }
        
        guard let _priceb = Float(priceb.replace(from: ",", to: "")) else {
            return
        }
        
        guard let _pricec = Float(pricec.replace(from: ",", to: "")) else {
            return
        }
        
        guard let _pricep = Float(pricep.replace(from: ",", to: "")) else {
            return
        }
        
        let _pricecr = Float(pricecr.replace(from: ",", to: "")) ?? 0.0
        
        let _downPay = Float(downPay.replace(from: ",", to: "")) ?? 0.0
        
        let _monthToPay = Float(monthToPay.replace(from: ",", to: "")) ?? 0.0
        
         if inCredit {
             
             guard _pricecr > 0 else{
                 showError(.requiredField, "Para activar inCredit se requiere Costo Credito")
                 return
             }
             
             guard _downPay > 0 else{
                 showError(.requiredField, "Para activar inCredit se requiere Enganche")
                 return
             }
             
             guard _monthToPay > 0 else{
                 showError(.requiredField, "Para activar inCredit se requiere Mese de Credito")
                 return
             }
             
         }
        
        let _comision: Double? = Double(comision.replace(from: ",", to: ""))
        
        let _points: Double? = Double(points.replace(from: ",", to: ""))
        
        let _premier: Double? = Double(premier.replace(from: ",", to: ""))
        
        let _warentSelf = Float(warentySelf.replace(from: ",", to: "")) ?? 0
        
        let _warentProvider = Float(warentyProvider.replace(from: ",", to: "")) ?? 0
        
        imageRefrence.forEach { id, item in
            
            guard let image = item.image else {
                return
            }
            
            files.append(.init(
                file: image,
                files: [image],
                width: item.width,
                height: item.height
            ))
        }
        
        guard let conditions = ItemConditions(rawValue: self.conditions) else {
            showError(.requiredField, "Seleccione estado de producto")
            return
        }
        
        //MARK: Process Third Party Stores
        
        var amazon: CustPOC.Amazon? = nil
        
        var claroShop: CustPOC.ClaroShop? = nil
        
        var ebay: CustPOC.EBay? = nil
        
        var enremate: CustPOC.EnRemate? = nil
        
        var mercadoLibre: CustPOC.MercadoLibre? = nil
        
        if (customerServiceProfile?.profile ?? []).contains(.thirdPartyOnlineStores) {
            
            //MARK: Process Mercado Libre
            if MercadoLibreControler.shared.profile != nil {
                
                if let mercadolibreControler {
                    
                    /*
                    guard (_warentSelf > 0 || _warentProvider > 0) else {
                        showError(.generalError, "Ingrese por lo menos una garantia.")
                        return
                    }
                    */
                    
                    let productId: String? = (mercadolibreControler.productId.isEmpty) ? nil : mercadolibreControler.productId
                    
                    let categoryId = mercadolibreControler.categoryId
                    
                    let inventoryId = mercadolibreControler.inventoryId
                    
                    let siteId = mercadolibreControler.siteId
                    
                    let autoPause = mercadolibreControler.autoPause
                    
                    let saleStatus = mercadolibreControler.saleStatus
                    
                    let isActive = mercadolibreControler.isActive
                    
                    if categoryId.isEmpty {
                        showError(.generalError, "Configure Categoria de Mercado Libre")
                        return
                    }
                    
                    guard let price = PriceType(rawValue: mercadolibreControler.priceTypeListener) else {
                        showError(.generalError, "Selecicone el precio a usar en Mercado Libre")
                        return
                    }
                    
                    let allowInPromoPrice = mercadolibreControler.allowInPromoPrice
                    
                    mercadoLibre = .init(
                        productId: productId,
                        categoryId: categoryId,
                        inventoryId: inventoryId,
                        siteId: siteId,
                        autoPause: autoPause,
                        saleStatus: saleStatus,
                        price: price,
                        allowInPromoPrice: allowInPromoPrice
                    )
                    
                }
            }
            
        }
        
        if let pocid {
            
            var secs: [CustPOCComponents.ProdInventorySecction] = []
            
            var error: String? = nil
            
            storageControles.forEach { vc in
                
                guard error == nil else {
                    return
                }
                
                guard let bodid = vc.bodegaid else {
                    error = "No ha seleccionado bodega para tienda \(vc.store.name)"
                    return
                }
                
                guard let bodega = bodegas[bodid] else {
                    error = "No ha localizo bodega para tienda \(vc.store.name)"
                    return
                }
                
                guard let secid = vc.seccionid else{
                    error = "No ha seleccionado seccion para tienda \(vc.store.name)"
                    return
                }
                
                guard let section = seccions[secid] else {
                    error = "No ha localizo bodega para tienda \(vc.store.name)"
                    return
                }
                
                secs.append(.init(
                    store: vc.storeId,
                    bodID: bodega.id,
                    bod: bodega.name,
                    secID: section.id,
                    sec: section.name
                ))
                
            }
            
            if let error {
                showError(.generalError, error)
                return
            }
            
            var imgs: [CustPOCComponents.ImagesMetaData] = []
            
            imageRefrence.forEach { id, view in
                
                guard let mediaid = view.mediaid else {
                    return
                }
                
                imgs.append(.init(
                    id: mediaid,
                    text: view.descr
                ))
            }
            
            loadingView(show: true)
            
            API.custPOCV1.updateProduct(
                pocid: pocid,
                upc: upc,
                productType: productType,
                productSubType: productSubType,
                brand: brand,
                model: model,
                pseudoModel: pseudoModel,
                name: name,
                tagOne: tagOne,
                tagTwo: tagTwo,
                tagThree: tagThree,
                smallDescription: smallDescription,
                description: descr,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                cost: _cost.toCents,
                pricea: _pricea.toCents,
                priceb: _priceb.toCents,
                pricec: _pricec.toCents,
                pricep: _pricep.toCents,
                pricecr: _pricecr.toCents,
                inCredit: inCredit,
                downPay: _downPay,
                monthToPay: _monthToPay.toInt,
                breakType: BreakType(rawValue: breakType) ?? .nobreak,
                breakOne: Float(breakOne) ?? 10,
                breakOneText: breakOneText,
                breakTwo: Float(breakTwo) ?? 20,
                breakTwoText: breakTwoText,
                breakThree: Float(breakThree) ?? 30,
                breakThreeText: breakThreeText,
                promo: promo,
                highlight: highlight,
                providers: providers,
                appliedTo: appliedTo,
                comision: _comision,
                points: _points,
                premier: _premier,
                codes: codes,
                warentySelf: _warentSelf.toInt,
                warentyProvider: _warentProvider.toInt,
                reqSeries: reqSeries,
                maximize: maximize,
                minInventory: Float(minInventory) ?? 0,
                level: Int(level) ?? 1,
                inventorySecction: secs,
                imagesMetaData: imgs,
                conditions: conditions,
                amazon: amazon,
                claroShop: claroShop,
                ebay: ebay,
                enremate: enremate,
                mercadoLibre: mercadoLibre
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
                
                showSuccess(.operacionExitosa, "Porducto Actulizado")
                
                self.callback(
                    pocid,
                    self.upc,
                    self.brand,
                    self.model,
                    self.name,
                    _cost.toCents,
                    _pricea.toCents,
                    self.avatar,
                    self.reqSeries
                )
                
            }
        }
        else{
            
            let bodid = UUID(uuidString: bodegaSelectObserver)
            
            var bodName = ""
            
            var secName = ""
            
            if let bodid {
                if let bodega = bodegas[bodid] {
                    bodName = bodega.name
                }
            }
            
            if let sectionid {
                if let seccion = seccions[sectionid] {
                    secName = seccion.name
                }
            }
            
            let inventory = Float(currentNewInventory) ?? 0
            
            if inventory > 0 && secName.isEmpty {
                showError(.generalError, "No ingrese seccion para el inventario.")
                return
            }
            
            loadingView(show: true)
            
            API.custPOCV1.createProduct(
                productCreateType: leveltype,
                productCreateUUID: levelid,
                productCreateSeccionName: levelName,
                store: custCatchStore,
                upc: upc,
                productType: productType,
                productSubType: productSubType,
                brand: brand,
                model: model,
                name: name,
                tagOne: tagOne,
                tagTwo: tagTwo,
                tagThree: tagThree,
                smallDescription: smallDescription,
                description: descr,
                fiscCode: fiscCode,
                fiscUnit: fiscUnit,
                cost: _cost.toCents,
                pricea: _pricea.toCents,
                priceb: _priceb.toCents,
                pricec: _pricec.toCents,
                pricep: _pricep.toCents,
                pricecr: _pricecr.toCents,
                inCredit: inCredit,
                downPay: _downPay,
                monthToPay: _monthToPay.toInt,
                breakType: .nobreak,
                breakOne: 10.0,
                breakOneText: "",
                breakTwo: 20.0,
                breakTwoText: "",
                breakThree: 30.0,
                breakThreeText: "",
                curStoreBodega: bodid,
                curStoreBodegaName: bodName,
                curStoreSeccion: sectionid,
                curStoreSeccionName: secName,
                minInventory: 0,
                promo: promo, 
                highlight: highlight,
                providers: providers,
                appliedTo: appliedTo,
                files: files,
                comision: _comision,
                points: _points,
                premier: _premier,
                codes: codes,
                warentySelf: _warentSelf,
                warentyProvider: _warentProvider,
                reqSeries: reqSeries,
                curInventory: inventory,
                maximize: maximize,
                level: Int(level) ?? 1,
                oneTimeUse: false,
                series: [],
                conditions: conditions,
                amazon: amazon,
                claroShop: claroShop,
                ebay: ebay,
                enremate: enremate,
                mercadoLibre: mercadoLibre
            ) { resp in
                
                loadingView(show: false)

                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }

                guard let pocid = resp.data?.pocid else {
                    showError(.generalError, "No se localizo id de la cuenta.")
                    return
                }
                
                self.callback(
                    pocid,
                    self.upc,
                    self.brand,
                    self.model,
                    self.name,
                    _cost.toCents,
                    _pricea.toCents,
                    self.avatar,
                    self.reqSeries
                )
                
                self.remove()
                
            }
        }
        
     }
    
    func deletePoc() {
        
        guard let pocid else {
            return
        }
        
        guard let pDir = customerServiceProfile?.account.pDir else {
            return
        }
        
        addToDom(ConfirmView(type: .yesNo, title: "Confirme eliminación", message: "¿Realmente desea eliminar el producto \(self.name.uppercased())?"){ isConfirm, reason in
             
            loadingView(show: true)
            
            API.custPOCV1.deletePOC(
                id: pocid,
                pDir: pDir
            ) { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Producto Eliminado")
                
                self.status = .canceled
                
                self.deleted()
                
                self.remove()
                    
            }
            
        })
        
    }
    
    func pausePoc(){
        
        guard let pocid else {
            return
        }
        
        addToDom(ConfirmView(type: .yesNo, title: "Confirme Pausa", message: "¿Realmente desea pausar el producto \(self.name.uppercased())?"){ isConfirm, reason in
             
            loadingView(show: true)
            
            API.custPOCV1.pausePOC(
                pocId: pocid
            ) { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                self.status = .suspended
                
            }
            
        })
        
    }
    
    func activatePOC(){
        
        guard let pocid else {
            return
        }
        
       loadingView(show: true)
       
       API.custPOCV1.activatePOC(
           pocId: pocid
       ) { resp in
       
           loadingView(show: false)
           
           guard let resp else {
               showError(.comunicationError, .serverConextionError)
               return
           }
           
           guard resp.status == .ok else{
               showError(.generalError, resp.msg)
               return
           }
           
           self.status = .active
               
       }
        
    }
    
    func addVendor(id : UUID, name: String) {
        
        providers.append(id)
        
        let view = Div {
            
            Img()
                .src("/skyline/media/cross.png")
                .float(.right)
                .marginRight(7.px)
                .cursor(.pointer)
                .width(18.px)
                .onClick({ _, event in
                    addToDom(ConfirmView(type: .acceptDeny, title: "Eliminar Etoqueta", message: "Confirme el eliminar etiqueta.", callback: { isConfirmed, comment in
                        if isConfirmed {
                            self.remmoveVendor(id: id)
                        }
                    }))
                    event.stopPropagation()
                })
            
            Div(name)
                .custom("width", "calc(100% - 36px)")
                .class(.oneLineText)
                .marginRight(7.px)
            
            
        }
            .marginTop(3.px)
            .marginBottom(4.px)
            .width(92.percent)
            .class(.uibtn)
            .onClick {
                addToDom(SearchVendorView(loadBy: .id(id), callback: { vendor in
                    
                }))
            }
        
        vendorViews[id] = view
        
        providerGrid.appendChild(view)
        
    }
    
    func remmoveVendor(id: UUID){
        if let view = vendorViews[id] {
            view.remove()
            vendorViews.removeValue(forKey: id)
        }
    }
    
    func addTag(tag: String){
        
        appliedTo.append(tag)
        
        let view = Div {
            
            Img()
                .src("/skyline/media/cross.png")
                .float(.right)
                .marginRight(7.px)
                .cursor(.pointer)
                .width(18.px)
                .onClick({ _, event in
                    addToDom(ConfirmView(type: .acceptDeny, title: "Eliminar Vendor", message: "Confirme el eliminar vendor.", callback: { isConfirmed, comment in
                        if isConfirmed {
                            self.remmoveTag(tag: tag)
                        }
                    }))
                    event.stopPropagation()
                })
            
            Div(tag)
                .custom("width", "calc(100% - 36px)")
                .class(.oneLineText)
                .marginRight(7.px)
            
        }
            .marginTop(3.px)
            .marginBottom(4.px)
            .width(92.percent)
            .class(.uibtn)
        
        tagsViews[tag] = view
        
        tagsGrid.appendChild(view)
        
    }
    
    func remmoveTag(tag: String) {
        //self.tagsGrid.appendChild(view)
        if let view = tagsViews[tag] {
            view.remove()
            tagsViews.removeValue(forKey: tag)
        }
    }
    
    func addNote() {
     
        if noteText.isEmpty {
            return
        }
        
        guard let pocid else{
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.addNote(
            relType: .product,
            rel: pocid,
            type: .autoNota,
            activity: noteText
        ) { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.generalError, resp.msg)
                return
            }
            
            guard let note = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }
            
            self.noteText = ""

            let view = QuickMessageObject(isEven: true, note: note)
            
            self.notesGrid.appendChild(view)
            
        }
    }
    
    func selectProductType(){
        addToDom(SelectProductType(productType: self.productType){ result in
            self.productType = result
        })
    }
    
    func selectProductSubType(){
        addToDom(SelectProductSubType(
            productType: self.productType,
            productSubType: self.productSubType
        ) { result in
                self.productSubType = result
        })
    }
    
    func loadRevenueDetail(_ type: PriceType){
        
        var price: Int64 = 0
        
        switch type {
        case .pricea:
            
            guard let _price = Float(pricea.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            price = _price
            
        case .priceb:
            
            guard let _price = Float(priceb.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            price = _price
            
        case .pricec:
            
            guard let _price = Float(pricec.replace(from: ",", to: ""))?.toCents else {
                return
            }
            
            price = _price
            
        }
        
        guard let cost = Float(self.cost.isEmpty ? "0" : self.cost.replace(from: ",", to: ""))?.toCents else {
            return
        }
        
        addToDom(RevenuePreview(
            price: price,
            cost: cost
        ))
        
    }
    
}

extension ManagePOC {
    enum CurrrentView {
        case inventory
        case notes
    }
    enum ThirdPartyStores {
        case enremate
        case claroshop
        case mercadolibre
        case amazon
        case ebay
    }
}
