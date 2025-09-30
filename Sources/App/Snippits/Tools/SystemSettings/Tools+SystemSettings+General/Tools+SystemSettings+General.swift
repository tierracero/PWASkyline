//
//  Tools+SystemSettings+General.swift
//
//
//  Created by Victor Cantu on 8/28/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings {
    /**
     let configGeneral: ConfigGeneral
     
     let pageProfile: GeneralPageProfile
     
     let socialProfile: CustSocialConfiguration
     */
    class General : Div {
        
        override class var name: String { "div" }
        
        var color: String
        
        /// ConfigConfigGeneralDocumentColor
        @State var institutionalColorListener = ""
        
        @State var slogan: String
        
        @State var mantra: String
        
        @State var commercialName: String
        
        @State var facebookLink: String
        
        @State var instagramLink: String
        
        @State var twitterLink: String
        
        @State var youtubeLink: String
        
        @State var pinterestLink: String
        
        @State var tictokLink: String
        
        public init(
            pageProfile: GeneralPageProfile,
            socialProfile: CustSocialConfiguration
        ) {
            self.color = pageProfile.institutionalColor.rawValue
            self.slogan = pageProfile.slogan ?? ""
            self.mantra = pageProfile.mantra ?? ""
            self.commercialName = pageProfile.commercialName
            self.facebookLink = socialProfile.facebookLink ?? ""
            self.instagramLink = socialProfile.instagramLink ?? ""
            self.twitterLink = socialProfile.twitterLink ?? ""
            self.youtubeLink = socialProfile.youtubeLink ?? ""
            self.pinterestLink = socialProfile.pinterestLink ?? ""
            self.tictokLink = socialProfile.tictokLink ?? ""
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        /// ConfigConfigGeneralDocumentColor
        /// azul, rojo, naranja, verde
        lazy var institutionalColorSelect = Select(self.$institutionalColorListener)
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var sloganeField = InputText(self.$slogan)
            .placeholder("Un sabor que nunca olvidaras")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var mantraField = InputText(self.$mantra)
            .placeholder("Te brindaremos un sabor y servicios que nunca olvidaras.")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var commercialNameField = InputText(self.$commercialName)
            .placeholder("Pollos Hermanos")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var facebookLinkField = InputText(self.$facebookLink)
            .placeholder("Usuario de Facebook")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var instagramLinkField = InputText(self.$instagramLink)
            .placeholder("Usuario de Intagram")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var twitterLinkField = InputText(self.$twitterLink)
            .placeholder("Usuario de Twitter")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var youtubeLinkField = InputText(self.$youtubeLink)
            .placeholder("Usuario de Youtube")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        ///
        lazy var tictokLinkField = InputText(self.$tictokLink)
            .placeholder("Usuario de TicTok")
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .width(95.percent)
        
        @DOM override var body: DOM.Content {
            
            Div{
                Div{
                    
                     H3("Configuracion Basica").color(.lightBlueText)
                     
                     /// Intitucional Color
                     Div{
                         
                         Div{
                             Label("Color Institucional")
                                 .color(.lightGray)
                         }
                         .class(.oneHalf)
                         
                         Div{
                             self.institutionalColorSelect
                         }
                         .class(.oneHalf)
                         
                     }
                      
                     Div().clear(.both).height(7.px)
                    
                    /// Slogan
                    Div{
                        Div{
                            Label("Slogan")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{
                            self.sloganeField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                    /// Mantra
                    Div{
                        Div{
                            Label("Mantra")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        
                        Div{
                            self.mantraField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                    /// Comertial Name
                    Div{
                        Div{
                            Label("Nombre Comercial")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        
                        Div{
                            self.commercialNameField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                }
                .margin(all: 7.px)
            }
            .width(50.percent)
            .float(.left)
            
            Div{
                
                Div{
                    
                     H3("Redes Sociales").color(.lightBlueText)
                     
                     /// Facebook
                     Div{
                         Div{
                             Label("Facebook")
                                 .color(.lightGray)
                         }
                         .class(.oneHalf)
                         Div{
                             self.facebookLinkField
                         }
                         .class(.oneHalf)
                     }
                      
                     Div().clear(.both).height(7.px)
                    
                    /// Instagram
                    Div{
                        Div{
                            Label("Intagram")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{
                            self.instagramLinkField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                    /// Twitter
                    Div{
                        Div{
                            Label("Twitter")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{
                            self.twitterLinkField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                    /// Youtube
                    Div{
                        Div{
                            Label("Youtube")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{
                            self.youtubeLinkField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                    /// Ticktok
                    Div{
                        Div{
                            Label("TicTok")
                                .color(.lightGray)
                        }
                        .class(.oneHalf)
                        Div{
                            self.tictokLinkField
                        }
                        .class(.oneHalf)
                    }
                     
                    Div().clear(.both).height(7.px)
                    
                }
                .margin(all: 7.px)
                 
            }
            .width(50.percent)
            .float(.left)
            
            Div().clear(.both)
            
            Div{
                Div("Guardar")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.saveSetting()
                    }
            }.align(.right)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            ConfigConfigGeneralDocumentColor.allCases.forEach { color in
                institutionalColorSelect.appendChild(Option(color.description).value(color.rawValue))
            }
            
            institutionalColorListener = color
            
        }
        
        
        func saveSetting() {
            
            guard let institutionalColor: ConfigConfigGeneralDocumentColor = .init(rawValue: institutionalColorListener) else {
                showError(.campoRequerido, "Escoja un color institucional valido")
                return
            }
            
            let slogan: String? = self.slogan.isEmpty ? nil : self.slogan
            
            let mantra: String? = self.mantra.isEmpty ? nil : self.mantra
            
            if commercialName.isEmpty {
                showError(.campoRequerido, "Ingrese Nombre Comercial")
                return
            }
            
            let facebookLink: String? = self.facebookLink.isEmpty ? nil : self.facebookLink
            
            let instagramLink: String? = self.instagramLink.isEmpty ? nil : self.instagramLink
            
            let twitterLink: String? = self.twitterLink.isEmpty ? nil : self.twitterLink
            
            let youtubeLink: String? = self.youtubeLink.isEmpty ? nil : self.youtubeLink
            
            let pinterestLink: String? = self.pinterestLink.isEmpty ? nil : self.pinterestLink
            
            let tictokLink: String? = self.tictokLink.isEmpty ? nil : self.tictokLink
            
            loadingView(show: true)
            
            API.custAPIV1.saveBasicProfile(
                pageProfile: .init(
                    institutionalColor: institutionalColor,
                    slogan: slogan,
                    mantra: mantra,
                    commercialName: commercialName
                ),
                socialProfile: .init(
                    facebookLink: facebookLink,
                    instagramLink: instagramLink,
                    twitterLink: twitterLink,
                    youtubeLink: youtubeLink,
                    pinterestLink: pinterestLink,
                    tictokLink: tictokLink
                )
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                }
        }
    }
}
