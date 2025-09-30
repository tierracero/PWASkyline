//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+SchedulesView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class SchedulesView: Div {

        override class var name: String { "div" }
        
        @State var schedules: [CustUsernameScheduleConfigurationObject]
      
        init(
            schedules: [CustUsernameScheduleConfigurationObject]
        ) {
            self.schedules = schedules
        
            super.init()
            
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var selectedScheduleId: UUID? = nil

        @DOM override var body: DOM.Content {
            Div()
        }

        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
            width(100.percent)
            
        }
    
    }
}