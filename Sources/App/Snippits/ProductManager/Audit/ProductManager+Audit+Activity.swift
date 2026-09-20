//
//  ProductManager+Audit+Activity.swift
//  
//
//  Created by Victor Cantu on 7/7/23.
//

import Foundation
import TCFundamentals 
import TCFireSignal
import Web

extension ProductManagerView.AuditView {
    
    class Activity: Div {
        
        override class var name: String { "div" }

        private var activityRenderId = UUID()
        
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

        private let resultElementId = "activityResultDiv_\(callKey(7))"
        
        lazy var resultDiv = Div{
            Table().noResult(label: "📈 Seleccione un periodo para iniciar")
        }
        .id(.init(resultElementId))
        .class(Class(TCCrystalSurfaceClass.auditResults))
        .custom("height", "calc(100% - 85px)")
        .custom("min-height", "0")
        .custom("box-sizing", "border-box")
        .custom("overflow-x", "auto")
        .custom("overflow-y", "auto")
        .custom("overscroll-behavior", "contain")

        
        lazy var reportActions = ReportActions(resultElementId: resultElementId) 

        @DOM override var body: DOM.Content {
            /// Filter View
            Div{
                
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
            activityRenderId = renderId
            reportActions.reset()

            loadingView.show()
            
            API.custPOCV1.auditProductActivity(
                from: startAtUTS,
                to: endAtUTS
            ) { resp in
                guard renderId == self.activityRenderId else {
                    return
                }

                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor para obtener la actividad de productos.")
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

                self.renderActivityReport(
                    payload,
                    aiResponse: resp.airesponse
                )
            }
        }

        private func renderActivityReport(
            _ payload: CustPOCComponents.AuditProductActivityResponse,
            aiResponse: String?
        ) {
            let createdProducts = payload.products.filter(\.wasCreatedInPeriod).count
            let editedProducts = payload.products.filter(\.wasEditedInPeriod).count
            let activityCount = payload.products.map { $0.activities.count }.reduce(0, +)
            let imageCount = payload.products.map { $0.images.count }.reduce(0, +)
            let usersById = Dictionary(uniqueKeysWithValues: payload.users.map { ($0.id, $0) })

            resultDiv.innerHTML = ""

            reportActions.present(
                title: "Auditoría de actividad de productos",
                fileName: "actividad-productos-\(getNow())",
                aiResponse: aiResponse,
                in: resultDiv
            )

            resultDiv.appendChild(ProductManagerView.AuditView.reportHeader(
                title: "🧭 Actividad de productos",
                subtitle: "Creación, edición, imágenes y actividad relacionada con el catálogo.",
                context: "Periodo: \(activityDateTime(payload.from)) — \(activityDateTime(payload.to)) • Generado: \(activityDateTime(payload.generatedAt))"
            ))

            resultDiv.appendChild(Div {
                ProductManagerView.AuditView.reportMetric(
                    title: "Productos con actividad",
                    value: payload.products.count.toString,
                    detail: "Durante el periodo"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Productos creados",
                    value: createdProducts.toString,
                    detail: "Según createdAt"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Productos editados",
                    value: editedProducts.toString,
                    detail: "Según modifiedAt"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Eventos",
                    value: activityCount.toString,
                    detail: "Actividad documentada"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Imágenes vinculadas",
                    value: imageCount.toString,
                    detail: "De productos del periodo"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Posibles duplicados",
                    value: payload.possibleDuplicates.count.toString,
                    detail: "Coincidencias estrictas"
                )
                ProductManagerView.AuditView.reportMetric(
                    title: "Catálogo analizado",
                    value: payload.totalProductsScanned.toString,
                    detail: "Escaneo completo"
                )
            }
            .class(Class(TCCrystalSurfaceClass.auditMetricGrid)))

            if payload.products.isEmpty {
                resultDiv.appendChild(
                    Table().noResult(label: "Sin actividad de productos para el periodo seleccionado")
                )
            }
            else {
                resultDiv.appendChild(
                    activityProductsTable(
                        payload.products,
                        usersById: usersById
                    )
                )
            }

            resultDiv.appendChild(
                duplicateProductsSection(payload.possibleDuplicates)
            )
        }

        private func activityProductsTable(
            _ products: [CustPOCComponents.AuditProductActivityProduct],
            usersById: [UUID: CustPOCComponents.AuditUserReference]
        ) -> Div {
            let tableBody = TBody()
            let table = Table {
                THead {
                    Tr {
                        ProductManagerView.AuditView.productManagerHeaderCell()
                        Td("Imágenes")
                        Td("Actividad")
                        Td("UPC")
                        Td("Producto")
                        Td("Marca / Modelo")
                        Td("Tipo / Subtipo")
                        Td("Descripción")
                        Td("Condición")
                        Td("Auditoría")
                        Td("Creado por")
                        Td("Creado")
                        Td("Última modificación")
                        Td("Eventos del periodo")
                    }
                }
                tableBody
            }
            .width(100.percent)
            .color(.white)
            .custom("min-width", "2100px")
            .custom("max-width", "none")

            products.enumerated().forEach { index, item in
                let productName = item.product.name.isEmpty
                    ? (item.product.pseudoName.isEmpty ? "Producto sin nombre" : item.product.pseudoName)
                    : item.product.name
                let brandModel = [item.product.brand, item.product.model]
                    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    .joined(separator: " / ")
                let type = [item.productType, item.productSubType]
                    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    .joined(separator: " / ")
                let description = [item.smallDescription, item.description]
                    .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    .joined(separator: " • ")

                tableBody.appendChild(Tr {
                    ProductManagerView.AuditView.productManagerCell(pocId: item.product.id)
                    self.activityImagesCell(
                        item.images,
                        productAvatar: item.product.avatar
                    )
                    Td(self.activityChangeDescription(item))
                        .color(item.wasEditedInPeriod ? .yellowTC : .lightBlueText)
                        .fontWeight(.bold)
                    Td(item.product.upc.isEmpty ? "N/D" : item.product.upc)
                    Td(productName)
                    Td(brandModel.isEmpty ? "N/D" : brandModel)
                    Td(type.isEmpty ? "N/D" : type)
                    Td(description.isEmpty ? "Sin descripción" : description)
                    Td(item.conditions.description)
                    Td(item.isAudited ? "Auditado" : "Pendiente")
                        .color(item.isAudited ? .slateGreen : .statusPendingSpare)
                    Td(self.activityUserName(item.createdBy, usersById: usersById))
                    Td(self.activityDateTime(item.createdAt))
                    Td(self.activityDateTime(item.modifiedAt))
                    self.activityEventsCell(item.activities, usersById: usersById)
                }
                .backgroundColor(index.isMultiple(of: 2) ? .backGroundRow : .transparent))
            }

            return Div {
                H3("Detalle por producto")
                    .color(.yellowTC)
                    .marginTop(14.px)
                    .marginBottom(7.px)
                Div {
                    table
                }
                .width(100.percent)
                .custom("max-width", "100%")
                .custom("overflow", "auto")
            }
        }

        private func activityImagesCell(
            _ images: [CustWebFilesQuick],
            productAvatar: String
        ) -> Td {
            let cell = Td()
                .custom("min-width", "410px")

            let reportImages = Array(images.prefix(4))
            if reportImages.isEmpty {
                guard !productAvatar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    cell.appendChild(Span("Sin imágenes").color(.gray))
                    return cell
                }

                cell.appendChild(activityThumbnail(source: activityImageSource(productAvatar)))
                return cell
            }

            reportImages.forEach { image in
                let value = image.avatar.isEmpty ? image.file : image.avatar
                cell.appendChild(
                    activityThumbnail(
                        source: activityImageSource(value),
                        title: image.description
                    )
                )
            }

            if images.count > reportImages.count {
                cell.appendChild(
                    Span("+\(images.count - reportImages.count)")
                        .color(.lightBlueText)
                        .fontWeight(.bold)
                        .marginLeft(4.px)
                )
            }

            return cell
        }

