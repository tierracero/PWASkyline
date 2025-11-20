//
//  LoginViewcontroler.swift
//  
//
//  Created by Victor Cantu on 3/18/22.
//

import Foundation
import TCFundamentals
import JavaScriptKit
import LanguagePack
import Web

public class LoginViewcontroler: PageController {
	
	@State var hello = "Hola!"
	
	@State var fontIsLoaded = false
    
	@State var cssIsLoaded = false
	
    @State var username: String = ""
    
    @State var password: String = ""
    
    @State var mobile: String = ""
    
    @State var viewPassword: Bool = false
    
    @State var mobileConfirmationText = "..."
    
    var passwordRecoveryToken = ""
    
    enum PasswordRecoveryMode: String {
        case confirmUsername
        case confirmMobile
    }
    
    ///confirmUsername , confirmMobile∫
    @State var passwordRecoveryMode: PasswordRecoveryMode? = nil
    
    lazy var usernameField = InputEmail(self.$username)
		.width(90.percent)
		.autocomplete(.off)
		.marginBottom(24.px)
        .class(.darkTextField)
        .placeholder(LString(String.enterUsername))
		.leftImage(img: "/skyline/media/usernameIconWhite.svg")
		
    lazy var usernameRevoveryField = InputEmail(self.$username)
        .width(90.percent)
        .autocomplete(.off)
        .marginBottom(24.px)
        .class(.darkTextField)
        .placeholder(LString(String.enterUsername))
        .leftImage(img: "/skyline/media/usernameIconWhite.svg")
    
    lazy var mobileRevoveryField = InputTel(self.$mobile)
        .width(90.percent)
        .autocomplete(.off)
        .marginBottom(24.px)
        .class(.darkTextField)
        .placeholder(LString(String.enterUsername))
        .leftImage(img: "/skyline/media/icon_mobile_white.png")
    
    lazy var passwordTextField = InputText(self.$password)
        .width(100.percent)
        .autocomplete(.off)
        .class(.darkTextField)
        .placeholder(LString(String.enterPassword))
        .leftImage(img: "/skyline/media/passwordIconWhite.svg")
    
    lazy var passwordField = InputPassword(self.$password)
		.width(100.percent)
		.autocomplete(.off)
		.class(.darkTextField)
        .placeholder(LString(String.enterPassword))
		.leftImage(img: "/skyline/media/passwordIconWhite.svg")
	
	lazy var box1 = Div()
		.class(.heroFigureBox, .heroFigureBox01)
		.custom("data-rotation", "45deg")
		.opacity(0)
	
	lazy var box2 = Div()
		.class(.heroFigureBox, .heroFigureBox02)
		.custom("data-rotation", "-45deg")
		.opacity(0)
	
	lazy var box3 = Div()
		.class(.heroFigureBox, .heroFigureBox03)
		.custom("data-rotation", "0deg")
		.opacity(0)
	
	lazy var box4 = Div()
		.class(.heroFigureBox, .heroFigureBox04)
		.custom("data-rotation", "-135deg")
		.opacity(0)
	
	lazy var box5 = Div()
		.class(.heroFigureBox, .heroFigureBox05)
		.opacity(0)
	
	lazy var box6 = Div()
		.class(.heroFigureBox, .heroFigureBox06)
		.opacity(0)
	
	lazy var box7 = Div()
		.class(.heroFigureBox, .heroFigureBox07)
		.opacity(0)
	
	lazy var box8 = Div()
		.class(.heroFigureBox, .heroFigureBox08)
		.custom("data-rotation", "-22deg")
		.opacity(0)
	
	lazy var box9 = Div()
		.class(.heroFigureBox, .heroFigureBox09)
		.custom("data-rotation", "-52deg")
		.opacity(0)
	
	lazy var box10 = Div()
		.class(.heroFigureBox, .heroFigureBox10)
		.custom("data-rotation", "-50deg")
		.opacity(0)
	
	lazy var loader = LoaderView()

