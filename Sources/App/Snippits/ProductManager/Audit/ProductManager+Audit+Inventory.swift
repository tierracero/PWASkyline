//
//  ProductManager+Audit+Inventory.swift
//  
//
//  Created by Victor Cantu on 7/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class Inventory: Div {
        
        override class var name: String { "div" }
        
        var auditType: AuditType
        
        init(
            auditType: AuditType
        ) {
            self.auditType = auditType
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// Cust Acct
        var accountId: UUID? = nil
        
        var accountRefrecnce:[UUID:CustAcctQuick] = [:]
        
        var pocRefrence: [UUID:CustPOCQuick] = [:]
        
        @State var reportType: InventoryAuditTypes? = nil
        
        /// InventoryAuditTypes
        @State var auditTypeListener = ""
        
        /// InventoryAuditTypes
        lazy var auditTypeSelect = Select(self.$auditTypeListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(42.px)
        
        @State var storeSelectListener = ""
        
        lazy var storeSelect = Select(self.$storeSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(42.px)
        
        @State var userSelectListener = ""
        
        lazy var usertSelect = Select(self.$userSelectListener)
            .body{
                Option("Seleccione Usuario")
                    .value("")
            }
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(42.px)
        
        @State var departmentSelectListener = ""
        
        lazy var departmentSelect = Select(self.$departmentSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(42.px)
        
        @State var dateSelectListener = ""
        
        lazy var dateSelect = Select(self.$dateSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(42.px)
        
        @State var startAt = ""
        
        lazy var startAtField = InputText(self.$startAt)
            .class(.textFiledBlackDark)
            .placeholder("DD/MM/AAAA")
            .fontSize(22.px)
            .width(130.px)
            .height(42.px)
        
        @State var endAt = ""
        
        lazy var endAtField = InputText(self.$endAt)
            .class(.textFiledBlackDark)
            .placeholder("DD/MM/AAAA")
            .fontSize(22.px)
            .width(130.px)
            .height(42.px)
        
        @State var startAtLabel = ""
        
        @State var endAtLabel = ""

        private let resultElementId = "resultDiv_\(callKey(7))"
        
        lazy var resultDiv = Div {
            Table().noResult(label: "📈 Seleccione una tienda para iniciar")
        }
        .id(.init(resultElementId))
        .class(Class(TCCrystalSurfaceClass.auditResults))
        // Keep the dynamic report inside one predictable scrolling viewport.
        .custom("height", "calc(100% - 130px)")
        .custom("overflow", "auto !important")
        .custom("position", "relative")
        .custom("box-sizing", "border-box")
        .custom("min-height", "0")

        lazy var reportActions = ReportActions(resultElementId: resultElementId)

        private var inventoryRenderId = UUID()

        private var cardexGraphRequestId = UUID()
        
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
            addToDom(ProductSearch(
                parsablePOCs: self.$parsablePOCs
            ){
                
            })
        }
        
        @DOM override var body: DOM.Content {
            
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
                .hidden({
                    switch self.auditType{
                    case .general:
                        return false
                    case .concessionaire:
                        return true
                    }
                }())
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
                
                /// Seleccione Departament
                Div{
                    Label("Seleccione Departament")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.departmentSelect
                }
                .hidden(self.$reportType.map{ !($0?.departmentable == true) })
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                /// Seleccione Usuario
                Div{
                    Label("Seleccione Usuario")
                        .fontSize(12.px)
                        .color(.gray)
                    Div().clear(.both)
                    self.usertSelect
                }
                .hidden(self.$reportType.map{ !($0?.userable == true) })
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
                .hidden(self.$reportType.map{ !($0?.productidable == true) })
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
                .hidden(self.$reportType.map{ !($0?.dateRangable == true) })
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
                .hidden(self.$reportType.map{ !($0?.dateRangable == true) })
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
                .hidden(self.$reportType.map{ !($0?.dateRangable == true) })
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

                Div()
                .width(100.percent)
                .height(3.px)
                .clear(.both)
                
                Div(self.$reportType.map{ $0?.helpText ??  "" })
                    .paddingBottom(7.px)
                    .marginLeft(12.px)
                    .fontSize(12.px)
                    .marginTop(3.px)
                    .height(15.px)
                    .color(.white)
                    
            }
            .class(Class(TCCrystalSurfaceClass.auditToolbar))
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .height(85.px)

            Div()
            .width(100.percent)
            .height(3.px)
            .clear(.both)

            /// Results View
            self.resultDiv

        }
        
        override func buildUI() {
            
            height(100.percent)
            // display(.grid)
            custom("grid-template-rows", "85px 3px minmax(0, 1fr)")
            custom("min-height", "0")
            custom("box-sizing", "border-box")
            custom("overflow", "hidden")
            
            auditTypeSelect.appendChild(
                Option("Seleccione")
                    .value("")
            )
            
            InventoryAuditTypes.allCases.forEach { type in
                auditTypeSelect.appendChild(
                    Option(type.description)
                        .value(type.rawValue)
                )
            }
            
            storeSelect.appendChild(
                Option("Todas las Tiendas")
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
                
                self.reportType = InventoryAuditTypes(rawValue: $0)
                
                guard let reportType = self.reportType else {
                    return
                }
                
                switch reportType {
                case .general:
                    break
                case .lowInvetory:
                    self.departmentSelectListener = "**"
                case .byDepartement:
                    self.departmentSelectListener = ""
                case .byProduct:
                    self.parsablePOCs.removeAll()
                case .byStore:
                    self.storeSelectListener = ""
                case .bySales:
                    self.storeSelectListener = ""
                case .bySalesConcession:
                    self.storeSelectListener = ""
                case .byCustomerSales:
                    break
                case .byUserSales:
                    self.userSelectListener = ""
                case .byConcession:
                    break
                case .fastAndFurios:
                    self.storeSelectListener = ""
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
            
            loadingView.show()
            
            API.v1.storeDeps(curObjs: []) { resp in
                
                loadingView.hide()
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                self.departmentSelect.appendChild(
                    Option("Seleccione Departamento")
                        .hidden(self.$reportType.map{ $0 != .byDepartement })
                        .value("")
                )
                
                self.departmentSelect.appendChild(
                    Option("Todos los Departamentos")
                        .hidden(self.$reportType.map{ $0 == .byDepartement })
                        .value("**")
                )
                
                resp.data?.deps.forEach { dep in
                    self.departmentSelect.appendChild(
                        Option(dep.name)
                            .value(dep.id.uuidString)
                    )
                }
                
            }
            
            getUsers(storeid: nil, onlyActive: true) { users in
                users.forEach { user in
                    
                    var uname = user.username.explode("@").first
                    
                    if let _uname = uname {
                        uname = "@\(_uname)"
                    }
                    else {
                        uname = user.username
                    }
                    
                    guard let uname else {
                        return
                    }
                    
                    self.usertSelect.appendChild(Option(uname).value(user.id.uuidString))
                }
            }
            
            switch auditType {
            case .general:
                break
            case .concessionaire(let account):
                auditTypeListener = InventoryAuditTypes.byProduct.rawValue
                self.accountId = account.id
            }
            
        }
        
        func requestReport(){
            
            guard let type = InventoryAuditTypes(rawValue: auditTypeListener) else {
                showError(.requiredField, "Ingrese tipo de reporte")
                return
            }
            
            let storeid: UUID? = UUID(uuidString: storeSelectListener)
            
            let depid: UUID? = UUID(uuidString: departmentSelectListener)
            
            let userId: UUID? = UUID(uuidString: userSelectListener)
            
            var startAtUTS: Int64? = nil
            
            var endAtUTS: Int64? = nil
            
            let ids = parsablePOCs.map{ $0.id }
            
            if type.dateRangable {
                
                if let range = DateRangeSelection(rawValue: dateSelectListener)?.range  {
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
                
            }
            
            let renderId = UUID()
            inventoryRenderId = renderId
            reportActions.reset()

            let eventId: UUID = .init()

            loadingView.show(eventId)

            if type == .fastAndFurios {
                guard let startAtUTS, let endAtUTS else {
                    loadingView.hide()
                    showError(.requiredField, "Ingrese el periodo del reporte")
                    return
                }

                API.custPOCV1.auditsVT(
                    type: type,
                    storeid: storeid,
                    from: startAtUTS,
                    to: endAtUTS,
                    eventId: eventId
                ) { resp in
                    guard renderId == self.inventoryRenderId else {
                        return
                    }

                    loadingView.hide()

                    guard let resp else {
                        showError(.comunicationError, .serverConextionError)
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }

                    guard let payload = resp.data else {
                        showError(.generalError, resp.msg)
                        return
                    }

                    self.resultDiv.innerHTML = ""

                    self.reportActions.present(
                        title: "Reporte de \(type.description)",
                        fileName: "inventario-\(type.rawValue)-\(getNow())",
                        aiResponse: resp.airesponse,
                        in: self.resultDiv
                    )

                    self.renderFastAndFurios(payload: payload)
                }

                return
            }
            
            API.custPOCV1.audits(
                type: type,
                storeid: storeid,
                userId: userId,
                depid: depid,
                accountId: accountId,
                from: startAtUTS,
                to: endAtUTS,
                ids: ids,
                eventId: eventId
            ) { resp in
                guard renderId == self.inventoryRenderId else {
                    return
                }
                
                loadingView.hide()
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.resultDiv.innerHTML = ""

                self.reportActions.present(
                    title: "Reporte de \(type.description)",
                    fileName: "inventario-\(type.rawValue)-\(getNow())",
                    aiResponse: resp.airesponse,
                    in: self.resultDiv
                )
                
                self.pocRefrence = Dictionary(uniqueKeysWithValues: payload.pocs.map{ poc in (poc.id, poc) })

                switch type {
                case .general, .lowInvetory, .fastAndFurios:
                    break
                case .byStore, .byDepartement, .byProduct, .bySales,
                     .bySalesConcession, .byCustomerSales, .byUserSales, .byConcession:
                    self.renderInventoryReportIntroduction(
                        type: type,
                        payload: payload,
                        requestedStartAt: startAtUTS,
                        requestedEndAt: endAtUTS
                    )
                }
                
                switch type {
                case .general:
                    
                    self.renderGenral(
                        payload: payload,
                        renderId: renderId
                    )
                    
                case .lowInvetory:
                    self.renderLowInventory(
                        payload: payload,
                        renderId: renderId
                    )
                case .byDepartement:
                    break
                case .byProduct:
                    
                    self.renderByProduct(
                        payload: payload,
                        startAtUTS: startAtUTS ?? 0,
                        endAtUTS: endAtUTS ?? 0
                    )
                    
                case .byStore:
                    
                    var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
                    
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
                    
                    if !itemRefrence.isEmpty {
                        
                        var grandCostTotal: Int64 = 0
                        
                        var grandPriceTotal: Int64 = 0
                        
                        self.resultDiv.appendChild(H1("📈 Inventario Existente")
                            .color(.yellowTC))
                        
                        itemRefrence.forEach { storeid, items in
                            
                            var catchItems: [API.custPOCV1.AuditObject] = []
                            
                            @State var sectionIsHidden = false
                            
                            var storeCostTotal: Int64 = 0
                            
                            var storePriceTotal: Int64 = 0
                            
                            let store = stores[storeid]
                            
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
                                
                                Img()
                                    .src("/skyline/media/excel.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .csv,
                                            name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv",
                                            item: catchItems,
                                            type: type,
                                            title: "Inventario por Tienda - \(store?.name ?? "")"
                                        )
                                    }
                                
                                Img()
                                    .src("/skyline/media/pdf.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .pdf,
                                            name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv",
                                            item: catchItems,
                                            type: type,
                                            title: "Inventario por Tienda - \(store?.name ?? "")"
                                        )
                                    }
                                
                                Div().clear(.both)
                                
                            })
                            
                            let tableBody = TBody()
                                .hidden($sectionIsHidden)
                            
                            let table = Table {
                                THead{
                                    ProductManagerView.AuditView.productManagerHeaderCell()
                                    Td("POC/SKU/UPC")
                                    Td("Nombre")
                                    Td("Marca")
                                    Td("Modelo")
                                    Td("DiaZero")
                                    Td("Mas Antig.")
                                    Td("Mas Nuevo")
                                    Td("Unis.")
                                    Td("Costo")
                                    Td("Precio")
                                }
                                tableBody
                            }
                                .marginBottom(24.px)
                                .width(100.percent)
                                .color(.white)
                            
                            var conterRow = true
                            
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
                                
                                tableBody.appendChild(Tr{
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/D")
                                    Td(poc?.model ?? "N/D")
                                    Td(item.zeroDay?.toString ?? "---")
                                    Td(oldestItem)
                                    Td(newestItem)
                                    Td(item.items.count.toString)
                                    Td(itemCostTotal.formatMoney)
                                    Td(itemPriceTotal.formatMoney)
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                storeCostTotal += itemCostTotal
                                
                                storePriceTotal += itemPriceTotal
                                
                                conterRow = !conterRow
                            }
                            
                            conterRow = !conterRow
                            
                            table.appendChild(TFoot{
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
                                    Td(storeCostTotal.formatMoney)
                                        .color(.yellowTC)
                                    Td(storePriceTotal.formatMoney)
                                        .color(.yellowTC)
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }())
                            })
                            
                            grandCostTotal += storeCostTotal
                            
                            grandPriceTotal += storePriceTotal
                            
                            self.resultDiv.appendChild(table)
                            
                        }
                        
                    }
                    
                    if !zeroItemRefrence.isEmpty {
                        
                        @State var thisViewIsHidden = true
                        
                        self.resultDiv.appendChild(H1("⚠️ Sin Inventario").color(.yellowTC))
                        
                        zeroItemRefrence.forEach { storeid, items in
                            
                            let store = stores[storeid]
                            
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
                                    ProductManagerView.AuditView.productManagerHeaderCell()
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
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/v")
                                    Td(poc?.model ?? "N/D")
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                conterRow = !conterRow
                                
                            }
                            
                            self.resultDiv.appendChild(table)
                        }
                    }
                    
                case .bySales:
                    
                    self.renderBySales(
                        payload: payload,
                        startAtUTS: startAtUTS ?? 0,
                        endAtUTS: endAtUTS ?? 0
                    )
                    
                case .bySalesConcession:
                    
                    self.renderBySalesConcession(
                        payload: payload,
                        startAtUTS: startAtUTS ?? 0,
                        endAtUTS: endAtUTS ?? 0
                    )
                    
                case .byCustomerSales:
                    
                    self.accountRefrecnce = Dictionary(uniqueKeysWithValues: payload.accounts.map{ value in (value.id, value) })
                    
                    var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
                    
                    var zeroItemRefrence: [UUID:[API.custPOCV1.AuditZeroObject]] = [:]
                    
                    payload.items.forEach { item in
                        
                        guard let accountId = item.accountId else {
                            return
                        }
                        
                        if let _ = itemRefrence[accountId] {
                            itemRefrence[accountId]?.append(item)
                        }
                        else {
                            itemRefrence[accountId] = [item]
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
                    
                    if !itemRefrence.isEmpty {
                        
                        var grandCostTotal: Int64 = 0
                        
                        var grandPriceTotal: Int64 = 0
                        
                        self.resultDiv.appendChild(H1("📈 Inventario Existente")
                            .color(.yellowTC))
                        
                        itemRefrence.forEach { accountId, items in
                            
                            var catchItems: [API.custPOCV1.AuditObject] = []
                            
                            @State var sectionIsHidden = false
                            
                            var storeCostTotal: Int64 = 0
                            
                            var storePriceTotal: Int64 = 0
                            
                            guard let account = self.accountRefrecnce[accountId] else {
                                return
                            }
                            
                            /// Add store name
                            self.resultDiv.appendChild(Div{
                                
                                H1("\(account.businessName) \(account.firstName) \(account.lastName)").color(.yellowTC)
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
                                
                                Img()
                                    .src("/skyline/media/excel.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .csv,
                                            name: "ventas_por_clientes_\( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Ventas Por Clientes \( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))"
                                        )
                                    }

                                Img()
                                    .src("/skyline/media/pdf.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .pdf,
                                            name: "ventas_por_clientes_\( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Ventas Por Clientes \( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))"
                                        )
                                    }
                                
                                Div().clear(.both)
                                
                            })
                            
                            let table = Table {
                                Tr{
                                    ProductManagerView.AuditView.productManagerHeaderCell()
                                    Td("POC/SKU/UPC")
                                    Td("Nombre")
                                    Td("Marca")
                                    Td("Modelo")
                                    Td("DiaZero")
                                    Td("Mas Antig.")
                                    Td("Mas Nuevo")
                                    Td("Unis.")
                                    Td("Costo")
                                    Td("Precio")
                                }
                            }
                                .hidden($sectionIsHidden)
                                .marginBottom(24.px)
                                .width(100.percent)
                                .color(.white)
                            
                            var conterRow = true
                            
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
                                
                                table.appendChild(Tr{
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/D")
                                    Td(poc?.model ?? "N/D")
                                    Td(item.zeroDay?.toString ?? "---")
                                    Td(oldestItem)
                                    Td(newestItem)
                                    Td(item.items.count.toString)
                                    Td(itemCostTotal.formatMoney)
                                    Td(itemPriceTotal.formatMoney)
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                storeCostTotal += itemCostTotal
                                
                                storePriceTotal += itemPriceTotal
                                
                                conterRow = !conterRow
                            }
                            
                            conterRow = !conterRow
                            
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
                            
                            grandCostTotal += storeCostTotal
                            
                            grandPriceTotal += storePriceTotal
                            
                            self.resultDiv.appendChild(table)
                            
                        }
                        
                    }
                    
                    if !zeroItemRefrence.isEmpty {
                        
                        self.resultDiv.appendChild(H1("⚠️ Sin Inventario").color(.yellowTC))
                        
                        zeroItemRefrence.forEach { storeid, items in
                            
                            let store = stores[storeid]
                            
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
                                    ProductManagerView.AuditView.productManagerHeaderCell()
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
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/D")
                                    Td(poc?.model ?? "N/D")
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                conterRow = !conterRow
                                
                            }
                            
                            self.resultDiv.appendChild(table)
                        }
                    }
                    
                case .byUserSales:
                    
                    var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
                    
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
                        
                    }
                    
                    payload.pocs.forEach { poc in
                        self.pocRefrence[poc.id] = poc
                    }
                    
                    if !itemRefrence.isEmpty {
                        
                        var grandCostTotal: Int64 = 0
                        
                        var grandPriceTotal: Int64 = 0
                        
                        self.resultDiv.appendChild(H1("📈 Inventario Existente")
                            .color(.yellowTC))
                        
                        itemRefrence.forEach { userId, items in
                            
                            var catchItems: [API.custPOCV1.AuditObject] = []
                            
                            @State var sectionIsHidden = false
                            
                            
                            var storeTotalUnits: Int64 = 0
                            
                            var storeCostTotal: Int64 = 0
                            
                            var storePriceTotal: Int64 = 0
                            
                            @State var uname: String = "N/D"
                            
                            getUserRefrence(id: .id(userId)) { user in
                                guard let user else {
                                    return
                                }
                                uname = user.username
                            }
                            
                            
                            /// Add store name
                            self.resultDiv.appendChild(Div{
                                
                                H1($uname).color(.yellowTC)
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
                                
                                Img()
                                    .src("/skyline/media/excel.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .csv,
                                            name: "ventas_por_usuario_\( uname.purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Ventas Por Ususario \( uname.purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))"
                                        )
                                    }
                                
                                Img()
                                    .src("/skyline/media/pdf.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .pdf,
                                            name: "ventas_por_usuario_\( uname.purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Ventas Por Ususario \( uname.purgeSpaces.replace(from: " ", to: "_") )__\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))"
                                        )
                                    }
                                
                                Div().clear(.both)
                                
                            })
                            
                            let table = Table {
                                Tr{
                                    ProductManagerView.AuditView.productManagerHeaderCell()
                                    Td("POC/SKU/UPC")
                                    Td("Nombre")
                                    Td("Marca")
                                    Td("Modelo")
                                    Td("Mas Antig.")
                                    Td("Mas Nuevo")
                                    Td("Unis.")
                                    Td("Costo")
                                    Td("Precio")
                                }
                            }
                                .hidden($sectionIsHidden)
                                .marginBottom(24.px)
                                .width(100.percent)
                                .color(.white)
                            
                            var conterRow = true
                            
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
                                
                                table.appendChild(Tr{
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/D")
                                    Td(poc?.model ?? "N/D")
                                    Td(oldestItem)
                                    Td(newestItem)
                                    Td(item.items.count.toString)
                                    Td(itemCostTotal.formatMoney)
                                    Td(itemPriceTotal.formatMoney)
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                storeTotalUnits += item.items.count.toInt64
                                
                                storeCostTotal += itemCostTotal
                                
                                storePriceTotal += itemPriceTotal
                                
                                conterRow = !conterRow
                            }
                            
                            conterRow = !conterRow
                            
                            table.appendChild(Tr{
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td(storeTotalUnits.toString)
                                Td(storeCostTotal.formatMoney)
                                    .color(.yellowTC)
                                Td(storePriceTotal.formatMoney)
                                    .color(.yellowTC)
                            }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                            
                            grandCostTotal += storeCostTotal
                            
                            grandPriceTotal += storePriceTotal
                            
                            self.resultDiv.appendChild(table)
                            
                        }
                    }
                    
                case .byConcession:
                    
                    let accountRefrecnce:[UUID: CustAcctQuick] = Dictionary(uniqueKeysWithValues: payload.accounts.map{ value in (value.id, value) })
                    
                    var itemRefrence: [UUID:[API.custPOCV1.AuditObject]] = [:]
                    
                    var zeroItemRefrence: [UUID:[API.custPOCV1.AuditZeroObject]] = [:]
                    
                    payload.items.forEach { item in
                        
                        guard let accountId = item.accountId else {
                            return
                        }
                        
                        if let _ = itemRefrence[accountId] {
                            itemRefrence[accountId]?.append(item)
                        }
                        else {
                            itemRefrence[accountId] = [item]
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
                    
                    if !itemRefrence.isEmpty {
                        
                        var grandCostTotal: Int64 = 0
                        
                        var grandPriceTotal: Int64 = 0
                        
                        self.resultDiv.appendChild(H1("📈 Inventario Existente")
                            .color(.yellowTC))
                        
                        itemRefrence.forEach { accountId, items in
                            
                            var catchItems: [API.custPOCV1.AuditObject] = []
                            
                            @State var sectionIsHidden = false
                            
                            var storeUnitsTotal: Int = 0
                            
                            var storeCostTotal: Int64 = 0
                            
                            var storePriceTotal: Int64 = 0
                            
                            guard let account = accountRefrecnce[accountId] else {
                                return
                            }
                            
                            /// Add store name
                            self.resultDiv.appendChild(Div{
                                
                                H1("\(account.businessName) \(account.firstName) \(account.lastName)").color(.yellowTC)
                                    .float(.left)
                                
                                Img()
                                    .src("/skyline/media/maximizeWindow.png")
                                    .class(.iconWhite)
                                    .marginLeft(7.px)
                                    .cursor(.pointer)
                                    .height(24.px)
                                    .onClick {
                                        
                                        
                                        let view = AccoutOverview(id: .id(account.id), isSuperView: true)
                                        
                                        addToDom(view)
                                        
                                        view.loadAccout()
                                        
                                    }
                                
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
                                    .src("/skyline/media/excel.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .csv,
                                            name: "inventario_en_concesion_\( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )_\(getDate().formatedLong.replace(from: " ", to: "_").purgeSpaces.replace(from: "/", to: "_"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Inventario en Concesión - \(account.businessName) \(account.firstName) \(account.lastName) \(getDate().formatedLong)"
                                        )
                                    }

                                
                                Img()
                                    .src("/skyline/media/pdf.png")
                                    .marginRight(24.px)
                                    .paddingTop(7.px)
                                    .float(.right)
                                    .width(36.px)
                                    .onClick {
                                        self.download(
                                            .pdf,
                                            name: "inventario_en_concesion_\( "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces.replace(from: " ", to: "_") )_\(getDate().formatedLong.replace(from: " ", to: "_").purgeSpaces.replace(from: "/", to: "_"))",
                                            item: catchItems,
                                            type: type,
                                            title: "Inventario en Concesión - \(account.businessName) \(account.firstName) \(account.lastName) \(getDate().formatedLong)"
                                        )
                                    }
                                
                                Div().clear(.both)
                                
                            })
                            
                            let table = Table {
                                Tr{
                                    ProductManagerView.AuditView.productManagerHeaderCell()
                                    Td("POC/SKU/UPC")
                                    Td("Nombre")
                                    Td("Marca")
                                    Td("Modelo")
                                    Td("DiaZero")
                                    Td("Mas Antig.")
                                    Td("Mas Nuevo")
                                    Td("Unis.")
                                    Td("Costo")
                                    Td("Precio")
                                }
                            }
                                .hidden($sectionIsHidden)
                                .marginBottom(24.px)
                                .width(100.percent)
                                .color(.white)
                            
                            var conterRow = true
                            
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
                                
                                table.appendChild(Tr{
                                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                                    Td(poc?.upc ?? "N/D")
                                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                                    Td(poc?.brand ?? "N/D")
                                    Td(poc?.model ?? "N/D")
                                    Td(item.zeroDay?.toString ?? "---")
                                    Td(oldestItem)
                                    Td(newestItem)
                                    Td(item.items.count.toString)
                                    Td(itemCostTotal.formatMoney)
                                    Td(itemPriceTotal.formatMoney)
                                }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                                
                                storeUnitsTotal += item.items.count
                                
                                storeCostTotal += itemCostTotal
                                
                                storePriceTotal += itemPriceTotal
                                
                                conterRow = !conterRow
                            }
                            
                            conterRow = !conterRow
                            
                            table.appendChild(Tr{
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td("")
                                Td(storeUnitsTotal.toString)
                                    .color(.yellowTC)
                                Td(storeCostTotal.formatMoney)
                                    .color(.yellowTC)
                                Td(storePriceTotal.formatMoney)
                                    .color(.yellowTC)
                            }.backgroundColor({ conterRow ? .backGroundRow : .transparent }()))
                            
                            grandCostTotal += storeCostTotal
                            
                            grandPriceTotal += storePriceTotal
                            
                            self.resultDiv.appendChild(table)
                            
                        }
                    }

                case .fastAndFurios:
                    break
                }

                self.renderProductDailySalesAverage(
                    payload: payload,
                    requestedStartAt: startAtUTS,
                    requestedEndAt: endAtUTS,
                    renderId: renderId
                )
            }
        }
        
        func download(_ documentType: DocumentType, name: String, item: [API.custPOCV1.AuditObject], type: InventoryAuditTypes, title: String) {
            
            loadingView.show()
            
            print("🟢  type: \(type.rawValue)") 

            switch type {
            case .general:
                break
            case .lowInvetory:
                break
            case .byStore:
                downloadByStore(type: documentType, name: name, items: item, title: title)
            case .byDepartement:
                break
            case .byProduct:
                downloadByProduct(type: documentType, name: name, item: item, title: title)
            case .bySales:
                downloadBySales(type: documentType, name: name, item: item, title: title)
            case .bySalesConcession:
                downloadBySalesConcession(type: documentType, name: name, item: item, title: title)
            case .byCustomerSales:
                downloadBySales(type: documentType, name: name, item: item, title: title)
            case .byUserSales:
                downloadBySales(type: documentType, name: name, item: item, title: title)
            case .byConcession:
                downloadByConcession(type: documentType, name: name, item: item, title: title)
            case .fastAndFurios:
                break
            }
            
            loadingView.hide()
            
        }
        
        func downloadByStore(type: DocumentType, name: String, items: [API.custPOCV1.AuditObject], title: String)  {

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

            let tableHeader: [String] = [
                "POC/SKU/UPC",
                "Nombre Marca",
                "Modelo",
                "DiaZero",
                "Mas Antiguo",
                "Mas Nuevo",
                "Unis",
                "Cost",
                "Precio"
            ]

            var tableBody: [[String]] = []

            var contents = "\(title),\(custCatchUrl),,\n" +

            tableHeader.joined(separator: ",") + "\n"

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
                
                let row: [String] = [
                        "\(poc?.upc ?? "N/D")",
                        "\(poc?.name ?? "N/D"),\(poc?.brand ?? "N/D")",
                        poc?.model ?? "N/D",
                        item.zeroDay?.toString ?? "---",
                        oldestItem,
                        newestItem,
                        item.items.count.toString,
                        itemCostTotal.formatMoney,
                        itemPriceTotal.formatMoney
                ]

                tableBody.append(row)

                contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
                
                storeCostTotal += itemCostTotal
                
                storePriceTotal += itemPriceTotal
                
            }
            
            let row:[String] = [
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                storeCostTotal.formatMoney,
                storePriceTotal.formatMoney
            ]
            
            tableBody.append(row)

            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"

            switch type {
                case .csv:
                
                _ = JSObject.global.download!( "\(name).csv", contents)

                case .pdf:
            
                    _ = JSObject.global.createProductAuditPDF!(name, title, tableHeader, tableBody)


            }
        }
        
        func downloadByProduct(type: DocumentType, name: String, item: [API.custPOCV1.AuditObject], title: String) {
            
            /*
            let tableHeader: [String] = [
                "POC/SKU/UPC Nombre Marca",
                "Nombre",
                "Existente",
                "Faltante"
            ]

            var contents = "\(title),\(custCatchUrl),,\n" +
                tableHeader.joined(separator: ",") + "\n"

            switch type {
                case .csv:

                _ = JSObject.global.download!( "\(name).csv", contents)
                
                case .pdf:
                
                _ = JSObject.global.createProductAuditPDF!( name, json, title)

            }
        */
        }
        
        func downloadBySales(type: DocumentType, name: String, item: [API.custPOCV1.AuditObject], title: String) {

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
            
            let tableHeader: [String] = [
                "POC/SKU/UPC",
                "Nombre | Marca",
                "Modelo",
                "DiaZero",
                "Mas Antig.",
                "Mas Nuevo",
                "Unis.",
                "Costo",
                "IVA",
                "Costo Neto",
                "Precio",
                "IVA",
                "Precio Neto"
            ]
            
            var tableBody: [[String]] = []

            var contents = "\(custCatchUrl),\(title),,,,,,,,\n" +
            tableHeader.joined(separator: ",") + "\n"

            item.forEach { item in
                
                let itemCostTotal: Int64 = item.items.map{ $0.cost }.reduce(0, +)
                
                /* CalcSubTotalResponse*/
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
                
                /* CalcSubTotalResponse*/
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

                let row: [String] = [
                    "\(poc?.upc)",
                    "\(poc?.name ?? "") \(poc?.brand ?? "")".purgeSpaces,
                    "\(poc?.model ?? "N/D")",
                    "\(item.zeroDay?.toString ?? "---")",
                    "\(oldestItem)",
                    "\(newestItem)",
                    "\(item.items.count.toString)",
                    "\(_costSubTotal.formatMoney)",       
                    "\(_costTaxTrasladados.formatMoney)",
                    "\(itemCostTotal.formatMoney)",
                    "\(_priceSubTotal.formatMoney)",
                    "\(_priceTaxTrasladados.formatMoney)",
                    "\(itemPriceTotal.formatMoney)"
                ]

                tableBody.append(row)

                contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
                
                // MARK: ADD COSTS
                costSubTotal += _costSubTotal.toCents
                
                costTaxTotal += _costTaxTrasladados.toCents
                
                storeCostTotal += itemCostTotal
                
                // MARK: ADD PROCES
                priceSubTotal += _priceSubTotal.toCents
            
                priceTaxTotal += _priceTaxTrasladados.toCents
                
                storePriceTotal += itemPriceTotal
                
            }
            
            let row: [String] = [
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "\(costSubTotal.formatMoney)",
                    "\(costTaxTotal.formatMoney)",
                    "\(storeCostTotal.formatMoney)",
                    "\(priceSubTotal.formatMoney)",
                    "\(priceTaxTotal.formatMoney)",
                    "\(storePriceTotal.formatMoney)"
                ]
            
            tableBody.append(row)

            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
            
            switch type {
                case .csv:

                _ = JSObject.global.download!( "\(name).csv", contents)

                case .pdf:

                _ = JSObject.global.createProductAuditPDF!( name, title, tableHeader, tableBody)
                
            }
            
        }
        
        func downloadBySalesConcession(type: DocumentType, name: String, item: [API.custPOCV1.AuditObject], title: String) {

            let tableHeader: [String] = [
                "POC/SKU/UPC",
                "Nombre | Marca",
                "Modelo",
                "DiaZero",
                "Mas Antig.",
                "Mas Nuevo",
                "Unis.",
                "Costo",
                "IVA",
                "Costo Neto",
                "Precio",
                "IVA",
                "Precio Neto"
            ]

            var tableBody: [[String]] = []

            var contents = "\(custCatchUrl),\(title),,,,,,,,\n" +
            tableHeader.joined(separator: ",") + "\n"

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
                
                /*CalcSubTotalResponse */
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
                
                let row: [String] = [
                        "\(poc?.upc ?? "N/D")",
                        "\(poc?.name ?? "") \(poc?.brand ?? "")".purgeSpaces,
                        poc?.model ?? "N/D",
                        item.zeroDay?.toString ?? "---",
                        oldestItem,
                        newestItem,
                        item.items.count.toString,
                        _costSubTotal.formatMoney,
                        _costTaxTrasladados.formatMoney,
                        itemCostTotal.formatMoney,
                        _priceSubTotal.formatMoney,
                        _priceTaxTrasladados.formatMoney,
                        itemPriceTotal.formatMoney
                ]

                tableBody.append(row)

                contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
                

                costSubTotal += _costSubTotal.toCents
                
                costTaxTotal += _costTaxTrasladados.toCents
                
                storeCostTotal += itemCostTotal
                
                
                priceSubTotal += _priceSubTotal.toCents
            
                priceTaxTotal += _priceTaxTrasladados.toCents
                
                storePriceTotal += itemPriceTotal
                
            }
            
            let row: [String] = [
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    costSubTotal.formatMoney,
                    costTaxTotal.formatMoney,
                    storeCostTotal.formatMoney,
                    priceSubTotal.formatMoney,
                    priceTaxTotal.formatMoney,
                    storePriceTotal.formatMoney
                ]

            tableBody.append(row)

            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
            
            switch type {
                case .csv:
                
                _ = JSObject.global.download!( "\(name).csv", contents)
                
                case .pdf:
                
                _ = JSObject.global.createProductAuditPDF!( name, title, tableHeader, tableBody)

            }
            
        }
        
        func downloadByConcession(type: DocumentType, name: String, item: [API.custPOCV1.AuditObject], title: String) {
            
            let tableHeader: [String] = [
                "POC/SKU/UPC",
                "Nombre | Marca",
                "Modelo",
                "DiaZero",
                "Mas Antig.",
                "Mas Nuevo",
                "Unis.",
                "Costo",
                // "IVA",
                // "Costo Neto",
                "Precio",
                // "IVA",
                // "Precio Neto"
            ]

            var tableBody: [[String]] = []

            var contents = "\(custCatchUrl),\(title),,,,,,,,\n" +
            tableHeader.joined(separator: ",") + "\n"

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

                let row: [String] =  [
                    "\(poc?.upc ?? "")",
                    "\(poc?.name ?? "") \(poc?.brand ?? "")".purgeSpaces,
                    poc?.model ?? "",
                    item.zeroDay?.toString ?? "---",
                    oldestItem,
                    newestItem,
                    item.items.count.toString,
                    itemCostTotal.formatMoney,
                    itemPriceTotal.formatMoney,
                ]

                tableBody.append(row)

                contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"
            
                storeUnitsTotal += item.items.count
                
                storeCostTotal += itemCostTotal
                
                storePriceTotal += itemPriceTotal
                
            }

            let row: [String] =  [
                "",
                "",
                "",
                "",
                "",
                "",
                storeUnitsTotal.toString,
                storeCostTotal.formatMoney,
                storePriceTotal.formatMoney,
            ]

            tableBody.append(row)

            contents += row.map{ $0.replace(from: ",", to: "") }.joined(separator: ",") + "\n"

            switch type {
                case .csv:
            
                _ = JSObject.global.download!( "\(name).cvs", contents)

                case .pdf:
                
                _ = JSObject.global.createProductAuditPDF!( name, title, tableHeader, tableBody)

            }

        }
        
        fileprivate func renderProductDailySalesAverage(
            payload: CustPOCComponents.AuditsResponse,
            requestedStartAt: Int64?,
            requestedEndAt: Int64?,
            renderId: UUID
        ) {
            guard renderId == inventoryRenderId else {
                return
            }

            var soldUnitsByProduct: [UUID: Int64] = [:]
            var saleTimestamps: [Int64] = []
            var sourceDescription = ""

            if let summaries = payload.salesSummaries, !summaries.isEmpty {
                summaries.forEach { summary in
                    soldUnitsByProduct[summary.productId, default: 0] += summary.units
                    saleTimestamps.append(summary.firstSoldAt)
                    saleTimestamps.append(summary.lastSoldAt)
                }
                sourceDescription = "ventas agregadas"
            }
            else if let summaries = payload.productMovementSummaries, !summaries.isEmpty {
                summaries.forEach { summary in
                    soldUnitsByProduct[summary.productId, default: 0] += summary.soldUnits
                    if let firstMovementAt = summary.firstMovementAt {
                        saleTimestamps.append(firstMovementAt)
                    }
                    if let lastMovementAt = summary.lastMovementAt {
                        saleTimestamps.append(lastMovementAt)
                    }
                }
                sourceDescription = "movimientos agregados"
            }
            else if !payload.cardex.isEmpty {
                payload.cardex.forEach { movement in
                    guard movement.mode == .remove else {
                        return
                    }

                    switch movement.channel {
                    case .pdv, .order, .eSale:
                        soldUnitsByProduct[movement.pocId, default: 0] += Int64(movement.processedUnits)
                        saleTimestamps.append(movement.createdAt)
                    case .default:
                        break
                    }
                }
                sourceDescription = "Cardex"
            }
            else {
                payload.items.forEach { product in
                    product.items.forEach { item in
                        guard let soldAt = item.soldAt else {
                            return
                        }
                        soldUnitsByProduct[product.id, default: 0] += 1
                        saleTimestamps.append(soldAt)
                    }
                }

                if !soldUnitsByProduct.isEmpty {
                    sourceDescription = "detalle de ventas"
                }
            }

            let cardexByProduct = Dictionary(grouping: payload.cardex) { $0.pocId }
            let displayedProductIds = Set(soldUnitsByProduct.keys).union(cardexByProduct.keys)

            resultDiv.appendChild(
                H2("Promedio vendido por día y producto")
                    .color(.yellowTC)
                    .marginTop(18.px)
            )

            guard !displayedProductIds.isEmpty else {
                resultDiv.appendChild(Div {
                    Span("No se recibieron ventas o movimientos de Cardex para calcular el promedio diario en este reporte.")
                }
                .color(.gray)
                .padding(all: 12.px)
                .marginBottom(16.px)
                .borderRadius(7.px)
                .backgroundColor(.grayBlackDark))
                return
            }

            let fallbackStartAt = saleTimestamps.min() ?? (getNow() - (90 * 24 * 60 * 60))
            let fallbackEndAt = saleTimestamps.max() ?? getNow()
            let startAt = payload.activityFrom
                ?? ((requestedStartAt ?? 0) > 0 ? requestedStartAt : nil)
                ?? fallbackStartAt
            let endAt = payload.activityTo
                ?? ((requestedEndAt ?? 0) > startAt ? requestedEndAt : nil)
                ?? fallbackEndAt
            let reportSeconds = max(endAt - startAt, 1)
            let reportDays = max(1, Int(ceil(Double(reportSeconds) / 86_400.0)))
            let includesCardexGraph = !cardexByProduct.isEmpty

            resultDiv.appendChild(Div {
                Span("Periodo: ")
                    .color(.gray)
                Span("\(getDate(startAt).formatedLong) al \(getDate(endAt).formatedLong)")
                    .color(.white)
                Span("  •  Días: ")
                    .color(.gray)
                Span(reportDays.toString)
                    .color(.white)
                if !sourceDescription.isEmpty {
                    Span("  •  Fuente: ")
                        .color(.gray)
                    Span(sourceDescription)
                        .color(.white)
                }
            }
            .fontSize(13.px)
            .marginBottom(7.px))

            let tableBody = TBody()

            let table = Table {
                THead {
                    Tr {
                        ProductManagerView.AuditView.productManagerHeaderCell()
                        Td("POC/SKU/UPC")
                        Td("Producto")
                        Td("Vendido")
                        Td("Días")
                        Td("Prom. vendido / día")
                        if includesCardexGraph {
                            Td("Cardex")
                        }
                    }
                }
                tableBody
            }
            .width(100.percent)
            .marginBottom(18.px)
            .color(.white)

            let products = displayedProductIds.compactMap { productId -> CustPOCQuick? in
                pocRefrence[productId] ?? payload.pocs.first(where: { $0.id == productId })
            }.sorted { lhs, rhs in
                let left = "\(lhs.upc) \(lhs.name)".purgeSpaces
                let right = "\(rhs.upc) \(rhs.name)".purgeSpaces
                return left.localizedCaseInsensitiveCompare(right) == .orderedAscending
            }

            let totalSoldUnits = products.map { soldUnitsByProduct[$0.id] ?? 0 }.reduce(0, +)
            let totalDailyAverage = Double(totalSoldUnits) / Double(reportDays)

            table.appendChild(TFoot {
                Tr {
                    Td("")
                    Td("Totales")
                    Td("\(products.count) productos")
                    Td(totalSoldUnits.toString)
                    Td(reportDays.toString)
                    Td(String(format: "%.2f", totalDailyAverage))
                    if includesCardexGraph {
                        Td("")
                    }
                }
            })

            resultDiv.appendChild(table)

            asyncAddProductDailySalesRows(
                renderId: renderId,
                products: products,
                soldUnitsByProduct: soldUnitsByProduct,
                cardexByProduct: cardexByProduct,
                reportDays: reportDays,
                includesCardexGraph: includesCardexGraph,
                tableBody: tableBody,
                startAt: startAt,
                endAt: endAt
            )
        }

        private func asyncAddProductDailySalesRows(
            renderId: UUID,
            products: [CustPOCQuick],
            soldUnitsByProduct: [UUID: Int64],
            cardexByProduct: [UUID: [CustPOCCardex]],
            reportDays: Int,
            includesCardexGraph: Bool,
            tableBody: TBody,
            startAt: Int64,
            endAt: Int64,
            index: Int = 0
        ) {
            guard renderId == inventoryRenderId,
                  products.indices.contains(index) else {
                return
            }

            Dispatch.asyncAfter(index == 0 ? 0.01 : 0.015) {
                guard renderId == self.inventoryRenderId,
                      products.indices.contains(index) else {
                    return
                }

                let product = products[index]
                let soldUnits = soldUnitsByProduct[product.id] ?? 0
                let dailyAverage = Double(soldUnits) / Double(reportDays)
                let productCardex = cardexByProduct[product.id] ?? []

                tableBody.appendChild(Tr {
                    ProductManagerView.AuditView.productManagerCell(pocId: product.id)
                    Td(product.upc.isEmpty ? "N/D" : product.upc)
                    ProductManagerView.AuditView.productDescriptionCell(
                        "\(product.name) \(product.brand) \(product.model)".purgeSpaces
                    )
                    Td(soldUnits.toString)
                    Td(reportDays.toString)
                    Td(String(format: "%.2f", dailyAverage))
                        .color(.yellowTC)
                        .fontWeight(.bold)
                    if includesCardexGraph {
                        Td {
                            if let graphItem = self.groupedCardexGraphItem(
                                product: product,
                                movements: productCardex
                            ) {
                                CardexGraphView.graphButton {
                                    addToDom(CardexGraphView(
                                        item: graphItem,
                                        storeName: self.cardexScopeName(movements: productCardex),
                                        startAt: startAt,
                                        endAt: endAt
                                    ))
                                }
                            }
                            else {
                                Span("N/D")
                                    .color(.gray)
                            }
                        }
                    }
                }
                .backgroundColor(index.isEven ? .backGroundRow : .transparent))

                self.asyncAddProductDailySalesRows(
                    renderId: renderId,
                    products: products,
                    soldUnitsByProduct: soldUnitsByProduct,
                    cardexByProduct: cardexByProduct,
                    reportDays: reportDays,
                    includesCardexGraph: includesCardexGraph,
                    tableBody: tableBody,
                    startAt: startAt,
                    endAt: endAt,
                    index: index + 1
                )
            }
        }

        fileprivate func groupedCardexGraphItem(
            product: CustPOCQuick,
            movements: [CustPOCCardex]
        ) -> CustPOCComponents.CardexObject? {

            let orderedMovements = movements.sorted { $0.createdAt < $1.createdAt }

            guard let first = orderedMovements.first, let last = orderedMovements.last else {
                return nil
            }

            let added = orderedMovements.filter { $0.mode == .add }

            let removed = orderedMovements.filter { $0.mode == .remove }

            let sold = removed.filter { movement in
                switch movement.channel {
                case .pdv, .order, .eSale:
                    return true
                case .default:
                    return false
                }
            }

            let initialUnits = first.initialUnits
            let addedInventory: Int = added.map { $0.processedUnits }.reduce(0, +)
            let removeInventory: Int = removed.map { $0.processedUnits }.reduce(0, +)
            let finalInventory: Int = last.finalUnits
            let soldInventory: Int = sold.map { $0.processedUnits }.reduce(0, +)
            let initalBalance: Int64 = first.initialBalance
            let addedBalance: Int64 = added.map { $0.processedBalance }.reduce(0, +)
            let removeBalance: Int64 = removed.map { $0.processedBalance }.reduce(0, +)
            let finalBalance: Int64 = last.finalBalance

            return .init(
                initalInventory: initialUnits,
                addedInventory: addedInventory,
                removeInventory: removeInventory,
                finalInventory: finalInventory,
                soldInventory: soldInventory,
                initalBalance: initalBalance,
                addedBalance: addedBalance,
                removeBalance: removeBalance,
                finalBalance: finalBalance,
                poc: product
            )
        }

        fileprivate func cardexScopeName(movements: [CustPOCCardex]) -> String {
            let relationIds = Set(movements.map { $0.relationId })

            guard relationIds.count == 1, let relationId = relationIds.first else {
                return "Todas las ubicaciones del reporte"
            }

            return stores[relationId]?.name ?? "Ubicación del reporte"
        }

        fileprivate func renderLowInventory(
            payload: CustPOCComponents.AuditsResponse,
            renderId: UUID
        ) {
            guard renderId == inventoryRenderId else {
                return
            }

            let inventorySummaries = (payload.inventorySummaries ?? []).filter {
                $0.isLowInventory || $0.isZeroInventory
            }

            guard !inventorySummaries.isEmpty else {
                resultDiv.appendChild(
                    Table().noResult(
                        label: "✅ No se encontraron productos con inventario bajo o agotado y actividad reciente."
                    )
                )
                return
            }

            var departmentReference: [UUID: String] = [:]
            payload.departments?.forEach { department in
                departmentReference[department.id] = department.name
            }

            var storeReference: [UUID: String] = [:]
            payload.stores?.forEach { store in
                storeReference[store.id] = store.name
            }
            stores.forEach { id, store in
                storeReference[id] = store.name
            }

            var lastActivityByProduct: [UUID: Int64] = [:]
            var lastActivityByProductAndStore: [String: Int64] = [:]
            var movementCountByProductAndStore: [String: Int] = [:]

            payload.cardex.forEach { movement in
                if movement.createdAt > (lastActivityByProduct[movement.pocId] ?? 0) {
                    lastActivityByProduct[movement.pocId] = movement.createdAt
                }

                let key = inventoryActivityKey(
                    productId: movement.pocId,
                    storeId: movement.relationId
                )
                movementCountByProductAndStore[key, default: 0] += 1

                if movement.createdAt > (lastActivityByProductAndStore[key] ?? 0) {
                    lastActivityByProductAndStore[key] = movement.createdAt
                }
            }

            let zeroInventoryCount = inventorySummaries.filter { $0.isZeroInventory }.count
            let lowInventoryCount = inventorySummaries.filter {
                $0.isLowInventory && !$0.isZeroInventory
            }.count
            let currentUnits = inventorySummaries.map { $0.currentStock }.reduce(0, +)
            let shortageUnits = inventorySummaries.compactMap { $0.shortageUnits }.reduce(0, +)
            let currentCostValue = inventorySummaries.map { $0.currentCostValue }.reduce(0, +)
            let currentRetailValue = inventorySummaries.map { $0.currentRetailValue }.reduce(0, +)

            resultDiv.appendChild(Div {
                H1("⚠️ Inventario bajo y agotado")
                    .color(.yellowTC)
                    .marginBottom(3.px)

                Div("Productos con actividad durante los últimos 90 días")
                    .color(.gray)
                    .fontSize(13.px)

                Div {
                    Span("Alcance: ")
                        .color(.gray)
                    Span(self.inventoryReportScope(payload: payload))
                        .color(.white)

                    Span("  •  Periodo: ")
                        .color(.gray)
                    Span(self.inventoryActivityRange(payload: payload))
                        .color(.white)

                    Span("  •  Generado: ")
                        .color(.gray)
                    Span(self.inventoryDateTime(payload.generatedAt))
                        .color(.white)
                }
                .fontSize(13.px)
                .marginTop(5.px)
            }
            .padding(all: 12.px)
            .marginBottom(10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .class(Class(TCCrystalSurfaceClass.auditReportHeader)))

            resultDiv.appendChild(Div {
                self.inventoryMetric(
                    title: "Productos afectados",
                    value: inventorySummaries.count.toString,
                    detail: "Bajo o agotado"
                )
                self.inventoryMetric(
                    title: "Inventario bajo",
                    value: lowInventoryCount.toString,
                    detail: "Existencia mayor a cero"
                )
                self.inventoryMetric(
                    title: "Agotados",
                    value: zeroInventoryCount.toString,
                    detail: "Con actividad reciente"
                )
                self.inventoryMetric(
                    title: "Unidades actuales",
                    value: currentUnits.toString,
                    detail: "Existencia combinada"
                )
                self.inventoryMetric(
                    title: "Faltante",
                    value: shortageUnits.toString,
                    detail: "Contra inventario mínimo"
                )
                self.inventoryMetric(
                    title: "Movimientos",
                    value: payload.cardex.count.toString,
                    detail: "Dentro del periodo"
                )
                self.inventoryMetric(
                    title: "Valor costo",
                    value: currentCostValue.formatMoney,
                    detail: "Existencia actual"
                )
                self.inventoryMetric(
                    title: "Valor venta",
                    value: currentRetailValue.formatMoney,
                    detail: "Existencia actual"
                )
            }
            .display(.flex)
            .custom("flex-wrap", "wrap")
            .custom("gap", "8px")
            .class(Class(TCCrystalSurfaceClass.auditMetricGrid))
            .marginBottom(10.px))

            resultDiv.appendChild(ProductManagerView.AuditView.reportBarChart(
                title: "Estado de inventario",
                items: [
                    ("Inventario bajo", Double(lowInventoryCount), lowInventoryCount.toString),
                    ("Agotados", Double(zeroInventoryCount), zeroInventoryCount.toString),
                    ("Faltante", Double(shortageUnits), shortageUnits.toString)
                ]
            ))

            if inventorySummaries.allSatisfy({ ($0.minInventory ?? 0) == 0 }) {
                resultDiv.appendChild(Div {
                    Span("ℹ️ ")
                    Span("Todos los productos del resultado tienen inventario mínimo en cero. ")
                        .fontWeight(.bold)
                    Span("Por eso el faltante y el conteo de inventario bajo son cero; los productos mostrados se incluyen porque están agotados y tuvieron actividad reciente.")
                }
                .color(.white)
                .padding(all: 10.px)
                .marginBottom(10.px)
                .borderRadius(7.px)
                .backgroundColor(.grayBlackDark))
            }

            resultDiv.appendChild(
                H2("Detalle de productos")
                    .color(.yellowTC)
                    .marginTop(16.px)
            )

            let lowInventorySummaries = inventorySummaries.filter {
                $0.isLowInventory && !$0.isZeroInventory
            }
            let zeroInventorySummaries = inventorySummaries.filter { $0.isZeroInventory }

            if !lowInventorySummaries.isEmpty {
                renderInventoryDepartment(
                    renderId: renderId,
                    departmentId: nil,
                    summaries: lowInventorySummaries,
                    departmentReference: departmentReference,
                    storeReference: storeReference,
                    lastActivityByProduct: lastActivityByProduct,
                    lastActivityByProductAndStore: lastActivityByProductAndStore,
                    movementCountByProductAndStore: movementCountByProductAndStore,
                    showDepartmentHeader: false,
                    sectionTitle: "Inventario bajo",
                    showStore: false,
                    usePOCPrices: true
                )
            }

            if !zeroInventorySummaries.isEmpty {
                renderInventoryDepartment(
                    renderId: renderId,
                    departmentId: nil,
                    summaries: zeroInventorySummaries,
                    departmentReference: departmentReference,
                    storeReference: storeReference,
                    lastActivityByProduct: lastActivityByProduct,
                    lastActivityByProductAndStore: lastActivityByProductAndStore,
                    movementCountByProductAndStore: movementCountByProductAndStore,
                    showDepartmentHeader: false,
                    sectionTitle: "Agotados",
                    showStore: false,
                    usePOCPrices: true
                )
            }
        }

        fileprivate func renderInventoryStoreSummary(
            payload: CustPOCComponents.AuditsResponse,
            storeReference: [UUID: String]
        ) {
            guard let summaries = payload.inventoryGroupSummaries, !summaries.isEmpty else {
                return
            }

            resultDiv.appendChild(
                H2("Resumen por tienda")
                    .color(.yellowTC)
            )

            let table = Table {
                THead {
                    Tr {
                        Td("Tienda")
                        Td("Productos")
                        Td("Con inventario")
                        Td("Bajo")
                        Td("Agotados")
                        Td("Unidades")
                        Td("Costo")
                        Td("Venta")
                    }
                }
            }
            .marginBottom(12.px)
            .width(100.percent)
            .color(.white)

            let sortedSummaries = summaries.sorted { lhs, rhs in
                let leftStore = inventoryStoreName(
                    id: lhs.storeId,
                    reference: storeReference
                )
                let rightStore = inventoryStoreName(
                    id: rhs.storeId,
                    reference: storeReference
                )
                return leftStore.localizedCaseInsensitiveCompare(rightStore) == .orderedAscending
            }

            var alternateRow = true
            sortedSummaries.forEach { summary in
                table.appendChild(Tr {
                    Td(self.inventoryStoreName(id: summary.storeId, reference: storeReference))
                    Td(summary.productCount.toString)
                    Td((summary.productCount - summary.zeroProductCount).toString)
                    Td(summary.lowProductCount.toString)
                    Td(summary.zeroProductCount.toString)
                    Td(summary.currentStock.toString)
                    Td(summary.currentCostValue.formatMoney)
                    Td(summary.currentRetailValue.formatMoney)
                }
                .backgroundColor(alternateRow ? .backGroundRow : .transparent))

                alternateRow = !alternateRow
            }

            table.appendChild(TFoot {
                Tr {
                    Td("Totales")
                    Td(sortedSummaries.map { $0.productCount }.reduce(0, +).toString)
                    Td(sortedSummaries.map { $0.productCount - $0.zeroProductCount }.reduce(0, +).toString)
                    Td(sortedSummaries.map { $0.lowProductCount }.reduce(0, +).toString)
                    Td(sortedSummaries.map { $0.zeroProductCount }.reduce(0, +).toString)
                    Td(sortedSummaries.map { $0.currentStock }.reduce(0, +).toString)
                    Td(sortedSummaries.map { $0.currentCostValue }.reduce(0, +).formatMoney)
                    Td(sortedSummaries.map { $0.currentRetailValue }.reduce(0, +).formatMoney)
                }
            })

            resultDiv.appendChild(table)
        }

        fileprivate func renderInventoryDepartment(
            renderId: UUID,
            departmentId: UUID?,
            summaries: [CustPOCComponents.AuditInventorySummary],
            departmentReference: [UUID: String],
            storeReference: [UUID: String],
            lastActivityByProduct: [UUID: Int64],
            lastActivityByProductAndStore: [String: Int64],
            movementCountByProductAndStore: [String: Int],
            showDepartmentHeader: Bool = true,
            sectionTitle: String? = nil,
            sectionStartsCollapsed: Bool = false,
            showStore: Bool = true,
            usePOCPrices: Bool = false,
            showActivity: Bool = true,
            showShortage: Bool = true,
            showLastSoldAt: Bool = false,
            cardexRange: (startAt: Int64, endAt: Int64)? = nil
        ) {
            guard renderId == inventoryRenderId else {
                return
            }

            let hasSectionHeader = showDepartmentHeader || sectionTitle != nil
            @State var sectionIsHidden = hasSectionHeader && sectionStartsCollapsed
            let sectionContainer = Div()
                .class(Class(TCCrystalSurfaceClass.auditSection))

            if hasSectionHeader {
                let departmentName = inventoryDepartmentName(
                    id: departmentId,
                    reference: departmentReference
                )
                let zeroCount = summaries.filter { $0.isZeroInventory }.count
                let lowCount = summaries.filter { $0.isLowInventory && !$0.isZeroInventory }.count
                let withStockCount = summaries.filter { $0.currentStock > 0 }.count
                let heading = sectionTitle.map {
                    "\($0)  •  \(summaries.count) productos"
                } ?? "\(departmentName)  •  \(summaries.count) productos  •  \(withStockCount) con inventario  •  \(lowCount) bajos  •  \(zeroCount) agotados"

                sectionContainer.appendChild(Div {
                    H2(heading)
                        .color(.yellowTC)
                        .float(.left)

                    Img()
                        .src($sectionIsHidden.map {
                            $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"
                        })
                        .marginRight(24.px)
                        .class(.iconWhite)
                        .paddingTop(7.px)
                        .float(.right)
                        .opacity(0.5)
                        .width(36.px)

                    Div().clear(.both)
                }
                .cursor(.pointer)
                .onClick {
                    sectionIsHidden = !sectionIsHidden
                })
            }

            let tableBody = TBody()

            let table = Table {
                THead {
                    Tr {
                        if showStore {
                            Td("Tienda")
                        }
                        ProductManagerView.AuditView.productManagerHeaderCell()
                        Td("POC/SKU/UPC")
                        Td("Producto")
                        Td("Marca / Modelo")
                        Td("Estado")
                        Td("Actual")
                        Td("Mínimo")
                        if showShortage {
                            Td("Faltante")
                        }
                        if showLastSoldAt {
                            Td("Última venta")
                        }
                        if showActivity {
                            Td("Movs.")
                            Td("Última actividad")
                        }
                        Td("Costo")
                        Td("Venta")
                        if cardexRange != nil {
                            Td("Cardex")
                        }
                    }
                }
                tableBody
            }
            .hidden($sectionIsHidden)
            .marginBottom(18.px)
            .width(100.percent)
            .color(.white)

            let sortedSummaries = summaries.sorted { lhs, rhs in
                if cardexRange != nil {
                    let leftPOC = pocRefrence[lhs.productId]
                    let rightPOC = pocRefrence[rhs.productId]
                    let leftProduct = leftPOC?.upc.isEmpty == false ? leftPOC?.upc : leftPOC?.name
                    let rightProduct = rightPOC?.upc.isEmpty == false ? rightPOC?.upc : rightPOC?.name
                    let productComparison = (leftProduct ?? "").localizedCaseInsensitiveCompare(rightProduct ?? "")

                    if productComparison != .orderedSame {
                        return productComparison == .orderedAscending
                    }
                }

                let leftStore = inventoryStoreName(id: lhs.storeId, reference: storeReference)
                let rightStore = inventoryStoreName(id: rhs.storeId, reference: storeReference)
                let storeComparison = leftStore.localizedCaseInsensitiveCompare(rightStore)
                if storeComparison != .orderedSame {
                    return storeComparison == .orderedAscending
                }

                let leftPOC = pocRefrence[lhs.productId]
                let rightPOC = pocRefrence[rhs.productId]
                let leftValue = leftPOC?.upc.isEmpty == false ? leftPOC?.upc : leftPOC?.name
                let rightValue = rightPOC?.upc.isEmpty == false ? rightPOC?.upc : rightPOC?.name
                return (leftValue ?? "").localizedCaseInsensitiveCompare(rightValue ?? "") == .orderedAscending
            }

            let latestSoldAt = sortedSummaries.map { $0.lastSoldAt }.max() ?? 0
            let totalCost = usePOCPrices
                ? sortedSummaries.compactMap { self.pocRefrence[$0.productId]?.cost }.reduce(0, +)
                : sortedSummaries.map { $0.currentCostValue }.reduce(0, +)
            let totalRetail = usePOCPrices
                ? sortedSummaries.compactMap { self.pocRefrence[$0.productId]?.pricea }.reduce(0, +)
                : sortedSummaries.map { $0.currentRetailValue }.reduce(0, +)

            table.appendChild(TFoot {
                Tr {
                    if showStore {
                        Td("Totales")
                    }
                    Td("")
                    Td(showStore ? "" : "Totales")
                    Td("\(sortedSummaries.count) registros")
                    Td("")
                    Td("")
                    Td(sortedSummaries.map { $0.currentStock }.reduce(0, +).toString)
                    Td(sortedSummaries.compactMap { $0.minInventory }.reduce(0, +).toString)
                    if showShortage {
                        Td(sortedSummaries.compactMap { $0.shortageUnits }.reduce(0, +).toString)
                    }
                    if showLastSoldAt {
                        Td(latestSoldAt > 0
                            ? self.inventoryDateTime(latestSoldAt)
                            : "Sin ventas")
                    }
                    if showActivity {
                        Td(sortedSummaries.map { summary in
                            let key = self.inventoryActivityKey(
                                productId: summary.productId,
                                storeId: summary.storeId
                            )
                            return movementCountByProductAndStore[key] ?? 0
                        }.reduce(0, +).toString)
                        Td("")
                    }
                    Td(totalCost.formatMoney)
                    Td(totalRetail.formatMoney)
                    if cardexRange != nil {
                        Td("")
                    }
                }
            })

            if hasSectionHeader {
                sectionContainer.appendChild(table)
                resultDiv.appendChild(sectionContainer)
            }
            else {
                resultDiv.appendChild(table)
            }

            asyncAddInventorySummaryRows(
                renderId: renderId,
                summaries: sortedSummaries,
                tableBody: tableBody,
                storeReference: storeReference,
                lastActivityByProduct: lastActivityByProduct,
                lastActivityByProductAndStore: lastActivityByProductAndStore,
                movementCountByProductAndStore: movementCountByProductAndStore,
                showStore: showStore,
                usePOCPrices: usePOCPrices,
                showActivity: showActivity,
                showShortage: showShortage,
                showLastSoldAt: showLastSoldAt,
                cardexRange: cardexRange
            )
        }

        private func asyncAddInventorySummaryRows(
            renderId: UUID,
            summaries: [CustPOCComponents.AuditInventorySummary],
            tableBody: TBody,
            storeReference: [UUID: String],
            lastActivityByProduct: [UUID: Int64],
            lastActivityByProductAndStore: [String: Int64],
            movementCountByProductAndStore: [String: Int],
            showStore: Bool,
            usePOCPrices: Bool,
            showActivity: Bool,
            showShortage: Bool,
            showLastSoldAt: Bool,
            cardexRange: (startAt: Int64, endAt: Int64)?,
            index: Int = 0
        ) {
            guard renderId == inventoryRenderId,
                  summaries.indices.contains(index) else {
                return
            }

            Dispatch.asyncAfter(index == 0 ? 0.01 : 0.015) {
                guard renderId == self.inventoryRenderId,
                      summaries.indices.contains(index) else {
                    return
                }

                let summary = summaries[index]
                let poc = self.pocRefrence[summary.productId]
                let key = self.inventoryActivityKey(
                    productId: summary.productId,
                    storeId: summary.storeId
                )
                let lastActivity = lastActivityByProductAndStore[key]
                    ?? lastActivityByProduct[summary.productId]
                let status: String
                if summary.isZeroInventory {
                    status = "Agotado"
                }
                else if summary.isLowInventory {
                    status = "Bajo"
                }
                else {
                    status = "Disponible"
                }
                let brandAndModel = "\(poc?.brand ?? "") \(poc?.model ?? "")".purgeSpaces
                let cost: Int64? = usePOCPrices ? poc?.cost : summary.currentCostValue
                let retail: Int64? = usePOCPrices ? poc?.pricea : summary.currentRetailValue

                tableBody.appendChild(Tr {
                    if showStore {
                        Td(self.inventoryStoreName(id: summary.storeId, reference: storeReference))
                    }
                    ProductManagerView.AuditView.productManagerCell(pocId: summary.productId)
                    Td(poc?.upc.isEmpty == false ? poc?.upc ?? "N/D" : "N/D")
                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
                    Td(brandAndModel.isEmpty ? "N/D" : brandAndModel)
                    Td(status)
                        .color(summary.isLowInventory || summary.isZeroInventory ? .yellowTC : .white)
                    Td(summary.currentStock.toString)
                    Td(summary.minInventory?.toString ?? "N/D")
                    if showShortage {
                        Td(summary.shortageUnits?.toString ?? "N/D")
                    }
                    if showLastSoldAt {
                        Td(summary.lastSoldAt > 0
                            ? self.inventoryDateTime(summary.lastSoldAt)
                            : "Sin ventas")
                    }
                    if showActivity {
                        Td((movementCountByProductAndStore[key] ?? 0).toString)
                        Td(self.inventoryDateTime(lastActivity))
                    }
                    Td(cost?.formatMoney ?? "N/D")
                    Td(retail?.formatMoney ?? "N/D")
                    if let cardexRange {
                        Td {
                            if let poc, let storeId = summary.storeId {
                                CardexGraphView.graphButton {
                                    self.loadCardexGraph(
                                        poc: poc,
                                        storeId: storeId,
                                        storeName: self.inventoryStoreName(
                                            id: storeId,
                                            reference: storeReference
                                        ),
                                        startAt: cardexRange.startAt,
                                        endAt: cardexRange.endAt
                                    )
                                }
                            }
                            else {
                                Span("N/D")
                                    .color(.gray)
                            }
                        }
                    }
                }
                .backgroundColor(index.isEven ? .backGroundRow : .transparent))

                self.asyncAddInventorySummaryRows(
                    renderId: renderId,
                    summaries: summaries,
                    tableBody: tableBody,
                    storeReference: storeReference,
                    lastActivityByProduct: lastActivityByProduct,
                    lastActivityByProductAndStore: lastActivityByProductAndStore,
                    movementCountByProductAndStore: movementCountByProductAndStore,
                    showStore: showStore,
                    usePOCPrices: usePOCPrices,
                    showActivity: showActivity,
                    showShortage: showShortage,
                    showLastSoldAt: showLastSoldAt,
                    cardexRange: cardexRange,
                    index: index + 1
                )
            }
        }

        func loadCardexGraph(
            poc: CustPOCQuick,
            storeId: UUID,
            storeName: String,
            startAt: Int64,
            endAt: Int64
        ) {
            let requestId = UUID()
            cardexGraphRequestId = requestId

            loadingView.show()

            API.custPOCV1.cardexDetail(
                relationId: storeId,
                pocId: poc.id,
                startAt: startAt,
                endAt: endAt
            ) { response in
                guard requestId == self.cardexGraphRequestId else {
                    return
                }

                loadingView.hide()

                guard let response else {
                    showError(.comunicationError, "No se pudo obtener el Cardex del producto.")
                    return
                }

                guard response.status == .ok else {
                    showError(.generalError, response.msg)
                    return
                }

                guard let movements = response.data?.cardexs, !movements.isEmpty else {
                    showError(.generalError, "No se encontraron movimientos de Cardex para este producto en el periodo seleccionado.")
                    return
                }

                addToDom(CardexGraphView(
                    poc: poc,
                    movements: movements,
                    storeName: storeName,
                    startAt: startAt,
                    endAt: endAt
                ))
            }
        }

        fileprivate func inventoryMetric(
            title: String,
            value: String,
            detail: String
        ) -> Div {
            Div {
                Div(title)
                    .color(.gray)
                    .fontSize(12.px)
                Div(value)
                    .color(.yellowTC)
                    .fontSize(18.px)
                    .fontWeight(.bold)
                Div(detail)
                    .color(.white)
                    .fontSize(11.px)
            }
            .class(Class(TCCrystalSurfaceClass.auditMetric))
            .custom("flex", "1 1 150px")
            .padding(all: 10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlackDark)
        }

        fileprivate func renderInventoryReportIntroduction(
            type: InventoryAuditTypes,
            payload: CustPOCComponents.AuditsResponse,
            requestedStartAt: Int64?,
            requestedEndAt: Int64?
        ) {
            let inventorySummaries = payload.inventorySummaries ?? []
            let salesSummaries = payload.salesSummaries ?? []
            let detailObjects = payload.items + payload.subItems
            let soldItems = detailObjects.flatMap { $0.items }.filter { $0.soldAt != nil }

            let productIds = Set(
                payload.pocs.map { $0.id }
                + detailObjects.map { $0.id }
                + payload.zeroItems.map { $0.id }
                + payload.cardex.map { $0.pocId }
            )
            let inventoryRecordCount = inventorySummaries.isEmpty
                ? payload.items.count
                : inventorySummaries.count
            let currentUnits = inventorySummaries.isEmpty
                ? payload.items.map { $0.currentStock ?? Int64($0.items.count) }.reduce(0, +)
                : inventorySummaries.map { $0.currentStock }.reduce(0, +)
            let lowCount = inventorySummaries.isEmpty
                ? payload.lowinventory.count
                : inventorySummaries.filter { $0.isLowInventory && !$0.isZeroInventory }.count
            let zeroCount = inventorySummaries.isEmpty
                ? payload.zeroItems.count
                : inventorySummaries.filter { $0.isZeroInventory }.count
            let currentCost = inventorySummaries.map { $0.currentCostValue }.reduce(0, +)
            let currentRetail = inventorySummaries.map { $0.currentRetailValue }.reduce(0, +)

            let soldUnits = salesSummaries.isEmpty
                ? Int64(soldItems.count)
                : salesSummaries.map { $0.units }.reduce(0, +)
            let transactionCount = salesSummaries.isEmpty
                ? Int64(soldItems.count)
                : salesSummaries.map { $0.transactionCount }.reduce(0, +)
            let grossSales = salesSummaries.isEmpty
                ? soldItems.map { $0.price }.reduce(0, +)
                : salesSummaries.map { $0.grossSales }.reduce(0, +)
            let costOfGoods = salesSummaries.isEmpty
                ? soldItems.map { $0.cost }.reduce(0, +)
                : salesSummaries.map { $0.costOfGoods }.reduce(0, +)

            var storeIds = Set((payload.stores ?? []).map { $0.id })
            payload.items.compactMap { $0.storeid }.forEach { storeIds.insert($0) }
            payload.subItems.compactMap { $0.storeid }.forEach { storeIds.insert($0) }
            payload.zeroItems.compactMap { $0.storeid }.forEach { storeIds.insert($0) }

            let requestedFrom: Int64? = (requestedStartAt ?? 0) > 0 ? requestedStartAt : nil
            let requestedTo: Int64? = (requestedEndAt ?? 0) > 0 ? requestedEndAt : nil
            let activityFrom = payload.activityFrom ?? requestedFrom ?? salesSummaries.map { $0.firstSoldAt }.min()
            let activityTo = payload.activityTo ?? requestedTo ?? salesSummaries.map { $0.lastSoldAt }.max()
            let reportDays: Int = {
                guard let activityFrom, let activityTo else { return 1 }
                return max(1, Int(ceil(Double(max(activityTo - activityFrom, 1)) / 86_400.0)))
            }()
            let soldPerDay = Double(soldUnits) / Double(reportDays)
            let soldPerProductPerDay = soldPerDay / Double(max(productIds.count, 1))

            let title: String
            switch type {
            case .byStore:
                title = "🏬 Inventario por tienda"
            case .byDepartement:
                title = "🗂️ Inventario por departamento"
            case .byProduct:
                title = "📦 Movimientos por producto"
            case .bySales:
                title = "📈 Ventas por tienda"
            case .bySalesConcession:
                title = "🤝 Ventas por tienda y concesión"
            case .byCustomerSales:
                title = "👥 Ventas por cliente"
            case .byUserSales:
                title = "🧑‍💼 Ventas por usuario"
            case .byConcession:
                title = "🏷️ Inventario en concesión"
            case .general, .lowInvetory, .fastAndFurios:
                title = "📊 \(type.description)"
            }

            let period: String
            if let activityFrom, let activityTo {
                period = "\(inventoryDateTime(activityFrom)) — \(inventoryDateTime(activityTo))"
            }
            else {
                period = "No especificado"
            }

            resultDiv.appendChild(ProductManagerView.AuditView.reportHeader(
                title: title,
                subtitle: type.helpText,
                context: "Alcance: \(inventoryReportScope(payload: payload)) • Periodo: \(period) • Generado: \(inventoryDateTime(payload.generatedAt))"
            ))

            let metrics = Div()
                .class(Class(TCCrystalSurfaceClass.auditMetricGrid))

            switch type {
            case .bySales, .bySalesConcession, .byCustomerSales, .byUserSales:
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Productos vendidos",
                    value: productIds.count.toString,
                    detail: "Con datos en el reporte"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Unidades vendidas",
                    value: soldUnits.toString,
                    detail: "Durante el periodo"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Operaciones",
                    value: transactionCount.toString,
                    detail: "Transacciones recibidas"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Vendido / día",
                    value: String(format: "%.2f", soldPerProductPerDay),
                    detail: "Promedio por producto"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Venta bruta",
                    value: grossSales.formatMoney,
                    detail: "Importe vendido"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Costo de venta",
                    value: costOfGoods.formatMoney,
                    detail: "Costo de lo vendido"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: "Margen bruto",
                    value: (grossSales - costOfGoods).formatMoney,
                    detail: "Venta menos costo"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: type == .byCustomerSales ? "Clientes" : (type == .byUserSales ? "Usuarios" : "Tiendas"),
                    value: type == .byCustomerSales ? payload.accounts.count.toString : (type == .byUserSales ? (payload.users?.count ?? 0).toString : storeIds.count.toString),
                    detail: "Incluidos en el reporte"
                ))

            case .byProduct:
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Productos", value: productIds.count.toString, detail: "Con datos recibidos"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Movimientos", value: payload.cardex.count.toString, detail: "Registros de Cardex"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Unidades actuales", value: currentUnits.toString, detail: "Existencia combinada"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Unidades vendidas", value: soldUnits.toString, detail: "Durante el periodo"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Vendido / día", value: String(format: "%.2f", soldPerProductPerDay), detail: "Promedio por producto"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Tiendas", value: storeIds.count.toString, detail: "Incluidas en el reporte"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Valor costo", value: currentCost.formatMoney, detail: "Existencia actual"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Valor venta", value: currentRetail.formatMoney, detail: "Existencia actual"))

            case .byStore, .byDepartement, .byConcession:
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Productos", value: productIds.count.toString, detail: "Con datos recibidos"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Registros", value: inventoryRecordCount.toString, detail: "Inventario agrupado"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Unidades actuales", value: currentUnits.toString, detail: "Existencia combinada"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Inventario bajo", value: lowCount.toString, detail: "Sobre cero y bajo mínimo"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Agotados", value: zeroCount.toString, detail: "Sin existencia"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(
                    title: type == .byDepartement ? "Departamentos" : (type == .byConcession ? "Cuentas" : "Tiendas"),
                    value: type == .byDepartement ? (payload.departments?.count ?? 0).toString : (type == .byConcession ? payload.accounts.count.toString : storeIds.count.toString),
                    detail: "Incluidos en el reporte"
                ))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Valor costo", value: currentCost.formatMoney, detail: "Existencia actual"))
                metrics.appendChild(ProductManagerView.AuditView.reportMetric(title: "Valor venta", value: currentRetail.formatMoney, detail: "Existencia actual"))

            case .general, .lowInvetory, .fastAndFurios:
                break
            }

            resultDiv.appendChild(metrics)
        }

        fileprivate func inventoryReportScope(
            payload: CustPOCComponents.AuditsResponse
        ) -> String {
            let storeNames = (payload.stores ?? []).map { $0.name }.sorted()

            if storeNames.count == 1 {
                return storeNames[0]
            }
            if storeNames.count > 1 {
                return "\(storeNames.count) tiendas: \(storeNames.joined(separator: ", "))"
            }

            switch payload.reportMode {
            case .selectedStore:
                return "Tienda seleccionada"
            case .autoSelectedStore:
                return "Tienda asignada"
            case .multiStore:
                return "Varias tiendas"
            case .general:
                return "General"
            case .concessionAccount:
                return "Cuenta en concesión"
            case .allConcessionAccounts:
                return "Todas las cuentas en concesión"
            case nil:
                return "No disponible"
            }
        }

        fileprivate func inventoryActivityRange(
            payload: CustPOCComponents.AuditsResponse
        ) -> String {
            guard let from = payload.activityFrom, let to = payload.activityTo else {
                return "Últimos 90 días"
            }
            return "\(inventoryDateTime(from)) — \(inventoryDateTime(to))"
        }

        fileprivate func inventoryDateTime(_ timestamp: Int64?) -> String {
            guard let timestamp else {
                return "N/D"
            }

            let date = getDate(timestamp)
            return "\(date.formatedShort) \(date.time)"
        }

        fileprivate func inventoryDepartmentName(
            id: UUID?,
            reference: [UUID: String]
        ) -> String {
            guard let id else {
                return "Sin departamento"
            }
            return reference[id] ?? "Departamento no disponible"
        }

        fileprivate func inventoryStoreName(
            id: UUID?,
            reference: [UUID: String]
        ) -> String {
            guard let id else {
                return "Todas"
            }
            return reference[id] ?? "Tienda no disponible"
        }

        fileprivate func inventoryActivityKey(
            productId: UUID,
            storeId: UUID?
        ) -> String {
            "\(productId.uuidString)|\(storeId?.uuidString ?? "")"
        }

        fileprivate func renderGenral(
            payload: CustPOCComponents.AuditsResponse,
            renderId: UUID
        ) {
            guard renderId == inventoryRenderId else {
                return
            }

            guard let inventorySummaries = payload.inventorySummaries else {
                renderGeneralCatalogSummary(payload: payload)
                return
            }

            guard !inventorySummaries.isEmpty else {
                resultDiv.appendChild(
                    Table().noResult(
                        label: "No se encontraron existencias ni ventas durante los últimos 90 días."
                    )
                )
                return
            }

            var storeReference: [UUID: String] = [:]
            payload.stores?.forEach { store in
                storeReference[store.id] = store.name
            }
            stores.forEach { id, store in
                storeReference[id] = store.name
            }

            var lastActivityByProduct: [UUID: Int64] = [:]
            var lastActivityByProductAndStore: [String: Int64] = [:]
            var movementCountByProductAndStore: [String: Int] = [:]

            payload.cardex.forEach { movement in
                if movement.createdAt > (lastActivityByProduct[movement.pocId] ?? 0) {
                    lastActivityByProduct[movement.pocId] = movement.createdAt
                }

                let key = inventoryActivityKey(
                    productId: movement.pocId,
                    storeId: movement.relationId
                )
                movementCountByProductAndStore[key, default: 0] += 1

                if movement.createdAt > (lastActivityByProductAndStore[key] ?? 0) {
                    lastActivityByProductAndStore[key] = movement.createdAt
                }
            }

            let inventoryRecordCount = inventorySummaries.count
            let productsWithStock = inventorySummaries.filter { $0.currentStock > 0 }.count
            let zeroInventoryCount = inventorySummaries.filter { $0.isZeroInventory }.count
            let lowInventoryCount = inventorySummaries.filter {
                $0.isLowInventory && !$0.isZeroInventory
            }.count
            let currentUnits = inventorySummaries.map { $0.currentStock }.reduce(0, +)
            let currentCostValue = inventorySummaries.map { $0.currentCostValue }.reduce(0, +)
            let currentRetailValue = inventorySummaries.map { $0.currentRetailValue }.reduce(0, +)
            let activeProductCount = payload.pocs.filter { $0.status == .active }.count
            let suspendedProductCount = payload.pocs.count - activeProductCount

            resultDiv.appendChild(Div {
                H1("📊 Estado general del inventario")
                    .color(.yellowTC)
                    .marginBottom(3.px)

                Div("Existencias actuales y productos con actividad durante los últimos 90 días")
                    .color(.gray)
                    .fontSize(13.px)

                Div {
                    Span("Alcance: ")
                        .color(.gray)
                    Span(self.inventoryReportScope(payload: payload))
                        .color(.white)

                    Span("  •  Periodo de actividad: ")
                        .color(.gray)
                    Span(self.inventoryActivityRange(payload: payload))
                        .color(.white)

                    Span("  •  Generado: ")
                        .color(.gray)
                    Span(self.inventoryDateTime(payload.generatedAt))
                        .color(.white)
                }
                .fontSize(13.px)
                .marginTop(5.px)
            }
            .padding(all: 12.px)
            .marginBottom(10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .class(Class(TCCrystalSurfaceClass.auditReportHeader)))

            resultDiv.appendChild(Div {
                self.inventoryMetric(
                    title: "Productos reportados",
                    value: payload.pocs.count.toString,
                    detail: "\(activeProductCount) activos • \(suspendedProductCount) suspendidos"
                )
                self.inventoryMetric(
                    title: "Registros con inventario",
                    value: productsWithStock.toString,
                    detail: "Producto / tienda"
                )
                self.inventoryMetric(
                    title: "Unidades actuales",
                    value: currentUnits.toString,
                    detail: "Existencia combinada"
                )
                self.inventoryMetric(
                    title: "Registros bajos",
                    value: lowInventoryCount.toString,
                    detail: "Producto / tienda"
                )
                self.inventoryMetric(
                    title: "Registros agotados",
                    value: zeroInventoryCount.toString,
                    detail: "Producto / tienda"
                )
                self.inventoryMetric(
                    title: "Tiendas incluidas",
                    value: (payload.stores?.count ?? storeReference.count).toString,
                    detail: "Alcance del reporte"
                )
                self.inventoryMetric(
                    title: "Valor costo",
                    value: currentCostValue.formatMoney,
                    detail: "Existencia actual"
                )
                self.inventoryMetric(
                    title: "Valor venta",
                    value: currentRetailValue.formatMoney,
                    detail: "Existencia actual"
                )
            }
            .display(.flex)
            .custom("flex-wrap", "wrap")
            .custom("gap", "8px")
            .class(Class(TCCrystalSurfaceClass.auditMetricGrid))
            .marginBottom(10.px))

            if productsWithStock == 0 {
                resultDiv.appendChild(Div {
                    Span("⚠️ ")
                    Span("No hay existencias registradas en \(self.inventoryReportScope(payload: payload)). ")
                        .fontWeight(.bold)
                    Span("Los \(inventoryRecordCount) registros aparecen porque tuvieron ventas durante los últimos 90 días.")
                }
                .color(.white)
                .padding(all: 10.px)
                .marginBottom(10.px)
                .borderRadius(7.px)
                .backgroundColor(.grayBlackDark))
            }

            if inventorySummaries.allSatisfy({ ($0.minInventory ?? 0) == 0 }) {
                resultDiv.appendChild(Div {
                    Span("ℹ️ ")
                    Span("Todos los productos tienen inventario mínimo en cero. ")
                        .fontWeight(.bold)
                    Span("Configure un mínimo mayor a cero para que el reporte pueda identificar inventario bajo antes de que el producto se agote.")
                }
                .color(.white)
                .padding(all: 10.px)
                .marginBottom(10.px)
                .borderRadius(7.px)
                .backgroundColor(.grayBlackDark))
            }

            let hasInventoryAging = inventorySummaries.contains {
                $0.age0To30 != nil ||
                $0.age31To60 != nil ||
                $0.age61To90 != nil ||
                $0.ageOver90 != nil
            }

            if currentUnits > 0 && hasInventoryAging {
                let age0To30 = inventorySummaries.compactMap { $0.age0To30 }.reduce(0, +)
                let age31To60 = inventorySummaries.compactMap { $0.age31To60 }.reduce(0, +)
                let age61To90 = inventorySummaries.compactMap { $0.age61To90 }.reduce(0, +)
                let ageOver90 = inventorySummaries.compactMap { $0.ageOver90 }.reduce(0, +)

                resultDiv.appendChild(
                    H2("Antigüedad de las unidades")
                        .color(.yellowTC)
                )

                resultDiv.appendChild(Div {
                    self.inventoryMetric(
                        title: "0–30 días",
                        value: age0To30.toString,
                        detail: "Unidades recientes"
                    )
                    self.inventoryMetric(
                        title: "31–60 días",
                        value: age31To60.toString,
                        detail: "Unidades en inventario"
                    )
                    self.inventoryMetric(
                        title: "61–90 días",
                        value: age61To90.toString,
                        detail: "Unidades en inventario"
                    )
                    self.inventoryMetric(
                        title: "Más de 90 días",
                        value: ageOver90.toString,
                        detail: "Revisar rotación"
                    )
                }
                .display(.flex)
                .custom("flex-wrap", "wrap")
                .custom("gap", "8px")
                .marginBottom(10.px))
            }

            renderInventoryStoreSummary(
                payload: payload,
                storeReference: storeReference
            )

            resultDiv.appendChild(
                H2("Detalle agrupado por producto y tienda")
                    .color(.yellowTC)
                    .marginTop(16.px)
            )

            let cardexStartAt = payload.activityFrom ?? (getNow() - (90 * 24 * 60 * 60))
            let cardexEndAt = payload.activityTo ?? getNow()

            renderInventoryDepartment(
                renderId: renderId,
                departmentId: nil,
                summaries: inventorySummaries,
                departmentReference: [:],
                storeReference: storeReference,
                lastActivityByProduct: lastActivityByProduct,
                lastActivityByProductAndStore: lastActivityByProductAndStore,
                movementCountByProductAndStore: movementCountByProductAndStore,
                showDepartmentHeader: false,
                showActivity: false,
                showShortage: false,
                showLastSoldAt: true,
                cardexRange: (cardexStartAt, cardexEndAt)
            )
        }

        fileprivate func renderGeneralCatalogSummary(
            payload: CustPOCComponents.AuditsResponse
        ) {
            let products = payload.pocs

            guard !products.isEmpty else {
                resultDiv.appendChild(
                    Table().noResult(
                        label: "No se encontraron productos ni datos de inventario para este reporte."
                    )
                )
                return
            }

            let activeProducts = products.filter { $0.status == .active }
            let suspendedProducts = products.filter { $0.status == .suspended }
            let productsWithUPC = products.filter { !$0.upc.isEmpty }
            let productsWithImage = products.filter { !$0.avatar.isEmpty }
            let productsWithPrice = products.filter { $0.pricea > 0 }
            let productsByBrand = Dictionary(grouping: products) { product in
                product.brand.isEmpty ? "Sin marca" : product.brand
            }
            let sortedBrands = productsByBrand.keys.sorted { lhs, rhs in
                let leftCount = productsByBrand[lhs]?.count ?? 0
                let rightCount = productsByBrand[rhs]?.count ?? 0

                if leftCount == rightCount {
                    return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
                }
                return leftCount > rightCount
            }

            resultDiv.appendChild(Div {
                H1("Catálogo general de productos")
                    .color(.yellowTC)
                    .marginBottom(3.px)

                Div("El servicio no incluyó existencias ni actividad de inventario. Se muestran los datos disponibles del catálogo.")
                    .color(.gray)
                    .fontSize(13.px)
            }
            .padding(all: 12.px)
            .marginBottom(10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlack)
            .class(Class(TCCrystalSurfaceClass.auditReportHeader)))

            resultDiv.appendChild(Div {
                self.inventoryMetric(
                    title: "Productos",
                    value: products.count.toString,
                    detail: "Total del catálogo"
                )
                self.inventoryMetric(
                    title: "Activos",
                    value: activeProducts.count.toString,
                    detail: "Disponibles para operar"
                )
                self.inventoryMetric(
                    title: "Suspendidos",
                    value: suspendedProducts.count.toString,
                    detail: "Fuera de operación"
                )
                self.inventoryMetric(
                    title: "Marcas",
                    value: productsByBrand.count.toString,
                    detail: "Incluye Sin marca"
                )
                self.inventoryMetric(
                    title: "Con POC/SKU/UPC",
                    value: productsWithUPC.count.toString,
                    detail: "Código configurado"
                )
                self.inventoryMetric(
                    title: "Con imagen",
                    value: productsWithImage.count.toString,
                    detail: "Avatar configurado"
                )
                self.inventoryMetric(
                    title: "Con precio A",
                    value: productsWithPrice.count.toString,
                    detail: "Precio configurado"
                )
            }
            .display(.flex)
            .custom("flex-wrap", "wrap")
            .custom("gap", "8px")
            .class(Class(TCCrystalSurfaceClass.auditMetricGrid))
            .marginBottom(10.px))

            resultDiv.appendChild(Div {
                Span("Información no disponible: ")
                    .fontWeight(.bold)
                Span("existencias, mínimos, agotados y valor actual del inventario.")
            }
            .color(.white)
            .padding(all: 10.px)
            .marginBottom(10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlackDark))

            resultDiv.appendChild(
                H2("Resumen del catálogo por marca")
                    .color(.yellowTC)
            )

            let table = Table {
                THead {
                    Tr {
                        Td("Marca")
                        Td("Productos")
                        Td("Activos")
                        Td("Suspendidos")
                        Td("Costo promedio")
                        Td("Precio A promedio")
                    }
                }
            }
            .width(100.percent)
            .color(.white)

            var alternateRow = true
            sortedBrands.forEach { brand in
                guard let brandProducts = productsByBrand[brand], !brandProducts.isEmpty else {
                    return
                }

                let activeCount = brandProducts.filter { $0.status == .active }.count
                let suspendedCount = brandProducts.filter { $0.status == .suspended }.count
                let averageCost = brandProducts.map { $0.cost }.reduce(0, +) / Int64(brandProducts.count)
                let averagePrice = brandProducts.map { $0.pricea }.reduce(0, +) / Int64(brandProducts.count)

                table.appendChild(Tr {
                    Td(brand)
                    Td(brandProducts.count.toString)
                    Td(activeCount.toString)
                    Td(suspendedCount.toString)
                    Td(averageCost.formatMoney)
                    Td(averagePrice.formatMoney)
                }
                .backgroundColor(alternateRow ? .backGroundRow : .transparent))

                alternateRow = !alternateRow
            }

            let averageCatalogCost = products.map { $0.cost }.reduce(0, +) / Int64(products.count)
            let averageCatalogPrice = products.map { $0.pricea }.reduce(0, +) / Int64(products.count)

            table.appendChild(TFoot {
                Tr {
                    Td("Total / promedio")
                    Td(products.count.toString)
                    Td(activeProducts.count.toString)
                    Td(suspendedProducts.count.toString)
                    Td(averageCatalogCost.formatMoney)
                    Td(averageCatalogPrice.formatMoney)
                }
            })

            resultDiv.appendChild(table)
        }

        fileprivate func renderLegacyGeneralCatalog(
            payload: CustPOCComponents.AuditsResponse,
            renderId: UUID
        ) {

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
                    
                    asyncAddAuditProduct(
                        renderId: renderId,
                        products: pocs,
                        container: innerView
                    )
                    
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
                
                asyncAddAuditProduct(
                    renderId: renderId,
                    products: suspended,
                    container: innerView
                )
                
                resultDiv.appendChild(innerView)
                
            }
            
        }

        private func asyncAddAuditProduct(
            renderId: UUID,
            products: [CustPOCQuick],
            container: Div,
            index: Int = 0
        ) {
            guard renderId == inventoryRenderId,
                  products.indices.contains(index) else {
                return
            }

            let product = products[index]
            let view = SearchItemPOCView(
                searchTerm: "",
                poc: .init(
                    id: product.id,
                    upc: product.upc,
                    name: product.name,
                    brand: product.brand,
                    model: product.model,
                    price: product.pricea,
                    avatar: product.avatar,
                    units: nil,
                    reqSeries: product.reqSeries
                )
            ) { _, _ in
                addToDom(ManagePOC(
                    leveltype: .all,
                    levelid: nil,
                    levelName: "",
                    pocid: product.id,
                    titleText: "",
                    quickView: false
                ) { _, _, _, _, _, _, _, _, _ in
                } deleted: {
                })
            }

            guard renderId == inventoryRenderId else {
                view.remove()
                return
            }

            container.appendChild(view)

            Dispatch.asyncAfter(0.01) {
                guard renderId == self.inventoryRenderId else {
                    return
                }

                self.asyncAddAuditProduct(
                    renderId: renderId,
                    products: products,
                    container: container,
                    index: index + 1
                )
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
                    .src("/skyline/media/excel.png")
                    .marginRight(24.px)
                    .paddingTop(7.px)
                    .float(.right)
                    .width(36.px)
                    .onClick {
                        self.download(.csv, name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
                    }

                
                Img()
                    .src("/skyline/media/pdf.png")
                    .marginRight(24.px)
                    .paddingTop(7.px)
                    .float(.right)
                    .width(36.px)
                    .onClick {
                        self.download(pdf, name: "inventario_existente_\(store?.name ?? "")_\(Date().cronStamp).csv", item: catchItems)
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
                
                let tableCardex = TBody()
                
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

                                        OrderCatchControler.shared.loadFolio(orderid: item.channelId) { account, order, notes, payments, charges, pocs, files, contracts, equipments, rentals, transferOrder, orderHighPriorityNote, accountHighPriorityNote, tasks, route, loadFromCatch in
                                            
                                            let accoutOverview = AccoutOverview (
                                                id: .id(order.custAcct)
                                            )
                                            
                                            accoutOverview.loadOrder(
                                                account: account,
                                                order: order,
                                                notes: notes,
                                                payments: payments,
                                                charges: charges,
                                                pocs: pocs,
                                                files: files,
                                                contracts: contracts,
                                                equipments: equipments,
                                                rentals: rentals,
                                                transferOrder: transferOrder,
                                                orderHighPriorityNote: orderHighPriorityNote,
                                                accountHighPriorityNote: accountHighPriorityNote,
                                                tasks: tasks,
                                                orderRoute: route,
                                                loadFromCatch: loadFromCatch
                                            )
                                            
                                            addToDom(accoutOverview)
                                            
                                            minViewAcctRefrence[order.custAcct] = accoutOverview
                                            
                                        }

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
                
                let timeTable = Table {
                    THead{
                        Tr{
                            ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: poc.id)
                            Td(poc.upc)
                            ProductManagerView.AuditView.productDescriptionCell(poc.name)
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
            
            let table = Table {
                THead{
                    Tr{
                        ProductManagerView.AuditView.productManagerHeaderCell()
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
                    ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                    Td(poc?.upc ?? "N/D")
                    ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
                        .src("/skyline/media/excel.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                .csv,
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                item: payload.items,
                                type: .bySales,
                                title: "Venta por Día \(getDate(startAtUTS).formatedLong) - \(getDate(endAtUTS).formatedLong)"
                            )
                        }

                    Img()
                        .src("/skyline/media/pdf.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                .pdf,
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                item: payload.items,
                                type: .bySales,
                                title: "Venta por Día \(getDate(startAtUTS).formatedLong) - \(getDate(endAtUTS).formatedLong)"
                            )
                        }
                    
                    Div().clear(.both)
                    
                })
                
                self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                
                let table = Table {
                    THead{
                        Tr{
                            Td("Date")
                            ProductManagerView.AuditView.productManagerHeaderCell()
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
                
                let tableBody = TBody().hidden($sectionAIsHidden)
                
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
                                                    ProductManagerView.AuditView.productManagerCell(pocId: poc.id)
                                                    Td(poc.upc)
                                                    ProductManagerView.AuditView.productDescriptionCell(poc.name)
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
                    
                    let tableBody = TBody().hidden($sectionBIsHidden)
                    
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
                            .src("/skyline/media/excel.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .csv,
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Img()
                            .src("/skyline/media/pdf.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .pdf,
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    let table = Table {
                        THead {
                            Tr{
                                ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                            Td(poc?.upc ?? "N/D")
                            ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
                                        
                                        addToDom(InventoryDetail(
                                            poc: poc,
                                            item: item
                                        ))
                                        
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
                            ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                            Td(poc?.upc ?? "N/D")
                            ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
                        .src("/skyline/media/excel.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                .csv,
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                item: payload.items,
                                type: .bySales,
                                title: "Venta por Día \(getDate(startAtUTS).formatedLong) - \(getDate(endAtUTS).formatedLong)"
                            )
                        }

                    Img()
                        .src("/skyline/media/pdf.png")
                        .marginRight(24.px)
                        .paddingTop(7.px)
                        .float(.right)
                        .width(36.px)
                        .onClick {
                            self.download(
                                .pdf,
                                name: "ventas_por_dia_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-")))",
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
                            ProductManagerView.AuditView.productManagerHeaderCell()
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
                                                    ProductManagerView.AuditView.productManagerCell(pocId: poc.id)
                                                    Td(poc.upc)
                                                    ProductManagerView.AuditView.productDescriptionCell(poc.name)
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
                            .src("/skyline/media/excel.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .csv,
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                            }
                        
                        Img()
                            .src("/skyline/media/pdf.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .pdf,
                                    name: "inventario_existente_\( (store?.name ?? "").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( (store?.name ?? ""))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    let table = Table {
                        THead {
                            Tr{
                                ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                            Td(poc?.upc ?? "N/D")
                            ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
                                        
                                        addToDom(InventoryDetail(
                                            poc: poc,
                                            item: item
                                        ))
                                        
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
                    
                    let tableBody = TBody().hidden($sectionBIsHidden)
                    
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
                            .src("/skyline/media/excel.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .csv,
                                    name: "inventario_existente_\( ("\(account.businessName) \(account.firstName) \(account.lastName)").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( ("\(account.businessName) \(account.firstName) \(account.lastName)"))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Img()
                            .src("/skyline/media/pdf.png")
                            .marginRight(24.px)
                            .paddingTop(7.px)
                            .float(.right)
                            .width(36.px)
                            .onClick {
                                self.download(
                                    .pdf,
                                    name: "inventario_existente_\( ("\(account.businessName) \(account.firstName) \(account.lastName)").replace(from: " ", to: "_") )_\(getDate(startAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))_al_\(getDate(endAtUTS).formatedLong.replace(from: " ", to: "-").replace(from: "/", to: "-"))",
                                    item: itemsSorted,
                                    type: .bySales,
                                    title: "Inventario Existente - \( ("\(account.businessName) \(account.firstName) \(account.lastName)"))_\(getDate(startAtUTS).formatedLong) al \(getDate(endAtUTS).formatedLong)"
                                )
                                
                            }
                        
                        Div().clear(.both)
                        
                    })
                    
                    self.resultDiv.appendChild(Div().height(3.px).clear(.both))
                    
                    let table = Table {
                        THead {
                            Tr{
                                ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                            Td(poc?.upc ?? "N/D")
                            ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
                                        
                                        addToDom(InventoryDetail(
                                            poc: poc,
                                            item: item
                                        ))
                                        
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
                            ProductManagerView.AuditView.productManagerHeaderCell()
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
                            ProductManagerView.AuditView.productManagerCell(pocId: item.id)
                            Td(poc?.upc ?? "N/D")
                            ProductManagerView.AuditView.productDescriptionCell(poc?.name ?? "N/D")
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
            
            loadingView.show()
            
            API.custPOCV1.getTransferInventory(identifier: .id(controlId)) { resp in
                
                loadingView.hide()
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
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
        

        override func didRemoveFromDOM() {
            inventoryRenderId = UUID()
            super.didRemoveFromDOM()
            $reportType.removeAllListeners()
            $auditTypeListener.removeAllListeners()
            $storeSelectListener.removeAllListeners()
            $userSelectListener.removeAllListeners()
            $departmentSelectListener.removeAllListeners()
            $dateSelectListener.removeAllListeners()
            $startAt.removeAllListeners()
            $endAt.removeAllListeners()
            $startAtLabel.removeAllListeners()
            $endAtLabel.removeAllListeners()
            $parsablePOCs.removeAllListeners()
        }
    }

}
extension ProductManagerView.AuditView.Inventory {
    
    enum RenderBySaleType {
        case general
        case byCustomer
        case byConcesion
    }
    
    enum DocumentType {

        case csv

        case pdf

    }

}
