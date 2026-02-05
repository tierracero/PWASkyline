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

    override func didAddToDOM() {
        super.didAddToDOM()

        /*

                        API.custAPIV1.requestMobileCamara( 
                            type: .useCamaraForOCR,
                            connid: custCatchChatConnID,
                            eventid: self.viewId,
                            relatedid: self.orcScript?.id,
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
                    
        */

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
            .left(10.percent)
            .top(25.px)
        }
        

}
    
    