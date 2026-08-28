import Foundation
import TCFundamentals
import TCFireSignal

extension CustExcelComponents {

    static func tripReport(
        _ payload: CustCommercialTripsComponents.GetReportTypes,
        callback: @escaping ((_ resp: APIResponseGeneric<TripReportResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "tripReport",
            payload
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<TripReportResponse>.self,
                    from: data
                ))
            }
            catch {
                print("🔴 DECODING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}
