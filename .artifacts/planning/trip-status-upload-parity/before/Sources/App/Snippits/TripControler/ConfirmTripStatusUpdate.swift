//
// ConfirmTripStatusUpdate.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

final class ConfirmTripStatusUpdate: Div {

    override class var name: String { "div" }

    private static let accent: Color = .init(r: 36, g: 185, b: 232)
    private static let secondaryText: Color = .init(r: 176, g: 205, b: 220)

    let currentStatus: FiscalTripFollowupStatus
    let nextStatus: FiscalTripFollowupStatus
    public var merchandise: [FiscalMercanciaItem]
    let locations: [FiscalLocationItem]

    private let callback: (
        FiscalTripFollowupStatus, String, [CustCommercialTripsComponents.ChangeTripStatusMedia]
    ) -> Void
    private var rows: [MerchandiseRow] = []
    private var didConfirm = false
    private let ws = WS()

    @State private var comment = ""

    init(
        currentStatus: FiscalTripFollowupStatus,
        nextStatus: FiscalTripFollowupStatus,
        merchandise: [FiscalMercanciaItem],
        locations: [FiscalLocationItem],
        callback: @escaping (
            FiscalTripFollowupStatus, String, [CustCommercialTripsComponents.ChangeTripStatusMedia]
        ) -> Void
    ) {
        self.currentStatus = currentStatus
        self.nextStatus = nextStatus
        self.merchandise = merchandise
        self.locations = locations
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private var actionTitle: String {
        switch nextStatus {
        case .inProgress: return "Iniciar Viaje"
        case .completed: return "Completar Viaje"
        case .cancelled: return "Cancelar Viaje"
        case .pending: return "Confirmar estatus"
        }
    }

    private var isValidTransition: Bool {
        Self.isValidTransition(current: currentStatus, requested: nextStatus)
    }

    static func isValidTransition(current: FiscalTripFollowupStatus, requested: FiscalTripFollowupStatus) -> Bool {
        switch (current, requested) {
        case (.pending, .inProgress), (.pending, .cancelled),
             (.inProgress, .completed), (.inProgress, .cancelled):
            return true
        default:
            return false
        }
    }

    static func assetRouteError(merchandise: [FiscalMercanciaItem], locations: [FiscalLocationItem]) -> String? {
        var assetIds = Set<UUID>()
        for item in merchandise where item.merchandiseType == .commercialAsset {
            guard let id = item.merchandiseId, assetIds.insert(id).inserted else {
                return "Un activo del viaje no tiene identificador o está duplicado."
            }
            for (reference, role) in [(item.from, TipoUbicacion.origen), (item.to, TipoUbicacion.destino)] {
                let reference = reference.purgeSpaces
                let matches = locations.filter { $0.placementId.purgeSpaces == reference }
                guard !reference.isEmpty, matches.count == 1, let location = matches.first,
                      location.placementType == role, location.locationId != nil else {
                    return "El origen y destino de cada activo deben tener un registro vinculado y una referencia única."
                }
                switch location.locationType {
                case .store, .warehouse, .subaccount: break
                default: return "Los activos solo pueden viajar entre tiendas, bodegas y subcuentas."
                }
            }
        }
        return nil
    }

    static func validationError(
        current: FiscalTripFollowupStatus, requested: FiscalTripFollowupStatus,
        comment: String, media: [CustCommercialTripsComponents.ChangeTripStatusMedia],
        merchandise: [FiscalMercanciaItem], locations: [FiscalLocationItem]
    ) -> String? {
        guard isValidTransition(current: current, requested: requested) else {
            return "El cambio de estatus solicitado no está disponible."
        }
        guard requested != .cancelled || !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Agregue un comentario para cancelar el viaje."
        }
        if let error = assetRouteError(merchandise: merchandise, locations: locations) { return error }
        let ids = Set(merchandise.map(\.id))
        var submitted = Set<UUID>()
        for entry in media {
            guard ids.contains(entry.merchandiseId), submitted.insert(entry.merchandiseId).inserted,
                  !entry.files.isEmpty, Set(entry.files).count == entry.files.count else {
                return "La evidencia debe pertenecer a una mercancía del viaje, sin duplicados."
            }
            for name in entry.files {
                guard isValidImageName(name) else { return "El nombre de una imagen de evidencia no es válido." }
            }
        }
        return nil
    }

