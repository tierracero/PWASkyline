//
//  CustRemoveFromConcessionView.swift
//
//
//  Created by Victor Cantu on 1/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/*
 public let type: RemoveFromConcessionType
 
 public let accountId: UUID
 
 public let storeId: UUID
 
 public let items: [UUID]
 
 public let comments: String
         
 */

class CustRemoveFromConcessionView: Div {
    
    override class var name: String { "div" }
    
    let account: CustAcct
    
    /// return, sale(RemoveFromConcessionPayment)
    let isSale: Bool
    
    @State var items: [CustPOCInventorySoldObject]
    
    let pocRefrence: [UUID:CustPOCQuick]
    
    private var deletedItems: ((
        _ ids: [UUID],
        _ control: CustFiscalInventoryControl?
    ) -> ())


    private var updateItem: ((
        _ itemId: UUID,
        _ price: Int64
    ) -> ())
    
    init(
        account: CustAcct,
        isSale: Bool,
        pocRefrence: [UUID:CustPOCQuick],
        items: [CustPOCInventorySoldObject],
        deletedItems: @escaping ((
            _ ids: [UUID],
            _ control: CustFiscalInventoryControl?
        ) -> ()),
        updateItem: @escaping ((
            _ itemId: UUID,
            _ price: Int64
        ) -> ())
    ) {
        self.account = account
        self.isSale = isSale
        self.pocRefrence = pocRefrence
        self.items = items
        self.deletedItems = deletedItems
        self.updateItem = updateItem
        
        super.init()
        
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var comments = ""
    
    lazy var productDiv = Div()
    
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
    
    @State var profiles: [FiscalComponents.Profile] = fiscalProfiles
    
    @State var profile: FiscalComponents.Profile? = nil
    
    @State var selectFiscalProfileIsHidden: Bool = true

    @State var grandTotal = "-.--"
    
    /// Payment States Inputs START
    lazy var paymentFormsSelect = Select($paymentFormListener)
        .class(.textFiledBlackDarkLarge)
        .width(99.percent)
        .fontSize(23.px)
    
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
    
    lazy var myBanksSelect = Select()
        .class(.textFiledBlackDarkLarge)
    
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
    
    lazy var choseFiscalProfilesView = Div()
        .custom("height", "calc(100% - 45px)")
        .marginTop(7.px)
        .overflow(.auto)
        .float(.right)
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Concesión \({ self.isSale ? "VENTA" : "DEVOLUCION" }())")
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
                Div().class(.clear)
            }
            
            Div().class(.clear).marginTop(3.px)
        
            Div{
                Div{
                    self.productDiv
                }
                .custom("width", "calc(100% - 6px)")
                .padding(all: 3.px)
            }
            .custom("height", {self.isSale ? "calc(100% - 35px)" : "calc(100% - 250px)" }())
            .width({self.isSale ? 60.percent : 100.percent }())
            .overflow(.auto)
            .float(.left)
            
            Div()
                .hidden(self.isSale)
                .clear(.both)
                .height(7.px)
            
