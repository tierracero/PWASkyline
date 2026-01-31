//
//  OrderView+OrderProject.swift
//
//
//  Created by Victor Cantu on 10/2/24.
//

import Foundation
import TCFundamentals
import Web

/**
 `TODO:`
    1) calt total time  bases in items
    2) calc cost bases  on charegs  and  include charges toogle
    3) add option of manual charges also bases o taggle state 
 
 */

extension OrderView {
    
    class AddOrderProject: Div {
        
        override class var name: String { "div" }
        
        public let accountId: UUID
        
        public let orderId: UUID
        
        public let storeId: UUID
        
        private let addProject: ((
            _ projectId: UUID
        ) -> ())
        
        init(
            accountId: UUID,
            orderId: UUID,
            storeId: UUID,
            addProject: @escaping (_ projectId: UUID) -> Void
        ){
            self.accountId = accountId
            self.orderId = orderId
            self.storeId = storeId
            self.addProject = addProject
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var supervisedBy: String = ""
        
        /// Name of the proyect
        @State var name: String = ""
        
        /// Full description of the proyect
        @State var descr: String = ""
        
        @State var includeCurrentCharges: Bool = true
        
        @State var items: [API.custOrderV1.AddOrderProjectItem] = []
        
        @State var manualCharges: [API.custOrderV1.AddOrderProjectCharge] = []
        
        lazy var supervisorSelect = Select(self.$supervisedBy)
            .body {
                Option("Seleccione Usuario")
                    .value("")
            }
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var nameField = InputText(self.$name)
            .placeholder("Nombre del Proyecto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var descriptionArea = TextArea(self.$descr)
            .placeholder("Nombre del Proyecto")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(75.px)
        
        lazy var includeCurrentChargesToggle = InputCheckbox().toggle(self.$includeCurrentCharges)
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Crear Projecto")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                }
                
                Div().clear(.both)
                
                Div{
                    
                    Div{
                        H2("Datos Generales")
                            .color(.white)
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Supervisor del proyecto")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.supervisorSelect
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Nombre del proyecto")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.nameField
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Descripción del proyecto")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.descriptionArea
                        
                        Div().clear(.both).height(12.px)
                        
                        Div{
                            H3("incluir Cargos")
                                .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)
                        Div{
                            self.includeCurrentChargesToggle
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).height(7.px)
                        
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        Div{
                            
                            Div{
                                Img()
                                    .src("/skyline/media/add.png")
                                    .cursor(.pointer)
                                    .marginLeft(3.px)
                                    .marginTop(7.px)
                                    .height(26.px)
                                    .onClick {
                                        addToDom(OrderProjectItem(storeId: self.storeId) { item in
                                            self.items.append(item)
                                        })
                                    }
                            }
                            .float(.right)
                             
                            H2("Elementos Operacionales")
                                .color(.white)
                        }
                        
                        Div().clear(.both).height(7.px)
                        
                        Div{
                            ForEach(self.$items) { item in
                                Div{
                                    Div{
                                        
                                        Span("Tiempo estimado de tarea")
                                            .color(.gray)
                                        
                                        Span((item.estimatedTime.toDouble / 28800.0).toInt.toString)
                                            .float(.right)
                                            .color(.white)
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                 
                                    Div{
                                        
                                        Span("Nombre")
                                            .color(.gray)
                                        
                                        Span(item.name)
                                            .float(.right)
                                            .color(.white)
                                    }
                                    
                                    Div().clear(.both).height(3.px)
                                 
                                    Div("Descripcion")
                                        .color(.gray)
                                    
                                    Div(item.description)
                                        .class(.oneLineText)
                                        .color(.white)
                                     
                                }
                                .class(.uibtnLarge)
                                .width(97.percent)
                            }
                            
                        }
                        .custom("height", "calc(100% - 45px)")
                        .overflow(.auto)
                        
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                }
                .custom("height", "calc(100% - 85px)")
                .overflow(.auto)
                .marginTop(7.px)
                
                Div{
                    Div("Crear Proyecto")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.createProject()
                        }
                }
                .marginTop(3.px)
                .align(.right)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 462px)")
            .custom("top", "calc(50% - 362px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(700.px)
            .width(900.px)
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.fixed)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            getUsers(storeid: storeId, onlyActive: true) { users in
                
                loadingView(show: false)
                
                users.forEach { user in
                    
                    self.supervisorSelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                    
                }
                
            }
            
        }
        
        func createProject() {
            
            guard let supervisedBy = UUID(uuidString: supervisedBy) else {
                showError(.generalError, "Seleccione us supervisor valido.")
                return
            }
            
            if name.isEmpty {
                showError(.requiredField, "Ingrese un nombre")
                return
            }
            
            if descr.isEmpty {
                showError(.requiredField, "Ingrese descrippcion")
                return
            }
            
            loadingView(show: true)
            
            API.custOrderV1.addOrderProject(
                supervisedBy: supervisedBy,
                accountId: accountId,
                orderId: orderId,
                name: name,
                description: descr,
                items: items, 
                includeCurrentCharges: includeCurrentCharges,
                manualCharges: manualCharges
            ) { resp in
                
                guard let resp else {
                    loadingView(show: false)
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    loadingView(show: false)
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    loadingView(show: false)
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.addProject(payload.projectId)
                
                self.remove()
                
                API.custOrderV1.loadOrderProject(
                    projetcId: payload.projectId,
                    orderId: self.orderId
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }
                    
                    
                    let view = OrderProject(
                        project: payload.project,
                        items: payload.items,
                        charges: payload.charges
                    )
                    
                    addToDom(view)
                    
                }
            }
            
        }
        
    }
}
