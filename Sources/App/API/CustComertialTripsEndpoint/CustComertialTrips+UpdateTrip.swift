import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func updateTrip(
        tripId: UUID,
        operadorId: UUID,
        vehicalId: UUID,
        permitId: UUID,
        hasDangerousMaterial: Bool,
        insuranceCivilId: UUID?,
        insuranceAmbientId: UUID?,
        insurancePayloadId: UUID?,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateTrip",
            UpdateTripRequest(
                tripId: tripId,
                operadorId: operadorId,
                vehicalId: vehicalId,
                permitId: permitId,
                hasDangerousMaterial: hasDangerousMaterial,
                insuranceCivilId: insuranceCivilId,
                insuranceAmbientId: insuranceAmbientId,
                insurancePayloadId: insurancePayloadId
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