            Div{
                Div{
                    Div{
                        Div{
                            
                            H2("Resumen General").color(.gray)
                            
                            Div().clear(.both).height(7.px)
                            
                            Div{
                                
                                H2("Unidades")
                                    .color(.white)
                                    .float(.left)
                                
                                H2(self.items.count.toString)
                                    .color(.yellowTC)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }
                            
                            Div().clear(.both).height(7.px)
                            
                            Div{
                                
                                H2("Total A")
                                    .color(.white)
                                    .float(.left)
                                
                                H2( self.$grandTotal )
                                    .color(.yellowTC)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }
                            
                            Div().clear(.both).height(7.px)
                            
                        }
                        .padding(all: 3.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            
                            H2("Comentarios").color(.gray)
                            
                            Div().clear(.both).height(7.px)
                            
                            TextArea(self.$comments)
                                .placeholder("Ingrese mensaje...")
                                .class(.textFiledBlackDark)
                                .marginBottom(12.px)
                                .padding(all:7.px)
                                .width(93.percent)
                                .height(70.px)
                            
                            Div("Devolición de Productos")
                                .class(.uibtnLargeOrange)
                                .width(95.percent)
                                .onClick {
                                    self.processReturn()
                                }
                            
                        }
                        .padding(all: 7.px)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                .margin(all: 3.px)
            }
            .height(215.px)
            .hidden(self.isSale)
            
            Div{
                
                Div{
                    
                    Div{
                        
                        H2("Resumen General").color(.gray)
                        
                        Div().clear(.both).height(3.px)
                        
                        Div{
                            
                            H2("Unidades")
                                .color(.white)
                                .float(.left)
                            
                            H2(self.items.count.toString)
                                .color(.yellowTC)
                                .float(.right)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(7.px)
                        
                        Div{
                            
                            H2("Total B")
                                .color(.white)
                                .float(.left)
                            
                            H2( self.$grandTotal )
                                .color(.yellowTC)
                                .float(.right)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).height(12.px)
                        
                        H2("Datos del Pago").color(.gray)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.paymentFormsSelect
                        
                        Div().class(.clear).marginTop(7.px)
                        
                        self.adjustmentView
                        
                        self.cardPaymentView
                        
                        self.checkPaymentView
                        
                        self.speiPaymentView
                        
                        Div().clear(.both).height(7.px)
                        
                        H2("Comentarios").color(.gray)
                        
                        Div().clear(.both).height(3.px)
                         
                        TextArea(self.$comments)
                            .placeholder("Ingrese mensaje...")
                            .class(.textFiledBlackDark)
                            .marginBottom(12.px)
                            .padding(all:7.px)
                            .width(93.percent)
                            .height(70.px)
                        
                    }
                    .custom("height", "calc(100% - 45px)")
                    .overflow(.auto)
                    
                    Div("Generar Venta")
                        .class(.uibtnLargeOrange)
                        .textAlign( .center)
                        .width(95.percent)
                        .onClick {
                            self.processSale()
                        }
                    
                }
                .custom("height", "calc(100% - 6px)")
                .padding(all: 3.px)
                 
            }
            .custom("height", "calc(100% - 35px)")
            .hidden(!self.isSale)
            .width(40.percent)
            .float(.left)
            
            Div().clear(.both)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(80.percent)
        .custom("left", {self.isSale ? "calc(50% - 450px)" : "calc(50% - 250px)" }())
        .width({self.isSale ? 900.px : 500.px }())
        .top(10.percent)
        
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

        grandTotal = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +).formatMoney 
        
        $items.listen {
            self.grandTotal = $0.map{ ($0.soldPrice ?? 0) }.reduce(0, +).formatMoney 
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
            
        }
        
        var itemsPOCRefrence: [UUID:[CustPOCInventorySoldObject]] = [:]
        
        items.forEach { item in
            if let _ = itemsPOCRefrence[item.POC] {
                itemsPOCRefrence[item.POC]?.append(item)
            }
            else {
                itemsPOCRefrence[item.POC] = [item]
            }
        }
        
        itemsPOCRefrence.forEach { pocId, items in
            
            let poc = self.pocRefrence[pocId]
            
            var avatar = "/skyline/media/skylineapp.svg"
            
            if let image = poc?.avatar {
                
                if !image.isEmpty {
                    
                    if let pDir = customerServiceProfile?.account.pDir {
                        
                        avatar = "https://intratc.co/cdn/\(pDir)/thump_\(image)"
                    }
                    
                }
                
            }
            
            let total: Int64 = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +)
            
            let table = Table{
                THead {
                    Tr{
                        Td()
                        Td("POC/SKU/UPC")
                        Td("Marca")
                        Td("Modelo")
                        Td("Nombre")
                        Td("Unis.")
                        Td("Costo")
                        Td()
                    }
                    Tr{
                        Td{
                            Img()
                                .src(avatar)
                                .height(28.px)
                                .width(28.px)
                        }.align(.center)
                        Td(poc?.upc ?? "")
                        Td(poc?.brand ?? "")
                        Td(poc?.model ?? "")
                        Td(poc?.name ?? "")
                        Td(items.count.toString)
                        Td(total.formatMoney)
                            .align(.center)
                            .colSpan(2)
                    }
                }
            }
            .width(100.percent)
            .color(.white)
            
            let tableBody = TBody()
            
            items.forEach { item in
                
                @State var viewPrice = (item.soldPrice ?? 0).formatMoney

                tableBody.appendChild(
                    Tr{
                        Td {

                            Img()
                            .src("/skyline/media/maximizeWindow.png")
                            .class(.iconWhite)
                            .cursor(.pointer)
                            .height(18.px)
                            .onClick {

                                let view = InventoryItemDetailView(itemid: item.id){ price in

                                    viewPrice = price.formatMoney

                                    var items: [CustPOCInventorySoldObject] = []

                                    Console.clear()

                                    self.items.forEach { nitem in
                                        if item.id == nitem.id {

                                            var nitem = nitem

                                            nitem.soldPrice = price

                                            print(nitem)

                                            items.append(nitem)

                                        }
                                        else {
                                            items.append(nitem)
                                        }
                                    }


                                    self.items = items

                                }

                                addToDom(view)

                            }
                            
                        }
                        Td("SERIE:").colSpan(2)
                        Td(item.series).colSpan(3)
                        Td($viewPrice)
                            .align(.center)
                            .colSpan(2)
                        
                    }
                )
                
            }
            
            table.appendChild(tableBody)
            
            self.productDiv.appendChild(table)
            
        }
        
        if isSale {
            
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
            
        }
        
        profile = profiles.first
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
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }
            
            
            guard let data = resp.data else {
                showError( .errorGeneral, .unexpenctedMissingPayload)
                return
            }
            

