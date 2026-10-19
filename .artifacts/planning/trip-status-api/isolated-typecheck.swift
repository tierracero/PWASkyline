// Isolated compile-only verification. No code is executed and no server is contacted.
// Uses the exact current shared DTOs, wrapper and changeStatus method extracted below.
// Namespace/presentation/transport scaffolding supplies only the unrelated app dependencies.
import Foundation
import TCFundamentals
protocol CrossPlatformPayload: Payloadable {}
enum CustCommercialTripsComponents {
    static let rout = "custCommercialTrips"
    static let version = "v1"
}
struct API { typealias custCommercialTrips = CustCommercialTripsComponents }
func sendPost<T: Encodable>(_ route: String, _ version: String, _ action: String, _ payload: T, callback: @escaping (Data?) -> Void) {}
func decodeAPIResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T { try JSONDecoder().decode(type, from: data) }
enum ErrorTitle { case generalError, comunicationError }
enum SuccessTitle { case operacionExitosa }
func showError(_ type: ErrorTitle, _ message: String) {}
func showSuccess(_ type: SuccessTitle, _ message: String) {}
extension String { static let serverConextionError = "Connection failure" }
struct LoadingView { func show() {} ; func hide() {} }
let loadingView = LoadingView()
var custCatchID = UUID()
struct TripSnapshot { var id = UUID(); var status = FiscalTripFollowupStatus.pending }

extension CustCommercialTripsComponents {
    public struct ChangeTripStatusMedia: Payloadable {
        
        public let merchandiseId: UUID
        
        public let files: [String]
        
        public init(
            merchandiseId: UUID,
            files: [String]
        ) {
            self.merchandiseId = merchandiseId
            self.files = files
        }
        
    }
    
    public struct ChangeTripStatusRequest: CrossPlatformPayload {
        
        public let tripId: UUID
        
        /// pending, inProgress, completed, cancelled
        public let status: FiscalTripFollowupStatus
        
        public let comment: String
        
        public let media: [ChangeTripStatusMedia]
        
        public init(
            tripId: UUID,
            status: FiscalTripFollowupStatus,
            comment: String,
            media: [ChangeTripStatusMedia]
        ) {
            self.tripId = tripId
            self.status = status
            self.comment = comment
            self.media = media
        }
    }
    
}

extension CustCommercialTripsComponents {

    static func changeTripStatus(
        tripId: UUID,
        status: FiscalTripFollowupStatus,
        comment: String,
        media: [ChangeTripStatusMedia],
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "changeTripStatus",
            ChangeTripStatusRequest(
                tripId: tripId,
                status: status,
                comment: comment,
                media: media
            )
        ) { data in
            
            guard let data else {
                callback(nil)
                return
            }
            
            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
final class TripStatusCompileHarness {
    var isInDOM = true
    var isChangingStatus = false
    var trip = TripSnapshot()
    var status = FiscalTripFollowupStatus.pending
    let statusChangedCallback: (UUID, FiscalTripFollowupStatus) -> Void = { _, _ in }
    private func changeStatus(
        _ newStatus: FiscalTripFollowupStatus,
        comment: String,
        media: [CustCommercialTripsComponents.ChangeTripStatusMedia]
    ) {
        guard isInDOM, !isChangingStatus, trip.status != newStatus else { return }

        let comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard newStatus != .cancelled || !comment.isEmpty else {
            showError(.generalError, "Agregue un comentario para cancelar el viaje.")
            return
        }

        let tripId = trip.id
        let sessionId = custCatchID
        let statusChanged = statusChangedCallback
        isChangingStatus = true
        loadingView.show()

        API.custCommercialTrips.changeTripStatus(
            tripId: tripId,
            status: newStatus,
            comment: comment,
            media: media
        ) { [weak self] response in
            loadingView.hide()
            self?.isChangingStatus = false
            guard custCatchID == sessionId else { return }

            guard let response else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            guard response.status == .ok else {
                showError(.generalError, response.msg)
                return
            }

            self?.trip.status = newStatus
            self?.status = newStatus
            statusChanged(tripId, newStatus)
            showSuccess(.operacionExitosa, "Estatus actualizado")
        }
    }

}
