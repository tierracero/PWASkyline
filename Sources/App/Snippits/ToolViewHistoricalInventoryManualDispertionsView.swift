//
//  ToolViewHistoricalInventoryManualDispertionsView.swift
//
//
//  Created by Victor Cantu on 12/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolViewHistoricalInventoryManualDispertionsView: Div {
        
        override class var name: String { "div" }
        
        /// general, byStore, byVendor
        @State var reportType: PurchaseOrderAuditTypes? = nil
        
        /// PurchaseOrderAuditTypes
        @State var auditTypeListener = ""
        
        @State var docs: [API.custPOCV1.GetManualDispertionsObject] = []

        @State var selectedDoc: UUID?  = nil

        /// InventoryAuditTypes
        lazy var auditTypeSelect = Select(self.$auditTypeListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(210.px)
            .height(34.px)
        
        @State var storeSelectListener = ""
        
        lazy var storeSelect = Select(self.$storeSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(210.px)
            .height(34.px)
        
        @State var vendorSelectListener = ""
        
        lazy var vendorSelect = Select(self.$vendorSelectListener)
            .body{
                Option("Seleccione Proveedor")
                    .value("")
            }
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

        @State var hasSearched = false
        
        lazy var innerSearchResultView = Div{

            Table().noResult(label: "No hay resultados para esta busqueda")
            .hidden(self.$docs.map{ !$0.isEmpty })

            Div{

                Div{
                    ForEach(self.$docs) { item in
                        
                        Div{
                            Div{
                                Div{
                                    
                                    Span(item.folio)
                                    
                                    Img()
                                        .src("/skyline/media/download2.png")
                                        .marginRight(12.px)
                                        .marginTop(2.px)
                                        .height(24.px)
                                        .float(.right)
                                        .onClick { _, event in
                                            
                                            loadingView(show: true)
                                            
                                            downloadManualInventoryControlOrders(id: item.id, detailed: true)
                                            
                                            Dispatch.asyncAfter(3.0) {
                                                loadingView(show: false)
                                            }
                                            event.stopPropagation()
                                        }
                                    
                                }
                                .custom("width", "calc(100% - 150px)")
                                .class(.oneLineText)
                                .float(.left)
                                
                                Div(getDate(item.createdAt).formatedLong)
                                    .width(150.px)
                                    .float(.left)
                                
                                Div().clear(.both)
                            }
                            .marginBottom(7.px)
                            .fontSize(20.px)
                            .color(.gray)
                            
                            Div{
                                
                                Div(item.name)
                                    .custom("width", "calc(100% - 140px)")
                                    .class(.oneLineText)
                            }
                            .marginBottom(7.px)
                            .fontSize(22.px)
                            
                            Div{
                                Div("\(item.vendor.businessName) \(item.vendor.razon)")
                                    .custom("width", "calc(100% - 140px)")
                                    .class(.oneLineText)
                                    .float(.left)
                                
                                Div(item.status.description)
                                    .width(140.px)
                                    .float(.left)
                                
                                Div().clear(.both)
                            }
                            .fontSize(16.px)
                            
                            Div().height(7.px).clear(.both)
                            
                        }
                        .width(96.percent)
                        .marginTop(12.px)
                        .class(.uibtn)
                        .border(width: .thin, style: .solid, color: self.$selectedDoc.map { ($0 == item.id) ? .cornflowerBlue : .transparent })
                        .onClick {

                            self.selectedDoc = item.id

                            self.loadDocument(id: item.id)
                        }
                        
                    }
                }
                .custom("height", "calc(100% - 56px)")
                .overflow(.auto)

                Div{

                    

                    Img()
                        .src("/skyline/media/excel.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            
                        }
                    
                    Img()
                        .src("/skyline/media/pdf.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            
                        }
                }
                .align(.right)
            }
            .hidden(self.$docs.map{ $0.isEmpty })
            .height(100.percent)

        }
            .height(100.percent)

        lazy var searchResultView  = Div{
            Div{
                self.innerSearchResultView
            }
            .custom("height", "calc(100% - 14px)")
            .class(.roundDarkBlue)
            .margin(all: 5.px)
        }
        .height(100.percent)
        .width(33.percent)
        .float(.left)

        lazy var innerPurchaseView = Div{
            Table().noResult(label: "Seleccione una entarda para ver compra")
        }
            .height(100.percent)
            .overflow(.auto)

        lazy var purchaseView  = Div{
            Div{
                self.innerPurchaseView
            }
            .custom("height", "calc(100% - 14px)")
            .margin(all: 7.px)
        }
        .height(100.percent)
        .width(66.percent)
        .float(.left)

        lazy var resultDiv = Div {
            Table().noResult(label: "📈 Seleccione una fecha y tienda para iniciar")
            .hidden(self.$hasSearched)

            Div{

                self.searchResultView 

                self.purchaseView

            }
            .height(100.percent)
            .width(100.percent)
            .hidden(self.$hasSearched.map{ !$0 })

        }
        .custom("height", "calc(100% - 100px)")
        .overflow(.auto)
        
        @DOM override var body: DOM.Content {
                        
            Div {
                    
                /* Header*/
                Div {
                    
                    Img()
                        .closeButton(.uiView1)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Compras Historicas")
                    .color(.lightBlueText)
                    
                }

                /* Filter View */
                Div{
                    /* Tipo de reporte*/
                    Div{
                        Label("Tipo de reporte")
                            .fontSize(12.px)
                            .color(.gray)
                        
                        Div().clear(.both)
                        
                        self.auditTypeSelect
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
                    .hidden(self.$reportType.map{$0 == nil })
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
                    .hidden(self.$reportType.map{$0 == nil })
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
                    .hidden(self.$reportType.map{$0 == nil })
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
                        Label("Seleccione Vendor")
                            .fontSize(12.px)
                            .color(.gray)
                        Div().clear(.both)
                        self.vendorSelect
                    }
                    .hidden(self.$reportType.map{ !($0?.vendorable == true) })
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
                
                /// Results View
                self.resultDiv
                
            }
            .custom("left", "calc(10% - 24px)")
            .custom("top", "calc(10% - 24px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(80.percent)
            .width(80.percent)

        }
        
        override func buildUI() {
             self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.absolute)
            left(0.px)
            top(0.px)
            
            auditTypeSelect.appendChild(
                Option("Seleccione")
                    .value("")
            )
            
            PurchaseOrderAuditTypes.allCases.forEach { type in
                auditTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
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
            
            $auditTypeListener.listen {
                
                self.reportType = PurchaseOrderAuditTypes(rawValue: $0)
                
                guard let reportType = self.reportType else {
                    return
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
            
            loadingView(show: true)

            API.custAPIV1.getVendors { resp in
                
                loadingView(show: false)

                print("🟢. 001")

                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    print("🔴 001")
                    self.remove()
                    return
                }
                
                guard let vendors = resp.data?.vendors else {
                    showError( .unexpectedResult, .unexpenctedMissingPayload)
                    print("🔴 002")
                    self.remove()
                    return
                }

                vendors.forEach { vendor in

                    self.vendorSelect.appendChild(
                        Option(" \(vendor.rfc) \(vendor.businessName) ")
                            .value(vendor.id.uuidString)
                    )  
                }

            }

            hasSearched = true

        }
        
        func requestReport(){
             
            guard let type = PurchaseOrderAuditTypes(rawValue: auditTypeListener) else {
                showError(.campoRequerido, "Ingrese tipo de reporte")
                return
            }
            
            var storeId: UUID? = UUID(uuidString: storeSelectListener)
            
            var vendorId : UUID? = UUID(uuidString: vendorSelectListener)
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
        
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
            
            var relId: UUID? = nil
            
            switch type {    
            case .byStore:
                guard let id =  storeId else {
                    showError(.errorGeneral, "Selecicone tienda para generar el reporte")
                    return 
                }
                relId = id
            case .byVendor:
                guard let id =  vendorId else {
                    showError(.errorGeneral, "Selecicone proveedor para generar el reporte")
                    return 
                }
                relId = id
            case .general:
                break
            }
            
            guard let startAtUTS  else {
                showError(.errorGeneral, "Ingrese un fecha de inicio valida")
                return 
            }

            guard let endAtUTS  else {
                showError(.errorGeneral, "Ingrese un fecha de finalizacion valida")
                return 
            }
            
            loadingView(show: true)

            API.custPOCV1.getManualDispertions(type: .historic(.init(
                type: type,
                 from: startAtUTS,
                  to: endAtUTS,
                   relId: relId
            ))){ resp in

                loadingView(show: false)

                self.hasSearched = true

                self.selectedDoc = nil
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.docs = data
                
            }

        }

        func loadDocument(id: UUID) {
            
            loadingView(show: true)
            
            API.custPOCV1.getManualDispertion(
                docId: .id(id)
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
                
                let view = ToolReciveSendInventory(loadid: nil)

                view.loadManualDispertion(payload)

                self.innerPurchaseView.innerHTML = ""

                self.innerPurchaseView.appendChild(view.innerBody)

            }
            
        }
            

        /*
        func download(name: String, item: [API.custPOCV1.AuditObject], type: InventoryAuditTypes, title: String) {
            
            loadingView(show: true)
            
            var contents = ""
            
            switch type {
            case .general:
                break
            case .lowInvetory:
                break
            case .byStore:
                contents = downloadByStore(items: item, title: title)
            case .byDepartement:
                break
            case .byProduct:
                contents = downloadByProduct(item: item, title: title)
            case .bySales:
                contents = downloadBySales(item: item, title: title)
                
            case .bySalesConcession:
                contents = downloadBySalesConcession(item: item, title: title)
                
            case .byCustomerSales:
                contents = downloadBySales(item: item, title: title)
            case .byUserSales:
                contents = downloadBySales(item: item, title: title)
            case .byConcession:
                contents = downloadByConcession(item: item, title: title)
            }
            
            _ = JSObject.global.download!( name, contents)
            
            loadingView(show: false)
            
        }
        
        func downloadByStore (items: [API.custPOCV1.AuditObject], title: String) -> String {
            
            var contents = "\(title),\(custCatchUrl),,\n" +
            "POC/SKU/UPC," +
            "Nombre," +
            "Marca," +
            "Modelo," +
            "DiaZero," +
            "Mas Antig," +
            "Mas Nuevo," +
            "Unis," +
            "Cost," +
            "Precio\n"
            
            var catchItems: [API.custPOCV1.AuditObject] = []
            
            var storeCostTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            var itemRefrence: [String:API.custPOCV1.AuditObject] = [:]
            
            var nocodeRefrence: [API.custPOCV1.AuditObject] = []
            
            items.forEach { item in
                
                if let poc = self.pocRefrence[item.id] {
                    
                    if poc.upc.isEmpty {
                        nocodeRefrence.append(item)
                        return
                    }
                 
                    itemRefrence[poc.upc] = item
                    
                }
            }
            
            let upcs = itemRefrence.map{ $0.key }.sorted()
            
            upcs.forEach { upc in
                if let item = itemRefrence[upc] {
                    catchItems.append(item)
                }
            }
            
            catchItems.append(contentsOf: nocodeRefrence)
            
            catchItems.forEach { item in
                
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
                
                contents += "\(poc?.upc ?? "N/D"),\(poc?.name ?? "N/D"),\(poc?.brand ?? "N/D"),\(poc?.model ?? "N/D"),\(item.zeroDay?.toString ?? "---"),\(oldestItem),\(newestItem),\(item.items.count.toString),\(itemCostTotal.formatMoney.replace(from: ",", to: "")),\(itemPriceTotal.formatMoney.replace(from: ",", to: ""))\n"
                
                storeCostTotal += itemCostTotal
                
                storePriceTotal += itemPriceTotal
                
            }
            
            contents += ",,,,,,,,\(storeCostTotal.formatMoney.replace(from: ",", to: "")),\(storePriceTotal.formatMoney.replace(from: ",", to: ""))\n"
            
            return contents
        }
        
        func downloadByProduct (item: [API.custPOCV1.AuditObject], title: String) -> String {
            
            var contents = "\(title),\(custCatchUrl),,\n" +
            "SKU / UPC / POC, Nombre, Existente, Faltante"
            
            return contents
            
        }
        
        func downloadBySales (item: [API.custPOCV1.AuditObject], title: String) -> String {
            
            var contents = "\(custCatchUrl),\(title),,,,,,,,\n" +
            "POC/SKU/UPC,Nombre,Marca,Modelo,DiaZero,Mas Antig.,Mas Nuevo,Unis.,Costo,IVA,Costo Neto,Precio,IVA,Precio Neto\n"
            
            var itemRefrence: [String:API.custPOCV1.AuditObject] = [:]
            
            var nocodeRefrence: [API.custPOCV1.AuditObject] = []
           
            var costSubTotal: Int64 = 0
            
            var costTaxTotal: Int64 = 0
            
            var storeCostTotal: Int64 = 0
            
            var priceSubTotal: Int64 = 0
            
            var priceTaxTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            item.forEach { item in
                
                if let poc = self.pocRefrence[item.id] {
                    
                    if poc.upc.isEmpty {
                        nocodeRefrence.append(item)
                        return
                    }
                 
                    itemRefrence[poc.upc] = item
                    
                }
            }
            
            item.forEach { item in
                
                let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                
                /// CalcSubTotalResponse
                let costTax = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: itemCostTotal * 10000,
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
                
                
                let _costSubTotal = (costTax.subTotal.doubleValue / 1000000)
                
                let _costTaxTrasladados = (costTax.trasladado.doubleValue / 1000000)
                
                let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                
                /// CalcSubTotalResponse
                let priceTax = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: itemPriceTotal * 10000,
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
                
                let _priceSubTotal = (priceTax.subTotal.doubleValue / 1000000)
                
                let _priceTaxTrasladados = (priceTax.trasladado.doubleValue / 1000000)
                
                //let priceTaxRetenidos = (priceTax.retenido.doubleValue / 1000000).formatMoney
                
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
                
                contents += "\(poc?.upc ?? "N/D"),\((poc?.name ?? "N/D").replace(from: ",", to: "")),\(poc?.brand ?? "N/D"),\(poc?.model ?? "N/D"),\(item.zeroDay?.toString ?? "---"),\(oldestItem),\(newestItem)," +
                "\"\(item.items.count.toString)\"," +
                "\"\(_costSubTotal.formatMoney)\"," +
                "\"\(_costTaxTrasladados.formatMoney)\"," +
                "\"\(itemCostTotal.formatMoney)\"," +
                "\"\(_priceSubTotal.formatMoney)\"," +
                "\"\(_priceTaxTrasladados.formatMoney)\"," +
                "\"\(itemPriceTotal.formatMoney)\"\n"
                
                costSubTotal += _costSubTotal.toCents
                
                costTaxTotal += _costTaxTrasladados.toCents
                
                storeCostTotal += itemCostTotal
                
                
                priceSubTotal += _priceSubTotal.toCents
               
                priceTaxTotal += _priceTaxTrasladados.toCents
                
                storePriceTotal += itemPriceTotal
                
            }
            
            contents += ",,,,,,,,\"\(costSubTotal.formatMoney)\",\"\(costTaxTotal.fromCents)\",\"\(storeCostTotal.formatMoney)\",\"\(priceSubTotal.formatMoney)\",\"\(priceTaxTotal.fromCents)\",\"\(storePriceTotal.formatMoney)\"\n"
            
            return contents
            
        }
        
        func downloadBySalesConcession (item: [API.custPOCV1.AuditObject], title: String) -> String {
            
            var contents = "\(custCatchUrl),\(title),,,,,,,,\n" +
            "POC/SKU/UPC,Nombre,Marca,Modelo,DiaZero,Mas Antig.,Mas Nuevo,Unis.,Costo,IVA,Costo Neto,Precio,IVA,Precio Neto\n"
            
            var itemRefrence: [String:API.custPOCV1.AuditObject] = [:]
            
            var nocodeRefrence: [API.custPOCV1.AuditObject] = []
           
            var costSubTotal: Int64 = 0
            
            var costTaxTotal: Int64 = 0
            
            var storeCostTotal: Int64 = 0
            
            var priceSubTotal: Int64 = 0
            
            var priceTaxTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            item.forEach { item in
                
                if let poc = self.pocRefrence[item.id] {
                    
                    if poc.upc.isEmpty {
                        nocodeRefrence.append(item)
                        return
                    }
                 
                    itemRefrence[poc.upc] = item
                    
                }
            }
            
            item.forEach { item in
                
                let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                
                /// CalcSubTotalResponse
                let costTax = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: itemCostTotal * 10000, 
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
                
                
                let _costSubTotal = (costTax.subTotal.doubleValue / 1000000)
                
                let _costTaxTrasladados = (costTax.trasladado.doubleValue / 1000000)
                
                let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                
                /// CalcSubTotalResponse
                let priceTax = calcSubTotal(
                    substractedTaxCalculation: true,
                    units: 100 * 10000,
                    cost: itemPriceTotal * 10000,
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
                
                let _priceSubTotal = (priceTax.subTotal.doubleValue / 1000000)
                
                let _priceTaxTrasladados = (priceTax.trasladado.doubleValue / 1000000)
                
                //let priceTaxRetenidos = (priceTax.retenido.doubleValue / 1000000).formatMoney
                
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
                
                contents += "\(poc?.upc ?? "N/D"),\((poc?.name ?? "N/D").replace(from: ",", to: "")),\(poc?.brand ?? "N/D"),\(poc?.model ?? "N/D"),\(item.zeroDay?.toString ?? "---"),\(oldestItem),\(newestItem)," +
                "\"\(item.items.count.toString)\"," +
                "\"\(_costSubTotal.formatMoney)\"," +
                "\"\(_costTaxTrasladados.formatMoney)\"," +
                "\"\(itemCostTotal.formatMoney)\"," +
                "\"\(_priceSubTotal.formatMoney)\"," +
                "\"\(_priceTaxTrasladados.formatMoney)\"," +
                "\"\(itemPriceTotal.formatMoney)\"\n"
                
                costSubTotal += _costSubTotal.toCents
                
                costTaxTotal += _costTaxTrasladados.toCents
                
                storeCostTotal += itemCostTotal
                
                
                priceSubTotal += _priceSubTotal.toCents
               
                priceTaxTotal += _priceTaxTrasladados.toCents
                
                storePriceTotal += itemPriceTotal
                
            }
            
            contents += ",,,,,,,,\"\(costSubTotal.formatMoney)\",\"\(costTaxTotal.fromCents)\",\"\(storeCostTotal.formatMoney)\",\"\(priceSubTotal.formatMoney)\",\"\(priceTaxTotal.fromCents)\",\"\(storePriceTotal.formatMoney)\"\n"
            
            return contents
            
        }
        
        func downloadByConcession (item: [API.custPOCV1.AuditObject], title: String) -> String {
            
            var contents = "\(custCatchUrl),\(title),,\n" +
            "SKU / UPC / POC, Nombre,Marca,Modelo,DiaZero,Mas Antig.,Mas Nuevo,Unis.,Costo,Precio\n"
            
            var storeUnitsTotal: Int = 0
            
            var storeCostTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            var itemRefrence: [String:API.custPOCV1.AuditObject] = [:]
            
            var nocodeRefrence: [API.custPOCV1.AuditObject] = []
            
            item.forEach { item in
                
                if let poc = self.pocRefrence[item.id] {
                    
                    if poc.upc.isEmpty {
                        nocodeRefrence.append(item)
                        return
                    }
                 
                    itemRefrence[poc.upc] = item
                    
                }
            }
            
            item.forEach { item in
                
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
                
                contents += "\(poc?.upc ?? "N/D"),\((poc?.name ?? "N/D").replace(from: ",", to: "")),\(poc?.brand ?? "N/D"),\(poc?.model ?? "N/D"),\(item.zeroDay?.toString ?? "---"),\(oldestItem),\(newestItem),\"\(item.items.count.toString)\",\"\(itemCostTotal.formatMoney)\",\"\(itemPriceTotal.formatMoney)\"\n"
                
                storeUnitsTotal += item.items.count
                
                storeCostTotal += itemCostTotal
                
                storePriceTotal += itemPriceTotal
                
            }
            
            contents += ",,,,,,,\"\(storeUnitsTotal.toString)\",\"\(storeCostTotal.formatMoney)\",\"\(storePriceTotal.formatMoney)\"\n"
        
            return contents
            
        }
        
        func renderGenral(payload: CustPOCComponents.AuditsResponse) {
            
            var active: [CustPOCQuick] = []
            
            var suspended: [CustPOCQuick] = []
            
            var byBrandSegmentation: [ String: [CustPOCQuick] ] = [:]
            
            payload.pocs.forEach { poc in
                if poc.status == .active {
                    active.append(poc)
                }
                else {
                    suspended.append(poc)
                }
            }
            
            if active.count > 0 {
                
                resultDiv.appendChild(H2{
                    Span("Productos Activos")
                    Span(active.count.toString)
                        .float(.right)
                }.color(.yellowTC))
                
                resultDiv.appendChild(Div().clear(.both).height(7.px))
                
                active.forEach { poc in
                    
                    if let _ = byBrandSegmentation[poc.tagThree] {
                        byBrandSegmentation[poc.tagThree]?.append(poc)
                    }
                    else {
                        byBrandSegmentation[poc.tagThree] = [poc]
                    }
                    
                }
                
                
                let items = byBrandSegmentation.map{ $0.key }.sorted()
                
                items.forEach { brand in
                    
                    guard let pocs = byBrandSegmentation[brand] else {
                        return
                    }
                    
                    @State var hideThisView = true
                    
                    var innerView = Div()
                        .hidden($hideThisView)
                    
                    resultDiv.appendChild(Div{
                        H2(brand.isEmpty ? "SIN CLASIFICAR" : brand )
                            .float(.left)
                        
                        Img()
                            .src($hideThisView.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                            .marginRight(12.px)
                            .class(.iconWhite)
                            .marginRight(7.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .opacity(0.5)
                            .width(18.px)
                            .onClick {
                                hideThisView = !hideThisView
                            }
                        
                        Span(pocs.count.toString)
                            .marginRight(7.px)
                            .fontSize(24.px)
                            .float(.right)
                        
                        Div().clear(.both)
                        
                    }.color(.white))
                    
                    resultDiv.appendChild(Div().clear(.both).height(7.px))
                    
                    pocs.forEach { poc in
                        
                        let view = SearchItemPOCView(
                            searchTerm: "",
                            poc: .init(
                                i: poc.id,
                                u: poc.upc,
                                n: poc.name,
                                b: poc.brand,
                                m: poc.model,
                                p: poc.pricea,
                                a: poc.avatar,
                                c: 0
                            ),
                            callback: { update, deleted in
                                
                                let view = ManagePOC(
                                    leveltype: CustProductType.all,
                                    levelid: nil,
                                    levelName: "",
                                    pocid: poc.id,
                                    titleText: "",
                                    quickView: false
                                ) {  pocid, upc, brand, model, name, cost, price, avatar in
                                    //update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                                } deleted: {
                                    //deleted()
                                }
                                
                                addToDom(view)
                                
                            })
                        
                        innerView.appendChild(view)
                        
                    }
                    
                    resultDiv.appendChild(innerView)
                    
                    resultDiv.appendChild(Div().clear(.both).height(3.px))
                    
                    resultDiv.appendChild(Div().clear(.both).borderBottom(width: .thin, style: .solid, color: .black) )
                    
                    resultDiv.appendChild(Div().clear(.both).height(12.px))
                    
                    
                }
                
                
            }
            
            if suspended.count > 0 {
                
                resultDiv.appendChild(Div().clear(.both).height(12.px))
                
                @State var hideInactiveView = true
                
                var innerView = Div()
                    .hidden($hideInactiveView)
                
                resultDiv.appendChild(Div{
                    
                    H2("Productos Suspendidos")
                        .color(.yellowTC)
                        .float(.left)
                    
                    Img()
                        .src($hideInactiveView.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                        .marginRight(12.px)
                        .class(.iconWhite)
                        .marginRight(7.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .opacity(0.5)
                        .width(18.px)
                        .onClick {
                            hideInactiveView = !hideInactiveView
                        }
                    
                    Span(suspended.count.toString)
                        .marginRight(7.px)
                        .color(.yellowTC)
                        .fontSize(24.px)
                        .float(.right)
                    
                    Div().clear(.both)
                    
                }.color(.white))
                
                resultDiv.appendChild(Div().clear(.both).height(7.px))
                
                suspended.forEach { poc in
                    let view = SearchItemPOCView(
                        searchTerm: "",
                        poc: .init(
                            i: poc.id,
                            u: poc.upc,
                            n: poc.name,
                            b: poc.brand,
                            m: poc.model,
                            p: poc.pricea,
                            a: poc.avatar,
                            c: 0
                        ),
                        callback: { update, deleted in
                            
                            let view = ManagePOC(
                                leveltype: CustProductType.all,
                                levelid: nil,
                                levelName: "",
                                pocid: poc.id,
                                titleText: "",
                                quickView: false
                            ) {  pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                                //update( name, "\(upc) \(brand) \(model)", price, avatar, reqSeries)
                            } deleted: {
                                //deleted()
                            }
                            
                            addToDom(view)
                            
                        })
                    innerView.appendChild(view)
                }
                
                resultDiv.appendChild(innerView)
                
            }
            
        }
        
        func renderByProduct(payload: CustPOCComponents.AuditsResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            var storeCostTotal: Int64 = 0
            
            var storePriceTotal: Int64 = 0
            
            /// Add store name
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
                
                H2("Cardex").color(.white)
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
                
                typealias YEAR = Int
                typealias MONTH = Int
                typealias DAY = Int
                
                var itemRefrence: [ YEAR:[ MONTH:[ DAY:[CustPOCComponents.AuditSaleObject] ]]] = [:]
                
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
        
        func renderBySales(payload: CustPOCComponents.AuditsResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
            
            /// [day:[month[year:pocid:[API.custPOCV1.AuditObject]]]]
            var itemByDateRefrence: [Int:[Int:[Int:[UUID:[API.custPOCV1.AuditSaleObject]]]]] = [:]
            
            var zeroItemRefrence: [UUID:[API.custPOCV1.AuditZeroObject]] = [:]
            
            payload.items.forEach { item in
                
                guard let storeid = item.storeid else {
                    return
                }
                
                if let _ = itemRefrence[storeid] {
                    itemRefrence[storeid]?.append(item)
                }
                else {
                    itemRefrence[storeid] = [item]
                }
                
                item.items.forEach { iitem in
                    
                    guard var soldAt = iitem.soldAt else {
                        return
                    }
                    
                    soldAt -= (60 * 60 * 6)
                    
                    let date = getDate(soldAt)
                    
                    if let _ = itemByDateRefrence[date.year] {
                        
                        if let _ = itemByDateRefrence[date.year]?[date.month] {
                            
                            if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day] {
                            
                                if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id]?.append(iitem)
                                }
                                else {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] = [iitem]
                                }
                            }
                            else {
                                itemByDateRefrence[date.year]?[date.month]?[date.day] = [
                                    item.id: [iitem]
                                ]
                            }
                        }
                        else {
                            
                            itemByDateRefrence[date.year]?[date.month] = [
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                            
                        }
                    }
                    else {
                        itemByDateRefrence[date.year] = [
                            date.month:[
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                        ]
                    }
                }
            }
            
            payload.zeroItems.forEach { item in
                
                guard let storeid = item.storeid else {
                    return
                }
                
                if let _ = zeroItemRefrence[storeid] {
                    zeroItemRefrence[storeid]?.append(item)
                }
                else {
                    zeroItemRefrence[storeid] = [item]
                }
                
            }
            
            payload.pocs.forEach { poc in
                self.pocRefrence[poc.id] = poc
            }
            
            if !itemByDateRefrence.isEmpty {
                
                @State var sectionAIsHidden = true
                
                self.resultDiv.appendChild(Div{
                    H1("📉 Ventas por dia").color(.yellowTC)
                        .float(.left)
                    
                    Img()
                        .src($sectionAIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                        .marginRight(24.px)
                        .class(.iconWhite)
                        .paddingTop(7.px)
                        .float(.right)
                        .opacity(0.5)
                        .width(36.px)
                        .onClick {
                            sectionAIsHidden = !sectionAIsHidden
                        }
                    
                    Img()
                        .src("/skyline/media/download2.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))).csv",
                                item: payload.items,
                                type: .bySales,
                                title: "Venta por Día \(getDate(startAtUTS).formatedLong) - \(getDate(endAtUTS).formatedLong)"
                            )
                        }
                    
                    Div().clear(.both)
                    
                })
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                var table = Table {
                    THead{
                        Tr{
                            Td("Date")
                            Td("POC/SKU/UPC")
                            Td("Nombre")
                            Td("Marca")
                            Td("Modelo")
                            Td("Unis.")
                            Td("Precio")
                        }
                    }
                }
                .marginBottom(24.px)
                .width(100.percent)
                .color(.white)
                
                var tableBody = TBody().hidden($sectionAIsHidden)
                
                let yearKeys = itemByDateRefrence.map{ $0.key }.sorted()
                
                var totalUnits  = 0
                
                var totalValue: Int64 = 0
                
                yearKeys.forEach { year in
                    
                    if let yearPayload = itemByDateRefrence[year] {
                        
                        let monthKeys = yearPayload.map{ $0.key }.sorted()
                        
                        monthKeys.forEach { month in
                            
                            if let monthPayload = yearPayload[month] {
                                
                                let dayKeys = monthPayload.map{$0.key }.sorted()
                                
                                dayKeys.forEach { day in
                                    
                                    if let dayPayload = monthPayload[day] {
                                        
                                        
                                        dayPayload.forEach { pocId, items in
                                            
                                            guard let poc = self.pocRefrence[pocId] else {
                                                return
                                            }
                                            
                                            totalUnits += items.count
                                            
                                            totalValue += items.map{ $0.price }.reduce(0, +)
                                            
                                            tableBody.appendChild(
                                                Tr{
                                                    Td("\(day)/\(month)/\(year)")
                                                    Td(poc.upc)
                                                    Td(poc.name)
                                                    Td(poc.brand)
                                                    Td(poc.model)
                                                    Td(items.count.toString)
                                                    Td(items.map{ $0.price }.reduce(0, +).formatMoney)
                                                }
                                            )
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                table.appendChild(tableBody)
                
                table.appendChild(TBody{
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td(totalUnits.toString)
                    Td(totalValue.formatMoney)
                })
                
                self.resultDiv.appendChild(table)
            }
            
            if !itemRefrence.isEmpty {
                
                var grandCostTotal: Int64 = 0
                
                var grandPriceTotal: Int64 = 0
                
                self.resultDiv.appendChild(H1("📈 Ventas por producto").color(.yellowTC))
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                itemRefrence.forEach { storeid, items in
                    
                    var storeCostTotal: Int64 = 0
                    
                    var storePriceTotal: Int64 = 0
                    
                    let store = stores[storeid]
                    
                    @State var sectionBIsHidden = true
                    
                    var tableBody = TBody().hidden($sectionBIsHidden)
                    
                    var conterRow = true
                    
                    /// [ POC.id : Units ]
                    var countRefrence: [UUID:Int] = [:]
                    
                    /// [ POC.id : API.custPOCV1.AuditObject ]
                    var itemRefrence: [UUID:API.custPOCV1.AuditObject] = [:]
                    
                    items.forEach { item in
                        countRefrence[item.id] = item.items.count
                        itemRefrence[item.id] = item
                    }
                    
                    let sortedItemRefrence = countRefrence.sorted {
                        return $0.value > $1.value
                    }
                    
                    var itemsSorted: [API.custPOCV1.AuditObject] = []
                    
                    sortedItemRefrence.forEach { id, _ in
                        if let item = itemRefrence[id] {
                            itemsSorted.append(item)
                        }
                    }
                    
                    
                    /// Add store name
                    self.resultDiv.appendChild(Div{
                        H1(store?.name ?? "")
                            .color(.yellowTC)
                            .float(.left)
                        
                        Img()
                            .src($sectionBIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                            .marginRight(24.px)
                            .class(.iconWhite)
                            .paddingTop(7.px)
                            .float(.right)
                            .opacity(0.5)
                            .width(36.px)
                            .onClick {
                                sectionBIsHidden = !sectionBIsHidden
                            }
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-")).csv",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    var table = Table {
                        THead {
                            Tr{
                                Td("POC/SKU/UPC")
                                Td("Nombre")
                                Td("Marca")
                                Td("Modelo")
                                Td("DiaZero")
                                Td("Actual")
                                Td("Vendido")
                                Td("Costo")
                                Td("Precio")
                                Td("Ver")
                            }
                        }
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                    
                    itemsSorted.forEach { item in
                        
                        let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                        
                        let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                        
                        let poc = self.pocRefrence[item.id]
                        
                        tableBody.appendChild(Tr{
                            Td(poc?.upc ?? "N/D")
                            Td(poc?.name ?? "N/D")
                            Td(poc?.brand ?? "N/D")
                            Td(poc?.model ?? "N/D")
                            Td(item.zeroDay?.toString ?? "---")
                            Td((item.currentStock ?? 0).toString)
                            Td(item.items.count.toString)
                            Td(itemCostTotal.formatMoney)
                            Td(itemPriceTotal.formatMoney)
                            Td{
                                Img()
                                    .src("/skyline/media/viewPassword.png")
                                    .class(.iconWhite)
                                    .cursor(.pointer)
                                    .width(23.px)
                                    .onClick {
                                        
                                        
                                    }
                            }
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                        
                        storeCostTotal += itemCostTotal
                        
                        storePriceTotal += itemPriceTotal
                        
                        conterRow = !conterRow
                    }
                    
                    table.appendChild(tableBody)
                    
                    conterRow = !conterRow
                    
                    table.appendChild(TBody{
                        Tr{
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
                            Td("")
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }())
                    })
                    
                    grandCostTotal += storeCostTotal
                    
                    grandPriceTotal += storePriceTotal
                    
                    self.resultDiv.appendChild(table)
                    
                }
                
            }
            
            if !zeroItemRefrence.isEmpty {
                
                self.resultDiv.appendChild(H1("⚠️ Sin Inventario").color(.yellowTC))
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                zeroItemRefrence.forEach { storeid, items in
                    
                    let store = stores[storeid]
                    
                    /// Add store name
                    
                    @State var sectionIsHidden = true
                    
                    /// Add store name
                    self.resultDiv.appendChild(Div{
                        H1(store?.name ?? "").color(.yellowTC)
                            .float(.left)
                        
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
                    })
                    
                    
                    var table = Table {
                        Tr{
                            Td("POC/SKU/UPC")
                            Td("Nombre")
                            Td("Marca")
                            Td("Modelo")
                        }
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                    .hidden($sectionIsHidden)
                    
                    var conterRow = true
                    
                    items.forEach { item in
                        
                        let poc = self.pocRefrence[item.id]
                        
                        table.appendChild(Tr{
                            Td(poc?.upc ?? "N/D")
                            Td(poc?.name ?? "N/D")
                            Td(poc?.brand ?? "N/v")
                            Td(poc?.model ?? "N/D")
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                        
                        conterRow = !conterRow
                        
                    }
                    
                    self.resultDiv.appendChild(table)
                    
                }
            }
            
        }
        
        func renderBySalesConcession(payload: CustPOCComponents.AuditsResponse, startAtUTS: Int64, endAtUTS: Int64) {
            
            self.accountRefrecnce = Dictionary(uniqueKeysWithValues: payload.accounts.map{ value in (value.id, value) })
            
            var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
            
            var subItemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
            
            /// [day:[month[year:pocid:[API.custPOCV1.AuditObject]]]]
            var itemByDateRefrence: [Int:[Int:[Int:[UUID:[API.custPOCV1.AuditSaleObject]]]]] = [:]
            
            var zeroItemRefrence: [UUID:[API.custPOCV1.AuditZeroObject]] = [:]
            
            payload.items.forEach { item in
                
                guard let storeid = item.storeid else {
                    return
                }
                
                if let _ = itemRefrence[storeid] {
                    itemRefrence[storeid]?.append(item)
                }
                else {
                    itemRefrence[storeid] = [item]
                }
                
                item.items.forEach { iitem in
                    
                    guard var soldAt = iitem.soldAt else {
                        return
                    }
                    
                    soldAt -= (60 * 60 * 6)
                    
                    let date = getDate(soldAt)
                    
                    if let _ = itemByDateRefrence[date.year] {
                        
                        if let _ = itemByDateRefrence[date.year]?[date.month] {
                            
                            if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day] {
                            
                                if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id]?.append(iitem)
                                }
                                else {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] = [iitem]
                                }
                            }
                            else {
                                itemByDateRefrence[date.year]?[date.month]?[date.day] = [
                                    item.id: [iitem]
                                ]
                            }
                        }
                        else {
                            
                            itemByDateRefrence[date.year]?[date.month] = [
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                            
                        }
                    }
                    else {
                        itemByDateRefrence[date.year] = [
                            date.month:[
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                        ]
                    }
                }
            }
            
            payload.subItems.forEach { item in
                
                guard let accountId = item.accountId else {
                    return
                }
                
                if let _ = subItemRefrence[accountId] {
                    subItemRefrence[accountId]?.append(item)
                }
                else {
                    subItemRefrence[accountId] = [item]
                }
                
                item.items.forEach { iitem in
                    
                    guard var soldAt = iitem.soldAt else {
                        return
                    }
                    
                    soldAt -= (60 * 60 * 6)
                    
                    let date = getDate(soldAt)
                    
                    if let _ = itemByDateRefrence[date.year] {
                        
                        if let _ = itemByDateRefrence[date.year]?[date.month] {
                            
                            if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day] {
                            
                                if let _ = itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id]?.append(iitem)
                                }
                                else {
                                    itemByDateRefrence[date.year]?[date.month]?[date.day]?[item.id] = [iitem]
                                }
                            }
                            else {
                                itemByDateRefrence[date.year]?[date.month]?[date.day] = [
                                    item.id: [iitem]
                                ]
                            }
                        }
                        else {
                            
                            itemByDateRefrence[date.year]?[date.month] = [
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                            
                        }
                    }
                    else {
                        itemByDateRefrence[date.year] = [
                            date.month:[
                                date.day: [
                                    item.id: [iitem]
                                ]
                            ]
                        ]
                    }
                }
            
            }
            
            payload.zeroItems.forEach { item in
                
                guard let storeid = item.storeid else {
                    return
                }
                
                if let _ = zeroItemRefrence[storeid] {
                    zeroItemRefrence[storeid]?.append(item)
                }
                else {
                    zeroItemRefrence[storeid] = [item]
                }
                
            }
            
            payload.pocs.forEach { poc in
                self.pocRefrence[poc.id] = poc
            }
            
            if !itemByDateRefrence.isEmpty {
                
                @State var sectionAIsHidden = true
                
                self.resultDiv.appendChild(Div{
                    H1("📉 Ventas por dia").color(.yellowTC)
                        .float(.left)
                    
                    Img()
                        .src($sectionAIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                        .marginRight(24.px)
                        .class(.iconWhite)
                        .paddingTop(7.px)
                        .float(.right)
                        .opacity(0.5)
                        .width(36.px)
                        .onClick {
                            sectionAIsHidden = !sectionAIsHidden
                        }
                    
                    Img()
                        .src("/skyline/media/download2.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))).csv",
                                item: payload.items,
                                type: .bySales,
                                title: "Venta por Día \(getDate(startAtUTS).formatedLong) - \(getDate(endAtUTS).formatedLong)"
                            )
                        }
                    
                    Div().clear(.both)
                    
                })
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                var table = Table {
                    THead{
                        Tr{
                            Td("Date")
                            Td("POC/SKU/UPC")
                            Td("Nombre")
                            Td("Marca")
                            Td("Modelo")
                            Td("Unis.")
                            Td("Precio")
                        }
                    }
                }
                .marginBottom(24.px)
                .width(100.percent)
                .color(.white)
                
                var tableBody = TBody().hidden($sectionAIsHidden)
                
                let yearKeys = itemByDateRefrence.map{ $0.key }.sorted()
                
                var totalUnits  = 0
                
                var totalValue: Int64 = 0
                
                yearKeys.forEach { year in
                    
                    if let yearPayload = itemByDateRefrence[year] {
                        
                        let monthKeys = yearPayload.map{ $0.key }.sorted()
                        
                        monthKeys.forEach { month in
                            
                            if let monthPayload = yearPayload[month] {
                                
                                let dayKeys = monthPayload.map{$0.key }.sorted()
                                
                                dayKeys.forEach { day in
                                    
                                    if let dayPayload = monthPayload[day] {
                                        
                                        
                                        dayPayload.forEach { pocId, items in
                                            
                                            guard let poc = self.pocRefrence[pocId] else {
                                                return
                                            }
                                            
                                            totalUnits += items.count
                                            
                                            totalValue += items.map{ $0.price }.reduce(0, +)
                                            
                                            tableBody.appendChild(
                                                Tr{
                                                    Td("\(day)/\(month)/\(year)")
                                                    Td(poc.upc)
                                                    Td(poc.name)
                                                    Td(poc.brand)
                                                    Td(poc.model)
                                                    Td(items.count.toString)
                                                    Td(items.map{ $0.price }.reduce(0, +).formatMoney)
                                                }
                                            )
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                table.appendChild(tableBody)
                
                table.appendChild(TBody{
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td("")
                    Td(totalUnits.toString)
                    Td(totalValue.formatMoney)
                })
                
                self.resultDiv.appendChild(table)
            }
            
            if !itemRefrence.isEmpty {
                
                var grandCostTotal: Int64 = 0
                
                var grandPriceTotal: Int64 = 0
                
                self.resultDiv.appendChild(H1("📈 Ventas por producto").color(.yellowTC))
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                itemRefrence.forEach { storeid, items in
                    
                    var storeCostTotal: Int64 = 0
                    
                    var storePriceTotal: Int64 = 0
                    
                    let store = stores[storeid]
                    
                    @State var sectionBIsHidden = true
                    
                    var tableBody = TBody().hidden($sectionBIsHidden)
                    
                    var conterRow = true
                    
                    /// [ POC.id : Units ]
                    var countRefrence: [UUID:Int] = [:]
                    
                    /// [ POC.id : API.custPOCV1.AuditObject ]
                    var itemRefrence: [UUID:API.custPOCV1.AuditObject] = [:]
                    
                    items.forEach { item in
                        countRefrence[item.id] = item.items.count
                        itemRefrence[item.id] = item
                    }
                    
                    let sortedItemRefrence = countRefrence.sorted {
                        return $0.value > $1.value
                    }
                    
                    var itemsSorted: [API.custPOCV1.AuditObject] = []
                    
                    sortedItemRefrence.forEach { id, _ in
                        if let item = itemRefrence[id] {
                            itemsSorted.append(item)
                        }
                    }
                    
                    
                    /// Add store name
                    self.resultDiv.appendChild(Div{
                        H1(store?.name ?? "")
                            .color(.yellowTC)
                            .float(.left)
                        
                        Img()
                            .src($sectionBIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                            .marginRight(24.px)
                            .class(.iconWhite)
                            .paddingTop(7.px)
                            .float(.right)
                            .opacity(0.5)
                            .width(36.px)
                            .onClick {
                                sectionBIsHidden = !sectionBIsHidden
                            }
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-")).csv",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    var table = Table {
                        THead {
                            Tr{
                                Td("POC/SKU/UPC")
                                Td("Nombre")
                                Td("Marca")
                                Td("Modelo")
                                Td("DiaZero")
                                Td("Actual")
                                Td("Vendido")
                                Td("Costo")
                                Td("Precio")
                                Td("Ver")
                            }
                        }
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                    
                    itemsSorted.forEach { item in
                        
                        let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                        
                        let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                        
                        let poc = self.pocRefrence[item.id]
                        
                        tableBody.appendChild(Tr{
                            Td(poc?.upc ?? "N/D")
                            Td(poc?.name ?? "N/D")
                            Td(poc?.brand ?? "N/D")
                            Td(poc?.model ?? "N/D")
                            Td(item.zeroDay?.toString ?? "---")
                            Td((item.currentStock ?? 0).toString)
                            Td(item.items.count.toString)
                            Td(itemCostTotal.formatMoney)
                            Td(itemPriceTotal.formatMoney)
                            Td{
                                Img()
                                    .src("/skyline/media/viewPassword.png")
                                    .class(.iconWhite)
                                    .cursor(.pointer)
                                    .width(23.px)
                                    .onClick {
                                        
                                    }
                            }
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                        
                        storeCostTotal += itemCostTotal
                        
                        storePriceTotal += itemPriceTotal
                        
                        conterRow = !conterRow
                    }
                    
                    table.appendChild(tableBody)
                    
                    conterRow = !conterRow
                    
                    table.appendChild(TBody{
                        Tr{
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
                            Td("")
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }())
                    })
                    
                    grandCostTotal += storeCostTotal
                    
                    grandPriceTotal += storePriceTotal
                    
                    self.resultDiv.appendChild(table)
                    
                }
                
            }
            
            if !subItemRefrence.isEmpty {
                
                var grandCostTotal: Int64 = 0
                
                var grandPriceTotal: Int64 = 0
                
                self.resultDiv.appendChild(H1("📈 Ventas por Concesionario").color(.yellowTC))
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                Console.clear()
                
                subItemRefrence.forEach { accountId, items in
                    
                    var storeCostTotal: Int64 = 0
                    
                    var storePriceTotal: Int64 = 0
                    
                    print("accountId \(accountId.uuidString)")
                    
                    guard let account = self.accountRefrecnce[accountId] else {
                        
                        print("")
                        
                        return
                    }
                    
                    @State var sectionBIsHidden = true
                    
                    var tableBody = TBody().hidden($sectionBIsHidden)
                    
                    var conterRow = true
                    
                    /// [ POC.id : Units ]
                    var countRefrence: [UUID:Int] = [:]
                    
                    /// [ POC.id : API.custPOCV1.AuditObject ]
                    var itemRefrence: [UUID:API.custPOCV1.AuditObject] = [:]
                    
                    items.forEach { item in
                        countRefrence[item.id] = item.items.count
                        itemRefrence[item.id] = item
                    }
                    
                    let sortedItemRefrence = countRefrence.sorted {
                        return $0.value > $1.value
                    }
                    
                    var itemsSorted: [API.custPOCV1.AuditObject] = []
                    
                    sortedItemRefrence.forEach { id, _ in
                        if let item = itemRefrence[id] {
                            itemsSorted.append(item)
                        }
                    }
                                        
                    /// Add store name
                    self.resultDiv.appendChild(Div{
                        H1("\(account.businessName) \(account.firstName) \(account.lastName)").color(.yellowTC)
                            .color(.yellowTC)
                            .float(.left)
                        
                        Img()
                            .src($sectionBIsHidden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                            .marginRight(24.px)
                            .class(.iconWhite)
                            .paddingTop(7.px)
                            .float(.right)
                            .opacity(0.5)
                            .width(36.px)
                            .onClick {
                                sectionBIsHidden = !sectionBIsHidden
                            }
                        
                        Img()
                            .src("/skyline/media/download2.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    
                                    name: "inventario_existente_\( ("\(account.businessName) \(account.firstName) \(account.lastName)").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-")).csv",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( ("\(account.businessName) \(account.firstName) \(account.lastName)"))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    var table = Table {
                        THead {
                            Tr{
                                Td("POC/SKU/UPC")
                                Td("Nombre")
                                Td("Marca")
                                Td("Modelo")
                                Td("DiaZero")
                                Td("Actual")
                                Td("Vendido")
                                Td("Costo")
                                Td("Precio")
                                Td("Ver")
                            }
                        }
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                    
                    itemsSorted.forEach { item in
                        
                        let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                        
                        let itemPriceTotal: Int64 = item.items.map{ $0.price }.reduce(0, +)
                        
                        let poc = self.pocRefrence[item.id]
                        
                        tableBody.appendChild(Tr{
                            Td(poc?.upc ?? "N/D")
                            Td(poc?.name ?? "N/D")
                            Td(poc?.brand ?? "N/D")
                            Td(poc?.model ?? "N/D")
                            Td(item.zeroDay?.toString ?? "---")
                            Td((item.currentStock ?? 0).toString)
                            Td(item.items.count.toString)
                            Td(itemCostTotal.formatMoney)
                            Td(itemPriceTotal.formatMoney)
                            Td{
                                Img()
                                    .src("/skyline/media/viewPassword.png")
                                    .class(.iconWhite)
                                    .cursor(.pointer)
                                    .width(23.px)
                                    .onClick {
                                        
                                        guard let poc else {
                                            return
                                        }
                                        
                                    }
                            }
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                        
                        storeCostTotal += itemCostTotal
                        
                        storePriceTotal += itemPriceTotal
                        
                        conterRow = !conterRow
                    }
                    
                    table.appendChild(tableBody)
                    
                    conterRow = !conterRow
                    
                    table.appendChild(TBody{
                        Tr{
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
                            Td("")
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }())
                    })
                    
                    grandCostTotal += storeCostTotal
                    
                    grandPriceTotal += storePriceTotal
                    
                    self.resultDiv.appendChild(table)
                    
                }
                
                
            }
            
            if !zeroItemRefrence.isEmpty {
                
                self.resultDiv.appendChild(H1("⚠️ Sin Inventario").color(.yellowTC))
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                zeroItemRefrence.forEach { storeid, items in
                    
                    let store = stores[storeid]
                    
                    /// Add store name
                    
                    @State var sectionIsHidden = true
                    
                    /// Add store name
                    self.resultDiv.appendChild(Div{
                        H1(store?.name ?? "").color(.yellowTC)
                            .float(.left)
                        
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
                    })
                    
                    
                    let table = Table {
                        Tr{
                            Td("POC/SKU/UPC")
                            Td("Nombre")
                            Td("Marca")
                            Td("Modelo")
                        }
                    }
                    .marginBottom(24.px)
                    .width(100.percent)
                    .color(.white)
                    .hidden($sectionIsHidden)
                    
                    var conterRow = true
                    
                    items.forEach { item in
                        
                        let poc = self.pocRefrence[item.id]
                        
                        table.appendChild(Tr{
                            Td(poc?.upc ?? "N/D")
                            Td(poc?.name ?? "N/D")
                            Td(poc?.brand ?? "N/v")
                            Td(poc?.model ?? "N/D")
                        }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                        
                        conterRow = !conterRow
                        
                    }
                    
                    self.resultDiv.appendChild(table)
                    
                }
            }
            
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
        */
    }