    private static func isValidImageName(_ name: String) -> Bool {
        !name.isEmpty && name == name.trimmingCharacters(in: .whitespacesAndNewlines) &&
        !name.contains("/") && !name.contains("\\") &&
        name.rangeOfCharacter(from: .controlCharacters) == nil &&
        ["jpg", "jpeg", "png", "gif", "webp"].contains((name as NSString).pathExtension.lowercased())
    }

    private lazy var commentField = UTextArea(self.$comment)
        .placeholder(nextStatus == .cancelled ? "Indique el motivo de la cancelación" : "Agregue un comentario (opcional)")
        .width(100.percent)
        .custom("height", "180px !important")
        .custom("min-height", "120px")
        .custom("resize", "vertical")
        .custom("box-sizing", "border-box")

    private lazy var merchandiseList = Div()
        .custom("display", "flex")
        .custom("flex-direction", "column")
        .custom("gap", "10px")
        .custom("flex", "1")
        .custom("min-height", "0")
        .overflow(.auto)

    @DOM override var body: DOM.Content {
        VPopUp(.semiFull) {
            VTitle(self.actionTitle, icon: "icon_route.png") {
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.half) {
                    VBox(.raised) {
                        UTitle("Cambio de estatus")

                        self.statusCard("Estatus actual", self.currentStatus)
                        self.statusCard("Nuevo estatus", self.nextStatus)

                        UField("Comentarios", required: self.nextStatus == .cancelled) {
                            self.commentField
                        }

                        UMinorTitle(self.nextStatus == .cancelled
                            ? "Para cancelar el viaje es necesario agregar un comentario."
                            : "Puede agregar comentarios e imágenes de la mercancía.")

                        Div().custom("flex", "1")

                        ULargeButton(self.actionTitle)
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .onClick { self.confirm() }
                    }
                    .custom("display", "flex")
                    .custom("flex-direction", "column")
                    .custom("gap", "14px")
                    .custom("min-height", "0")
                }
                .custom("align-content", "stretch")

                VGrid(.half) {
                    VBox(.raised) {
                        UTitle("Mercancía · \(self.merchandise.count)")
                        UMinorTitle("Adjunte imágenes o use la cámara remota. Toque la imagen para ver los adjuntos.")
                        self.merchandiseList
                    }
                    .custom("display", "flex")
                    .custom("flex-direction", "column")
                    .custom("gap", "14px")
                    .custom("min-height", "0")
                }
                .custom("align-content", "stretch")
                .custom("min-height", "0")
            }
            .custom("align-content", "stretch")
        }
    }

    override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)
        position(.absolute)
        left(0.px)
        top(0.px)
        width(100.percent)
        height(100.percent)

        rows = merchandise.map { MerchandiseRow(item: $0) }
        if rows.isEmpty {
            merchandiseList.appendChild(UMinorTitle("Este viaje no tiene mercancía."))
        } else {
            rows.forEach { merchandiseList.appendChild($0) }
        }

        WebApp.current.wsevent.listen { [weak self] message in
            guard let self, self.isInDOM, !message.isEmpty else { return }
            self.receiveMediaEvent(message)
        }
    }

    private func statusCard(_ label: String, _ status: FiscalTripFollowupStatus) -> Div {
        Div {
            UMinorTitle(label)
            Div(status.description)
                .fontSize(20.px)
                .fontWeight(.bold)
                .color(Self.accent)
                .marginTop(6.px)
        }
        .custom("background", "rgba(3, 18, 32, 0.68)")
        .custom("border", "1px solid #245a7c")
        .custom("border-left", "3px solid #24b9e8")
        .custom("border-radius", "10px")
        .padding(all: 12.px)
    }

    private func confirm() {
        guard isInDOM, !didConfirm else { return }
        guard isValidTransition else {
            showError(.generalError, "El cambio de estatus solicitado no está disponible.")
            return
        }
        let comment = self.comment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard nextStatus != .cancelled || !comment.isEmpty else {
            showError(.generalError, "Agregue un comentario para cancelar el viaje.")
            commentField.focus()
            return
        }
        guard !rows.contains(where: { $0.hasPendingUploads }) else {
            showError(.generalError, "Espere a que terminen las imágenes o cancele la solicitud de cámara pendiente.")
            return
        }

        let media: [CustCommercialTripsComponents.ChangeTripStatusMedia] = rows.compactMap { row in
            let files = row.completedFiles.map { $0.file }
            guard !files.isEmpty else { return nil }
            return .init(merchandiseId: row.item.id, files: files)
        }
        if let error = Self.validationError(
            current: currentStatus, requested: nextStatus, comment: comment, media: media,
            merchandise: merchandise, locations: locations
        ) {
            showError(.generalError, error)
            return
        }
        didConfirm = true
        callback(nextStatus, comment, media)
        remove()
    }

    private func receiveMediaEvent(_ message: String) {
        let (event, _) = ws.recive(message)
        switch event {
        case .asyncFileUpload:
            guard let payload = ws.asyncFileUpload(message) else { return }
            row(for: payload.eventid)?.complete(
                eventId: payload.eventid, type: payload.type,
                file: payload.fileName, avatar: payload.avatar, url: payload.url
            )
        case .asyncFileUpdate:
            guard let payload = ws.asyncFileUpdate(message) else { return }
            row(for: payload.eventId)?.setProgress(payload.message, eventId: payload.eventId)
        case .requestMobileCamaraComplete:
            guard let payload = ws.requestMobileCamaraComplete(message) else { return }
            row(for: payload.eventid)?.complete(
                eventId: payload.eventid, type: payload.type,
                file: payload.file, avatar: payload.avatar, url: payload.url
            )
        case .requestMobileCamaraProgress:
            guard let payload = ws.requestMobileCamaraProgress(message) else { return }
            row(for: payload.eventid)?.setProgress("\(payload.percent)%", eventId: payload.eventid)
        case .requestMobileCamaraFail:
            guard let payload = ws.requestMobileCamaraFail(message),
                  let row = row(for: payload.eventid) else { return }
            row.fail(eventId: payload.eventid, message: payload.error)
        case .requestMobileCamaraCancel:
            guard let payload = ws.requestMobileCamaraCancel(message) else { return }
            row(for: payload.eventid)?.fail(eventId: payload.eventid)
        default:
            break
        }
    }

    private func row(for eventId: UUID) -> MerchandiseRow? {
        rows.first { $0.contains(eventId) }
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        rows.forEach { $0.stopUploads() }
        $comment.removeAllListeners()
    }
}

