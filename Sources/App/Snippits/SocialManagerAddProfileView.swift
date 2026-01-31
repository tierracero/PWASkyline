//
//  SocialManagerAddProfileView.swift
//  
//
//  Created by Victor Cantu on 10/11/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SocialManagerAddProfileView: Div {
    
    let ws = WS()
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ page: CustSocialPageQuick
    ) -> ())
    
    init(
        type: SocialProfileType? = nil,
        callback: @escaping ((
            _ page: CustSocialPageQuick
        ) -> ())
    ) {
        self.type = type
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var socialIconsGrid = Td()
        .verticalAlign(.middle)
        .align(.center)
    
    lazy var secondView = Div()
    
    lazy var iframe = IFrame()
    
    /// siwe, facebook, instagram, youtube, tiktok, pintrest, twitter, snapchat, googleplus
    @State var type: SocialProfileType? = nil
    
    /// List of pages, of all social networks.
    /// ``The only purpuse of this listener is to hide close buttun till a solcial page profile is loaded``
    @State var pages: [CustSocialPageQuick] = []
    
    //var token: String? = nil
    
    var userid: String? = nil
    
    var tokenExpiresIn: Int64? = nil
    
    var ytPageToken: String? = nil
    var ytPageId: String? = nil
    var ytManageToken: String? = nil
    var ytUploadToken: String? = nil
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// First View Header
            Div{
                Img()
                    .closeButton(.view)
                    .hidden(self.$pages.map {$0.isEmpty})
                    .onClick{
                        self.remove()
                    }
                
                H2("Agregar Redes Sociales")
                    .color(.lightBlueText)
            }
            .hidden(self.$type.map{ $0 != nil})
            
            Div{
                Table{
                    Tr{
                        self.socialIconsGrid
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .custom("height", "calc(100% - 30px)")
            .hidden(self.$type.map{ ($0 != nil) && [SocialProfileType.mercadoLibre].contains($0) })
            .overflow(.auto)
            
            /// Second View Header
            Div {
                Img()
                    .src("/skyline/media/backDarkOrange.png")
                    .hidden(self.$type.map{ [SocialProfileType.mercadoLibre].contains($0) })
                    .marginRight(7.px)
                    .cursor(.pointer)
                    .height(24.px)
                    .float(.left)
                    .onClick {
                        self.type = nil
                    }
                
                H2( self.$type.map{ ($0?.description ?? "Seleccione Sociales") })
                    .color(.darkOrange)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            .hidden( self.$type.map{ $0 == nil} )
            .overflow(.auto)
            
            self.secondView
            .custom("height", "calc(100% - 30px)")
            .hidden( self.$type.map{ $0 == nil} )
            .overflow(.auto)
            
        }
        .custom("left", "calc(50% - 200px)")
        .custom("top", "calc(50% - 175px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(350.px)
        .width(400.px)
        
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
            
            guard let event else {
                return
            }
            
            if event == .NotifyAddFacebookProfile {
                
                print("⚡️ WS addFacebookProfile managen by social view")
                if let profile = self.ws.notifyAddFacebookProfile($0) {
                    
                    socialProfiles.append(profile)
                    
                    self.iframe.remove()
                    
                    //self.token = profile.token
                    self.userid = profile.vendorid
                    self.tokenExpiresIn = profile.expireAt
                    
                    self.fbPageList()
                    
                }
                else {
                    
                }
                
                WebApp.current.wsevent.wrappedValue = ""
            }
            else if event == .NotifyAddYoutubeProfile {
                
                if let profile = self.ws.notifyAddYoutubeProfile($0) {
                    
                    socialProfiles.append(profile)
                    
                    self.iframe.remove()
                    
                    //self.token = profile.token
                    self.userid = profile.vendorid
                    self.tokenExpiresIn = profile.expireAt
                    
                    self.ytPageList()
                    
                }
                else {
                    
                }
                
                WebApp.current.wsevent.wrappedValue = ""
                
            }
            else if event == .NotifyAddMercadoLibreProfile {
                
                if let profile = self.ws.notifyAddMercadoLibreProfile($0) {
                    MercadoLibreControler.shared.profile = profile
                    self.remove()
                }
                else {
                    
                }
            }
            
        }
        
        var cc = 0
        
        $type.listen { profile in
            if let profile {
                self.parseSelectedSocialProfile(profile: profile)
            }
            
        }
        
        SocialProfileType.allCases.forEach { prof in
            
            if prof.isActive {
                self.socialIconsGrid.appendChild(
                    
                    Img()
                        .src("/skyline/media/scicon_\(prof.rawValue).jpg")
                        .borderRadius(all: 20.percent)
                        .padding(all: 3.px)
                        .overflow(.hidden)
                        .cursor(.pointer)
                        .height(70.px)
                        .onClick {
                            self.type = prof
                        }
                )
            }
            
            if cc == 3 {
                self.socialIconsGrid.appendChild(Br())
                cc = 0
                return
            }
            
            cc += 1
            
        }
        
        if let type{
            self.parseSelectedSocialProfile(profile: type)
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        pages = socialPages
    }
    
    override func didRemoveFromDOM() {
        
        super.didRemoveFromDOM()
        
        print("🟠 didRemoveFromDOM  🟠")
        
        $pages.removeAllListeners()
        
    }
    
    func parseSelectedSocialProfile(profile: SocialProfileType){
        switch profile{
        case .siwe:
            break
        case .facebook, .instagram:
            
            if profile == .instagram {
                addToDom(ConfirmView(
                    type: .ok,
                    title: "Configuracion de Instagram ",
                    message: "Recuerda debes de:\n1) Configurar tu insta como empresa\n2) Conecar tu insta a la pagina de face deseada",
                    callback: { isConfirmed, comment in
                    }
                ))
            }
            
            print("🟦 will try fb")
            /// Load facebook profiles `resp: [CustSocialProfileQuick]`
            API.custAPIV1.getSocialProfiles(profileType: .facebook) { resp in
                
                /// NOTE: `for the moment it will only load one profiel but has preperation for  more that one profile`
                if let profile = resp.first {
                    
                    /// Load pages of profile
                    if let expireAt = profile.expireAt {
                        if expireAt < getNow() {
                            self.fbLogin()
                            return
                        }
                    }
                    
                    self.userid = profile.vendorid
//                        self.tokenExpiresIn = profile.expireAt
                    self.fbPageList()
                    
                }
                else{
                    self.fbLogin()
                }
                
            }
            
        case .youtube:
            self.ytProcess()
        case .tiktok:
            break
        case .pintrest:
            break
        case .twitter:
            break
        case .snapchat:
            break
        case .googleplus:
            break
        case .telegram:
            break
        case .whatsapp:
            break
        case .mercadoLibre:
            self.mlProcess()
        case .ebay:
            break
        case .amazon:
            break
        case .general:
            break
        }
    }
    
    func fbLogin() {
        
        var sessionToken: String? = nil
        
        var loginToken : String? = nil
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web, 
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8){
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    sessionToken = base64Encoded
                }
            }
        }
        
        guard let sessionToken = sessionToken else{
            showError(.generalError, "No se puede generar autorizacion. 001")
            return
        }
        
        do {
            loginToken = try JSONEncoder().encode(LoginToken(
                connid: custCatchChatConnID,
                token: sessionToken
            )).base64EncodedString()
            
        }
        catch {
            showError(.generalError, "Error al generar token de acceso")
            self.remove()
            return
        }

        guard var loginToken = loginToken else{
            showError(.generalError, "No se puede generar autorizacion. 001")
            return
        }
        
        loginToken = (loginToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        loadingView(show: true)
        
        self.iframe = IFrame()
            .src(
                "https://tierracero.com/socialconn" +
                "?token=\(loginToken)" +
                "&profileType=\(SocialProfileType.facebook.rawValue)"
                
            )
            .border(width: .none, style: .hidden, color: .none)
            .custom("background-image", "url('images/conntotierracero.png')")
            .custom("background-repeat", "no-repete")
            .custom("background-attachment", "fixed")
            .custom("background-position", "50% 50%")
            .custom("background-repeat", "no-repeat")
            .borderRadius(all: 24.px)
            .height(100.percent)
            .width(100.percent)
            .onLoad {
                Dispatch.asyncAfter(2.0) {
                    loadingView(show: false)
                }
            }

        self.secondView.innerHTML = ""
        self.secondView.appendChild(self.iframe)
        self.secondView.overflow(.hidden)
        
    }
    
    func fbPageList() {
        
        loadingView(show: true)
        
        API.custAPIV1.getFacebookPages  { pages in
         
            loadingView(show: false)
            
            self.secondView.innerHTML = ""

            self.secondView.overflow(.auto)
            
            pages.forEach { page in
                
                self.secondView.appendChild(
                    
                    Div{
                        Img()
                            .load("https://graph.facebook.com/\(page.id)/picture?type=square")
                            .src("skyline/media/tierraceroRoundLogoWhite.svg")
                            .borderRadius(all: 20.percent)
                            .height(50.px)
                            .float(.left)
                        
                        Div(page.name)
                            .custom("width", "calc(100% - 60px)")
                            .class(.oneLineText)
                            .marginLeft(7.px)
                            .fontSize(36.px)
                            .color(.white)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                        .custom("width", "calc(100% - 18px)")
                        .marginBottom(12.px)
                        .class(.uibtnLarge)
                        .onClick {
                            
                            print("⭐️ type  \(self.type?.rawValue ?? "N/A")")
                            
                            if(self.type == .facebook){
                                
                                print("⭐️ will try to add facebook page")
                                
                                self.addPageProfile(
                                    type: .facebook,
                                    name: page.name,
                                    pageid: page.id,
                                    token: page.access_token,
                                    username: page.username ?? "",
                                    avatar: "https://graph.facebook.com/\(page.id)/picture?type=square"
                                )
                            }
                            else if ( self.type == .instagram ) {
                                
                                print("⭐️ will try to add ig page")
                                
                                self.igPageList(name: page.name, fbpageid: page.id)
                            }
                        }
                )
            }
        }
    }
    
    func igPageList(name: String, fbpageid: String) {
        
        loadingView(show: true)
        
        API.custAPIV1.getInstagramPages(fbpageid: fbpageid) { payload in

            guard let payload else {
                showError(.comunicationError, .serverConextionError)
                loadingView(show: false)
                return
            }
            
            guard payload.status == .ok else {
                showError(.comunicationError, payload.msg)
                return
            }
            
            guard let igpageid = payload.data?.request else {
                 addToDom(ConfirmView(
                     type: .ok,
                     title: "\(name) sin perfiles IG Activos",
                     message: "⚠️\(name) sin perfiles IG Activos⚠️\nRecuerda debes de:\n1) Configurar tu insta como empresa\n2) Conecar tu insta a la pagina de face deseada",
                     callback: { isConfirmed, comment in
                         
                     }))
                loadingView(show: false)
                 return
            }
            
            API.custAPIV1.getInstagramPageData(
                fbpageid: fbpageid,
                igpageid: igpageid
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    return
                }
                
                guard resp.status == .ok else {
                    return
                }
                
                guard let page = resp.data else {
                    return
                }
                
                let name = page.name ?? ""
                
                let username = page.username ?? ""
                
                let avatar = page.profile_picture_url ?? ""
                
                self.secondView.innerHTML = ""
                
                self.secondView.overflow(.auto)
                
                self.secondView.appendChild(
                    
                    Div{
                        Img()
                            .src("skyline/media/tierraceroRoundLogoWhite.svg")
                            .borderRadius(all: 20.percent)
                            .height(50.px)
                            .float(.left)
                            .load(avatar)
                        
                        Div(name)
                            .custom("width", "calc(100% - 60px)")
                            .class(.oneLineText)
                            .marginLeft(7.px)
                            .fontSize(36.px)
                            .color(.white)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                        .custom("width", "calc(100% - 18px)")
                        .marginBottom(12.px)
                        .class(.uibtnLarge)
                        .onClick {
                            
                            self.addPageProfile(
                                type: .instagram,
                                name: name,
                                pageid: page.id,
                                token: fbpageid,
                                username: username,
                                avatar: avatar
                            )
                        }
                )
            }
            
            /*
            pages.forEach { page in
                
                let avatar = page.profile_pic ?? ""
                let username = page.username ?? ""
                
                self.secondView.innerHTML = ""
                
                self.secondView.overflow(.auto)
                
                self.secondView.appendChild(
                    
                    Div{
                        Img()
                            .load(avatar)
                            .src("skyline/media/tierraceroRoundLogoWhite.svg")
                            .borderRadius(all: 20.percent)
                            .height(50.px)
                            .float(.left)
                        
                        Div(username)
                            .custom("width", "calc(100% - 60px)")
                            .class(.oneLineText)
                            .marginLeft(7.px)
                            .fontSize(36.px)
                            .color(.white)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                        .custom("width", "calc(100% - 18px)")
                        .marginBottom(12.px)
                        .class(.uibtnLarge)
                        .onClick {
                            
                            self.addPageProfile(
                                type: .instagram,
                                name: username,
                                pageid: page.id,
                                token: pageid,
                                username: username,
                                avatar: avatar
                            )
                        }
                )
            }
            */
            /*
            igGetPageData(token: token, igid: igid) { payload in
                
                if let error = payload.error {
                    showError(.generalError, "Segenero un error, refresque e intente de nuevo")
                    return
                }
                
                let name = payload.name ?? ""
                let avatar = payload.profile_picture_url ?? ""
                let username = payload.username ?? ""
                
                self.secondView.innerHTML = ""
                
                self.secondView.overflow(.auto)
                
                self.secondView.appendChild(
                    
                    Div{
                        Img()
                            .load(avatar)
                            .src("skyline/media/tierraceroRoundLogoWhite.svg")
                            .borderRadius(all: 20.percent)
                            .height(50.px)
                            .float(.left)
                        
                        Div(name)
                            .custom("width", "calc(100% - 60px)")
                            .class(.oneLineText)
                            .marginLeft(7.px)
                            .fontSize(36.px)
                            .color(.white)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                        .custom("width", "calc(100% - 18px)")
                        .marginBottom(12.px)
                        .class(.uibtnLarge)
                        .onClick {
                            
                            self.addPageProfile(
                                type: .instagram,
                                name: name,
                                pageid: igid,
                                token: pageid,
                                username: username,
                                avatar: avatar
                            )
                        }
                )
            }
*/
           /*
           pages.forEach { page in
               
               self.secondView.appendChild(
                   
                   Div{
                       Img()
                           .load("https://graph.facebook.com/\(page.id)/picture?type=square")
                           .src("skyline/media/tierraceroRoundLogoWhite.svg")
                           .borderRadius(all: 20.percent)
                           .height(50.px)
                           .float(.left)
                       
                       Div(page.name)
                           .custom("width", "calc(100% - 60px)")
                           .class(.oneLineText)
                           .marginLeft(7.px)
                           .fontSize(36.px)
                           .color(.white)
                           .float(.left)
                       
                       Div().class(.clear)
                       
                   }
                   .custom("width", "calc(100% - 18px)")
                   .marginBottom(12.px)
                   .class(.uibtnLarge)
                   .onClick {
                       
                       self.addPageProfile(
                           type: .instagram,
                           name: page.name,
                           pageid: page.id,
                           token: page.access_token,
                           username: page.username ?? ""
                       )
                       
                   }
               )
           }
            */
        }
    }
    
    func ytProcess() {
        
        /*
         1) cheke if its active
         2) if not promote to connect
         */
        
        API.custAPIV1.youtubeIsActive { resp in
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            print(resp)
            
            if resp.status == .ok {
                self.ytPageList()
                return
            }
            
            var sessionToken: String? = nil
            
            var loginToken : String? = nil
            
            if let jsonData = try? JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                url: custCatchUrl,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web, 
                applicationType: .customer
            )){
                if let str = String(data: jsonData, encoding: .utf8){
                    let utf8str = str.data(using: .utf8)
                    if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                        sessionToken = base64Encoded
                    }
                }
            }
            
            guard let sessionToken = sessionToken else{
                showError(.generalError, "No se puede generar autorizacion. 001")
                return
            }
            
            do {
                loginToken = try JSONEncoder().encode(LoginToken(
                    connid: custCatchChatConnID,
                    token: sessionToken
                )).base64EncodedString()
                
            }
            catch {
                showError(.generalError, "Error al generar token de acceso")
                self.remove()
                return
            }

            guard var loginToken = loginToken else{
                showError(.generalError, "No se puede generar autorizacion. 001")
                return
            }
            
            loginToken = (loginToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                .replace(from: "/", to: "%2f")
                .replace(from: "+", to: "%2b")
                .replace(from: "=", to: "%3d")
            
            let oauth2Endpoint = "https://accounts.google.com/o/oauth2/v2/auth"
            let redirect_uri = "https://tierracero.com/youtubeconn"
            let prompt = "consent"
            let response_type = "code"
            let client_id = "431508787955-7d9qhpn3ngk36o0l9rnqbvpelmcpot75.apps.googleusercontent.com"
            let scope = "https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.channel-memberships.creator+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.force-ssl+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.upload"
            let access_type = "offline"
            
            let ytAuthUrl = "\(oauth2Endpoint)?" +
            "redirect_uri=\(redirect_uri)&" +
            "prompt=\(prompt)&" +
            "response_type=\(response_type)&" +
            "client_id=\(client_id)&" +
            "scope=\(scope)&" +
            "access_type=\(access_type)"
            
            print("⭐️  ytAuthUrl  ⭐️")
            print(ytAuthUrl)
            print("⭐️  ytAuthUrl.uriEncode  ⭐️")
            print(ytAuthUrl.uriEncode)
            
            loadingView(show: true)
            
            
            /// DELETEME
            let isRequesting = "&isRequesting=" + SocialYoutubeStates.ytPageToken.rawValue
            
            self.iframe = IFrame()
                .src(
                    "https://tierracero.com/socialconn" +
                    "?token=\(loginToken)" +
                    "&profileType=\(SocialProfileType.youtube.rawValue)" +
                    "&ytAuthUrl=\(ytAuthUrl.uriEncode)" +
                    isRequesting
                )
                .border(width: .none, style: .hidden, color: .none)
                .custom("background-image", "url('images/conntotierracero.png')")
                .custom("background-repeat", "no-repete")
                .custom("background-attachment", "fixed")
                .custom("background-position", "50% 50%")
                .custom("background-repeat", "no-repeat")
                .borderRadius(all: 24.px)
                .height(100.percent)
                .width(100.percent)
                .onLoad {
                    Dispatch.asyncAfter(2.0) {
                        loadingView(show: false)
                    }
                }
            
            self.secondView.innerHTML = ""
            
            self.secondView.appendChild(self.iframe)
            
            self.secondView.overflow(.auto)
            
        }
    }
    
    func ytPageList() {
        
        loadingView(show: true)
        
        API.custAPIV1.getYoutubeChannels { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let channels = resp.data?.channels else {
                showError(.unexpectedResult, "No se obtuvo caneles de manera inesperada")
                return
            }
            
            self.secondView.innerHTML = ""
            
            channels.forEach { channel in
                
                let name = "\(channel.username) \(channel.title)"
                
                let view = Div {
                    Img()
                        .load(channel.avatar)
                        .src("skyline/media/tierraceroRoundLogoWhite.svg")
                        .borderRadius(all: 20.percent)
                        .height(50.px)
                        .float(.left)
                    
                    Div(name)
                        .custom("width", "calc(100% - 60px)")
                        .class(.oneLineText)
                        .marginLeft(7.px)
                        .fontSize(36.px)
                        .color(.white)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                    .custom("width", "calc(100% - 18px)")
                    .marginBottom(12.px)
                    .class(.uibtnLarge)
                    .onClick {
                        
                        print("add youtube")
                        
                        self.addPageProfile(
                            type: .youtube,
                            name: channel.title,
                            pageid: channel.id,
                            token: "",
                            username: channel.username,
                            avatar: channel.avatar
                        )
                        
                    }
                
                self.secondView.appendChild(view)
            }
            
            self.secondView.overflow(.auto)
            
        }
        
    }
    
    func addPageProfile (
        type: SocialProfileType,
        name: String,
        pageid: String,
        token: String,
        username: String,
        avatar: String
    ){
        
        guard let userid = userid else {
            print("No user id found")
            return
        }
        
        print("⭐️ adding \(type.rawValue)")
        
        switch type {
        case .siwe:
            break
        case .facebook:
            
            loadingView(show: true)
            
            API.custAPIV1.addFacebookPage(
                userid: userid,
                name: name,
                pageid: pageid,
                token: token,
                username: username,
                avatar: avatar
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let page = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo datos de la pagina, intente de nuevo.")
                    return
                }

                socialPages.append(page)
                
                self.callback(page)
                
                self.remove()
                
            }
            
        case .instagram:
            
            loadingView(show: true)
            
            API.custAPIV1.addInstagramPage(
                userid: userid,
                name: name,
                pageid: pageid,
                token: token,
                username: username,
                avatar: avatar
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let page = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo datos de la pagina, intente de nuevo.")
                    return
                }

                socialPages.append(page)
                
                self.callback(page)
                
                self.remove()
                
            }
            
        case .youtube:
            
            loadingView(show: true)
            
            API.custAPIV1.addYoutubePage(
                name: name,
                pageid: pageid,
                username: username,
                avatar: avatar
            )  { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let page = resp.data else {
                    showError(.unexpectedResult, "No se obtuvo datos de la pagina, intente de nuevo.")
                    return
                }

                socialPages.append(page)
                
                self.callback(page)
                
                self.remove()
                
            }
            
        case .tiktok:
            break
        case .pintrest:
            break
        case .twitter:
            break
        case .snapchat:
            break
        case .googleplus:
            break
            
        case .telegram:
            break
        case .whatsapp:
            break
        case .mercadoLibre:
            break
        case .ebay:
            break
        case .amazon:
            break
            
        case .general:
            break
        }
        
        
    }
    
    func mlProcess() {
        
        var sessionToken: String? = nil
        
        var loginToken : String? = nil
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web, 
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8){
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    sessionToken = base64Encoded
                }
            }
        }
        
        guard let sessionToken = sessionToken else{
            showError(.generalError, "No se puede generar autorizacion. 001")
            return
        }
        
        do {
            loginToken = try JSONEncoder().encode(LoginToken(
                connid: custCatchChatConnID,
                token: sessionToken
            )).base64EncodedString()
            
        }
        catch {
            showError(.generalError, "Error al generar token de acceso")
            self.remove()
            return
        }

        guard var loginToken else{
            showError(.generalError, "No se puede generar autorizacion. 001")
            return
        }
        
        loginToken = (loginToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .replace(from: "/", to: "%2f")
            .replace(from: "+", to: "%2b")
            .replace(from: "=", to: "%3d")
        
        loadingView(show: true)
        
        self.iframe = IFrame()
            .src(
                "https://tierracero.com/socialconn" +
                "?token=\(loginToken)" +
                "&profileType=\(SocialProfileType.mercadoLibre.rawValue)"
            )
            .border(width: .none, style: .hidden, color: .none)
            .custom("background-image", "url('images/conntotierracero.png')")
            .custom("background-repeat", "no-repete")
            .custom("background-attachment", "fixed")
            .custom("background-position", "50% 50%")
            .custom("background-repeat", "no-repeat")
            .borderRadius(all: 24.px)
            .height(100.percent)
            .width(100.percent)
            .onLoad {
                Dispatch.asyncAfter(2.0) {
                    loadingView(show: false)
                }
            }
        
        self.secondView.innerHTML = ""
        
        self.secondView.appendChild(self.iframe)
        
        self.secondView.overflow(.auto)
        
    }
    
}
