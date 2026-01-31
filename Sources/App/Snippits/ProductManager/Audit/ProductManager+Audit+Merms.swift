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

        @State var merms: [CustFiscalInventoryControl] = []
        
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
        
        lazy var resultDiv = Div{
            Table().noResult(label: "📈 Seleccione una tienda para iniciar")
            .hidden(self.$merms.map{ !($0.isEmpty) })

            ForEach(self.$merms) { merm in

                ProductTransferViewRow(item: merm, removed: { id in
                    
                })

            }
            .hidden(self.$merms.map{ $0.isEmpty })

        }
        .custom("height", "calc(100% - 85px)")
        .overflow(.auto)
        
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
            
            loadingView(show: true)
            
            API.custPOCV1.getMerms(
                store: store,
                startAt: startAtUTS,
                 endAt: endAtUTS
            ) { resp in

                loadingView(show: false)
                
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

                self.merms = payload.merms
                
            }

        }
        
        func downloadCardexReport(startAt: Int64, endAt: Int64, storeId: UUID, payload: CustPOCComponents.CardexResponse) {
            
            loadingView(show: true)
            
            var name = ""
            
            var contents =
            "SKU/UPC/POC," +
            "Nombre x Marca / Modelo," +
            "Costo," +
            "Precio," +
            "Saldo Ini," +
            "Inicial," +
            "+ Agr," +
            "- Rem," +
            "Final," +
            "Saldo Fini\n"
            
            var totalInitialUnits: Int = 0
            
            var totalAddedUnits: Int = 0
            
            var totalRemovedUnits: Int = 0
            
            var totalFinalUnits: Int = 0
            
            var totalInitialCost: Int64 = 0
            
            var totalFinalCost: Int64 = 0
            
            stores.forEach { id, store in
                if storeId == id {
                    name = store.name
                }
            }
            
            name += " \(getDate(startAt).formatedLong) al \(getDate(endAt).formatedLong)"
            
            let fileName = safeFileName(name: name, to: .none, folio: nil)
            
            payload.objects.forEach { item in
                
                totalInitialUnits += item.initalInventory
                
                totalAddedUnits += item.addedInventory
                
                totalRemovedUnits += item.removeInventory
                
                totalFinalUnits += item.finalInventory
                
                totalInitialCost += item.initalBalance
                
                totalFinalCost += item.finalBalance
                
                contents +=
                "\(item.poc.upc)," +
                "\("\(item.poc.name) \(item.poc.brand) \(item.poc.model)".purgeSpaces)," +
                "\(item.poc.cost.formatMoney.replace(from: ",", to: ""))," +
                "\(item.poc.pricea.formatMoney.replace(from: ",", to: ""))," +
                "\(item.initalBalance.formatMoney.replace(from: ",", to: ""))," +
                "\(item.initalInventory.toString)," +
                "\(item.addedInventory.toString)," +
                "\(item.removeInventory.toString)," +
                "\(item.finalInventory.toString)," +
                "\(item.finalBalance.formatMoney.replace(from: ",", to: ""))\n"
                
            }
            
            contents += ",,,," +
            "\(totalInitialCost.formatMoney.replace(from: ",", to: ""))," +
            "\(totalInitialUnits.toString)," +
            "\(totalAddedUnits.toString)," +
            "\(totalRemovedUnits.toString)," +
            "\(totalFinalUnits.toString)," +
            "\(totalFinalCost.formatMoney.replace(from: ",", to: ""))"
            
            loadingView(show: false)
            
            _ = JSObject.global.download!( "\(fileName).csv", contents)
            
            
        }
        
    }
}
