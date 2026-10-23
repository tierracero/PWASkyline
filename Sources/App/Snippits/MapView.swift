import Foundation
import TCFundamentals
import Web

final class MapView: Div {

    override class var name: String { "div" }

    let latitude: Double
    let longitude: Double

    private let mapId = "map_view_" + callKey(32)
    private let sessionId = custCatchID
    private var locationMap: JSObject?
    private var mapRequest = UUID()

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private lazy var mapContainer = Div()
        .id(.init(mapId))
        .width(100.percent)
        .height(100.percent)
        .custom("grid-column", "1 / -1")
        .custom("min-height", "0")
        .borderRadius(12.px)
        .overflow(.hidden)
        .backgroundColor(.init(r: 3, g: 18, b: 32, a: 0.68))

    @DOM override var body: DOM.Content {
        VPopUp(.semiFull) {
            VTitle("Mapa") {
                USmallTitle("Ubicación registrada")
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                self.mapContainer
            }
            .custom("grid-template-rows", "minmax(0, 1fr)")
            .custom("align-content", "stretch")
            .custom("min-height", "0")
        }
    }

    override func buildUI() {
        super.buildUI()
        TCTripBetaTheme.apply(to: self)
        TCCrystalSurfaceTheme.apply(to: self, variant: .assets)
        position(.absolute)
        top(0.px)
        left(0.px)
        width(100.percent)
        height(100.percent)
        attribute("role", "dialog")
        attribute("aria-modal", "true")
        attribute("aria-label", "Mapa de la ubicación")
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        loadMap()
    }

    static func hasValidCoordinates(latitude: Double, longitude: Double) -> Bool {
        latitude.isFinite && longitude.isFinite
            && (-90.0...90.0).contains(latitude)
            && (-180.0...180.0).contains(longitude)
    }

    private func loadMap() {
        guard isInDOM, custCatchID == sessionId else { return }
        mapRequest = UUID()
        let request = mapRequest
        clearMap()

        guard Self.hasValidCoordinates(latitude: latitude, longitude: longitude) else {
            showStatus("No hay coordenadas válidas para mostrar el mapa.")
            return
        }

        showStatus("Cargando mapa…")
        API.v1.jwt { [weak self] token in
            guard let self, self.isInDOM, custCatchID == self.sessionId,
                  self.mapRequest == request else { return }
            guard let token,
                  let createMap = JSObject.global["createSubCustomerLocationMap"].function else {
                self.showStatus("No fue posible cargar el mapa.")
                return
            }

            self.mapContainer.innerHTML = ""
            guard let map = createMap(self.mapId, token, self.latitude, self.longitude).object else {
                self.showStatus("No fue posible cargar el mapa.")
                return
            }
            self.locationMap = map
            if let marker = map["annotations"].array?.first?.object {
                marker["title"] = "Ubicación".jsValue
            }
        }
    }

    private func showStatus(_ message: String) {
        mapContainer.innerHTML = ""
        mapContainer.appendChild(
            USmallTitle(message)
                .align(.center)
                .padding(all: 24.px)
        )
    }

    private func clearMap() {
        if let locationMap { _ = locationMap.destroy?() }
        locationMap = nil
        mapContainer.innerHTML = ""
    }

    override func didRemoveFromDOM() {
        mapRequest = UUID()
        clearMap()
        super.didRemoveFromDOM()
    }
}
