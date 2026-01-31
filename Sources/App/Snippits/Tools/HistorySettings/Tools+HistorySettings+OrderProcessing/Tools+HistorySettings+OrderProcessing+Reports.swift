//
//  Tools+HistorySettings+OrderProcessing+Reports.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals

import Web

extension ToolsView.HistorySettings.OrderProcessing {
    
    class Reports: Div {
        
        override class var name: String { "div" }
        
        @State var data: API.custOrderV1.ReportResponseType? = nil
        
        @State var reportType: OrderReportTypes? = nil
        
        @State var reportTypeListener = ""
        
        lazy var reportTypeSelect = Select(self.$reportTypeListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(150.px)
            .height(34.px)
        
        @State var storeSelectListener = ""
        
        lazy var storeSelect = Select(self.$storeSelectListener)
            .body{
                Option(self.$reportType.map{ $0 == .byStore ? "Seleccione Tiendas": "Todas las Tiendas" })
                .value("")
            }
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(150.px)
            .height(34.px)
        
        @State var userSelectListener = ""
        
        lazy var userSelect = Select(self.$userSelectListener)
            .body{
                Option("Seleccione Usuario")
                    .value("")
            }
            .class(.textFiledBlackDark)
            .width(150.px)
            .fontSize(22.px)
            .height(34.px)
        
        
        @State var dateSelectListener = ""
        
        lazy var dateSelect = Select(self.$dateSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(150.px)
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
        
        lazy var gridDiv = Div()
        
        var filterStatusListenerRefrence: [String:State<String>] = [:]
        
        var filterByPendingPickUpRefrence: [String:State<Bool?>] = [:]
        
        var filterStatusRefrence: [String:State<CustFolioStatus?>] = [:]
        
        var filterByPendingPickUpListenerRefrence: [String:State<String>] = [:]
        
        @DOM override var body: DOM.Content {
            
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
                .hidden(self.$reportType.map{ !($0?.storeable == true) })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                /// Seleccione Usuario
                Div{
                    Label("Seleccione Usuario")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.userSelect
                }
                .hidden(self.$reportType.map{ !($0?.userable == true) })
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
                .hidden(self.$reportType.map{ $0 == nil })
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
                .hidden(self.$reportType.map{ $0 == nil })
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
                .hidden(self.$reportType.map{ $0 == nil })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div(" Crear Reporte ")
                    .hidden(self.$reportType.map{ $0 == nil })
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
                    .fontSize(16.px)
                    .marginBottom(7.px)
                    .marginTop(7.px)
                    .height(15.px)
                    .color(.white)
                
                Div().clear(.both)
            }
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .height(90.px)
            
            Div{
                
                Table().noResult(label: "📈 Seleccione una tienda para iniciar")
                    .hidden(self.$data.map{ $0 != nil })
                
                self.gridDiv
                .hidden(self.$data.map{ $0 == nil })
                .height(700.px)
                
            }
            .custom("height", "calc(100% - 90px)")
            .overflow(.auto)
            
        }
        
        override func buildUI() {
            
            height(100.percent)
            
            reportTypeSelect.appendChild(
                Option("Seleccione")
                    .value("")
            )
            
            OrderReportTypes.allCases.forEach { type in
                reportTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            stores.forEach { _, store in
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }
            
            getUsers(storeid: nil, onlyActive: true) { users in
                users.forEach { user in
                    self.userSelect.appendChild(
                        Option(user.username)
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
                self.reportType = OrderReportTypes(rawValue: $0)
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
            
            dateSelectListener = DateRangeSelection.thisWeek.rawValue
            
            
        }
        
        func requestReport(){
            
            guard let reportType = OrderReportTypes(rawValue: reportTypeListener) else {
                showError(.requiredField, "Ingrese tipo de reporte")
                return
            }
            
            var storeid: UUID? = UUID(uuidString: storeSelectListener)
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
            
            if let range = DateRangeSelection(rawValue: dateSelectListener)?.range {
                startAtUTS = range.startAt
                endAtUTS = range.endAt
            }
            else {
                
                if startAt.isEmpty {
                    showError(.requiredField, "Ingrese fecha de Inicio")
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
                
                //startAtUTS = _startAtUTS
                
                //endAtUTS = _endAtUTS
                
                
                
                startAtUTS = _startAtUTS + (60 * 60 * 6)
                
                endAtUTS = _endAtUTS + (60 * 60 * 6)
                
            }
            
            guard let startAtUTS else {
                showError(.generalError, "Ingrese fecha de inicion valida")
                return
            }
            
            guard let endAtUTS else {
                showError(.generalError, "Ingrese fecha de finalizacion valida")
                return
            }
            
            self.data = nil
            
            self.gridDiv.innerHTML = ""
            
            loadingView(show: true)
            
            API.custOrderV1.reports(
                type: reportType,
                storeId: storeid,
                userId: UUID(uuidString: self.userSelectListener),
                from: startAtUTS,
                to: endAtUTS
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
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                self.data = payload
                
                self.parceReport()
                
            }
            
        }
        
        func parceReport(){
            
            guard let data else {
                return
            }
            
            switch data {
            case .general(let general):
                parseReportGeneral(
                    created: general.created,
                    closed: general.closed,
                    payments: general.payments
                )
            case .byOrder(_):
                break
            case .byStore(let byStore):
                parseReportGeneral(
                    created: byStore.created,
                    closed: byStore.closed,
                    payments: byStore.payments
                )
            case .byUser(let byUser):
                parseReportGeneral(
                    created: byUser.created,
                    closed: byUser.closed,
                    payments: byUser.payments
                )
            case .byType(_):
                break
            }
            
        }
        
        func parseReportGeneral(created: [API.custOrderV1.ReportsObjects], closed: [API.custOrderV1.ReportsObjects], payments: [CustAcctPaymentsQuick]){
            
            self.gridDiv.innerHTML = ""
            
            loadingView(show: true)
            
            getUsers(storeid: nil, onlyActive: false) { users in
                
                var userref: [UUID:CustUsername] = [:]
                
                users.forEach { user in
                    userref[user.id] = user
                }
                
                @State var isHiddenA: Bool = false
                
                if created.count > 0 {
                    
                    self.gridDiv.appendChild(Div{
                        
                        Img()
                            .src($isHiddenA.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                            .marginRight(24.px)
                            .class(.iconWhite)
                            .paddingTop(7.px)
                            .float(.right)
                            .opacity(0.5)
                            .width(36.px)
                            .onClick {
                                isHiddenA = !isHiddenA
                            }
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                //self.download(name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                                self.downloadReport(type: .created)
                            }
                        
                        
                        H1("Orden Creada")
                            .color(.yellowTC)
                            .marginBottom(7.px)
                            .marginTop(12.px)
                            .float(.left)
                    })
                    
                    self.parseReportGeneralData(userref: userref, type: "created", isHidden: $isHiddenA, data: created)
                    
                }
                
                if closed.count > 0 {
                    
                    @State var isHiddenB = false
                    
                    self.gridDiv.appendChild(
                        Div{
                            
                            Img()
                                .src($isHiddenB.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png" })
                                .marginRight(24.px)
                                .class(.iconWhite)
                                .paddingTop(7.px)
                                .float(.right)
                                .opacity(0.5)
                                .width(36.px)
                                .onClick {
                                    isHiddenB = !isHiddenB
                                }
                            
                            Img()
                                .src("/skyline/media/download2.png")
                                .marginRight(24.px)
                                .paddingTop(7.px)
                                .float(.right)
                                .width(36.px)
                                .onClick {
                                    self.downloadReport(type: .closed)
                                    //self.download(name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                                    
                                }
                            
                            H1("Orden Cerrada")
                                .color(.yellowTC)
                                .marginBottom(7.px)
                                .marginTop(12.px)
                        }
                        
                    )
                    
                    self.parseReportGeneralData(userref: userref, type: "closed", isHidden: $isHiddenB, data: closed)
                    
                }
                
                if payments.count > 0 {
                    
                    @State var isHiddenC = false
                    
                    self.gridDiv.appendChild(
                        Div{
                            
                            Img()
                                .src($isHiddenC.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                .marginRight(24.px)
                                .class(.iconWhite)
                                .paddingTop(7.px)
                                .float(.right)
                                .opacity(0.5)
                                .width(36.px)
                                .onClick {
                                    isHiddenC = !isHiddenC
                                }
                            
                            Img()
                                .src("/skyline/media/download2.png")
                                .marginRight(24.px)
                                .paddingTop(7.px)
                                .float(.right)
                                .width(36.px)
                                .onClick {
                                    //self.download(name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                                    self.downloadReport(type: .payments)
                                }
                            
                            
                            H1("Pagos Recidos")
                                .color(.yellowTC)
                                .marginBottom(7.px)
                                .marginTop(12.px)
                        }
                    )
                    
                    self.parseReportPaymentData(userref: userref, isHidden: $isHiddenC, data: payments)
                }
                
                loadingView(show: false)
                
            }
        }
        
        func parseReportGeneralData( userref: [UUID:CustUsername], type: String, isHidden: State<Bool>, data: [API.custOrderV1.ReportsObjects]){
            
            var status: [CustFolioStatus] = []
            
            @State var filterStatusListener: String = ""
            
            if let val = filterStatusListenerRefrence[type] {
                filterStatusListener = val.wrappedValue
            }
            else {
                filterStatusListenerRefrence[type] = $filterStatusListener
            }
            
            @State var filterByPendingPickUp: Bool? = nil
            
            @State var filterStatus: CustFolioStatus? = nil
            
            @State var filterByPendingPickUpListener: String = ""
            
            $filterByPendingPickUpListener.listen {
                switch $0 {
                case "SI":
                    filterByPendingPickUp = true
                case "NO":
                    filterByPendingPickUp = false
                default:
                    filterByPendingPickUp = nil
                }
                self.parceReport()
            }
            
            $filterStatusListener.listen {
                filterStatus = CustFolioStatus(rawValue: $0)
                self.parceReport()
            }
            
            var filterByPendingPickUpSelect = Select($filterByPendingPickUpListener)
                .body{
                    Option("**")
                        .value("")
                    Option("Si")
                        .value("SI")
                    Option("No")
                        .value("NO")
                }
            
            var filterStatusSelect = Select($filterStatusListener)
                .body{
                    Option("**")
                        .value("")
                }
            
            var tableView = TBody()
                .hidden(isHidden)
            
            let table = Table{
                
                THead{
                    Tr{
                        Td("Creado")
                            .textAlign(.center)
                            .width(120.px)
                        Td("Finalizado")
                            .textAlign(.center)
                            .width(120.px)
                        Td("Folio")
                            .textAlign(.center)
                            .width(100.px)
                        Td("Creado Por")
                            .textAlign(.center)
                            .width(100.px)
                        Td("Procesado Por")
                            .textAlign(.center)
                            .width(100.px)
                        Td{
                            Span("Pend Entrega")
                            Div()
                            //filterByPendingPickUpSelect
                        }
                            .textAlign(.center)
                            .width(100.px)
                        Td("Descripción")
                        Td("QA")
                        Td{
                            Span("Status")
                            Div()
                            //filterStatusSelect
                        }
                        
                        Td("Costos")
                            .textAlign(.center)
                            .width(10.px)
                        Td("Cargos")
                            .textAlign(.center)
                            .width(10.px)
                        Td("Ganacia")
                            .textAlign(.center)
                            .width(10.px)
                    }
                    .backgroundColor(.black)
                    .color(.yellowTC)
                    .position(.sticky)
                    .top(0.px)
                }
                
                tableView
            }
            .width(100.percent)
            
            // MARK: Process
            
            data.forEach { object in
                if status.contains(object.status) {
                    return
                }
                status.append(object.status)
            }
            
            status.forEach { status in
                filterStatusSelect.appendChild(
                    Option(status.description)
                        .value(status.rawValue)
                )
            }
            
            var grandCost: Int64 = 0
            
            var grandTotal: Int64 = 0
            
            data.forEach { item in
                
                if let filterStatus {
                    if item.status != filterStatus {
                        return
                    }
                }
                
                if let filterByPendingPickUp {
                    if filterByPendingPickUp != item.pendingPickup {
                        return
                    }
                }
                
                var createdBy = "N/A"
                
                if let uid = item.createdBy {
                    createdBy = userref[uid]?.username ?? "N/F"
                    if createdBy.contains("@"){
                        createdBy = "@\((createdBy.explode("@").first ?? ""))"
                    }
                }
                
                var workedBy = "N/A"
                
                if let uid = item.workedBy {
                    workedBy = userref[uid]?.username ?? "N/F"
                    if createdBy.contains("@"){
                        workedBy = "@\((workedBy.explode("@").first ?? ""))"
                    }
                }
                
                var pendingPickup = "NO"
                
                if item.pendingPickup {
                    pendingPickup = "Si"
                }
                
                var cost: Int64 = 0
                
                var total: Int64 = 0
                
                item.charges.forEach { charge in
                    cost += charge.cost
                    total += charge.price
                }
                
                let revenue = total - cost
                
                grandCost += cost
                
                grandTotal += total
                
                tableView.appendChild(Tr{
                    Td(getDate(item.createdAt).formatedLong)
                    Td(getDate(item.modifiedAt).formatedLong)
                    Td(item.folio)
                    Td(createdBy)
                    Td(workedBy)
                    Td(pendingPickup)
                    Td(item.description)
                    Td("N/A")
                    Td(item.status.description)
                    Td(cost.formatMoney)
                        .textAlign(.right)
                    Td(total.formatMoney)
                        .textAlign(.right)
                    Td(revenue.formatMoney)
                        .textAlign(.right)
                }.color(.white))
            }
            
            table.appendChild(
                TFoot{
                    Tr{
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td("")
                        Td(grandCost.formatMoney)
                            .textAlign(.right)
                        Td(grandTotal.formatMoney)
                            .textAlign(.right)
                        Td((grandTotal - grandCost).formatMoney)
                            .textAlign(.right)
                    }.color(.white)
                }
            )
            
            self.gridDiv.appendChild(table)
            
        }
        
        func parseReportPaymentData( userref: [UUID:CustUsername], isHidden: State<Bool>, data: [CustAcctPaymentsQuick]){
            
            var tableView = TBody()
                .hidden(isHidden)
            
            let table = Table{
                
                THead{
                    Tr{
                        Td("Creado")
                            .textAlign(.center)
                            .width(120.px)
                        Td("Tipo")
                            .textAlign(.center)
                            .width(100.px)
                        Td("Folio")
                            .textAlign(.center)
                            .width(100.px)
                        Td("Orden")
                            .textAlign(.center)
                            .width(100.px)
                        Td("Creado Por")
                            .textAlign(.center)
                            .width(100.px)
                        
                        Td("Descripción")
                        
                        Td("Cantidad")
                            .textAlign(.center)
                            .width(100.px)
                    }
                    .backgroundColor(.black)
                    .color(.yellowTC)
                    .position(.sticky)
                    .top(0.px)
                }
                
                tableView
            }
            .width(100.percent)
            .color(.white)
            
            var total: Int64 = 0
            
            data.forEach { item in
                
                switch item.type {
                    
                case .payment:
                    total += item.cost
                case .adjustment:
                    total -= item.cost
                }
                
                var uname = ""
                
                if let createdBy = item.createdBy {
                    if let user = userref[createdBy] {
                        uname = user.username.explode("@").last ?? user.username
                    }
                }
                
                let tr = Tr{
                    Td(getDate(item.createdAt).formatedLong)
                        .textAlign(.center)
                        .width(120.px)
                    Td(item.type.description)
                        .textAlign(.center)
                        .width(100.px)
                    Td(item.folio)
                        .textAlign(.center)
                        .width(100.px)
                    Td("--")
                        .textAlign(.center)
                        .width(100.px)
                    Td(uname)
                        .textAlign(.center)
                        .width(100.px)
                    
                    Td(item.description)
                    
                    Td(item.cost.formatMoney)
                        .textAlign(.center)
                        .width(100.px)
                }
                
                tableView.appendChild(tr)
                
            }
            
            let tr = Tr{
                Td("")
                    .textAlign(.center)
                    .width(120.px)
                Td("")
                    .textAlign(.center)
                    .width(100.px)
                Td("")
                    .textAlign(.center)
                    .width(100.px)
                Td("")
                    .textAlign(.center)
                    .width(100.px)
                Td("")
                    .textAlign(.center)
                    .width(100.px)
                
                Td("TOTAL: ")
                    .align(.right)
                
                Td(total.formatMoney)
                    .textAlign(.center)
                    .width(100.px)
            }
            
            table.appendChild(TFoot{tr})
            
            self.gridDiv.appendChild(table)
            
        }
        
        func downloadReport(type: ReportType) {
            
            guard let data else {
                return
            }
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
            
            if let range = DateRangeSelection(rawValue: dateSelectListener)?.range {
                startAtUTS = range.startAt
                endAtUTS = range.endAt
            }
            else {
                
                if startAt.isEmpty {
                    showError(.requiredField, "Ingrese fecha de Inicio")
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
                
                //startAtUTS = _startAtUTS
                
                //endAtUTS = _endAtUTS
                
                
                
                startAtUTS = _startAtUTS + (60 * 60 * 6)
                
                endAtUTS = _endAtUTS + (60 * 60 * 6)
                
            }
            
            guard let startAtUTS else {
                showError(.generalError, "Ingrese fecha de inicion valida")
                return
            }
            
            guard let endAtUTS else {
                showError(.generalError, "Ingrese fecha de finalizacion valida")
                return
            }
            
            
            getUsers(storeid: nil, onlyActive: false) { users in
                
                var userref: [UUID:CustUsername] = [:]
                
                users.forEach { user in
                    userref[user.id] = user
                }
             
                switch data {
                case .general(let payload):
                    
                    var storeName = ""
                    
                    if let storeId = UUID(uuidString: self.storeSelectListener) {
                        
                        stores.forEach { store in
                            if store.key == storeId {
                                storeName = "\(store.value.name) "
                            }
                        }
                    }
                    
                    switch type{
                    case .created:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte general de ordenes creadas \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.created
                        )
                    case .closed:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte genral de ordenes cerradas \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.closed
                        )
                    case .payments:
                        self.printReportPaymentData(
                            userref: userref,
                            fileName: "reporte genral de finanzas \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.payments
                        )
                    }
                case .byOrder(_):
                    break
                case .byStore(let payload):
                    
                    var storeName = ""
                    
                    if let storeId = UUID(uuidString: self.storeSelectListener) {
                        
                        stores.forEach { store in
                            if store.key == storeId {
                                storeName = "\(store.value.name) "
                            }
                        }
                        
                    }
                    
                    switch type{
                    case .created:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte ordens creadas por tienda \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.created
                        )
                    case .closed:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte ordenes cerradas por tienda \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.closed
                        )
                    case .payments:
                        self.printReportPaymentData(
                            userref: userref,
                            fileName: "reporte pagos por tienda \(storeName)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.payments
                        )
                    }
                case .byUser(let payload):
                    
                    var uname = ""
                    
                    if let userId = UUID(uuidString: self.userSelectListener) {
                        userref.forEach { id, udata in
                            if id == userId {
                                uname = "\(udata.username.explode("@").first ?? udata.username) "
                            }
                        }
                    }
                    
                    switch type{
                    case .created:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte ordens creadas por usuario \(uname)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.created
                        )
                    case .closed:
                        self.printReportGeneralData(
                            userref: userref,
                            fileName: "reporte ordenes cerradas por usuario \(uname)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.closed
                        )
                    case .payments:
                        self.printReportPaymentData(
                            userref: userref,
                            fileName: "reporte pagos por usuario \(uname)\(getDate(startAtUTS).formatedLong)-\(getDate(endAtUTS).formatedLong)".uppercased().replace(from: " ", to: "_") + ".csv",
                            data: payload.payments
                        )
                    }
                case .byType(_):
                    break
                }
            }
        }
        
        func printReportGeneralData( userref: [UUID:CustUsername], fileName: String, data: [API.custOrderV1.ReportsObjects]){
            
            var csvString = "Creado,Finalizado,Folio,Creado Por,Procesado Por,Pend Entrega,Descripción,QA,Status,Costos,Cargos,Ganacia"
            
            var grandCost: Int64 = 0
            
            var grandTotal: Int64 = 0
            
            data.forEach { item in
                
                var createdBy = "N/A"
                
                if let uid = item.createdBy {
                    createdBy = userref[uid]?.username ?? "N/F"
                    if createdBy.contains("@"){
                        createdBy = "@\((createdBy.explode("@").first ?? ""))"
                    }
                }
                
                var workedBy = "N/A"
                
                if let uid = item.workedBy {
                    workedBy = userref[uid]?.username ?? "N/F"
                    if createdBy.contains("@"){
                        workedBy = "@\((workedBy.explode("@").first ?? ""))"
                    }
                }
                
                var pendingPickup = "NO"
                
                if item.pendingPickup {
                    pendingPickup = "Si"
                }
                
                var cost: Int64 = 0
                
                var total: Int64 = 0
                
                item.charges.forEach { charge in
                    cost += charge.cost
                    total += charge.price
                }
                
                let revenue = total - cost
                
                grandCost += cost
                
                grandTotal += total
                
                csvString += "\n\(getDate(item.createdAt).formatedLong),\(getDate(item.modifiedAt).formatedLong),\(item.folio),\(createdBy),\(workedBy),\(pendingPickup),\(item.description.replace(from: ",", to: " ")),N/A,\(item.status.description),\(cost.formatMoney.replace(from: ",", to: "")),\(total.formatMoney.replace(from: ",", to: "")),\(revenue.formatMoney.replace(from: ",", to: "")))"
                
            }
            
            csvString += "\n,,,,,,,N/A,,\(grandCost.formatMoney.replace(from: ",", to: "")),\(grandTotal.formatMoney.replace(from: ",", to: "")),\((grandTotal - grandCost).formatMoney.replace(from: ",", to: "")))"
         
            
            _ = JSObject.global.download!( fileName, csvString)
            
            loadingView(show: false)
            
        }
        
        func printReportPaymentData( userref: [UUID:CustUsername], fileName: String, data: [CustAcctPaymentsQuick]){
            
            var csvString = "Creado,Tipo,Folio,Orden,Creado Por,Descripción,Cantidad"
            
            var total: Int64 = 0
            
            data.forEach { item in
                
                switch item.type {
                    
                case .payment:
                    total += item.cost
                case .adjustment:
                    total -= item.cost
                }
                
                var uname = ""
                
                if let createdBy = item.createdBy {
                    if let user = userref[createdBy] {
                        uname = user.username.explode("@").first ?? user.username
                    }
                }
                
                csvString += "\n\(getDate(item.createdAt).formatedLong),\(item.type.description.replace(from: ",", to: "")),\(item.folio),--,\(uname),\(item.description.replace(from: ",", to: " ")),\(item.cost.formatMoney.replace(from: ",", to: ""))"
                
            }
            
            csvString += "\n,,,,,TOTAL,\(total.formatMoney.replace(from: ",", to: ""))"
            
            _ = JSObject.global.download!( fileName, csvString)
            
        }
        
        
    }
}
extension ToolsView.HistorySettings.OrderProcessing.Reports {
    enum ReportType {
        case created
        case closed
        case payments
    }
}
