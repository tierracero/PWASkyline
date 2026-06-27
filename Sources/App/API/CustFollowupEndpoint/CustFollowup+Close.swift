
import Foundation
import TCFundamentals
import TCFireSignal

extension CustFollowupComponents {
    
    static func close(
        followupId: UUID,
        closeType: CloseType,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "close",
            CloseRequest(
                followupId: followupId,
                closeType: closeType
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do {
                callback(try JSONDecoder().decode(APIResponse.self, from: data))
            }
            catch {
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
