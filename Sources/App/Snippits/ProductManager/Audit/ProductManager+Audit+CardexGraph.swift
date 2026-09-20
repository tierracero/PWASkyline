//
//  ProductManager+Audit+CardexGraph.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ProductManagerView.AuditView {

    class CardexGraphView: Div {

        override class var name: String { "div" }

        private let aggregateItem: CustPOCComponents.CardexObject?
        private let poc: CustPOCQuick
        private let movements: [CustPOCCardex]
        private let storeName: String
        private let startAt: Int64
        private let endAt: Int64

        init(
            item: CustPOCComponents.CardexObject,
            storeName: String,
            startAt: Int64,
            endAt: Int64
        ) {
            self.aggregateItem = item
            self.poc = item.poc
            self.movements = []
            self.storeName = storeName
            self.startAt = startAt
            self.endAt = endAt
        }

        init(
            poc: CustPOCQuick,
            movements: [CustPOCCardex],
            storeName: String,
            startAt: Int64,
            endAt: Int64
        ) {
            self.aggregateItem = nil
            self.poc = poc
            self.movements = movements.sorted { lhs, rhs in
                if lhs.createdAt == rhs.createdAt {
                    return lhs.id.uuidString > rhs.id.uuidString
                }
                return lhs.createdAt > rhs.createdAt
            }
            self.storeName = storeName
            self.startAt = startAt
            self.endAt = endAt
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            Div {
                Div {
                    Img()
                        .closeButton(.uiView2)
                        .onClick {
                            self.remove()
                        }

                    H2("📈 Gráfica de Cardex")
                        .color(.lightBlueText)
                        .marginBottom(2.px)

                    Div("\(self.poc.upc)  •  \(self.poc.name)")
                        .color(.white)
                        .fontSize(18.px)
                        .fontWeight(.bold)

                    Div("\(self.storeName)  •  \(getDate(self.startAt).formatedLong) al \(getDate(self.endAt).formatedLong)")
                        .color(.gray)
                        .fontSize(13.px)
                        .marginTop(3.px)

                    Div().clear(.both)
                }
                .backgroundColor(.slateHeader)
                .padding(all: 12.px)
                .marginBottom(12.px)
                .borderRadius(9.px)

                if !self.movements.isEmpty {
                    self.detailedCardexView()
                }
                else if let aggregateItem = self.aggregateItem {
                    self.aggregateCardexView(aggregateItem)
                }
            }
            .custom("box-shadow", "0 22px 70px rgba(0, 0, 0, 0.72)")
            .class(Class(TCCrystalSurfaceClass.auditModalPanel))
            .custom("width", "min(1040px, calc(100% - 48px))")
            .custom("transform", "translate(-50%, -50%)")
            .custom("max-height", "calc(100% - 72px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 16.px)
            .custom("left", "50%")
            .custom("top", "50%")
            .position(.absolute)
            .padding(all: 14.px)
            .overflow(.auto)
        }

        override func buildUI() {
            super.buildUI()

            self.class(Class(TCCrystalSurfaceClass.auditWorkspace))
            custom("background", "rgba(0, 0, 0, 0.48)")
            custom("backdrop-filter", "blur(5px)")
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
    
            CrystalTheme.apply(to: self)

        }

        private func detailedCardexView() -> Div {
            let initialUnits = movements.first?.initialUnits ?? 0
            let finalUnits = movements.last?.finalUnits ?? initialUnits
            let addedUnits = movements.filter { $0.mode == .add }.map { $0.processedUnits }.reduce(0, +)
            let removedUnits = movements.filter { $0.mode == .remove }.map { $0.processedUnits }.reduce(0, +)

            return Div {
                Div {
                    ProductManagerView.AuditView.reportMetric(
                        title: "Inventario inicial",
                        value: initialUnits.toString,
                        detail: "Antes del primer movimiento"
                    )
                    ProductManagerView.AuditView.reportMetric(
                        title: "Entradas",
                        value: addedUnits.toString,
                        detail: "Unidades agregadas"
                    )
                    ProductManagerView.AuditView.reportMetric(
                        title: "Salidas",
                        value: removedUnits.toString,
                        detail: "Unidades retiradas"
                    )
                    ProductManagerView.AuditView.reportMetric(
                        title: "Inventario final",
                        value: finalUnits.toString,
                        detail: "Después del último movimiento"
                    )
                    ProductManagerView.AuditView.reportMetric(
                        title: "Actividades",
                        value: self.movements.count.toString,
                        detail: "Movimientos recibidos"
                    )
                }
                .class(Class(TCCrystalSurfaceClass.auditMetricGrid))

                H3("Existencia por fecha")
                    .color(.yellowTC)
                    .marginBottom(7.px)

                self.lineChart()

                H3("Actividad de Cardex")
                    .color(.yellowTC)
                    .marginTop(16.px)
                    .marginBottom(7.px)

                self.activityTable()
            }
        }

        private func lineChart() -> Div {
            let chartWidth = 920.0
            let chartHeight = 330.0
            let leftInset = 58.0
            let rightInset = 24.0
            let topInset = 22.0
            let bottomInset = 62.0
            let plotWidth = chartWidth - leftInset - rightInset
            let plotHeight = chartHeight - topInset - bottomInset

            let unitValues = [movements.first?.initialUnits ?? 0] + movements.map { $0.finalUnits }
            let rawMinimumUnits = unitValues.min() ?? 0
            let rawMaximumUnits = unitValues.max() ?? 0
            let visiblePadding = max(1, (rawMaximumUnits - rawMinimumUnits) / 5)
            let minimumUnits = max(0, rawMinimumUnits - visiblePadding)
            let maximumUnits = max(rawMaximumUnits + visiblePadding, minimumUnits + 1)
            let unitRange = max(maximumUnits - minimumUnits, 1)

            let points: [(x: Double, y: Double, units: Int, timestamp: Int64)] = unitValues.enumerated().map { index, units in
                let denominator = max(unitValues.count - 1, 1)
                let x = leftInset + (Double(index) / Double(denominator)) * plotWidth
                let normalized = Double(units - minimumUnits) / Double(unitRange)
                let y = topInset + (1.0 - normalized) * plotHeight
                let timestamp = index == 0
                    ? (movements.first?.createdAt ?? startAt)
                    : movements[index - 1].createdAt
                return (x, y, units, timestamp)
            }

            let svg = Svg()
                .custom("viewBox", "0 0 \(Int(chartWidth)) \(Int(chartHeight))")
                .custom("preserveAspectRatio", "xMidYMid meet")
                .width(100.percent)
                .height(330.px)

            for gridIndex in 0...4 {
                let ratio = Double(gridIndex) / 4.0
                let y = topInset + ratio * plotHeight
                let units = maximumUnits - Int(round(ratio * Double(unitRange)))

                svg.appendChild(Line()
                    .custom("x1", self.coordinate(leftInset))
                    .custom("x2", self.coordinate(chartWidth - rightInset))
                    .custom("y1", self.coordinate(y))
                    .custom("y2", self.coordinate(y))
                    .custom("stroke", "rgba(151, 190, 215, 0.18)")
                    .custom("stroke-width", "1"))

                svg.appendChild(SVGText(units.toString)
                    .custom("x", self.coordinate(leftInset - 9))
                    .custom("y", self.coordinate(y + 4))
                    .custom("fill", "#9fb5c5")
                    .custom("font-size", "12")
                    .custom("text-anchor", "end"))
            }

            if let firstPoint = points.first, let lastPoint = points.last {
                let linePath = points.enumerated().map { index, point in
                    "\(index == 0 ? "M" : "L") \(self.coordinate(point.x)) \(self.coordinate(point.y))"
                }.joined(separator: " ")
                let areaLinePath = points.map { point in
                    "L \(self.coordinate(point.x)) \(self.coordinate(point.y))"
                }.joined(separator: " ")
                let areaPath = "M \(self.coordinate(firstPoint.x)) \(self.coordinate(topInset + plotHeight)) "
                    + areaLinePath
                    + " L \(self.coordinate(lastPoint.x)) \(self.coordinate(topInset + plotHeight)) Z"

                svg.appendChild(Path()
                    .custom("d", areaPath)
                    .custom("fill", "rgba(73, 185, 245, 0.13)")
                    .custom("stroke", "none"))

                svg.appendChild(Path()
                    .custom("d", linePath)
                    .custom("fill", "none")
                    .custom("stroke", "#49b9f5")
                    .custom("stroke-width", "4")
                    .custom("stroke-linecap", "round")
                    .custom("stroke-linejoin", "round")
                    .custom("filter", "drop-shadow(0 0 5px rgba(73,185,245,0.52))"))
            }

            let labelStep = max(1, Int(ceil(Double(points.count) / 6.0)))
            points.enumerated().forEach { index, point in
                svg.appendChild(SVGRect()
                    .custom("x", self.coordinate(point.x - 4))
                    .custom("y", self.coordinate(point.y - 4))
                    .custom("width", "8")
                    .custom("height", "8")
                    .custom("rx", "4")
                    .custom("fill", index == 0 ? "#ff9f0a" : "#edf7ff")
                    .custom("stroke", "#49b9f5")
                    .custom("stroke-width", "2"))

                if index % labelStep == 0 || index == points.count - 1 {
                    let date = getDate(point.timestamp)
                    svg.appendChild(SVGText(date.formatedShort)
                        .custom("x", self.coordinate(point.x))
                        .custom("y", self.coordinate(chartHeight - 28))
                        .custom("fill", "#a8bed0")
                        .custom("font-size", "11")
                        .custom("text-anchor", "middle"))

                    svg.appendChild(SVGText(point.units.toString)
                        .custom("x", self.coordinate(point.x))
                        .custom("y", self.coordinate(max(point.y - 11, 12)))
                        .custom("fill", "#edf7ff")
                        .custom("font-size", "11")
                        .custom("font-weight", "700")
                        .custom("text-anchor", "middle"))
                }
            }

            return Div {
                svg
                Div {
                    Span("■ ")
                        .color(.statusPendingSpare)
                    Span("Punto inicial")
                        .color(.gray)
                    Span("   ■ ")
                        .color(.lightBlueText)
                    Span("Existencia después de cada actividad")
                        .color(.gray)
                }
                .fontSize(12.px)
                .padding(top: 0.px, right: 12.px, bottom: 0.px, left: 12.px)
            }
            .padding(top: 8.px, right: 10.px, bottom: 8.px, left: 10.px)
            .borderRadius(10.px)
            .backgroundColor(.grayBlackDark)
            .custom("border", "1px solid rgba(73, 185, 245, 0.2)")
        }

        private func activityTable() -> Div {
            let table = Table {
                THead {
                    Tr {
                        Td("Fecha")
                        Td("Actividad")
                        Td("Origen")
                        Td("Folio")
                        Td("Inicial")
                        Td("Procesado")
                        Td("Final")
                    }
                }
            }
            .width(100.percent)
            .color(.white)

            movements.enumerated().forEach { index, movement in
                let date = getDate(movement.createdAt)
                let operation = movement.mode == .add ? "Entrada" : "Salida"
                let processed = "\(movement.mode == .add ? "+" : "-")\(movement.processedUnits)"
                let source = movement.channel == .default
                    ? movement.relation.description
                    : movement.channel.description

                table.appendChild(Tr {
                    Td("\(date.formatedShort) \(date.time)")
                    Td(operation)
                        .color(movement.mode == .add ? .slateGreen : .statusPendingSpare)
                        .fontWeight(.bold)
                    Td(source)
                    Td {
                        Div(movement.channelFolio.isEmpty ? "N/D" : movement.channelFolio)
                            .class(.uibtn)
                            .onClick {
                                self.openFolio(movement)
                            }
                    }
                    Td(movement.initialUnits.toString)
                    Td(processed)
                    Td(movement.finalUnits.toString)
                }
                .backgroundColor(index.isMultiple(of: 2) ? .backGroundRow : .transparent))
            }

            return Div {
                table
            }
            .custom("max-height", "280px")
            .overflow(.auto)
            .borderRadius(9.px)
            .custom("border", "1px solid rgba(96, 164, 207, 0.18)")
        }

        private func openFolio(_ item: CustPOCCardex) {
            switch item.channel {
            case .pdv:
                addToDom(SalePointView.DetailView(saleId: .id(item.channelId)))

            case .order:
                self.openOrder(orderId: item.channelId)

            case .eSale:
                showAlert(.alerta, "Las ventas eSale aún no son soportadas.")

            case .default:
                self.openConcession(controlId: item.channelId)
            }
        }

        private func openOrder(orderId: UUID) {
            
            OrderCatchControler.shared.loadFolio(orderid: orderId) {
                account,
                order,
                notes,
                payments,
                charges,
                pocs,
                files,
                contracts,
                equipments,
                rentals,
                transferOrder,
                orderHighPriorityNote,
                accountHighPriorityNote,
                tasks,
                route,
                loadFromCatch in

                let accountOverview = AccoutOverview(
                    id: .id(order.custAcct)
                )

                accountOverview.loadOrder(
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

                addToDom(accountOverview)
                minViewAcctRefrence[order.custAcct] = accountOverview
            }
        }

        private func openConcession(controlId: UUID) {
            loadingView.show()

            API.custPOCV1.getTransferInventory(identifier: .id(controlId)) { resp in
                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
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
                    hasRecived: {},
                    hasIngressed: {}
                ))
            }
        }

        private func aggregateCardexView(_ item: CustPOCComponents.CardexObject) -> Div {
            let maximum = [
                item.initalInventory,
                item.addedInventory,
                item.removeInventory,
                item.finalInventory,
                item.soldInventory ?? 0,
                1
            ].max() ?? 1

            return Div {
                Div {
                    self.graphBar(title: "Inicial", value: item.initalInventory, maximum: maximum, color: .lightBlueText)
                    self.graphBar(title: "Agregado", value: item.addedInventory, maximum: maximum, color: .slateGreen)
                    self.graphBar(title: "Removido", value: item.removeInventory, maximum: maximum, color: .statusPendingSpare)
                    self.graphBar(title: "Final", value: item.finalInventory, maximum: maximum, color: .strongBlue)
                    if let soldInventory = item.soldInventory {
                        self.graphBar(title: "Vendido", value: soldInventory, maximum: maximum, color: .yellowTC)
                    }
                }
                .display(.flex)
                .custom("align-items", "flex-end")
                .custom("justify-content", "space-around")
                .custom("gap", "18px")
                .height(285.px)
                .padding(top: 12.px, right: 18.px, bottom: 8.px, left: 18.px)
                .borderRadius(9.px)
                .backgroundColor(.grayBlackDark)

                Div {
                    self.balanceMetric("Saldo inicial", item.initalBalance)
                    self.balanceMetric("Entradas", item.addedBalance)
                    self.balanceMetric("Salidas", item.removeBalance)
                    self.balanceMetric("Saldo final", item.finalBalance)
                }
                .display(.flex)
                .custom("flex-wrap", "wrap")
                .custom("gap", "8px")
                .marginTop(12.px)
            }
        }

        private func graphBar(
            title: String,
            value: Int,
            maximum: Int,
            color: Color
        ) -> Div {
            let normalizedValue = max(value, 0)
            let barHeight = max(8, Int((Double(normalizedValue) / Double(maximum)) * 205.0))

            return Div {
                Div(value.toString)
                    .color(.white)
                    .fontSize(18.px)
                    .fontWeight(.bold)
                    .marginBottom(6.px)

                Div()
                    .height(barHeight.px)
                    .custom("width", "min(74px, 100%)")
                    .backgroundColor(color)
                    .custom("border-radius", "8px 8px 2px 2px")
                    .custom("box-shadow", "0 0 18px rgba(40, 178, 225, 0.18)")

                Div(title)
                    .color(.white)
                    .fontSize(13.px)
                    .marginTop(7.px)
            }
            .display(.flex)
            .custom("flex-direction", "column")
            .custom("align-items", "center")
            .custom("justify-content", "flex-end")
            .height(270.px)
            .custom("flex", "1 1 0")
            .custom("min-width", "74px")
        }

        private func balanceMetric(_ title: String, _ value: Int64) -> Div {
            Div {
                Div(title)
                    .color(.gray)
                    .fontSize(12.px)
                Div(value.formatMoney)
                    .color(.white)
                    .fontSize(17.px)
                    .fontWeight(.bold)
            }
            .class(Class(TCCrystalSurfaceClass.auditMetric))
            .custom("flex", "1 1 145px")
            .padding(all: 10.px)
            .borderRadius(7.px)
            .backgroundColor(.grayBlackDark)
        }

        private func coordinate(_ value: Double) -> String {
            String(format: "%.2f", value)
        }

        static func graphButton(_ action: @escaping () -> Void) -> Div {
            Div {
                Span("📈")
                    .marginRight(5.px)
                Span("Gráfica")
            }
            .display(.inlineFlex)
            .custom("align-items", "center")
            .padding(top: 5.px, right: 9.px, bottom: 5.px, left: 9.px)
            .border(width: .thin, style: .solid, color: .lightBlueText)
            .borderRadius(all: 7.px)
            .backgroundColor(.grayBlackDark)
            .color(.white)
            .fontSize(12.px)
            .fontWeight(.bold)
            .cursor(.pointer)
            .onClick {
                action()
            }
        }
    }
}
