// DELETEME
//  Cust+GetJobRecruitmentProfiler.swift
//  
//
//  Created by Victor Cantu on 5/29/23.
//
/*
import Foundation
import TCFundamentals
import TCFireSignal

extension CustAPIEndpointV1 {
        
    public static func getJobRecruitmentProfiler( // GetJobRecruitmentProfilerResponse
        callback: @escaping ( (_ resp: APIResponseGeneric<GetJobRecruitmentProfilerResponse>?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "getJobRecruitmentProfiler",
            EmptyPayload()
        ) { payload in
            
            guard let payload else {
                callback(nil)
                return
            }
            
            do{
                var resp = try JSONDecoder().decode(APIResponseGeneric<String>.self, from: payload)
                
                var decoded: APIResponseGeneric<GetJobRecruitmentProfilerResponse?> = .init(
                    status: resp.status,
                    msg: resp.msg,
                    data: nil,
                    errcode: resp.errcode
                )
                
                if let data = resp.data?.decryptc?.data(using: .utf8) {
                    
                    do {
                        let response = try JSONDecoder().decode(GetJobRecruitmentProfilerResponse.self, from: data)
                        decoded.data = response
                    }
                    catch { }
                    
                }
                
                callback(decoded)
            }
            catch {
                callback(nil)
            }
            
        }
    }
}
*/
