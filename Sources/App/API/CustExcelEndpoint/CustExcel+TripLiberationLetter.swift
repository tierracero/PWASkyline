import Foundation
import TCFundamentals
import TCFireSignal

extension CustExcelComponents {

    static func tripLiberationLetter(
        tripId: UUID,
        callback: @escaping ((_ resp: APIResponseGeneric<TripLiberationLetterResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "tripLiberationLetter",
            TripLiberationLetterRequest(tripId: tripId)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(
                    APIResponseGeneric<TripLiberationLetterResponse>.self,
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
