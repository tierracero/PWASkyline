//
//  SalePoint+HistoryView.swift
//  
//
//  Created by Victor Cantu on 5/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension SalePointView {
    
    class HistoryView: Div {
        
        override class var name: String { "div" }
        
        var accountRefrence: [UUID:CustAcctQuick] = [:]
        
        var pocRefrence: [UUID:CustPOCQuick] = [:]
        
        @State var sales: [CustSaleQuick] = []
        
        @State var salesWithOutFiscalDocumets: [CustSaleQuick] = []
        
        @State var reportType: SalesReportTypes? = nil
        
        @State var totalBalance = "0.00"
        
        @State var reportTypeListener = ""
        
        lazy var reportTypeSelect = Select(self.$reportTypeListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .height(34.px)
        
        @State var storeSelectListener = ""
        
        lazy var storeSelect = Select(self.$storeSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .height(34.px)
        
        @State var userSelectListener = ""
        
        lazy var userSelect = Select(self.$userSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(200.px)
            .height(34.px)
        
        @State var dateSelectListener = ""
        
        lazy var dateSelect = Select(self.$dateSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(200.px)
            .height(34.px)
        
        /// the day the current active report  is done
        var startAtResultDate: Int64 = 0
        @State var startAt = ""
        
        lazy var startAtField = InputText(self.$startAt)
            .class(.textFiledBlackDark)
            .placeholder("DD/MM/AAAA")
            .fontSize(22.px)
            .width(130.px)
            .height(34.px)
        
        /// the day the current active report  is done
        var endAtResultDate: Int64 = 0
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
            Table().noResult(label: "📈 Seleccione datos para iniciar")
                .hidden(self.$sales.map{ !$0.isEmpty })
            
            Div{
            
                Div("Folio")
                    .textAlign(.center)
                    .width(10.percent)
                    .float(.left)
                
                Div("Fecha")
                    .textAlign(.center)
                    .width(15.percent)
                    .float(.left)
                
                Div("Cliente")
                    .textAlign(.center)
                    .width(25.percent)
                    .float(.left)
                
                Div("ODC")
                    .textAlign(.center)
                    .width(5.percent)
                    .float(.left)
                
                Div("ODE")
                    .textAlign(.center)
                    .width(5.percent)
                    .float(.left)
                
                Div("Total")
                    .textAlign(.center)
                    .width(15.percent)
                    .float(.left)
                
                Div("Balance")
                    .textAlign(.center)
                    .width(10.percent)
                    .float(.left)
                  
                Div("Factura")
                    .textAlign(.center)
                    .width(5.percent)
                    .float(.left)
                
                Div().clear(.both)
            }
            .hidden(self.$sales.map{ $0.isEmpty })
            .marginBottom(7.px)
            .marginTop(12.px)
            .color(.white)
            
            ForEach(self.$sales){ sale in
                
                if let accountId = sale.custAcct {
                    HistoryRow(
                        sale: sale,
                        custAcct: self.accountRefrence[accountId]
                    )
                        .fontSize(18.px)
                        .class(.rowItem)
                }
                else {
                    HistoryRow(
                        sale: sale,
                        custAcct: nil
                    )
                        .fontSize(18.px)
                        .class(.rowItem)
                }
                
                
                
            }
            .hidden(self.$sales.map{ $0.isEmpty })
            
        }
        .overflow(.auto)
        
        @State var parsablePOCs: [SearchPOCResponse] = []
        
        lazy var parceblePOCDiv = Div {
            Div(self.$parsablePOCs.map{
                if $0.isEmpty {
                    return "Buscar..."
                }
                else if $0.count == 1 {
                    
                    guard let poc = $0.first else {
                        return "1 Producto"
                    }
                    
                    if !poc.upc.isEmpty {
                        return poc.upc
                    }
                    else {
                        return "\(poc.upc) \(poc.brand) \(poc.model) \(poc.name)"
                    }
                    
                }
                else{
                    return "\($0.count.toString) Producto"
                }
            })
            .color(self.$parsablePOCs.map{ $0.isEmpty ? .gray : .white })
            .custom("width", "calc(100% - 32px)")
            .class(.oneLineText)
            .marginRight(3.px)
            .fontSize(22.px)
            .float(.left)
            
            Div{
                Img()
                    .src("/skyline/media/zoom.png")
                    .padding(all: 3.px)
                    .paddingRight(0.px)
                    .height(18.px)
            }
            .marginRight(3.px)
            .paddingTop(3.px)
            .float(.left)
            
        }
        .backgroundColor(.grayBlackDark)
        .borderRadius(all: 7.px)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .cursor(.pointer)
        .height(27.px)
        .width(230.px)
        .onClick {
            addToDom(ProductManagerView.AuditView.ProductSearch(
                parsablePOCs: self.$parsablePOCs
            ){
                
            })
        }
        
        @State var parsableSOCs: [SearchChargeResponse] = []
        
        lazy var parcebleSOCDiv = Div {
            Div(self.$parsableSOCs.map{
                if $0.isEmpty {
                    return "Buscar..."
                }
                else if $0.count == 1 {
                    
                    guard let poc = $0.first else {
                        return "1 Servicio"
                    }
                    
                    if !poc.u.isEmpty {
                        return poc.u
                    }
                    else {
                        return "\(poc.u) \(poc.b) \(poc.m) \(poc.n)"
                    }
                    
                }
                else{
                    return "\($0.count.toString) Servicios"
                }
            })
            .color(self.$parsablePOCs.map{ $0.isEmpty ? .gray : .white })
            .custom("width", "calc(100% - 32px)")
            .class(.oneLineText)
            .marginRight(3.px)
            .fontSize(22.px)
            .float(.left)
            
            Div{
                Img()
                    .src("/skyline/media/zoom.png")
                    .padding(all: 3.px)
                    .paddingRight(0.px)
                    .height(18.px)
            }
            .marginRight(3.px)
            .paddingTop(3.px)
            .float(.left)
            
        }
        .backgroundColor(.grayBlackDark)
        .borderRadius(all: 7.px)
        .padding(all: 3.px)
        .margin(all: 3.px)
        .cursor(.pointer)
        .height(27.px)
        .width(230.px)
        .onClick {
            
            let view = SearchSeviceView(parsableSOCs: self.$parsableSOCs) {
                
            }
            
            addToDom(view)
        }
        
        @DOM override var body: DOM.Content {
            
            Div {
                // Top Tools
                Div{
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Historial de Ventas")
                        .color(.lightBlueText)
                }
                .paddingBottom(7.px)
                
                Div{
                    
                    if custCatchHerk > 1 {
                        
                        Div{
                            /// Tipo de reporte
                            Div{
                                Label("Tipo de reporte")
                                    .fontSize(12.px)
                                    .color(.gray)
                                
                                Div().clear(.both)
                                
                                self.reportTypeSelect
                            }
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Seleccione Tienda
                            Div{
                                Label("Seleccione Tienda")
                                    .fontSize(12.px)
                                    .color(.gray)
                                Div().clear(.both)
                                
                                self.storeSelect
                            }
                            .hidden(self.$reportType.map{ !($0?.storeable ==  true) })
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Seleccione Ususario
                            Div{
                                Label("Seleccione Usuario")
                                    .fontSize(12.px)
                                    .color(.gray)
                                Div().clear(.both)
                                
                                self.userSelect
                            }
                            .hidden(self.$reportType.map{ !($0?.userable ==  true) })
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Product Search
                            Div{
                                Label("Seleccione Productos")
                                    .fontSize(12.px)
                                    .color(.gray)
                                Div().clear(.both)
                                self.parceblePOCDiv
                            }
                            .hidden(self.$reportType.map{ !($0 == .byProduct) })
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Product Search
                            Div{
                                Label("Seleccione Servicio")
                                    .fontSize(12.px)
                                    .color(.gray)
                                Div().clear(.both)
                                self.parcebleSOCDiv
                            }
                            .hidden(self.$reportType.map{ !($0 == .byService) })
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Date Select Type
                            Div{
                                Label("Seleccione Fecha")
                                    .fontSize(12.px)
                                    .color(.gray)
                                Div().clear(.both)
                                self.dateSelect
                            }
                            .hidden(self.$reportType.map{ $0 == nil})
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// Star At
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
                            .hidden(self.$reportType.map{ $0 == nil})
                            .marginLeft(12.px)
                            .marginTop(3.px)
                            .float(.left)
                            
                            /// End At
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
                            .hidden(self.$reportType.map{ $0 == nil})
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
                            
                            Div(self.$reportType.map{ $0?.helpText ??  "" })
                                .paddingBottom(7.px)
                                .marginLeft(12.px)
                                .fontSize(12.px)
                                .marginTop(3.px)
                                .height(15.px)
                                .color(.white)
                                
                        }
                        .borderRadius(7.px)
                        .backgroundColor(.grayBlack)
                        .height(85.px)
                    
                        self.resultDiv
                            .custom("height", "calc(100% - 85px)")
                        
                    }
                    else {
                        self.resultDiv
                            .height(100.percent)
                    }
                    
                }.custom("height", "calc(100% - 70px)")
                
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .marginLeft(7.px)
                            .cursor(.pointer)
                            .height(18.px)
                        
                        Span("Imprimir")
                            .marginLeft(7.px)
                        
                    }
                    .class(.uibtnLarge)
                    .marginTop(0.px)
                    .float(.left)
                    .onClick {
                        self.printDocument()
                    }
                    
                    if custCatchHerk > 1 {
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/money_bag.png")
                                .marginLeft(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            Span("Facturar")
                                .marginLeft(7.px)
                            
                        }
                        .hidden(self.$salesWithOutFiscalDocumets.map{ $0.isEmpty })
                        .class(.uibtnLarge)
                        .marginLeft(7.px)
                        .marginTop(0.px)
                        .float(.left)
                        .onClick {
                            self.facturar()
                        }
                    }
                    
                    
                    H1(self.$totalBalance)
                        .color(.yellowTC)
                    
                }
                .align(.right)
                
            }
            .custom("height", "calc(100% - 70px)")
            .custom("width", "calc(100% - 100px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(40.px)
            .top(25.px)

        }
        
        override func buildUI() {
            
            self.class(.transparantBlackBackGround)
            height(100.percent)
            position(.absolute)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            if custCatchHerk == 1 {
                
                reportTypeListener = SalesReportTypes.byUser.rawValue
                
                userSelectListener = custCatchID.uuidString
                
                dateSelectListener = DateRangeSelection.lastSevenDays.rawValue
                
                requestReport()
                
                return
            }
            
            reportTypeSelect.appendChild(
                Option("Seleccione")
                    .value("")
            )
            
            SalesReportTypes.allCases.forEach { type in
                reportTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            storeSelect.appendChild(
                Option("Seleccione Tienda")
                .value("")
            )
            
            stores.forEach { _, store in
                
                if custCatchHerk < 3 {
                    if custCatchStore != store.id {
                        return
                    }
                }
                
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
                
            }
            
            var storeid: UUID? = custCatchStore
            
            if custCatchHerk > 3 {
                storeid = nil
            }
            
            userSelect.appendChild(
                Option("Seleccione usuario")
                    .value("")
            )
            
            getUsers(storeid: storeid, onlyActive: true) { users in
                users.forEach { user in
                    self.userSelect.appendChild(
                        Option("@" + (user.username.explode("@").first ?? user.firstName ))
                            .value(user.id.uuidString)
                    )
                }
            }
            
            DateRangeSelection.allCases.forEach { item in
                dateSelect.appendChild(
                    Option(item.description)
                        .value(item.rawValue)
                )
            }
            
            $reportTypeListener.listen {
                
                self.reportType = SalesReportTypes(rawValue: $0)
                
                guard let reportType = self.reportType else {
                    return
                }
                
                switch reportType{
                case .byStore:
                    self.storeSelectListener = ""
                case .byUser:
                    self.storeSelectListener = ""
                case .byProduct:
                    
                    self.parsablePOCs = []
                    
                case .byService:
                    self.parsableSOCs = []
                }
                
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
            
        }
        
        func requestReport(){
            
            guard let type = SalesReportTypes(rawValue: reportTypeListener) else {
                showError(.campoRequerido, "Ingrese tipo de reporte")
                return
            }
            
            var id: UUID? = nil
            
            var ids: [UUID] = []
            
            switch type {
            case .byStore:
                guard let tid = UUID(uuidString: storeSelectListener) else {
                    showError(.errorGeneral, "Seleccione id de la tienda")
                    return
                }
                id = tid
            case .byUser:
                guard let tid = UUID(uuidString: userSelectListener) else {
                    showError(.errorGeneral, "Seleccione id del usuario")
                    return
                }
                id = tid
            case .byProduct:
                guard !parsablePOCs.isEmpty else {
                    showError(.errorGeneral, "Seleccione productos a auditar")
                    return
                }
                ids = parsablePOCs.map{ $0.id }
            case .byService:
                guard !parsableSOCs.isEmpty else {
                    showError(.errorGeneral, "Seleccione servicios a auditar")
                    return
                }
                 ids = parsableSOCs.map{ $0.i }
            }
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
            
            if let range = DateRangeSelection(rawValue: dateSelectListener)?.range {
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
                comps.second = 59
                
                guard let _endAtUTS = Calendar.current.date(from: comps)?.timeIntervalSince1970.toInt64 else {
                    showError(.unexpectedResult, "Error al crear estampa de tiempo, contacte a Soporte TC")
                    return
                }
                
                startAtUTS = _startAtUTS + (60 * 60 * 6)
                
                endAtUTS = _endAtUTS + (60 * 60 * 6)
                
            }
            
            guard let startAtUTS else {
                showError( .errorGeneral, "Seleccione una fecha de inicio.")
                return
            }
            
            guard let endAtUTS else {
                showError( .errorGeneral, "Seleccione una fecha de finalización.")
                return
            }
            
            loadingView(show: true)
            
            if type == .byProduct {
                
                API.custPOCV1.audits(
                    type: .byProduct,
                    storeid: nil,
                    userId: nil,
                    depid: nil,
                    accountId: nil,
                    from: startAtUTS,
                    to: endAtUTS,
                    ids: ids
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
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    self.resultDiv.innerHTML = ""
                    
                    self.pocRefrence = Dictionary(uniqueKeysWithValues: payload.pocs.map{ poc in (poc.id, poc) })
                    
                    self.renderByProduct(
                        payload: payload,
                        startAtUTS: startAtUTS ?? 0,
                        endAtUTS: endAtUTS ?? 0
                    )
                }
                
                return
                
            }
            else {
                API.custPDVV1.getSales(
                    type: type,
                    id: id,
                    startAt: startAtUTS,
                    endAt: endAtUTS,
                    requestedIds: ids
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
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }
                    
                    self.startAtResultDate = startAtUTS
                    
                    self.endAtResultDate = endAtUTS
                    
                    self.accountRefrence = Dictionary(uniqueKeysWithValues: payload.accounts.map{ account in ( account.id, account ) })
                    
                    self.salesWithOutFiscalDocumets = []
                    
                    switch type {
                    case .byStore, .byUser:
                        
                        self.renderByDefault(
                            payload: payload,
                            startAtUTS: startAtUTS,
                            endAtUTS: endAtUTS
                        )
                        
                    case .byProduct:
                        break
                    case .byService:
                        
                        self.renderByService(
                            payload: payload,
                            startAtUTS: startAtUTS,
                            endAtUTS: endAtUTS
                        )
                    }
                    
                }
            }
            
            
        }
        
        func facturar(){
            
            if salesWithOutFiscalDocumets.isEmpty {
                return
            }
            
            loadingView(show: true)
            
            API.custPDVV1.requestGlobalFiscalDocument(
                documentsIds: salesWithOutFiscalDocumets.map{ $0.id }
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
                    showError(.errorGeneral, .unexpenctedMissingPayload)
                    return
                }
                
                let view = ToolFiscal(
                    loadType: .salePinGlobalSale(payload: .init(
                        sales: payload.sales,
                        payments: payload.payments,
                        products: payload.products,
                        services: payload.services,
                        fiscCodes: payload.fiscCodes,
                        fiscUnits: payload.fiscUnits,
                        pocs: payload.pocs
                    )),
                    folio: nil
                ) { id, folio, pdf, xml in
                    
                    var sales: [CustSaleQuick] = self.sales
                    
                    self.salesWithOutFiscalDocumets.forEach { sale in
                        
                        var newSale = sale
                        
                        newSale.fiscalDocumentStatus = .global
                        
                        sales.append(newSale)
                    }
                    
                    self.sales.removeAll()
                    
                    self.sales = sales
                    
                    self.salesWithOutFiscalDocumets.removeAll()
                    
                }
                
                addToDom(view)
                
            }
        }
        
        func printDocument(){
            
            if sales.isEmpty {
                return
            }
            
            var logo = ""
            
            if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
                if !_logo.isEmpty {
                    logo = "https://\(custCatchUrl)/contenido/\(_logo)"
                }
            }
            
            print("🟢  logo \(logo)")
            print("🟢  logo \(logo)")
            print("🟢  logo \(logo)")
            print("🟢  logo \(logo)")
            
            print(custWebFilesLogos)
            
            print(custWebFilesLogos)
            
            
            var tableBody = TBody()
            
            let printBody = Div{
                
                Div{
                    Div{
                        if !logo.isEmpty {
                            Img()
                                .src(logo)
                                .width(90.percent)
                                .maxHeight(70.px)
                        }
                    }
                    .width(33.percent)
                    .overflow(.hidden)
                    .float(.left)
                    
                    Div{
                        H3("Reporte de Ventas \(getDate(self.startAtResultDate).formatedLong) - \(getDate(self.endAtResultDate).formatedLong)")
                    }
                    .class(.oneLineText)
                    .textAlign(.center)
                    .width(33.percent)
                    .float(.left)
                    
                    Div{
                        H3(getDate().formatedLong)
                            .textAlign(.right)
                    }
                    .class(.oneLineText)
                    .width(33.percent)
                    .align(.right)
                    .float(.left)
                    
                }
                
                Div()
                    .height(7.px)
                    .clear(.both)
                
                Table{
                    THead{
                        Tr{
                            Td("Folio")
                            Td("Fecha")
                            Td("Cliente")
                                .width(300.px)
                            Td("ODC")
                            Td("ODE")
                            Td("Total")
                            Td("Balance")
                            Td("status")
                        }
                    }
                    tableBody
                }
                .width(100.percent)
                .fontSize(14.px)
                
                Div().height(7.px).clear(.both)
                
                Div{
                    H2("TOTAL \(self.totalBalance)")
                        .float(.right)
                }
                
            }
            
            self.sales.forEach { item in
                
                tableBody.appendChild(Tr{
                    Td(item.folio)
                    Td("\(getDate(item.createdAt).day.toString)/\(getDate(item.createdAt).month.toString)/\(getDate(item.createdAt).year.toString.suffix(2)) \(getDate(item.createdAt).time)")
                    Td{
                        if let accountId = item.custAcct {
                            Div("\(self.accountRefrence[accountId]?.folio ?? "") \(self.accountRefrence[accountId]?.businessName ?? "") \(self.accountRefrence[accountId]?.firstName ?? "") \(self.accountRefrence[accountId]?.firstName ?? "")".purgeSpaces)
                                .class(.twoLineText)
                                .width(300.px)
                        }
                        else {
                            Span("")
                        }
                    }
                    Td({ (item.purchesOrder == nil) ? "Si" : "No"}())
                    Td({ item.pickupOrder.isEmpty ? "No" : "Si" }())
                    Td(item.total.formatMoney)
                    Td(item.balance.formatMoney)
                    Td({ (item.status == .canceled) ? "Cancelado" : "Activo" }())
                })
                
            }
            
            _ = JSObject.global.renderGeneralPrint!(custCatchUrl, "\(getDate(self.startAtResultDate).formatedLong) - \(getDate(self.endAtResultDate).formatedLong)", printBody.innerHTML)
            
        }
        
        func renderByDefault(payload: CustPDVEndpointV1.GetSalesResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            resultDiv.innerHTML = ""
            
            resultDiv.appendChild(Div{
                Table().noResult(label: "📈 Seleccione datos para iniciar")
                    .hidden(self.$sales.map{ !$0.isEmpty })
                
                Div{
                
                    Div("Folio")
                        .textAlign(.center)
                        .width(10.percent)
                        .float(.left)
                    
                    Div("Fecha")
                        .textAlign(.center)
                        .width(15.percent)
                        .float(.left)
                    
                    Div("Cliente")
                        .textAlign(.center)
                        .width(25.percent)
                        .float(.left)
                    
                    Div("ODC")
                        .textAlign(.center)
                        .width(5.percent)
                        .float(.left)
                    
                    Div("ODE")
                        .textAlign(.center)
                        .width(5.percent)
                        .float(.left)
                    
                    Div("Total")
                        .textAlign(.center)
                        .width(15.percent)
                        .float(.left)
                    
                    Div("Balance")
                        .textAlign(.center)
                        .width(10.percent)
                        .float(.left)
                      
                    Div("Factura")
                        .textAlign(.center)
                        .width(5.percent)
                        .float(.left)
                    
                    Div().clear(.both)
                }
                .hidden(self.$sales.map{ $0.isEmpty })
                .marginBottom(7.px)
                .marginTop(12.px)
                .color(.white)
                
                ForEach(self.$sales){ sale in
                    
                    if let accountId = sale.custAcct {
                        HistoryRow(
                            sale: sale,
                            custAcct: self.accountRefrence[accountId]
                        )
                            .fontSize(18.px)
                            .class(.rowItem)
                    }
                    else {
                        HistoryRow(
                            sale: sale,
                            custAcct: nil
                        )
                            .fontSize(18.px)
                            .class(.rowItem)
                    }
                           
                }
                .hidden(self.$sales.map{ $0.isEmpty })
                
            })
            
            sales = payload.sales.reversed()
            
            payload.sales.forEach { sale in
                
                if sale.fiscalDocumentStatus == .unrequest &&
                    sale.status != .removeRequest &&
                    sale.status != .canceled
                {
                    salesWithOutFiscalDocumets.append(sale)
                }
            }
            
            totalBalance = payload.sales.map{ ($0.status != .canceled) ? $0.total : 0 }.reduce(0, +).formatMoney
            
        }
        
        func renderByProduct(payload: CustPOCEndpointV1.AuditsResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            var storeCostTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            resultDiv.innerHTML = ""
            
            /// Add
            /// store name
            resultDiv.appendChild(Div{
                
                H1("Inventario por producto").color(.yellowTC)
                    .float(.left)
                /*
                Img()
                    .src($sectionIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                    .marginRight(24.px)
                    .class(.iconWhite)
                    .paddingTop(7.px)
                    .float(.right)
                    .opacity(0.5)
                    .width(36.px)
                    .onClick {
                        sectionIsHidden = !sectionIsHidden
                    }
                
                Img()
                    .src("/skyline/media/download2.png")
                    .marginRight(24.px)
                    .paddingTop(7.px)
                    .float(.right)
                    .width(36.px)
                    .onClick {
                        self.download(name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                    }
                */
                Div().clear(.both)
                
            })
            
            resultDiv.appendChild(Div{
                
                H2("Kardex").color(.white)
                    .float(.left)
                
                Div().clear(.both)
                
            })
            
            /// [ CustPOC.id : [CustPOCCardex] ]
            var cardexRefrence: [ UUID: [CustPOCCardex] ] = [:]
            
            payload.cardex.forEach { item in
                
                if let _ = cardexRefrence[item.pocId] {
                    cardexRefrence[item.pocId]?.append(item)
                }
                else {
                    cardexRefrence[item.pocId] = [item]
                }
                
            }
            
            cardexRefrence.forEach { pocId, items in
                
                if let poc = self.pocRefrence[pocId] {
                    self.resultDiv.appendChild(H3("\(poc.upc) \(poc.brand) \(poc.model) \(poc.name)").color(.yellowTC))
                }
                
                var tableCardex = TBody()
                
                self.resultDiv.appendChild(
                    Table {
                        THead{
                            Tr{
                                Td("Fecha")
                                Td("Tipo")
                                Td("Folio")
                                Td("Inical")
                                Td("Processados")
                                Td("Final")
                            }
                        }
                        
                        tableCardex
                        
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                )
                
                
                items.forEach { item in
                    
                    print("⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ⭐️  ")
                    
                    print(item)
                    
                    var channel = "Concesion"
                    
                    var operation = "+"
                    
                    switch item.channel {
                    case .pdv:
                        channel = "PDV"
                    case .order:
                        channel = "ODS"
                    case .eSale:
                        channel = "eSale"
                    case .default:
                        if  item.relation == .unconcession {
                            channel = "Desconcesionado"
                            operation = "-"
                        }
                    }
                    
                    tableCardex.appendChild(Tr{
                        Td(getDate(item.createdAt).formatedLong)
                        Td(channel)
                        Td{
                            Div(item.channelFolio)
                                .class(.uibtn)
                                .onClick {
                                    
                                    switch item.channel {
                                    case .pdv:
                                        
                                        addToDom(SalePointView.DetailView(saleId: .id(item.channelId)))
                                        
                                    case .order:
                                        return
                                    case .eSale:
                                        return
                                    case .default:
                                        self.openConcession(controlId: item.channelId)
                                    }
                                    
                                }
                        }
                        Td(item.initialUnits.toString)
                            .align(.center)
                        Td("\(operation) \(item.processedUnits.toString)")
                            .align(.center)
                        Td(item.finalUnits.toString)
                            .align(.center)
                    })
                }
            
            }
            
            resultDiv.appendChild(Div{
                
                H3("Linea de Tiempo").color(.white)
                    .float(.left)
                
            })
            
            payload.items.forEach { item in
                
                guard let poc = self.pocRefrence[item.id] else {
                    return
                }
                
                let units = item.items.count
                
                let totalPrice = item.items.map{ $0.price }.reduce(0, +)
                
                var avaragePrice: Int64 = 0
                
                if totalPrice != 0 && units != 0 {
                    avaragePrice = (totalPrice.toDouble / units.toDouble).toInt64
                }
                
                var timeTable = Table {
                    THead{
                        Tr{
                            Td("POC/SKU/UPC")
                                .width(150)
                            Td("Nombre")
                            Td("Marca")
                                .width(150)
                            Td("Modelo")
                                .width(150)
                            Td("Vendidos")
                                .width(150)
                            Td("P.Uni")
                                .width(150)
                            Td("Total")
                                .width(150)
                        }
                        Tr{
                            Td(poc.upc)
                            Td(poc.name)
                            Td(poc.brand)
                            Td(poc.model)
                            Td(units.toString)
                            Td(avaragePrice.formatMoney)
                            Td(totalPrice.formatMoney)
                        }
                        .color(.yellowTC)
                        
                    }
                }
                .marginBottom(24.px)
                .width(100.percent)
                .color(.white)
                
                print("🟢  4 - 3")
                
                typealias YEAR = Int
                typealias MONTH = Int
                typealias DAY = Int
                
                var itemRefrence: [ YEAR:[ MONTH:[ DAY:[CustPOCEndpointV1.AuditSaleObject] ]]] = [:]
                
                item.items.forEach { item in
                    
                    guard let soldAtStamp = item.soldAt else {
                        return
                    }
                    
                    let soldAt = getDate(soldAtStamp)
                    
                    if let _ = itemRefrence[soldAt.year] {
                    
                        if let _ = itemRefrence[soldAt.year]?[soldAt.month] {
                        
                            if let _ = itemRefrence[soldAt.year]?[soldAt.month]?[soldAt.day] {
                                itemRefrence[soldAt.year]?[soldAt.month]?[soldAt.day]?.append(item)
                            }
                            else {
                                /// DAY NOT SET
                                itemRefrence[soldAt.year]![soldAt.month]![soldAt.day] = [item]
                            }
                            
                        }
                        else {
                            /// MONTH NOT SET
                            itemRefrence[soldAt.year]![soldAt.month] = [ soldAt.day: [item]]
                        }
                        
                    }
                    else {
                        /// YEAR NOT SET
                        itemRefrence[soldAt.year] = [ soldAt.month:[ soldAt.day: [item]] ]
                    }
                    
                }
                print("🟢  4 - 4")
                let yearKeys: [YEAR] = itemRefrence.map{ $0.key }.sorted()
                
                yearKeys.forEach { year in
                    
                    let yearNode = itemRefrence[year]!
                    
                    let monthKeys: [MONTH] = yearNode.map{ $0.key }.sorted()
                    
                    monthKeys.forEach { month in
                        
                        let monthNode = itemRefrence[year]![month]!
                        
                        let dayKeys: [DAY] = monthNode.map{ $0.key }.sorted()
                        
                        dayKeys.forEach { day in
                        
                            let items = itemRefrence[year]![month]![day]!
                            
                            timeTable.appendChild(Tr{
                                Td("\(day.toString)/\(month.toString)/\(year.toString)")
                                Td("")
                                Td("")
                                Td("")
                                Td(items.count.toString)
                                Td("")
                                Td(items.map{ $0.price }.reduce(0, +).formatMoney)
                            })
                            
                        }
                    }
                }
                
                print("🟢  4 - 5")
                
                resultDiv.appendChild(timeTable)
            }
            
            resultDiv.appendChild(Div{
                
                H3("Resumen General").color(.white)
                    .float(.left)
                
            })
            
            var table = Table {
                THead{
                    Tr{
                        Td("POC/SKU/UPC")
                        Td("Nombre")
                        Td("Marca")
                        Td("Modelo")
                        Td("Mas Antig.")
                        Td("Mas Nuevo")
                        Td("DiaZero")
                        Td("Actual")
                        Td("Vendido")
                        Td("Costo")
                        Td("Precio")
                    }
                }
            }
            .marginBottom(24.px)
            .width(100.percent)
            .color(.white)
            
            var conterRow = true
            
            payload.items.forEach { item in
                
                let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                
                let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                
                let poc = self.pocRefrence[item.id]
                
                var oldestItem = "N/D"
                
                var newestItem = "N/D"
                
                if let uts = item.oldestStock {
                    
                    let date = getDate(uts)
                    
                    oldestItem = "\(date.monthName.prefix(3)) \(date.year.toString.suffix(2))"
                }
                
                if let uts = item.newestStock {
                    
                    let date = getDate(uts)
                    
                    newestItem = "\(date.monthName.prefix(3)) \(date.year.toString.suffix(2))"
                }
                
                table.appendChild(Tr{
                    Td(poc?.upc ?? "N/D")
                    Td(poc?.name ?? "N/D")
                    Td(poc?.brand ?? "N/D")
                    Td(poc?.model ?? "N/D")
                    Td(oldestItem)
                    Td(newestItem)
                    Td(item.zeroDay?.toString ?? "---")
                    /// Actual
                    Td(item.currentStock?.toString ?? "N/D")
                    /// Vendido
                    Td(item.items.count.toString)
                    Td(itemCostTotal.formatMoney)
                    Td(itemPriceTotal.formatMoney)
                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                
                storeCostTotal += itemCostTotal
                
                storePriceTotal += itemPriceTotal
                
                conterRow = !conterRow
                
            }
            
            table.appendChild(Tr{
                Td("")
                Td("")
                Td("")
                Td("")
                Td("")
                Td("")
                Td("")
                Td("")
                Td("")
                Td(storeCostTotal.formatMoney)
                    .color(.yellowTC)
                Td(storePriceTotal.formatMoney)
                    .color(.yellowTC)
            }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
            
            resultDiv.appendChild(table)
            
        }
        
        func renderByService(payload: CustPDVEndpointV1.GetSalesResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            var storeCostTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            var productionTimeTotal: Int64 = 0
            
            resultDiv.innerHTML = ""
            
            
            resultDiv.appendChild(Div{
                
                H1("Reporte de Servicios").color(.yellowTC)
                    .float(.left)
                /*
                Img()
                    .src($sectionIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                    .marginRight(24.px)
                    .class(.iconWhite)
                    .paddingTop(7.px)
                    .float(.right)
                    .opacity(0.5)
                    .width(36.px)
                    .onClick {
                        sectionIsHidden = !sectionIsHidden
                    }
                
                Img()
                    .src("/skyline/media/download2.png")
                    .marginRight(24.px)
                    .paddingTop(7.px)
                    .float(.right)
                    .width(36.px)
                    .onClick {
                        self.download(name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                    }
                */
                Div().clear(.both)
                
            })
            
            let tbody = TBody()
            
            self.resultDiv.appendChild(
                Table {
                    THead{
                        Tr{
                            Td("Fecha")
                            Td("Descripción")
                            Td("Type")
                            Td("TDP")
                            Td("Costo")
                            Td("Precio")
                        }
                    }
                    
                    tbody
                    
                }
                .marginBottom(24.px)
                .width(100.percent)
                .color(.white)
            )
            
            payload.charges.forEach { charge in
                
                storeCostTotal += charge.cost
                
                storePriceTotal += charge.price
                
                productionTimeTotal += charge.productionTime
                
                tbody.appendChild(Tr{
                    Td(getDate(charge.createdAt).formatedLong)
                    Td(charge.name)
                    Td("Cargo")
                    Td(charge.productionTime.toString)
                    Td(charge.cost.formatMoney)
                    Td(charge.price.formatMoney)
                })
                
            }
            
            tbody.appendChild(Tr{
                Td("")
                Td("")
                Td("")
                Td(productionTimeTotal.toString)
                Td(storeCostTotal.formatMoney)
                Td(storePriceTotal.formatMoney)
            })
            
        }
        
        func openConcession(controlId: UUID) {
            
            loadingView(show: true)
            
            API.custPOCV1.getTransferInventory(identifier: .id(controlId)) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }

                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.unexpectedResult, "No se pudo obtener documento")
                    return
                }
                
                addToDom(InventoryControlView(
                    control: data.control,
                    items: data.items,
                    pocs: data.pocs,
                    places: data.places,
                    notes: data.notes,
                    fromStore: data.fromStore,
                    toStore: data.toStore,
                    hasRecived: {
                        
                    },
                    hasIngressed: {
                        
                    })
                )
                
            }
        }
    }
}
