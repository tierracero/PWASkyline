//
//  SelectCustUsername.swift
//  
//
//  Created by Victor Cantu on 4/26/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SelectCustUsernameView: Div {
    
    override class var name: String { "div" }
    
    var type: LoadType
    
    var ignore: [UUID]
    
    private var callback: ((
        _ user: CustUsername
    ) -> ())
    
    init(
        type: LoadType,
        ignore: [UUID],
        callback: @escaping ((
            _  user: CustUsername
        ) -> ())
    ) {
        self.type = type
        self.ignore = ignore
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var userSelectListener = ""
    
    lazy var userSelect = Select($userSelectListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(32.px)
        .height(48.px)
   
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Seleccione Usuario")
                    .color(.lightBlueText)
                    .height(35.px)
                
            }
            
            Div{
                
                Span("Seleccione se la siguiente lista")
                    .color(.gray)
                
                Div()
                    .marginBottom(7.px)
                    .class(.clear)
                
                self.userSelect
                
                Div()
                    .marginBottom(7.px)
                    .class(.clear)
                
                Div{
                    Div("Seleccionar")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            
                            self.selectUser()
                            
                        }
                }
                .align(.right)
                
            }
            .position(.relative)
            .overflow(.hidden)
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 274px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
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
        
        var storeid: UUID? = nil
        
        switch type {
        case .store(let id):
            storeid = id
        case .all:
            break
        }
        
        print("⭐️ type ⭐️")
        
        print(type)
        
        getUsers(storeid: storeid, onlyActive: true) { users in
            
            var ids: [UUID] = []
            
            print("⭐️ users")
            
            print(users)
            
            users.forEach { user in
                
                if self.ignore.contains(user.id){
                    return
                }
                
                ids.append(user.id)
                
                self.userSelect.appendChild(
                    Option(user.username)
                        .value(user.id.uuidString.lowercased())
                )
            }
            
            if ids.contains(custCatchID) {
                self.userSelectListener = custCatchID.uuidString.lowercased()
                
            }
            else {
                
                if let id = users.first?.id.uuidString.lowercased() {
                    self.userSelectListener = id
                }
                
            }
            
        }
        
    }
    
    func selectUser() {
     
        let idString = userSelect.value
        
        if idString.isEmpty {
            print("❌ 001")
            return
        }
        
        guard let id = UUID(uuidString: idString) else {
            print("❌ 002")
            return
        }

        getUserRefrence(id: .id(id)) { user in
            guard let user else {
                print("❌ 003")
                return
            }
            
            self.callback(user)
            self.remove()
        }
    }
    
    
}

extension SelectCustUsernameView {
    
    enum LoadType {
        case store(UUID)
        case all
    }
    
}

