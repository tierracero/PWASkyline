
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func create(
        nextDateAt: Int64?,
        currentUser: UUID,
        accountId: UUID,
        type: CustFollowUpType,
        interest: CustFollowUpIntrest,
        comment: String,
        items: [CreateItem],
        callback: @escaping ( (_ resp: APIResponseGeneric<CreateResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "create",
            CreateRequest(
                nextDateAt: nextDateAt,
                currentUser: currentUser,
                accountId: accountId,
                type: type,
                interest: interest,
                comment: comment,
                items: items
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<CreateResponse>.self, from: data))
            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}