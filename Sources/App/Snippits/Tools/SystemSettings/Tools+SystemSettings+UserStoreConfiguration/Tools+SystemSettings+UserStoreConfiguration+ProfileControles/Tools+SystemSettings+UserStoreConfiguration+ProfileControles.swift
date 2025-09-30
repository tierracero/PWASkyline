//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration {
    
    class ProfileControles: Div {
        
        override class var name: String { "div" }
        
        @State var selectedSetting: ViewLoadType?

        var callback: ((
        ) -> ())

        init(
            selectedSetting: ViewLoadType?,
            callback: @escaping ((
            ) -> ())
        ) {
            self.selectedSetting = selectedSetting
            self.callback = callback
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var jobPostIsLoaded: Bool = false

        @State var psicometicsIsLoaded: Bool = false

        @State var nominaIsLoaded: Bool = false

        @State var schedulesIsLoaded: Bool = false

        @State var rulesIsLoaded: Bool = false

        lazy var jobPostContainer = Div()
        .height(100.percent)
        .width(100.percent)

        lazy var psicometicsContainer = Div()
        .height(100.percent)
        .width(100.percent)

        lazy var nominaContainer = Div()
        .height(100.percent)
        .width(100.percent)
        
        lazy var schedulesContainer = Div()
        .height(100.percent)
        .width(100.percent)
        
        lazy var rulesContainer = Div()
        .height(100.percent)
        .width(100.percent)

        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Configuración de trabajo")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    
                    Div{
                        Div{

                            H2("Herramientas")
                            .color(.white)

                            Div().clear(.both).height(7.px)

                            // jobPost
                            Div("Puestos de Trabajo")
                                        .border(
                                            width: .medium,
                                            style: self.$selectedSetting.map{ $0 == .jobPosts ? .solid : .none },
                                            color: .skyBlue
                                        )
                                        .class(.uibtnLarge)
                                        .width(95.percent)
                                        .onClick {
                                            self.loadJobPostView()
                                        }
                            
                            // psicometics
                            Div("Pruebas Psicometricas")
                                        .border(
                                            width: .medium,
                                            style: self.$selectedSetting.map{ $0 == .psicometics ? .solid : .none },
                                            color: .skyBlue
                                        )
                                        .class(.uibtnLarge)
                                        .width(95.percent)
                                        .onClick {
                                            self.loadPsicometicsView()
                                        }
                            
                            // nomina
                            Div("Perfiles de Nomina")
                                        .border(
                                            width: .medium,
                                            style: self.$selectedSetting.map{ $0 == .nominas ? .solid : .none },
                                            color: .skyBlue
                                        )
                                        .class(.uibtnLarge)
                                        .width(95.percent)
                                        .onClick {
                                            self.loadNominaView()
                                        }
                    
                            // schedules
                            Div("Perfiles de Horarios")
                                        .border(
                                            width: .medium,
                                            style: self.$selectedSetting.map{ $0 == .schedules ? .solid : .none },
                                            color: .skyBlue
                                        )
                                        .class(.uibtnLarge)
                                        .width(95.percent)
                                        .onClick {
                                            self.loadSchedulesView()
                                        }
                    
                            // rules
                            Div("Documentacion y Reglas")
                                        .border(
                                            width: .medium,
                                            style: self.$selectedSetting.map{ $0 == .rules ? .solid : .none },
                                            color: .skyBlue
                                        )
                                        .class(.uibtnLarge)
                                        .width(95.percent)
                                        .onClick {
                                            self.loadRulesView()
                                        }
                                    
                        }
                        .margin(all: 12.px)
                    }
                    .height(100.percent)
                    .width(25.percent)
                    .overflow(.auto)
                    .float(.left)
                    
                    Div{

                        Table().noResult(label: "Seleccione herramienta para iniciar a trabajar.")
                        .hidden(self.$selectedSetting.map{ !($0 == nil) })

                        Div{
                            self.jobPostContainer
                            .hidden(self.$selectedSetting.map{ $0 != .jobPosts })

                            self.psicometicsContainer
                            .hidden(self.$selectedSetting.map{ $0 != .psicometics })

                            self.nominaContainer
                            .hidden(self.$selectedSetting.map{ $0 != .nominas })

                            self.schedulesContainer
                            .hidden(self.$selectedSetting.map{ $0 != .schedules })

                            self.rulesContainer
                            .hidden(self.$selectedSetting.map{ $0 != .rules })

                        }
                        .height(100.percent)
                        .margin(all: 12.px)
                        .hidden(self.$selectedSetting.map{ ($0 == nil) })

                    }
                    .height(100.percent)
                    .width(75.percent)
                    .float(.left)
                    
                }
                .custom("height", "calc(100% - 35px)")
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(80.percent)
            .left(10.percent)
            .top(10.percent)
            
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
    
        func loadJobPostView() {
            if jobPostIsLoaded {
                selectedSetting = .jobPosts
                return
            }

            loadingView(show: true)

            API.custAPIV1.getJobPosts { resp in
            
                    loadingView(show: false)

                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let data = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    self.jobPostContainer
                    .appendChild(JobPostsView(jobPosts: data))

                    self.selectedSetting = .jobPosts
                    
                    self.jobPostIsLoaded = true

            }
            
        }

        func loadPsicometicsView() {

            if psicometicsIsLoaded {
                selectedSetting = .psicometics
                return
            }

            loadingView(show: true)
            
            API.custAPIV1.getPsychometricsTests(
                type: .customer(nil)
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
                    
                    guard let items = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    self.psicometicsContainer
                    .appendChild(PsichometricsView(items: items))

                    self.selectedSetting = .psicometics
                    
                    self.psicometicsIsLoaded = true

            }

        }
        
        func loadNominaView() {
            if nominaIsLoaded {
                selectedSetting = .nominas
                return
            }
            
            loadingView(show: true)

            API.custAPIV1.getNominaProfiles { resp in
                    
                    loadingView(show: false)

                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let data = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    self.nominaContainer
                    .appendChild(NominasView(
                        nominas: data.nominas
                    ))

                    self.selectedSetting = .nominas
                    
                    self.nominaIsLoaded = true

            }

        }
        
        func loadSchedulesView() {
            if schedulesIsLoaded {
                selectedSetting = .schedules
                return
            }
            
            loadingView(show: true)

            API.custAPIV1.getScheduleProfiles { resp in
                    
                    loadingView(show: false)

                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let data = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    self.nominaContainer
                    .appendChild(SchedulesView(
                        schedules: data.schedules
                    ))

                    self.selectedSetting = .schedules
                    
                    self.schedulesIsLoaded = true

            }

        }
        
        func loadRulesView() {
            if rulesIsLoaded {
                selectedSetting = .rules
                return
            }
            
            loadingView(show: true)
            
            API.custAPIV1.getDocumentationRules { resp in

                    loadingView(show: false)

                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }

                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let data = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }

                    var rulesRefrence: [UUID : [CustDocumentationRuleManagerQuick]] = [:]

                    var articleRefrence: [UUID : [CustDocumentationArticleManagerQuick]] = [:]

                    data.rules.forEach{ rule in
                        if let _ = rulesRefrence[rule.bookId] {
                            rulesRefrence[rule.bookId]?.append(rule)
                        } else {
                            rulesRefrence[rule.bookId] = [rule]
                        }
                    }

                    data.article.forEach{ article in
                        if let _ = articleRefrence[article.ruleId] {
                            articleRefrence[article.ruleId]?.append(article)
                        } else {
                            articleRefrence[article.ruleId] = [article]
                        }
                    }

                    self.rulesContainer
                    .appendChild(DocumentacionsView(
                        books:  data.books,
                        rulesRefrence: rulesRefrence,
                        articleRefrence: articleRefrence
                    ))

                    self.selectedSetting = .rules
                    
                    self.rulesIsLoaded = true

            }

        }
    }

}

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {

    /// jobPost, psicometics, nomina, rules
    enum ViewLoadType {

        case jobPosts

        case psicometics

        case nominas

        case schedules

        case rules
        
    }


}