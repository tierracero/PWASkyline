import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {

    static func getReport(
        from: Int64,
        to: Int64,
        type: TripReportTypes,
        relationId: UUID? = nil,
        callback: @escaping ((_ resp: APIResponseGeneric<GetReportTypes>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getReport",
            GetReportRequest(
                from: from,
                to: to,
                type: type,
                relationId: relationId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetReportTypes>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
