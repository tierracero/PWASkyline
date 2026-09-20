import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func getServiceCard(
        id: GetServiceCardType,
        callback: @escaping ((_ resp: APIResponseGeneric<GetServiceCardResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "getServiceCard",
            GetServiceCardRequest(id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<GetServiceCardResponse>.self,
                    from: data
                ))
            } catch {
                callback(nil)
            }
        }
    }
}
