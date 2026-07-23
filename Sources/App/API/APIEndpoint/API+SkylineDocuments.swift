import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals
import SkylineDocumentationCore

extension APIComponents {
    
    static func skylineDocuments(
        family: DocumentFamily,
        callback: @escaping ( (_ resp: APIResponseGeneric<[DocumentQuick]>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "skylineDocuments",
            SkylineDocumentsRequest(
                family: family
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                callback(try decodeAPIResponse(APIResponseGeneric<[DocumentQuick]>.self, from: data))
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(#function)
                print(error)
                callback(nil)
            }
        }
    }
}

