//
//  SocialManagerConfirmView.swift
//  
//
//  Created by Victor Cantu on 4/7/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class SocialManagerConfirmView: Div {
    
    override class var name: String { "div" }
    
    let type: SocialManagerPostType
    
    let originalImage: String
    
    let originalWidth: Int
    
    let originalHeight: Int
    
    let relativeHeight: Int
    
    let relativeWidth: Int
    
    let watermarks: [WaterMarkItem]
    
    let pages: [CustSocialPageQuick]
    
    private var callback: ((
    ) -> ())
    
    init(
        type: SocialManagerPostType,
        originalImage: String,
        originalWidth: Int,
        originalHeight: Int,
        relativeHeight: Int,
        relativeWidth: Int,
        watermarks: [WaterMarkItem],
        pages: [CustSocialPageQuick],
        callback: @escaping ((
        ) -> ())
    ) {
        self.type = type
        self.originalImage = originalImage
        self.originalWidth = originalWidth
        self.originalHeight = originalHeight
        self.relativeHeight = relativeHeight
        self.relativeWidth = relativeWidth
        self.watermarks = watermarks
        self.pages = pages
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var caption: String = ""
    
    @State var link: String = ""
    
    @State var uts: Int64? = nil
    
    var selectedDateStamp = ""
    
    @State var resultViewIsHidden = true
    
    lazy var captionField = TextArea(self.$caption)
        .custom("width","calc(100% - 16px)")
        .placeholder("Texto de la publicación")
        .class(.textFiledBlackDark)
        .borderRadius(7.px)
        .padding(all: 7.px)
        .height(60.px)
    
    lazy var linkField = InputText(self.$link)
        .custom("width","calc(100% - 16px)")
        .placeholder("http://link.pagina.com/articulo/12345")
        .class(.textFiledBlackDark)
        .height(29.px)
    
    lazy var dateField = Div{
        
        Img()
            .src("/skyline/media/cross.png")
            .hidden(self.$uts.map{ $0 == nil })
            .marginTop(1.px)
            .height(24.px)
            .float(.right)
            .onClick { _, event in
                self.selectedDateStamp = ""
                self.uts = nil
                event.stopPropagation()
            }
        
        Span(self.$uts.map{ ($0 == nil) ? "Publicar Hoy" : getDate($0).formatedLong })
    }
        .color(self.$uts.map{ ($0 == nil) ? Color(r: 81, g: 85, b: 94) : .lightGray })
        .padding(top: 3.px, right: 7.px, bottom: 7.px, left: 7.px)
        .class(.textFiledBlackDark)
        .class(.oneLineText)
        .borderRadius(7.px)
        .margin(all: 3.px)
        .fontSize(24.px)
        .onClick {
            
            addToDom(SelectCalendarDate(
                type: nil,
                selectedDateStamp: self.selectedDateStamp,
                currentSelectedDates: [],
                callback: { selectedDateStamp, uts, _ in
                    self.selectedDateStamp = selectedDateStamp
                    self.uts = uts.toInt64
                }))
        }
    
    lazy var resultsView = Div()
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Redes Sociales")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear)
            
            Label("Texto de la publicación")
                .color(.lightGray)
                
            Div().class(.clear).marginBottom(7.px)
            
            self.captionField
            
            Div().class(.clear).marginBottom(12.px)
            
            if self.type == .text {
                
                Label("Link de la publicación")
                    .color(.lightGray)
                   
                Div().class(.clear) .marginBottom(7.px)
                
                self.linkField
                
                Div().class(.clear).marginBottom(12.px)
            }
            
            Label("Fecha de publicacion")
                .color(.lightGray)
                
            Div().class(.clear).marginBottom(7.px)
            
            self.dateField
            
            Div().class(.clear).marginBottom(12.px)
            
            Div{
                Div("Crear Publicacion")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.publicToSocial()
                    }
            }
            .align(.right)
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 250px)")
        .custom("top", "calc(50% - 200px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(500.px)
        
        
        Div{
            
            Div{
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Publicaciones")
                        .color(.lightBlueText)
                    
                }
                
                Div().class(.clear).marginBottom(7.px)
                
                self.resultsView
                
                
                Div{
                    Div("OK")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.callback()
                            self.remove()
                        }
                }
                .align(.center)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 250px)")
            .custom("top", "calc(50% - 200px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(500.px)
        }
        .class(.transparantBlackBackGround)
        .hidden(self.$resultViewIsHidden)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        self.class(.transparantBlackBackGround)
        self.zIndex(99999999)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
    
    
    func publicToSocial(){
        
        loadingView(show: true)
        
        var _link: String? = nil
        
        if !link.isEmpty {
            _link = link
        }
        
        if originalImage.isEmpty {
            if caption.isEmpty {
                showError(.requiredField, "Ingrese Texto de la publicación")
                return
            }
        }
        
        API.custAPIV1.publicToSocial(
            originalImage: originalImage,
            originalWidth: originalWidth,
            originalHeight: originalHeight,
            relativeWidth: relativeWidth,
            relativeHieght: relativeHeight,
            watermarks: watermarks,
            pages: pages,
            caption: caption,
            link: _link,
            uts: uts
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }

            guard let payload = resp.data else {
                showError(.unexpectedResult, "Error al obtener payload de data")
                return
            }
            
            if !payload.posts.isEmpty {
                
                self.resultsView.appendChild(H2("Operaciones Exitosas").color(.white))
                
                payload.posts.forEach { post in
                    
                    var mediaid = post.mediaid
                    
                    if mediaid.isEmpty {
                        mediaid = post.postid
                    }
                    
                    self.resultsView.appendChild(
                        Div("\(post.profileType.description) \(mediaid)")
                            .marginBottom(7.px)
                            .color(.gray)
                    )
                }
                
            }
            
            if !payload.errors.isEmpty {
                self.resultsView.appendChild(H2("Se han genrerado unos errores pero ya estan reportados y los investigaremos lo más pronto posible").color(.white))
            }
            
            self.resultViewIsHidden = false
            
        }
    }
}
