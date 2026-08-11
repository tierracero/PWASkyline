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
        .class(Class(TCTripBetaClass.uiControl))
        .width(100.percent)
        .height(44.px)
   
    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 560)) {
            VTitle("Seleccionar usuario", icon: "icon_user.png") {
                USmallTitle("Asignación")
                    .class(Class(TCMoneyManagerClass.badge))
            } onClose: {
                self.remove()
            }

            VBodyGrid {
                VGrid(.full) {
                    VBox(.raised) {
                        Div {
                            Div {
                                Img()
                                    .src("/skyline/media/usernameIconWhite.svg")
                                    .width(34.px)
                                    .height(34.px)
                            }
                            .display(.flex)
                            .custom("align-items", "center")
                            .custom("justify-content", "center")
                            .width(48.px)
                            .height(48.px)
                            .custom("border", "1px solid rgba(66, 183, 245, 0.3)")
                            .custom("border-radius", "12px")
                            .custom("background", "rgba(10, 55, 87, 0.58)")

                            Div {
                                USubTitle("Responsable")
                                UMinorTitle("Seleccione un usuario disponible para continuar.")
                                    .marginTop(4.px)
                                    .custom("line-height", "1.4")
                            }
                            .custom("min-width", "0")
                        }
                        .class(Class(TCMoneyManagerClass.userSummary))

                        UField("Usuario", required: true) {
                            self.userSelect
                        }
                        .marginTop(16.px)
                    }
                    .class(Class(TCMoneyManagerClass.formCard))
                }

                VGrid(.half) {
                    ULargeButton("Cancelar")
                        .width(100.percent)
                        .onClick {
                            self.remove()
                        }
                }

                VGrid(.half) {
                    ULargeButton("Seleccionar")
                        .width(100.percent)
                        .class(Class(TCMoneyManagerClass.primaryButton))
                        .onClick {
                            self.selectUser()
                        }
                }
            }
        }
        .class(Class(TCMoneyManagerClass.popup))
    }
    
    override func buildUI() {
        super.buildUI()

        TCMoneyManagerTheme.apply(to: self)
        
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
    
    

    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $userSelectListener.removeAllListeners()
    }
}

extension SelectCustUsernameView {
    
    enum LoadType {
        case store(UUID)
        case all
    }
    
}
