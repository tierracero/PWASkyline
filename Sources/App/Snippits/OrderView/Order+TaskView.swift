//
//  Order+TaskView.swift
//  
//
//  Created by Victor Cantu on 12/29/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class TaskView: Div {
        
        override class var name: String { "div" }
        
        let task: CustTaskAuthorizationManagerQuick
        
        private var callback: ((
            _ taskId: UUID
        ) -> ())
        
        init(
            task: CustTaskAuthorizationManagerQuick,
            callback: @escaping (
                _ taskId: UUID
            ) -> Void
        ) {
            self.task = task
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        var taskColorLevel: Color = .white
        
        @State var reason: String = ""
        
        @State var username: String = ""
        
        lazy var reasonField = InputText(self.$reason)
            .custom("width","calc(100% - 24px)")
            .placeholder("Ingrese resultado de la tarea...")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        /*
         id: UUID,
         createdAt: Int64,
         createdBy: UUID,
         folio: String,
         alertLevel: CustTaskAuthorizationManagerAlertLevel,
         alertType: CustTaskAuthorizationManagerAlertType,
         actionType: CustTaskAuthorizationManagerActionType,
         relId: UUID?,
         relFolio: String?,
         ids: [UUID],
         requestMessage: String,
         status: CustTaskAuthorizationManagerStatus
         */
        @DOM override var body: DOM.Content {
        
            Div{
                
                H5("Tarea \(self.task.folio)")
                    .color(self.taskColorLevel)
                    .float(.left)
                
                H5(self.$username)
                    .float(.right)
                    .color(.white)
                
                Div().clear(.both)
            }
            
            Div().clear(.both).height(3.px)
            
            Div(self.task.requestMessage)
            
            Div().clear(.both).height(3.px)
            
            self.reasonField
            
            Div().clear(.both).height(3.px)
            
            Div{
                Div("Terminado")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.closeTask()
                    }
            }
            .align(.right)
        
        
        }
     
        override func buildUI() {
            super.buildUI()
            
            marginBottom(7.px)
            
            switch task.alertLevel {
            case .low:
                break
            case .medium:
                taskColorLevel = .yellowText
            case .high:
                taskColorLevel = .slateRed
            }
            
            if let uid = task.requestTo.first {
                getUserRefrence(id: .id(uid)) { user in
                    
                    guard let user else {
                        return
                    }
                    
                    let uname = user.username.explode("@").first ?? user.firstName
                    
                    self.username = "@\(uname)"
                    
                }
            }
            
            
        }
        
        func closeTask(){
            
            loadingView(show: true)
            
            API.custAPIV1.CTAMResolve(
                alertid: self.task.id,
                action: .done,
                responseMessage: self.reason
            ) { resp in
                
                loadingView(show: false)
            
                guard resp != nil else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                self.remove()
                    
                self.callback(self.task.id)
                
            }
        }
    }
}
