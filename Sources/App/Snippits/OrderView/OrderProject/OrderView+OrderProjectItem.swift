//
//  OrderView+OrderProjectItem.swift
//
//
//  Created by Victor Cantu on 10/2/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderView {
    
    class OrderProjectItem: Div {
        
        override class var name: String { "div" }
        
        let storeId: UUID
        
        private let addProject: ((
            _ item: API.custOrderV1.AddOrderProjectItem
        ) -> ())
        
        init(
            storeId: UUID,
            addProject: @escaping (_: API.custOrderV1.AddOrderProjectItem) -> Void
        ) {
            self.storeId = storeId
            self.addProject = addProject
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var estimatedTime: String = ""
        
        @State var workedBy: String = ""
        
        /// Name of the task
        @State var name: String = ""
        
        /// Full description of the task
        @State var descr: String = ""
        
        @State var objects: [API.custOrderV1.AddOrderProjectItemObject] = []

        lazy var estimatedTimeField = InputText(self.$estimatedTime)
            .placeholder("En días")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)

        lazy var workedBySelect = Select(self.$workedBy)
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
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Agregar Tarea")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                }
                
                Div().clear(.both)
                
                Div{
                    
                    Div{
                        
                        H2("Datos Generales")
                            .color(.white)
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Tiempo etimado de la tarea (DIAS)")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.estimatedTimeField
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Operador de tarea (opcional)")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.workedBySelect
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Nombre de la tarea")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.nameField
                        
                        Div().clear(.both).height(12.px)
                        
                        Label("Descripción de la tarea")
                            .color(.white)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.descriptionArea
                        
                        Div().clear(.both).height(12.px)
                        
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
                                        addToDom(ServiceAccionItemElementView(element: nil, callback: { element in
                                            
                                            self.objects.append(API.custOrderV1.AddOrderProjectItemObject(
                                                id: .init(),
                                                primary: false,
                                                type: element.type,
                                                actionName: element.title,
                                                helpText: element.help,
                                                placeholder: element.placeholder,
                                                options: element.options,
                                                value: "",
                                                isRequired: element.isRequired,
                                                locked: false
                                            ))
                                        }))
                                    }
                            }
                            .float(.right)

                            H2("Tareas de Elememto")
                                .color(.white)
                            
                        }
                        
                        Div().clear(.both).height(7.px)
                        
                        Div{
                            ForEach(self.$objects) { element in
                                
                                AddOrderProjectItemObject(element: element) { id in
                                    
                                } callback: { element in
                                    
                                }

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
                    Div("Agregar Tarea")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.createTask()
                        }
                }
                .marginTop(3.px)
                .align(.right)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 375px)")
            .custom("top", "calc(50% - 265px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(500.px)
            .width(700.px)
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.fixed)
            left(0.px)
            top(0.px)
            
            getUsers(storeid: storeId, onlyActive: true) { users in
                users.forEach { user in
                    self.workedBySelect.appendChild(
                        Option(user.username)
                            .value(user.id.uuidString)
                    )
                }
            }
            
        }
        
        func createTask() {
            
            guard let estimatedTimeDays = Double(estimatedTime) else {
                showError(.invalidField, "Inlcuya un tiempo estima do en días valido")
                return
            }

            guard estimatedTimeDays > 0 else {
                showError(.invalidField, "El tiempo estimado debe ser mayor a cero")
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
            
            addProject(.init(
                estimatedTime: (estimatedTimeDays * 28800.0).toInt64,
                workedBy: UUID(uuidString: workedBy),
                position: 0,
                name: name,
                description: descr,
                objects: objects
            ))
            
            self.remove()
        }
        
    }
}
