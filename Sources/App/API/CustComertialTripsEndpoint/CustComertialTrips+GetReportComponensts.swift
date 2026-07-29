import Foundation
import TCFundamentals
import TCFireSignal
import SkylineDocumentationCore

extension CustCommercialTripsComponents {

    static func getReportComponensts(
        callback: @escaping ((_ resp: APIResponseGeneric<GetReportComponenstsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getReportComponensts",
            EmptyPayload()
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetReportComponenstsResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
