//
//  ProductManager+Audit+ReportActions.swift
//

import Foundation
import JavaScriptKit
import Web

extension ProductManagerView.AuditView {

    final class ReportActions: Div {

        override class var name: String { "div" }

        private let resultElementId: String
        private var reportTitle = "Reporte"
        private var fileName = "reporte"
        private var aiResponse = ""
        private var pdfCallback: (() -> Void)?
        private var excelCallback: (() -> Void)?

        init(resultElementId: String) {
            self.resultElementId = resultElementId
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private lazy var excelButton = reportButton(
            label: "Excel",
            icon: "/skyline/media/excel.png",
            action: "excel"
        ) {
            self.export(
                using: "createProductAuditExcelFromElement",
                callback: self.excelCallback
            )
        }

        private lazy var csvButton = reportButton(
            label: "CSV",
            icon: "/skyline/media/excel.png",
            action: "csv"
        ) {
            self.export(
                using: "createProductAuditExcelFromElement",
                callback: self.excelCallback
            )
        }

        private lazy var pdfButton = reportButton(
            label: "PDF",
            icon: "/skyline/media/pdf.png",
            action: "pdf"
        ) {
            self.export(
                using: "createProductAuditPDFFromElement",
                callback: self.pdfCallback
            )
        }

        private lazy var playButton = Div {
            Span("▶")
                .class(Class("tc-audit-report-action-symbol"))
            Span("Play")
        }
        .class(Class(TCCrystalSurfaceClass.auditReportAction))
        .attribute("data-report-action", "play")
        .attribute("role", "button")
        .attribute("aria-label", "Escuchar resumen del reporte")
        .attribute("title", "Escuchar resumen generado por IA")
        .hidden(true)
        .onClick {
            self.playAIResponse()
        }

        @DOM override var body: DOM.Content {
            self.excelButton
            self.csvButton
            self.pdfButton
            self.playButton
        }

        override func buildUI() {
            super.buildUI()
            self.class(Class(TCCrystalSurfaceClass.auditReportActions))
            csvButton.display(.none)
            playButton.display(.none)
            display(.none)
        }

        func present(
            title: String,
            fileName: String,
            aiResponse: String?,
            in resultContainer: Div,
            pdfCallback: (() -> Void)? = nil,
            excelCallback: (() -> Void)? = nil,
            excelButtonLabel: String = "Excel"
        ) {
            reportTitle = title
            self.fileName = fileName
            self.aiResponse = (aiResponse ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            self.pdfCallback = pdfCallback
            self.excelCallback = excelCallback

            let usesCSV = excelButtonLabel.caseInsensitiveCompare("CSV") == .orderedSame
            excelButton.display(usesCSV ? .none : .inlineFlex)
            csvButton.display(usesCSV ? .inlineFlex : .none)

            resultContainer.appendChild(self)
            playButton.display(self.aiResponse.isEmpty ? .none : .inlineFlex)
            display(.flex)
        }

        func reset() {
            SpeechRecognitionManager.shared.stopSpeaking()
            aiResponse = ""
            pdfCallback = nil
            excelCallback = nil
            excelButton.display(.inlineFlex)
            csvButton.display(.none)
            playButton.display(.none)
            display(.none)
        }

        private func reportButton(
            label: String,
            icon: String,
            action: String,
            callback: @escaping () -> Void
        ) -> Div {
            Div {
                Img()
                    .src(icon)
                    .attribute("aria-hidden", "true")
                Span(label)
            }
            .class(Class(TCCrystalSurfaceClass.auditReportAction))
            .attribute("data-report-action", action)
            .attribute("role", "button")
            .attribute("aria-label", "Exportar reporte a \(label)")
            .attribute("title", "Exportar reporte a \(label)")
            .onClick {
                callback()
            }
        }

        private func export(using functionName: String, callback: (() -> Void)?) {
            if let callback = callback {
                callback()
                return
            }

            guard let exporter = JSObject.global[functionName].function else {
                showError(.generalError, "El exportador del reporte todavía no está disponible.")
                return
            }

            let didExport = exporter.callAsFunction(
                optionalThis: JSObject.global,
                arguments: [resultElementId, fileName, reportTitle]
            )?.boolean ?? false

            if !didExport {
                showError(.generalError, "No fue posible exportar el reporte.")
            }
        }

        private func playAIResponse() {
            guard !aiResponse.isEmpty else { return }

            let didStart = SpeechRecognitionManager.shared.speak(
                aiResponse,
                language: "es-MX",
                rate: 0.94
            )

            if !didStart {
                showError(.generalError, "La lectura de texto no está disponible en este navegador.")
            }
        }

        override func didRemoveFromDOM() {
            SpeechRecognitionManager.shared.stopSpeaking()
            super.didRemoveFromDOM()
        }
    }
}
