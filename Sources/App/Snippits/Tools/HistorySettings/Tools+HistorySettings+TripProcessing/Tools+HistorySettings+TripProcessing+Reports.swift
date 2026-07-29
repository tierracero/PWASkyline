//
//  Tools+HistorySettings+TripProcessing+Reports.swift
//
//
//  Created by Victor Cantu on 10/16/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

import Web

extension ToolsView.HistorySettings.TripProcessing {
    
    class Reports: Div {
        
        override class var name: String { "div" }
        
        @State var reportType: TripReportTypes? = nil
        
        @State var reportTypeListener = ""

        @State var account: CustAcctSearch? = nil
        
        lazy var reportTypeSelect = Select(self.$reportTypeListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(150.px)
            .height(34.px)
        
        @State var operadorSelectListener = ""
        
        lazy var operadorSelect = Select(self.$operadorSelectListener)
            .body{
                Option("Seleccione operador")
                .value("")
            }
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(150.px)
            .height(34.px)
        
        @State var vehicalSelectListener = ""
        
        lazy var vehicalSelect = Select(self.$vehicalSelectListener)
            .body{
                Option("Seleccione Vehiculo")
                    .value("")
            }
            .class(.textFiledBlackDark)
            .width(150.px)
            .fontSize(22.px)
            .height(34.px)
        
        lazy var customerSelect = Div {
            Span(self.$account.map { account in
                guard let account else { return "buscar cliente" }
                let name = "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces
                return name.isEmpty ? account.folio : name
            })
        }
            .class(.textFiledBlackDark)
            .width(230.px)
            .height(34.px)
            .padding(top: 0.px, right: 9.px, bottom: 0.px, left: 9.px)
            .custom("box-sizing", "border-box")
            .custom("line-height", "34px")
            .custom("cursor", "pointer")
            .custom("white-space", "nowrap")
            .custom("overflow", "hidden")
            .custom("text-overflow", "ellipsis")
            .onClick {
                self.selectCustomer()
            }

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
        
        @State var data: API.custCommercialTrips.GetReportTypes? = nil

        var reportOperators: [API.custCommercialTrips.GetReportOperador] = []
        var reportVehicals: [API.custCommercialTrips.GetReportVehical] = []

        lazy var gridDiv = Div()
        
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
                /// Seleccione Cliente
                Div{
                    Label("Cliente")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.customerSelect
                }
                .hidden(self.$reportType.map{ !($0?.customerable == true) })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)

                /// Seleccione Operador
                Div{
                    Label("Operador")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.operadorSelect
                }
                .hidden(self.$reportType.map{ !($0?.operatorable == true) })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)

                /// Seleccione Vehículo
                Div{
                    Label("Vehículo")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.vehicalSelect
                }
                .hidden(self.$reportType.map{ !($0?.vehicable == true) })
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
            .backgroundColor(.init(r: 37, g: 44, b: 59))
            .borderRadius(7.px)
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

