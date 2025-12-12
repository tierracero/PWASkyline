//
//  Tools+ServiceManager.swift
//  
//
//  Created by Victor Cantu on 3/30/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/*
id: UUID = .init(),
createdAt: Int64 = getNow(),
modifiedAt: Int64 = getNow(),
name: String,
smallDescription: String,
description: String,
icon: String,
coverLandscape: String,
coverPortrait: String
*/

/*
 public struct CustSOCQuick: Codable {
     
     public var id: UUID
     
     public var name: String
     
     public var pseudoName: String
     
     public var pricea: Int64
     
     public var priceb: Int64
     
     public var pricec: Int64
     
     public var avatar: String
     /// unrequested, active, suspended, canceled, fraud, delicuent, hotline, collection
     public var status: GeneralStatus
 */

extension ToolsView {
    
    class ServiceManager: Div {
        
        override class var name: String { "div" }
        
        /*
         
         init(
             currentChatIds: [UUID],
             callback: @escaping ((_ id: CustChatRoomProfile) -> ())
         ) {
             self.currentChatIds = currentChatIds
             self.callback = callback
             super.init()
         }
         
         required init() {
             fatalError("init() has not been implemented")
         }
         
         */
        
        // .class(.roundDarkBlue)
        
        @State var selectedDepatment: CustSvcDepsQuick? = nil
        
        @State var deps: [CustSvcDepsQuick] = []
        
        @State var services: [CustSOCQuick] = []
        
        var sericesRefrences: [UUID:[CustSOCQuick]] = [:]
        
        lazy var leftView = Div{
            Div {
                Div{
                    ForEach(self.$deps) { dep in
                        SeviceItemTierView(
                            type: .dep,
                            dep: dep.id,
                            cat: nil,
                            line: nil,
                            tierName: dep.name,
                            icon:dep.icon,
                            coverLandscape: dep.coverLandscape,
                            coverPortrait: dep.coverPortrait
                        ) { isEdited, id, tierName in
                            
                            if isEdited {
                                return
                            }
                            
                            self.loadDepartment(dep: dep)
                            
                        }
                        .backgroundColor(self.$selectedDepatment.map{ ($0?.id == dep.id) ? .black : .grayBlackDark })
                    }
                    .hidden(self.$deps.map{ $0.isEmpty })
                    
                    Table().noResult(label: "No hay departamentos, puede crear uno para poder agregar Codigos de Servicio")
                        .hidden(self.$deps.map{ !$0.isEmpty })
                }
                .class(.roundDarkBlue)
                .height(100.percent)
                .padding(all: 7.px)
                .overflow(.auto)
                
                Div("+ Agregar Departamento")
                .class(.uibtnLargeOrange)
                .textAlign(.center)
                .width(95.percent)
                .onClick {
                    
                    self.appendChild(CreateServiceLevelDepartement(callback: { id, name in
                        
                        self.deps.append(.init(
                            id: id,
                            name: name,
                            smallDescription: "",
                            description: "",
                            icon: "",
                            coverLandscape: "",
                            coverPortrait: ""
                        ))
                        
                    }))
                }
            }
            .custom("height", "calc(100% - 72px)")
            .marginBottom(12.px)
        }
            .height(100.percent)
            .width(370.px)
            .float(.left)
        
        var serviceRowRefrence: [ UUID : ServiceItemSOCView ] = [:]
            
        lazy var serviceContiner = Div()

        lazy var rightView = Div{
            
            Div{
                
                self.serviceContiner
                .hidden(self.$services.map{ $0.isEmpty })
                
                Table().noResult(label: "Agregue un nuevo servicio.")
                    .hidden(self.$services.map{ !$0.isEmpty })
            }
            .hidden(self.$selectedDepatment.map{ $0 == nil })
            .height(100.percent)
            .width(100.percent)
            
            Table().noResult(label: "Seleccione un departamento para agregar servicios.")
                .hidden(self.$selectedDepatment.map{ $0 != nil })
            
        }
            .custom("height", "calc(100% - 24px)")
            .custom("width", "calc(100% - 395px)")
            .class(.roundBlue)
            .padding(all: 7.px)
            .marginLeft(7.px)
            .overflow(.auto)
            .float(.left)
        
