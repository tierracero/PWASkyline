//
//  AccountCreditConfirmationViews.swift
//
//
//  Created by Codex on 6/29/26.
//

import Foundation
import TCFundamentals
import Web

private struct AccountCreditConfirmationField {
    let title: String
    let isValid: Bool
}

private class AccountCreditConfirmationFieldView: Div {

    override class var name: String { "div" }

    let field: AccountCreditConfirmationField

    init(_ field: AccountCreditConfirmationField) {
        self.field = field
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @DOM override var body: DOM.Content {
        Div {
            Img()
                .src(self.field.isValid ? "/skyline/media/checkmark2.png" : "/skyline/media/cross.png")
                .height(28.px)
                .width(28.px)
                .marginRight(12.px)
                .float(.left)

            Div(self.field.title)
                .fontSize(18.px)
                .lineHeight(28.px)
                .color(self.field.isValid ? .white : .fireBrick)
                .class(.oneLineText)
        }
        .custom("width", "calc(50% - 24px)")
        .float(.left)
        .margin(all: 12.px)
    }
}

class ActvateBuissnessCreditConfirmationView: Div {

    override class var name: String { "div" }

    let businessName: String
    let fiscalRazon: String
    let fiscalRfc: String
    let fiscalPOCFirstName: String
    let fiscalPOCLastName: String
    let fiscalPOCMobile: String
    let callback: () -> ()

    init(
        businessName: String,
        fiscalRazon: String,
        fiscalRfc: String,
        fiscalPOCFirstName: String,
        fiscalPOCLastName: String,
        fiscalPOCMobile: String,
        callback: @escaping () -> ()
    ) {
        self.businessName = businessName
        self.fiscalRazon = fiscalRazon
        self.fiscalRfc = fiscalRfc
        self.fiscalPOCFirstName = fiscalPOCFirstName
        self.fiscalPOCLastName = fiscalPOCLastName
        self.fiscalPOCMobile = fiscalPOCMobile
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private var fields: [AccountCreditConfirmationField] {
        [
            .init(title: "Nombre del Negocio", isValid: !businessName.isEmpty),
            .init(title: "Razon Social", isValid: !fiscalRazon.isEmpty),
            .init(title: "RFC Fiscal", isValid: !fiscalRfc.isEmpty),
            .init(title: "Primer Nombre de contacto fiscal", isValid: !fiscalPOCFirstName.isEmpty),
            .init(title: "Primer Apellido de contacto fiscal", isValid: !fiscalPOCLastName.isEmpty),
            .init(title: "Movil de contacto fiscal", isValid: !fiscalPOCMobile.isEmpty)
        ]
    }

    private var isValid: Bool {
        fields.allSatisfy { $0.isValid }
    }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Img()
                    .closeButton(.uiView4)
                    .onClick {
                        self.remove()
                    }

                H2("Alta de Credito Empresarial")
                    .color(.lightBlueText)

                Div()
                    .class(.clear)
                    .marginTop(12.px)

                P("Confirme que la cuenta cuenta con los datos requeridos.")
                    .fontSize(24.px)
                    .color(.white)

                Div()
                    .class(.clear)

                AccountCreditConfirmationFieldView(self.fields[0])
                AccountCreditConfirmationFieldView(self.fields[1])
                AccountCreditConfirmationFieldView(self.fields[2])
                AccountCreditConfirmationFieldView(self.fields[3])
                AccountCreditConfirmationFieldView(self.fields[4])
                AccountCreditConfirmationFieldView(self.fields[5])

                Div().class(.clear).height(12.px)

                if self.isValid {
                    Div {
                        Strong("Activar Credito")
                            .padding(all: 7.px)
                    }
                    .class(.greenButton)
                    .cursor(.pointer)
                    .float(.right)
                    .onClick {
                        self.remove()
                        self.callback()
                    }
                }
                else {
                    Div("Favor de completar los valores faltantes.")
                        .color(.fireBrick)
                        .fontSize(22.px)
                        .fontWeight(.bolder)
                        .textAlign(.center)
                        .marginTop(12.px)
                }
                
                Div().class(.clear).height(12.px)

            }
            .margin(all: 7.px)
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        .color(.white)
    }

    override func buildUI() {
        super.buildUI()

        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
}

class ActvatePersonalCreditConfirmationView: Div {

    override class var name: String { "div" }

    let firstName: String
    let lastName: String
    let mobile: String
    let IDTypeIsValid: Bool
    let IDNum: String
    let curp: String
    let callback: () -> ()

    init(
        firstName: String,
        lastName: String,
        mobile: String,
        IDTypeIsValid: Bool,
        IDNum: String,
        curp: String,
        callback: @escaping () -> ()
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.IDTypeIsValid = IDTypeIsValid
        self.IDNum = IDNum
        self.curp = curp
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private var fields: [AccountCreditConfirmationField] {
        [
            .init(title: "Nombre", isValid: !firstName.isEmpty),
            .init(title: "Apellido", isValid: !lastName.isEmpty),
            .init(title: "Movil", isValid: !mobile.isEmpty),
            .init(title: "Tipo de Identificacion", isValid: IDTypeIsValid),
            .init(title: "Numero de Identificacion", isValid: !IDNum.isEmpty),
            .init(title: "CURP", isValid: !curp.isEmpty)
        ]
    }

    private var isValid: Bool {
        fields.allSatisfy { $0.isValid }
    }

    @DOM override var body: DOM.Content {
        Div {
            Div {
                Img()
                    .closeButton(.uiView4)
                    .onClick {
                        self.remove()
                    }

                H2("Alta de Credito Personal")
                    .color(.lightBlueText)

                Div()
                    .class(.clear)
                    .marginTop(12.px)

                P("Confirme que la cuenta cuenta con los datos requeridos.")
                    .fontSize(24.px)
                    .color(.white)

                Div()
                    .class(.clear)

                AccountCreditConfirmationFieldView(self.fields[0])
                AccountCreditConfirmationFieldView(self.fields[1])
                AccountCreditConfirmationFieldView(self.fields[2])
                AccountCreditConfirmationFieldView(self.fields[3])
                AccountCreditConfirmationFieldView(self.fields[4])
                AccountCreditConfirmationFieldView(self.fields[5])

                Div().class(.clear).height(12.px)

                if self.isValid {
                    Div{
                        Div {
                            Strong("Activar Credito")
                                .padding(all: 7.px)
                        }
                        .class(.greenButton)
                        .cursor(.pointer)
                        .float(.right)
                        .onClick {
                            self.remove()
                            self.callback()
                        }
                    }
                    
                }
                else {
                    Div("Favor de completar los valores faltantes.")
                        .color(.fireBrick)
                        .fontSize(22.px)
                        .fontWeight(.bolder)
                        .textAlign(.center)
                        .marginTop(12.px)
                }

                Div().class(.clear).height(12.px)
            }
            .margin(all: 7.px)
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        .color(.white)
    }

    override func buildUI() {
        super.buildUI()

        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
}
