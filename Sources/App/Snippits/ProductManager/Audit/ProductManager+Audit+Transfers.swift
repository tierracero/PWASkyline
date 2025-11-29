//
//  ProductManager+Audit+Transfers.swift
//  
//
//  Created by Victor Cantu on 10/5/24.
//
import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class Transfers: Div {
        
        override class var name: String { "div" }
        
        @State var fromStoreSelectListener = ""
        
        lazy var fromStoreSelect = Select(self.$fromStoreSelectListener)
            .class(.textFiledBlackDark)
            .fontSize(22.px)
            .width(230.px)
            .height(34.px)
        
        @State var toStoreSelectListener = ""
        
        lazy var toStoreSelect = Select(self.$toStoreSelectListener)
            .body{
                Option("Seleccione tienda origen")
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
                
                // MARK: Form store
                Div{
                    Label("Tenda Origen")
                        .fontSize(12.px)
                        .color(.gray)
                    
                    Div().clear(.both)
                    
                    self.fromStoreSelect
                }
                .marginLeft(12.px)
                .marginTop(3.px)
                .float(.left)
                
                // MARK: To store
                Div{
                    Label("Tienda Destino")
                        .fontSize(12.px)
                        .color(.gray)
                    
                    Div().clear(.both)
                    
                    self.toStoreSelect
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
                fromStoreSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                )
            }
            
            $fromStoreSelectListener.listen {
                
                guard let storeId = UUID(uuidString: self.fromStoreSelectListener) else {
                    return
                }
                
                self.toStoreSelectListener = ""
                
                self.toStoreSelect.innerHTML = ""
                
                self.toStoreSelect.appendChild(
                    Option("Seleccione tienda destino")
                        .value("")
                )
                
                stores.forEach { _, store in
                    
                    if storeId == store.id {
                        return
                    }
                    
                    self.toStoreSelect.appendChild(
                        Option(store.name)
                            .value(store.id.uuidString)
                    )
                    
                }
            }
            
            fromStoreSelectListener = custCatchStore.uuidString
            
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
            
            guard let fromStore: UUID = UUID(uuidString: fromStoreSelectListener) else {
                showError(.errorGeneral, "Seleccione una tienda origen.")
                return
            }
            
            
            guard let toStore: UUID = UUID(uuidString: toStoreSelectListener) else {
                showError(.errorGeneral, "Seleccione una tienda origen.")
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
            
            API.custPOCV1.tranferReport(
                fromStore: fromStore,
                toStore: toStore,
                startAt: startAtUTS,
                endAt: endAtUTS
            ) { resp in
                
                getUsers(storeid: nil, onlyActive: false) { users in
                 
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
                 
                    // MARK: Refrences
                    
                    let userRefrence: [UUID:CustUsername] = Dictionary.init(uniqueKeysWithValues: users.map{ ($0.id, $0) })
                    
                    var itemRefrence: [UUID:CustPOCInventorySoldObject] = [:]
                    
                    payload.items.forEach { item in
                        itemRefrence[item.id] = item
                    }
                    
                    // MARK: Process Documents
                    
                    let outgoingBody = TBody()
                    
                    let incommingBody = TBody()
                    
                    let outgoingTable = Table{
                        THead{
                            Tr{
                                Td{
                                    Div{
                                        H1("Salidas").color(.darkGoldenRod)
                                    }
                                    .borderBottom(width: .thin, style: .solid, color: .darkGoldenRod)
                                }
                                .colSpan(9)
                            }
                            Tr{
                                Td("Fecha")
                                Td("Folio")
                                Td("Nombre")
                                Td("Creador")
                                Td("Recibido")
                                Td("Almacenado")
                                Td("Unis")
                                Td("Costo")
                                Td(" ")
                            }
                        }
                        .custom("inset-block-start", "0")
                        .backgroundColor(.black)
                        .position(.sticky)
                        .zIndex(1)
                        
                        outgoingBody
                    }
                    //.height(100.percent)
                    .width(100.percent)
                    .color(.white)
                    
                    let incomingTable = Table{
                        THead{
                            Tr{
                                Td{
                                    Div{
                                        H1("Entradas").color(.darkGoldenRod)
                                    }
                                    .borderBottom(width: .thin, style: .solid, color: .darkGoldenRod)
                                }
                                .colSpan(9)
                            }
                            Tr{
                                Td("Fecha")
                                Td("Folio")
                                Td("Nombre")
                                Td("Creador")
                                Td("Recibido")
                                Td("Almacenado")
                                Td("Unis")
                                Td("Costo")
                                Td(" ")
                            }
                        }
                        .custom("inset-block-start", "0")
                        .backgroundColor(.black)
                        .position(.sticky)
                        .zIndex(1)
                        
                        incommingBody
                    }
                    //.height(100.percent)
                    .width(100.percent)
                    .color(.white)
                    
                    var totalIncomingUnits: Int = 0
                    
                    var totalIncomingCost: Int64 = 0
                    
                    var totalOutgoingUnits: Int = 0
                    
                    var totalOutgoingCost: Int64 = 0
                    
                    payload.outgoing.forEach { doc in
                        
                        var createdBy = "N/A"
                        
                        var receivedBy = "N/A"
                        
                        var closedBy = "N/A"
                        
                        if let uname = userRefrence[doc.createdBy]?.username, let user = uname.explode("@").first {
                            createdBy = "@\(user)"
                        }
                        
                        if let receivedById = doc.receivedBy, let uname = userRefrence[receivedById]?.username, let user = uname.explode("@").first {
                            receivedBy = "@\(user)"
                        }
                        
                        if let closedById = doc.closedBy, let uname = userRefrence[closedById]?.username, let user = uname.explode("@").first {
                            closedBy = "@\(user)"
                        }
                        
                        let units = doc.items.count
                        
                        let cost = doc.items.map{ itemRefrence[$0]?.cost ?? 0 }.reduce(0, +)
                        
                        totalOutgoingUnits += units
                        
                        totalOutgoingCost += cost
                        
                        outgoingBody.appendChild(Tr{
                            Td(getDate(doc.createdAt).formatedLong)
                            Td(doc.folio)
                            Td(doc.description)
                            Td{
                                Div(createdBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td{
                                Div(receivedBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td{
                                Div(closedBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td(units.toString)
                            Td(cost.formatMoney)
                            Td{
                                Div{
                                    Img()
                                        .src("/skyline/media/maximizeWindow.png")
                                        .class(.iconWhite)
                                        .cursor(.pointer)
                                        .height(18.px)
                                        .onClick {
                                            
                                            loadingView(show: true)
                                            
                                            API.custPOCV1.getTransferInventory(identifier: .id(doc.id)) { resp in
                                                
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
                                .margin(all: 7.px)
                            }
                        }.class(.hoverFocusBlack))
                    }
                    
                    payload.incoming.forEach { doc in
                        
                        var createdBy = "N/A"
                        
                        var receivedBy = "N/A"
                        
                        var closedBy = "N/A"
                        
                        if let uname = userRefrence[doc.createdBy]?.username, let user = uname.explode("@").first {
                            createdBy = "@\(user)"
                        }
                        
                        if let receivedById = doc.receivedBy, let uname = userRefrence[receivedById]?.username, let user = uname.explode("@").first {
                            receivedBy = "@\(user)"
                        }
                        
                        if let closedById = doc.closedBy, let uname = userRefrence[closedById]?.username, let user = uname.explode("@").first {
                            closedBy = "@\(user)"
                        }
                        
                        let units = doc.items.count
                        
                        let cost = doc.items.map{ itemRefrence[$0]?.cost ?? 0 }.reduce(0, +)
                        
                        totalIncomingUnits += units
                        
                        totalIncomingCost += cost
                        
                        incommingBody.appendChild(Tr{
                            Td(getDate(doc.createdAt).formatedLong)
                            Td(doc.folio)
                            Td(doc.description)
                            Td{
                                Div(createdBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td{
                                Div(receivedBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td{
                                Div(closedBy)
                                    .class(.oneLineText)
                                    .width(150.px)
                            }
                            Td(units.toString)
                            Td(cost.formatMoney)
                            Td{
                                Div{
                                    Img()
                                        .src("/skyline/media/maximizeWindow.png")
                                        .class(.iconWhite)
                                        .cursor(.pointer)
                                        .height(18.px)
                                        .onClick {
                                            
                                            loadingView(show: true)
                                            
                                            API.custPOCV1.getTransferInventory(identifier: .id(doc.id)) { resp in
                                                
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
                                .margin(all: 7.px)
                            }
                        }.class(.hoverFocusBlack))
                    }
                    
                    var costTax = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: totalOutgoingCost * 10000,
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
                    
                    outgoingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("Sub Total")
                        Td("")
                        Td((costTax.subTotal / 10000).formatMoney)
                            .color(.gray)
                    }.class(.hoverFocusBlack))
                    
                    outgoingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("IVA")
                        Td("")
                        Td((costTax.trasladado / 10000).formatMoney)
                            .color(.gray)
                    }.class(.hoverFocusBlack))
                    
                    outgoingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("Total")
                        Td(totalOutgoingUnits.toString)
                        Td(totalOutgoingCost.formatMoney)
                    }.class(.hoverFocusBlack))
                    
                    
                    costTax = calcSubTotal(
                        substractedTaxCalculation: true,
                        units: 100 * 10000,
                        cost: totalIncomingCost * 10000,
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
                    
                    incommingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("Sub Total")
                        Td("")
                        Td((costTax.subTotal / 10000).formatMoney)
                            .color(.gray)
                    }.class(.hoverFocusBlack))
                    
                    incommingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("IVA")
                        Td("")
                        Td((costTax.trasladado / 10000).formatMoney)
                            .color(.gray)
                    }.class(.hoverFocusBlack))
                    
                    
                    incommingBody.appendChild(Tr{
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td(" ")
                        Td("Total")
                        Td(totalIncomingUnits.toString)
                        Td(totalIncomingCost.formatMoney)
                    }.class(.hoverFocusBlack))
                    
                    // MARK: Process Items
                    
                    let tableBody = TBody()
                    
                    let table = Table{
                        THead{
                            Tr{
                                Td{
                                    Div{
                                        
                                        Div{
                                            
                                            Img()
                                                .src("/skyline/media/download2.png")
                                                .marginLeft(12.px)
                                                .height(18.px)
                                        
                                             Span("Descargar")
                                             
                                         }
                                        .float(.right)
                                        .class(.uibtn)
                                        .onClick {
                                            /*
                                            self.downloadCardexReport(
                                                startAt: startAtUTS,
                                                endAt: endAtUTS,
                                                storeId: storeId,
                                                payload: payload
                                            )
                                             */
                                        }
                                        
                                        H1("Resultados")
                                            .color(.darkGoldenRod)
                                    }
                                        .borderBottom(width: .thin, style: .solid, color: .darkGoldenRod)
                                }
                                .colSpan(10)
                            }
                            Tr{
                                Td("")
                                Td("SKU/UPC/POC")
                                Td("Nombre / Marca / Modelo")
                                Td("Costo")
                                Td("Precio")
                                Td("Inicial")
                                Td("Agregados")
                                Td("Removidos")
                                Td("Final")
                                Td("Saldo")
                            }
                        }
                        
                        .custom("inset-block-start", "0")
                        .backgroundColor(.black)
                        .position(.sticky)
                        .zIndex(1)
                        
                        tableBody
                    }
                    //.height(100.percent)
                    .width(100.percent)
                    .color(.white)
                    
                    var totalInitialUnits: Int = 0
                    
                    var totalAddedUnits: Int = 0
                    
                    var totalRemovedUnits: Int = 0
                    
                    var totalFinalUnits: Int = 0
                    
                    var totalFinalCost: Int64 = 0
                    
                    payload.objects.forEach { item in
                        
                        let initialUnits: Int = item.initialInventory
                        
                        let finalUnits = (initialUnits + item.addedInventory - item.removeInventory)
                        
                        totalInitialUnits += initialUnits
                        
                        totalAddedUnits += item.addedInventory
                        
                        totalRemovedUnits += item.removeInventory
                        
                        totalFinalUnits += finalUnits
                        
                        totalFinalCost += (finalUnits.toInt64 * item.poc.cost)
                        
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
                            Td(item.poc.pricea.formatMoney)
                                .align(.right)
                            Td(initialUnits.toString)
                                .align(.center)
                            Td(item.addedInventory.toString)
                                .align(.center)
                            Td(item.removeInventory.toString)
                                .align(.center)
                            Td(finalUnits.toString)
                                .align(.center)
                            Td((finalUnits.toInt64 * item.poc.cost).formatMoney)
                                .align(.right)
                        }.class(.hoverFocusBlack))
                        
                        if let pDir = customerServiceProfile?.account.pDir, !item.poc.avatar.isEmpty {
                            avatar.load("https://intratc.co/cdn/\(pDir)/thump_\(item.poc.avatar)")
                        }
                    }
                    
                    tableBody.appendChild(Tr{
                        Td()
                        Td()
                        Td()
                        Td()
                        Td()
                        Td(totalInitialUnits.toString)
                        Td(totalAddedUnits.formatMoney)
                        Td(totalRemovedUnits.toString)
                        Td(totalFinalUnits.formatMoney)
                        Td(totalFinalCost.formatMoney)
                    })
                    
                    // MARK: Clear current table
                    
                    self.resultDiv.innerHTML = ""
                    
                    // MARK: Output Table
                    
                    self.resultDiv.appendChild(outgoingTable)
                    
                    self.resultDiv.appendChild(Div().clear(.both).height(12.px))
                    
                    // MARK: Incomming Table
                    
                    self.resultDiv.appendChild(incomingTable)
                    
                    self.resultDiv.appendChild(Div().clear(.both).height(12.px))
                    
                    // MARK: Items Table
                    
                    self.resultDiv.appendChild(table)
                    
                }
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
