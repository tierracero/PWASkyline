//
// SkylineDocumentationView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import SkylineDocumentationCore

class SkylineDocumentationView: Div {
    
    override class var name: String { "div" }

    @State var selectedFamily: DocumentFamily? = nil

    @State var selectedButton: GeneralButton? = nil

    private let families = DocumentFamily.allCases

    private let buttons = GeneralButton.allCases

    lazy var mainContainer = Div()
        .custom("grid-template-columns", "repeat(auto-fit, minmax(210px, 1fr))")
        .display(.grid)
        .custom("gap", "14px")

    @State var currentDocs: [DocumentQuick] = []

    @State var selectedView: SelectedView = .docs

    @State var errorReports: [ErrorReportRecord] = []

    @State var errorReportsLoadState: ErrorReportsLoadState = .idle

    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Documentacion Skyline")
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            
            Div{
                // MARK: Left menu
                Div {
                    H3("Temas")
                        .marginBottom(12.px)
                        .fontSize(18.px)
                        .color(.darkGoldenRod)
                    
                    Div().clear(.both).height(3.px)

                    Div {

                        ForEach(self.families) { family in
                            self.familyListButton(family)
                        }

                        Div().clear(.both)
                    }

                    Div().clear(.both).height(3.px)

                    H3("Ayuda")
                        .marginBottom(12.px)
                        .fontSize(18.px)
                        .color(.darkGoldenRod)

                    Div().clear(.both).height(3.px)

                    Div {

                        ForEach(self.buttons) { item in
                            self.generalListButton(item)
                        }

                        Div().clear(.both)
                    }
                    
                    Div().clear(.both).height(3.px)

                }
                .custom("width", "270px")
                .custom("height", "calc(100% - 28px)")
                .float(.left)
                .backgroundColor(.grayBlackDark)
                .borderRadius(all: 14.px)
                .padding(all: 14.px)
                .overflow(.auto)
                
                // MARK: DOC body
                Div {
                    Div {
                        H2("Manual de usuario")
                            .color(.white)
                            .fontSize(24.px)
                            .float(.left)
                        
                        Div("Skyline > Documentacion")
                            .color(.lightGray)
                            .fontSize(13.px)
                            .float(.right)
                            .paddingTop(7.px)
                        
                        Div().class(.clear)
                    }
                    .paddingBottom(14.px)
                    .borderBottom(width: .thin, style: .solid, color: .grayBlackDark)
                    
                    Div {
                        
                        H3("Lista de documentacion")
                            .color(.lightBlueText)
                            .fontSize(21.px)
                            .marginBottom(14.px)
                        
                        self.mainContainer

                    }
                    .backgroundColor(.grayBlackDark)
                    .borderRadius(all: 14.px)
                    .padding(all: 18.px)
                    .marginTop(18.px)
                    .hidden(self.$selectedFamily.map{ $0 != nil })
                    
                    Div {
                        Div {

                            H3(self.$selectedFamily.map { $0?.documentableName ?? "N/A" })
                                .color(.white)
                                .fontSize(21.px)
                                .marginBottom(10.px)
                            
                            Div {

                                Img()
                                    .src(self.$selectedFamily.map { self.iconPath(for: $0 ?? .general) })
                                    .width(42.px)
                                    .height(42.px)
                                    .marginRight(14.px)
                                    .float(.left)
                                
                                Div {

                                    Strong("Resumen")
                                        .color(.darkOrange)
                                        .fontSize(16.px)
                                    
                                    P(self.$selectedFamily.map { $0?.documentableDescription ?? "N/A" })
                                        .color(.lightGray)
                                        .fontSize(15.px)
                                        .marginTop(6.px)
                                        .lineHeight(22.px)
                                }
                                .custom("width", "calc(100% - 58px)")
                                .float(.left)
                                
                                Div().class(.clear)


                            }
                        }
                        .backgroundColor(.grayBlackDark)
                        .borderRadius(all: 14.px)
                        .padding(all: 18.px)

                        Div {
                            
                            ForEach(self.$currentDocs) { item in

                                Div {
                                    
                                    Div{
                                        
                                        H4(item.title)
                                        .color(.white)

                                        Div().clear(.both).height(3.px)

                                        Span(item.objective)
                                        .fontSize(16.px)
                                        .color(.gray)

                                        if !item.keywords.isEmpty {

                                            Div().clear(.both)

                                            Span(item.keywords.joined(separator: ", "))
                                            .fontSize(14.px)
                                            .color(.white)
                                        }

                                    }
                                    
                                }
                                .custom("width", "calc(100% - 16px)")
                                .class(.uibtnLarge)
                                .onClick {
                                    self.openDocument(item.id)
                                }

                                Div().clear(.both).height(7.px)
                                
                            }
                            
                        }

                    }
                    .marginTop(18.px)
                    .hidden(self.$selectedFamily.map{ $0 == nil })
                    
                }
                .custom("width", "calc(100% - 335px)")
                .custom("height", "calc(100% - 28px)")
                .float(.right)
                .backgroundColor(.grayBlack)
                .borderRadius(all: 14.px)
                .padding(all: 14.px)
                .overflow(.auto)
                .hidden(self.$selectedView.map{ !($0 == .docs) })

                // MARK: ERROR body
                Div {
                    
                    Div {
                        H2("Reportes de Errores")
                            .color(.white)
                            .fontSize(24.px)
                            .float(.left)
                        
                        Div("Skyline > Errores")
                            .color(.lightGray)
                            .fontSize(13.px)
                            .float(.right)
                            .paddingTop(7.px)
                        
                        Div().class(.clear)
                    }
                    .paddingBottom(14.px)
                    .borderBottom(width: .thin, style: .solid, color: .grayBlackDark)
                    
                    Div{
                        Div {
                            Div(self.$errorReports.map { records in
                                let pending = records.filter { !$0.reported }.count
                                let completed = records.count - pending
                                return "\(pending) pendientes • \(completed) completados"
                            })
                            .color(.lightGray)
                            .fontSize(14.px)
                            .paddingTop(9.px)
                            .float(.left)

                            Div("Actualizar")
                                .color(.white)
                                .backgroundColor(.slateHeader)
                                .borderRadius(all: 7.px)
                                .padding(v: 8.px, h: 14.px)
                                .cursor(.pointer)
                                .float(.right)
                                .onClick {
                                    self.loadErrorReports()
                                }

                            Div().class(.clear)
                        }
                        .marginBottom(12.px)

                        Div("Cargando reportes locales...")
                            .color(.lightGray)
                            .fontSize(15.px)
                            .padding(all: 18.px)
                            .textAlign(.center)
                            .hidden(self.$errorReportsLoadState.map { $0 != .loading })

                        Div(self.$errorReportsLoadState.map { state in
                            guard case .failed(let message) = state else { return "" }
                            return message
                        })
                        .color(.red)
                        .fontSize(15.px)
                        .padding(all: 18.px)
                        .textAlign(.center)
                        .hidden(self.$errorReportsLoadState.map { state in
                            guard case .failed = state else { return true }
                            return false
                        })

                        Table().noResult(label: "No hay reportes de error locales.")
                            .hidden(self.$errorReportsLoadState.map { $0 != .empty })

                        ForEach(self.$errorReports) { record in
                            self.errorReportCard(record)
                        }
                    }
                    .custom("height", "calc(100% - 43px)")
                    .overflow(.auto)
                    
                    
                }
                .custom("width", "calc(100% - 335px)")
                .custom("height", "calc(100% - 28px)")
                .float(.right)
                .backgroundColor(.grayBlack)
                .borderRadius(all: 14.px)
                .padding(all: 14.px)
                .overflow(.auto)
                .hidden(self.$selectedView.map{ !($0 == .errors) })


                    /*

    @State var selectedFamily: DocumentFamily? = nil

    @State var selectedButton: GeneralButton? = nil
*/
                
                Div().class(.clear)
            }
            .custom("height","calc(100% - 35px)")
            
        }
        .custom("height","calc(100% - 45px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(25.px)
    }

    @DOM private func familyListButton(_ family: DocumentFamily) -> DOM.Content {

        Div {

            Img()
                .src(self.iconPath(for: family))
                .width(22.px)
                .height(22.px)
                .marginRight(10.px)
                .float(.left)
            
            Div(family.documentableName)
                .color(self.$selectedFamily.map { $0 == family ? .white : .lightGray })
                .fontSize(16.px)
                .custom("width", "calc(100% - 34px)")
                .float(.left)
                .class(.oneLineText)
            
            Div().class(.clear)

        }
        .backgroundColor(self.$selectedFamily.map { $0 == family ? .slateHeader : .transparent })
        .borderLeft(width: .medium, style: .solid, color: self.$selectedFamily.map { $0 == family ? .darkOrange : .transparent })
        .borderRadius(all: 7.px)
        .padding(v: 9.px, h: 10.px)
        .marginBottom(7.px)
        .cursor(.pointer)
        .onClick {
            self.selectFamily(family)
        }
    }

    @DOM private func generalListButton(_ icon: GeneralButton) -> DOM.Content {

        Div {
            
            Img()
                .src("/skyline/media/\(icon.icon)")
                .width(22.px)
                .height(22.px)
                .marginRight(10.px)
                .float(.left)
            
            Div(icon.description)
                .color(self.$selectedButton.map { $0 == icon ? .white : .lightGray })
                .custom("width", "calc(100% - 34px)")
                .fontSize(16.px)
                .float(.left)
                .class(.oneLineText)
            
            Div().class(.clear)

        }
        .backgroundColor(self.$selectedButton.map { $0 == icon ? .slateHeader : .transparent })
        .borderLeft(width: .medium, style: .solid, color: self.$selectedButton.map { $0 == icon ? .darkOrange : .transparent })
        .borderRadius(all: 7.px)
        .padding(v: 9.px, h: 10.px)
        .marginBottom(7.px)
        .cursor(.pointer)
        .onClick {
            self.selectButton(icon)
        }
    }

    func familyGridButton(_ family: DocumentFamily) -> Div {
        Div {

            Img()
                .src(self.iconPath(for: family))
                .width(35.px)
                .height(35.px)
                .marginBottom(10.px)
            
            H3(family.documentableName)
                .color(.white)
                .fontSize(17.px)
                .marginBottom(8.px)
                .textAlign(.center)
            
            P(family.documentableDescription)
                .color(.lightGray)
                .fontSize(13.px)
                .lineHeight(19.px)
                .textAlign(.center)
        }
        .backgroundColor(self.$selectedFamily.map { $0 == family ? .slateHeader : .backGroundGraySlate })
        .border(width: .thin, style: .solid, color: self.$selectedFamily.map { $0 == family ? .darkOrange : .grayBlack })
        .boxShadow(h: 0.px, v: 2.px, blur: 9.px, color: .grayBlackDark)
        .borderRadius(all: 10.px)
        .padding(all: 16.px)
        .custom("min-height", "145px")
        .align(.center)
        .cursor(.pointer)
        .onClick {
            self.selectFamily(family)
        }
    }

    private func iconPath(for family: DocumentFamily) -> String {
        "/skyline/DocumentFamilyIcons/\(family.rawValue).svg"
    }

    override func buildUI() {
        
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

        families.forEach { item in 
            let view = familyGridButton(item)
            mainContainer.appendChild(view)
        }

        $selectedFamily.listen {
            if let _ = $0 {
                self.selectedView = .docs
                self.selectedButton = nil       
            }
        }

        $selectedButton.listen {
            if let _ = $0 {
                self.selectedView = .errors
                self.selectedFamily = nil       
            }
        }

    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $selectedFamily.removeAllListeners()
        $selectedButton.removeAllListeners()
    }

    func selectFamily(_ family: DocumentFamily) {

        loadingView.show()

        API.v1.skylineDocuments(
            family: family
        ) { resp in

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

            self.currentDocs = payload

            self.selectedFamily = family    
            
        }

    }

    func selectButton(_ button: GeneralButton) {
        self.selectedButton = button
        if button == .errorReport {
            loadErrorReports()
        }
    }

    func loadErrorReports() {
        errorReportsLoadState = .loading

        ErrorReportingControler.shared.getRecords { result in
            switch result {
            case .success(let records):
                self.errorReports = records
                self.errorReportsLoadState = records.isEmpty ? .empty : .loaded
            case .failure(let error):
                self.errorReports = []
                self.errorReportsLoadState = .failed(
                    "No se pudieron cargar los reportes locales: \(error.description)"
                )
            }
        }
    }

    @DOM private func errorReportCard(_ record: ErrorReportRecord) -> DOM.Content {
        Div {
            Div {
                H4(record.errorTitle)
                    .color(.white)
                    .fontSize(17.px)
                    .custom("width", "calc(100% - 110px)")
                    .float(.left)

                Span(record.reported ? "Completado" : "Pendiente")
                    .color(record.reported ? .green : .darkOrange)
                    .fontSize(13.px)
                    .textAlign(.right)
                    .custom("width", "100px")
                    .float(.right)

                Div().class(.clear)
            }

            Div(
                "\(record.category.rawValue) • Prioridad: \(record.priorty.description) • " +
                "Ocurrencias: \(record.occurrenceCount) • Reintentos: \(record.retries)"
            )
            .color(.lightGray)
            .fontSize(13.px)
            .marginTop(6.px)

            Div("Generado: \(self.errorReportDate(record.createdAt)) • Último evento: \(self.errorReportDate(record.lastOccurredAt))")
                .color(.gray)
                .fontSize(13.px)
                .marginTop(5.px)

            if let reportedAt = record.reportedAt {
                Div("Completado: \(self.errorReportDate(reportedAt))")
                    .color(.gray)
                    .fontSize(13.px)
                    .marginTop(5.px)
            }

            if !record.endpoint.isEmpty {
                Div("Solicitud: \(record.method) \(record.endpoint)")
                    .color(.lightBlueText)
                    .fontSize(13.px)
                    .marginTop(7.px)
            }

            if let status = record.httpStatus {
                Div("HTTP: \(status) \(record.httpStatusText ?? "")")
                    .color(.lightGray)
                    .fontSize(13.px)
                    .marginTop(5.px)
            }

            if !record.sourceFile.isEmpty {
                Div("Origen: \(self.errorReportSource(record))")
                    .color(.gray)
                    .fontSize(13.px)
                    .marginTop(5.px)
            }

            P(self.errorReportSummary(record.error))
                .color(.white)
                .fontSize(14.px)
                .lineHeight(20.px)
                .marginTop(9.px)
                .custom("white-space", "pre-wrap")
                .custom("overflow-wrap", "anywhere")

            if let reportingError = record.lastReportingError, !reportingError.isEmpty {
                Div("Último error de envío: \(self.errorReportSummary(reportingError, limit: 300))")
                    .color(.red)
                    .fontSize(13.px)
                    .marginTop(7.px)
            }
        }
        .backgroundColor(.grayBlackDark)
        .borderLeft(
            width: .medium,
            style: .solid,
            color: record.reported ? .green : .darkOrange
        )
        .borderRadius(all: 10.px)
        .padding(all: 16.px)
        .marginBottom(10.px)
    }

    private func errorReportDate(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let components = Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute, .second],
            from: date
        )
        guard
            let day = components.day,
            let month = components.month,
            let year = components.year,
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second
        else {
            return timestamp.toString
        }
        return "\(twoDigit(day))/\(twoDigit(month))/\(year) \(twoDigit(hour)):\(twoDigit(minute)):\(twoDigit(second))"
    }

    private func twoDigit(_ value: Int) -> String {
        value < 10 ? "0\(value)" : value.toString
    }

    private func errorReportSource(_ record: ErrorReportRecord) -> String {
        let file = record.sourceFile.split(separator: "/").last.map(String.init) ?? record.sourceFile
        return "\(file):\(record.sourceLine) • \(record.sourceFunction)"
    }

    private func errorReportSummary(_ value: String, limit: Int = 800) -> String {
        guard value.count > limit else { return value }
        return String(value.prefix(limit)) + "…"
    }

    func openDocument(_ documentId: UUID) {

        loadingView.show()

        API.v1.skylineDocument(
            documentId: documentId
        ) { resp in

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

            guard let family = self.selectedFamily else {
                print("No famaly selected")
                return
            }

            print("I HAVE payload.documentBody.count ")

            print(payload.documentBody.count)

            let view = DocumentView(
                    family: family,
                    item: payload.item,
                    documentBody: payload.documentBody
                )

            addToDom(view)


            
        }
    }

    enum GeneralButton: String, CaseIterable {


        case errorReport
    
        var description: String {
            switch self {
                case .errorReport:
                    return "Reporte de Errores"
                
            }
        }

        var icon: String {
            switch self {
                case .errorReport:
                    return "debug_white_icon.png"
                
            }
        }



    }

    enum SelectedView {
        case docs
        case errors
    }

    enum ErrorReportsLoadState: Hashable {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

}