	@DOM public override var body: DOM.Content {
        Script()
            .src("https://js.hcaptcha.com/1/api.js")
            .type("text/javascript")
            .async(true)
            .defer(true)
        
        Script()
            .src("skyline/js/login.js")
            .type("text/javascript")
            .onLoad {
                
            }
        
        Link()
            .href("https://fonts.googleapis.com/css?family=IBM+Plex+Sans:400,600")
            .rel(.stylesheet)
            .onLoad {
                self.fontIsLoaded = true
            }
        
        Link()
            .href("/skyline/css/login.css")
            .rel(.stylesheet)
            .onLoad {
                self.cssIsLoaded = true
            }
        
		self.loader
		
		Div {
			/// Header
			Header {
				Div {
					Div {
						Div{ 
							H1{
								A{
									Img()
										.src("/skyline/media/logoTierraCeroLongWhite.svg")
										.height(36.px)
										.class(.headerLogoImage)
								}
								.href("#")
							}
							.class(.m0)
						}
						.class(.brand, .headerBrand)
					}
					.class(.siteHeaderInner)
				}
				.class(.container)
			}
			.class(.siteHeader)
			/// Main
			Main {
				Section {
					Div {
						Div{
							
							/// Left View
							Div{
								
							}
							.class(.heroCopy)
							
							
							/// Right View
							Div{
								
								Svg{
									SVGRect()
										.width(528)
										.height(396)
										.custom("fill", "transparent")
								}
								.class(.placeholder)
								.width(527)
								.height(396)
								.custom("viewBox", "0 0 528 396")
								
								self.box1
								
								self.box2
								
								self.box3
							
								self.box4
								
								self.box5
								
								self.box6
								
								self.box7
								
								self.box8
								
								self.box9
								
								self.box10
								
							}
							.class(.heroFigure, .animeElement)
						}
						.class(.heroInner)
					}
					.class(.container)
				}.class(.hero)
			}
			
		}
		.class(.bodyWrap)
		
		Div{
			
			Table{
				Tr{
					Td{
						Img()
							.src("/images/defaultLogoWhiteLong.svg")
							.width(250.px)
							.marginBottom(24.px)
						
						Div{
							
							H1(self.$hello)
                                .marginRight(0.px)
                                .marginLeft(0.px)
                                .textAlign(.center)
								.class(.heroTitle, .mt0)
							
							P("Ingresa tu usuario y contraseña")
								.class(.heroParagraph)
							
							self.usernameField
								.onReturn { input in
                                    
                                    /// User is not empty
									guard !input.text.isEmpty else {return}
									
                                    /// Password is empty
                                    if self.password.isEmpty {
                                        self.passwordField.select()
                                        return
                                    }
                                    
                                    self.login()
									
								}
							
                            Div{
                                
                                self.passwordTextField
                                    .hidden(self.$viewPassword.map{ !$0 })
                                    .onKeyUp { input, event in
                                        if event.code == "Enter" || event.code == "NumpadEnter" {
                                            guard !self.usernameField.text.isEmpty else {return}
                                            guard !input.text.isEmpty else {return}
                                            self.login()
                                        }
                                    }
                                self.passwordField
                                    .hidden(self.$viewPassword)
                                    .onReturn { input in
                                        guard !self.usernameField.text.isEmpty else {return}
                                        guard !input.text.isEmpty else {return}
                                        self.login()
                                    }
                                
                                Img()
                                    .src(self.$viewPassword.map{ !$0 ? "/skyline/media/hidePassword.webp" : "/skyline/media/viewPassword.png" })
                                    .class(.iconWhite)
                                    .position(.relative)
                                    .marginRight(12.px)
                                    .cursor(.pointer)
                                    .float(.right)
                                    .width(24.px)
                                    .top(-35.px)
                                    .onClick {
                                        self.viewPassword = !self.viewPassword
                                        
                                        if self.viewPassword {
                                            self.passwordTextField.select()
                                        }
                                        
                                    }
                                
                            }
                            .marginBottom(24.px)
                            .width(90.percent)
                            
							Div{
								
                                A(LString(String.forgotPassword))
									.class(.button)
									.onClick {
                                        self.passwordRecoveryMode = .confirmUsername
                                        self.usernameRevoveryField.select()
									}
                                    .float(.left)
                                    .marginRight(0.px)
								
                                A(LString(String.login))
									.class(.button, .buttonPrimary)
									.onClick {
										self.login()
									}
							}
							.class(.heroCta)
							.align(.right)
							 
							 
						}
						.boxShadow(h: 3.px, v: 3.px, blur: 64.px, color: .black)
						.backgroundColor(.hex(0x23272f))
						.borderRadius(all: 24.px)
						.padding(all: 24.px)
						.width(450.px)
						
					}
					.align(.center)
					.verticalAlign(.middle)
				}
				.border(style: .none)
			}
			.width(100.percent)
			.height(100.percent)
			
		}
		.width(60.percent)
		.height(85.percent)
		.position(.absolute)
		.top(0.px)
		.left(0.px)
		
		P("Bienvenidos a Tierra Cero Skyline [" +
        "\(SkylineWeb().version.mode.rawValue) " +
        "\(SkylineWeb().version.major.toString)." +
        "\(SkylineWeb().version.minor.toString)." +
        "\(SkylineWeb().version.patch.toString)" +
        "] Gracias por usar  la version beta. Usese bajo su propio riesgo >_<")
			.marginLeft(24.px)
			.marginRight(24.px)
			.position(.absolute)
			.bottom(0.px)
		
        Div{
            
            Div{
                Div{
                    
                    H2("Recuperar Clave 🔑")
                        .marginRight(0.px)
                        .marginLeft(0.px)
                        .textAlign(.center)
                        .class(.heroTitle, .mt0)
                    
                    P("Ingresa tu usuario para iniciar proceso")
                        .class(.heroParagraph)
                    
                    self.usernameRevoveryField
                        .onReturn { input in
                            guard !input.text.isEmpty else {return}
                            self.requestPasswordRecovery()
                        }
                    
                }
                .align(.center)
                
                Div{
                    
                    A("Cancelar")
                        .class(.button)
                        .onClick {
                            self.passwordRecoveryMode = nil
                        }
                        .float(.left)
                        .marginRight(0.px)
                    
                    A("Continuar...")
                        .class(.button, .buttonPrimary)
                        .onClick {
                            self.requestPasswordRecovery()
                        }
                }
                .class(.heroCta)
                .align(.right)
                
            }
            .boxShadow(h: 3.px, v: 3.px, blur: 64.px, color: .black)
            .backgroundColor(.hex(0x23272f))
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 24.px)
            .width(450.px)
            .top(25.percent)
            .custom("left", "calc(50% - 225px)")
            .hidden(self.$passwordRecoveryMode.map{ !($0 == .confirmUsername) })
            
            Div{
                Div{
                    
                    H2("Confirme Celular 📱")
                        .marginRight(0.px)
                        .marginLeft(0.px)
                        .textAlign(.center)
                        .class(.heroTitle, .mt0)
                    
                    P(self.$mobileConfirmationText)
                        .class(.heroParagraph)
                    
                    self.mobileRevoveryField
                        .onReturn { input in
                            guard !input.text.isEmpty else {return}
                        }
                    
                }
                .align(.center)
                
                Div{
                    
                    A("Cancelar")
                        .class(.button)
                        .onClick {
                            self.passwordRecoveryMode = nil
                        }
                        .float(.left)
                        .marginRight(0.px)
                    
                    A("Confirmar")
                        .class(.button, .buttonPrimary)
                        .onClick {
                            self.requestPasswordRecoveryConfirmCellphone()
                        }
                }
                .class(.heroCta)
                .align(.right)
                
            }
            .boxShadow(h: 3.px, v: 3.px, blur: 64.px, color: .black)
            .backgroundColor(.hex(0x23272f))
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 24.px)
            .width(450.px)
            .top(25.percent)
            .custom("left", "calc(50% - 225px)")
            .hidden(self.$passwordRecoveryMode.map{ !($0 == .confirmMobile) })
            
        }
        .backgroundColor(.transparentBlack)
        .hidden(self.$passwordRecoveryMode.map{ $0 == nil })
        .width(100.percent)
        .height(100.percent)
        .position(.absolute)
        .top(0.px)
        
        WebApp.current.loadingView
		
        WebApp.current.messageGrid
		
	}
	
	public override func buildUI() {
        
		super.buildUI()
        
        height(100.percent)
        width(100.percent)
        
        $fontIsLoaded.listen {
            if self.fontIsLoaded && self.cssIsLoaded {
                self.animate()
            }
        }
        
        $cssIsLoaded.listen {
            if self.fontIsLoaded && self.cssIsLoaded {
                self.animate()
            }
        }
               
        if let _ = isMobile() {
            Dispatch.asyncAfter(0.5) {
                History.pushState(path: "app")
            }
            return
        }
        
        title = "Tierra Cero | Login"
        
        metaDescription = "Login"
        
        let _hour = Date().hour - 6
        
        if _hour > 4 && _hour < 12 {
            self.hello = "Buenos Dias ☕️"
        }
        else if _hour > 12 && _hour < 19 {
            self.hello = "Buenas Tardes 🍖"
        }
        else{
            self.hello = "Buenas Noches 🍺"
        }
        
        if let lastUser = WebApp.current.window.localStorage.string(forKey: "lastLooginUser") {
            self.username = lastUser
        }
        
        self.$passwordRecoveryMode.listen{
            if $0 == nil {
                self.mobileConfirmationText = "..."
                self.mobile = ""
            }
        }
        
        if self.fontIsLoaded && self.cssIsLoaded {
            self.animate()
        }

        rendered()
	}
	
    public override func didAddToDOM() {
        
        print("💎 LOGIN didAddToDOM")
    
        loadBasicConfiguration() { status in
        
            guard let status else {
                /// no session will remain in page
                return
            }
            
            if status == .hotline {
                _ = JSObject.global.goToURL!("hotline")
                return
            }
            
            if !skylineLandingPage.isEmpty {
                History.pushState(path: skylineLandingPage)
                return
            }
            
            History.pushState(path: "work")
            
            WebApp.current.window.localStorage.set(getNow(), forKey: "sessionControl")
        }

    }
    
	func animate (){
		
		self.loader.remove()
		
		Dispatch.asyncAfter(0.05) {
			
			self.box6.custom("animation" ,"anibox6 1.2s forwards")
			self.box3.custom("animation" ,"anibox3 1.2s forwards")
			self.box9.custom("animation" ,"anibox9 1.21s forwards")
			self.box10.custom("animation" ,"anibox110 1.05s forwards")
		}
		
		Dispatch.asyncAfter(0.35) {
			self.usernameField.select()
			
			self.box1.custom("animation" ,"anibox1 1s forwards")
			self.box2.custom("animation" ,"anibox2 0.5s forwards")
			self.box4.custom("animation" ,"anibox4 1s forwards")
			self.box5.custom("animation" ,"anibox5 0.9s forwards")
			self.box7.custom("animation" ,"anibox7 1s forwards")
			self.box8.custom("animation" ,"anibox8 0.95s forwards")
			
		}
	}
	
    func login(){
        
        if self.username.isEmpty{
            showError(.campoRequerido, "Ingrese Nombre de Usuario")
            self.usernameField.select()
            return
        }
        
        if !self.username.contains("@"){
            showError(.campoInvalido, "Ingrese un nombre usuario valido.")
            self.usernameField.select()
            return
        }
        
        if self.password.isEmpty{
            showError(.campoRequerido, "Ingrese Contraseña")
            self.passwordField.select()
            return
        }
        
        //8342759495
        
//        if WebApp.shared.window.location.host != "127.0.0.1:8888" {
//            
//            var host = WebApp.shared.window.location.host
//            
//            if host.hasPrefix("www.") {
//                let _host = host.dropFirst(4)
//                host = String(_host)
//            }
//            
//            let parts = self.username.explode("@")
//            
//            if let domain = parts.last {
//                
//                if domain.isEmpty {
//                    showError(.unexpectedResult, "Use formato de correo electronico.")
//                    return
//                }
//                
//                print("\(domain) vs \(host)")
//                
//                if domain != host {
//                    if !allowedDomain.contains(domain){
//                        showError(.unexpectedResult, "Error Usuario / Contraseña ⚠️")
//                       //return
//                    }
//                }
//            }
//            else{
//                showError(.unexpectedResult, "Use formato de correo electronico.")
//                return
//            }
//            
//        }
        
        var brand = ""
        var model = ""
        var OS = ""
        var OSv = ""
        
        let userAgent = WebApp.current.window.navigator.userAgent
        
        let parta = userAgent.split(separator: "(")
        let partb = parta[1].split(separator: ")")
        let partc = partb[0].split(separator: ";")
        
        brand = String(partc[0])
        model = String(partc[1])
        
        let partd = userAgent.split(separator: " ")
        let parde = partd[(partd.count - 2)].split(separator: "/")
        
        OS = String(parde[0])
        OSv = String(parde[1])
        
        loadingView(show: true)
        
        API.authV1.customerLogin(
            username: self.username,
            password: self.password,
            OS: OS,
            OSv: OSv,
            model: model,
            brand: brand
        ) { payload in
            
            loadingView(show: false)
            
            guard let resp = payload else {
                showError(.errorDeCommunicacion, "No se pudo comuicar con el servidor")
                return
            }
            
            if resp.status != .ok {
                showError(.errorGeneral, "Revice sus credenciales")
                return
            }
            
            guard let data = resp.data else {
                showError(.errorGeneral, "No se obuvo el id del grupo de trabajo constacte a Soporte TC")
                return
            }
            
            guard let store = data.store else {
                showError(.errorGeneral, "No se obuvo el id de la tienda constacte a Soporte TC")
                return
            }
            
            guard let groop = data.workGroop else {
                showError(.errorGeneral, "No se obuvo el id del grupo de trabajo constacte a Soporte TC")
                return
            }
            
            showSuccess(.operacionExitosa, "Inicio de session exitosa")
            
            custCatchUser = self.username
            custCatchHerk = data.herk
            custCatchToken = data.token
            custCatchMid = data.mid
            custCatchKey = data.key
            custCatchID = data.id
            custCatchMyChatToken = data.userToken
            custCatchStore = store
            custCatchGroop = groop
            linkedProfile = data.linkedProfile
            
            panelMode = data.mode
            
            if let _url = custCatchUser.explode("@").last {
                custCatchUrl = _url
            }
            
            WebApp.current.window.localStorage.set( JSString(self.username), forKey: "custCatchUser")
            WebApp.current.window.localStorage.set( JSString(String(data.herk)), forKey: "custCatchHerk")
            WebApp.current.window.localStorage.set( JSString(data.token), forKey: "custCatchToken")
            WebApp.current.window.localStorage.set( JSString(data.mid), forKey: "custCatchMid")
            WebApp.current.window.localStorage.set( JSString(data.key), forKey: "custCatchKey")
            WebApp.current.window.localStorage.set( JSString(data.id.uuidString), forKey: "custCatchID")
            WebApp.current.window.localStorage.set( JSString(data.userToken), forKey: "custCatchMyChatToken")
            WebApp.current.window.localStorage.set( JSString(store.uuidString), forKey: "custCatchStore")
            WebApp.current.window.localStorage.set( JSString(groop.uuidString), forKey: "custCatchGroop")
            WebApp.current.window.localStorage.set( JSString(data.mode.rawValue), forKey: "panelMode")
            WebApp.current.window.localStorage.set( JSString(self.username), forKey: "lastLooginUser")
            WebApp.current.window.localStorage.set(getNow(), forKey: "sessionControl")
            
            let today = "\(JSDate().fullYear)\(JSDate().month)\(JSDate().day)"
            
            WebApp.current.window.localStorage.set( JSString(today), forKey: "activeSession")
            
            if let jsonData = try? JSONEncoder().encode(data.linkedProfile) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    WebApp.current.window.localStorage.set(jsonString, forKey: "linkedProfile")
                }
            }
            
            if !skylineLandingPage.isEmpty {
                History.pushState(path: skylineLandingPage)
                return
            }
            
            History.pushState(path: "work")
            
            
        }
    }
    
    func requestPasswordRecovery(){
        
        if username.isEmpty {
            self.usernameRevoveryField.select()
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.requestPasswordRecovery(
            username: self.username
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.errorGeneral, .unexpenctedMissingPayload)
                return
            }
            
            if data.requestUrl {
                showError(.errorGeneral, "No se localiza usuario.")
            }
            
            self.mobileConfirmationText = "Confirme su numero:\n \(data.confirmText)"
            self.passwordRecoveryToken = data.requstKey
            self.passwordRecoveryMode = .confirmMobile

        }
    }
    
    func requestPasswordRecoveryConfirmCellphone(){
        
        if mobile.isEmpty {
            self.usernameRevoveryField.select()
            return
        }
        
        API.custAPIV1.requestPasswordRecoveryConfirmCellphone(
            username: self.username,
            key: self.passwordRecoveryToken,
            cell: self.mobile
        ) { resp in
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }
            
            showSuccess(.operacionExitosa, "Su contraseña fue enviada.")
            
            self.passwordRecoveryMode = nil

        }
    }
	
}



