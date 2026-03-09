
import Foundation
import TCFundamentals
import TCFireSignal

extension CustExcelComponents {
    
    static func customePrintEngine(
        storeId: UUID?,
        fileName: String,
        startAt: Int64,
        endAt: Int64,
        payload: CustOrderComponents.ReportResponseType,
        callback: @escaping ( (_ resp: APIResponseGeneric<OrderReportResponse>?) -> () )
    ) {
        sendPost(
            rout,
            version,
            "customePrintEngine",
            OrderReportRequest(
                storeId: storeId,
                fileName: fileName,
                startAt: startAt,
                endAt: endAt,
                payload: payload
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }
            do{
                callback(try JSONDecoder().decode(APIResponseGeneric<OrderReportResponse>.self, from: data))
            }
            catch{
                print("🔴 DEOCDING \(#function)")
                print(error)
                callback(nil)
            }
        }
    }
}