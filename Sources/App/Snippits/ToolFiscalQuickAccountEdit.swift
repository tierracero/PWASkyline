//
//  ToolFiscalQuickAccountEdit.swift
//  
//
//  Created by Victor Cantu on 2/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ToolFiscalQuickAccountEdit: Div {
    
    override class var name: String { "div" }
    
    @State var accountid: UUID
    
    @State var razon: String
    
    @State var rfc: String
    
    @State var zipCpde: String
    
    /// 612 Personas Físicas con Actividades Empresariales y Profesionales...
    @State var regimen: FiscalRegimens?
    
    @State var email: String
    
    @State var mobile: String
    
    private var callback: ((
        _ razon: String,
        _ rfc: String,
        _ zipCpde: String,
        _ regimen: FiscalRegimens,
        _ email: String,
        _ mobile: String
    ) -> ())
    
    init(
        accountid: UUID,
        razon: String,
        rfc: String,
        zipCpde: String,
        regimen: FiscalRegimens?,
        email: String,
        mobile: String,
        callback: @escaping ((
            _ razon: String,
            _ rfc: String,
            _ zipCpde: String,
            _ regimen: FiscalRegimens,
            _ email: String,
            _ mobile: String
        ) -> ())
    ) {
        self.accountid = accountid
        self.razon = razon
        self.rfc = rfc
        self.zipCpde = zipCpde
        self.regimen = regimen
        self.email = email
        self.mobile = mobile
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var reciverRegimen: String = ""
    
    lazy var razonSocialInput = InputText(self.$razon)
        .placeholder("Razon Social")
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        .onFocus({ tf in
            tf.select()
        })
    
    
    lazy var rfcInput = InputText(self.$rfc)
        .placeholder("RFC")
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        .onFocus({ tf in
            tf.select()
        })
    
    
    lazy var zipCodeInput = InputText(self.$zipCpde)
        .placeholder("Codigo Postal")
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        .onFocus({ tf in
            tf.select()
        })
    
    lazy var regimenSelect = Select(self.$reciverRegimen)
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        
    lazy var emailField = InputText(self.$email)
        .placeholder("Correo Electonico Fiscal")
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        .onFocus({ tf in
            tf.select()
        })
    
    
    lazy var mobileInput = InputText(self.$mobile)
        .placeholder("Celular Fiscal")
        .class(.textFiledBlackDark)
        .marginBottom(3.px)
        .width(95.percent)
        .fontSize(20.px)
        .height(24.px)
        .onFocus({ tf in
            tf.select()
        })
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Editar Perfil Fiscal")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).marginBottom(7.px)
            
            Label("Razon Social")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.razonSocialInput
            
            Div().class(.clear).marginBottom(7.px)
            
            Label("RFC")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.rfcInput
            
            Div().class(.clear).marginBottom(7.px)
            
            
            
            Label("Codigo Postal")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.zipCodeInput
            
            Div().class(.clear).marginBottom(7.px)
            
            
            
            Label("Regimen Fiscal")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.regimenSelect
            
            Div().class(.clear).marginBottom(7.px)
            
            
            
            Label("Correo Fiscal")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.emailField
            
            Div().class(.clear).marginBottom(7.px)
            
            
            Label("Celular Fiscal")
                .color(.white)
            
            Div().class(.clear).marginBottom(3.px)
            
            self.mobileInput
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                Div("Guardar Cambios")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.saveChanges()
                    }
            }
            .align(.right)
            
            Div().class(.clear).marginBottom(7.px)
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 200px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .top(25.percent)
        .width(400.px)
    }
    
    
    override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        regimenSelect.appendChild(
            Option("Seleccione Perfil")
                .value("")
        )
        
        FiscalRegimens.allCases.forEach { regimen in
            
            let opt = Option("\(regimen.code) \(regimen.description)")
                .value(regimen.code)
            
            regimenSelect.appendChild(opt)
            
        }
        
        if let regimen {
            reciverRegimen = regimen.rawValue
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        razonSocialInput.select()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
    func saveChanges(){
        
        razon = razon.uppercased().purgeSpaces
        
        rfc = rfc.uppercased().purgeSpaces
        
        zipCpde = zipCpde.pseudo.uppercased().purgeSpaces
        
        if razon.isEmpty {
            showError(.requiredField, .requierdValid("Razon social"))
            razonSocialInput.select()
            return
        }
        
        if rfc.isEmpty {
            showError(.requiredField, .requierdValid("RFC"))
            rfcInput.select()
            return
        }
        
        if zipCpde.isEmpty {
            showError(.requiredField, .requierdValid("Codigo Postal"))
            zipCodeInput.select()
            return
        }
        
        guard let newRegimen = FiscalRegimens(rawValue: reciverRegimen) else {
            showError(.requiredField, .requierdValid("Regimen Fiscal"))
            return
        }
        
        
        loadingView(show: true)
        
        API.custAccountV1.updateFiscal(
            accountid: accountid,
            fiscalRazon: razon,
            fiscalRfc: rfc,
            fiscalRegime: newRegimen,
            fiscalZip: zipCpde,
            fiscalPOCMail: email,
            fiscalPOCMobile: mobile
        ){ resp in
            
            loadingView(show: false)

            guard let resp else {
               showError(.generalError, .serverConextionError)
               return
            }

            guard resp.status == .ok else {
               showError(.generalError, resp.msg)
               return
            }
            
            showSuccess(.operacionExitosa, "Datos Actualizados")
            
            self.callback(
                self.razon,
                self.rfc,
                self.zipCpde,
                newRegimen,
                self.email,
                self.mobile
            )
            self.remove()
               
        }

    }
    
}
