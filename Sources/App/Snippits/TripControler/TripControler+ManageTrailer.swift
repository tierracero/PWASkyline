//
// TripControler+ManageTrailer.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import XMLHttpRequest
import Web

class TripControlerManageTrailer: Div {

    override class var name: String { "div" }

    private var callback: (
        _ item: CallbackType
    ) -> Void

    let viewId: UUID = .init()
    let ws = WS()

    init(
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.callback = callback
        super.init()
    }

    init(
        item: CustCommercialTripTrailer,
        callback: @escaping (
            _ item: CallbackType
        ) -> Void
    ) {
        self.id = item.id
        self.createdAt = item.createdAt
        self.modifiedAt = item.modifiedAt
        self.status = item.status
        self.type = item.type
        self.typeListener = item.type.rawValue
        self.series = item.series
        self.name = item.name
        self.avatar = item.avatar
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @State var id: UUID? = nil

    var createdAt: Int64 = getNow()
    var modifiedAt: Int64 = getNow()
    var status: BasicStatus = .active

    /// caballete, caja, cajaAbierta, cajaCerrada
    @State var type: TipoRemolque? = nil
    @State var typeListener: String = ""

    @State var series: String = ""

    @State var name: String = ""

    @State var avatar: String? = nil

    @State var uploadPercent: String? = nil

    lazy var typeSelect = Select(self.$typeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)

    lazy var nameField = InputText(self.$name)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Nombre del Remolque")
        .onFocus { $0.select() }

    lazy var seriesField = InputText(self.$series)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
        .placeholder("Serie / Placas")
        .onFocus { $0.select() }

    lazy var fileLoader: InputFile = InputFile()
        .accept(["image/png", "image/gif", "image/jpeg", "image/jpg", "image/webp"])
        .hidden(true)

    lazy var imgAvatar = tripAvatarImage(nil)
        .custom("aspect-ratio", "1 / 1")
        .width(100.percent)
        .height(150.px)
        .cursor(.pointer)
        .onClick {
            self.fileLoader.click()
        }

    lazy var avatarPanel = Div {
        self.fileLoader

        Label("Avatar").color(.gray)

        Div {
            self.imgAvatar

            Img()
                .src("/skyline/media/upload2.png")
                .height(30.px)
                .position(.absolute)
                .right(6.px)
                .bottom(6.px)
                .cursor(.pointer)
                .onClick {
                    self.fileLoader.click()
                }

            Div {
                Table {
                    Tr {
                        Td(self.$uploadPercent.map { $0 ?? "" })
                            .verticalAlign(.middle)
                            .fontSize(18.px)
                            .align(.center)
                            .color(.white)
                    }
                }
                .backgroundColor(.init(r: 0, g: 0, b: 0, a: 0.5))
                .height(100.percent)
                .width(100.percent)
            }
            .hidden(self.$uploadPercent.map { $0 == nil })
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .overflow(.hidden)
            .left(0.px)
            .top(0.px)
        }
        .position(.relative)
        .width(100.percent)
        .align(.center)
    }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Div {
                    Img()
                        .src("/skyline/media/icon_trailer.png")
                        .class(.iconBlue)
                        .height(24.px)

                    H2(self.$id.map{ ($0 == nil) ?  "Crear Remolque" : "Editar Remolque" })
                        .margin(all: 0.px)
                        .class(Class(TCTripBetaClass.titleText))
                }
                .display(.flex)
                .custom("align-items", "center")
                .custom("gap", "8px")
                .custom("min-width", "0")

                Img()
                    .closeButton(.uiView2)
                    .class(Class(TCTripBetaClass.close))
                    .onClick {
                        self.remove()
                    }
            }
            .class(Class(TCTripBetaClass.title))

