import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {

    static func setFavoriteVendor(
        vendorId: UUID,
        favorite: Bool,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "setFavoriteVendor",
            SetFavoriteVendorRequest(
                vendorId: vendorId,
                favorite: favorite
            )
        ) { payload in
            guard let data = payload else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                print("🔴 API_DECODING_ERROR \(#function)")
                callback(nil)
            }
        }
    }
}