private extension ConfirmTripStatusUpdate {

    final class MerchandiseRow: Div {

        override class var name: String { "div" }

        let item: FiscalMercanciaItem
        // Stage unregistered images with the existing asset upload pipeline.
        // Merchandise association is returned by the parent, never saved here.
        private let destination: ImagePickerTo = .asset
        private var order: [UUID] = []
        private var pending: [UUID: String] = [:]
        private var files: [UUID: MediaViewer.MediaFile] = [:]
        private var requests: [UUID: XMLHttpRequest] = [:]
        private var cameraEventId: UUID?
        private var avatarEventId: UUID?
        private var viewer: MediaViewer?

        @State private var avatar = "/skyline/media/tierraceroRoundLogoWhite.svg"
        @State private var imageCount = 0
        @State private var progress = ""
        @State private var isCameraPending = false

        var hasPendingUploads: Bool { !pending.isEmpty }
        var completedFiles: [MediaViewer.MediaFile] { order.compactMap { files[$0] } }

        init(item: FiscalMercanciaItem) {
            self.item = item
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        private lazy var fileInput = InputFile()
            .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
            .multiple(true)
            .display(.none)

        @DOM override var body: DOM.Content {
            self.fileInput

            Div {
                Img()
                    .src(self.$avatar)
                    .attribute("alt", "Imágenes de \(self.item.description)")
                    .attribute("title", "Ver imágenes")
                    .width(64.px)
                    .height(64.px)
                    .custom("object-fit", "contain")
                    .custom("border-radius", "8px")
                    .cursor(.pointer)
                    .onClick { self.openViewer() }

                Div(self.$imageCount.map { "\($0) imágenes" })
                    .fontSize(12.px)
                    .color(ConfirmTripStatusUpdate.secondaryText)
            }
            .custom("flex", "0 0 76px")
            .textAlign(.center)

            Div {
                Div(self.item.description)
                    .fontWeight(.bold)
                    .color(.init(r: 232, g: 242, b: 251))
                Div("\(self.item.units.formatMoney) \(self.item.fiscUnitName) · \(self.item.kilograms.formatMoney) kg")
                    .fontSize(14.px)
                    .color(ConfirmTripStatusUpdate.secondaryText)
                    .marginTop(5.px)
                Div(self.$progress)
                    .fontSize(13.px)
                    .color(ConfirmTripStatusUpdate.accent)
                    .marginTop(5.px)
                    .hidden(self.$progress.map { $0.isEmpty })
                Button("Cancelar cámara")
                    .class(Class(TCCrystalSurfaceClass.goodButton))
                    .hidden(self.$isCameraPending.map { !$0 })
                    .display(self.$isCameraPending.map { $0 ? .inlineFlex : .none })
                    .marginTop(5.px)
                    .onClick {
                        if let eventId = self.cameraEventId {
                            self.fail(eventId: eventId)
                        }
                    }
            }
            .custom("flex", "1")
            .custom("min-width", "0")
            .custom("overflow-wrap", "anywhere")

            self.attachmentIcons()
        }

        override func buildUI() {
            super.buildUI()
            custom("display", "flex")
            custom("align-items", "center")
            custom("gap", "10px")
            custom("padding", "12px")
            custom("border", "1px solid #245a7c")
            custom("border-radius", "10px")
            custom("background", "rgba(22, 29, 40, 0.78)")
            custom("flex", "0 0 auto")

            fileInput.$files.listen { [weak self] files in
                guard let self, self.isInDOM else { return }
                files.forEach { self.upload($0) }
                #if arch(wasm32)
                self.fileInput.domElement.value = .string("")
                #endif
            }
        }

        private func attachmentIcons() -> Div {
            Div {
                Img()
                    .src("/skyline/media/icon_clip.png")
                    .class(.iconWhite)
                    .width(24.px)
                    .height(24.px)
                    .attribute("alt", "Adjuntos")
                    .attribute("title", "Adjuntos")
                    .cursor(.pointer)
                    .onClick { self.fileInput.click() }

                Img()
                    .src("/skyline/media/mobileCamara.png")
                    .class(.iconWhite)
                    .width(24.px)
                    .height(24.px)
                    .attribute("alt", "Cámara remota")
                    .attribute("title", "Cámara remota")
                    .cursor(.pointer)
                    .onClick { self.requestCamera() }
            }
            .custom("display", "flex")
            .custom("flex-direction", "column")
            .custom("align-items", "center")
            .custom("gap", "4px")
            .marginBottom(4.px)
        }

        func contains(_ eventId: UUID) -> Bool { pending[eventId] != nil }

        private func begin(_ eventId: UUID, message: String) {
            order.append(eventId)
            pending[eventId] = message
            refresh()
        }

        func setProgress(_ message: String, eventId: UUID) {
            guard isInDOM, contains(eventId) else { return }
            pending[eventId] = message
            refresh()
        }

        func complete(eventId: UUID, type: FileTypes, file: String, avatar: String, url: String) {
            guard isInDOM, contains(eventId) else { return }
            guard type == .image, !file.isEmpty, !url.isEmpty else {
                fail(eventId: eventId, message: "Adjunte únicamente imágenes válidas.")
                return
            }
            // HTTP and WebSocket completion can describe the same upload.
            if !files.values.contains(where: { $0.file == file && $0.url == url }) {
                files[eventId] = .init(fileId: nil, file: file, avatar: avatar, type: .image, url: url)
                if avatarEventId == nil { avatarEventId = eventId }
            } else {
                order.removeAll { $0 == eventId }
            }
            pending.removeValue(forKey: eventId)
            requests.removeValue(forKey: eventId)
            if cameraEventId == eventId {
                cameraEventId = nil
                isCameraPending = false
            }
            refresh()
        }

        func fail(eventId: UUID, message: String? = nil) {
            guard contains(eventId) else { return }
            pending.removeValue(forKey: eventId)
            order.removeAll { $0 == eventId }
            let request = requests.removeValue(forKey: eventId)
            request?.abort()
            if cameraEventId == eventId {
                cameraEventId = nil
                isCameraPending = false
            }
            refresh()
            if isInDOM, let message {
                showError(.generalError, message)
            }
        }

        private func refresh() {
            let completed = completedFiles
            imageCount = completed.count
            if let first = avatarEventId.flatMap({ files[$0] }) {
                let original = first.avatar.isEmpty ? first.file : first.avatar
                let path = original as NSString
                let directory = path.deletingLastPathComponent
                let name = path.lastPathComponent.hasPrefix("thump_") ? original :
                    (directory.isEmpty ? "" : directory + "/") + "thump_" + path.lastPathComponent
                avatar = name.hasPrefix("http") || name.hasPrefix("/") ? name : (first.url ?? "") + name
            }
            progress = order.compactMap { pending[$0] }.joined(separator: " · ")
        }

        private func requestCamera() {
            guard isInDOM, cameraEventId == nil else { return }
            let eventId = UUID()
            cameraEventId = eventId
            isCameraPending = true
            begin(eventId, message: "Esperando cámara remota…")
            API.custAPIV1.requestMobileCamara(
                type: .useCamaraForAssetItem,
                connid: custCatchChatConnID,
                eventid: eventId,
                relatedid: nil,
                relatedfolio: "",
                multipleTakes: false
            ) { [weak self] response in

                guard let self, self.isInDOM, self.contains(eventId) else { return }

                guard let response else {
                    self.fail(eventId: eventId, message: "No se pudo solicitar la cámara remota.")
                    return
                }

                guard response.status == .ok else {
                    self.fail(eventId: eventId, message: response.msg)
                    return
                }

                showSuccess(.operacionExitosa, "Entre en la notificación en su móvil.")
                
            }
        }

        private func upload(_ file: File) {
            guard file.type.hasPrefix("image/") else {
                showError(.generalError, "Adjunte únicamente imágenes.")
                return
            }
            guard file.size <= 30 * 1_000_000 else {
                showError(.generalError, "No se pueden subir imágenes de más de 30 MB.")
                return
            }
            let eventId = UUID()
            let xhr = XMLHttpRequest()
            begin(eventId, message: "0%")
            requests[eventId] = xhr

            xhr.onError { [weak self] _ in
                self?.fail(eventId: eventId, message: "No se pudo cargar la imagen.")
            }
            xhr.onLoadEnd { [weak self, weak xhr] in
                guard let self, let xhr, self.isInDOM, self.contains(eventId) else { return }
                guard let data = xhr.responseText?.data(using: .utf8),
                      let response = try? decodeAPIResponse(APIResponseGeneric<CustComponents.UploadManagerResponse>.self, from: data) else {
                    self.fail(eventId: eventId, message: "No se pudo leer la respuesta de la carga.")
                    return
                }
                guard response.status == .ok, let result = response.data else {
                    self.fail(eventId: eventId, message: response.msg)
                    return
                }
                switch result {
                case .processing:
                    self.setProgress("Procesando…", eventId: eventId)
                    self.checkUpload(eventId, attempt: 0)
                case .processed(let payload):
                    self.complete(eventId: eventId, type: payload.type, file: payload.fileName, avatar: payload.avatar, url: payload.url)
                }
            }
            xhr.upload.addEventListener("progress", options: EventListenerAddOptions(
                capture: false, once: false, passive: false, mozSystemGroup: false
            )) { [weak self] event in
                let progress = ProgressEvent(event.jsEvent)
                guard progress.total > 0 else { return }
                let percent = Int(Double(progress.loaded) / Double(progress.total) * 100)
                self?.setProgress("\(percent)%", eventId: eventId)
            }

            let data = FormData()
            let name = safeFileName(name: file.name, to: destination, folio: eventId.uuidString)
            data.append("file", file, filename: name)
            data.append("eventid", eventId.uuidString)
            data.append("to", destination.rawValue)
            data.append("fileName", name)
            data.append("connid", custCatchChatConnID)
            data.append("remoteCamera", false.description)
            xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
            xhr.setRequestHeader("Accept", "application/json")
            xhr.setRequestHeader("WSId", custCatchChatConnID)
            guard let header = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID, AppToken: thisAppToken, url: custCatchUrl,
                user: custCatchUser, mid: custCatchMid, key: custCatchKey,
                token: custCatchToken, tcon: .web,
                applicationType: custCatchAccountType.sessionType
            )) else {
                fail(eventId: eventId, message: "No se pudo preparar la carga.")
                return
            }
            xhr.setRequestHeader("Authorization", header.base64EncodedString())
            xhr.send(data)
        }