        private func activityThumbnail(
            source: String,
            title: String = ""
        ) -> Img {
            Img()
                .src(source)
                .title(title.isEmpty ? "Imagen vinculada al producto" : title)
                .objectFit(.cover)
                .borderRadius(all: 8.px)
                .marginRight(6.px)
                .width(96.px)
                .height(96.px)
        }

        private func activityEventsCell(
            _ events: [CustPOCComponents.AuditProductActivityEvent],
            usersById: [UUID: CustPOCComponents.AuditUserReference]
        ) -> Td {
            let cell = Td()
                .custom("min-width", "330px")

            guard !events.isEmpty else {
                cell.appendChild(Span("Sin detalle de eventos").color(.gray))
                return cell
            }

            events.forEach { event in
                let noteType = event.noteType.map { " • \($0.description)" } ?? ""
                let detail = event.detail.trimmingCharacters(in: .whitespacesAndNewlines)

                cell.appendChild(Div {
                    Div("\(self.activityEventDescription(event.type))\(noteType)")
                        .color(event.type == .edited ? .yellowTC : .lightBlueText)
                        .fontWeight(.bold)
                    Div("\(self.activityDateTime(event.occurredAt)) • \(self.activityUserName(event.userId, usersById: usersById))")
                        .color(.gray)
                        .fontSize(11.px)
                    if !detail.isEmpty {
                        Div(detail)
                            .fontSize(12.px)
                            .marginTop(2.px)
                            .custom("white-space", "pre-wrap")
                    }
                }
                .padding(all: 5.px)
                .marginBottom(3.px)
                .borderRadius(5.px)
                .backgroundColor(.grayBlackDark))
            }

            return cell
        }

