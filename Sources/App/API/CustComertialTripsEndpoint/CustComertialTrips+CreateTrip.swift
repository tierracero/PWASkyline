import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {
    
    static func createTrip(
        accountId: UUID,
        operadorId: UUID,
        vehicalId: UUID,
        permitId: UUID,
        hasDangerousMaterial: Bool,
        insuranceCivilId: UUID?,
        insuranceAmbientId: UUID?,
        insurancePayloadId: UUID?,
        remolques: [UUID],
        locations: [TripLocation],
        merchandise: [TripMerchandise],
        balance: Int64,
        odometerInitial: Int64?,
        odometerFinal: Int64?,
        callback: @escaping ((_ resp: APIResponseGeneric<GetTripResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createTrip",
            CreateTripRequest(
                accountId: accountId,
                operadorId: operadorId,
                vehicalId: vehicalId,
                permitId: permitId,
                hasDangerousMaterial: hasDangerousMaterial,
                insuranceCivilId: insuranceCivilId,
                insuranceAmbientId: insuranceAmbientId,
                insurancePayloadId: insurancePayloadId,
                remolques: remolques,
                locations: locations,
                merchandise: merchandise,
                balance: balance,
                odometerInitial: odometerInitial,
                odometerFinal: odometerFinal
            )
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
