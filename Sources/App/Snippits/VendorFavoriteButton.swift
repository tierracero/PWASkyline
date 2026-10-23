import Foundation
import TCFundamentals
import Web

final class VendorFavoriteButton: Div {

    override class var name: String { "div" }

    private let vendorId: UUID

    private let favorite: State<Bool>

    private let isSaving: State<Bool>

    private let onChange: ((Bool) -> ())?

    init(
        vendorId: UUID,
        favorite: State<Bool>,
        isSaving: State<Bool>,
        onChange: ((Bool) -> ())? = nil
    ) {
        self.vendorId = vendorId
        self.favorite = favorite
        self.isSaving = isSaving
        self.onChange = onChange
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @DOM override var body: DOM.Content {
        Button(self.favorite.map { $0 ? "★" : "☆" })
            .attribute("type", "button")
            .attribute("aria-label", "Cambiar proveedor favorito")
            .attribute("title", "Marcar o desmarcar como favorito")
            .disabled(self.isSaving)
            .color(self.favorite.map { $0 ? .init(r: 242, g: 184, b: 56) : .init(r: 150, g: 160, b: 178) })
            .backgroundColor(.transparent)
            .custom("border", "0")
            .fontSize(26.px)
            .cursor(.pointer)
            .onClick { [weak self] _, event in
                event.stopPropagation()
                self?.toggleFavorite()
            }
    }

    private func toggleFavorite() {
        guard !isSaving.wrappedValue else {
            return
        }

        let favorite = !self.favorite.wrappedValue
        let sessionId = custCatchID
        isSaving.wrappedValue = true

        let favoriteState = self.favorite
        let savingState = self.isSaving
        let onChange = self.onChange

        API.custAPIV1.setFavoriteVendor(
            vendorId: vendorId,
            favorite: favorite
        ) { resp in
            savingState.wrappedValue = false

            guard custCatchID == sessionId else {
                return
            }

            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            favoriteState.wrappedValue = favorite
            onChange?(favorite)
        }
    }
}
