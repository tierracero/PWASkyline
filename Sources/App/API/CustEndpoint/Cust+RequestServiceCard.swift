import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func requestServiceCard(
        type: CustShortLinkManagerType,
        id: RequestServiceCardType,
        callback: @escaping ((_ resp: APIResponseGeneric<RequestServiceCardResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "requestServiceCard",
            RequestServiceCardRequest(
                type: type,
                id: id
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<RequestServiceCardResponse>.self,
                    from: data
                ))
            } catch {
                callback(nil)
            }
        }
    }
}
