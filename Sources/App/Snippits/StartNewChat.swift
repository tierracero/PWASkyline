//
//  StartNewChat.swift
//  
//
//  Created by Victor Cantu on 8/8/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StartNewChat: Div {
    override class var name: String { "div" }
    
    var currentChatIds: [UUID]
    private var callback: ((_ id: CustChatRoomProfile) -> ())
    
    init(
        currentChatIds: [UUID],
        callback: @escaping ((_ id: CustChatRoomProfile) -> ())
    ) {
        self.currentChatIds = currentChatIds
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var newUserDiv = Div()
    .custom("height", "calc(100% - 35px)")
    .overflow(.auto)
    .padding(all: 3.px)
    .margin(all: 3.px)
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.view)
                .onClick{
                    self.remove()
                }
            
            H2("Iniciar Nuevo Chat")
                .color(.lightBlueText)
            
            Div().class(.clear)
            
            self.newUserDiv
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(35% - 12px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(60.percent)
        .width(30.percent)
        .top(20.percent)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        userCathByUUID.forEach { id, user in
            
            if id == custCatchID {
                return
            }
            
            if currentChatIds.contains(id) {
                return
            }
            
            var avatar = "skyline/media/default_panda.jpeg"
            
            if !user.avatar.isEmpty {
                avatar = "contenido/thump_\(user.avatar)"
            }
            
            let userView = Div{
                Div{
                    Img()
                        .src("skyline/media/default_panda.jpeg")
                        .borderRadius(all: 12.px)
                        .load(avatar)
                        .width(44.px)
                }
                .align(.center)
                .float(.left)
                .padding(all: 3.px)
                .width(50.px)
                
                Div{
                    Div(user.username)
                        .class(.oneLineText)
                        .color(.lightGray)
                        .align(.right)
                    
                    Div("\(user.firstName) \(user.lastName)")
                        .class(.oneLineText)
                        .fontSize(24.px)
                        .color(.white)
                        
                }
                .float(.left)
                .padding(all: 3.px)
                .custom("width", "calc(100% - 70px)")
                
                Div().class(.clear)
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 12.px)
            .cursor(.pointer)
            .marginBottom(7.px)
            .onClick {
                self.createNewChatRoom(id: id)
            }
            
            self.newUserDiv.appendChild(userView)
            
        }
    }
    
    func createNewChatRoom(id: UUID){
        
        loadingView(show: true)
        
        API.wsV1.createCustChatRoom(id: id) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }

            guard resp.status == .ok else {
                showError(.comunicationError, resp.msg)
                return
            }
            
             guard let data = resp.data else {
                 showError(.generalError, .unexpenctedMissingPayload)
                 return
             }
             
            guard let room = data.room else {
                showError(.unexpectedResult, "No se obtuvo chat, contacta a Soporte TC")
                return
            }
            
            self.callback(room)
            
            self.remove()
            
        }
    }
}
