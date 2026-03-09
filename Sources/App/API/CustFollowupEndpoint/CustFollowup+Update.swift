
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func update(
        followupId: UUID,
        nextDateAt: Int64,
        currentUser: UUID,
        type: CustFollowUpType,
        comment: String,
        interest: CustFollowUpIntrest,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "update",
            UpdateRequest(
                followupId: followupId,
                nextDateAt: nextDateAt,
                currentUser: currentUser,
                type: type,
                comment: comment,
                interest: interest
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}