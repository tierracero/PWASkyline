//
//  ToolFiscal.swift
//  
//
//  Created by Victor Cantu on 10/21/22.
// searchAccountFiscal

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscal: Div {
    
    override class var name: String { "div" }
    
    /// manual, order{id}, sale{id}, loadFiscalDoc{id}
    @State var loadType: LoadType
    
    @State var cartaPorte: FiscalCartaPorte?
    
    @State var folio: String?
    
    private var callback: ((
        /// Document Fiscal Row ID
        _ id: UUID,
        /// Fiscal Profile Folio
        _ folio: String,
        /// PDF File Name
        _ pdf: String,
        /// XML File Name
        _ xml: String
    ) -> ())
    
    /// - Parameters:
    ///   - loadType: manual, order{id}, sale{id}, loadFiscalDoc{id}
    ///   - folio: manual, order{id}, sale{id}, loadFiscalDoc{id} human readable folio
    ///   - callback: Document Fiscal ID,  Fiscal Profile Folio, PDF File Name, XML File Name
    init(
        loadType: LoadType,
        folio: String?,
        callback: @escaping ((
            /// Document Fiscal ID
            _ id: UUID,
            /// Fiscal Profile Folio
            _ folio: String,
            /// PDF File Name
            _ pdf: String,
            /// XML File Name
            _ xml: String

        ) -> ())
    ) {
        self.loadType = loadType
        self.folio  = folio
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var eventid: UUID = .init()
    
    @State var verifyDropDownIsHidden = true
    
    @State var lockPrices = false
    
    @State var substractedTaxCalculation: Bool = true
    
    @State var subTotal = ""
    
    @State var discount = ""
    
    @State var trasTotal = ""
    
    @State var retTotal = ""
    
    @State var total = ""
    
    @State var items: [FiscalItem] = []
    
    @State var itemViews: [ToolFiscalItemView] = []
    
    @State var selectFiscalProfileIsHidden: Bool = true
    
    @State var selectPackage: CustTCSOCObject? = nil
    
    @State var profiles: [FiscalEndpointV1.Profile] = fiscalProfiles
    
    @State var profile: FiscalEndpointV1.Profile? = nil
    
    @State var reciver: CustAcctFiscal? = nil
    
    @State var reciverRazon = ""
    
    @State var reciverRfc = ""
    
    @State var reciverZip = ""
    
    @State var reciverRegimen = ""
    
    @State var communicationMethod = ""
    
    @State var reciverRazonIsDisabled: Bool = false
    
    @State var reciverRfcIsDisabled: Bool = false
    
    @State var reciverZipIsHidden: Bool = false
    
    @State var reciverRegimenIsHidden: Bool = false
    
    @State var currentView: ViewTabs = .mainView
    
    var hasLoadedHistory = false
    
    var hasLoadedTools = false
    
    @State var hiringMode: HiringMode? = nil
    
    @State var comment = ""
    
    /// Payment States START
    
    /// FiscalPaymentCodes
    /// Ejemplo: efectivo, chequeNominativo, transferenciaElectronicaDeFondos ...
    @State var paymentForm: FiscalPaymentCodes = .efectivo
    
    /// FiscalPaymentCodes
    @State var paymentFormListener = FiscalPaymentCodes.efectivo.rawValue
    
    @State var generalBankResultsIsHidden = true
    
    @State var providerFilter = ""
    
    var providerName = ""
    
    var banks: [BanksItem] = []
    
    @State var provider = ""
    
    @State var lastFour = ""
    
    @State var auth = ""
    
    @State var newBalance = "0.00"
    
    @State var currentBalance: Int64 = 0
    
    /// Payment States END
    
    /// FiscalPaymentMeths
    /// pagoEnUnaSolaExhibicion PUE
    /// pagoEnParcialidadesODiferido PPD
    @State var methodForm: FiscalPaymentMeths = .pagoEnUnaSolaExhibicion
    
    /// FiscalPaymentMeths
    @State var methodFormListener = FiscalPaymentMeths.pagoEnUnaSolaExhibicion.rawValue

    /// FiscalUse
    ///P01 porDefinir, G03 gastosEnGeneral, P01 porDefinir
    @State var useOfDocument: FiscalUse = .gastosEnGeneral
    
    /// FiscalUse
    @State var useOfDocumentListener = FiscalUse.gastosEnGeneral.rawValue

    lazy var generalBankField = InputText(self.$providerFilter)
        .placeholder("Seleccione Banco")
        .class(.textFiledBlackDarkLarge)
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onFocus {
            self.generalBankResultsIsHidden = false
        }
        .onKeyUp({ tf in
            self.filterPublicBanks()
        })
        .onBlur {
            
            Dispatch.asyncAfter(0.35) {
                self.generalBankResultsIsHidden = true
                if !self.providerName.isEmpty {
                    self.providerFilter = self.providerName
                    self.checkFreePayment()
                }
            }
        }
    
    lazy var generalBankResults = Div()
        .hidden(self.$generalBankResultsIsHidden)
        .backgroundColor(.grayBlackDark)
        .borderRadius(12.px)
        .position(.absolute)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .width(45.percent)
        .marginTop(7.px)
        .zIndex(1)
    
    lazy var methodFormSelect = Select(self.$methodFormListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(23.px)
        .disabled(true)
   
    lazy var useOfDocumentSelect = Select(self.$useOfDocumentListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(23.px)
    
    lazy var fiscalView = Div()
        .custom("height", "calc(100% - 50px)")
        .marginTop(3.px)
    
    /// View that contains tools and views
    lazy var oporationView = Div {
        
    }
    
    /// Requiers ower to contract view
    lazy var requestServiceNotAvailableView = Div{
        Table {
            Tr{
                Td{
                   Img()
                        .src("/skyline/media/fiscalActivationPromoWhite.png")
                        .width(70.percent)
                    Br()
                    H1("Contacta al CEO para hacer la contratacion.")
                        .color(.darkOrange)
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    .height(100.percent)
    .width(100.percent)
    
    lazy var seePacksBtn = Div("Ver Paquetes")
        .class(.uibtnLargeOrange)
        .fontSize(36.px)
        .onClick {
            self.getFiscalSOCs()
        }
    
    /// Activate fiscal service
    lazy var requestServiceView = Div {
        Table {
            Tr{
                Td{
                   Img()
                        .src("/skyline/media/fiscalActivationPromoWhite.png")
                        .width(70.percent)
                    Br()
                    self.seePacksBtn
                }
                .verticalAlign(.middle)
                .align(.center)
            }
        }
        .height(100.percent)
        .width(100.percent)
    }
    .height(100.percent)
    .width(100.percent)
    
    /// Payment States Inputs START
    lazy var paymentFormsSelect = Select($paymentFormListener)
        .class(.textFiledBlackDarkLarge)
        .width(99.percent)
        .fontSize(23.px)
    
    lazy var myBanksSelect = Select()
        .class(.textFiledBlackDarkLarge)
    
    lazy var cardProviderSelect = Select {
        
        Option("Seleccione Proveedor")
            .value("")
        
        Option("Master Card")
            .value("MC")
        
        Option("Visa")
            .value("VISA")
        
        Option("American Express")
            .value("AMEX")
        
        Option("Discover")
            .value("DISCOVER")
        
        Option("Otro")
            .value("other")
        
    }
        .class(.textFiledBlackDarkLarge)
    
    lazy var reciverRazonSelect = Select(self.$reciverRegimen)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .fontSize(23.px)
        .float(.right)
        .width(100.percent)
    
    lazy var adjustmentView = Div {
        H4("Motivo del Ajuste")
            .color(.lightBlueText)
        
        Label("Motivo del Ajuste")
            .fontSize(12.px)
        
        TextArea(self.$auth)
            .placeholder("Ingrese la razon del ajuste")
            .width(99.percent)
            .fontSize(23.px)
            .class(.textFiledBlackDarkLarge)
        
    }
        .padding(all: 7.px)
        .color(.lightGray)
        .class(.roundBlue)
        .hidden(self.$paymentForm.map{
            $0 != .condonacion &&
            $0 != .compensacion &&
            $0 != .remisionDeDeuda
        })
    
    lazy var cardPaymentLastFourField = InputText(self.$lastFour)
        .class(.textFiledBlackDarkLarge)
        .placeholder("4 ultimos")
        .width(90.percent)
        .fontSize(23.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var cardPaymentAuthField = InputText(self.$auth)
        .placeholder("Folio de Autorizacion")
        .class(.textFiledBlackDarkLarge)
        .width(90.percent)
        .fontSize(23.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var cardPaymentView = Div {
        
        H4("Datos del pago con tarjeta")
            .color(.lightBlueText)
        
        Div().class(.clear)
        
        Label("Proveedor")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.cardProviderSelect
        .onChange { event, select in
            self.provider = select.value
            self.checkFreePayment()
        }
        .fontSize(23.px)
        .width(99.percent)
        
        Div().class(.clear)
        
        Label("Ultimos Cuatro")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.cardPaymentLastFourField
        
        Div().class(.clear)
        
        Label("Folio de Autorizacion")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.cardPaymentAuthField
        
        Div().class(.clear)
        
    }
        .padding(all: 7.px)
        .class(.roundBlue)
        .color(.lightGray)
        .hidden(self.$paymentForm.map {
            $0 != .tarjetaDeDebito &&
            $0 != .tarjetaDeCredito
        })
    
    lazy var checkPaymentNumber = InputText(self.$auth)
        .class(.textFiledBlackDarkLarge, .zoom)
        .placeholder("4 ultimos")
        .width(90.percent)
        .fontSize(23.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var checkPaymentView = Div {
        
        H4("Datos del Cheque")
            .color(.lightBlueText)
        
        Label("Proveedor")
            .fontSize(12.px)
            .color(.lightGray)
        
        Div().class(.clear)
        
        self.generalBankField
        
        Div().class(.clear)
        
        self.generalBankResults
        
        Div().class(.clear)
            
        Label("Numero de Cheque")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.checkPaymentNumber
        Div().class(.clear)
        
    }
        .hidden(self.$paymentForm.map{ $0 != .chequeNominativo })
        .padding(all: 7.px)
        .class(.roundBlue)
    
    lazy var speiPaymentFolio = InputText(self.$auth)
        .class(.textFiledBlackDarkLarge, .zoom)
        .placeholder("Folio De Tranferencia")
        .width(90.percent)
        .fontSize(23.px)
        .onKeyUp({ tf in
            
            if ignoredKeys.contains(tf.text) {
                return
            }
            
            let term = tf.text
            
            Dispatch.asyncAfter(0.3) {
                if term != tf.text {
                    return
                }
                self.checkFreePayment()
            }
            
        })
        .onBlur {
            self.checkFreePayment()
        }
    
    lazy var speiPaymentView = Div {
        
        H4("Datos de la transferencia")
            .color(.lightBlueText)
        
        Div().class(.clear)
        
        Label("Banco ¿Donde Recibiste El Deposito?")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.myBanksSelect
        .onChange { event, select in
            self.provider = select.value
            self.checkFreePayment()
        }
        .fontSize(23.px)
        .width(99.percent)
        
        Div().class(.clear)
        
        Label("Folio De Tranferencia")
            .color(.lightGray)
            .fontSize(12.px)
        
        Div().class(.clear)
        
        self.speiPaymentFolio
        
        Div().class(.clear)
        
    }
        .padding(all: 7.px)
        .class(.roundBlue)
        .color(.lightGray)
        .hidden(self.$paymentForm.map{ $0 != .transferenciaElectronicaDeFondos })
    
    /// Payment States Inputs END
    
    ///profile
    /// Fiscal document issuer
    lazy var issuerView = Div {
        Div{
            
            Div{
                Div{
                    
                    Img()
                        .src("/skyline/media/random.png")
                        .height(18.px)
                        .paddingRight(0.px)
                }
                .marginRight(3.px)
                .float(.left)
                
                Label("Cambiar Perfil")
                    .fontSize(12.px)
            }
            .hidden(self.$profiles.map{ $0.count < 2 })
            .marginTop(-7.px)
            .float(.right)
            .class(.uibtn)
            .onClick {
                self.changeFiscalProfile()
            }
            
            H4("Perfil de Facturación")
        }
        
        Div().class(.clear).marginBottom(7.px)
        
        InputText(self.$profile.map{ $0?.razon ?? "" })
            .class(.textFiledBlackDark)
            .placeholder("Razon Social")
            .marginBottom(3.px)
            .width(95.percent)
            .fontSize(20.px)
            .height(24.px)
        
        InputText(self.$profile.map{ $0?.rfc ?? "" })
            .class(.textFiledBlackDark)
            .placeholder("RFC")
            .marginBottom(3.px)
            .width(95.percent)
            .fontSize(20.px)
            .height(24.px)
    }
    .hidden(self.$profiles.map{ $0.count < 2 })
    
    /// Fiscal document reciver
    lazy var reciverView = Div {
        Div{
            Div{
                Div{
                    Img()
                        .src("/skyline/media/zoom.png")
                        .height(18.px)
                        .paddingRight(0.px)
                }
                .marginRight(7.px)
                .float(.left)
                
                Label("Buscar")
            }
            .hidden(self.$reciver.map{ ($0 == nil) })
            .float(.right)
            .class(.uibtn)
            .onClick {
                self.searchCustomer(nil)
            }
            
            H3(self.$reciver.map{ ($0 == nil) ? "Buscar Cliente" : "Cuenta: \($0?.folio ?? "")" })
                .float(.left)
            
            Img()
                .float(.right)
                .cursor(.pointer)
                .src("/skyline/media/pencil.png")
                .height(24.px)
                .padding(all: 3.px)
                .paddingRight(7.px)
                .hidden(self.$reciver.map{ ($0 == nil) })
                .onClick { img, event in
                    
                    guard let reciver = self.reciver else {
                        showError(.errorGeneral, "No se pudo cargar cuenta fiscal del cliente.")
                        return
                    }
                    
                    addToDom(ToolFiscalQuickAccountEdit(
                        accountid: reciver.id,
                        razon: reciver.fiscalRazon,
                        rfc: reciver.fiscalRfc,
                        zipCpde: reciver.fiscalZip,
                        regimen: reciver.fiscalRegime,
                        email: reciver.fiscalPOCMail,
                        mobile: reciver.fiscalPOCMobile,
                        callback: { razon, rfc, zipCpde, regimen, email, mobile in
                            self.reciverRazon = razon
                            self.reciverRfc = rfc
                            self.reciverZip = zipCpde
                            self.reciverRegimen = regimen.rawValue
                            
                            self.reciver?.fiscalRazon = razon
                            self.reciver?.fiscalRfc = rfc
                            self.reciver?.fiscalZip = zipCpde
                            self.reciver?.fiscalRegime = regimen
                            self.reciver?.fiscalPOCMail = email
                            self.reciver?.fiscalPOCMobile = mobile
                            
                            if !email.isEmpty{
                                self.communicationMethod = email
                            }
                            else if !mobile.isEmpty{
                                self.communicationMethod = mobile
                            }
                        }))
                }
            
            
            Div().class(.clear)
        }
        
        Label("Infomación Global")
            .hidden(self.$reciverRfc.map{ $0 != "XAXX010101000" })
            .color(.darkOrange)
            .marginBottom(7.px)
        
        Div{
            
            Label("Tipo de Periodo:")
                .marginBottom(3.px)
            
            self.periodSelectSelect
                .marginBottom(7.px)
            
            Label("Periodo:")
                .marginBottom(3.px)
            
            self.monthSelectSelect
                .marginBottom(7.px)
            
            Label("Año:")
                .marginBottom(3.px)
            
            self.yearField
                .marginBottom(7.px)
            
        }
        .hidden(self.$reciverRfc.map{ $0 != "XAXX010101000" })
        .custom("width", "calc(100% - 16px);")
        .marginBottom(7.px)
        .padding(all: 3.px)
        .class(.roundBlue)
        
        ///  Account Data
        Div{
            
            Div().class(.clear).marginBottom(7.px)
            
            Label("Razon Social")
                .marginBottom(3.px)
                .fontSize(16.px)
                .color(.white)
            
            InputText(self.$reciverRazon)
                .disabled(self.$reciverRazonIsDisabled)
                .class(.textFiledBlackDark)
                .placeholder("Razon Social")
                .width(95.percent)
                .fontSize(20.px)
                .height(24.px)
            
            Div().clear(.both).height(7.px)
            
            Label("RFC")
                .marginBottom(3.px)
                .fontSize(16.px)
                .color(.white)
            
            InputText(self.$reciverRfc)
                .disabled(self.$reciverRfcIsDisabled)
                .class(.textFiledBlackDark)
                .placeholder("RFC")
                .width(95.percent)
                .fontSize(20.px)
                .height(24.px)
            
            Div().clear(.both).height(7.px)
            
            Label("Codigo Postal Fiscal")
                .hidden(self.$reciverZipIsHidden)
                .marginBottom(3.px)
                .fontSize(16.px)
                .color(.white)
            
            InputText(self.$reciverZip)
                .hidden(self.$reciverZipIsHidden)
                .class(.textFiledBlackDark)
                .placeholder("Codigo Postal")
                .width(95.percent)
                .fontSize(20.px)
                .height(24.px)
            
            Div().clear(.both).height(7.px)
            
            Label("Regimen Fiscal")
                .hidden(self.$reciverZipIsHidden)
                .marginBottom(3.px)
                .fontSize(16.px)
                .color(.white)
            
            self.reciverRazonSelect
                .hidden(self.$reciverRegimenIsHidden)
                .class(.textFiledBlackDark)
                .width(95.percent)
                .fontSize(20.px)
                .height(24.px)
            
            Div().clear(.both).height(7.px)
            
            Label("Enviar Factura")
                .marginBottom(3.px)
                .fontSize(16.px)
                .color(.white)
            
            InputText(self.$communicationMethod)
                .class(.textFiledBlackDark)
                .placeholder("Correo o Movil")
                .width(95.percent)
                .fontSize(20.px)
                .height(24.px)
            
            Div().clear(.both).height(7.px)
        }
        .hidden(self.$reciver.map{ ($0 == nil) })
        
        /// Search Button
        Div{
            Div{
                Img()
                    .src("/skyline/media/zoom.png")
                    .height(24.px)
                    .paddingTop( 3.px)
                    .paddingRight(0.px)
                    .marginRight(7.px)
                
                Label("Buscar Cliente")
            }
            .class(.uibtnLargeOrange)
            .cursor(.pointer)
            .width(90.percent).onClick {
                self.searchCustomer(nil)
            }
        }
        .hidden(self.$reciver.map{ ($0 != nil) })
        .align(.center)
    }
    
    lazy var choseFiscalProfilesView = Div()
        .custom("height", "calc(100% - 45px)")
        .marginTop(7.px)
        .overflow(.auto)
        .float(.right)
    
    lazy var itemsDiv = Div()
        .class(.roundDarkBlue)
        .marginBottom(7.px)
        .padding(all: 7.px)
        .overflow(.auto)
        .height(305.px)
    
    lazy var infoDiv = Div()
    
    lazy var taxCalcToggle = InputCheckbox().toggle(self.$substractedTaxCalculation)
    
    /// `Historical View`
    
    var hasFilter = false
    
    @State var documentFilter = ""
    
    @State var fiscalProfileListener = ""
    
    var due: [ String : [FIAccountsServices] ] = [:]
    
    var pending: [ String : [FIAccountsServices] ] = [:]
    
    var historical: [ String : [FIAccountsServices] ] = [:]
    
    lazy var documentFilterFilter = InputText(self.$documentFilter)
        .class(.textFiledBlackDarkLarge, .zoom)
        .placeholder("Buscar...")
        .marginRight(7.px)
        .marginTop(-8.px)
        .fontSize(23.px)
        .width(230.px)
        .float(.right)
        .onKeyUp({ tf, event in
            
            let term = tf.text.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: "")
            
            Dispatch.asyncAfter(0.33) {
                if term == tf.text.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: ""){
                    self.filterDocments()
                }
            }
            
        })
        .onEnter {
            self.advancedSearch()
        }
    
    lazy var historicalRazonSelect = Select(self.$fiscalProfileListener)
        .class(.textFiledBlackDarkLarge)
        .borderRadius(7.px)
        .marginBottom(0.px)
        .marginLeft(12.px)
        .fontSize(18.px)
        .width(300.px)
        .float(.left)
    
    lazy var historicalLeftView = Div()
        .height(100.percent)
        .overflow(.auto)
    
    lazy var historicalRightView = Div()
        .height(100.percent)
        .overflow(.auto)
    
    lazy var historicalView = Div{
        Div{
            
            Div {
                
                Div{
                    Div{
                        Img()
                            .src("/skyline/media/coin.png")
                            .marginTop(3.px)
                            .height(24.px)
                    }
                    .marginRight(3.px)
                    .float(.left)
                    
                    Span("Complemento")
                    
                    Div().class(.clear)
                }
                .marginRight(12.px)
                .marginTop(-3.px)
                .float(.right)
                .class(.uibtn)
                .onClick {
                    self.addComplento()
                }
                
                H2("Facturas a Credito")
                    .marginTop(7.px)
                    .color(.white)
            }
            
            Div().class(.clear)
            
            Div{
                self.historicalLeftView
            }
            .custom("height", "calc(100% - 50px)")
            .padding(all: 3.px)
            .margin(all: 3.px)
            
        }
        .height(100.percent)
        .width(50.percent)
        .float(.left)
        
        Div{
            
            Div{
                
                Div("Buscar")
                    .class(.uibtnLarge)
                    .marginTop(-12.px)
                    .marginRight(7.px)
                    .float(.right)
                    .onClick {
                        self.advancedSearch()
                    }
                
                self.documentFilterFilter
                
                H2("Historial")
                   .color(.white)
            }
            .marginTop(7.px)
            
            Div().class(.clear)
            
            Div{
                self.historicalRightView
            }
            .custom("height", "calc(100% - 95px)")
            .padding(all: 3.px)
            .margin(all: 3.px)
            
            Div{
                Div("Cancelaciones")
                    .class(.uibtnLargeOrange)
                    .marginRight(7.px)
                    .marginTop(0.px)
                    .onClick {
                        addToDom(FiscalCurrentCancelationsView())
                    }
            }
            .align(.right)
            
        }
        .height(100.percent)
        .width(50.percent)
        .float(.left)
        
    }
        .hidden(self.$currentView.map({ $0 != .history }))
        .height(100.percent)
        .width(100.percent)
    
    lazy var toolsView = Div{
        
    }
        .hidden(self.$currentView.map({ $0 != .tools }))
        .backgroundColor(.blue)
        .height(100.percent)
        .width(100.percent)
    
    /// Global document (Publico en General)
    
    @State var periodSelectListener = ""
    
    @State var monthSelectListener = ""
    
    @State var yearFieldListener = ""
    
    lazy var periodSelectSelect = Select(self.$periodSelectListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(23.px)
    
    lazy var monthSelectSelect = Select(self.$monthSelectListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(23.px)
   
    lazy var yearField = InputText(self.$yearFieldListener)
        .class(.textFiledBlackDarkLarge)
        .placeholder("2023")
        .width(95.percent)
        .fontSize(23.px)
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
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                /// Tabs  for fiscal tool view
                Div{
                    if (custCatchHerk > 2 && linkedProfile.contains(.billing)) || self.loadType != .manual {
                        
                        H3("Nueva Factura")
                            .borderBottom(width: .thin, style: .solid, color: self.$currentView.map{ ($0 == .mainView) ? .lightBlueText : .gray })
                            .color(self.$currentView.map{ ($0 == .mainView) ? .white : .gray })
                            .custom("width", "fit-content")
                            .marginRight(12.px)
                            .cursor(.pointer)
                            .fontSize(24.px)
                            .float(.left)
                            .onClick {
                                self.currentView = .mainView
                            }
                    }
                    
                    
                    H3("Historial")
                        .borderBottom(width: .thin, style: .solid, color: self.$currentView.map{ ($0 == .history) ? .lightBlueText : .gray })
                        .color(self.$currentView.map{ ($0 == .history) ? .white : .gray })
                        .custom("width", "fit-content")
                        .hidden(self.$lockPrices)
                        .marginRight(12.px)
                        .cursor(.pointer)
                        .fontSize(24.px)
                        .float(.left)
                        .onClick {
                            self.currentView = .history
                        }
                    
                    H3("Herraminetas")
                        .borderBottom(width: .thin, style: .solid, color: self.$currentView.map{ ($0 == .tools) ? .lightBlueText : .gray })
                        .color(self.$currentView.map{ ($0 == .tools) ? .white : .gray })
                        .custom("width", "fit-content")
                        .hidden(self.$lockPrices)
                        .marginRight(24.px)
                        .cursor(.pointer)
                        .fontSize(24.px)
                        .float(.left)
                        .onClick {
                            self.currentView = .tools
                        }
                    
                }
                .hidden(self.$profiles.map{ $0.isEmpty })
                .float(.right)
                
                H2(self.$hiringMode.map{ ($0 == nil) ? "Facturacion" : $0!.description })
                    .color(self.$hiringMode.map{ ($0 == nil) ? .lightBlueText : .darkOrange })
                    .float(.left)
                    .marginLeft(7.px)
                
                if self.profiles.count > 1 {
                    self.historicalRazonSelect
                        .hidden(self.$currentView.map({ $0 != .history }))
                }
                
                
                H2(self.$hiringMode.map{ ($0 == nil) ? "" : $0!.help })
                    .marginLeft(7.px)
                    .float(.left)
                    .color(.gray)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            /// Body
            self.fiscalView
            
        }
        .custom("height","calc(100% - 45px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(25.px)
        
        Div{
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.selectFiscalProfileIsHidden = true
                        }
                    
                    H2("Seleccionar Perfil")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                /// Fiscal Profie Div
                self.choseFiscalProfilesView
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 200px)")
            .custom("top", "calc(50% - 130px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(270.px)
            .width(400.px)
        }
        .hidden(self.$selectFiscalProfileIsHidden)
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
        
        $substractedTaxCalculation.listen {
            self._calculateTotal()
        }
        
        $items.listen {
            
            self.itemsDiv.innerHTML = ""
            
            self.itemViews = []
            
            $0.forEach { item in
                
                let view = ToolFiscalItemView(
                    substractedTaxCalculation: self.$substractedTaxCalculation,
                    item: item,
                    edit: {
                        
                        let view = ToolFiscalAddManualChargeView(
                            item: item,
                            substractedTaxCalculation: self.substractedTaxCalculation,
                            lockPrices: self.lockPrices,
                            add: { item in
                                // Add does not apply to existing object
                            },
                            update: { item in
                                
                                var _items: [FiscalItem] = []
                                
                                self.items.forEach { _item in
                                    if _item.tid != item.tid {
                                        _items.append(_item)
                                    }
                                    else{
                                        _items.append(item)
                                    }
                                }
                                
                                self.items = _items
                            },
                            remove: { id in
                                var _items: [FiscalItem] = []
                                
                                self.items.forEach { item in
                                    if id == item.tid {
                                        return
                                    }
                                    _items.append(item)
                                }
                                
                                self.items = _items
                            }
                        )
                        
                        
                        
                        addToDom(view)
                    })
                
                self.itemViews.append(view)
                
                self.itemsDiv.appendChild(view)
            }
            
            self._calculateTotal()
            
        }
        
        $reciver.listen {
            
            if let reciver = $0 {
                
                self.reciverRazon = reciver.fiscalRazon
                
                self.reciverRfc = reciver.fiscalRfc
                
                self.reciverZip = reciver.fiscalZip
                
                self.reciverRegimen = (reciver.fiscalRegime?.rawValue ?? "")
                
                self.reciverRazonIsDisabled = !reciver.fiscalRazon.isEmpty
                
                self.reciverRfcIsDisabled = !reciver.fiscalRfc.isEmpty
                
                self.reciverZipIsHidden = !reciver.fiscalZip.isEmpty
                
                if !reciver.fiscalPOCMail.isEmpty {
                    self.communicationMethod = reciver.fiscalPOCMail
                }
                else if !reciver.fiscalPOCMobile.isEmpty {
                    self.communicationMethod = reciver.fiscalPOCMobile
                }
                else if !reciver.email.isEmpty {
                    self.communicationMethod = reciver.email
                }
                else if !reciver.mobile.isEmpty {
                    self.communicationMethod = reciver.mobile
                }
                
                self.reciverRegimenIsHidden = !(reciver.fiscalRegime == nil)
            }
            
        }
        
        $profile.listen {
            
        }
        
        $currentView.listen {
            switch $0{
            case .mainView:
                break
            case .history:
                if self.hasLoadedHistory {
                    return
                }
                self.loadHistory()
            case .tools:
                if self.hasLoadedTools {
                    return
                }
            }
        }
        
        /// Payment Form Setting
        $paymentFormListener.listen {
        
            guard let meth = FiscalPaymentCodes(rawValue: $0) else {
                return
            }
            
            self.paymentForm = meth
            
            self.provider = ""
            self.lastFour = ""
            self.auth = ""
            
            if meth == .transferenciaElectronicaDeFondos {
               if mybanks.isEmpty {
                   
                   self.paymentFormListener = FiscalPaymentCodes.efectivo.rawValue
                   showError(.campoRequerido, "No tiene bancos. Ingrese a configuracion para agregar bancos.")
                   
                   return
               }
            }
            
            if meth == .porDefenir {
                self.methodFormListener = FiscalPaymentMeths.pagoEnParcialidadesODiferido.rawValue
            }
            else{
                self.methodFormListener = FiscalPaymentMeths.pagoEnUnaSolaExhibicion.rawValue
            }
            
        }
        
        $methodFormListener.listen {
            guard let meth = FiscalPaymentMeths(rawValue: $0) else {
                return
            }
            
            self.methodForm = meth
            
        }
        
        $useOfDocumentListener.listen {
            guard let use = FiscalUse(rawValue: $0) else {
                return
            }
            
            self.useOfDocument = use
        }
        
        $fiscalProfileListener.listen {
            
            self.documentFilter = ""
            
            self.loadHistoryView()
        }
        
        $periodSelectListener.listen {
            
            self.monthSelectSelect.innerHTML = ""
            
            guard let period = Periodicidad(rawValue: $0) else {
                return
            }
            
            let month = getDate(nil).month
            
            if period.isBimestral {
               
                Meses.allCases.forEach { item in
                    if !item.isBimestral {
                        return
                    }
                    self.monthSelectSelect.appendChild(
                        Option(item.description)
                            .value(item.rawValue)
                    )
                }
                
                if month == 1 || month == 2 {
                    self.monthSelectListener = Meses.eneroFebrero.rawValue
                }
                else if month == 3 || month == 4 {
                    self.monthSelectListener = Meses.marzoAbril.rawValue
                }
                else if month == 5 || month == 6 {
                    self.monthSelectListener = Meses.mayoJunio.rawValue
                }
                else if month == 7 || month == 8 {
                    self.monthSelectListener = Meses.julioAgosto.rawValue
                }
                else if month == 9 || month == 10 {
                    self.monthSelectListener = Meses.septiembreOctubre.rawValue
                }
                else if month == 11 || month == 12 {
                    self.monthSelectListener = Meses.noviembre.rawValue
                }
                
            }
            else {
                
                Meses.allCases.forEach { item in
                     if item.isBimestral {
                         return
                     }
                     self.monthSelectSelect.appendChild(
                         Option(item.description)
                             .value(item.rawValue)
                     )
                 }
                
                if month == 1 {
                    self.monthSelectListener = Meses.enero.rawValue
                }
                else if month == 2 {
                    self.monthSelectListener = Meses.febrero.rawValue
                }
                else if month == 3 {
                    self.monthSelectListener = Meses.marzo.rawValue
                }
                else if month == 4 {
                    self.monthSelectListener = Meses.abril.rawValue
                }
                else if month == 5 {
                    self.monthSelectListener = Meses.mayo.rawValue
                }
                else if month == 6 {
                    self.monthSelectListener = Meses.junio.rawValue
                }
                else if month == 7 {
                    self.monthSelectListener = Meses.julio.rawValue
                }
                else if month == 8 {
                    self.monthSelectListener = Meses.agosto.rawValue
                }
                else if month == 9 {
                    self.monthSelectListener = Meses.septiembre.rawValue
                }
                else if month == 10 {
                    self.monthSelectListener = Meses.octubre.rawValue
                }
                else if month == 11 {
                    self.monthSelectListener = Meses.noviembre.rawValue
                }
                else if month == 12 {
                    self.monthSelectListener = Meses.diciembre.rawValue
                }
                
            }
            
        }
        
        Periodicidad.allCases.forEach { item in
            periodSelectSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        periodSelectListener = Periodicidad.diario.rawValue
        
        yearFieldListener = getDate(nil).year.toString
        
        if profiles.isEmpty {
            self.fiscalView.appendChild(self.requestServiceView)
        }
        else {
            profile = profiles.first
            loadMainView()
        }
        
        FiscalPaymentCodes.allCases.forEach { code in
            if code.basicCodes {
                paymentFormsSelect.appendChild(
                    Option("\(code.rawValue) \(code.description)")
                        .value(code.rawValue)
                )
            }
        }
        
        API.v1.getBanks { resp in
            
            guard let resp = resp else {
                return
            }
            
            self.banks = resp
            
            self.filterPublicBanks()
            
        }
        
        self.myBanksSelect.appendChild(
            Option("Seleccione Banco")
                .value("")
        )
        
        mybanks.forEach { bank in
            self.myBanksSelect.appendChild(
                Option("\(bank.bank) \(bank.account.suffix(4)) \(bank.nick)")
                    .value("\(bank.bank) \(bank.account.suffix(4))")
            )
        }
        
        FiscalPaymentMeths.allCases.forEach { meth in
            let opt = Option("\(meth.code) \(meth.description)")
                .value(meth.code)
            
            self.methodFormSelect.appendChild(opt)
        }
        
        FiscalUse.allCases.forEach { use in
            let opt = Option("\(use.code) \(use.description)")
                .value(use.code)
            
            self.useOfDocumentSelect.appendChild(opt)
        }
        
        reciverRazonSelect.appendChild(
            Option("Seleccione Perfil")
                .value("")
        )
        
        FiscalRegimens.allCases.forEach { regimen in
            reciverRazonSelect.appendChild(
                Option("\(regimen.code) \(regimen.description)")
                    .value(regimen.code)
            )
        }
        
        if let prof = fiscalProfile {
            paymentFormListener = prof.paymentCode.rawValue
            useOfDocumentListener = prof.use.rawValue
        }
        
        if (custCatchHerk > 2 && linkedProfile.contains(.billing)) || self.loadType != .manual {
            currentView = .mainView
        }
        else{
            currentView = .history
        }
        
        $reciverRfc.listen {
        
            if $0 == "XAXX010101000" {
                self.useOfDocumentListener = "S01"
                self.useOfDocumentSelect.disabled(true)
                Dispatch.asyncAfter(0.5) {
                    self.reciverRegimen = FiscalRegimens.sinIbligacionesFiscales.rawValue
                    self.reciverRazonSelect.disabled(true)
                }
            }
            else {
                
                if let prof = fiscalProfile {
                    self.useOfDocumentListener = prof.use.rawValue
                }
                
                self.useOfDocumentSelect.disabled(false)
                self.reciverRazonSelect.disabled(false)
            }
            
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    func calcNewBalance(){
        newBalance = "0.00"
    }
    
    func checkFreePayment() {
        
        cardPaymentAuthField
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        checkPaymentNumber
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        speiPaymentFolio
            .removeClass(.zoom)
            .removeClass(.isOk)
            .removeClass(.isNok)
        
        switch paymentForm {
        case .efectivo:
            /// Cash dose not requier validation
            break
        case .chequeNominativo:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            checkPaymentNumber
                .class(.isLoading)
            
        case .transferenciaElectronicaDeFondos:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            speiPaymentFolio
                .class(.isLoading)
            
            
        case .tarjetaDeDebito, .tarjetaDeCredito:
            
            guard !provider.isEmpty else {
                return
            }
            
            guard !lastFour.isEmpty else {
                return
            }
            
            guard !auth.isEmpty else {
                return
            }
            
            cardPaymentAuthField
                .class(.isLoading)
            
        case .condonacion, .compensacion, .remisionDeDeuda:
            /// Adjustment does not requiere validation
            break
        default:
            return
        }
        
        API.custAPIV1.paymentAuthPreValidation(
            formaDePago: paymentForm,
            provider: provider,
            auth: auth,
            lastFour: lastFour
        ) { resp in
            
            self.checkPaymentNumber
                .removeClass(.isLoading)
            
            self.cardPaymentAuthField
                .removeClass(.isLoading)
            
            self.speiPaymentFolio
                .removeClass(.isLoading)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }
            
             guard let data = resp.data else {
                 showError(.errorGeneral, .unexpenctedMissingPayload)
                 return
             }
             
            let isFree = data.isFree
            
            switch self.paymentForm {
            case .efectivo:
                /// Cash dose not requier validation
                break
            case .chequeNominativo:

                if isFree {
                    self.checkPaymentNumber
                        .class(.isOk)
                }
                else{
                    self.checkPaymentNumber
                        .class(.isNok)
                }
                
            case .transferenciaElectronicaDeFondos:
                if isFree {
                    self.speiPaymentFolio
                        .class(.isOk)
                }
                else{
                    self.speiPaymentFolio
                        .class(.isNok)
                }
            case .tarjetaDeDebito, .tarjetaDeCredito:
                if isFree {
                    self.cardPaymentAuthField
                        .class(.isOk)
                }
                else{
                    self.cardPaymentAuthField
                        .class(.isNok)
                }
            case .condonacion, .compensacion, .remisionDeDeuda:
                /// Adjustment does not requiere validation
                break
            default:
                return
            }
        }
    }
    
    func renderFiscalDocument(
        isPreDocument: Bool,
        _ renderdData:  @escaping ((
            _ taxMode: TaxMode,
            _ comment: String,
            _ communicationMethod: String,
            _ type: FIAccountsServicesRelatedType,
            _ accountid: UUID,
            _ orderid: UUID?,
            _ folio: String?,
            _ officialDate: Int64?,
            _ profile: UUID,
            _ razon: String,
            _ rfc: String,
            _ zip: String,
            _ regimen: FiscalRegimens,
            _ use: FiscalUse,
            _ metodo: FiscalPaymentMeths,
            _ forma: FiscalPaymentCodes,
            _ items: [FiscalConcept],
            _ provider: String,
            _ auth: String,
            _ lastFour: String,
            _ cartaPorte: FiscalCartaPorte?,
            _ globalInformation: InformacionGlobal?
        ) -> ())
    ){
        
        /// general, order, sale, fiscalComplement, bill
        var type: FIAccountsServicesRelatedType = .general
        
        var relid: UUID? = nil
        
        var globalIds: [UUID]? = nil
        
        switch loadType {
        case .manual:
            type = .general
        case .order(let id):
            type = .order
            relid = id
        case .sale(let id):
            type = .sale
            relid = id
        case .loadFiscalDoc(let id):
            type = .fiscalComplement
            relid = id
        case .salePinGlobalSale(let globalInformation):
            type = .sale
            globalIds = globalInformation.sales.map{ $0.id }
        }
        
        // validate payment
        if relid == nil && !isPreDocument {
            
            switch paymentForm {
            case .chequeNominativo:
                
                if provider.isEmpty {
                    showError(.campoRequerido, "Seleccione Banco provedor de cheque")
                    return
                }
                
                if self.auth.isEmpty {
                    showError(.campoRequerido, "Ingrese numero de cheque")
                    return
                }
                
            case .transferenciaElectronicaDeFondos:
                
                if provider.isEmpty {
                    showError(.campoRequerido, "Seleccione Banco")
                    return
                }
                
                if self.auth.isEmpty {
                    showError(.campoRequerido, "Ingrese folio de transferencia")
                    return
                }
                
            case .tarjetaDeCredito, .tarjetaDeDebito, .tarjetaDeServicios:
                
                if provider.isEmpty {
                    showError(.campoRequerido, "Seleccione Banco")
                    return
                }
                
                if self.lastFour.isEmpty {
                    showError(.campoRequerido, "Ingrese utimos 4 de la tarjeta")
                    return
                }

                
                if self.auth.isEmpty {
                    showError(.campoRequerido, "Ingrese folio de autorización")
                    return
                }

            case .condonacion, .compensacion, .remisionDeDeuda:
                break
            default:
                break
            }
        }
        
        /// CustAcctFiscal
        guard let reciver = reciver else {
            showError(.campoRequerido, "Seleccione perfil de facturacion")
            return
        }
        /// FiscalEndpointV1.Profile
        guard let profile = profile else {
            showError(.campoRequerido, "Seleccione cliente")
            return
        }
        
        guard !reciverZip.isEmpty else{
            showError(.campoRequerido, .requierdValid("Codigo Postal Fiscal"))
            return
        }
        
        guard let regimen = FiscalRegimens(rawValue: reciverRegimen) else{
            showError(.campoRequerido, .requierdValid("Regime Fiscal"))
            return
        }
        
        if itemViews.isEmpty {
            showError(.errorGeneral, "Ingrese productos a facturar.")
            return
        }
        
        var taxMode:TaxMode = .susbstracted
        
        if !substractedTaxCalculation {
            taxMode = .aggregate
        }
        
        var _items: [FiscalConcept] = []
        
        var hasError: Bool = false
        var hasErrorMsg:String = ""
        
        itemViews.forEach { view in
            
            if hasError {
                return
            }
            
            guard let _totals = view.totals else {
                hasError = true
                hasErrorMsg = "No se localizo total de \(view.item.name)"
                return
            }
            
            let _item = view.item
            
            if _item.fiscCode.isEmpty || _item.fiscCodeDescription.isEmpty {
                hasError = true
                hasErrorMsg = "No se localizo CODIGO FISCAL de \(_item.name)"
                return
            }
            
            if _item.fiscUnit.isEmpty || _item.fiscUnitDescription.isEmpty {
                hasError = true
                hasErrorMsg = "No se localizo UNIDAD FISCAL de \(_item.name)"
                return
            }
            
            _items.append(.init(
                type: _item.type,
                id: _item.id,
                fiscCode: _item.fiscCode,
                fiscCodeDescription: _item.fiscCodeDescription,
                fiscUnit: _item.fiscUnit,
                fiscUnitDescription: _item.fiscUnitDescription,
                series: _item.series,
                code: _item.code,
                name: _item.name,
                units: _item.units,
                unitCost: _item.unitCost,
                discount: _item.discount,
                subTotal: _totals.subTotal,
                trasladado: _totals.trasladado,
                retenido: _totals.retenido,
                total: _totals.total,
                retenidos: _totals.retenidos,
                trasladados: _totals.trasladados
            ))
            
        }
        
        if hasError {
            showError(.errorGeneral, hasErrorMsg)
            return
        }
        
        var globalInformation: InformacionGlobal? = nil
        
        if reciverRfc == "XAXX010101000" {
            
            guard let period = Periodicidad(rawValue: periodSelectListener) else {
                return
            }
            
            guard let month = Meses(rawValue: monthSelectListener) else {
                return
            }
            
            guard !yearFieldListener.isEmpty else {
                return
            }
            
            guard let _ = Int(yearFieldListener) else {
                return
            }
            
            globalInformation = .init(
                period: period,
                month: month,
                year: yearFieldListener,
                globalIds: globalIds
            )
            
        }
        
        renderdData(
            taxMode,
            self.comment,
            self.communicationMethod,
            type,
            reciver.id,
            relid,
            folio,
            nil,
            profile.id,
            reciverRazon,
            reciverRfc,
            reciverZip,
            regimen,
            useOfDocument,
            methodForm,
            paymentForm,
            _items,
            provider,
            auth,
            lastFour,
            cartaPorte,
            globalInformation
        )
    }
    
    func validateFiscalDocument() {
        
        renderFiscalDocument(isPreDocument: false) { taxMode, comment, communicationMethod, type, accountid, orderid, folio, officialDate, profile, razon, rfc, zip, regimen, use, metodo, forma, items, provider, auth, lastFour, cartaPorte, globalInformation in
            
            let view = ToolFiscalConfirmView(
                taxMode: taxMode,
                comment: comment,
                communicationMethod: communicationMethod,
                type: type,
                accountid: accountid,
                orderid: orderid,
                folio: folio,
                officialDate: officialDate,
                profile: profile,
                razon: razon,
                rfc: rfc,
                zip: zip,
                regimen: regimen,
                use: use,
                metodo: metodo,
                forma: forma,
                items: items,
                provider: provider,
                auth: auth,
                lastFour: lastFour,
                cartaPorte: cartaPorte,
                globalInformation: globalInformation,
                total: self.total
            ) {
                self.createFiscalDocument()
            }
            
            addToDom(view)
            
        }
        
    }
    
    func createFiscalDocument() {
        
        renderFiscalDocument(isPreDocument: false) {
            taxMode,
            comment,
            communicationMethod,
            type,
            accountid,
            orderid,
            folio,
            officialDate,
            profile,
            razon,
            rfc,
            zip,
            regimen,
            use,
            metodo,
            forma,
            items,
            provider,
            auth,
            lastFour,
            cartaPorte,
            globalInformation in
            
            loadingView(show: true)
            
            API.fiscalV1.create4(
                eventid: self.eventid,
                taxMode: taxMode,
                comment: comment,
                communicationMethod: communicationMethod,
                type: type, 
                storeId: custCatchStore,
                accountid: accountid,
                orderid: orderid,
                officialDate: officialDate,
                profile: profile,
                razon: razon,
                rfc: rfc,
                zip: zip,
                regimen: regimen,
                use: use,
                metodo: metodo,
                forma: forma,
                items: items,
                provider: provider,
                auth: auth,
                lastFour: lastFour,
                cartaPorte: cartaPorte,
                globalInformation: globalInformation
            ) { resp in
                
                loadingView(show: false)
                
                do {
                    let data = try JSONEncoder().encode(resp)
                    
                    if let str = String(data: data, encoding: .utf8) {
                        print("🟢  create4  🟢")
                        print(str)
                        
                    }
                }
                catch {}
                
                self.infoDiv.innerHTML = ""
                
                self.infoDiv.color(.white)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.infoDiv.color(.gold)
                    self.infoDiv.appendChild(Div("Error de conexion al servidor"))
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.infoDiv.color(.gold)
                    self.infoDiv.appendChild(Div(resp.msg))
                    return
                }
                
                
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo data del servidor")
                    self.infoDiv.color(.gold)
                    self.infoDiv.appendChild(Div(resp.msg))
                    return
                }
                
                let _folio = (payload.folio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                    .replace(from: "/", to: "%2f")
                    .replace(from: "+", to: "%2b")
                    .replace(from: "=", to: "%3d")
                
                let _pdf = (payload.pdf.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                    .replace(from: "/", to: "%2f")
                    .replace(from: "+", to: "%2b")
                    .replace(from: "=", to: "%3d")
                
                let _xml = (payload.xml.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                    .replace(from: "/", to: "%2f")
                    .replace(from: "+", to: "%2b")
                    .replace(from: "=", to: "%3d")
                
                let pdfLink = pdfLinkString(folio: _folio, pdf: _pdf)
                
                let xmlLink = xmlLinkString(folio: _folio, xml: _xml)
                
                var printTicket = false
                
                switch self.loadType {
                case .manual, .loadFiscalDoc, .salePinGlobalSale:
                    break
                case .order:
                    if configStore.print.document == .miniprinter {
                        printTicket = true
                    }
                case .sale:
                    if configStore.printPdv.document == .miniprinter {
                        printTicket = true
                    }
                }
                
                if printTicket{
                    
                    let div = Div {
                        Table{
                            Tr{
                                Td{
                                    Img()
                                        .src("/skyline/media/icon_print.png")
                                        .class(.iconWhite)
                                        .width(80.percent)
                                        .cursor(.pointer)
                                        .onClick {
                                            self.printTicket(
                                                stamp: payload.stamp,
                                                raw: payload.raw
                                            )
                                        }
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                    }
                    .height(90.percent)
                    .float(.left)
                    .width(70.px)
                    
                    self.infoDiv.appendChild(div)
                }
                
                self.infoDiv.appendChild(A{
                    Img()
                        .src("/skyline/media/pdf_icon.png")
                        .height(90.percent)
                }
                .href(pdfLink).margin(all: 7.px))
                
                self.infoDiv.appendChild(A {
                    Img()
                        .src("/skyline/media/xml_icon.png")
                        .height(90.percent)
                }
                .href(xmlLink).margin(all: 7.px))
                
                self.callback(payload.id, payload.folio, payload.pdf, payload.xml)
                
            }
        }
    }
    
    func addCartaPorte(loadHistory: Bool) {
        addToDom(AddCartaPorteView(cartaPorte: cartaPorte, loadHistory: loadHistory){ cartaPorte in
            self.cartaPorte = cartaPorte
        })
    }
    
    func loadHistory() {
        
        loadingView(show: true)
        
        API.fiscalV1.loadDocuments(id: nil) { resp in
            
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
                showError(.unexpectedResult, "No se puedo obtener payload de data")
                return
            }
            
            if let id = payload.profile {
                self.profiles.forEach { profile in
                    if id == profile.id {
                        self.fiscalProfileListener = profile.rfc
                    }
                }
            }
            
            self.profiles.forEach { profile in
                self.pending[profile.rfc] = []
                self.due[profile.rfc] = []
                self.historical[profile.rfc] = []
            }
            
            payload.pending.forEach { doc in
                self.pending[doc.emisorRfc]?.append(doc)
            }
            
            payload.historical.forEach { doc in
                self.historical[doc.emisorRfc]?.append(doc)
            }
            
            payload.due.forEach { doc in
                self.due[doc.emisorRfc]?.append(doc)
            }
            
            self.hasLoadedHistory = true
            
            self.loadHistoryView()
            
        }
    }
    
    func loadHistoryView() {
        
        hasFilter = false
        
        let rfc = fiscalProfileListener
        
        historicalLeftView.innerHTML = ""
        
        historicalRightView.innerHTML = ""
        
        /// [ RFC : FIAcct.Folio ]
        var rfcFolioRefrence: [String:String] = [:]
        
        rfcFolioRefrence = [:]
        
        profiles.forEach { profile in
            rfcFolioRefrence[profile.rfc] = profile.folio
        }
        
        if let docs = due[rfc] {
            docs.forEach { doc in
                historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                
            }
        }
        
        if let docs = pending[rfc] {
            docs.forEach { doc in
                historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
            }
        }
        
        if let docs = historical[rfc] {
            docs.forEach { doc in
                historicalRightView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
            }
        }
    }
    
    func filterDocments() {
        
        var currentIds: [UUID] = []
        
        let term = documentFilter.lowercased().purgeSpaces.purgeHtml.replace(from: ",", to: "")
        
        if term.isEmpty && hasFilter {
            print("Load History")
            loadHistoryView()
            return
        }
        
        if term.isEmpty {
            return
        }
        
        print("Load Filter")
        
        hasFilter = true
        
        let rfc = fiscalProfileListener
        
        historicalLeftView.innerHTML = ""
        
        historicalRightView.innerHTML = ""
        
        /// [ RFC : FIAcct.Folio ]
        var rfcFolioRefrence: [String:String] = [:]
        
        rfcFolioRefrence = [:]
        
        profiles.forEach { profile in
            rfcFolioRefrence[profile.rfc] = profile.folio
        }
        
        /// `` full equivencily``
        if let docs = due[rfc] {
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio == term {
                    add = true
                }
                
                if doc.receptorRfc.lowercased() == term {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total == term {
                    add = true
                }

                if add {
                    currentIds.append(doc.id)
                    historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                }
                
                
                
            }
        }
        
        if let docs = pending[rfc] {
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio == term {
                    add = true
                }
                
                if doc.receptorRfc.lowercased() == term {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total == term {
                    add = true
                }

                if add {
                    
                    if currentIds.contains(doc.id) {
                        return
                    }
                    
                    currentIds.append(doc.id)
                    
                    historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                    
                }
                
            }
        }
        
        if let docs = historical[rfc] {
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio == term {
                    add = true
                }
                
                if doc.receptorRfc.lowercased() == term {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total == term {
                    add = true
                }

                if add {
                    
                    if currentIds.contains(doc.id) {
                        return
                    }
                    
                    currentIds.append(doc.id)
                    
                    historicalRightView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                    
                }
            }
        }
        
        /// `` contains equivencily``
        if let docs = due[rfc] {
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio.contains(term) {
                    add = true
                }
                
                if doc.receptorRfc.lowercased().contains(term) {
                    add = true
                }
                
                if doc.receptorName.lowercased().contains(term) {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total.contains(term) {
                    add = true
                }

                if add {
                    
                    if currentIds.contains(doc.id) {
                        return
                    }
                    
                    currentIds.append(doc.id)
                    
                    historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                }
                
            }
        }
        
        if let docs = pending[rfc] {
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio.contains(term) {
                    add = true
                }
                
                if doc.receptorRfc.lowercased().contains(term) {
                    add = true
                }
                
                if doc.receptorName.lowercased().contains(term) {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total.contains(term) {
                    add = true
                }

                if add {
                    
                    if currentIds.contains(doc.id) {
                        return
                    }
                    
                    currentIds.append(doc.id)
                    
                    historicalLeftView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                }
                
            }
        }
        
        if let docs = historical[rfc] {
            
            docs.forEach { doc in
                
                var add = false
                
                if doc.folio.contains(term) {
                    add = true
                }
                
                if doc.receptorRfc.lowercased().contains(term) {
                    add = true
                }
                
                if doc.receptorName.lowercased().contains(term) {
                    add = true
                }
                
                let total = doc.total.fromCents.toString.explode(".").first ?? ""
                
                if total.contains(term) {
                    add = true
                }

                if add {
                    
                    if currentIds.contains(doc.id) {
                        return
                    }
                    
                    currentIds.append(doc.id)
                    
                    historicalRightView.appendChild(loadFiscRow(folio: rfcFolioRefrence[doc.emisorRfc] ?? "", doc: doc))
                }
            }
            
        }
    }
    
    func loadFiscRow(folio: String, doc: FIAccountsServices) -> FiscalDocumentRow {

        return FiscalDocumentRow(
            folio: folio,
            doc: doc
        )

    }
    
    func printTicket(stamp: FIAccountsServices, raw: Comprobante.IngresoRaw){
        
        guard let profile else {
            print("❌ Fiscal Profile not found")
            return
        }
        
        guard let store = stores[custCatchStore] else {
            print("❌ store not found")
            return
        }
        
        var logo = profile.logo
        
        if logo.isEmpty, let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            logo = _logo
        }
        
        let qr = "data:image/png;base64,\(raw.qr)"
        
        let productTable = Table{
            Tr{
                Td("Unis.")
                Td("Descripcion")
                Td("P. Uni.")
                Td("Importe")
            }
        }
            .width(100.percent)
        
        let body = Div{
            
            Div{
                if !logo.isEmpty {
                    Img()
                        .src("https://\(custCatchUrl)/contenido/\(logo)")
                        .width(90.percent)
                }
                
                H2(profile.nomComercial)
                
                Div{
                    if !store.street.isEmpty { Span(store.street).marginLeft(7.px) }
                    if !store.colony.isEmpty { Span(store.colony).marginLeft(7.px) }
                    if !store.city.isEmpty { Span(store.city).marginLeft(7.px) }
                }
                .marginBottom(7.px)
                
                /*
                Div("\(store.telephone) \(store.email) ")
                    .marginBottom(7.px)
                */
                
                Div{
                    if !store.schedulea.isEmpty { P(store.schedulea) }
                    if !store.scheduleb.isEmpty { P(store.scheduleb) }
                    if !store.schedulec.isEmpty { P(store.schedulec) }
                }
                .marginBottom(7.px)
                
            }
            .align(.center)
            
            H4("Factura Electronica \(stamp.version)")
            
            Table {
                Tr{
                    Td("Folio Fiscal")
                    Td(stamp.uuid?.uuidString ?? "")
                }
                Tr{
                    Td("Certificado SAT")
                    Td(stamp.noCertSat)
                }
                Tr{
                    Td("Certificado del Emisor")
                    Td(stamp.noCertCFDI)
                }
                Tr{
                    Td("Fecha de Certificación")
                    Td("\(getDate(stamp.officialDate).formatedLong) \(getDate(stamp.officialDate).time)")
                }
            }
            .width(100.percent)
            
            H4("Emisor")
            
            Table {
                Tr{
                    Td("Razon Social")
                        .colSpan(1)
                }
                Tr{
                    Td(raw.emisor.nombre)
                        .colSpan(1)
                }
                Tr{
                    Td("RFC")
                    Td(raw.emisor.rfc)
                }
                Tr{
                    Td("Tipo")
                    Td("\(stamp.tipoDeComprobante.code) \(stamp.tipoDeComprobante.description)")
                }
            }
            .width(100.percent)
            
            H4("Receptor")
            
            Table {
                Tr{
                    Td("Razon Social")
                        .colSpan(1)
                }
                Tr{
                    Td(raw.receptor.nombre)
                        .colSpan(1)
                }
                Tr{
                    Td("RFC")
                    Td(raw.receptor.rfc)
                }
                Tr{
                    Td("USO")
                    Td("\(raw.receptor.usoCFDI.code) \(raw.receptor.usoCFDI.description)")
                }
            }
            .width(100.percent)
            
            H4("Conceptos")
            
            productTable
            
            Br()
            
            Br()
            
            H5("Cadena Original")
                .marginBottom(3.px)
            
            Div(raw.cadenaOriginal)
            
            H5("Sello Digita Contribuyente")
                .marginBottom(3.px)
            
            Div(raw.selloCFDI)
            
            H5("Sello Digita SAT")
                .marginBottom(3.px)
            
            P(raw.selloSAT)
            
            Div{
                Img()
                    .width(70.percent)
                    .src(qr)
            }
            .align(.center)
            
        }
            .width(100.percent)

        raw.conceptos.concepto.forEach { item in
            
            productTable.appendChild(Tr{
                Td(item.cantidad.formatMoney)
                Td(item.descripcion)
                Td(item.valorUnitario.formatMoney)
                Td(item.importe.formatMoney)
            })
            
        }
        
        productTable.appendChild(Tr{
            Td("Sub Total")
                .colSpan(2)
            Td(raw.subTotal.formatMoney)
                .colSpan(2)
        })
        
        if let traslados = raw.impuestos?.traslados?.traslado {
            productTable.appendChild(Tr{
                Td("Taladados")
                    .colSpan(2)
                Td(traslados.map{ $0.importe }.reduce(0, +).formatMoney)
                    .colSpan(2)
            })
        }
        
        if let retenidos = raw.impuestos?.retenidos?.retenido {
            productTable.appendChild(Tr{
                Td("Retenidos")
                    .colSpan(2)
                Td(retenidos.map{ $0.importe }.reduce(0, +).formatMoney)
                    .colSpan(2)
            })
        }
        
        productTable.appendChild(Tr{
            Td("Total")
                .colSpan(2)
            Td(raw.total.formatMoney)
                .colSpan(2)
        })
        
        generalPrint(body: body.innerHTML)
        
    }
    
    func advancedSearch(){
        
        $fiscalProfileListener
        
        
        var prof: FiscalEndpointV1.Profile? = nil
        
        profiles.forEach { _prof in
            if fiscalProfileListener == _prof.rfc {
                prof = _prof
            }
        }
        
        guard let emisorRfc = prof?.rfc else {
            showError(.errorGeneral, "No se ha seleccionado perfil fiscal")
            return
        }
        
        if documentFilter.count < 5 {
            showError(.errorGeneral, "El terminos de busqueda debe de ser de minimo 5 caracteres.")
            return
        }
        
        loadingView(show: true)
        
        API.fiscalV1.search(
            emisorRfc: emisorRfc,
            term: documentFilter
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                self.infoDiv.color(.gold)
                self.infoDiv.appendChild(Div("Error de conexion al servidor"))
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
            
            self.due.removeAll()
            
            self.pending.removeAll()
            
            self.historical.removeAll()
            
            payload.oncredit.forEach { doc in
                
                if let _ = self.pending[doc.emisorRfc]  {
                    self.pending[doc.emisorRfc]?.append(doc)
                }
                else {
                    self.pending[doc.emisorRfc] = [doc]
                }
            }
            
            payload.current.forEach { doc in
                if let _ = self.historical[doc.emisorRfc]  {
                    self.historical[doc.emisorRfc]?.append(doc)
                }
                else {
                    self.historical[doc.emisorRfc] = [doc]
                }
            }
            
            self.hasLoadedHistory = true
            
            self.loadHistoryView()
            
        }
    }
}

/// Helpers and controlers
extension ToolFiscal {
    
    struct RequestSalePointGlobalFiscal: Codable, Equatable {
        
        let id: UUID
        let sales: [CustSaleQuick]
        let payments: [CustAcctPaymentsQuick]
        let products: [CustPOCInventorySoldObject]
        let services: [CustAcctChargesQuick]
        let fiscCodes: [FIClaveProductQuick]
        let fiscUnits: [FIClaveUnidadQuick]
        let pocs: [CustPOCQuick]
        
        init(
            sales: [CustSaleQuick],
            payments: [CustAcctPaymentsQuick],
            products: [CustPOCInventorySoldObject],
            services: [CustAcctChargesQuick],
            fiscCodes: [FIClaveProductQuick],
            fiscUnits: [FIClaveUnidadQuick],
            pocs: [CustPOCQuick]
        ) {
            self.id = .init()
            self.sales = sales
            self.payments = payments
            self.products = products
            self.services = services
            self.fiscCodes = fiscCodes
            self.fiscUnits = fiscUnits
            self.pocs = pocs
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
    }
    
    /// What kind of load will we be handelin
    /// manual, order{id}, sale{id}, loadFiscalDoc{id}
    enum LoadType: CustomStringConvertible, Equatable {
         
        case manual
        case order(id: UUID)
        case sale(id: UUID)
        case loadFiscalDoc(id: UUID)
        case salePinGlobalSale(payload: RequestSalePointGlobalFiscal)
        
        var description: String {
            switch self {
            case .manual:
                return "Factura Manual"
            case .order:
                return "Facturar Orden"
            case .sale:
                return "Facturar Venta"
            case .loadFiscalDoc:
                return "Ver Documento"
            case .salePinGlobalSale:
                return  "Factura Global PDV"
            }
        }
    }
    
    enum ViewTabs {
        /// Create new manual fiscal Document
        case mainView
        /// Historical docs view
        case history
        /// Tool View
        case tools
    }
    
    func loadMainView(){
        
        fiscalProfileListener = (profiles.first?.rfc ?? "").uppercased()
        
        profiles.forEach { profile in
            historicalRazonSelect.appendChild (
                Option(profile.razon)
                    .value(profile.rfc.uppercased())
            )
        }
        
        if profiles.count < 2 {
            historicalRazonSelect.hidden(true)
        }
        
        let rightView = Div {
            
            Label("Forma de Pago:")
                .marginBottom(3.px)
                
            Div{
                self.paymentFormsSelect
            }
            
            Div()
                .class(.clear)
                .marginTop(7.px)
            
            self.adjustmentView
            
            self.cardPaymentView
            
            self.checkPaymentView
            
            self.speiPaymentView
            
            Label("Metodo De Pago:")
                .marginBottom(3.px)
            
            self.methodFormSelect
            
            Label("Uso de factura:")
                .marginBottom(3.px)
            
            self.useOfDocumentSelect
            
            Label("Comentarios")
                .marginBottom(3.px)
            
            TextArea(self.$comment)
                .class(.textFiledBlackDarkLarge)
                .placeholder("Comentarios...")
                .width(99.percent)
                .fontSize(23.px)
                .height(70.px)
            
            Div().class(.clear).marginTop(7.px)
                .hidden(self.$profiles.map{ $0.count < 2 })
            
            self.issuerView
            
            Div().class(.clear).marginTop(7.px)
            
            self.reciverView
            
        }
        .height(100.percent)
        .width(30.percent)
        .overflow(.auto)
        .color(.white)
        .float(.left)
        
        let leftView = Div{
            
            Div{
                /// Header
                Div{
                    
                    Div("")
                        .width(5.percent)
                        .float(.left)
                    
                    Div("Unis.")
                        .width(10.percent)
                        .float(.left)
                    
                    Div("Descripción y costo")
                        .width(55.percent)
                        .float(.left)
                    
                    Div("Sub Total")
                        .width(15.percent)
                        .align(.center)
                        .float(.left)
                    
                    Div("Total")
                        .width(15.percent)
                        .align(.center)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                .marginBottom(7.px)
                .marginTop(7.px)
                
                Div().class(.clear)
                
                self.itemsDiv
                    
                Div().class(.clear)
                
                Div{
                    Div{
                        
                        Div{
                            
                            Div{
                                
                                Img()
                                    .src("/skyline/media/history_color.png" )
                                    .marginRight(3.px)
                                    .marginLeft(3.px)
                                    .height(18.px)
                            }
                            .marginTop(5.px)
                            
                        }
                        
                        .class(.uibtn)
                        .float(.left)
                        .onClick {
                            self.addCartaPorte(loadHistory: true)
                        }
                        
                        Div{
                            
                            Div{
                                
                                Img()
                                    .src(self.$cartaPorte.map{ ($0 == nil) ? "/skyline/media/add.png" : "/skyline/media/checkmark.png" })
                                    .height(18.px)
                                    .marginLeft(7.px)
                            }
                            .marginTop(5.px)
                            .float(.left)
                            
                            
                            Span("Carta Porte")
                        }
                        .marginLeft(-3.px)
                        .class(.uibtn)
                        .float(.left)
                        .onClick {
                            self.addCartaPorte(loadHistory: false)
                        }
                    }
                    
                    Div().class(.clear)
                    
                    self.infoDiv
                        .overflow(.auto)
                        .height(85.px)
                }
                .width(50.percent)
                .height(115.px)
                .float(.left)
                
                
                Div {
                    /// SubTotal
                    Div{
                        Div("SubTotal")
                            .width(40.percent)
                            .align(.right)
                            .float(.left)
                        
                        Div(self.$subTotal)
                            .width(60.percent)
                            .align(.center)
                            .align(.right)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    .color(.lightGray)
                    
                    Div()
                        .marginTop(7.px)
                        .class(.clear)
                    
                    /// Trasladados
                    Div{
                        Div("Trasladados")
                            .width(40.percent)
                            .align(.right)
                            .float(.left)
                        
                        Div(self.$trasTotal)
                            .width(60.percent)
                            .align(.center)
                            .align(.right)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    .color(.lightGray)
                    Div()
                        .marginTop(7.px)
                        .class(.clear)
                    
                    /// Retenidos
                    Div{
                        Div("Retenidos")
                            .width(40.percent)
                            .align(.right)
                            .float(.left)
                        
                        Div(self.$retTotal)
                            .width(60.percent)
                            .align(.center)
                            .align(.right)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    .color(.lightGray)
                    Div()
                        .marginTop(7.px)
                        .class(.clear)
                    
                    /// Total
                    Div{
                        Div("TOTAL")
                            .width(40.percent)
                            .align(.right)
                            .float(.left)
                        
                        Div(self.$total)
                            .width(60.percent)
                            .align(.center)
                            .align(.right)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    .fontSize(24.px)
                    .color(.white)
                    
                    Div()
                        .marginTop(7.px)
                        .class(.clear)
                    
                }
                .width(50.percent)
                .height(115.px)
                .float(.left)
                
                Div().class(.clear)
                
                Div{
                    
                    Div{
                        
                        Span("Calculo de impuestos")
                            .marginRight(7.px)
                            .color(.white)
                        
                        Div().class(.clear)
                        
                        self.taxCalcToggle
                            .marginRight(7.px)
                            .float(.left)
                        
                        H2(self.$substractedTaxCalculation.map{$0 ? "Sustraido" : "Agregado"})
                            .color(.white)
                            .float(.left)
                    }
                    .float(.left)
                    
                    Div("+ Agregar Cargo")   
                        .class(.uibtnLarge)
                        .float(.right)
                        .onClick{
                            
                            if self.lockPrices {
                                return
                            }
                            
                            let addChargeFormView = AddChargeFormView(
                                allowManualCharges: false,
                                allowWarrantyCharges: false,
                                socCanLoadAction: false,
                                costType: .cost_a, 
                                currentSOCMasters: []
                            ) { pocid, isWarenty, internalWarenty in
                                
                                let view = ConfirmProductView(
                                    accountId: self.reciver?.id,
                                    costType: .cost_a,
                                    pocid: pocid,
                                    selectedInventoryIDs: []
                                ) { poc, price, costType, _units, items, storeid, isWarenty, internalWarenty, generateRepositionOrder, soldObjectFrom in
                                    
                                    /// ``⚠️ ALERT `` should come in cents not hole units
                                    let units:Int64 = _units * 1000000
                                    
                                    let unitCost:Int64 = price * 10000
                                    
                                    let total:Int64 = unitCost * _units
                                    
                                    let trasladados: [FiscalItemTaxItem] = [
                                        .init(
                                            type: .iva,
                                            factor: .tasa,
                                            taza: "0.160000"
                                        )
                                    ]
                                    
                                    self.items.append(.init(
                                        type: .service,
                                        id: poc.id,
                                        fiscCode: poc.fiscCode,
                                        fiscCodeDescription: "",
                                        fiscUnit: poc.fiscUnit,
                                        fiscUnitDescription: "",
                                        series: "",
                                        code: poc.upc,
                                        name: "\(poc.brand) \(poc.model) \(poc.name)".purgeSpaces,
                                        discount: 0,
                                        units: units,
                                        unitCost: unitCost,
                                        total: total,
                                        uids: items.map{ $0.id },
                                        taxes: .init(
                                            retenidos: [],
                                            trasladados: trasladados
                                        )
                                    ))
                                    
                                    
                                }
                                
                                self.appendChild(view)
                                
                            }
                            addSoc: { soc, codeType, isWarenty, internalWarenty in
                                
                                let units:Int64 = soc.units * 10000
                                
                                let unitCost:Int64 = soc.price * 10000
                                
                                let total:Int64 = unitCost * (soc.units / 100)
                                
                                let trasladados: [FiscalItemTaxItem] = [
                                    .init(
                                        type: .iva,
                                        factor: .tasa,
                                        taza: "0.160000"
                                    )
                                ]
                                
                                self.items.append(.init(
                                    type: .service,
                                    id: soc.id,
                                    fiscCode: soc.fiscCode,
                                    fiscCodeDescription: "",
                                    fiscUnit: soc.fiscUnit,
                                    fiscUnitDescription: "",
                                    series: "",
                                    code: "",
                                    name: soc.description,
                                    discount: 0,
                                    units: units,
                                    unitCost: unitCost,
                                    total: total,
                                    taxes: .init(
                                        retenidos: [],
                                        trasladados: trasladados
                                    )
                                ))
                                
                            }
                            
                            self.appendChild(addChargeFormView)
                            
                            addChargeFormView.searchTermInput.select()
                            
                        }
                    
                    Div("+ Agregar Cargo Manual")
                        .marginRight(12.px)
                        .class(.uibtnLarge)
                        .float(.right)
                        .color(.gray)
                        .onClick {
                            
                            if self.lockPrices {
                                return
                            }
                            
                            addToDom(ToolFiscalAddManualChargeView(
                                item: nil,
                                substractedTaxCalculation: self.substractedTaxCalculation,
                                lockPrices: false,
                                add: { item in
                                    self.items.append(item)
                                },
                                update: { item in
                                    /// Update does not apply to new object
                                },
                                remove: { id in
                                    /// Remove does not apply to new object
                                }))
                        }
                    
                    Div().class(.clear)
                }
                .align(.right)
                .hidden(self.$lockPrices)
                
                Div().class(.clear).marginTop(7.px)
                
                Div{
                    
                    Div{
                        
                        Span("Validar Datos")
                        
                        if self.loadType == .manual {
                            
                            Div{
                                Img()
                                    .src(self.$verifyDropDownIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                    .class(.iconWhite)
                                    .paddingTop(7.px)
                                    .width(18.px)
                            }
                            .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                            .paddingRight(3.px)
                            .paddingLeft(7.px)
                            .marginLeft(7.px)
                            .float(.right)
                            .onClick { _, event in
                                self.verifyDropDownIsHidden = !self.verifyDropDownIsHidden
                                event.stopPropagation()
                            }
                            Div().clear(.both)
                            
                        }
                    }
                    .class(.uibtnLargeOrange)
                    .align(.right)
                    .float(.right)
                    .onClick {
                        self.validateFiscalDocument()
                    }
                    
                    if self.loadType == .manual {
                        Div("Guardadas")
                            .hidden(self.$items.map{ !$0.isEmpty })
                            .class(.uibtnLarge)
                            .onClick { _, event in
                                self.verifyDropDownIsHidden = true
                                self.openSavedManualDocuments()
                                event.stopPropagation()
                            }
                    }
                    
                    Div().clear(.both)
                    
                    if self.loadType == .manual {
                        
                        Div{
                            Div{
                                Div{
                                    Img()
                                        .src("/skyline/media/diskette.png")
                                        .marginRight(7.px)
                                        .paddingTop(7.px)
                                        .width(18.px)
                                    
                                    Span("Guardar")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.saveManualDocument()
                                    event.stopPropagation()
                                }
                                
                                Div{
                                    
                                    Img()
                                        .src("/skyline/media/download2.png")
                                        .marginRight(7.px)
                                        .paddingTop(7.px)
                                        .width(18.px)
                                        
                                    Span("Descargar")
                                }
                                .width(90.percent)
                                .marginTop(7.px)
                                .class(.uibtn)
                                .onClick { _, event in
                                    self.verifyDropDownIsHidden = true
                                    self.downLoadManualDocument()
                                    event.stopPropagation()
                                }
                                
                                Div().marginTop(7.px)
                            }
                            .hidden(self.$verifyDropDownIsHidden)
                            .backgroundColor(.transparentBlack)
                            .position(.absolute)
                            .borderRadius(12.px)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .marginTop(7.px)
                            .right(0.px)
                            .onClick { _, event in
                                event.stopPropagation()
                            }
                        }
                        .float(.right)
                        
                    }
                    
                }
                
            }
            .custom("height", "calc(100% - 14px)")
            .marginLeft(7.px)
        }
        .height(100.percent)
        .width(70.percent)
        .overflow(.auto)
        .color(.white)
        .float(.left)
        
        switch self.loadType {
        case .manual:
            break
        case .order(id: let id):
            
            lockPrices = true
            
            API.custOrderV1.getCharges(orderid: id) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se localizo payload de data.")
                    return
                }
                
                var _items: [FiscalItem] = []
                
                var fiscCodeRefrence: [String:String] = [:]
                
                var fiscUnitRefrence: [String:String] = [:]
                
                payload.fiscCodes.forEach { code in
                    fiscCodeRefrence[code.code] = code.realValue
                }
                
                payload.fiscUnits.forEach { code in
                    fiscUnitRefrence[code.code] = code.realValue
                }
                
                payload.charges.forEach { charge in
                    
                    let units:Int64 = charge.cuant * 10000
                    
                    let unitCost:Int64 = charge.price * 10000
                    
                    let total:Int64 = unitCost * (charge.cuant / 100)
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var type: ChargeType = .manual
                    
                    if let _ = charge.SOC {
                        type = .service
                    }
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    _items.append(.init(
                        type: type,
                        id: charge.SOC,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: "",
                        name: charge.name,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                }
                
                /// products
                /// POC ID : CustPOC
                var pocsRef: [UUID:[CustPOCQuick]] = [:]
                
                var pocWithDifrentePriceBase: [CustPOCQuick] = []
                
                payload.pocs.forEach { charge in
                    
                    if let poc = pocsRef[charge.id]?.first {
                        
                        if poc.pricea == charge.pricea {
                            pocsRef[charge.id]?.append(charge)
                        }
                        else{
                            pocWithDifrentePriceBase.append(charge)
                        }
                        
                    }
                    else {
                        pocsRef[charge.id] = [charge]
                    }
                    
                }
                
                var hasError = false
                
                pocsRef.forEach { id, pocs in
                    
                    guard let charge = pocs.first else{
                        hasError = true
                        return
                    }
                    
                    let units:Int64 = Int64(pocs.count * 1000000)
                    
                    let unitCost:Int64 = charge.pricea * 10000
                    
                    let total:Int64 = unitCost
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    var code = charge.upc
                    
                    if code.isEmpty {
                        code = charge.model
                    }
                    
                    _items.append(.init(
                        type: .product,
                        id: charge.id,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: code,
                        name: "\(charge.brand) \(charge.model) \(charge.name)".purgeSpaces,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                }
                
                pocWithDifrentePriceBase.forEach { charge in
                    
                    let units:Int64 = 100 * 10000
                    
                    let unitCost:Int64 = charge.pricea * 10000
                    
                    let total:Int64 = unitCost
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    var code = charge.upc
                    
                    if code.isEmpty {
                        code = charge.model
                    }
                    
                    _items.append(.init(
                        type: .product,
                        id: charge.id,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: code,
                        name: "\(charge.brand) \(charge.model) \(charge.name)".purgeSpaces,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                    
                }
                
                if hasError {
                    
                    addToDom(ConfirmView(type: .ok, title: "Documento no soportado", message: "Hay un error al renderizar productos. reporte el folio de la venta Soporte TC", callback: { isConfirmed, comment in
                        self.remove()
                    }) )
                    
                    return
                }
                
                if payload.payments.isEmpty {
                    
                    self.paymentFormListener = "99"
                    
                    self.paymentFormsSelect.disabled(true)
                    
                }
                else if payload.payments.count == 1 {
                    
                    guard let payment = payload.payments.first else {
                        return
                    }
                    
                    self.paymentFormListener = payment.fiscCode.rawValue
                    
                    self.paymentFormsSelect.disabled(true)
                    
                    self.adjustmentView.hidden(true)
                    
                    self.cardPaymentView.hidden(true)
                    
                    self.checkPaymentView.hidden(true)
                    
                    self.speiPaymentView.hidden(true)
                    
                }
                else{
                    
                    addToDom(ConfirmView(type: .ok, title: "Documento no soportado", message: "Tiene mas un pago registrado en el folio, haga la factura manual.", callback: { isConfirmed, comment in
                        self.remove()
                    }) )
                    
                }
                
                self.items = _items
                
            }
            
        case .sale(id: let id):
            
            lockPrices = true
            
            API.custOrderV1.getCharges(orderid: id) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, "No se localizo payload de data.")
                    return
                }
                
                var _items: [FiscalItem] = []
                
                var fiscCodeRefrence: [String:String] = [:]
                
                var fiscUnitRefrence: [String:String] = [:]
                
                payload.fiscCodes.forEach { code in
                    fiscCodeRefrence[code.code] = code.realValue
                }
                
                payload.fiscUnits.forEach { code in
                    fiscUnitRefrence[code.code] = code.realValue
                }
                
                payload.charges.forEach { charge in
                    
                    let units:Int64 = charge.cuant * 10000
                    
                    let unitCost:Int64 = charge.price * 10000
                    
                    let total:Int64 = unitCost * (charge.cuant / 100)
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var type: ChargeType = .manual
                    
                    if let _ = charge.SOC {
                        type = .service
                    }
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    _items.append(.init(
                        type: type,
                        id: charge.SOC,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: "",
                        name: charge.name,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                }
                
                /// products
                /// POC ID : CustPOC
                var pocsRef: [UUID:[CustPOCQuick]] = [:]
                
                var pocWithDifrentePriceBase: [CustPOCQuick] = []
                
                payload.pocs.forEach { charge in
                    
                    if let poc = pocsRef[charge.id]?.first {
                        
                        if poc.pricea == charge.pricea {
                            pocsRef[charge.id]?.append(charge)
                        }
                        else{
                            pocWithDifrentePriceBase.append(charge)
                        }
                        
                    }
                    else {
                        pocsRef[charge.id] = [charge]
                    }
                    
                }
                
                var hasError = false
                
                pocsRef.forEach { id, pocs in
                    
                    guard let charge = pocs.first else{
                        hasError = true
                        return
                    }
                    
                    let units:Int64 = Int64(pocs.count * 1000000)
                    
                    let unitCost:Int64 = charge.pricea * 10000
                    
                    let total:Int64 = unitCost
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    var code = charge.upc
                    
                    if code.isEmpty {
                        code = charge.model
                    }
                    
                    _items.append(.init(
                        type: .product,
                        id: charge.id,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: code,
                        name: "\(charge.brand) \(charge.model) \(charge.name)".purgeSpaces,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                    
                    
                }
                
                pocWithDifrentePriceBase.forEach { charge in
                    
                    let units:Int64 = 100 * 10000
                    
                    let unitCost:Int64 = charge.pricea * 10000
                    
                    let total:Int64 = unitCost
                    
                    let trasladados: [FiscalItemTaxItem] = [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                    
                    var _fiscCode = ""
                    var _fiscCodeDescription = ""
                    
                    var _fiscUnit = ""
                    var _fiscUnitDescription = ""
                    
                    if let codeDescription = fiscCodeRefrence[charge.fiscCode] {
                        _fiscCode = charge.fiscCode
                        _fiscCodeDescription = codeDescription
                    }
                    
                    if let codeDescription = fiscUnitRefrence[charge.fiscUnit] {
                        _fiscUnit = charge.fiscUnit
                        _fiscUnitDescription = codeDescription
                    }
                    
                    var code = charge.upc
                    
                    if code.isEmpty {
                        code = charge.model
                    }
                    
                    _items.append(.init(
                        type: .product,
                        id: charge.id,
                        fiscCode: _fiscCode,
                        fiscCodeDescription: _fiscCodeDescription,
                        fiscUnit: _fiscUnit,
                        fiscUnitDescription: _fiscUnitDescription,
                        series: "",
                        code: code,
                        name: "\(charge.brand) \(charge.model) \(charge.name)".purgeSpaces,
                        discount: 0,
                        units: units,
                        unitCost: unitCost,
                        total: total,
                        taxes: .init(
                            retenidos: [],
                            trasladados: trasladados
                        )
                    ))
                    
                }
                
                if hasError {
                    
                    addToDom(ConfirmView(type: .ok, title: "Documento no soportado", message: "Hay un error al renderizar productos. reporte el folio de la venta Soporte TC", callback: { isConfirmed, comment in
                        self.remove()
                    }) )
                    
                    return
                }
                
                if payload.payments.isEmpty {
                    
                    self.paymentFormListener = "99"
                    
                    self.paymentFormsSelect.disabled(true)
                    
                }
                else if payload.payments.count == 1 {
                    
                    guard let payment = payload.payments.first else {
                        return
                    }
                    
                    self.paymentFormListener = payment.fiscCode.rawValue
                    
                    self.paymentFormsSelect.disabled(true)
                    
                    self.adjustmentView.hidden(true)
                    
                    self.cardPaymentView.hidden(true)
                    
                    self.checkPaymentView.hidden(true)
                    
                    self.speiPaymentView.hidden(true)
                    
                }
                else{
                    
                    addToDom(ConfirmView(type: .ok, title: "Documento no soportado", message: "Tiene mas un pago registrado en el folio, haga la factura manual.", callback: { isConfirmed, comment in
                        self.remove()
                    }) )
                    
                }
                
                self.items = _items
                
            }
            
        case .loadFiscalDoc(id: let id):
            lockPrices = true
        case .salePinGlobalSale(let payload):
            
            /*
             let sales: [CustSaleQuick]
             let payments: [CustAcctPaymentsQuick]
             let products: [CustPOCInventorySoldObject]
             let services: [CustAcctChargesQuick]
             let fiscCodes: [FIClaveProductQuick]
             let fiscUnits: [FIClaveUnidadQuick]
             */
            
            /// [ saleId : [items]]
            var amountref: [FiscalPaymentCodes:Int64] = [:]
            
            /// [ saleId : [items]]
            var payref: [UUID:[CustAcctPaymentsQuick]] = [:]
            
            /// [ saleId : [items]]
            var prodref: [UUID:[CustPOCInventorySoldObject]] = [:]
            
            /// [ saleId : [items]]
            var svcref: [UUID:[CustAcctChargesQuick]] = [:]
            
            /// code : FIClaveProductQuick
            var coderef: [String:FIClaveProductQuick] = [:]
            
            /// code : FIClaveUnidadQuick
            var unitref: [String:FIClaveUnidadQuick] = [:]
            
            var pocref: [UUID:CustPOCQuick] = [:]
            
            payload.payments.forEach { item in
                
                guard let id = item.custFolio else {
                    return
                }
                
                if let _ = amountref[item.fiscCode] {
                    amountref[item.fiscCode]? += item.cost
                }
                else{
                    amountref[item.fiscCode] =  item.cost
                }
                
                if let _ = payref[id] {
                    payref[id]?.append(item)
                }
                else{
                    payref[id] = [item]
                }
                
            }

            payload.products.forEach { item in
                
                guard let id = item.custFolio else {
                    return
                }
                
                if let _ = prodref[id] {
                    prodref[id]?.append(item)
                }
                else{
                    prodref[id] = [item]
                }
            }
            
            payload.services.forEach { item in
                
                guard let id = item.custFolio else {
                    return
                }
                
                if let _ = svcref[id] {
                    svcref[id]?.append(item)
                }
                else{
                    svcref[id] = [item]
                }
            }
            
            payload.fiscCodes.forEach { item in
                coderef[item.code] = item
            }
            
            payload.fiscUnits.forEach { item in
                unitref[item.code] = item
            }
            
            payload.pocs.forEach { poc in
                pocref[poc.id] = poc
            }
            
            let sortedDictByKey = amountref.sorted{ $0.value > $1.value }


            print("- - - - - - - - - - -  TOTAL CODE")

            amountref.forEach { code , amount in
                print("CODE: \(code.rawValue) AMOUNT: \(amount.formatMoney)")
            }
            
            print("- - - - - - - - - - -  parced CODE")

            sortedDictByKey.forEach { code , amount in
                print("CODE: \(code.rawValue) AMOUNT: \(amount.formatMoney)")
            }



            guard let primaryPaymentMethod = sortedDictByKey.first?.key else {
                showError(.errorGeneral, "No se puedo establecer metodo de pago primario")
                return
            }
            
            /*
            guard let profile else {
                showError(.errorGeneral, "No se puedo establecer perfil fiscal primario")
                return
            }
            */

            print("primaryPaymentMethod \(primaryPaymentMethod.rawValue)")

            paymentFormListener = primaryPaymentMethod.rawValue
            
            // TODO: CHECK WHY is it not giving proper payment type 
            //paymentFormsSelect.disabled(true)
            
            searchCustomer("XAXX010101000")
            
            var _items: [FiscalItem] = []
            
            payload.sales.forEach { sale in
                
                if let pocs = prodref[sale.id] {
                    pocs.forEach { poc in
                        
                        _items.append(.init(
                            type: ChargeType.product,
                            id: poc.id,
                            fiscCode: poc.fiscCode,
                            fiscCodeDescription: coderef[poc.fiscCode]?.realValue ?? "",
                            fiscUnit: poc.fiscUnit,
                            fiscUnitDescription: unitref[poc.fiscUnit]?.realValue ?? "",
                            series: "",
                            code: pocref[poc.POC]?.upc ?? "",
                            name: "\(sale.folio) \(pocref[poc.POC]?.name ?? "") \(pocref[poc.POC]?.model ?? "")".purgeSpaces,
                            discount: 0,
                            units: 1000000,
                            unitCost: poc.soldPrice! * 10000,
                            total: poc.soldPrice! * 10000,
                            taxes: .init(trasladados: [.init(
                                type: .iva,
                                factor: .tasa,
                                taza: "0.160000")
                            ])
                        ))
                    }
                }
                
                if let socs = svcref[sale.id] {
                    socs.forEach { soc in
                        
                        _items.append(.init(
                            type: ChargeType.service,
                            id: soc.id,
                            fiscCode: soc.fiscCode,
                            fiscCodeDescription: coderef[soc.fiscCode]?.realValue ?? "",
                            fiscUnit: soc.fiscUnit,
                            fiscUnitDescription: unitref[soc.fiscUnit]?.realValue ?? "",
                            series: "",
                            code: "",
                            name: "\(sale.folio) \(soc.name)".purgeSpaces,
                            discount: 0,
                            units: soc.cuant * 10000,
                            unitCost: soc.price * 10000,
                            total: (soc.price * soc.cuant) * 10000,
                            taxes: .init(trasladados: [.init(
                                type: .iva,
                                factor: .tasa,
                                taza: "0.160000")
                            ])
                        ))
                    }
                }
            }
            
            self.items = _items
        }
        
        if (custCatchHerk > 2 && linkedProfile.contains(.billing)) || self.loadType != .manual {
            
            let mainViewDiv = Div {
                rightView
                leftView
            }
                .hidden(self.$currentView.map({ $0 != .mainView }))
                .height(100.percent)
                .width(100.percent)
            
            self.fiscalView.appendChild(mainViewDiv)
            
        }
        
        self.fiscalView.appendChild(historicalView)
        
        self.fiscalView.appendChild(toolsView)
    }
    
    func changeFiscalProfile(){
        
        if profiles.count > 2 {
            
            choseFiscalProfilesView.innerHTML = ""
            
            profiles.forEach { prof in
                
                if prof.id == profile?.id {
                    return
                }
                
                choseFiscalProfilesView.appendChild(
                    Div(prof.razon)
                        .width(97.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            self.selectFiscalProfileIsHidden = true
                            self.profile = prof
                        }
                )
            }
            
            selectFiscalProfileIsHidden = false
            
        }
        else{
            
            var _prof: FiscalEndpointV1.Profile? = nil
            profiles.forEach { prof in
                if prof.id != profile?.id {
                    _prof = prof
                }
            }
            
            profile = _prof
        }
    }
    
    func searchCustomer(_ customer: String?){
        
        addToDom(SearchCustomerFiscalView(
            term: customer,
            callback: { account in
                self.reciver = account
            }, 
            create: { term in
                
                /// No customer, create cuatomer.
                addToDom(CreateNewCusomerView(
                    searchTerm: term,
                    custType: .business,
                    callback: { acctType, custType, searchTerm in
                        
                        let custDataView = CreateNewCustomerDataView(
                            acctType: acctType,
                            custType: custType,
                            orderType: nil,
                            searchTerm: searchTerm
                        ) { account in
                            /// CustAcctFiscal?
                            self.reciver = .init(
                                id: account.id,
                                folio: account.folio,
                                businessName: account.businessName,
                                firstName: account.firstName,
                                lastName: account.lastName,
                                mcc: account.lastName,
                                mobile: account.mobile,
                                email: account.email,
                                autoPaySpei: account.autoPayOxxo,
                                autoPayOxxo: account.autoPaySpei,
                                fiscalProfile: account.fiscalProfile,
                                fiscalRazon: account.fiscalRazon,
                                fiscalRfc: account.fiscalRfc,
                                fiscalRegime: account.fiscalRegime,
                                fiscalZip: account.fiscalZip,
                                cfdiUse: account.cfdiUse,
                                fiscalPOCFirstName: "",
                                fiscalPOCLastName: "",
                                fmcc: "",
                                fiscalPOCMobile: "",
                                fiscalPOCMobileValidaded: false,
                                fiscalPOCMail: "",
                                fiscalPOCMailValidaded: false,
                                crstatus: account.crstatus, 
                                isConcessionaire: account.isConcessionaire
                            )
                        }

                        self.appendChild(custDataView)
                        
                    }
                ))
            }
        ))
            
    }
    
    func _calculateTotal(){
        
        var _subTotal: Int64 = 0
        var _trasTotal: Int64 = 0
        var _retTotal: Int64 = 0
        var _total: Int64 = 0
        
        items.forEach { item in
            
            let params = calcSubTotal(
                substractedTaxCalculation: self.substractedTaxCalculation,
                units: item.units,
                cost: item.unitCost, 
                discount: item.discount,
                retenidos: item.taxes.retenidos,
                trasladados: item.taxes.trasladados
            )
            
            do{
                let data = try JSONEncoder().encode(params)
            }
            catch { }
            
            _subTotal += params.subTotal
            _trasTotal += params.trasladado
            _retTotal += params.retenido
            _total += params.total
            
        }
        
        subTotal = (_subTotal.doubleValue / 1000000).toString
        trasTotal = (_trasTotal.doubleValue / 1000000).toString
        retTotal = (_retTotal.doubleValue / 1000000).toString
        total = ((_total - _retTotal).doubleValue / 1000000).toString
        
    }
    
    func addComplento(){
        
        var prof: FiscalEndpointV1.Profile? = nil
        
        profiles.forEach { _prof in
            if fiscalProfileListener == _prof.rfc {
                prof = _prof
            }
        }
        
        guard let prof else {
            showError(.errorGeneral, "No hay perfil fiscal seleccionado")
            return
        }
        
        guard var docs = due[prof.rfc] else {
            showError(.errorGeneral, "No se localizaron documentos pendientes")
            return
        }
        
        if let due = pending[prof.rfc] {
            docs.append(contentsOf: due)
        }
        
        let view = ToolFiscalAddComplementoView(
            profile: prof,
            docs: docs
        ) { ids in
            
            if var items = self.due[prof.rfc] {
                
                var _items: [FIAccountsServices] = []
                
                items.forEach { item in
                    
                    if ids.contains(item.id) {
                        return
                    }
                    
                    _items.append(item)
                    
                }
                
                self.due[prof.rfc] = items
                
            }
            
            if var items = self.pending[prof.rfc] {
                
                var _items: [FIAccountsServices] = []
                
                items.forEach { item in
                    
                    if ids.contains(item.id) {
                        return
                    }
                    
                    _items.append(item)
                    
                }
                
                self.pending[prof.rfc] = items
                
            }
            
            self.filterDocments()
            
        }
        
        addToDom(view)
        
    }
    
    func filterPublicBanks(){
        
        generalBankResults.innerHTML = ""
        
        let term = providerFilter.lowercased().purgeSpaces
        
        if term.isEmpty {
            
            banks.forEach { bank in
                
                let view = Div{
                    Div(bank.name)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .fontSize(24.px)
                }
                    .marginBottom(7.px)
                    .borderRadius(7.px)
                    .width(95.percent)
                    .class(.uibtn)
                    .textAlign(.left)
                    .onClick {
                        self.generalBankField.class(.isOk)
                        self.providerFilter = bank.name
                        self.providerName = bank.name
                        self.provider = bank.code
                        self.generalBankResultsIsHidden = true
                    }
                
                generalBankResults.appendChild(view)
                
                
                
            }
            
        }
        else{
            
            var current: [String] = []
            
            banks.forEach { bank in
                
                if bank.name.lowercased().hasPrefix(term) {
                    current.append(bank.code)
                    
                    let view = Div{
                        Div(bank.name)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .fontSize(24.px)
                    }
                        .marginBottom(7.px)
                        .borderRadius(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                        .textAlign(.left)
                        .onClick {
                            self.generalBankField.class(.isOk)
                            self.providerFilter = bank.name
                            self.providerName = bank.name
                            self.provider = bank.code
                            self.generalBankResultsIsHidden = true
                        }
                    
                    generalBankResults.appendChild(view)
                    
                }
                
            }
            
            banks.forEach { bank in
                
                if current.contains(bank.code) {
                    return
                }
                
                if bank.name.lowercased().contains(term) {
                    
                    current.append(bank.code)
                    
                    let view = Div{
                        Div(bank.name)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .fontSize(24.px)
                    }
                        .marginBottom(7.px)
                        .borderRadius(7.px)
                        .width(95.percent)
                        .class(.uibtn)
                        .textAlign(.left)
                        .onClick {
                            self.generalBankField.class(.isOk)
                            self.providerFilter = bank.name
                            self.providerName = bank.name
                            self.provider = bank.code
                            self.generalBankResultsIsHidden = true
                        }
                    
                    generalBankResults.appendChild(view)
                    
                }
                
            }
        }
    }
    
    func openSavedManualDocuments(){
        addToDom(ViewManualSavedDocuments{ eventid, payload in
            
            self.eventid = eventid
            
            self.substractedTaxCalculation = false
            
            let item = payload.raw
            
            payload.fiscCodeRefrence.forEach { code in
                fiscCodeRefrence[code.code] = code.name
            }
            
            payload.fiscUnitRefrence.forEach { code in
                fiscUnitRefrence[code.code] = code.name
            }
            
            /// Select Fical Profile
            self.profiles.forEach { _profile in
                
                if item.emisor.rfc == _profile.rfc {
                    self.profile = .init(
                        id: _profile.id,
                        folio: _profile.folio,
                        type: _profile.type,
                        relprof: _profile.relprof,
                        rfc: _profile.rfc,
                        razon: _profile.razon,
                        logo: _profile.logo,
                        nomComercial: _profile.nomComercial
                    )
                }
                
            }
            
            /// Load Payment Info
            self.paymentFormListener = item.formaPago.rawValue
            
            /// Load Data
            self.useOfDocumentListener = item.receptor.usoCFDI.rawValue
            
            self.comment = item.comment
            
            /// load Customer Data
            
            self.reciver = payload.cusAcct
            
            /// Load Carta Porte
            self.cartaPorte = item.cartaPorte
            
            /// Load Concets
            item.conceptos.concepto.forEach { charge in
                                
                let units:Int64 = Int64(charge.cantidad * 1000000)
                
                let unitCost:Int64 = Int64(charge.valorUnitario * 1000000)
                
                let total:Int64 = unitCost * charge.cantidad.toInt64
                
                var trasladados: [FiscalItemTaxItem] = []
                
                charge.impuestos?.traslados?.traslado.forEach({ tax in
                    trasladados.append(.init(
                        type: tax.impuesto,
                        factor: tax.tipoFactor,
                        taza: tax.tasaOCuota,
                        base: tax.base.toCents,
                        importe: tax.importe.toCents
                    ))
                })
                
                var retenidos: [FiscalItemTaxItem] = []
                
                charge.impuestos?.retenidos?.retenido.forEach({ tax in
                    trasladados.append(.init(
                        type: tax.impuesto,
                        factor: tax.tipoFactor,
                        taza: tax.tasaOCuota,
                        base: tax.base.toCents,
                        importe: tax.importe.toCents
                    ))
                })
                
                var _fiscCodeDescription = ""
                
                var _fiscUnitDescription = ""
                
                if let codeDescription = fiscCodeRefrence[charge.claveProdServ] {
                    _fiscCodeDescription = codeDescription
                }
                
                if let codeDescription = fiscUnitRefrence[charge.claveUnidad] {
                    _fiscUnitDescription = codeDescription
                }
                
                self.items.append(.init(
                    type: ChargeType.manual,
                    id: nil,
                    fiscCode: charge.claveProdServ,
                    fiscCodeDescription: _fiscCodeDescription,
                    fiscUnit: charge.claveUnidad,
                    fiscUnitDescription: _fiscUnitDescription,
                    series: "",
                    code: charge.noIdentificacion,
                    name: charge.descripcion,
                    discount: 0,
                    units: units,
                    unitCost: unitCost,
                    total: total,
                    taxes: .init(
                        retenidos: retenidos,
                        trasladados: trasladados
                    )
                ))
                
            }
            
        })
    }
    
    func saveManualDocument(_ callback: ((_ id: UUID) -> ())? = nil){
        
        renderFiscalDocument(isPreDocument: true) { taxMode, comment, communicationMethod, type, accountid, orderid, folio, officialDate, profile, razon, rfc, zip, regimen, use, metodo, forma, items, provider, auth, lastFour, cartaPorte, globalInformation in
            
            loadingView(show: true)
            
            API.fiscalV1.saveManualDocument(
                eventid: self.eventid,
                taxMode: taxMode,
                comment: comment,
                communicationMethod: communicationMethod,
                type: type, 
                storeId: custCatchStore,
                accountid: accountid,
                orderid: orderid,
                officialDate: officialDate,
                profile: profile,
                razon: razon,
                rfc: rfc,
                zip: zip,
                regimen: regimen,
                use: use,
                metodo: metodo,
                forma: forma,
                items: items,
                provider: provider,
                auth: auth,
                lastFour: lastFour,
                cartaPorte: cartaPorte,
                globalInformation: globalInformation
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    self.infoDiv.color(.gold)
                    self.infoDiv.appendChild(Div("Error de conexion al servidor"))
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    self.infoDiv.color(.gold)
                    self.infoDiv.appendChild(Div(resp.msg))
                    return
                }
                
                guard let id = resp.id else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                if let callback {
                    callback(id)
                }
                
            }
            
        }
    }
    
    func downLoadManualDocument(){
        saveManualDocument(){ id in
            let link = baseSkylineAPIUrl(ie: "downPreFiscalDocument") +
            "&id=\(id.uuidString)" +
            "&tcon=web"
            
            _ = JSObject.global.goToURL!(link)
            
            showSuccess(.operacionExitosa, "Descargando")
            
        }
    }
    
}

/// Subscribe to service
extension ToolFiscal {
    
    enum HiringMode: Codable {
        
        case selectPackage
        case addInfo
        
        var description: String {
            switch self {
            case .selectPackage:
                return "Seleccione Paquete"
            case .addInfo:
                return "Ingrese información"
            }
        }
        
        var help: String {
            switch self {
            case .selectPackage:
                return "Para luego ingresar información."
            case .addInfo:
                return "Para proceder a activacion."
            }
        }
    }
    
    enum FiscalCreationMode: Codable {
        /// Taxes are deduct from total
        case substacted
        /// Taxes are aded to  total
        case added
    }
    
    func getFiscalSOCs(){
        
        loadingView(show: true)
        
        API.custAPIV1.getTCSOCAvailableServices(efect: [.fiscal]) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorDeCommunicacion, resp.msg)
                return
            }
            
             guard let data = resp.data else {
                 showError(.errorGeneral, .unexpenctedMissingPayload)
                 return
             }
             
            self.hiringMode = .selectPackage
            
            self.fiscalView.innerHTML = ""

            let leftView = Div{
                H1("Escoge el paquete ideal para ti.")
                    .color(.yellowTC)
                
                Br()
                
                H2("- Nos timbres NO expiran.")
                
                Div("No tiene fecha de caducidad.")
                    .marginBottom(7.px)
                    .marginLeft(22.px)
                    .marginTop(3.px)
                    .color(.lightGray)
                
                H2("- Los paquetes se recargan automaticamente")
                
                Div("No tienes que ir al banco o la tienda a depositar.")
                    .marginBottom(7.px)
                    .marginLeft(22.px)
                    .marginTop(3.px)
                    .color(.lightGray)
                
                H2("- Entre mas timbres más ahorras")
                
                Div("Los precios bajan al aumnetar tu consumo.")
                    .marginBottom(7.px)
                    .marginLeft(22.px)
                    .marginTop(3.px)
                    .color(.lightGray)
                
                H2("- Renovacion de FIEL y Sellos GRATIS")
                
                Div("Nosotros renovamos en el portal del SAT para tu convenincia.")
                    .marginBottom(7.px)
                    .marginLeft(22.px)
                    .marginTop(3.px)
                    .color(.lightGray)
                
                H2("- Costo de activacion $99.00")
                
                Div("Una sola vez.")
                    .marginBottom(7.px)
                    .marginLeft(22.px)
                    .marginTop(3.px)
                    .color(.lightGray)
                
                H1("¿Necesitas más?")
                    .color(.yellowTC)
                
                Br()
                
                H2("Con el servicio de PapaContador.com puedes")
                
                Br()
                
                H2("- Organizar TODAS tus facturas de manera automatica")
                
                Br()
                
                H2("- Presentación de impuestos y declaraciones")
                
                
                Br()
                
                
                H2("y mucho más, contacta a Soporte TC para más información de Papa Contador.")
            }
                .height(100.percent)
                .width(50.percent)
                .overflow(.auto)
                .color(.white)
                .float(.left)
            
            let rightView = Div()
                .custom("height", "calc(100% - 100px)")
                .overflow(.auto)
            
            data.reversed().forEach { soc in
                rightView.appendChild(
                    Div{
                        Div{
                            Span("\(soc.soc) \(soc.name)")
                            Span("$\(soc.cost.formatMoney)")
                                .color(.darkOrange)
                                .float(.right)
                        }
                        .marginBottom(7.px)
                        .fontSize(26.px)
                        
                        Div(soc.description)
                            .fontSize(18.px)
                            .color(.gray)
                        
                    }
                    .class(.uibtnLarge)
                    .border(width: .medium, style: .solid, color: self.$selectPackage.map{ ($0?.id == soc.id) ? .darkOrange : .black })
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .marginBottom(7.px)
                    .width(97.percent)
                    .color(.white)
                    .onClick {
                        self.selectPackage = soc
                    }
                )
            }
            
            self.fiscalView.appendChild(leftView)
            
            self.fiscalView.appendChild(
                Div{
                    H2("Seleccione Paquete, para ingresar info.")
                        .marginBottom(7.px)
                        .color(.yellowTC)
                    
                    rightView
                    
                    Div{
                        Div("Ingresar información >")
                            .class(.uibtnLargeOrange)
                            .color(self.$selectPackage.map{ ($0 == nil) ? .gray : .darkOrange })
                            .cursor(self.$selectPackage.map{ ($0 == nil) ? .default : .pointer })
                            .fontSize(32.px)
                            .onClick {
                                if self.selectPackage ==  nil {
                                    showAlert(.alerta, "Seleccione paquete fiscal")
                                    return
                                }
                                self.addBaseDataView(socs: data)
                            }
                    }.align(.right)
                }
                    .height(100.percent)
                    .width(50.percent)
                    .overflow(.auto)
                    .color(.white)
                    .float(.left)
            )
        }
    }
    
    func addBaseDataView(socs: [CustTCSOCObject]){
        
        guard let soc = self.selectPackage else {
            return
        }
        
        self.hiringMode = .addInfo
        
        self.fiscalView.innerHTML = ""
        
        self.fiscalView.appendChild(ManageFiscalProfile(
            fiscid: nil,
            packid: selectPackage?.id,
            socs: socs,
            callback: { profile in
                
                if fiscalProfile == nil {
                    fiscalProfile = .init(
                        paymentCode: FiscalPaymentCodes.efectivo,
                        paymentCodeObjects: [],
                        use: .gastosEnGeneral,
                        useObjects: [],
                        profiles: [profile]
                    )
                }
                
                fiscalProfiles.append(profile)
                
                self.profiles.append(profile)
                
                self.profile = profile
                
                if (custCatchHerk > 2 && linkedProfile.contains(.billing)) || self.loadType != .manual {
                    self.searchCustomer(nil)
                }
                
            })
        )
    }
    
}
