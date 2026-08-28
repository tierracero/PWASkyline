//
//  Theme+DeleteViewBlog.swift
//

import Foundation
import TCFundamentals
import TCFireSignal

extension ThemeComponents {

    public static func deleteViewBlog(
        id: UUID,
        callback: @escaping ((_ resp: APIResponse?) -> ())
    ) {
        sendPost(
            rout,
            version,
            "deleteViewBlog",
            DeleteViewBlogRequest(id: id)
        ) { data in
            guard let data else {
                callback(nil)
                return
            }

            do {
                callback(try decodeAPIResponse(APIResponse.self, from: data))
            } catch {
                print("⭕️ \(#file)")
                print(error)
                callback(nil)
            }
        }
    }
}
