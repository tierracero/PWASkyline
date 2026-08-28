import Foundation
import TCFundamentals
import TCFireSignal

extension CustAssetsComponents {

    static func createDepartment(
        accountId: UUID?,
        assetType: CustCommercialAssetsType,
        name: String,
        smallDescription: String,
        description: String,
        icon: String,
        coverLandscape: String,
        coverPortrait: String,
        callback: @escaping ((_ resp: APIResponseGeneric<CreateDepartmentResponse>?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "createDepartment",
            CreateDepartmentRequest(
                accountId: accountId,
                assetType: assetType,
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
                callback(try decodeAPIResponse(
                    APIResponseGeneric<CreateDepartmentResponse>.self,
                    from: data
                ))
            }
            catch {
                callback(nil)
            }
        }
    }
}
