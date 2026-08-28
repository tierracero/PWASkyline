import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func updateDepartment(
        depId: UUID,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "updateDepartment",
            UpdateDepartmentRequest(
                depid: depId, 
                name: name,
                smallDescription: smallDescription,
                description: description,
                icon: icon,
                coverLandscape: coverLandscape,
                coverPortrait: coverPortrait
            )
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            }
            catch {
                callback(nil)
            }
        }
    }
}
