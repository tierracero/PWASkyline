//
//  ProductManager+Audit+Products.swift
//  
//
//  Created by Victor Cantu on 7/7/23.
//

import Foundation
import TCFundamentals 
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class Products: Div {
        
        override class var name: String { "div" }
        
        @State var typeSelectListener: CardexRequestType = .store
        
        lazy var typeSelect = Select()
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(200.px)
            .height(34.px)
            .onChange { _, select in
                
                if let type = CardexRequestType(rawValue: select.text) {
                    self.typeSelectListener = type
                }
                
            }
        
        @State var selectCustomerListener = ""
        
        @State var selectCustomerId: UUID? = nil
        
        lazy var selectCustomerField = InputText(self.$selectCustomerListener)
            .custom("width", "calc(100% - 8px)")
            .class(.textFiledBlackDark)
            .placeholder("Buscar...")
            .fontSize(22.px)
            .height(34.px)
        
        @State var storeSelectListener = custCatchStore.uuidString
        
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
        }
        .custom("height", "calc(100% - 85px)")
        .overflow(.auto)
        
        @DOM override var body: DOM.Content {
            /// Filter View
            Div{
                
                /// Seleccione Tienda
                Div{
                    Label("Tipo de Reporte")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.typeSelect
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
                .hidden(self.$typeSelectListener.map{ $0 != .store })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                Div{
                    
                    Label("Seleccione Concesionario")
                        .fontSize(12.px)
                        .color(.gray)
                    
                    Div().clear(.both)
                    
                    Div{
                        
                        Div{
                            
                            Div{
                                self.selectCustomerField
                            }
                            .custom("width", "calc(100% - 45px)")
                            .float(.left)
                            
                            Div{
                                Img()
                                    .src("/skyline/media/zoom.png")
                                    .marginLeft(5.px)
                                    .marginTop(3.px)
                                    .width(35.px)
                            }
                            .width(45.px)
                            .float(.left)
                            
                            Div()
                                .position(.absolute)
                                .height(100.percent)
                                .width(100.percent)
                                .cursor(.pointer)
                                .onClick {
                                    self.selectConcesionier()
                                }
                            
                        }
                        .position(.fixed)
                        
                    }
                    .marginRight(50.px)
                    .width(224.px)
                }
                .hidden(self.$typeSelectListener.map{ $0 != .concessionaire })
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
            
            Div().clear(.both)
            
            self.resultDiv
            
        }
        
        override func buildUI() {
            height(100.percent)
            
            CardexRequestType.allCases.forEach { type in
                typeSelect.appendChild(Option(type.description).value(type.rawValue))
            }
            
            stores.forEach { _, store in
                
                if store.id != custCatchStore {
                    return
                }
                
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }
            
            stores.forEach { _, store in
                
                if store.id == custCatchStore {
                    return
                }
                
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
            
        }
        
        func createReport() {
            
            var relationId: UUID? = nil
            
            switch typeSelectListener {
            case .store:
                guard let storeId: UUID = UUID(uuidString: storeSelectListener) else {
                    showError(.errorGeneral, "Seleccione una tienda valida.")
                    return
                }
                
                relationId = storeId
                
            case .concessionaire:
                
                guard let selectCustomerId else {
                    showError(.errorGeneral, "Seleccione una cliente concesionario.")
                    return
                }
                
                relationId = selectCustomerId
                
            }
            
            guard let relationId else {
                showError(.unexpectedResult, "No se establecio id a buscar")
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
            
            guard let startAtUTS else {
                showError(.errorGeneral, "Seleccione una fecha valida.")
                return
            }
            
            guard let endAtUTS else {
                showError(.errorGeneral, "Seleccione una fecha valida.")
                return
            }
            
            loadingView(show: true)
            
            API.custPOCV1.cardex(
                relationId: relationId,
                pocIds: [],
                startAt: startAtUTS,
                endAt: endAtUTS
            ) { resp in
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
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
             
                let tableBody = TBody()
                
                let table = Table{
                    THead{
                        Tr{
                            Td("")
                            Td("SKU/UPC/POC")
                            Td("Nombre / Marca / Modelo")
                            Td("Costo")
                            Td("Precio")
                            Td("Saldo Ini")
                            Td("Inicial")
                            Td("+ Agr")
                                .width(50.px)
                            Td("- Rem")
                                .width(50.px)
                            Td("Final")
                            Td("Saldo Fini")
                        }
                    }
                    .custom("inset-block-start", "0")
                    .backgroundColor(.black)
                    .position(.sticky)
                    tableBody
                }
                    .height(100.percent)
                    .width(100.percent)
                    .color(.white)
                
                var totalInitialUnits: Int = 0
                
                var totalAddedUnits: Int = 0
                
                var totalRemovedUnits: Int = 0
                
                var totalFinalUnits: Int = 0
                
                var totalInitialCost: Int64 = 0
                
                var totalFinalCost: Int64 = 0
                
                payload.objects.forEach { item in
                    
                    totalInitialUnits += item.initalInventory
                    
                    totalAddedUnits += item.addedInventory
                    
                    totalRemovedUnits += item.removeInventory
                    
                    totalFinalUnits += item.finalInventory
                    
                    totalInitialCost += item.initalBalance
                    
                    totalFinalCost += item.finalBalance
                    
                    let avatar = Img()
                        .src("/skyline/media/512.png")
                        .borderRadius(all: 12.px)
                        .marginRight(7.px)
                        .objectFit(.cover)
                        .height(75.px)
                        .width(75.px)
                        .float(.left)
                    
                    tableBody.appendChild(Tr{
                        Td{
                            avatar
                        }
                        Td(item.poc.upc)
                        Td("\(item.poc.name) \(item.poc.brand) \(item.poc.model)".purgeSpaces)
                        Td(item.poc.cost.formatMoney)
                            .align(.right)
                        Td(item.poc.pricea.formatMoney)
                            .align(.right)
                        Td(item.initalBalance.formatMoney)
                            .align(.right)
                        Td(item.initalInventory.toString)
                            .align(.right)
                        Td(item.addedInventory.toString)
                            .align(.right)
                        Td(item.removeInventory.toString)
                            .align(.right)
                        Td(item.finalInventory.toString)
                            .align(.right)
                        Td(item.finalBalance.formatMoney)
                            .align(.right)
                    }.class(.hoverFocusBlack))
                    
                    if let pDir = customerServiceProfile?.account.pDir, !item.poc.avatar.isEmpty {
                        avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(item.poc.avatar)")
                    }
                }
                
                let costTaxSI = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: totalInitialCost * 10000,
                    discount: 0,
                    retenidos: [],
                    trasladados: [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                )
                
                let _costSubTotalSI = (costTaxSI.subTotal.doubleValue / 1000000)
                
                let _costTaxTrasladadosSI = (costTaxSI.trasladado.doubleValue / 1000000)
                
                let costTaxSF = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: totalFinalCost * 10000,
                    discount: 0,
                    retenidos: [],
                    trasladados: [
                        .init(
                            type: .iva,
                            factor: .tasa,
                            taza: "0.160000"
                        )
                    ]
                )
                
                
                let _costSubTotalSF = (costTaxSF.subTotal.doubleValue / 1000000)
                
                let _costTaxTrasladadosSF = (costTaxSF.trasladado.doubleValue / 1000000)
                
                table.appendChild(
                    TFoot{
                        
                        // MARK: SUB TOTAL
                        Tr{
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td("SUB T.")
                            Td(_costSubTotalSI.formatMoney)
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(_costSubTotalSF.formatMoney)
                                .align(.right)
                        }
                        
                        // MARK: TAXES
                        Tr{
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td("IVA")
                            Td(_costTaxTrasladadosSI.formatMoney)
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(" ")
                                .align(.right)
                            Td(_costTaxTrasladadosSF.formatMoney)
                                .align(.right)
                        }
                        
                        // MARK: TOTAL
                        Tr{
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td(" ")
                            Td(totalInitialCost.formatMoney)
                                .align(.right)
                            Td(totalInitialUnits.toString)
                                .align(.right)
                            Td(totalAddedUnits.toString)
                                .align(.right)
                            Td(totalRemovedUnits.toString)
                                .align(.right)
                            Td(totalFinalUnits.toString)
                                .align(.right)
                            Td(totalFinalCost.formatMoney)
                                .align(.right)
                        }
                    }
                        .custom("inset-block-end", "0")
                        .backgroundColor(.black)
                        .position(.sticky)
                )
                
                self.resultDiv.innerHTML = ""
                
                self.resultDiv.appendChild(
                    Div{
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/excel.png")
                                .marginLeft(12.px)
                                .height(18.px)

                         }
                        .float(.right)
                        .onClick {
                            self.downloadCardexReport(
                                .csv,
                                startAt: startAtUTS,
                                endAt: endAtUTS,
                                storeId: relationId,
                                payload: payload
                            )
                        }
                        
                        Div{

                            Img()
                                .src("/skyline/media/pdf.png")
                                .marginLeft(12.px)
                                .height(18.px)
                             
                         }
                        .float(.right)
                        .onClick {
                            self.downloadCardexReport(
                                .pdf,
                                startAt: startAtUTS,
                                endAt: endAtUTS,
                                storeId: relationId,
                                payload: payload
                            )
                        }
                        

                        H1("Resultados")
                            .color(.darkGoldenRod)
                    }
                        .borderBottom(width: .thin, style: .solid, color: .darkGoldenRod)
                )
                
                self.resultDiv.appendChild(Div().clear(.both).height(3.px))
                
                self.resultDiv.appendChild(table)
                
            }
        }
        
        func downloadCardexReport(_ documentType:  DocumentType, startAt: Int64, endAt: Int64, storeId: UUID, payload: CustPOCEndpointV1.CardexResponse) {
            
            loadingView(show: true)
            
            var name = ""
            
            let tableHeader: [String] = [
                "POC/SKU/UPC | Nombre | Marca",
                "Modelo",
                "Costo",
                "Precio",
                "Saldo Ini",
                "Inicial",
                "+ Agr",
                "- Rem",
                "Final",
                "Saldo Fini"
            ]

            var tableBody: [[String]] = []

            var contents = "\(custCatchUrl),Reporte de Cardex,,,,,,,,\n" +
            tableHeader.joined(separator: ",") + "\n"
            
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
            
            if name.isEmpty{
                name = selectCustomerListener
            }
            
            name += " \(getDate(startAt).formatedLong) al \(getDate(endAt).formatedLong)"
            
            let fileName = safeFileName(name: "\(name)", to: .none, folio: nil)
            
            payload.objects.forEach { item in
                
                totalInitialUnits += item.initalInventory
                
                totalAddedUnits += item.addedInventory
                
                totalRemovedUnits += item.removeInventory
                
                totalFinalUnits += item.finalInventory
                
                totalInitialCost += item.initalBalance
                
                totalFinalCost += item.finalBalance
                
                let row: [String] = [
                    "\(item.poc.upc) \(item.poc.name) \(item.poc.brand)",
                    item.poc.model,
                    item.poc.cost.formatMoney,
                    item.poc.pricea.formatMoney,
                    item.initalBalance.formatMoney,
                    item.initalInventory.toString,
                    item.addedInventory.toString,
                    item.removeInventory.toString,
                    item.finalInventory.toString,
                    item.finalBalance.formatMoney
                ]

                tableBody.append(row)

                contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") +  "\n"
    
            }
            
            
            let costTaxSI = calcSubTotal(
                substractedTaxCalculation: true,
                units: 100 * 10000,
                cost: totalInitialCost * 10000,
                discount: 0,
                retenidos: [],
                trasladados: [
                    .init(
                        type: .iva,
                        factor: .tasa,
                        taza: "0.160000"
                    )
                ]
            )
            
            let _costSubTotalSI = (costTaxSI.subTotal.doubleValue / 1000000)
            
            let _costTaxTrasladadosSI = (costTaxSI.trasladado.doubleValue / 1000000)
            
            let costTaxSF = calcSubTotal(
                substractedTaxCalculation: true,
                units: 100 * 10000,
                cost: totalFinalCost * 10000,
                discount: 0,
                retenidos: [],
                trasladados: [
                    .init(
                        type: .iva,
                        factor: .tasa,
                        taza: "0.160000"
                    )
                ]
            )
            
            let _costSubTotalSF = (costTaxSF.subTotal.doubleValue / 1000000)
            
            let _costTaxTrasladadosSF = (costTaxSF.trasladado.doubleValue / 1000000)
            
            // MARK: SUB TOTAL
            var row: [String] = [
                "",
                "",
                "",
                "",
                "",
                _costSubTotalSI.formatMoney,
                "",
                "",
                "",
                "",
                _costSubTotalSF.formatMoney,
            ]

            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") +  "\n"
            
            // MARK: TAX
            row = [
                "",
                "",
                "",
                "",
                "",
                _costTaxTrasladadosSI.formatMoney,
                "",
                "",
                "",
                "",
                _costTaxTrasladadosSF.formatMoney,
            ]
            
            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") +  "\n"
            
            // MARK: TOTAL
            row = [
                "",
                "",
                "",
                "",
                "",
                totalInitialCost.formatMoney,
                totalInitialUnits.toString,
                totalAddedUnits.toString,
                totalRemovedUnits.toString,
                totalFinalUnits.toString,
                totalFinalCost.formatMoney,
            ]
            
            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") +  "\n"
            
            loadingView(show: false)
            
            switch documentType {
                case .csv:
                _ = JSObject.global.download!( "\(fileName).csv", contents)
                case .pdf:
                _ = JSObject.global.createProductAuditPDF!( fileName, name, tableHeader, tableBody)
            }

        }
        
        func selectConcesionier(){
            
            let view = SearchCustomerQuickView { account in
                
                guard account.isConcessionaire else {
                    showError(.errorGeneral, "La cuenta no tiene perfil de concesionario.")
                    return
                }
                
                self.selectCustomerListener = "\(account.businessName) \(account.firstName) \(account.lastName)"
                
                self.selectCustomerId = account.id
                
            } create: { _ in
                //MARK: No create callback requiered
            }
            
            view.canCreateAccount = false

            addToDom(view)
            
        }
    }
}


extension ProductManagerView.AuditView.Products {
    

    enum DocumentType {

        case csv

        case pdf

    }

    
    public enum CardexRequestType: String, Codable, CaseIterable {
        
        case store
        
        case concessionaire
        
        public var description: String {
            switch self {
            case .store:
                return "Tienda"
            case .concessionaire:
                return "Consessionario"
            }
        }
        
    }
    
}
