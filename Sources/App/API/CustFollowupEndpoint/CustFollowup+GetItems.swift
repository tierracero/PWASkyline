
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func getItems(
        userId: UUID?,
        status: CustFollowUpStatus?,
        callback: @escaping ( (_ resp: APIResponseGeneric<GetItemsResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getItems",
            GetItemsRequest(
                userId: userId,
                status: status
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<GetItemsResponse>.self, from: data))
            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}