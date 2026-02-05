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

    init(
        script: OCRCustomeScript
    ) {
        self.script  = script 
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
    
    /// Found Prodcts
    @State var items: [OCRCustomePayloadItem] = []

    override func didAddToDOM() {
        super.didAddToDOM()


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

    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)

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

                                ForEach(self.$items) { item in
                                    Div("\(item.units) \(item.code) \(item.description)")

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
                .custom("height", "calc(100% - 50px)")
                
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
        

}
    
    