            TripReportTypes.allCases.forEach { type in
                reportTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            DateRangeSelection.allCases.forEach { item in
                dateSelect.appendChild(
                    Option(item.description)
                        .value(item.rawValue)
                )
            }
            
            $reportTypeListener.listen {
                self.reportType = TripReportTypes(rawValue: $0)
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
            
            loadingView(show: true)

            API.custCommercialTrips.getReportComponensts { resp in
                    
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

                self.reportOperators = payload.operador
                self.reportVehicals = payload.vehical

                self.operadorSelect.innerHTML = ""
                self.operadorSelect.appendChild(
                    Option("Seleccione operador")
                        .value("")
                )
                payload.operador.forEach { operador in
                    self.operadorSelect.appendChild(
                        Option(operador.name)
                            .value(operador.id.uuidString)
                    )
                }

                self.vehicalSelect.innerHTML = ""
                self.vehicalSelect.appendChild(
                    Option("Seleccione vehículo")
                        .value("")
                )
                payload.vehical.forEach { vehical in
                    self.vehicalSelect.appendChild(
                        Option("\(vehical.name) · \(vehical.licensePlate)")
                            .value(vehical.id.uuidString)
                    )
                }

            }

        }
        
        func requestReport(){
            
            guard let reportType = TripReportTypes(rawValue: reportTypeListener) else {
                showError(.requiredField, "Ingrese tipo de reporte")
                return
            }
            
            //var storeId: UUID? = UUID(uuidString: storeSelectListener)
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
            
            if let range = DateRangeSelection(rawValue: dateSelectListener)?.range {
                startAtUTS = range.startAt
                endAtUTS = range.endAt
            }
            else {
                
                if startAt.isEmpty {
                    showError(.requiredField, "Ingrese fecha de Inicio")
                    return
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
            
            guard let startAtUTS else {
                showError(.generalError, "Ingrese fecha de inicion valida")
                return
            }
            
            guard let endAtUTS else {
                showError(.generalError, "Ingrese fecha de finalizacion valida")
                return
            }

            var relationId: UUID? = nil

            switch reportType {
            case .general:
                break
            case .byCustomer:
                guard let account else {
                    showError(.requiredField, "Seleccione un cliente")
                    return
                }
                relationId = account.id
            case .byOperador:
                guard let id = UUID(uuidString: operadorSelectListener) else {
                    showError(.requiredField, "Seleccione un operador")
                    return
                }
                relationId = id
            case .byVehical:
                guard let id = UUID(uuidString: vehicalSelectListener) else {
                    showError(.requiredField, "Seleccione un vehículo")
                    return
                }
                relationId = id
            }

            loadingView(show: true)

            API.custCommercialTrips.getReport(
                from: startAtUTS,
                to: endAtUTS,
                type: reportType,
                relationId: relationId
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

                guard let report = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }

                self.data = report
                self.renderReport(report)
            }
        }

        private func selectCustomer() {
            let view = SearchCustomerQuickView { account in
                self.account = account
            } create: { term in
                addToDom(CreateNewCusomerView(
                    searchTerm: term,
                    custType: .general,
                    callback: { acctType, custType, searchTerm in
                        addToDom(CreateNewCustomerDataView(
                            acctType: acctType,
                            custType: custType,
                            orderType: nil,
                            searchTerm: searchTerm
                        ) { account in
                            self.account = account
                        })
                    }
                ))
            }

            addToDom(view)
        }

        private func renderReport(_ report: API.custCommercialTrips.GetReportTypes) {
            switch report {
            case .general(let value):
                renderReport(
                    title: "Reporte General de Viajes",
                    relation: "Todos los clientes, operadores y vehículos",
                    from: value.from,
                    to: value.to,
                    summary: value.summary,
                    items: value.items
                )
            case .byCustomer(let value):
                renderReport(
                    title: "Reporte de Viajes por Cliente",
                    relation: "\(value.customer.name) · \(value.customer.folio)",
                    from: value.from,
                    to: value.to,
                    summary: value.summary,
                    items: value.items
                )
            case .byOperador(let value):
                renderReport(
                    title: "Reporte de Actividad por Operador",
                    relation: value.operador.name,
                    from: value.from,
                    to: value.to,
                    summary: value.summary,
                    items: value.items
                )
            case .byVehical(let value):
                renderReport(
                    title: "Reporte de Actividad por Vehículo",
                    relation: "\(value.vehical.name) · \(value.vehical.licensePlate)",
                    from: value.from,
                    to: value.to,
                    summary: value.summary,
                    items: value.items
                )
            }
        }

        private func renderReport(
            title: String,
            relation: String,
            from: Int64,
            to: Int64,
            summary: API.custCommercialTrips.GetReportSummary,
            items: [API.custCommercialTrips.GetReportTripItem]
        ) {
            gridDiv.innerHTML = ""

            let reportView = Div()
                .custom("display", "flex")
                .custom("flex-direction", "column")
                .custom("gap", "12px")
                .custom("padding", "12px")
                .custom("box-sizing", "border-box")
                .custom("color", "#edf7ff")

            reportView.appendChild(
                Div {
                    H3(title)
                        .margin(all: 0.px)
                        // TODO: Replace this inline accent with the shared crystal palette token.
                        .color(.init(r: 49, g: 185, b: 245))
                    Span("\(getDate(from).formatedShort) — \(getDate(to).formatedShort) · \(relation)")
                        .fontSize(13.px)
                        .color(.gray)
                }
                    .custom("display", "flex")
                    .custom("flex-direction", "column")
                    .custom("gap", "4px")
                    .custom("padding", "10px 12px")
                    .custom("background", "rgba(4, 25, 43, 0.88)")
                    .custom("border", "1px solid rgba(102, 184, 236, 0.24)")
                    .custom("border-radius", "10px")
            )

            let kpis = Div()
                .custom("display", "grid")
                .custom("grid-template-columns", "repeat(4, minmax(0, 1fr))")
                .custom("gap", "8px")

            [
                ("Viajes", "\(summary.tripCount)"),
                ("Completados", "\(summary.completedCount)"),
                ("En proceso", "\(summary.inProgressCount)"),
                ("Cancelados", "\(summary.cancelledCount)"),
                ("Ingresos", summary.totalRevenue.formatMoney),
                ("Inversion / Gasto", summary.totalDirectCost.formatMoney),
                ("Margen bruto", summary.grossProfit.formatMoney),
                ("Utilidad %", summary.grossMarginPercent.map { String(format: "%.2f%%", $0) } ?? "—"),
                ("Pagos", summary.paymentTotal.formatMoney),
                ("Saldo guardado", summary.outstandingBalance.formatMoney),
                ("Saldo calculado", summary.calculatedBalance.formatMoney),
                ("Variación", summary.balanceVariance.formatMoney),
                ("Kilogramos", "\(summary.cargoKilograms)"),
                ("Distancia odómetro", "\(summary.odometerDistanceKilometers) km"),
                ("Con odómetro", "\(summary.tripsWithOdometerDistance)"),
                ("Sin odómetro", "\(summary.tripCount - summary.tripsWithOdometerDistance)")
            ].forEach { label, value in
                kpis.appendChild(
                    Div {
                        Span(label)
                            .fontSize(12.px)
                            .color(.gray)
                        Strong(value)
                            .fontSize(16.px)
                            .color(.white)
                    }
                        .custom("display", "flex")
                        .custom("flex-direction", "column")
                        .custom("gap", "4px")
                        .custom("padding", "9px")
                        .custom("background", "rgba(10, 39, 63, 0.74)")
                        .custom("border", "1px solid #252c3b")
                        .custom("border-radius", "9px")
                )
            }

            reportView.appendChild(kpis)

            let table = Table()
                .custom("width", "100%")
                .custom("border-collapse", "separate")
                .custom("border-spacing", "0 5px")

            table.appendChild(THead {
                Tr {
                    ["Creado", "Folio", "Estado", "Cliente", "Operador", "Vehículo", "Origen", "Destino", "Kg", "Odómetro", "Ingresos", "Inversion / Gasto", "Utilidad", "Saldo"]
                        .map { title in
                            Td(title)
                                .fontSize(12.px)
                                .color(.gray)
                                .padding(all: 7.px)
                        }
                }
            })

            let tableBody = TBody()
            items.forEach { item in
                let vehicle = [item.vehicalName, item.vehicalLicensePlate]
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .joined(separator: " · ")

                tableBody.appendChild(
                    Tr {
                        Td(getDate(item.createdAt).formatedShort)
                        Td(item.folio)
                        Td(item.status.description)
                        Td(item.accountName)
                        Td(item.operadorName ?? "—")
                        Td(vehicle.isEmpty ? "—" : vehicle)
                        Td(item.origin ?? "—")
                        Td(item.destination ?? "—")
                        Td("\(item.cargoKilograms)")
                        Td(item.odometerDistanceKilometers.map { "\($0)" } ?? "—")
                        Td(item.totalRevenue.formatMoney)
                        Td(item.totalDirectCost.formatMoney)
                        Td(item.grossProfit.formatMoney)
                        Td(item.balance.formatMoney)
                    }
                        .custom("background", "rgba(10, 39, 63, 0.58)")
                        .custom("border-left", "3px solid #252c3b")
                )
            }

            table.appendChild(tableBody)
            reportView.appendChild(table)
            gridDiv.appendChild(reportView)
        }
        
        override func didRemoveFromDOM() {
            $reportType.removeAllListeners()
            $reportTypeListener.removeAllListeners()
            $account.removeAllListeners()
            $operadorSelectListener.removeAllListeners()
            $vehicalSelectListener.removeAllListeners()
            $dateSelectListener.removeAllListeners()
            $startAt.removeAllListeners()
            $endAt.removeAllListeners()
            $startAtLabel.removeAllListeners()
            $endAtLabel.removeAllListeners()
            $data.removeAllListeners()
            super.didRemoveFromDOM()
        }
    }
}
