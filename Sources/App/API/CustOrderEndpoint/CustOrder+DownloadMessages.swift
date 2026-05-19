//
//  CustOrder+DownloadMessages
//
import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
	
	static func downloadMessages(
        orderId: UUID,
        notes: [UUID],
        callback: @escaping ( (_ resp: APIResponseGeneric<DownloadMessagesResponse>?) -> () )
    ) {
		sendPost(
			rout,
			version,
			"downloadMessages",
			DownloadMessagesRequest(
                orderId: orderId,
                notes: notes
            )
		) { data in
			guard let data else {
				callback(nil)
				return
			}
			do{
				callback(try JSONDecoder().decode(APIResponseGeneric<DownloadMessagesResponse>.self, from: data))
			}
			catch{
				callback(nil)
			}
		}
	}
	
}
