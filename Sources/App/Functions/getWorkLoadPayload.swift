//
//  getWorkLoadPayload.swift
//
//
//  Created by Victor Cantu on 4/21/22.
//

import Foundation
import TCFundamentals
import Web


public func getWorkLoadPayload(){
    
    var store = custCatchStore
    
    if configStore.operationType == .external {
        if let _store = configStore.oporationStore {
            store = _store
        }
    }
    
    API.custOrderV1.getWorkLoadPayload(id: store) { resp in
        
        Dispatch.asyncAfter( (60 * 30) ) {
            getWorkLoadPayload()
        }
        
        guard let resp = resp else {
            return
        }
        
        guard resp.status == .ok else {
            return
        }

        guard let data = resp.data else {
            return
        }
        
        generalWorkload = data.generalWorkload
        workMap = [:]
        
        var _workMap: [
            Int: [
                Int: [
                    Int: CustOperationWorkProfile
                ]
            ]
        ] = [:]
        
        data.workLoadMap.forEach { yearsPayload in
            
            let year = yearsPayload.year
            let months = yearsPayload.months
            
            var monthMap: [Int:[Int:CustOperationWorkProfile]] = [:]
            
            months.forEach { monthsPayload in
                
                let month = monthsPayload.month
                let days = monthsPayload.days
                
                var dayMap: [Int:CustOperationWorkProfile] = [:]
                
                days.forEach { daysPayload in
                    
                    let day = daysPayload.day
                    let capacity = daysPayload.capacity
                    let workload = daysPayload.workload
                    
                    dayMap[day] = .init(order: capacity.order, rent: capacity.rent, sale: capacity.sale, admin: capacity.admin)
                    
                }
                
                monthMap[month] = dayMap
            }
            
            _workMap[year] = monthMap
            
        }
        
        workMap = _workMap
        
    }
}
