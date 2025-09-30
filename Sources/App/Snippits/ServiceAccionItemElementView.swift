//
//  ServiceAccionItemElementView.swift
//  
//
//  Created by Victor Cantu on 4/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionItemElementView: Div {
    
    override class var name: String { "div" }
    
    @State var element: CustSaleActionObjectDecoder?
    
    private var callback: ((
        _ element: CustSaleActionObjectDecoder
    ) -> ())
    
    init(
        element: CustSaleActionObjectDecoder?,
        callback: @escaping ((
            _ element: CustSaleActionObjectDecoder
        ) -> ())
    ) {
        self.element = element
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    /// textField, textArea, checkBox, selection, radio, instruction
    @State var type = SaleActionInputType.textField
    
    @State var typeListener = SaleActionInputType.textField.rawValue
    
    @State var title: String = ""
    
    @State var help: String = ""
    
    @State var placeholder: String = ""
    
    @State var options: String = ""
    
    @State var isRequired: Bool = false
    
    @State var customerMessage: String = ""
    
    lazy var typeSelect = Select(self.$typeListener)
        .custom("width", "calc(100% - 100px)")
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .height(28.px)
        .onChange { _, select in
            self.typeListener = select.value
        }

    lazy var titleField = InputText(self.$title)
        .placeholder("Nombre del la instruccion")
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
    
    lazy var helpField = InputText(self.$help)
        .placeholder("Texto que describre la accion a tomar")
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
    
    lazy var placeholderField = InputText(self.$placeholder)
        .placeholder("Texto que se incluye como texto temporal del campo")
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
        
    lazy var optionsArea = TextArea(self.$options)
        .placeholder(self.$type.map{ ($0 == .textArea) ? "Eduque al cleinte lo siguinte:\nNo deje articulos de valor ya que..." : "Texto que se incluye como texto temporal del campo" })
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .marginRight(12.px)
        .width(95.percent)
        .height(100.px)
    
    lazy var customerMessageField = InputText(self.$customerMessage)
        .placeholder("Texto que se incluye como texto temporal del campo")
        .class(.textFiledBlackDark)
        .marginBottom(12.px)
        .marginRight(12.px)
        .width(95.percent)
        .height(28.px)
        
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick{
                        self.remove()
                    }
                
                H2( self.$element.map{ ($0 == nil) ? "Agregar Elemento" : "Editar Elemento" } )
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
            Span("Tipo de elemento")
                .marginBottom(7.px)
                .color(.white)
            
            Div().class(.clear)
            
            self.typeSelect
            
            Div().class(.clear)
            
            Span("Nombre de la accion")
                .marginBottom(7.px)
                .color(.white)
            
            Div().class(.clear)
            
            self.titleField
            
            Div().class(.clear)
            
            Span("Texto de ayuda")
                .hidden(self.$type.map{ $0 == .textArea })
                .color(.white)
            
            Div().class(.clear).marginBottom(7.px)
            
            self.helpField
                .hidden(self.$type.map{ $0 == .textArea })
                .color(.white)
            
            Div().class(.clear)
            
            Span("Placeholder (Dentro del caja)")
                .hidden(self.$type.map{ !($0 == .textField || $0 == .textArea ) })
                .color(.white)
            
            Div().class(.clear).marginBottom(7.px)
            
            self.placeholderField
                .hidden(self.$type.map{ !($0 == .textField || $0 == .textArea ) })
            
            Div().class(.clear)
            
            Span("Valores, una por linea")
                .hidden(self.$type.map{ !($0 == .radio || $0 == .selection ) })
                .color(.white)
            
            Div().class(.clear).marginBottom(7.px)
            
            self.optionsArea
                .hidden(self.$type.map{ !($0 == .radio || $0 == .selection  || $0 == .textArea ) })
            
            Div().class(.clear).marginBottom(7.px)
                .hidden(self.$type.map{ !($0 == .radio || $0 == .selection  || $0 == .textArea ) })
            
            Div{
                Span("Es Requerido")
                    .color(.white)
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                InputCheckbox().toggle(self.$isRequired)
            }
            .width(50.percent)
            .float(.left)
    
            Div{
                Div().class(.clear).marginBottom(7.px)
                
                Div{
                    Span("Mensaje a Cliente (opcional)")
                        .color(.white)
                }
                .width(50.percent)
                .float(.left)
                
                Div{
                    self.customerMessageField
                }
                .width(50.percent)
                .float(.left)
                
            }
            .hidden(self.$type.map{ $0 != .instruction })
            
            Div().class(.clear).marginBottom(12.px)
            
            Div{
                
                Div( self.$element.map{ ($0 == nil) ? "Agregar Elemento" : "Guardar Datos" } )
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.saveElement()
                    }
                
            }
            .align(.right)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 250px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .top(20.percent)
        .width(500.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        SaleActionInputType.allCases.forEach { item in
            typeSelect.appendChild(Option(item.description).value(item.rawValue))
        }
        
        $typeListener.listen {
            if let _type = SaleActionInputType(rawValue: $0) {
                
                self.type = _type
                
            }
        }
        
        if let element {
            
            type = element.type
            
            typeListener = type.rawValue
            
            title = element.title
            
            help = element.help
            
            placeholder = element.placeholder
            
            options = element.options.joined(separator: "\n")
            
            isRequired = element.isRequired
            
            customerMessage = element.customerMessage
            
        }
        
    }
    
    func saveElement(){
    
        let _options = options.explode("\n")
        
        if title.isEmpty {
            showError( .campoRequerido, .requierdValid("nombre"))
            titleField.select()
            return
        }
        
        switch type {
        case .textField, .textArea:
            
            if help.isEmpty {
                showError( .campoRequerido, .requierdValid("texto ayuda"))
                helpField.select()
                return
            }
            
            if placeholder.isEmpty {
                showError( .campoRequerido, .requierdValid("placeholder"))
                placeholderField.select()
                return
            }
            
        case .checkBox:
            
            if help.isEmpty {
                showError( .campoRequerido, .requierdValid("texto ayuda"))
                helpField.select()
                return
            }
            
        case .selection, .radio:
            
            if help.isEmpty {
                showError( .campoRequerido, .requierdValid("texto ayuda"))
                helpField.select()
                return
            }
            
            if options.purgeSpaces.isEmpty {
                showError( .campoRequerido, .requierdValid("opciones"))
                return
            }
        case .instruction:
            
            if help.isEmpty {
                showError( .campoRequerido, .requierdValid("mensaje de instruccion"))
                return
            }
        }
        
        callback(.init(
            id: element?.id ?? .init(),
            type: type,
            title: title,
            help: help,
            placeholder: placeholder,
            options: _options,
            isRequired: isRequired,
            customerMessage: self.customerMessage
        ))
        
        self.remove()
        
    }
    
}
