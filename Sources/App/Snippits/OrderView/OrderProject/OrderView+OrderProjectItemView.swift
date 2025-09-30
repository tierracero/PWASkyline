//
//  OrderView+OrderProjectItemView.swift
//
//
//  Created by Victor Cantu on 10/2/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderView { 
    
    class OrderProjectItemView: Div { 
        
        override class var name: String { "div" }
        
        let item: CustOrderProjetcManagerItem
        
        var id: UUID
        
        @State var initiatedAt: Int64?
        
        @State var finalizedAt: Int64?
        
        var estimatedTime: Int64
        
        /// Name of the task
        var name: String
        
        /// Full description of the task
        var descr: String
        
        @State var status: CustOrderProjetcManagerItemStatus
        
        @State var objects: [CustOrderProjetcManagerItemObject]
        
        let activeStatus: [CustOrderProjetcManagerItemStatus] = [.pending, .active, .inrevsion]
        
        private var updateStatus: ((
            _ status: CustOrderProjetcManagerItemStatus
        ) -> ())
        
        public init(
            item: CustOrderProjetcManagerItem,
            objects: [CustOrderProjetcManagerItemObject],
            updateStatus: @escaping ((
                _ status: CustOrderProjetcManagerItemStatus
            ) -> ())
        ) {
            self.item = item
            self.id = item.id
            self.initiatedAt = item.initiatedAt
            self.finalizedAt = item.finalizedAt
            self.estimatedTime = item.estimatedTime
            self.name = item.name
            self.descr = item.description
            self.status = item.status
            self.objects = objects
            self.updateStatus = updateStatus
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var workedBy: String = ""
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    Div(self.name)
                        .custom("width", "calc(100% - 27px)")
                        .color(.darkGoldenRod)
                        .class(.twoLineText)
                        .float(.left)
                        .marginRight(3.px)
                        
                    Div{
                        Img()
                            .src("/skyline/media/next.png")
                            .cursor(.pointer)
                            .height(24.px)
                            .onClick {
                                self.updateStatusAction()
                            }
                    }
                    .float(.left)
                    .width(24.px)
                    .hidden(self.$status.map{ !self.activeStatus.contains($0) })
                    
                    Div().clear(.both)
                }
                
                Div().clear(.both).height(7.px)
                
                Div(self.descr)
                    .color(.white)
                    .marginBottom(3.px)
                //
                Div{
                    Div("Iniciado")
                        .width(50.percent)
                        .float(.left)
                    Div(self.$initiatedAt.map{ ($0 == nil) ? "N/A" : getDate($0 ?? 0).formatedShort })
                        .width(50.percent)
                        .float(.left)
                    
                    Div().clear(.both)
                }
                .marginBottom(3.px)
                .color(.gray)
                
                Div{
                    Div("Finalizado")
                        .width(50.percent)
                        .float(.left)
                    Div(self.$finalizedAt.map{ ($0 == nil) ? "N/A" : getDate($0 ?? 0).formatedShort })
                        .width(50.percent)
                        .float(.left)
                    Div().clear(.both)
                }
                .marginBottom(3.px)
                .color(.gray)
                
                Div(self.$workedBy)
                    .hidden(self.$workedBy.map{ $0 == nil })
                    .marginBottom(3.px)
                
                Div{
                    ForEach(self.$objects) { object in
                        OrderProjectItemObjectView(object: object)
                        
                        Div().height(7.px)
                        
                    }
                }
                .hidden(self.$objects.map{ $0.isEmpty })
                
            }
            .padding(all: 3.px)
            .margin(all: 3.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.roundDarkBlue)
            
            marginBottom(12.px)
            
            if let workedBy = item.workedBy {
                getUserRefrence(id: .id(workedBy)) { user in
                    if let user {
                        self.workedBy = user.username
                    }
                }
            }
            
            $status.listen {
                self.updateStatus($0)
            }
            
            
        }
        
        func updateStatusAction(){
            
            var newStatus: CustOrderProjetcManagerItemStatus? = nil
            
            switch status {
            case .pending:
                newStatus = .active
            case .active:
                newStatus = .inrevsion
            case .inrevsion:
                newStatus =  .aproved
            case .aproved:
                break
            case .canceled:
                break
            }
            
            guard let newStatus else {
                return
            }
            
            loadingView(show: true)
            
            API.custOrderV1.updateCustProjectItemStatus(
                itemId: self.id,
                status: newStatus
            ) { resp in
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                self.status = newStatus
                
            }
            
        }
        
    }
}