        private func duplicateProductsSection(
            _ duplicates: [CustPOCComponents.AuditProductDuplicateConflict]
        ) -> Div {
            let section = Div {
                H3("⚠️ Posibles productos duplicados")
                    .color(.yellowTC)
                    .marginTop(18.px)
                    .marginBottom(3.px)
                Div("El análisis considera el catálogo completo y solo muestra coincidencias estrictas.")
                    .color(.gray)
                    .fontSize(12.px)
                    .marginBottom(7.px)
            }

            guard !duplicates.isEmpty else {
                section.appendChild(
                    Table().noResult(label: "No se detectaron conflictos estrictos en el catálogo")
                )
                return section
            }

            let tableBody = TBody()
            let table = Table {
                THead {
                    Tr {
                        Td("Puntuación")
                        Td("Confianza")
                        Td("Motivo")
                        ProductManagerView.AuditView.productManagerHeaderCell()
                        Td("Primer producto")
                        Td("UPC")
                        ProductManagerView.AuditView.productManagerHeaderCell()
                        Td("Segundo producto")
                        Td("UPC")
                    }
                }
                tableBody
            }
            .width(100.percent)
            .color(.white)

            duplicates.enumerated().forEach { index, conflict in
                tableBody.appendChild(Tr {
                    Td("\(conflict.score)%")
                        .color(.yellowTC)
                        .fontWeight(.bold)
                    Td(self.duplicateConfidenceDescription(conflict.confidence))
                    Td(conflict.reasons.map(self.duplicateReasonDescription).joined(separator: " + "))
                    ProductManagerView.AuditView.productManagerCell(pocId: conflict.first.id)
                    Td(self.activityProductName(conflict.first))
                    Td(conflict.first.upc.isEmpty ? "N/D" : conflict.first.upc)
                    ProductManagerView.AuditView.productManagerCell(pocId: conflict.second.id)
                    Td(self.activityProductName(conflict.second))
                    Td(conflict.second.upc.isEmpty ? "N/D" : conflict.second.upc)
                }
                .backgroundColor(index.isMultiple(of: 2) ? .backGroundRow : .transparent))
            }

            section.appendChild(
                Div {
                    table
                }
                .width(100.percent)
                .custom("max-width", "100%")
                .custom("overflow", "auto")
            )
            return section
        }

        private func activityProductName(_ product: CustPOCQuick) -> String {
            let name = product.name.isEmpty
                ? (product.pseudoName.isEmpty ? "Producto sin nombre" : product.pseudoName)
                : product.name
            let brandModel = [product.brand, product.model]
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .joined(separator: " / ")
            return brandModel.isEmpty ? name : "\(name) • \(brandModel)"
        }

        private func activityChangeDescription(
            _ item: CustPOCComponents.AuditProductActivityProduct
        ) -> String {
            if item.wasCreatedInPeriod && item.wasEditedInPeriod {
                return "Creado y editado"
            }
            if item.wasCreatedInPeriod {
                return "Creado"
            }
            if item.wasEditedInPeriod {
                return "Editado"
            }
            return "Actividad relacionada"
        }

        private func activityEventDescription(
            _ type: CustPOCComponents.AuditProductActivityEventType
        ) -> String {
            switch type {
            case .created:
                return "Creación"
            case .edited:
                return "Edición"
            case .relatedActivity:
                return "Actividad relacionada"
            }
        }

        private func duplicateConfidenceDescription(
            _ confidence: CustPOCComponents.AuditProductDuplicateConfidence
        ) -> String {
            switch confidence {
            case .critical:
                return "Crítica"
            case .high:
                return "Alta"
            }
        }

        private func duplicateReasonDescription(
            _ reason: CustPOCComponents.AuditProductDuplicateReason
        ) -> String {
            switch reason {
            case .exactUPC:
                return "UPC idéntico"
            case .exactNameBrandAndModel:
                return "Nombre, marca y modelo idénticos"
            }
        }

        private func activityUserName(
            _ userId: UUID?,
            usersById: [UUID: CustPOCComponents.AuditUserReference]
        ) -> String {
            guard let userId else {
                return "Sin usuario identificado"
            }
            guard let user = usersById[userId] else {
                return "Usuario \(userId.uuidString)"
            }

            let nick = user.nick.trimmingCharacters(in: .whitespacesAndNewlines)
            return nick.isEmpty ? user.username : "\(nick) (\(user.username))"
        }

        private func activityImageSource(_ value: String) -> String {
            let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty else {
                return "/skyline/media/512.png"
            }
            guard !normalized.hasPrefix("/") &&
                    !normalized.hasPrefix("http://") &&
                    !normalized.hasPrefix("https://") else {
                return normalized
            }

            let file = normalized.hasPrefix("thump_") ? normalized : "thump_\(normalized)"
            return ImagePickerTo.product.url(
                url: custCatchUrl,
                pDir: pDir,
                isPreRegistration: false,
                accountType: custCatchAccountType
            ) + file
        }

        private func activityDateTime(_ timestamp: Int64) -> String {
            let date = getDate(timestamp)
            return "\(date.formatedShort) \(date.time)"
        }

        override func didRemoveFromDOM() {
            activityRenderId = UUID()
            super.didRemoveFromDOM()
            $dateSelectListener.removeAllListeners()
            $startAt.removeAllListeners()
            $endAtLabel.removeAllListeners()
            $endAt.removeAllListeners()
            $startAtLabel.removeAllListeners()
        }
    }
}
