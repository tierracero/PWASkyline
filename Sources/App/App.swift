import Web
import TCFundamentals

@main
class App: WebApp {

    enum Theme: String {
        case main, skyline, login
    }
    
	@State var theme: Theme = .main
    
	@State var keyUp: String = ""    

    @AppBuilder override var app: Configuration {
        Lifecycle.didFinishLaunching { app in
            
            Navigator.shared.serviceWorker?.register("./service.js")

            if WebApp.shared.window.location.hostname == "localhost" || WebApp.shared.window.location.hostname == localTestIp {
                developmentMode = .develpment
                print("⚠️ APPLICATION IN DEVEPMENT MODE")
                print("⚠️ API MODE: \(developmentMode.rawValue)")
            }

            WebApp.shared.window.$location.listen {
                self.toggalStyles($0.pathname.replace(from: "/", to: ""))
            }

            self.toggalStyles(WebApp.shared.window.location.pathname.replace(from: "/", to: ""))
            
            Localization.default = .es
            
            Localization.current = .es
            
            Localization.currentState.listen {
                WebApp.current.window.localStorage.set($0.rawValue, forKey: "webLanguage")
            }
            
            /*
            Try to find user language prefrences
            */

            if let lang = WebApp.current.window.localStorage.string(forKey: "webLanguage") {
                
                if lang == "en" {
                    Localization.current = .en
                }
                else if lang == "fr" {
                    Localization.current = .fr
                }
                
            }
            else {
                
                /// Try to find user navigator language
                if let lang = App.current.window.navigator.language {
                    
                    if lang.hasPrefix("en") {
                        Localization.current = .en
                    }
                    else if lang == "fr" {
                        Localization.current = .fr 
                    }
                }
                
            }

            _ = JSObject.global.removeInitalElements!()

            print("Lifecycle.didFinishLaunching")
        }.willTerminate {
            print("Lifecycle.willTerminate")
        }.willResignActive {
            print("Lifecycle.willResignActive")
        }.didBecomeActive {

            self.toggalStyles(WebApp.shared.window.location.pathname.replace(from: "/", to: ""))
            
            if let lastCheckAt = Int64(WebApp.current.window.localStorage.string(forKey: "sessionControl") ?? "") {
                
                let interval = getNow() - lastCheckAt
                
                if interval < 10799 {
                    return
                }
                
            }
            
            loadBasicConfiguration { status in
            
                let path = WebApp.shared.window.location.pathname.replace(from: "/", to: "")
                
                guard let status else {
                    if path == "work" {
                        _ = JSObject.global.goToLogin!()
                    }
                    return
                }
                
                if status == .hotline {
                    History.pushState(path: "hotline")
                    return
                } 
                 
                WebApp.current.window.localStorage.set(getNow(), forKey: "sessionControl")
                
            }
            
            print("Lifecycle.didBecomeActive")
        }.didEnterBackground {
            print("Lifecycle.didEnterBackground")
        }.willEnterForeground {
            print("Lifecycle.willEnterForeground")
        }
        
        Routes {
            // Page { IndexPage() } DevPublic/
            Page { SplashScreen() }
            Page("hello") { HelloPage() }
            Page("**") { NotFoundPage() }
            Page("app") { SkylineMobileApp() }
            Page("skyline") { SplashScreen() }
            Page("login") { LoginViewcontroler() }
            Page("panel") { LoginViewcontroler() }
            Page("work") { WorkViewControler() }
            Page("hotline") { HotlineViewcontroler() }
            Page("nodisponible") { ServiceNotAvailbleViewControler() }

            if WebApp.shared.window.location.hostname == "control.tierracero.com" || WebApp.shared.window.location.hostname == "tierracero.com" || WebApp.shared.window.location.hostname == "localhost" {
                // Page("socialconn") { SocialConnect() }
                // Page("youtubeconn") { YoutubeConnect(isRequesting: .ytPageToken) }
                // Page("mercadolibre") { MercadoLibreConnect() }
            }

        }
        
        MainStyle().disabled($theme.map { $0 != .main })
        
        SKMainStyle().disabled($theme.map { $0 != .skyline })
        
        SKLogInStyle().disabled($theme.map { $0 != .login })
        
    }
    
    
	public func configure(){
		
        fiscCodesBase.forEach { code in
            fiscCodeRefrence[code.c] = code.v
        }
        
        fiscUnitsBase.forEach { code in
            fiscUnitRefrence[code.c] = code.v
        }
        
        Localization.default = .es
        
        Localization.current = .es
        
        if let lang = WebApp.current.window.localStorage.string(forKey: "panelLanguage") {
            if lang == "en" {
                Localization.current = .en
            }
        }
        
        Window.shared.document.addEventListener(.keyUp) { event in
            guard let key = event.jsEvent.object?.key else { return }
            self.keyUp = key.description.lowercased()
            
            if self.keyUp == "escape" {
                _ = JSObject.global.closeUIView!()
            }
            
        }
        
	}
	
    func toggalStyles(_ page: String) {
        
        let skylinePages = [
            "hotline",
            "panel",
            "configuration",
            "work"
        ]
        
        if page == "login" || page == "panel" {
            theme = .login
        }
        else if skylinePages.contains(page) {
            print("skyline")
            theme = .skyline
        }
        else {
            theme = .main
        }
    }
    
}
