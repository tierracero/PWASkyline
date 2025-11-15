//
//  Tools+SystemSettings.swift
//  
//
//  Created by Victor Cantu on 9/9/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

extension ToolsView {
    
    class SystemSettings: Div {
        
        override class var name: String { "div" }
        
        @State var selectedSetting: ConfigurationView = .seviceOrder
        
        // seviceOrder
        lazy var seviceOrderDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .seviceOrder })
            .height(100.percent)
            .width(100.percent)
        
        // seviceTags
        lazy var seviceTagsDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .seviceTags })
            .height(100.percent)
            .width(100.percent)
        
        // storeProduct
        lazy var storeProductDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .storeProduct })
            .height(100.percent)
            .width(100.percent)
        
        // general
        lazy var generalDiv = Div()
            .hidden(self.$selectedSetting.map{ $0 != .general })
            .height(100.percent)
            .width(100.percent)

        // advance configuration
        lazy var advancedlDiv = Div{
            Div("Descargar Respaldo")
            .class(.uibtn)
            .onClick {
                self.downloadBackup()
            }
        }
            .hidden(self.$selectedSetting.map{ $0 != .advancesConfiguration })
            .height(100.percent)
            .width(100.percent)
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Ajustes de Sistema")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                Div {
                    
                    Div{
                        Div{
                            
                            H2("Configuraciones")
                                .color(.lightBlueText)
                                .width(95.percent)
                                .marginBottom(7.px)
                            
                            if custCatchHerk > 3 {
                                
                                /// ConfigStoreProcessing
                                /// ConfigContactTags
                                Div("Ordenes de Servicio")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .seviceOrder ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .seviceOrder
                                    }
                                
                                /// ConfigServiceTags
                                Div("Etiquetas de Servicio")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .seviceTags ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .seviceTags
                                    }
                                
                                Div("Tieda / Productos")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .storeProduct ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .storeProduct
                                    }
                                    
                                /// ConfigGeneral
                                Div("General")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .general ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .general
                                    }

                                /// Advanced
                                Div("Avanzado")
                                    .border(
                                        width: .medium,
                                        style: self.$selectedSetting.map{ $0 == .advancesConfiguration ? .solid : .none },
                                        color: .skyBlue
                                    )
                                    .class(.uibtnLarge)
                                    .width(95.percent)
                                    .onClick {
                                        self.selectedSetting = .advancesConfiguration
                                    }
                            }
                            
                        }
                        .padding(all: 7.px)
                    }
                    .height(100.percent)
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        self.seviceOrderDiv
                        self.seviceTagsDiv
                        self.storeProductDiv
                        self.generalDiv
                        self.advancedlDiv
                    }
                    .height(100.percent)
                    .width(75.percent)
                    .overflow(.auto)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .custom("height", "calc(100% - 28px)")
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(90.percent)
            .left(5.percent)
            .top(10.percent)
            
        }
        
        override func buildUI() {
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custAPIV1.getConfigs { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
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
                
                self.seviceOrderDiv.appendChild(SeviceOrder(
                    configStoreProcessing: payload.configStoreProcessing,
                    configContactTags: payload.configContactTags
                ))
                
                self.seviceTagsDiv.appendChild(SeviceTags(
                    configServiceTags: payload.configServiceTags
                ))

                self.storeProductDiv.appendChild(StoreProducts(
                    configStoreProduct: payload.configStoreProduct
                ))
                
                self.generalDiv.appendChild(General(
                    pageProfile: payload.pageProfile,
                    socialProfile: payload.socialProfile
                ))


                

                // payload.configGeneral
                // payload.configServiceTags

            }
        }
    }
}

extension ToolsView.SystemSettings {
    
    /// seviceOrder, seviceTags, ConfigGeneral
    enum ConfigurationView {
        
        /// My personal Conficuration
        case myconfig
        
        /// ConfigStoreProcessing
        /// ConfigContactTags
        case seviceOrder
        
        /// ConfigServiceTags
        case seviceTags
        
        /// ConfigGeneral
        case general
        
        ///  ConfigStoreProduct
        case storeProduct
        
        case  advancesConfiguration

    }

    func downloadBackup() {

        let url = baseAPIUrl( "https://intratc.co/api/cust/v1/downloadBackup")
        
        print(url)

        _ = JSObject.global.goToURL!(url)

        /*
        do {

            let data = try JSONEncoder().encode(APIHeader(
                AppID: thisAppID,
                AppToken: thisAppToken,
                user: custCatchUser,
                mid: custCatchMid,
                key: custCatchKey,
                token: custCatchToken,
                tcon: .web,
                applicationType: .customer
            ))

            let token = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            Console.clear()

            print("token")

            print(token)

            var header: [String:String] = [
                "Authorization": token
            ]
            // 
            _ = JSObject.global.downloadWithHeader!("https://intratc.co/a[i/cust/v1/downloadBackup", header)

        }
        catch {
            showError(.unexpectedResult, "Error al crear header DATA")
            return
        }
    */
        



        /*

        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {

        guard let json = String(data: data, encoding: .utf8) else {
            showError(.unexpectedResult, "Error al crear header JSON")
            return
        }

        downloadWithHeader("")

        var xhr = XMLHttpRequest();

        xhr.open(method: "GET", url: "")

        xhr.responseType = .blob

        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web,
            applicationType: .customer
        )){
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        xhr.onLoad {
            
            print("xhr.responseType")

            print(xhr.responseType)
            

            var blob = xhr.response
        }

        /*
        xhr.onload = function () {
            if (xhr.status === 200) {
                const blob = xhr.response;
                const url = window.URL.createObjectURL(blob);

                const link = document.createElement("a");
                link.href = url;
                link.download = "report.pdf";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                window.URL.revokeObjectURL(url);
            } else {
                console.error("Download failed:", xhr.status, xhr.statusText);
            }
        };
        */
        
        xhr.send();
        */
    }
    
}
func _downloadBackup(
    /// Term to Search
    term: String,
    callback: @escaping ((_ term: String, _ resp: [APISearchResultsGeneral])->())
){
    
    let _term = (term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        .replace(from: "/", to: "%2f")
        .replace(from: "+", to: "%2b")
        .replace(from: "=", to: "%3d")
    
    let xhr = XMLHttpRequest()
    
    let url = baseAPIUrl("https://intratc.co/api/v1/getFiscalUnitPesos") + "&term=\(_term)"
    
    xhr.open(method: "GET", url: url)
    
    xhr.setRequestHeader("Accept", "application/json")
        .setRequestHeader("Content-Type", "application/json")

    xhr.send("")
    
    xhr.onError {
        print("error")
        print(xhr.responseText ?? "")
        callback(term,[])
    }
    xhr.onLoad {
        
        if let data = xhr.responseText?.data(using: .utf8) {
            do {
                let resp = try JSONDecoder().decode([APISearchResultsGeneral].self, from: data)
                
                callback(term,resp)
                
            } catch  {
                print(error)
                callback(term,[])
            }
        }
        else{
            callback(term,[])
        }
    }
}

