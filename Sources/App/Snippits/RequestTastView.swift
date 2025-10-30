//
//  RequestTastView.swift
//
//
//  Created by Victor Cantu on 10/23/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class RequestTastView: Div {
    
    override class var name: String { "div" }
    
    var preloaded: Bool
    
    ///product, purchase, fiscal, orderCharge, orderPayment, sale, budget, personalLone, moneyTransfer, task
    @State var type: CustTaskAuthorizationManagerAlertType?
    
    @State var relationId: UUID?
    
    @State var relationFolio: String?
    
    @State var relationName: String?
    
    private var callback: ((
    ) -> ())
    
    init(
        type: CustTaskAuthorizationManagerAlertType?,
        relationId: UUID?,
        relationFolio: String?,
        relationName: String?,
        callback: @escaping ((
        ) -> ())
    ) {
        self.preloaded = (type != nil)
        self.type = type
        self.relationId = relationId
        self.relationFolio = relationFolio
        self.relationName = relationName
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var userId: UUID? = nil
    
    @State var userName: String = ""
    
    @State var typeListener = ""
    
    @State var selecTypeTitle = ""
    
    @State var reason = ""
    
    @State var selecTypeButton = ""
    
    /// CustTaskAuthorizationManagerAlertLevel
    @State var selectImportanceListener = CustTaskAuthorizationManagerAlertLevel.low.rawValue
    
    lazy var typeSelect = Select(self.$typeListener)
        .body(content: {
            Option("Seleccione tipo de Tarea")
                .value("")
        })
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var selectImportanceSelect = Select(self.$selectImportanceListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        
                        if self.preloaded {
                            self.remove()
                            return
                        }
                        
                        if let _ = self.type {
                            self.typeListener = ""
                            self.type = nil
                            return
                        }
                        
                        self.remove()
                    }
                
                H2{
                    
                    
                    Img()
                        .src("/skyline/media/notificationIcon.png")
                        .marginRight(7.px)
                        .height(24.px)
                    
                    Span("Crear Tarea")
                }
                .color(.lightBlueText)
            }
            
            Div().class(.clear).height(7.px)
            
            Div{
                H2("Seleccione tipo de Tarea")
                    .color(.white)
                
                Div().clear(.both).height(24.px)
                
                self.typeSelect
                
                Div().clear(.both).height(12.px)
            }
            .hidden(self.$type.map{ $0 != nil })
            
            Div{
                
                Div{
                    /// `Tipo de tarea a solicitar`
                    H3("Tipo de tarea a solicitar")
                        .color(.gray)
                    
                    Div().clear(.both).height(3.px)
                    
                    H2(self.$type.map{ $0?.sectionName ?? "Seleccione Tarea"})
                        .color(.white)
                }
                .width(60.percent)
                .float(.left)
                
                Div{
                    H3("Importancia")
                        .color(.gray)
                    
                    Div().clear(.both).height(3.px)
                    
                    self.selectImportanceSelect
                }
                .width(40.percent)
                .float(.left)
                
                Div().clear(.both).height(7.px)
                
                /// `Usuario Seleccionado`
                H3("Usuario Seleccionado")
                    .color(.gray)
                Div().clear(.both).height(3.px)
                Div{
                   Div("Seleleccionar Usuario")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(95.percent)
                        .onClick {
                            self.selectUser()
                        }
                }
                .hidden(self.$userId.map { $0 != nil })
                
                H2(self.$userName)
                    .hidden(self.$userId.map { $0 == nil })
                    .color(.white)
               
                Div().clear(.both).height(7.px)
                
                /// `Elemento Seleccionado`
                H3(self.$selecTypeTitle)
                    .color(.gray)
                Div().clear(.both).height(3.px)
                Div{
                   Div(self.$selecTypeButton)
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                       .width(95.percent)
                       .onClick {
                           self.selectRelation()
                       }
                }
                .hidden(self.$relationId.map { $0 != nil })
                H2{
                    Span(self.$relationFolio.map{ $0 ?? "--"})
                        .hidden(self.$relationFolio.map{ $0 == nil})
                        .marginRight(7.px)
                    
                    Span(self.$relationName.map{ $0 ?? "--"})
                        .marginRight(7.px)
                }
                .hidden(self.$relationId.map { $0 == nil })
                .color(.white)
               
                Div().clear(.both).height(7.px)
                
                /// `Elemento Seleccionado`
                H3("Tarea o instruccion a realizar")
                    .color(.gray)
                
                Div().clear(.both).height(7.px)
                
                TextArea(self.$reason)
                    .class(.textFiledBlackDarkLarge)
                    .placeholder("Que se requiere para esta tarea")
                    .width(90.percent)
                    .fontSize(23.px)
                    .height(90.px)
                
                Div().clear(.both).height(7.px)
                
                Div("Crear Tarea")
                    .class(.uibtnLargeOrange)
                    .textAlign(.center)
                    .width(95.percent)
                    .onClick {
                        self.requestTask()
                    }
                
                Div().clear(.both).height(7.px)
                 
                
            }
            .hidden(self.$type.map{ $0 == nil })
            
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
        
        $typeListener.listen {
            self.type = CustTaskAuthorizationManagerAlertType(rawValue: $0)
        }
        
        $type.listen {
            
            guard let type = $0 else {
                self.relationId = nil
                self.relationFolio = nil
                self.relationName = nil
                self.userId = nil
                self.userName = ""
                self.selecTypeTitle = ""
                self.selecTypeButton = ""
                return
            }
            
            self.parceType()
            
        }
        
        CustTaskAuthorizationManagerAlertType.allCases.forEach { type in
            
            guard type.taskable else {
                return
            }
            
            typeSelect.appendChild(
                Option(type.sectionName)
                .value(type.rawValue)
            )
            
        }
        
        CustTaskAuthorizationManagerAlertLevel.allCases.forEach { item in
            selectImportanceSelect.appendChild(
                Option(item.description)
                    .value(item.rawValue)
            )
        }
        
        parceType()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        if let _ = type {
            self.selectUser()
        }
    }
    
    func parceType() {
        
        guard let type else {
            return
        }
        
//        self.typeListener = type.rawValue
        
//        self.selectImportanceListener = CustTaskAuthorizationManagerAlertLevel.low.rawValue
        
        switch type {
        case .product:
            self.selecTypeTitle = "Seleccione Producto"
            self.selecTypeButton = "Buscar Producto"
        case .purchase:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .fiscal:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .order:
            self.selecTypeTitle = "Seleccionar Orden"
            self.selecTypeButton = "Buscar Orden"
        case .orderCharge:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .orderPayment:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .sale:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .budget:
            self.selecTypeTitle = "Seleccionar Orden"
            self.selecTypeButton = "Buscar Orden"
        case .personalLone:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .moneyTransfer:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .changePrice:
            self.selecTypeTitle = ""
            self.selecTypeButton = ""
        case .task:
            self.selecTypeTitle = "Seleccione Relacion"
            self.selecTypeButton = "Relacion no requerida"
        }
        
    }
    
    func selectUser(){
        addToDom(SelectCustUsernameView(
            type: (custCatchHerk > 3) ? .all : .store(custCatchStore),
            ignore: [],
            callback: { user in
                self.userId = user.id
                self.userName = user.username
            }
        ))
    }
    
    func selectRelation(){
        
        guard let type else {
            showError(.unexpectedResult, #"Seleccione "Tipo de tarea a solicitar""#)
            return
        }
        
        switch type {
        case .product:
            addToDom(ToolReciveSendInventorySelectPOC(
                isManual: true,
                selectedPOC: { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                    self.relationId = pocid
                    self.relationName = "\(brand) \(model) \(name)"
                }, createPOC: { type, levelid, titleText in
                    let view = ManagePOC(
                        leveltype: type,
                        levelid: levelid,
                        levelName: titleText,
                        pocid: nil,
                        titleText: titleText,
                        quickView: true
                    ) { pocid, upc, brand, model, name, cost, price, avatar, reqSeries in
                        self.relationId = pocid
                        self.relationName = "\(brand) \(model) \(name)"
                    } deleted: {
                        // Not aplicable
                    }
                }))
        case .purchase:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .fiscal:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .order, .budget:
            addToDom(QuickOrderSearch{ order in
                self.relationId = order.id
                self.relationFolio = order.folio
                self.relationName = order.name
            })
        case .orderCharge:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .orderPayment:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .sale:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .personalLone:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .moneyTransfer:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .changePrice:
            showError(.unexpectedResult, "Lo sentimos, \(type.sectionName.uppercased()) no es soportado, contacte a Soporte TC.")
        case .task:
            break
        }
        
    }
    
    func requestTask(){
        
        guard let type else {
            showError(.campoInvalido, "Seleccione tipo de tarea")
            return
        }
        
        guard let level = CustTaskAuthorizationManagerAlertLevel(rawValue: selectImportanceListener) else {
            showError(.campoInvalido, "Seleccione nivel de importancia")
            return
        }
        guard let userId else {
            showError(.campoInvalido, "Seleccione usuario")
            return
        }
        
        if reason.isEmpty {
            showError(.campoInvalido, "Ingrese Tarea o instruccion a realizar")
            return
        }
        
        if type != .task {
            if relationId == nil  {
                showError(.campoInvalido, selecTypeTitle)
                return
            }
        }
        
        loadingView(show: true)
        
        API.custAPIV1.requestTask(
            type: type,
            level: level,
            relationId: relationId,
            targetIds: [userId],
            description: reason
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
            
            guard let payload = resp.data else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            showSuccess(.operacionExitosa, "Folio de tarea \(payload.taskFolio)")

            self.remove()
            
        }
        
    }
}