        private func checkUpload(_ eventId: UUID, attempt: Int) {
            Dispatch.asyncAfter(7) { [weak self] in
                guard let self, self.isInDOM, self.contains(eventId) else { return }
                API.custAPIV1.asyncCheckUploadStatus(type: .upload, eventid: eventId) { [weak self] response in
                    guard let self, self.isInDOM, self.contains(eventId) else { return }
                    guard let response, response.status == .ok, let payload = response.data else {
                        self.fail(eventId: eventId, message: "No se pudo verificar la carga de la imagen.")
                        return
                    }
                    switch payload.status {
                    case .done:
                        guard let file = payload.image, !file.isEmpty else {
                            self.fail(eventId: eventId, message: "No se recibió la imagen procesada.")
                            return
                        }
                        let url = self.destination.url(url: custCatchUrl, pDir: pDir, isPreRegistration: true, accountType: custCatchAccountType)
                        self.complete(eventId: eventId, type: .image, file: file, avatar: "thump_" + file, url: url)
                    case .active, .processed:
                        if attempt < 20 {
                            self.checkUpload(eventId, attempt: attempt + 1)
                        } else {
                            self.fail(eventId: eventId, message: "La carga de la imagen tardó demasiado. Intente nuevamente.")
                        }
                    case .error:
                        self.fail(eventId: eventId, message: "Falló la carga de la imagen.")
                    }
                }
            }
        }

        private func openViewer() {
            let files = completedFiles
            guard !files.isEmpty, viewer == nil else { return }
            let view = MediaViewer(relid: nil, type: .content, url: "", files: files, currentView: 0, allowsMediaActions: false)
            viewer = view
            view.onDidRemoveFromDOM { [weak self] in self?.viewer = nil }
            addToDom(view, presentation: .interactive)
        }

        func stopUploads() {
            pending.removeAll()
            cameraEventId = nil
            isCameraPending = false
            let active = Array(requests.values)
            requests.removeAll()
            active.forEach { $0.abort() }
            viewer?.remove()
            viewer = nil
        }

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            stopUploads()
            fileInput.$files.removeAllListeners()
            $avatar.removeAllListeners()
            $imageCount.removeAllListeners()
            $progress.removeAllListeners()
            $isCameraPending.removeAllListeners()
        }
    }
}
