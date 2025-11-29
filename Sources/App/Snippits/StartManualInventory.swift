import Foundation
import TCFundamentals
import TCFireSignal
import Web

class StartManualInventory: Div {

    override class var name: String { "div" }
    
    private var callback: ((
        _ newDocumentName: String,
        _ vendor: CustVendorsQuick,
        _ profile: FiscalComponents.Profile
    ) -> ())

    init(
        callback: @escaping (
            _ newDocumentName: String,
            _ vendor: CustVendorsQuick,
            _ profile: FiscalComponents.Profile
        ) -> Void
    ) {
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var newDocumentName = ""
    
    @State var vendor: CustVendorsQuick? = nil
    
    @State var profile: FiscalComponents.Profile? = nil
    
    @State var selectFiscalProfileIsHidden = true
    
    @State var profiles: [FiscalComponents.Profile] = fiscalProfiles
    
    lazy var newDocumentNameField = InputText(self.$newDocumentName)
        .placeholder("Nombre de la orden de compra")
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .overflow(.auto)
        .height(31.px)
        .onEnter {
            if self.newDocumentName.isEmpty {
                return
            }

            if self.vendor == nil {
                self.selectVendor()
                return
            }

            self.createDocument()

        }

    lazy var choseFiscalProfilesView = Div()
        .custom("height", "calc(100% - 45px)")
        .marginTop(7.px)
        .overflow(.auto)
        .float(.right)

    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Crear Ingreso")
                    .color(.lightBlueText)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Label("Nombre del nueva compra")
                .color(.gray)
            
            Div().class(.clear).height(3.px)
            
            self.newDocumentNameField
            
            Div().class(.clear).height(7.px)
            
            Label("Proveedor")
                .color(.gray)
            
            Div().class(.clear).height(3.px)
            
            Div("Buscar Proveedor")
                .hidden(self.$vendor.map{ $0 != nil })
                .color(.yellowTC)
                .textAlign(.center)
                .marginBottom(7.px)
                .width(97.percent)
                .paddingBottom(7.px)
                .paddingTop(7.px)
                .fontSize(18.px)
                .class(.uibtn)
                .onClick {
                    self.selectVendor()
                }
            
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .marginTop(3.px)
                    .onClick({ _, event in
                        
                        self.vendor = nil
                        
                        self.selectVendor()
                        
                        event.stopPropagation()
                        
                    })
                
                Div{
                    Span(self.$vendor.map{ $0?.folio ?? "--" })
                        .marginRight(7.px)
                    
                    Span(self.$vendor.map{ $0?.businessName ?? "--" })
                        .marginRight(7.px)
                        .hidden(self.$vendor.map{ ($0?.businessName ?? "").isEmpty })
                    
                    Span(self.$vendor.map{ $0?.razon ?? "--" })
                        .marginRight(7.px)
                }
                .custom("width", "calc(100% - 35px)")
                .class(.oneLineText)
                
            }
            .hidden(self.$vendor.map{ $0 == nil })
            .color(.yellowTC)
            .paddingBottom(7.px)
            .marginBottom(7.px)
            .width(97.percent)
            .paddingTop(7.px)
            .fontSize(18.px)
            .class(.uibtn)
            .onClick {
                
                guard let vendor = self.vendor else {
                    return
                }
                
                addToDom( SearchVendorView(loadBy: .account(vendor)) { account in
                    self.vendor = account
                })
            }
            
            Div().class(.clear).height(7.px)
                .hidden(self.$profiles.map{ $0.count < 2 })
            
            Div {
                Div{
                    
                    Div{
                        Div{
                            
                            Img()
                                .src("/skyline/media/random.png")
                                .height(18.px)
                                .paddingRight(0.px)
                        }
                        .marginRight(3.px)
                        .float(.left)
                        
                        Label("Cambiar Perfil")
                            .fontSize(12.px)
                    }
                    .hidden(self.$profiles.map{ $0.count < 2 })
                    .marginTop(-7.px)
                    .float(.right)
                    .class(.uibtn)
                    .onClick {
                        self.changeFiscalProfile()
                    }
                    
                    H4("Perfil de Facturación")
                }
                
                Div().class(.clear).marginBottom(7.px)
                
                InputText(self.$profile.map{ $0?.razon ?? "" })
                    .class(.textFiledBlackDark)
                    .placeholder("Razon Social")
                    .marginBottom(3.px)
                    .width(95.percent)
                    .fontSize(20.px)
                    .height(24.px)
                
                InputText(self.$profile.map{ $0?.rfc ?? "" })
                    .class(.textFiledBlackDark)
                    .placeholder("RFC")
                    .marginBottom(3.px)
                    .width(95.percent)
                    .fontSize(20.px)
                    .height(24.px)
            }
            .hidden(self.$profiles.map{ $0.count < 2 })
            
            Div().class(.clear).height(7.px)
            
            Div("iniciar Compra")
                .paddingBottom(7.px)
                .marginBottom(7.px)
                .width(97.percent)
                .paddingTop(7.px)
                .textAlign(.center)
                .color(.yellowTC)
                .fontSize(18.px)
                .class(.uibtn)
                .onClick {
                    self.createDocument()
                }
            
        }
        .custom("left", "calc(50% - 224px)")
        .custom("top", "calc(50% - 224px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(400.px)

        Div{
            Div{
                
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.subView)
                        .onClick{
                            self.selectFiscalProfileIsHidden = true
                        }
                    
                    H2("Seleccionar Perfil")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                }
                
                /// Fiscal Profie Div
                self.choseFiscalProfilesView
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 200px)")
            .custom("top", "calc(50% - 130px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(270.px)
            .width(400.px)
        }
        .hidden(self.$selectFiscalProfileIsHidden)
        .class(.transparantBlackBackGround)
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .left(0.px)
        .top(0.px)

    }

    override func buildUI() {
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        color(.white)
        left(0.px)
        top(0.px)

        profile = fiscalProfiles.first
        
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        
        newDocumentNameField.select()

    }

    func createDocument(){
        
        newDocumentName = newDocumentName.purgeSpaces.capitalizingFirstLetters()
        
        if newDocumentName.isEmpty {
            showError(.campoRequerido, "Ingrese nombre para identificar documento")
            newDocumentNameField.select()
            return
        }
        
        guard let vendor else {
            showError(.campoRequerido, "Seleccione provedor de la compra")
            return
        }
        
        guard let profile else {
            showError(.campoRequerido, "Seleccione/Active Perfil Fiscal, contatcte a Soporte TC")
            return
        }

        callback(newDocumentName, vendor, profile)

        self.remove()
    }

    func changeFiscalProfile(){
        
        if profiles.count > 2 {
            
            choseFiscalProfilesView.innerHTML = ""
            
            profiles.forEach { prof in
                
                if prof.id == profile?.id {
                    return
                }
                
                choseFiscalProfilesView.appendChild(
                    Div(prof.razon)
                        .width(97.percent)
                        .class(.uibtnLarge)
                        .onClick {
                            self.selectFiscalProfileIsHidden = true
                            self.profile = prof
                        }
                )
            }
            
            selectFiscalProfileIsHidden = false
            
        }
        else{
            
            var _prof: FiscalComponents.Profile? = nil
            profiles.forEach { prof in
                if prof.id != profile?.id {
                    _prof = prof
                }
            }
            
            profile = _prof
        }
    }

    func selectVendor() {
        addToDom( SearchVendorView(loadBy: nil) { account in

            self.vendor = account

            if self.newDocumentName.purgeSpaces.isEmpty {
                self.newDocumentNameField.select()
                return
            }

            self.createDocument()

        })
    }
    
}