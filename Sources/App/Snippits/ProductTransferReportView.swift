//
//  ProductTransferReportView.swift
//  
//
//  Created by Victor Cantu on 5/13/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ProductTransferReportView: Div {
    
    override class var name: String { "div" }
    
    let reportType: InventoryTransferReportTypes
    
    init(
        reportType: InventoryTransferReportTypes
    ) {
        self.reportType = reportType
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var reportName = ""
    
    @State var customerName = ""
    
    /// InventoryAuditTypes
    @State var auditTypeListener = ""
    
    @State var storeSelectListener = ""
    
    lazy var storeSelect = Select(self.$storeSelectListener)
        .class(.textFiledBlackDark)
        .fontSize(22.px)
        .width(230.px)
        .height(34.px)
    
    @State var dateSelectListener = ""
    
    lazy var dateSelect = Select(self.$dateSelectListener)
        .class(.textFiledBlackDark)
        .fontSize(22.px)
        .width(230.px)
        .height(34.px)
    
    @State var startAt = ""
    
    lazy var startAtField = InputText(self.$startAt)
        .class(.textFiledBlackDark)
        .placeholder("DD/MM/AAAA")
        .fontSize(22.px)
        .width(130.px)
        .height(34.px)
    
    @State var endAt = ""
    
    lazy var endAtField = InputText(self.$endAt)
        .class(.textFiledBlackDark)
        .placeholder("DD/MM/AAAA")
        .fontSize(22.px)
        .width(130.px)
        .height(34.px)
    
    @State var startAtLabel = ""
    
    @State var endAtLabel = ""
    
    lazy var resultDiv = Div{
        Table().noResult(label: "📈 Seleccione una tienda para iniciar")
    }
    .custom("height", "calc(100% - 85px)")
    .overflow(.auto)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.reportName)
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
                Div().class(.clear)
            }
            
            Div().class(.clear).marginTop(3.px)
            
            /// Filter View
            Div{
                
                /// Seleccione Tienda
                Div{
                    Label("Seleccione Tienda")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.storeSelect
                }
                .hidden({
                    switch self.reportType {
                    case .byStores:
                        return false
                    case .byConcessionaire:
                        return true
                    }
                }())
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                /// Seleccione Tienda
                Div{
                    Label("Cliente")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    Div(self.$customerName)
                        .fontSize(24.px)
                        .color(.white)
                }
                .hidden({
                    switch self.reportType {
                    case .byStores:
                        return true
                    case .byConcessionaire:
                        return false
                    }
                }())
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div{
                    Label("Seleccione Fecha")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.dateSelect
                }
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div{
                    Label("Fecha Inicio")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.startAtField
                        .hidden(self.$endAtLabel.map{ !$0.isEmpty })
                    Span(self.$startAtLabel)
                        .hidden(self.$endAtLabel.map{ $0.isEmpty })
                        .color(.white)
                }
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div{
                    Label("Fecha Final")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.endAtField
                        .hidden(self.$endAtLabel.map{ !$0.isEmpty })
                    Span(self.$endAtLabel)
                        .hidden(self.$endAtLabel.map{ $0.isEmpty })
                        .color(.white)
                }
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div(" Crear Reporte ")
                    .class(.uibtnLargeOrange)
                    .marginRight(12.px)
                    .marginTop(18.px)
                    .float(.right)
                    .onClick {
                        self.requestReport()
                    }
                
                Div().clear(.both)
                    
            }
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .height(85.px)
            
            /// Results View
            self.resultDiv
            
        }
        .custom("height","calc(100% - 50px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(25.px)
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        storeSelect.appendChild(
            Option("Seleccione Tienda")
            .value("")
        )
        
        stores.forEach { _, store in
            storeSelect.appendChild(
                Option(store.name)
                    .value(store.id.uuidString)
            )
        }
        
        DateRangeSelection.allCases.forEach { item in
            dateSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        $dateSelectListener.listen {
            
            guard let range = DateRangeSelection(rawValue: $0)?.range else {
                self.startAtLabel = ""
                self.endAtLabel = ""
                return
            }
            
            let startAt = getDate(range.startAt)
            
            let endAt = getDate(range.endAt)
            
            self.startAtLabel = "\(startAt.formatedShort) \(startAt.time)"
            
            self.endAtLabel = "\(endAt.formatedShort) 23:59"
            
        }
        
        switch reportType {
        case .byStores:
            reportName = "Reporte por Tienda"
        case .byConcessionaire(let custAcct):
            reportName = "Reporte por Consecionario \(custAcct.businessName.isEmpty ? ( "\(custAcct.fiscalRazon)" ) :  custAcct.businessName )"
        }
        
    }
    
    func requestReport(){
        
        var type: API.custPOCV1.GetInventoryTransferReportType? = nil
        
        var id: UUID? = nil
        
        var startAtUTS: Int64? = nil
        
        var endAtUTS: Int64? = nil
        
        switch reportType {
        case .byStores:
            type = .byStore
            
            id = UUID(uuidString: storeSelectListener)
            
        case .byConcessionaire(let custAcct):
            type = .byConcessionaire
            id = custAcct.id
        }
        
        if let range = DateRangeSelection(rawValue: dateSelectListener)?.range  {
            startAtUTS = range.startAt
            endAtUTS = range.endAt
        }
        else {
            
            if startAt.isEmpty {
                showError(.campoRequerido, "Ingrese fecha de Inicio")
            }
            
            var dateParts = startAt.explode("/")
            
            if dateParts.count != 3 {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA"))
                return
            }
            
            guard let startDay = Int(dateParts[0]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31"))
                return
            }
            
            guard (startDay > 0 && startDay < 32) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31."))
                return
            }
            
            guard let startMonth = Int(dateParts[1]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard (startMonth > 0 && startMonth < 13) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard let startYear = Int(dateParts[2]) else {
                return
            }
            
            guard startYear >= (Date().year - 4) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha inicial)", message: "Año invalido, ingrese un año igual o mayor que 4 años atras."))
                return
            }
            
            var comps = DateComponents()
            
            comps.day = startDay
            comps.month = startMonth
            comps.year = startYear
            comps.hour = 0
            comps.minute = 0
            
            guard let _startAtUTS = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
                showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
                return
            }
            
            dateParts = endAt.explode("/")
            
            if dateParts.count != 3 {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "La fecha debe de tener el siguente formato:\nDD/MM/AAAA"))
                return
            }
            
            guard let endDay = Int(dateParts[0]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31"))
                return
            }
            
            guard (endDay > 0 && endDay < 32) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Dia invalido, ingrese un dia valido entre 1 y el 31."))
                return
            }
            
            guard let endMonth = Int(dateParts[1]) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard (endMonth > 0 && endMonth < 13) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Mes invalido, ingrese un mes valido entre 1 y el 12."))
                return
            }
            
            guard let endYear = Int(dateParts[2]) else {
                return
            }
            
            guard endYear >= (Date().year - 4) else {
                addToDom(ConfirmView(type: .ok, title: "Formato de fecha invalida (fecha final)", message: "Año invalido, ingrese un año igual o mayor que 4 años atras."))
                return
            }
            
            comps.day = endDay
            comps.month = endMonth
            comps.year = endYear
            comps.hour = 23
            comps.minute = 59
            
            guard let _endAtUTS = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
                showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
                return
            }
            
            startAtUTS = _startAtUTS + (60 * 60 * 6)
            
            endAtUTS = _endAtUTS + (60 * 60 * 6)
            
        }
        
        guard let type else {
            showError(.campoRequerido, "")
            return
        }
        
        guard let id else {
            showError(.campoRequerido, "")
            return
        }
        
        guard let startAtUTS else {
            showError(.campoRequerido, "")
            return
        }
        
        guard let endAtUTS else {
            showError(.campoRequerido, "")
            return
        }
        
        loadingView(show: true)
        
        API.custPOCV1.getInventoryTransferReport(
            type: type,
            id: id,
            from: startAtUTS,
            to: endAtUTS
        ) { resp in

            guard let resp else {
                loadingView(show: false)
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                return
            }
            
            guard resp.status == .ok else {
                loadingView(show: false)
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                loadingView(show: false)
                showError(.errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            self.resultDiv.innerHTML = ""
            
            var totalCostSub: Int64 = 0
            
            var totalCostTax: Int64 = 0
            
            var totalCost: Int64 = 0
            
            var totalPriceSub: Int64 = 0
            
            var totalPriceTax: Int64 = 0
            
            var totalPrice: Int64 = 0
            
            let itemRefrence: [UUID:CustPOCInventorySoldObject] = Dictionary(uniqueKeysWithValues: payload.items.map{ item in ( item.id, item ) })
            
            var tableBody = TBody()
            
            var table = Table {
                THead {
                    Tr{
                        Td("Date")
                        Td("Folio")
                        Td("Articulos")
                        Td("Descripcion")
                        Td("Costo")
                        Td("IVA")
                        Td("C. Total")
                        Td("Precio")
                        Td("IVA")
                        Td("P. Total")
                    }
                    .color(.goldenRod)
                }
                tableBody
            }
                .width(100.percent)
                .color(.white)
            
            switch type {
            case .byStore:
                payload.controls.forEach { control in
                    
                    var _costSubTotal: Int64 = 0
                    
                    var _costTaxes: Int64 = 0
                    
                    var _costTotal: Int64 = 0
                    
                    var _priceSubTotal: Int64 = 0
                    
                    var _priceTaxes: Int64 = 0
                    
                    var _priceTotal: Int64 = 0
                    
                    control.items.forEach { id in
                        
                        guard let item = itemRefrence[id] else {
                            return
                        }
                        
                        let cost = item.cost
                        
                        let price = item.soldPrice ?? 0
                        
                        let taxCost = calcSubTotal(
                            substractedTaxCalculation: true,
                            units: 100 * 10000,
                            cost: cost * 10000,
                            discount: 0,
                            retenidos: [],
                            trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                        )
                        
                        let costSubTotal = (taxCost.subTotal / 10000)
                        
                        let costTrasTotal = (taxCost.trasladado / 10000)
                        
                        let taxPrice = calcSubTotal(
                            substractedTaxCalculation: true,
                            units: 100 * 10000,
                            cost: price * 10000,
                            discount: 0,
                            retenidos: [],
                            trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                        )
                        
                        let priceSubTotal = (taxPrice.subTotal / 10000)
                        
                        let priceTrasTotal = (taxPrice.trasladado / 10000)
                        
                        _costSubTotal += costSubTotal
                        
                        _costTaxes += costTrasTotal
                        
                        _costTotal += cost
                        
                        _priceSubTotal += priceSubTotal
                        
                        _priceTaxes += priceTrasTotal
                        
                        _priceTotal += price
                        
                        
                    }
                    
                    tableBody.appendChild(Tr{
                        Td(getDate(control.createdAt).formatedLong)
                        Td(control.folio)
                        Td(control.items.count.toString)
                        Td(control.description)
                        Td(_costSubTotal.formatMoney)
                        Td(_costTaxes.formatMoney)
                        Td(_costTotal.formatMoney)
                        Td(_priceSubTotal.formatMoney)
                        Td(_priceTaxes.formatMoney)
                        Td(_priceTotal.formatMoney)
                    })
                    
                    totalCostSub += _costSubTotal
                    
                    totalCostTax += _costTaxes
                    
                    totalCost += _costTotal
                    
                    totalPriceSub += _priceSubTotal
                    
                    totalPriceTax += _priceTaxes
                    
                    totalPrice += _priceTotal
                    
                }
            case .byConcessionaire:
                payload.controls.forEach { control in
                    
                    var _costSubTotal: Int64 = 0
                    
                    var _costTaxes: Int64 = 0
                    
                    var _costTotal: Int64 = 0
                    
                    var _priceSubTotal: Int64 = 0
                    
                    var _priceTaxes: Int64 = 0
                    
                    var _priceTotal: Int64 = 0
                    
                    control.items.forEach { id in
                        
                        guard let item = itemRefrence[id] else {
                            return
                        }
                        
                        let cost = item.cost
                        
                        let price = item.soldPrice ?? 0
                        
                        let taxCost = calcSubTotal(
                            substractedTaxCalculation: true,
                            units: 100 * 10000,
                            cost: cost * 10000,
                            discount: 0,
                            retenidos: [],
                            trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                        )
                        
                        let costSubTotal = (taxCost.subTotal / 10000)
                        
                        let costTrasTotal = (taxCost.trasladado / 10000)
                        
                        let taxPrice = calcSubTotal(
                            substractedTaxCalculation: true,
                            units: 100 * 10000,
                            cost: price * 10000,
                            discount: 0,
                            retenidos: [],
                            trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                        )
                        
                        let priceSubTotal = (taxPrice.subTotal / 10000)
                        
                        let priceTrasTotal = (taxPrice.trasladado / 10000)
                        
                        if control.disperseType == .concession {
                            
                            _costSubTotal += costSubTotal
                            
                            _costTaxes += costTrasTotal
                            
                            _costTotal += cost
                            
                            _priceSubTotal += priceSubTotal
                            
                            _priceTaxes += priceTrasTotal
                            
                            _priceTotal += price
                            
                        }
                        else {
                            
                            _costSubTotal -= costSubTotal
                            
                            _costTaxes -= costTrasTotal
                            
                            _costTotal -= cost
                            
                            _priceSubTotal -= priceSubTotal
                            
                            _priceTaxes -= priceTrasTotal
                            
                            _priceTotal -= price
                            
                        }
                    }
                    
                    tableBody.appendChild(Tr{
                        Td(getDate(control.createdAt).formatedLong)
                        Td(control.folio)
                        Td(control.items.count.toString)
                        Td(control.disperseType.description)
                        Td(_costSubTotal.formatMoney)
                        Td(_costTaxes.formatMoney)
                        Td(_costTotal.formatMoney)
                        Td(_priceSubTotal.formatMoney)
                        Td(_priceTaxes.formatMoney)
                        Td(_priceTotal.formatMoney)
                    })
                    
                    totalCostSub += _costSubTotal
                    
                    totalCostTax += _costTaxes
                    
                    totalCost += _costTotal
                    
                    totalPriceSub += _priceSubTotal
                    
                    totalPriceTax += _priceTaxes
                    
                    totalPrice += _priceTotal
                    
                }
            }
            
            table.appendChild(Tr{
                Td("")
                Td("")
                Td("")
                Td("")
                Td(totalCostSub.formatMoney)
                Td(totalCostTax.formatMoney)
                Td(totalCost.formatMoney)
                Td(totalPriceSub.formatMoney)
                Td(totalPriceTax.formatMoney)
                Td(totalPrice.formatMoney)
            }.color(.goldenRod))
            
            self.resultDiv.appendChild(Div{
                H2("Reporte")
                    .color(.yellowTC)
                
                Div("Descargar")
                    .class(.uibtn)
                    .float(.right)
                    .onClick {
                        self.downloadReport(from: startAtUTS, to: endAtUTS, id: id, payload: payload)
                    }
            })
            
            self.resultDiv.appendChild(table)
            
            loadingView(show: false)
            
        }
    }
    
    func downloadReport(from: Int64, to: Int64, id: UUID, payload: CustPOCComponents.GetInventoryTransferReportResponse) {
        
        loadingView(show: true)
        
        var totalCostSub: Int64 = 0
        
        var totalCostTax: Int64 = 0
        
        var totalCost: Int64 = 0
        
        var totalPriceSub: Int64 = 0
        
        var totalPriceTax: Int64 = 0
        
        var totalPrice: Int64 = 0
        
        let itemRefrence: [UUID:CustPOCInventorySoldObject] = Dictionary(uniqueKeysWithValues: payload.items.map{ item in ( item.id, item ) })
        
        var tableBody = TBody()
        
        var name = ""
        
        switch reportType {
        case .byStores:
            stores.forEach { storeId, store in
                if storeId == id {
                    name = store.name
                }
            }
        case .byConcessionaire(let custAcct):
            name = "\(custAcct.businessName) \(custAcct.firstName) \(custAcct.lastName)"
        }
        
        var csv = "\(getDate(from).formatedLong),\(getDate(to).formatedLong),,\(reportName) \(name),,,,,,\n"
        
        csv += "Date,Folio,Articulos,Descripcion,Costo,IVA,C. Total,Precio,IVA,P. Total\n"
        
        switch reportType {
        case .byStores:
            payload.controls.forEach { control in
                
                var _costSubTotal: Int64 = 0
                
                var _costTaxes: Int64 = 0
                
                var _costTotal: Int64 = 0
                
                var _priceSubTotal: Int64 = 0
                
                var _priceTaxes: Int64 = 0
                
                var _priceTotal: Int64 = 0
                
                control.items.forEach { id in
                    
                    guard let item = itemRefrence[id] else {
                        return
                    }
                    
                    let cost = item.cost
                    
                    let price = item.soldPrice ?? 0
                    
                    let taxCost = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: cost * 10000,
                        discount: 0,
                        retenidos: [],
                        trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                    )
                    
                    let costSubTotal = (taxCost.subTotal / 10000)
                    
                    let costTrasTotal = (taxCost.trasladado / 10000)
                    
                    let taxPrice = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: price * 10000,
                        discount: 0,
                        retenidos: [],
                        trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                    )
                    
                    let priceSubTotal = (taxPrice.subTotal / 10000)
                    
                    let priceTrasTotal = (taxPrice.trasladado / 10000)
                    
                    _costSubTotal += costSubTotal
                    
                    _costTaxes += costTrasTotal
                    
                    _costTotal += cost
                    
                    _priceSubTotal += priceSubTotal
                    
                    _priceTaxes += priceTrasTotal
                    
                    _priceTotal += price
                    
                    
                }
                
                csv += "\(getDate(control.createdAt).formatedLong),\(control.folio),\(control.items.count.toString),\(control.description),\(_costSubTotal.formatMoney.replace(from: ",", to: "")),\(_costTaxes.formatMoney.replace(from: ",", to: "")),\(_costTotal.formatMoney.replace(from: ",", to: "")),\(_priceSubTotal.formatMoney.replace(from: ",", to: "")),\(_priceTaxes.formatMoney.replace(from: ",", to: "")),\(_priceTotal.formatMoney.replace(from: ",", to: ""))\n"
                
                totalCostSub += _costSubTotal
                
                totalCostTax += _costTaxes
                
                totalCost += _costTotal
                
                totalPriceSub += _priceSubTotal
                
                totalPriceTax += _priceTaxes
                
                totalPrice += _priceTotal
                
            }
        case .byConcessionaire(let account):
            payload.controls.forEach { control in
                
                var _costSubTotal: Int64 = 0
                
                var _costTaxes: Int64 = 0
                
                var _costTotal: Int64 = 0
                
                var _priceSubTotal: Int64 = 0
                
                var _priceTaxes: Int64 = 0
                
                var _priceTotal: Int64 = 0
                
                control.items.forEach { id in
                    
                    guard let item = itemRefrence[id] else {
                        return
                    }
                    
                    let cost = item.cost
                    
                    let price = item.soldPrice ?? 0
                    
                    let taxCost = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: cost * 10000,
                        discount: 0,
                        retenidos: [],
                        trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                    )
                    
                    let costSubTotal = (taxCost.subTotal / 10000)
                    
                    let costTrasTotal = (taxCost.trasladado / 10000)
                    
                    let taxPrice = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: price * 10000,
                        discount: 0,
                        retenidos: [],
                        trasladados: [.init(type: .iva, factor: .tasa, taza: "0.160000")]
                    )
                    
                    let priceSubTotal = (taxPrice.subTotal / 10000)
                    
                    let priceTrasTotal = (taxPrice.trasladado / 10000)
                    
                    if control.disperseType == .concession {
                        
                        _costSubTotal += costSubTotal
                        
                        _costTaxes += costTrasTotal
                        
                        _costTotal += cost
                        
                        _priceSubTotal += priceSubTotal
                        
                        _priceTaxes += priceTrasTotal
                        
                        _priceTotal += price
                        
                    }
                    else {
                        
                        _costSubTotal -= costSubTotal
                        
                        _costTaxes -= costTrasTotal
                        
                        _costTotal -= cost
                        
                        _priceSubTotal -= priceSubTotal
                        
                        _priceTaxes -= priceTrasTotal
                        
                        _priceTotal -= price
                        
                    }
                }
                
                csv += "\(getDate(control.createdAt).formatedLong),\(control.folio),\(control.items.count.toString),\(control.disperseType.description),\(_costSubTotal.formatMoney.replace(from: ",", to: "")),\(_costTaxes.formatMoney.replace(from: ",", to: "")),\(_costTotal.formatMoney.replace(from: ",", to: "")),\(_priceSubTotal.formatMoney.replace(from: ",", to: "")),\(_priceTaxes.formatMoney.replace(from: ",", to: "")),\(_priceTotal.formatMoney.replace(from: ",", to: ""))\n"
                
                totalCostSub += _costSubTotal
                
                totalCostTax += _costTaxes
                
                totalCost += _costTotal
                
                totalPriceSub += _priceSubTotal
                
                totalPriceTax += _priceTaxes
                
                totalPrice += _priceTotal
                
            }
        }
        
        csv += ",,,,\(totalCostSub.formatMoney.replace(from: ",", to: "")),\(totalCostTax.formatMoney.replace(from: ",", to: "")),\(totalCost.formatMoney.replace(from: ",", to: "")),\(totalPriceSub.formatMoney.replace(from: ",", to: "")),\(totalPriceTax.formatMoney.replace(from: ",", to: "")),\(totalPrice.formatMoney.replace(from: ",", to: ""))\n"
        
        _ = JSObject.global.download!( "\(reportName)_\(name)_\(getDate(from).formatedLong)-\(getDate(to).formatedLong).csv".replace(from: " ", to: "-"), csv)
        
        loadingView(show: false)
        
    }
    
}
