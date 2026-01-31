//
//  CartaPorteOperator.swift
//
//
//  Created by Victor Cantu on 3/14/25.
//

import Foundation
import TCFundamentals
import Web

class CartaPorteOperator: Div {
    
    override class var name: String { "div" }
    
    @State var id: UUID?
    
    /// First and Last name [meta1]
    @State var name: String
    
    /// Licence number meta2
    @State var licence: String
    
    /// RFC meta3
    @State var rfc: String
    
    private var callback: ((
        _ operator: CustFiscalOperator
    ) -> ())
    
    init(
        _ operator: CustFiscalOperator? = nil,
        callback: @escaping ((
            _ operator: CustFiscalOperator
        ) -> ())
    ) {
        
        self.id = `operator`?.id
        self.name = `operator`?.name ?? ""
        self.licence = `operator`?.licence ?? ""
        self.rfc = `operator`?.rfc ?? ""
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // MARK: Nombre
    lazy var nameField = InputText(self.$name)
        .custom("width", "calc(100% - 16px)")
        .placeholder("Nombre del Operador")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
    
    // MARK: RFC
    lazy var rfcField = InputText(self.$rfc)
        .custom("width", "calc(100% - 16px)")
        .placeholder("RFC del Operador")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }

    
    // MARK: Licencia
    lazy var licenceField = InputText(self.$licence)
        .custom("width", "calc(100% - 16px)")
        .placeholder("Numero de Licencia")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .height(28.px)
        .onFocus { tf in
            tf.select()
        }
        
    @DOM override var body: DOM.Content {
    
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$id.map{ ($0 == nil) ? "Agregar Operador" : "Editar Operador" })
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            // MARK: Name
            Div{
                Label("Nombre del Operador")
                    .color(.gray)
                
                Div{
                    self.nameField
                }
            }
            .class(.section)
            Div().class(.clear).marginBottom(7.px)
            
            
            // MARK: RFC
            Div{
                Label("RFC del Operador")
                    .color(.gray)
                
                Div{
                    self.rfcField
                }
            }
            .class(.section)
            Div().class(.clear).marginBottom(7.px)
            
            // MARK: Licencia
            Div{
                Label("Numero de Licencia")
                    .color(.gray)
                
                Div{
                    self.licenceField
                }
            }
            .class(.section)
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Div(self.$id.map{ ($0 == nil) ? "+ Agregar" : "Guardar Cambios" })
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.saveOperator()
                    }
            }
            .align(.right)
            
            Div().class(.clear).marginBottom(7.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(40.percent)
        .left(30.percent)
        .top(25.percent)
    
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)
        
    }
    
    func saveOperator(){
     
        if name.isEmpty {
            showError(.requiredField, .requierdValid("nombre"))
            nameField.select()
            return
        }
        
        if rfc.isEmpty {
            showError(.requiredField, .requierdValid("nombre"))
            rfcField.select()
            return
        }
        
        if licence.isEmpty {
            showError(.requiredField, .requierdValid("nombre"))
            licenceField.select()
            return
        }
        
        loadingView(show: true)
        
        if let id  {
            
            API.fiscalV1.saveFiscalOperators(
                id: id,
                name: name,
                licence: licence,
                rfc: rfc,
                expire: nil
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
                
                self.callback(.init(
                    id: id,
                    name: self.name,
                    licence: self.licence,
                    rfc: self.rfc,
                    expireAt: nil
                ))
                
                self.remove()
                
            }
            
            return
            
        }
        
        API.fiscalV1.addFiscalOperators(
            name: name,
            rfc: rfc,
            licence: licence,
            expire: nil
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
         
            self.callback(payload)
            
            self.remove()
            
        }
    }
    
}