            Div {
                Div {
                    Div {
                        Label("Tipo de Remolque").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.typeSelect
                    }
                    .class(.section)

                    Div().class(.clear).height(7.px)

                    Div {
                        Label("Nombre").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.nameField
                    }
                    .width(50.percent)
                    .float(.left)

                    Div {
                        Label("Serie / Placas").color(.gray)
                        Div().class(.clear).height(3.px)
                        self.seriesField
                    }
                    .width(50.percent)
                    .float(.left)

                    Div().class(.clear)
                }
                .class(
                    Class(TCTripBetaClass.box),
                    Class(TCTripBetaClass.boxRaised)
                )
                .padding(all: 10.px)
                .marginTop(10.px)
                .marginBottom(10.px)
                .width(72.percent)
                .float(.left)

                self.avatarPanel
                    .width(25.percent)
                    .float(.right)

                Div().class(.clear)

                Div {

                    Div("Eliminar")
                        .class(.uibtn)
                        .onClick {
                            self.deleteItem()
                        }
                        .hidden(self.$id.map{ ($0 == nil) })

                    Div(self.$id.map{ ($0 == nil) ?  "Agregar" : "Guardar Cambios" })
                        .class(.uibtn)
                        .onClick {
                            self.saveData()
                        }
                }
                .class(Class(TCTripBetaClass.titleActions))
                .custom("margin-top", "12px")

            }
            .custom("flex-direction", "column")
            .custom("gap", "12px")
            .custom("min-height", "0")
            .custom("overflow", "auto")
            .custom("box-sizing", "border-box")
            .padding(all: 12.px)
        }
        .class(
            Class(TCTripBetaClass.popUpPanel),
            Class(TCTripBetaClass.popUpPanelFitContent)
        )
        .custom("max-width", "620px !important")
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        self.class(Class(TCTripBetaClass.popUp))
        self.attribute("role", "dialog")
        self.attribute("aria-modal", "true")

        if let avatar {
            imgAvatar.load(tripAvatarSource(avatar))
        }

        fileLoader.$files.listen {
            $0.forEach { self.loadMedia($0) }
        }

        WebApp.current.wsevent.listen {
            guard !$0.isEmpty else { return }

            let (event, _) = self.ws.recive($0)

            guard let event else { return }

            switch event {
            case .asyncFileUpload:
                guard let payload = self.ws.asyncFileUpload($0), payload.eventid == self.viewId else {
                    return
                }

                self.uploadPercent = nil
                self.avatar = payload.avatar
                self.imgAvatar.load(tripAvatarSource(payload.avatar))
                self.notifyAvatarUpdated()

            case .asyncFileUpdate:
                guard let payload = self.ws.asyncFileUpdate($0), payload.eventId == self.viewId else {
                    return
                }

                self.uploadPercent = payload.message

            default:
                break
            }
        }

        typeSelect.appendChild(
            Option("Seleccione")
                .value("")
        )

        TipoRemolque.allCases.forEach { type in
            typeSelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }

        $typeListener.listen { rawValue in
            self.type = TipoRemolque(rawValue: rawValue)

            if self.name.isEmpty {
                self.name = self.type?.description ?? ""
            }
        }
    }

    func saveData() {
        guard let type else {
            showError(.requiredField, "Seleccione tipo de remolque")
            return
        }

        guard !name.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese nombre del remolque")
            nameField.select()
            return
        }

        guard !series.purgeSpaces.isEmpty else {
            showError(.requiredField, "Ingrese serie o placas del remolque")
            seriesField.select()
            return
        }

        loadingView.show()

        if let id {
            API.custCommercialTrips.updateTrailer(
                trailerId: id,
                trailerType: type.rawValue,
                trailerTypeName: name,
                trailerLicensePlate: series,
                avatar: avatar
            ) { resp in
                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.update(.init(
                    id: id,
                    createdAt: self.createdAt,
                    modifiedAt: getNow(),
                    type: type,
                    series: self.series,
                    name: self.name,
                    avatar: self.avatar,
                    status: self.status
                )))

                self.remove()
            }

            return
        }

        API.custCommercialTrips.createTrailer(
            trailerType: type.rawValue,
            trailerTypeName: name,
            trailerLicensePlate: series,
            avatar: avatar
        ) { resp in
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
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }

            self.callback(.create(payload.item))
            self.remove()
        }
    }

    func deleteItem() {
        guard let id else { return }

        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Eliminar Remolque",
            message: "Confirme que desea eliminar este remolque."
        ) { isConfirmed, _ in
            guard isConfirmed else { return }

            loadingView.show()

            API.custCommercialTrips.deleteTrailer(trailerId: id) { resp in
                loadingView.hide()

                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }

                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }

                self.callback(.delete(id))
                self.remove()
            }
        })
    }

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()

        $id.removeAllListeners()
        $type.removeAllListeners()
        $typeListener.removeAllListeners()
        $series.removeAllListeners()
        $name.removeAllListeners()
        $avatar.removeAllListeners()
        $uploadPercent.removeAllListeners()
    }

    private func loadMedia(_ file: File) {
        uploadTripAvatar(
            file: file,
            eventId: viewId,
            id: id,
            to: .tripTrailer,
            progress: { self.uploadPercent = $0 },
            completed: { avatar in
                self.avatar = avatar
                self.imgAvatar.load(tripAvatarSource(avatar))
                self.notifyAvatarUpdated()
            }
        )
    }

    private func notifyAvatarUpdated() {
        guard let item = currentItem() else {
            return
        }

        callback(.update(item))
    }

    private func currentItem() -> CustCommercialTripTrailer? {
        guard let id, let type else {
            return nil
        }

        return .init(
            id: id,
            createdAt: createdAt,
            modifiedAt: getNow(),
            type: type,
            series: series,
            name: name,
            avatar: avatar,
            status: status
        )
    }
}

extension TripControlerManageTrailer {

    enum CallbackType {
        case create(CustCommercialTripTrailer)
        case update(CustCommercialTripTrailer)
        case delete(UUID)
    }

}
