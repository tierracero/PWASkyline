import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func getSecctionDetails(
        id: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<GetSecctionDetailsResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getSecctionDetails",
            APIRequestID(id: id, store: nil)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetSecctionDetailsResponse>.self,
                    from: data
                ))
            } catch {
                callback(nil)
            }
        }
    }
}
