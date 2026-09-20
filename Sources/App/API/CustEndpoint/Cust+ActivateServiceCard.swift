import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func activateServiceCard(
        cardId: UUID,
        type: ActivateServiceCardType,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "activateServiceCard",
            ActivateServiceCardRequest(
                cardId: cardId,
                type: type
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                callback(nil)
            }
        }
    }
}
