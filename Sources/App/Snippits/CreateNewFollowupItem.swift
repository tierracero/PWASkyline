//
//  CreateNewFollowupItem.swift
//
//
//  Created by Victor Cantu on 3/6/26.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateNewFollowupItem: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ linkType: CustFollowUpItemType,
        _ linkId: UUID?,
        _ comment: String
    ) -> ())
    
    /// product, service, general
    @State var linkType: CustFollowUpItemType?
    
    @State var linkId: UUID?
    
    @State var comment: String
    
    @State var linkTypeListener = ""
    
    @State var linkIdListener = ""
    
    lazy var linkTypeSelect = Select(self.$linkTypeListener)
        .custom("width", "calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var linkIdField = InputText(self.$linkIdListener)
        .class(.textFiledBlackDarkLarge)
        .placeholder("UUID de relacion (opcional)")
        .width(95.percent)
    
    lazy var commentField = TextArea(self.$comment)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Ingrese comentario")
        .width(95.percent)
        .height(120.px)
    
    init(
        linkType: CustFollowUpItemType? = nil,
        linkId: UUID? = nil,
        comment: String = "",
        callback: @escaping ((
            _ linkType: CustFollowUpItemType,
            _ linkId: UUID?,
            _ comment: String
        ) -> ())
    ) {
        self.linkType = linkType
        self.linkId = linkId
        self.comment = comment
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div {
            
            Div {
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }
                
                H2("Crear Item de Seguimiento")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).height(7.px)
            
            H3("Tipo de relacion")
                .color(.gray)
            Div().class(.clear).height(3.px)
            self.linkTypeSelect
            
            Div().class(.clear).height(7.px)
            
            H3("ID de relacion")
                .color(.gray)
            Div().class(.clear).height(3.px)
            self.linkIdField
            
            Div().class(.clear).height(7.px)
            
            H3("Comentario")
                .color(.gray)
            Div().class(.clear).height(3.px)
            self.commentField
            
            Div().class(.clear).height(7.px)
            
            Div("Agregar Item")
                .class(.uibtnLargeOrange)
                .textAlign(.center)
                .width(95.percent)
                .onClick {
                    self.createItem()
                }
        }
        .custom("left", "calc(50% - 225px)")
        .custom("top", "calc(50% - 250px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(450.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        linkTypeSelect.appendChild(
            Option("Seleccione tipo de relacion")
                .value("")
        )
        
        CustFollowUpItemType.allCases.forEach { item in
            linkTypeSelect.appendChild(
                Option(item.rawValue)
                .value(item.rawValue)
            )
        }
        
        if let linkType {
            linkTypeListener = linkType.rawValue
        }
        
        if let linkId {
            linkIdListener = linkId.uuidString
        }
        
        $linkTypeListener.listen {
            self.linkType = CustFollowUpItemType(rawValue: $0)
        }
    }
    
    func createItem() {
        
        guard let linkType = CustFollowUpItemType(rawValue: linkTypeListener) else {
            showError(.invalidField, "Seleccione tipo de relacion")
            return
        }
        
        var linkId: UUID? = nil
        
        if !linkIdListener.isEmpty {
            guard let id = UUID(uuidString: linkIdListener) else {
                showError(.invalidField, "Ingrese UUID de relacion valido")
                return
            }
            linkId = id
        }
        
        if comment.isEmpty {
            showError(.invalidField, "Ingrese comentario")
            return
        }
        
        callback(linkType, linkId, comment)
        
        remove()
    }
}