        @DOM override var body: DOM.Content {
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Control de Servicios")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                Div {
                    
                    Div{
                        H2("Secciones")
                            .color(.gold)
                            .float(.left)
                    }
                    .marginBottom(7.px)
                    .height(30.px)
                    
                    Div {
                        
                        self.leftView
                        
                        self.rightView
                        
                    }
                    .custom("height", "calc(100% - 23px)")
                    
                    Div{
                        Div("+ Agregar Servicio")
                        Div(self.$selectedDepatment.map{ "en \($0?.name ?? "")" })
                        .class(.oneLineText)
                        .textAlign(.center)
                        .color(.lightGray)
                        .fontSize(13.px)
                    }
                        .boxShadow(h: 0.px, v: 0.px, blur: 24.px, color: .black)
                        .hidden(self.$selectedDepatment.map{ $0 == nil })
                        .class(.uibtnLargeOrange)
                        .position(.absolute)
                        .bottom(24.px)
                        .right(24.px)
                        .onClick {
                            
                            guard let levelid = self.selectedDepatment?.id else {
                                return
                            }
                            
                            let view = ManageSOCView(
                                type: .dep,
                                levelid: levelid,
                                levelName: self.selectedDepatment?.name ?? "",
                                socid: nil,
                                titleText:  "Agregar en " + (self.selectedDepatment?.name ?? ""),
                                quickView: false
                            ) { socid, name, price, avatar in
                                // No row to update since new product
                            } created: { soc in

                                self.services.append(soc)

                                self.sericesRefrences[levelid]?.append(soc)

                                self.addServiceItem(soc: soc, levelid: levelid)
                                
                            } delete: { id in
                                
                                print(" 🟢  🗳️  delete 002")

                                var services: [CustSOCQuick] = []

                                self.services.forEach { service in
                                    
                                    if service.id == id {
                                        return
                                    }

                                    services.append(service)

                                }

                                if let depId = self.selectedDepatment?.id {
                                    self.sericesRefrences[depId]  = services
                                }
                                
                                self.services = services

                                self.serviceRowRefrence[id]?.remove()

                            }

                            addToDom(view)
                            
                        }
                    
                }
                .custom("height", "calc(100% - 37px)")
                
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(80.percent)
            .left(10.percent)
            .top(10.percent)
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custSOCV1.getDepartments { resp in
                
                loadingView(show: false)
                
                guard let resp else{
                    showError(.errorDeCommunicacion, "No se pudieron obtener los departamentso del servidor")
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                self.deps = data
            }

        }
        
        override public func didAddToDOM() {
            super.didAddToDOM()
        }
        
        func loadDepartment(dep: CustSvcDepsQuick){
            
            if let selectedDepatment {
                if selectedDepatment.id == dep.id {
                    return
                }
            }
            
            if let svcs = sericesRefrences[dep.id] {
                if svcs.count > 0 {
                    services = svcs
                    serviceContiner.innerHTML = ""
                    svcs.forEach { svc in
                        addServiceItem(soc: svc, levelid: dep.id)
                    }

                    return
                }
            }
            
            loadingView(show: true)
            
            API.custSOCV1.getSOCs(depid: dep.id) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    showError(.errorGeneral, .unexpenctedMissingPayload)
                    return
                }
                
                self.selectedDepatment = dep
                
                self.sericesRefrences[dep.id] = data
                
                self.services = data
                self.serviceContiner.innerHTML = ""
                data.forEach { svc in
                    self.addServiceItem(soc: svc, levelid: dep.id)
                }
                    
            }
        }

        func addServiceItem(soc: CustSOCQuick, levelid: UUID) {
            
            let view = ServiceItemSOCView(soc: soc) { update in
                
                let view = ManageSOCView(
                    type: .dep,
                    levelid: levelid,
                    levelName: self.selectedDepatment?.name ?? "",
                    socid: soc.id,
                    titleText: "",
                    quickView: false
                ) { socid, name, price, avatar in

                    update(name, "", price, avatar)
                    
                    if let depid = self.selectedDepatment?.id {
                        
                        if let refs = self.sericesRefrences[depid] {
                            
                            var new: [CustSOCQuick] = []
                            
                            refs.forEach { _soc in
                                ///  self.sericesRefrences[levelid]?.append(soc)
                                if _soc.id == soc.id {
                                    new.append(CustSOCQuick(
                                        id: soc.id,
                                        name: name,
                                        pseudoName: name.pseudo,
                                        pricea: price,
                                        priceb: soc.pricea,
                                        pricec: soc.priceb,
                                        avatar: avatar,
                                        status: soc.status
                                    ))
                                }
                                else{
                                    new.append(_soc)
                                }
                            }
                            
                            self.services = new

                            self.sericesRefrences[depid] = new
                            
                        }
                        
                    }
                    
                } created: { soc in

                    self.services.append(soc)

                    self.sericesRefrences[levelid]?.append(soc)

                    self.addServiceItem(soc: soc, levelid: levelid)

                } delete: { id in

                    var services: [CustSOCQuick] = []

                    self.services.forEach { service in
                        
                        if service.id == id {
                            print("🚧   no_add")
                            return
                        }

                        print("🟢   add")

                        services.append(service)

                    }

                    self.services = services
                        
                    if let depId = self.selectedDepatment?.id {
                        self.sericesRefrences[depId]  = services
                    }

                    self.serviceRowRefrence[id]?.remove()
                    
                }
                
                addToDom(view)
                
            }

            serviceRowRefrence[soc.id] = view

            serviceContiner.appendChild(view)
                    
        }

    }
}



