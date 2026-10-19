// Compile-only check: code is never executed and no server is contacted.
// Exact current shared request/wrapper/presenter logic; namespace renamed for the fixture.
// Response types come from the unchanged cached contract; unrelated app dependencies scaffolded.
import Foundation
import TCFundamentals
import TCFireSignal

protocol CrossPlatformPayload: Payloadable {}
enum AppTripContract {
    typealias GetTripResponse = CustCommercialTripsComponents.GetTripResponse
    static let rout = "custCommercialTrips"
    static let version = "v1"
}
struct API { typealias custCommercialTrips = AppTripContract }
func sendPost<T: Encodable>(_ route: String, _ version: String, _ action: String, _ payload: T, callback: @escaping (Data?) -> Void) {}
func decodeAPIResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T { try JSONDecoder().decode(type, from: data) }
enum ErrorTitle { case generalError, comunicationError, unexpectedResult }
func showError(_ type: ErrorTitle, _ message: String) {}
extension String {
    static let serverConextionError = "Connection failure"
    static let unexpenctedMissingPayload = "Missing payload"
}
struct LoadingView { func show() {}; func hide() {} }
let loadingView = LoadingView()
class TripViewBeta {
    init(trip: AppTripContract.GetTripResponse, statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> Void) {}
}
func addToDom(_ view: TripViewBeta) {}

extension AppTripContract {
    public struct GetTripRequest: CrossPlatformPayload {
        public let tripId: HybridIdentifier
        
        public init(
            tripId: HybridIdentifier
        ) {
            self.tripId = tripId
        }
    }
    

}
import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension AppTripContract {
    
    static func getTrip(
        tripId: HybridIdentifier,
        callback: @escaping ((_ resp: APIResponseGeneric<GetTripResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getTrip",
            GetTripRequest(tripId: tripId)
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponseGeneric<GetTripResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}

extension TripViewBeta {
    static func loadAndPresent(
        tripId: HybridIdentifier,
        statusChangedCallback: @escaping (UUID, FiscalTripFollowupStatus) -> Void = { _, _ in }
    ) {
        loadingView.show()

        API.custCommercialTrips.getTrip(tripId: tripId) { resp in
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

            addToDom(TripViewBeta(
                trip: payload,
                statusChangedCallback: statusChangedCallback
            ))
        }
    }


}

// Verify both supported identifier cases and the unchanged UUID-based status callback.
func compileSupportedLookups(tripId: UUID, folio: String) {
    API.custCommercialTrips.getTrip(tripId: .id(tripId)) { _ in }
    API.custCommercialTrips.getTrip(tripId: .folio(folio)) { _ in }
    TripViewBeta.loadAndPresent(tripId: .id(tripId)) { (id: UUID, status: FiscalTripFollowupStatus) in }
    TripViewBeta.loadAndPresent(tripId: .folio(folio)) { (id: UUID, status: FiscalTripFollowupStatus) in }
}
