
import Foundation
import TCFundamentals
import TCFireSignal
import TCFundamentals

extension APIComponents {
    
    static func skylineDocument(
        documentId: UUID,
        callback: @escaping ( (_ resp: APIResponseGeneric<SkylineDocumentResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "skylineDocument",
            SkylineDocumentRequest(
                documentId: documentId
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            
            do{
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("🟢 skylineDocument raw response")
                    print(rawResponse)
                }
                
                let response = try decodeAPIResponse(APIResponseGeneric<SkylineDocumentResponse>.self, from: data)
                print("🟢 skylineDocument decoded body count")
                print(response.data?.documentBody.count ?? -1)
                callback(response)
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
