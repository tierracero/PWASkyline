//
//  Tools+SystemSettings+UserStoreConfiguration+UserView.swift
//
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class UserView: Div {
        
        override class var name: String { "div" }
        
        let store: CustStore
        
        let userCard: UserCard
        
        let data: CustAPIEndpointV1.GetUserResponse
        
        init(
            store: CustStore,
            userCard: UserCard,
            data: CustAPIEndpointV1.GetUserResponse
        ) {
            self.store = store
            self.userCard = userCard
            self.data = data
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var storeName = ""
        
        @State var groopName = "N/A"
        
        @State var supervisorName = "N/A"
        
        @State var userMid = ""
        
        /// UsernameRoles
        /// general, supervisor, manager, gmanager, owner
        @State var roleListener: String = UsernameRoles.general.rawValue
        
        @State var username: String = ""
        
        @State var password: String = ""
        
        @State var passwordConfirm: String = ""
        
        @State var pin: String = ""
        
        @State var pinConfirm: String = ""
        
        @State var title: String = ""
        
        @State var firstName: String = ""
        
        @State var secondName: String = ""
        
        @State var lastName: String = ""
        
        @State var secondLastName: String = ""
        
        /// Int?
        @State var birthDay: String = ""
        
        /// Int?
        @State var birthMonth: String = ""
        
        /// Int?
        @State var birthYear: String = ""
        
        @State var rfc: String = ""
        
        @State var curp: String = ""
        
        @State var nss: String = ""
        
        @State var telephone: String = ""
        
        @State var mobile: String = ""
        
        @State var email: String = ""
        
        @State var street: String = ""
        
        @State var colony: String = ""
        
        @State var city: String = ""
        
        @State var state: String = ""
        
        @State var country: String = ""
        
        @State var zip: String = ""
        
        @State var herk: String = ""
        
        ///socialLive, generalSiteAnalitics, config, comms, bizODS, bizPDV, bizMail, bizCal, billing, cajaChicaM, cajaChicaN, cajaChicaV, cajaGrandeM, cajaGrandeN, cajaGrandeV, confEtiquetas, configDieneroProvedores, configUserStores, configWeb, dataAnalitics, POCs, SOCs
        @State var linkedProfile: [PanelConfigurationObjects] = []
        
        /// Double
        @State var preformanceRankListener = "1"
        
        @State var nick: String = ""
        
        @State var colorCode: String = "#000000"
        
        /// Genders
        /// male, female
        @State var sexo: String = ""
        
        @State var meta: String = ""
        
        @State var corporateMailIsActive: Bool = false
        
        @State var corporateMailAliases: [String] = []
        
        /// CustProductionProfile
        /// order, rent, sale, admin
        @State var productionProfile: [CustProductionProfile] = []
        
        /// UsernameStatus: active, suspended, canceled
        @State var status: String = UsernameStatus.active.rawValue
        
        lazy var permitionView = Div()
        
        @State var permitionItems: [Div] = []
        
        @DOM override var body: DOM.Content {
            Div{
                
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2{
                        Span("Usuario:")
                            .color(.goldenRod)
                            .marginRight(7.px)
                        
                        Span(self.$userMid)
                            .marginRight(7.px)
                            .color(.white)
                        
                        Span(self.$username)
                            .marginRight(7.px)
                            .color(.white)
                    }
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    Div{
                        
                        Div{
                            Img()
                                .src("/skyline/media/default_panda.jpeg")
                                .height(100.percent)
                                .width(100.percent)
                        }
                        .backgroundColor(.grayBlackDark)
                        .borderRadius(24)
                        .height(286.px)
                        .width(286.px)
                        
                        Div().clear(.both).marginTop(7.px)
                        
                        Div {
                            Div{
                                Label("Grupo")
                                    .fontSize(18.px)
                                    .color(.gray)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                Label("Supervisor")
                                    .fontSize(18.px)
                                    .color(.gray)
                            }
                            .textAlign(.right)
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div {
                            Div(self.$groopName)
                                .width(50.percent)
                                .class(.oneLineText)
                                .float(.left)
                            
                            Div(self.$supervisorName)
                                .class(.oneLineText)
                                .width(50.percent)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).marginTop(7.px)
                        
                        Div {
                            Div{
                                Label("Color")
                                    .fontSize(18.px)
                                    .color(.gray)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                InputColor(self.$colorCode)
                                    .cursor(.pointer)
                                    .height(30.px)
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().clear(.both)
                        }
                        
                        Div().clear(.both).marginTop(7.px)
                        
                        Div{
                            Div{
                                Img()
                                    .src("/skyline/media/add.png")
                                    .padding(all: 3.px)
                                    .paddingRight(0.px)
                                    .cursor(.pointer)
                                    .height(28.px)
                                    .float(.right)
                                    .onClick {
                                        
                                    }
                                
                                H2("Permisos")
                            }
                            Div{
                                ForEach(self.$permitionItems) {
                                    $0
                                }
                                .margin(all: 3.px)
                            }
                            .class(.roundDarkBlue)
                            
                        }
                        
                    }
                    .margin(all: 7.px)
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
                .width(300.px)
                .float(.left)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(90.percent)
            .width(90.percent)
            .left(5.percent)
            .top(5.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            fontSize(20.px)
            color(.white)
            left(0.px)
            top(0.px)
            
            $colorCode.listen {
                print("new color")
                print($0)
            }
            
            storeName = store.name
            
            userMid = data.userData.MID
            
            /// UsernameRoles
            roleListener = data.userData.role.rawValue
            
            title = data.userData.title
            
            firstName = data.userData.firstName
            
            secondName = data.userData.secondName
            
            lastName = data.userData.lastName
            
            secondLastName = data.userData.secondLastName
            
            /// Int?
            birthDay = data.userData.birthDay?.toString ?? ""
            
            /// Int?
            birthMonth = data.userData.birthMonth?.toString ?? ""
            
            /// Int?
            birthYear = data.userData.birthYear?.toString ?? ""
            
            rfc = data.userData.rfc
            
            curp = data.userData.curp
            
            nss = data.userData.nss
            
            telephone = data.userData.telephone
            
            mobile = data.userData.mobile
            
            email = data.userData.email
            
            street = data.userData.street
            
            colony = data.userData.colony
            
            city = data.userData.city
            
            state = data.userData.state
            
            country = data.userData.country
            
            zip = data.userData.zip
            
            herk = data.userData.herk.toString
            
            ///socialLive, generalSiteAnalitics, config, comms, bizODS, bizPDV, bizMail, bizCal, billing, cajaChicaM, cajaChicaN, cajaChicaV, cajaGrandeM, cajaGrandeN, cajaGrandeV, confEtiquetas, configDieneroProvedores, configUserStores, configWeb, dataAnalitics, POCs, SOCs
            linkedProfile = data.userData.linkedProfile
            
            /// Double
            preformanceRankListener = data.userData.preformanceRank.toString
            
            nick = data.userData.nick
            
            /// Genders
            /// male, female
            sexo = data.userData.sexo?.rawValue ?? ""
            
            meta = data.userData.meta
            
            corporateMailIsActive = data.userData.corporateMailIsActive
            
            corporateMailAliases = data.userData.corporateMailAliases
            
            /// CustProductionProfile
            /// order, rent, sale, admin
            productionProfile = data.userData.productionProfile
            
            /// UsernameStatus: active, suspended, canceled
            status = data.userData.status.rawValue
            
            if let color = data.userData.colorCode {
                colorCode = "#\(color)"
            }
            
            if let uname = data.userData.username.explode("@").first {
                username = "@\(uname)"
            }
            else {
                username = data.userData.username
            }
            
            getUserRefrence(id: .id(data.userData.supervisor)) { user in
                if let uname = user?.username.explode("@").first {
                    self.supervisorName = "@\(uname)"
                }
                else {
                    self.supervisorName = user?.username ?? "N/D"
                }
            }
            
            API.custAPIV1.getGroups(
                storeId: self.store.id
            ) { resp in
                
                guard let resp else {
                    return
                }
                
                resp.data?.forEach { group in
                    if self.data.userData.workGroop == group.id {
                        self.groopName = group.meta2
                    }
                }
            }
            
            API.custAPIV1.prepareUserPermition { resp in
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                //var cats: [PanelConfigurationCatagoryItem] = []
                
                /// [ PanelConfigurationCatagory.id : [ PanelConfigurationSubCatagory ] ]
                var subCats: [ UUID : [PanelConfigurationSubCatagoryItem] ] = [:]
                
                var atributes: [ UUID : [PanelConfigurationAtributeItem] ] = [:]
                
                //var catsRefrence: [ UUID : PanelConfigurationCatagoryItem ] = Dictionary(uniqueKeysWithValues: payload.cats.map{ ($0.id, $0) })
                
                //var subCatsRefrence: [UUID:PanelConfigurationSubCatagoryItem] = Dictionary(uniqueKeysWithValues: payload.subCats.map{ ($0.id, $0) })
                
                //var atributesRefrence: [UUID:PanelConfigurationAtributeItem] = Dictionary(uniqueKeysWithValues: payload.atributes.map{ ($0.id, $0) })
                
                payload.subCats.forEach { cat in
                 
                    if let _ = subCats[cat.panelConfigurationCatagory] {
                        subCats[cat.panelConfigurationCatagory]?.append(cat)
                    }
                    else {
                        subCats[cat.panelConfigurationCatagory] = [cat]
                    }
                    
                }
                
                payload.atributes.forEach { attriute in
                 
                    if let _ = subCats[attriute.panelConfigurationSubCatagory] {
                        atributes[attriute.panelConfigurationSubCatagory]?.append(attriute)
                    }
                    else {
                        atributes[attriute.panelConfigurationSubCatagory] = [attriute]
                    }
                    
                }
                
                payload.cats.forEach { cat in
                    
                    if !self.linkedProfile.contains(cat.code) {
                        return
                    }
                    
                    let catInnerDom = Div()
                    
                    let catDom = Div{
                        Div{
                            Div(cat.name)
                                .custom("width", "calc(100% - 18px)")
                                .class(.oneLineText)
                                .float(.left)
                            Div{
                                Img()
                                    .src("https://tierracero.com/dev/core/images/icon/color_18/gear.png")
                                    .marginTop(3.px)
                                    .height(24.px)
                                    .width(24.px)
                            }
                            .width(18.px)
                            .float(.left)
                        }
                        
                        catInnerDom
                    }
                        .custom("width", "calc(100% - 18px)")
                        .class(.uibtnLarge)
                        
                    
                    if let _subCat = subCats[cat.id] {
                        
                        _subCat.forEach { subCat in
                            
                            if !self.linkedProfile.contains(subCat.code) {
                                return
                            }
                            
                            let subCatInnerDom = Div()
                            
                            let subCatDom = Div{
                                Div{
                                    
                                    Div(subCat.name)
                                        .custom("width", "calc(100% - 22px)")
                                        .class(.oneLineText)
                                        .float(.left)
                                    
                                    Div{
                                        Img()
                                            .src("https://tierracero.com/dev/core/images/icon/color_18/gear.png")
                                            .marginTop(3.px)
                                            .height(24.px)
                                            .width(24.px)
                                    }
                                    .width(18.px)
                                    .float(.left)
                                    
                                }
                                
                                subCatInnerDom
                            }
                                .backgroundColor(r: 47, g: 47, b: 47, a: 1)
                                .custom("width", "calc(100% - 18px)")
                                .class(.uibtnLarge)
                                
                            
                            
                            if let _atributes = atributes[cat.id] {
                                _atributes.forEach { atribute in
                                    
                                }
                            }
                            
                            catInnerDom.appendChild(subCatDom)
                            
                        }
                    }
                    
                    self.permitionItems.append(catDom)
                    
                }
            }
        }
    }
}
