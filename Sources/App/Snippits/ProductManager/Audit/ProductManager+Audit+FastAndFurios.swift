//
//  ProductManager+Audit+FastAndFurios.swift
//
//

import Foundation
import TCFireSignal
import TCFundamentals
import Web

extension ProductManagerView.AuditView.Inventory {

    func renderFastAndFurios(
        payload: CustPOCComponents.AuditsVTResponse
    ) {
        let soldUnits = payload.products.map { $0.soldUnits }.reduce(0, +)
        let grossRevenue = payload.products.map { $0.grossRevenue }.reduce(0, +)
        let averageScore = payload.products.isEmpty
            ? 0
            : payload.products.map { $0.overallScore }.reduce(0, +) / Double(payload.products.count)
        let productsWithInventory = payload.products.filter { $0.hasInventory }.count
        let scope: String

        if let storeid = payload.storeid {
            scope = stores[storeid]?.name ?? "Tienda seleccionada"
        }
        else {
            scope = "Todas las tiendas"
        }

        resultDiv.appendChild(
            ProductManagerView.AuditView.reportHeader(
                title: "🏎️ Top 70 Rápido y Furioso",
                subtitle: "Hasta 70 productos mejor clasificados por ingreso, velocidad y unidades desplazadas.",
                context: "Alcance: \(scope) • Periodo: \(fastAndFuriosDateTime(payload.from)) — \(fastAndFuriosDateTime(payload.to)) • Generado: \(fastAndFuriosDateTime(payload.generatedAt))"
            )
        )

        let metrics = Div()
            .class(Class(TCCrystalSurfaceClass.auditMetricGrid))

        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Productos",
                value: payload.products.count.toString,
                detail: "Mejor clasificados"
            )
        )
        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Unidades vendidas",
                value: soldUnits.toString,
                detail: "Total del reporte"
            )
        )
        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Ingreso generado",
                value: grossRevenue.formatMoney,
                detail: "Venta bruta acumulada"
            )
        )
        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Mejor puntuación",
                value: fastAndFuriosScore(payload.products.first?.overallScore ?? 0),
                detail: "Máximo de 100 puntos"
            )
        )
        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Puntuación promedio",
                value: fastAndFuriosScore(averageScore),
                detail: "Promedio de productos"
            )
        )
        metrics.appendChild(
            ProductManagerView.AuditView.reportMetric(
                title: "Con inventario",
                value: productsWithInventory.toString,
                detail: "Después de la última venta"
            )
        )

        resultDiv.appendChild(metrics)

        resultDiv.appendChild(
            Div {
                Div("Cómo se calcula")
                    .color(.lightBlueText)
                    .fontSize(16.px)
                    .fontWeight(.bold)
                Div("Ingreso por día 50% • Velocidad de unidades 25% • Total de unidades 25%. Cada componente se compara contra el producto líder del reporte.")
                    .color(.white)
                    .fontSize(12.px)
                    .marginTop(4.px)
            }
            .class(Class(TCCrystalSurfaceClass.auditMetric))
            .marginTop(10.px)
            .marginBottom(10.px)
        )

        guard !payload.products.isEmpty else {
            resultDiv.appendChild(
                Table().noResult(
                    label: "No se encontraron ventas para el periodo seleccionado"
                )
            )
            return
        }

        let tableBody = TBody()
        let table = Table {
            THead {
                Tr {
                    Td("#")
                    ProductManagerView.AuditView.productManagerHeaderCell()
                    Td("UPC")
                    Td("Producto")
                    Td("Marca / Modelo")
                    Td("Unidades")
                    Td("Ingreso")
                    Td("Días efectivos")
                    Td("Cierre efectivo")
                    Td("Inventario")
                    Td("Ingreso / día")
                    Td("Puntos ingreso")
                    Td("Unidades / día")
                    Td("Puntos velocidad")
                    Td("Puntos volumen")
                    Td("Puntuación total")
                    Td("Cardex")
                }
            }
            tableBody
        }
        .width(100.percent)
        .color(.white)
        // The dedicated table viewport owns both scroll axes, so the report header
        // and metrics remain in place while this wide table scrolls.
        .custom("min-width", "1810px")
        .custom("max-width", "none")

        payload.products.enumerated().forEach { index, item in
            let productName = item.product.name.isEmpty
                ? (item.product.pseudoName.isEmpty ? "Producto sin nombre" : item.product.pseudoName)
                : item.product.name
            let brandModel = [item.product.brand, item.product.model]
                .filter { !$0.isEmpty }
                .joined(separator: " / ")
            let elapsedDays = Double(item.elapsedSeconds) / 86_400.0
            let revenuePerDay = Int64(item.revenuePerDay.rounded())

            tableBody.appendChild(
                Tr {
                    Td((index + 1).toString)
                        .color(.yellowTC)
                        .fontWeight(.bold)
                    ProductManagerView.AuditView.productManagerCell(
                        pocId: item.product.id
                    )
                    Td(item.product.upc.isEmpty ? "N/D" : item.product.upc)
                    ProductManagerView.AuditView.productDescriptionCell(productName)
                    Td(brandModel.isEmpty ? "N/D" : brandModel)
                    Td(item.soldUnits.toString)
                    Td(item.grossRevenue.formatMoney)
                    Td(String(format: "%.2f", elapsedDays))
                    Td(self.fastAndFuriosDateTime(item.calculationEndedAt))
                    Td(item.hasInventory ? "Disponible" : "Agotado")
                        .color(item.hasInventory ? .lightBlueText : .yellowTC)
                    Td(revenuePerDay.formatMoney)
                    self.fastAndFuriosScoreCell(item.revenueVelocityScore)
                    Td(String(format: "%.4f", item.unitsPerDay))
                    self.fastAndFuriosScoreCell(item.salesVelocityScore)
                    self.fastAndFuriosScoreCell(item.soldUnitsScore)
                    self.fastAndFuriosScoreCell(item.overallScore, highlighted: true)
                    Td {
                        ProductManagerView.AuditView.CardexGraphView.graphButton {
                            guard let storeId = payload.storeid else {
                                showError(
                                    .requiredField,
                                    "Seleccione una tienda y vuelva a generar el reporte para consultar la gráfica de Cardex."
                                )
                                return
                            }

                            self.loadCardexGraph(
                                poc: item.product,
                                storeId: storeId,
                                storeName: stores[storeId]?.name ?? "Tienda seleccionada",
                                startAt: payload.from,
                                endAt: payload.to
                            )
                        }
                    }
                }
                .backgroundColor(index.isMultiple(of: 2) ? .backGroundRow : .transparent)
            )
        }

        resultDiv.appendChild(
            Div {
                table
            }
            .width(100.percent)
            .custom("max-width", "100%")
            .custom("max-height", "max(320px, calc(100vh - 360px))")
            .custom("min-width", "0")
            .custom("box-sizing", "border-box")
            .custom("position", "relative")
            .custom("overflow", "auto")
        )
    }

    private func fastAndFuriosScoreCell(
        _ score: Double,
        highlighted: Bool = false
    ) -> Td {
        Td(fastAndFuriosScore(score))
            .color(highlighted ? .yellowTC : .lightBlueText)
            .fontWeight(.bold)
    }

    private func fastAndFuriosScore(
        _ score: Double
    ) -> String {
        String(format: "%.2f", score)
    }

    private func fastAndFuriosDateTime(
        _ timestamp: Int64
    ) -> String {
        let date = getDate(timestamp)
        return "\(date.formatedShort) \(date.time)"
    }
}
