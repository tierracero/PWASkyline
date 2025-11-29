//
//  CustOrder+ChangeStatus.swift
//  
//
//  Created by Victor Cantu on 10/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal

extension CustOrderComponents {
    
    static func changeStatus (
        orderId: UUID,
        reason: String,
        status: CustFolioStatus,
        dueDate: Int64?,
        callback: @escaping ( (_ resp: APIResponse?) -> () )
    ) {
        
        sendPost(
            rout,
            version,
            "changeStatus",
            ChangeStatusRequest(
                orderId: orderId,
                reason: reason,
                status: status, 
                dueDate: dueDate
            )
        ) { data in
            guard let data else{
                callback(nil)
                return
            }
            do{
                let resp = try JSONDecoder().decode(APIResponse.self, from: data)
                callback(resp)
            }
            catch{
                print("🔴 API_DECODING_ERROR")
                print(error)
                callback(nil)
            }
        }
        
    }
}


    /*
     
     habilitar esta fun cion y hacer  un drop down  para  buscar CustOrderLoadFolioNotes
     remover del menu lateral  bton de Cobranza

     agregar select de tienda a este mismo metodo
     pero como dropdown tabien


     falta probar cambio de status y hacer le feed back en la ui

     */
