//
//  ProductManager+Audit+Merms.swift
//  
//
//  Created by Victor Cantu on 7/7/23.
//

import Foundation
import TCFundamentals 
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class Merms: Div {
        
        override class var name: String { "div" }

        private var mermRenderId = UUID()
        
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
        
        @State var endAtLabel = ""
        
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

        private let resultElementId = "mermResultDiv_\(callKey(7))"
        
        lazy var resultDiv = Div{
            Table().noResult(label: "📈 Seleccione una tienda para iniciar")
        }
        .id(.init(resultElementId))
        .class(Class(TCCrystalSurfaceClass.auditResults))
        .custom("height", "calc(100% - 85px)")
        .overflow(.auto)

        
        lazy var reportActions = ReportActions(resultElementId: resultElementId) 

        @DOM override var body: DOM.Content {
            /// Filter View
            Div{
                
                // MARK: Selected store
                Div{
                    Label("Tenda Origen")
                        .fontSize(12.px)
                        .color(.gray)
                    
                    Div().clear(.both)
                    
                    self.storeSelect
                }
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
                        self.createReport()
                    }

                Div().clear(.both)
                
            }
            .class(Class(TCCrystalSurfaceClass.auditToolbar))
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .height(85.px)
            
            self.resultDiv
            
        }
        
        override func buildUI() {
            height(100.percent)
            
            stores.forEach { _, store in
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }
            
            storeSelectListener = custCatchStore.uuidString
            
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
            
        }
        
        func createReport() {
            
            guard let store: UUID = UUID(uuidString: storeSelectListener) else {
                showError(.generalError, "Seleccione una tienda origen.")
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
                
                startAtUTS = _startAtUTS + (60 * 60 * 6)
                
                endAtUTS = _endAtUTS + (60 * 60 * 6)
                
            }
            
            guard let startAtUTS else {
                showError(.generalError, "Seleccione una fecha valida.")
                return
            }
            guard let endAtUTS else {
                showError(.generalError, "Seleccione una fecha valida.")
                return
            }
            
            let renderId = UUID()
            mermRenderId = renderId
            reportActions.reset()

            loadingView.show()
            
            API.custPOCV1.getMerms(
                store: store,
                startAt: startAtUTS,
                 endAt: endAtUTS
            ) { resp in

                guard renderId == self.mermRenderId else {
                    return
                }

                loadingView.hide()
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
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

                self.resultDiv.innerHTML = ""

                self.reportActions.present(
                    title: "Reporte de mermas",
                    fileName: "mermas-\(getNow())",
                    aiResponse: resp.airesponse,
                    in: self.resultDiv
                ) {
                    showAlert(.alerta, "El reporte de PDF estare dispobible pronto si lo ocupa antes haganos lo saber ")
                } excelCallback: {
                    self.downloadMermReport(startAt: startAtUTS, endAt: endAtUTS, storeId: store, merms: payload.merms)
                }

                let totalUnits = payload.merms.map { $0.items.count }.reduce(0, +)
                let averageUnits = Double(totalUnits) / Double(max(payload.merms.count, 1))
                let largestDocuments = Array(payload.merms.sorted { $0.items.count > $1.items.count }.prefix(8))

                self.resultDiv.appendChild(ProductManagerView.AuditView.reportHeader(
                    title: "📉 Resumen de mermas",
                    subtitle: "Unidades retiradas del inventario durante el periodo",
                    context: "Alcance: \(stores[store]?.name ?? "Tienda") • Periodo: \(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong) • Generado: \(getDate(getNow()).formatedLong)"
                ))

                self.resultDiv.appendChild(Div {
                    ProductManagerView.AuditView.reportMetric(title: "Documentos", value: payload.merms.count.toString, detail: "Registros de merma")
                    ProductManagerView.AuditView.reportMetric(title: "Unidades", value: totalUnits.toString, detail: "Unidades afectadas")
                    ProductManagerView.AuditView.reportMetric(title: "Promedio / documento", value: String(format: "%.1f", averageUnits), detail: "Unidades por registro")
                    ProductManagerView.AuditView.reportMetric(title: "Mayor documento", value: (largestDocuments.first?.items.count ?? 0).toString, detail: "Máximo de unidades")
                }
                .class(Class(TCCrystalSurfaceClass.auditMetricGrid)))

                if payload.merms.isEmpty {
                    self.resultDiv.appendChild(
                        Table().noResult(label: "Sin mermas para el periodo seleccionado")
                    )
                    return
                }

                self.resultDiv.appendChild(ProductManagerView.AuditView.reportBarChart(
                    title: "Documentos con mayor merma",
                    items: largestDocuments.map {
                        ($0.folio, Double($0.items.count), $0.items.count.toString)
                    }
                ))

                self.asyncAddMerm(
                    renderId: renderId,
                    items: payload.merms
                )
                
            }

        }

        private func asyncAddMerm(
            renderId: UUID,
            items: [CustFiscalInventoryControl],
            index: Int = 0
        ) {
            guard renderId == mermRenderId,
                  items.indices.contains(index) else {
                return
            }

            let view = ProductTransferViewRow(
                item: items[index],
                removed: { _ in }
            )

            guard renderId == mermRenderId else {
                view.remove()
                return
            }

            resultDiv.appendChild(view)

            Dispatch.asyncAfter(0.01) {
                guard renderId == self.mermRenderId else {
                    return
                }

                self.asyncAddMerm(
                    renderId: renderId,
                    items: items,
                    index: index + 1
                )
            }
        }
        
        func downloadMermReport(startAt: Int64, endAt: Int64, storeId: UUID, merms: [CustFiscalInventoryControl]) {
            
            loadingView.show()

            prepareMermReport(merms: merms, items: []) { items in

                    var name = ""
                    
                    func csvField(_ value: String) -> String {
                        let normalizedValue = value
                            .replacingOccurrences(of: "\r", with: " ")
                            .replacingOccurrences(of: "\n", with: " ")
                            .replacingOccurrences(of: "\"", with: "\"\"")
                        return "\"\(normalizedValue)\""
                    }

                    var contents = [
                        "Fecha",
                        "Folio",
                        "Tienda",
                        "Descripción",
                        "UPC",
                        "Producto",
                        "Marca",
                        "Modelo",
                        "Costo",
                        "Bodega",
                        "Sección",
                        "Estatus",
                        "ID Inventario"
                    ]
                    .map(csvField)
                    .joined(separator: ",") + "\n"

                    items.forEach { report in
                        var pocReference: [UUID: CustPOCQuick] = [:]
                        report.pocs.forEach { poc in
                            pocReference[poc.id] = poc
                        }

                        var placeReference: [UUID: CustPOCStoragePlace] = [:]
                        report.places.forEach { place in
                            placeReference[place.poc] = place
                        }

                        report.items.forEach { inventory in
                            let poc = pocReference[inventory.POC]
                            let place = placeReference[inventory.POC]
                            let productName = poc.map {
                                "\($0.name) \($0.brand) \($0.model)".purgeSpaces
                            } ?? ""
                            let cost = poc.map {
                                $0.cost.formatMoney.replace(from: ",", to: "")
                            } ?? ""

                            let row = [
                                getDate(report.control.createdAt).formatedLong,
                                report.control.folio,
                                report.fromStore.name,
                                report.control.description,
                                poc?.upc ?? "",
                                productName,
                                poc?.brand ?? "",
                                poc?.model ?? "",
                                cost,
                                place?.bod ?? "",
                                place?.sec ?? "",
                                inventory.status.description,
                                inventory.id.uuidString
                            ]

                            contents += row.map(csvField).joined(separator: ",") + "\n"
                        }
                    }
                    
                    stores.forEach { id, store in
                        if storeId == id {
                            name = store.name
                        }
                    }
                    
                    name += " \(getDate(startAt).formatedLong) al \(getDate(endAt).formatedLong)"
                    
                    let fileName = safeFileName(name: name, to: .none, folio: nil)
                    
                    _ = JSObject.global.download!( "\(fileName).csv", contents)
                    
                    loadingView.hide()
            }
            
        }

        func prepareMermReport(merms: [CustFiscalInventoryControl], items: [CustPOCComponents.GetTransferInventoryResponse], callback: @escaping (_ items: [CustPOCComponents.GetTransferInventoryResponse])->Void) {

            if merms.isEmpty {
                callback(items)
                return
            }

            var merms = merms

            var items = items

            guard let merm = merms.popLast() else {
                prepareMermReport(
                    merms: merms,
                    items: items,
                    callback: callback
                )
                return
            }

            API.custPOCV1.getTransferInventory(identifier: .id(merm.id)) { resp in

                guard let resp = resp else {
                    loadingView.hide()
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else{
                    loadingView.hide()
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    loadingView.hide()
                    showError(.unexpectedResult, "No se pudo obtener documento")
                    return
                }

                items.append(payload)

                self.prepareMermReport(
                    merms: merms,
                    items: items,
                    callback: callback
                )
                
            }
        }
        

        override func didRemoveFromDOM() {
            mermRenderId = UUID()
            super.didRemoveFromDOM()
            $storeSelectListener.removeAllListeners()
            $dateSelectListener.removeAllListeners()
            $startAt.removeAllListeners()
            $endAtLabel.removeAllListeners()
            $endAt.removeAllListeners()
            $startAtLabel.removeAllListeners()
        }
    }
}
