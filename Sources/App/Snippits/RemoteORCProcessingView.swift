// 
// RemoteORCProcessingView.swift
//
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class RemoteORCProcessingView: Div {
    
    override class var name: String { "div" }

    let script: OCRCustomeScript
    private var callback: (
        _ idTagOne: String,
        _ idTagTwo: String,
        _ items: [OCRCustomePayloadItem]
    ) -> Void
    init(
        script: OCRCustomeScript,
        callback: @escaping(
            _ idTagOne: String,
            _ idTagTwo: String,
            _ items: [OCRCustomePayloadItem]
        ) -> Void
    ) {
        self.script  = script
        self.callback = callback
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    var viewId: UUID = .init()

    let ws = WS()
    
    @State var loadState = "📷 Solicitando conección a camara del al app"

    @State var docIsLoaded = false

    /// Mayor document Identifier EG: SERIE
    @State var idOne: String = ""
    
    /// Minor document identifier EG: FOLIO
    @State var idTwo: String = ""
    
    @State var itemRefrence: [RemoteORCProcessingItem] = []

    lazy var itemContainer = Div()

    override func didAddToDOM() {
        super.didAddToDOM()

        sendSignal()

    }

    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

        WebApp.current.wsevent.listen {
            
            if $0.isEmpty { return }
            
            let (event, _) = self.ws.recive($0)
            
            guard let event  else {
                return
            }

            switch event {
                case .requestMobileCamaraFail:
                if let payload = self.ws.requestMobileCamaraFail($0) {
                                        
                    guard payload.eventid == self.viewId else {
                        return
                    }

                    self.remove()
                }
            case .requestMobileCamaraInitiate:
                if let payload = self.ws.requestMobileCamaraInitiate($0) {
                    
                    guard payload.eventid == self.viewId else {
                        return
                    }

                    self.loadState = "La camara rmota ha iniciado" 

                }
            case .requestMobileCamaraProgress:
            
                if let payload = self.ws.requestMobileCamaraProgress($0) {
                    
                    guard payload.eventid == self.viewId else {
                        return
                    }

                    self.loadState = "Cargando \(payload.percent.toString)%"

                }

           case .requestMobileCamaraCancel:

                if let payload = self.ws.requestMobileCamaraCancel($0) {

                    guard payload.eventid == self.viewId else {
                        return
                    }

                    self.remove()

                }

           case .requestMobileCamaraSelected:

                if let payload = self.ws.requestMobileCamaraSelected($0) {
           
                    guard payload.eventid == self.viewId else {
                        return
                    }

                    self.loadState = "Iniciando Carga..." 
                }
            case .asyncFileOCR:
                if let payload = self.ws.asyncFileOCR($0) {
                    
                    guard payload.eventId == self.viewId else {
                        return
                    }

                    self.docIsLoaded = true
                    
                    self.idOne = payload.payload.idOne
                
                    self.idTwo = payload.payload.idTwo

                    self.itemRefrence = payload.payload.items.map{ .init(item: $0)}

                }
            case .asyncFileUpdate:
                if let payload = self.ws.asyncFileUpdate($0) {
                    
                    guard payload.eventId == self.viewId else {
                        return
                    }

                    self.loadState = payload.message

                }
           
            default:
            break
            }
            
        }

    }

    @DOM override var body: DOM.Content {

            Div{

                /// Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            self.remove()
                        }
                    
                    Div{

                        Div{
                            Img()
                                .src("/skyline/media/mobileScannerWhite.png")
                                .marginTop(3.px)
                                .height(23.px)
                        }
                        .marginRight(7.px)
                        .float(.left)

                        Span("Enviar Señal")

                    }
                    .marginRight(12.px)
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        self.sendSignal()
                    }

                    H2("Escaneo de Documento | \(self.script.name)")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                                
                Div().clear(.both).height(3.px)

                Div{

                    Div{
                        Table{
                            Tr{
                                Td{
                                    Span(self.$loadState)
                                    .color(.white)
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                    }
                    .height(100.percent)
                    .hidden(self.$docIsLoaded)
                    
                    Div{
                        
                        H2("Datos de la compra")
                            .color(.white)

                        Div {
                            H2(self.$idOne.map{ "SERIE: \($0)" })
                            .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)

                        Div {
                            H2(self.$idTwo.map{ "FOLIO: \($0)" })
                            .color(.white)
                        }
                        .width(50.percent)
                        .float(.left)

                        H2("Productos")
                            .color(.white)
                        Div{
                            Div{
                                ForEach(self.$itemRefrence) { item in
                                    item
                                }
                            }
                            .margin(all: 7.px)
                        }
                        .class(.roundDarkBlue)
                        .custom("height", "calc(100% - 90px)")

                    }
                    .height(100.percent)
                    .hidden(self.$docIsLoaded.map{ !$0 })

                }
                .custom("height", "calc(100% - 85px)")

                Div{
                    Div("Ingresar Productos")
                    .class( .uibtnLargeOrange )
                    .onClick {
                        //
                        self.addProducts()
                    }
                }
                .align(.right)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(10% - 14px)")
            .custom("top","calc(10% - 14px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(80.percent)
        }
    
    func sendSignal(){

        loadingView(show: true)

        API.custAPIV1.requestMobileCamara( 
            type: .useCamaraForOCR,
            connid: custCatchChatConnID,
            eventid: self.viewId,
            relatedid: self.script.id,
            relatedfolio: "",
            multipleTakes: false
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            showSuccess(.operacionExitosa, "Entre en la notificacion en su movil.")
            
        }
        
    }

    func addProducts() {

        self.callback( idOne, idTwo, itemRefrence.map{
            .init(
                code: $0.item.code,
                description: $0.item.description,
                 cost: $0.item.cost,
                 units: $0.item.units,
                 poc: $0.poc
            )
        })

        self.remove()

    }

}
    
extension RemoteORCProcessingView {

    class RemoteORCProcessingItem: Div {
        
        override class var name: String { "div" }

        let item: OCRCustomePayloadItem

        @State var poc: CustPOCQuick? = nil

        init(
            item: OCRCustomePayloadItem
        ) {
            self.item  = item
            self.poc = item.poc
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        override func buildUI() {
            super.buildUI()
            custom("width", "calc(100% - 14px)")
        }

        @DOM override var body: DOM.Content {
            Div {

                Div (self.item.code)
                .class(.oneLineText)
                .minHeight(10.px)
                .width(150.px)
                .float(.left)

                Div (self.item.description)
                .custom("width", "calc(100% - 530px)")
                .class(.oneLineText)
                .minHeight(10.px)
                .float(.left)

                Div (self.item.units.toString)
                .class(.oneLineText)
                .minHeight(10.px)
                .width(90.px)
                .float(.left)

                Div (self.item.cost.formatMoney)
                .class(.oneLineText)
                .minHeight(10.px)
                .width(90.px)
                .float(.left)

                Div {

                    Div("Crear Producto")
                    .class(.oneLineText)
                    .align(.center)
                    .class(.uibtn)
                    .onClick{
                        
                        let view = SelectStoreDepartment { type, levelid, titleText in
                        
                            let view = ManagePOC(
                                leveltype: type,
                                levelid: levelid,
                                levelName: titleText,
                                pocid: nil,
                                titleText: titleText,
                                quickView: true
                            ) { pocId, upc, brand, model, name, cost, price, avatar, reqSeries in
                                self.poc = .init(
                                    id: pocId,
                                    name: name,
                                    pseudoName: name.pseudo,
                                    upc: upc,
                                    brand: brand,
                                    model: model,
                                    pseudoModel: model.pseudo,
                                    tagOne: "",
                                    tagTwo: "",
                                    tagThree: "",
                                    fiscCode: "",
                                    fiscUnit: "",
                                    cost: cost,
                                    pricea: price,
                                    priceb: price,
                                    pricec: price,
                                    pricecr: price,
                                    avatar: avatar,
                                    inCredit: false,
                                    reqSeries: reqSeries,
                                    status: GeneralStatus.active
                                )
                            } deleted: { }
                            
                            view.upc = self.item.code

                            view.name = self.item.description

                            view.cost = self.item.cost.formatMoney

                            addToDom( view )

                        }

                        addToDom( view )
                    }

                }
                .width(100.px)
                .align(.center)
                .float(.left)
                .hidden(self.$poc.map{ $0 == nil })
                
                Div{
                    Img()
                    .src("skyline/media/icon-checkmark.svg")
                    .margin(all: 5.px)
                    .height(42)
                }
                .width(100.px)
                .align(.center)
                .float(.left)
                .hidden(self.$poc.map{ $0 != nil })
                
                Div().clear(.both)

            }
            .borderBottom(width: .thin, style: .solid, color: .backGroundLightGraySlate)
            .fontSize(26.px)
            .color(.white)
            
            Div().height(3.px)

        }

    }
}