            switch self.paymentForm {
            case .efectivo:
                /// Cash dose not requier validation
                break
            case .chequeNominativo:
                if data.isFree {
                    self.checkPaymentNumber
                        .class(.isOk)
                }
                else{
                    self.checkPaymentNumber
                        .class(.isNok)
                }
                
            case .transferenciaElectronicaDeFondos:
                if data.isFree {
                    self.speiPaymentFolio
                        .class(.isOk)
                }
                else{
                    self.speiPaymentFolio
                        .class(.isNok)
                }
            case .tarjetaDeDebito, .tarjetaDeCredito:
                if data.isFree {
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
    
    func processReturn(){
        
        if items.isEmpty {
            showError(.errorGeneral, "No hay productutos seleccionados.")
            return
        }
        
        loadingView(show: true)
        
        API.custPDVV1.removeFromConcession(
            type: .return,
            accountId: self.account.id,
            storeId: custCatchStore,
            items: items.map{ $0.id },
            comments: comments, 
            receptorRfc: profile?.rfc ?? ""
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            if resp.status != .ok {
                showError(.campoRequerido, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError( .errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            /// CustFiscalInventoryControl
            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            var kart: [SalePointObject] = []
            
            self.items.forEach { item in
                
                guard let poc = self.pocRefrence[item.POC] else {
                    return
                }
                
                kart.append(.init(
                    id: .init(),
                    kartItemView: .init(
                        id: item.id,
                        cost: item.cost,
                        quant: 100,
                        price: item.soldPrice ?? 0,
                        data: .init(
                            t: .product,
                            i: poc.id,
                            u: poc.upc,
                            n: poc.name,
                            b: poc.brand,
                            m: poc.model,
                            p: poc.pricea,
                            a: poc.avatar,
                            reqSeries: poc.reqSeries
                        ),
                        deleteButton: false,
                        missingInventory: false,
                        callback: { _ in
                            
                        }, editManualCharge: { id, units, description, price, cost in
                            
                        }),
                    data: .init(
                        type: .product,
                        id: poc.id,
                        store: custCatchStore,
                        ids: [item.id],
                        series: [item.series],
                        cost: item.soldPrice,
                        units: 100,
                        unitPrice: item.soldPrice ?? 0,
                        subTotal: item.soldPrice ?? 0,
                        costType: .cost_a,
                        name: poc.name,
                        brand: poc.brand,
                        model: poc.model,
                        pseudoModel: poc.pseudoModel,
                        avatar: poc.avatar,
                        fiscCode: poc.fiscCode,
                        fiscUnit: poc.fiscUnit,
                        preRegister: false
                    )
                ))
                
            }
            
            switch payload {
            case .return(let payload):
                
                let view = ConcessionConfirmationView(
                    accountid: self.account.id,
                    accountFolio: self.account.folio,
                    accountName: "\(self.account.fiscalRfc) \(self.account.fiscalRegime?.description ?? "N/A")",
                    purchaseManager: payload.document.id,
                    subTotal: self.items.map{ ( $0.soldPrice ?? 0 ) }.reduce(0, +).formatMoney,
                    document: payload.document,
                    //kart: kart,
                    cardex: payload.cardex
                )
                
                addToDom(view)
                
                self.deletedItems(self.items.map{ $0.id }, payload.document)
                
                self.remove()
                
            case .sale(_):
                break
            }
            
            
        }
    }
    
    func processSale(){
        
        if items.isEmpty {
            showError(.errorGeneral, "No hay productutos seleccionados.")
            return
        }
        
        let total = items.map{ ( $0.soldPrice ?? 0 ) }.reduce(0, +)
        
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
        
        loadingView(show: true)
        
        API.custPDVV1.removeFromConcession(
            type: .sale(.init(
                fiscCode: paymentForm,
                description: "Pago",
                amount: total,
                provider: provider,
                lastFour: lastFour,
                auth: auth
            )),
            accountId: self.account.id,
            storeId: custCatchStore,
            items: items.map{ $0.id },
            comments: comments, 
            receptorRfc: profile?.rfc ?? ""
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            if resp.status != .ok {
                showError(.campoRequerido, resp.msg)
                return
            }
            
            /// CloseSaleResponse
            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
         
            var kart: [SalePointObject] = []
            
            self.items.forEach { item in
                
                guard let poc = self.pocRefrence[item.POC] else {
                    return
                }
                
                kart.append(.init(
                    id: .init(),
                    kartItemView: .init(
                        id: item.id,
                        cost: item.cost,
                        quant: 100,
                        price: item.soldPrice ?? 0,
                        data: .init(
                            t: .product,
                            i: poc.id,
                            u: poc.upc,
                            n: poc.name,
                            b: poc.brand,
                            m: poc.model,
                            p: poc.pricea,
                            a: poc.avatar,
                            reqSeries: poc.reqSeries
                        ),
                        deleteButton: false,
                        missingInventory: false,
                        callback: { _ in
                            
                        }, editManualCharge: { id, units, description, price, cost in
                            
                        }),
                    data: .init(
                        type: .product,
                        id: poc.id,
                        store: custCatchStore,
                        ids: [item.id],
                        series: [item.series],
                        cost: item.soldPrice,
                        units: 100,
                        unitPrice: item.soldPrice ?? 0,
                        subTotal: item.soldPrice ?? 0,
                        costType: .cost_a,
                        name: poc.name,
                        brand: poc.brand,
                        model: poc.model,
                        pseudoModel: poc.pseudoModel,
                        avatar: poc.avatar,
                        fiscCode: poc.fiscCode,
                        fiscUnit: poc.fiscUnit,
                        preRegister: false
                    )
                ))
                
            }
            
            switch payload {
            case .return(_):
                break
            case .sale(let sale):
                
                var cardex: [CustPOCCardex] = []
                
                sale.cardex.forEach { item in
                    if item.relation == .concession {
                        cardex.append(item)
                    }
                }
                
                let view = PaymentConfirmationView(
                    saleId: sale.id,
                    saleFolio: sale.folio,
                    accountid: self.account.id,
                    accountFolio: self.account.folio,
                    accountName: "\(self.account.fiscalRfc) \(self.account.fiscalRegime)",
                    accountMobile: self.account.mobile,
                    subTotal: total.formatMoney,
                    payment: total.formatMoney,
                    change: "0",
                    kart: kart,
                    cardex: cardex
                )
                
                addToDom(view)
                
                self.deletedItems(self.items.map{ $0.id }, nil)
                
                self.remove()
                
            }
            
        }
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
            
            var _prof: FiscalComponents.Profile? = nil
            profiles.forEach { prof in
                if prof.id != profile?.id {
                    _prof = prof
                }
            }
            
            profile = _prof
        }
    }
    
}
