import Foundation
import TCFundamentals
import TCFireSignal

extension CustCommercialTripsComponents {

    static func deliverAssetItem(
        tripId: UUID,
        assetItemId: UUID,
        comment: String? = nil,
        files: [String] = [],
        destinationSectionId: UUID? = nil,
        destinationSubSectionId: UUID? = nil,
        callback: @escaping (APIResponseGeneric<DeliverAssetItemResponse>?) -> Void
    ) {
        sendPost(
            rout,
            version,
            "deliverAssetItem",
            DeliverAssetItemRequest(
                tripId: tripId,
                assetItemId: assetItemId,
                comment: comment,
                files: files,
                destinationSectionId: destinationSectionId,
                destinationSubSectionId: destinationSubSectionId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponseGeneric<DeliverAssetItemResponse>.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
