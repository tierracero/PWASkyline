
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func addNote(
        followupId: UUID,
        comment: String,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "addNote",
            AddNoteRequest(
                followupId: followupId,
                comment: comment
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