
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func getItem(
        followupId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetItemResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getItem",
            GetItemRequest(
                followupId: followupId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetItemResponse>.self, from: data))
            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}