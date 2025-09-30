//
//  CreateServiceLevelDepartement.swift
//  
//
//  Created by Victor Cantu on 4/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateServiceLevelDepartement: Div {
    
    override class var name: String { "div" }
    
    let dep: CustSvcDeps?
    
    private var callback: ((
        _ id: UUID,
        _ name: String
    ) -> ())
    
    init(
        dep: CustSvcDeps? = nil,
        callback: @escaping ((
            _ id: UUID,
            _ name: String
        ) -> ())
    ) {
        self.dep = dep
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var titleText = "Crear Departamento"
    
    var buttonText = "Crear Departamento"
    
    @State var name = ""
    
    @State var descr = ""
    
    lazy var nameField = InputText(self.$name)
        .placeholder("Nombre del Departamento")
        .custom("width", "calc(100% - 14px)")
        .class(.textFiledBlackDarkLarge)
    
    lazy var descriptionField = InputText(self.$descr)
        .placeholder("Lista, marcas, o pequeña description")
        .custom("width", "calc(100% - 14px)")
        .class(.textFiledBlackDarkLarge)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                  
                H2(self.titleText)
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).marginBottom(7.px)
            
            Label("Nombre de Departamento")
                
            Div().class(.clear).marginBottom(7.px)
            
            self.nameField
            
            Div().class(.clear).marginBottom(12.px)
            
            Label("Descripcion Corta")
                
            Div().class(.clear).marginBottom(7.px)
            
            self.descriptionField
            
            Div().class(.clear).marginBottom(12.px)
            
            Div{
                Div(self.buttonText)
                    .class(.uibtnLarge)
            }
            .align(.center)
            .onClick{
                self.createLevel()
            }
            
        }
        .backgroundColor(.grayBlack)
        .custom("top", "calc(50% - 117px)")
        .custom("left", "calc(50% - 200px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .height(235.px)
        .width(400.px)
        .color(.white)
        
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
        if let dep {
            
            titleText = "Editar Departamento"
            
            buttonText = "Guardar Cambios"
            
            name = dep.name
            
            descr = dep.smallDescription
        }
        
        
        
    }
    
    override func didAddToDOM() {
        self.nameField.select()
        
        nameField.select()
    }
    
    func createLevel() {
        
        name = name.purgeSpaces.purgeHtml.capitalized
        
        descr = descr.purgeSpaces.purgeHtml.capitalizeFirstLetter
        
        if name.isEmpty {
            showError(.campoRequerido, .requierdValid("Nombre"))
            nameField.select()
            return
        }
        
        loadingView(show: true)
        
        if let id = self.dep?.id {
            
            API.custSOCV1.updateDepartment(
                depid: id,
                name: name,
                smallDescription: descr,
                description: "",
                icon: "",
                coverLandscape: "",
                coverPortrait: ""
            ){ resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                showSuccess(.operacionExitosa, "Cambios Guardados")
                
                self.callback(id, self.name)
                
                self.remove()
                
            }
        }
        else{
            
            API.custSOCV1.createDepartment(
                name: name,
                smallDescription: descr,
                description: "",
                icon: "",
                coverLandscape: "",
                coverPortrait: ""
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let id = resp.id else {
                    showError(.unexpectedResult, "No se obtuvo id del nuevo departamento, refresque la webapp.")
                    return
                }
                
                var depArray: [String] = []
                
                var depRefrence: [String:CustStoreDepsAPI] = [:]
                
                depArray.append(self.name)
                
                depRefrence[self.name] = .init(
                    id: id,
                    modifiedAt: getNow(),
                    name: self.name,
                    smallDescription: self.descr,
                    description: "",
                    icon: "",
                    coverLandscape: "",
                    coverPortrait: ""
                )
                
                storeDeps.forEach { dep in
                    depArray.append(dep.name)
                    depRefrence[dep.name] = dep
                }
                
                depArray.sort()
                
                storeDeps.removeAll()
                
                depArray.forEach { name in
                    if let dep = depRefrence[name] {
                        storeDeps.append(dep)
                    }
                }
                
                self.callback(id, self.name)
                
                self.remove()
                
            }
            
        }
        
    }
}

