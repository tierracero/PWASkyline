
import Foundation
import TCFundamentals
import TCFireSignal

fileprivate var getCampaignsResponse: APIResponseGeneric<CustFollowupComponents.GetCampaignsResponse>? = nil

extension CustFollowupComponents {
    
    static func getCampaigns(
        callback: @escaping ( (_ resp: APIResponseGeneric<GetCampaignsResponse>?) -> () )
    ) {
        
        if let getCampaignsResponse {
            callback(getCampaignsResponse)
            return 
        }

        sendPost(
            rout,
            version,
            "getCampaigns",
            EmptyPayload()
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do {

                let payload = try JSONDecoder().decode(APIResponseGeneric<GetCampaignsResponse>.self, from: data)

                getCampaignsResponse = payload

                callback(payload)

            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}