//
//  CameraView.swift
//  
//
//  Created by Victor Cantu on 1/19/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class CameraView: Div {
    
    override class var name: String { "div" }
    
    var type: LoadType
    
    private var callback: ((
        _ item: String
    ) -> ())
    
    init(
        type: LoadType,
        callback: @escaping ((
            _ item: String
        ) -> ())
    ) {
        self.type = type
        self.callback = callback
        
        super.init()
    }
    
    @State var currentPicture: String? = nil
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var video = Video()
        .id(Id(unicodeScalarLiteral: "video"))
        .backgroundColor(.grayBlackDark)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
    
    lazy var canvas = Canvas()
        .id(Id(unicodeScalarLiteral: "canvas"))
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .display(.none)
        .left(0.px)
        .top(0.px)

    lazy var output = Div{
        self.photo
    }
        .hidden(self.$currentPicture.map{ $0 == nil })
        .backgroundColor(.transparent)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
    
    lazy var photo = Img()
        .id(Id(unicodeScalarLiteral: "photo"))
        .height(100.percent)
        .width(100.percent)
        .objectFit(.cover)

    lazy var camaraButton = Div()
        .id(Id(unicodeScalarLiteral: "startbutton"))
        .hidden(self.$currentPicture.map{ $0 != nil })
        .backgroundColor(.white)
        .borderRadius(25.px)
        .cursor(.pointer)
        .marginTop(10.px)
        .height(50.px)
        .width(50.px)
        .onClick {
            self.currentPicture = takePicture()
        }
    
    lazy var usePictureButton = Span("Usar Foto")
        .hidden(self.$currentPicture.map{ $0 == nil })
        .class(.uibtnLarge)
        .marginTop(10.px)
        .onClick {
            
            guard let currentPicture = self.currentPicture else {
                showError(.errorGeneral, "Tome foto de nuevo")
                return
            }
            
            self.callback(currentPicture)
            
            self.remove()
            
        }
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        stopVideo()
                        Dispatch.asyncAfter(0.5) {
                            self.remove()
                        }
                    }
                
                H2("Camara")
                    .color(.lightBlueText)
                    .height(35.px)
            }
            
            Div{
                
                self.video
                
                self.canvas
                
                self.output
                
                Div{
                    Div{
                        
                        Div("Tomar de Nuevo")
                            .hidden(self.$currentPicture.map{ $0 == nil })
                            .position(.absolute)
                            .cursor(.pointer)
                            .color(.white)
                            .float(.left)
                            .onClick{
                                
                                startCamara()
                                
                                self.currentPicture = nil
                            }
                        
                        self.camaraButton
                        
                        self.usePictureButton
                    }
                    .margin(all:12.px)
                    
                }
                .backgroundColor(.transparentBlack)
                .position(.absolute)
                .width(100.percent)
                .overflow(.hidden)
                .height(70.px)
                .align(.center)
                .bottom(0.px)
                .left(0.px)
                
            }
            .custom("height", "calc(100% - 35px)")
            .borderRadius(all: 24.px)
            .position(.relative)
            .overflow(.hidden)
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 274px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(535.px)
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
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        loadingView(show: true)
        
        Dispatch.asyncAfter(0.5) {
            loadingView(show: false)
        }
        
        startCamara()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
}

extension CameraView {
    
    enum LoadType: String, Codable {
        case picture
        case view
    }
    
}
