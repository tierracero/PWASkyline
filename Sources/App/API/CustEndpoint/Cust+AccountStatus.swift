
import Foundation
import TCFundamentals
import TCFireSignal

extension CustComponents {
    
    static func accountStatus(
        callback: @escaping ( (_ resp: APIResponseGeneric<AccountStatusResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "accountStatus",
            EmptyPayload()
        ) { data in
            
            guard let data else{
                callback(nil)
                return
            }
            
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<AccountStatusResponse>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
    }
}
