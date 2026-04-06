//
//  StartSeviceOrderBulk.swift
//
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class StartServiceOrderBulk: Div {
    
    override class var name: String { "div" }
    
    var account: CustAcctSearch
    
    var customeScript: CustomerCustomeScript
    
    var file: File
    
    init(
        account: CustAcctSearch,
        customeScript: CustomerCustomeScript,
        file: File
    ) {
        self.account = account
        self.customeScript = customeScript
        self.file = file
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let viewid: UUID = .init()
    
    @State var loadPercent = ""
    
    @State var status = "Preparando archivo"
    
    @State var mediaid: UUID? = nil
    
    @State var isCompleted = false
    
    @State var items: [SeviceOrderBulkItem] = []

    lazy var itemsContainer = Div{
       Div{
            ForEach(self.$items) { item in
                item
            }
       }
       .padding(all: 3.px)
    }
        .custom("height", "calc(100% - 200px)")
        .class(.roundDarkBlue)
        .overflow(.auto)
        .hidden(self.$items.map{ $0.isEmpty })
    
    lazy var noItemsView = Div {
        Table().noResult(label: "⚠️ No se localizaron registros.")
    }
    .custom("height", "calc(100% - 200px)")
    .class(.roundBlue)
    .hidden(self.$items.map{ !$0.isEmpty })
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick {
                        self.remove()
                    }
                
                H2("Orden de Servicio Masiva")
                    .color(.lightBlueText)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            
            Div().class(.clear).height(3.px)
            
            Div {
                Div {
                    
                    Label("Cuenta")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Div("\(self.account.folio) \(self.account.firstName) \(self.account.lastName)".purgeSpaces)
                        .class(.oneLineText)
                        .fontWeight(.bolder)
                        .color(.white)
                    
                }
                .width(33.percent)
                .fontSize(22.px)
                .height(75.px)
                .float(.left)
                
                Div {
                    
                    Label("Script")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Div(self.customeScript.name)
                        .class(.oneLineText)
                        .fontWeight(.bolder)
                        .color(.white)
                    
                }
                .width(33.percent)
                .fontSize(22.px)
                .height(75.px)
                .float(.left)
                
                Div {
                    
                    Label("Archivo")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Div(self.file.name)
                        .class(.oneLineText)
                        .fontWeight(.bolder)
                        .color(.white)
                    
                }
                .width(33.percent)
                .fontSize(22.px)
                .height(75.px)
                .float(.left)

                Div().clear(.both)

                Div {
                    Label("Estado")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Span(self.$status)
                        .color(.white)
                        .fontWeight(.bolder)
                }
                .width(65.percent)
                .float(.left)
                
                Div {
                    Label("Registros")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Span(self.$items.map { $0.count.toString })
                        .color(.white)
                        .fontWeight(.bolder)
                }
                .width(20.percent)
                .float(.left)
                
                Div {
                    Label("Carga")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear)
                    
                    Span(self.$loadPercent.map { $0.isEmpty ? "--" : "\($0)%" })
                        .color(.white)
                        .fontWeight(.bolder)
                }
                .width(15.percent)
                .float(.left)
                
                Div().class(.clear)
                
            }
            
            Div().class(.clear).height(7.px)
            
            self.noItemsView
            
            self.itemsContainer

            Div{
                Div("Crear Ordenes").class(.uibtnLargeOrange)
                .onClick {
                    self.createOrder()
                }
            }
            .align(.right)
            
        }
        .custom("height", "calc(100% - 70px)")
        .custom("width", "calc(100% - 70px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .left(24.px)
        .top(24.px)
        
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
        self.loadMedia(file)
    }
    
    func loadExtractedItems(fileName: String) {
        
        self.status = "Extrayendo ordenes"
        
        API.custOrderV1.extractData(
            fileName: fileName,
            scriptId: self.customeScript.id
        ) { resp in
            
            guard let resp else {
                self.status = "No se pudo extraer la informacion"
                showError(.generalError, .serverConextionError)
                self.remove()
                return
            }
            
            guard resp.status == .ok else {
                self.status = "Error al extraer la informacion"
                showError(.generalError, resp.msg)
                self.remove()
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpectedMissingPayload)
                self.remove()
                return
            }

            var items: [SeviceOrderBulkItem] = []

            payload.orders.forEach { order in

                if order.posibleConflict == true  {
                    return
                }

                let row = SeviceOrderBulkItem(item: order) { _ in

                }

                items.append(row)

            }

             self.items = items
            
            self.status = "Carga Correcta "
        }
        
    }
    
    func loadMedia(_ file: File) {
        
        let xhr = XMLHttpRequest()
        
        xhr.onLoadStart { _ in
            self.status = "Cargando archivo"
        }
        
        xhr.onError { _ in
            self.status = "Error de comunicacion"
            showError(.comunicationError, .serverConextionError)
        }
        
        xhr.onLoadEnd {
            
            print("StartSeviceOrderBulk.onLoadEnd")
            
            self.loadPercent = ""
            
            guard let responseText = xhr.responseText else {
                self.status = "No se pudo leer la respuesta"
                showError(.generalError, .serverConextionError + " 001")
                return
            }
            
            guard let data = responseText.data(using: .utf8) else {
                self.status = "No se pudo procesar la respuesta"
                showError(.generalError, .serverConextionError + " 002")
                return
            }
            
            do {
                
                let resp = try JSONDecoder().decode(APIResponseGeneric<API.custAPIV1.UploadManagerResponse>.self, from: data)
                
                guard resp.status == .ok else {
                    self.status = "Error al cargar archivo"
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let process = resp.data else {
                    self.status = "No se pudo cargar datos"
                    showError(.generalError, "No se pudo cargar datos")
                    return
                }
                
                switch process {
                case .processing(let payload):
                    self.status = "Procesando \(payload.fileName)"
                    
                case .processed(let payload):
                    
                    self.isCompleted = true
                    self.status = "Archivo cargado correctamente"
                    self.mediaid = payload.mediaid
                    
                    self.loadExtractedItems(fileName: payload.fileName)
                }
                
            }
            catch {
                self.status = "Error al decodificar respuesta"
                showError(.generalError, .serverConextionError + " 003")
                return
            }
            
        }
        
        xhr.upload.addEventListener("progress", options: EventListenerAddOptions.init(capture: false, once: false, passive: false, mozSystemGroup: false)) { _event in
            
            let event = ProgressEvent(_event.jsEvent)
            
            self.loadPercent = ((Double(event.loaded) / Double(event.total)) * 100).toInt.toString
            
            print("PROGRESS \(self.loadPercent)")
            
        }
        
        xhr.onProgress { event in
            print("StartSeviceOrderBulk.onProgress")
            print(event.loaded)
            print(event.total)
        }
        
        let fileName = safeFileName(name: file.name, to: nil, folio: nil)
        
        let formData = FormData()
        
        formData.append("file", file, filename: fileName)
        formData.append("eventid", self.viewid.uuidString)
        formData.append("to", ImagePickerTo.oncreate.rawValue)
        formData.append("fileName", fileName)
        formData.append("connid", custCatchChatConnID)
        formData.append("remoteCamera", false.description)
        
        xhr.open(method: "POST", url: "https://api.tierracero.co/cust/v1/uploadManager")
        
        xhr.setRequestHeader("Accept", "application/json")
        
        if let jsonData = try? JSONEncoder().encode(APIHeader(
            AppID: thisAppID,
            AppToken: thisAppToken,
            url: custCatchUrl,
            user: custCatchUser,
            mid: custCatchMid,
            key: custCatchKey,
            token: custCatchToken,
            tcon: .web,
            applicationType: custCatchAccountType.sessionType
        )) {
            if let str = String(data: jsonData, encoding: .utf8) {
                let utf8str = str.data(using: .utf8)
                if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
                    xhr.setRequestHeader("Authorization", base64Encoded)
                }
            }
        }
        
        xhr.send(formData)
        
    }
    
    func createOrder(){
        
        guard !items.isEmpty else {
            showError(.requiredField, "No hay registros para crear.")
            return
        }
        
        let view = ConfirmationView(type: .yesNo, title: "Confirmar Creacion", message: "Confirme la creacion de \(items.count.toString) ordenes") { isConfirm, _ in

            if !isConfirm {
                return
            }

            var extarct: [OrderExtractPayload] = []
            
            for (index, item) in self.items.enumerated() {

                let payload = item.extractPayload()
                let rowName = payload.idOne.isEmpty ? "registro \(index + 1)" : payload.idOne
                
                guard !payload.mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showError(.requiredField, "El \(rowName) debe incluir movil.")
                    return
                }

                let (isValid, message) = isValidPhone(payload.mobile)

                if isValid {
                    showError(.requiredField, rowName  + " " + message)
                    return
                }

                guard !payload.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showError(.requiredField, "El \(rowName) debe incluir primer nombre.")
                    return
                }
                
                guard !payload.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showError(.requiredField, "El \(rowName) debe incluir apellido.")
                    return
                }
                
                guard !payload.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    showError(.requiredField, "El \(rowName) debe incluir descripcion.")
                    return
                }

                

                
                extarct.append(payload)
            }

            loadingView(show: true)

            API.custOrderV1.createBatch(
                type: .folio,
                storeId: custCatchStore,
                custAcct: self.account.id,
                custSubAcct: nil,
                items: extarct
            ) { resp in
                
                loadingView(show: false)

                guard let resp else {
                    self.status = "No se pudieron crear las ordenes"
                    showError(.generalError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    self.status = "Error al crear ordenes"
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let data = resp.data else {
                    self.status = "No se recibieron resultados"
                    showError(.generalError, "No se recibieron resultados de la creacion.")
                    return
                }
                
                self.status = "Ordenes creadas"

                addToDom(
                    SeviceOrderBulkResults(
                        orders: data.orders,
                        errors: data.errors
                    )
                )


                self.remove()

            }
            
        }

        addToDom(view)
    
    }
}

class SeviceOrderBulkResults: Div {
    
    override class var name: String { "div" }
    
    @State var orders: [CustOrder]
    
    @State var errors: [String]
    
    init(
        orders: [CustOrder],
        errors: [String]
    ) {
        self.orders = orders
        self.errors = errors
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var ordersView = Div {
        ForEach(self.$orders) { order in
            Div {
                Label("Folio Creado")
                    .color(.gray)
                    .fontSize(15.px)
                
                Div().class(.clear).height(4.px)
                
                Div("\(order.folio) \(order.name) \(order.smallDescription)")
                    .class(.textFiledBlackDark, .oneLineText)
                    .padding(all: 10.px)
                    .color(.white)
            }
            .class(.roundBlue)
            .padding(all: 12.px)
            .marginBottom(8.px)
        }
    }
    .custom("height", "calc(100% - 70px)")
    .overflow(.auto)
    .hidden(self.$orders.map { $0.isEmpty })
    
    lazy var ordersEmptyView = Div {
        Table().noResult(label: "No se crearon ordenes.")
    }
    .custom("height", "calc(100% - 70px)")
    .hidden(self.$orders.map { !$0.isEmpty })
    
    lazy var errorsView = Div {
        ForEach(self.$errors) { error in
            Div {
                Label("Error")
                    .color(.gray)
                    .fontSize(15.px)
                
                Div().class(.clear).height(4.px)
                
                Div(error)
                    .class(.textFiledBlackDark)
                    .padding(all: 10.px)
                    .color(.white)
            }
            .class(.roundBlue)
            .padding(all: 12.px)
            .marginBottom(8.px)
        }
    }
    .custom("height", "calc(100% - 70px)")
    .overflow(.auto)
    .hidden(self.$errors.map { $0.isEmpty })
    
    lazy var errorsEmptyView = Div {
        Table().noResult(label: "No se reportaron errores.")
    }
    .custom("height", "calc(100% - 70px)")
    .hidden(self.$errors.map { !$0.isEmpty })
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div {
                
                Img()
                    .closeButton(.uiView1)
                    .onClick {
                        self.remove()
                    }
                
                H2("Resultado de Carga")
                    .color(.lightBlueText)
                    .float(.left)
                
                Div().class(.clear)
            }
            
            Div().class(.clear).height(8.px)
            
            Div {
                
                Div {
                    Label("Ordenes Creadas")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear).height(8.px)
                    
                    self.ordersEmptyView
                    self.ordersView
                }
                .width(50.percent)
                .height(100.percent)
                .float(.left)
                
                Div {
                    Label("Errores")
                        .color(.gray)
                        .fontSize(16.px)
                    
                    Div().class(.clear).height(8.px)
                    
                    self.errorsEmptyView
                    self.errorsView
                }
                .width(50.percent)
                .height(100.percent)
                .float(.left)
                
                Div().class(.clear)
            }
            .custom("height", "calc(100% - 48px)")
            
        }
        .custom("height", "calc(100% - 310px)")
        .custom("width", "calc(100% - 310px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 16.px)
        .left(186.px)
        .top(186.px)
        
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
    
}

class SeviceOrderBulkItem: Div {
    
    override class var name: String { "div" }
    
    var item: OrderExtractPayload
    
    @State var brand: String
    @State var city: String
    @State var colony: String
    @State var country: String
    @State var itemDescription: String
    @State var email: String
    @State var firstName = ""
    @State var idOne: String
    @State var idTwo: String
    @State var lastName: String
    @State var latitude: String
    @State var longitud: String
    @State var mobile: String
    @State var model: String
    @State var posibleConflict: Bool
    @State var secondLastName: String
    @State var secondName: String
    @State var serie: String
    @State var state: String
    @State var street: String
    @State var telephone: String
    @State var type: String
    @State var zip: String
    @State var workedBy: String

    private var onRemove: ((
        _ itemId: UUID
    ) -> ())

    init(
        item: OrderExtractPayload,
        onRemove: @escaping ((
            _ itemId: UUID
        ) -> ())
    ) {
        self.item = item
        self.onRemove = onRemove
        self.brand = item.brand
        self.city = item.city
        self.colony = item.colony
        self.country = item.country
        self.itemDescription = item.description
        self.email = item.email
        self.firstName = item.firstName
        self.idOne = item.idOne
        self.idTwo = item.idTwo
        self.lastName = item.lastName
        self.latitude = Self.formatCoordinate(item.latitude)
        self.longitud = Self.formatCoordinate(item.longitud)
        self.mobile = item.mobile
        self.model = item.model
        self.posibleConflict = item.posibleConflict ?? false
        self.secondLastName = item.secondLastName
        self.secondName = item.secondName
        self.serie = item.serie
        self.state = item.state
        self.street = item.street
        self.telephone = item.telephone
        self.type = item.type
        self.zip = item.zip
        self.workedBy = item.workedBy?.uuidString.lowercased() ?? ""
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    
    lazy var idTag1Field = InputText(self.$idOne)
        .autocomplete(.off)
        .placeholder(configServiceTags.idTagPlaceholder)
        .class(.textFiledBlackDark)
        .custom("width", "calc(100% - 10px)")
       
    lazy var idTag2Field = InputText(self.$idTwo)
        .autocomplete(.off)
        .placeholder(configServiceTags.secondIDTagPlaceholder)
        .class(.textFiledBlackDark)
        .custom("width", "calc(100% - 10px)")
    

    lazy var descriptionArea = TextArea(self.$itemDescription)
        .placeholder(configServiceTags.tagDescrPlaceholder)
        .custom("width", "calc(100% - 10px)")
        .class(.textFiledBlackDark)
        .width(100.percent)
        .height(90.px)

    lazy var brandField = self.makeTextField(self.$brand, placeholder: "Marca")
    lazy var cityField = self.makeTextField(self.$city, placeholder: "Ciudad")
    lazy var colonyField = self.makeTextField(self.$colony, placeholder: "Colonia")
    lazy var countryField = self.makeTextField(self.$country, placeholder: "Pais")
    lazy var emailField = self.makeTextField(self.$email, placeholder: "Correo")
    lazy var firstNameField = self.makeTextField(self.$firstName, placeholder: "Primer Nombre")
    lazy var lastNameField = self.makeTextField(self.$lastName, placeholder: "Primer Apellido")
    lazy var latitudeField = self.makeTextField(self.$latitude, placeholder: "Latitud")
    lazy var longitudField = self.makeTextField(self.$longitud, placeholder: "Longitud")
    lazy var mobileField = self.makeTextField(self.$mobile, placeholder: "Celular")
    lazy var modelField = self.makeTextField(self.$model, placeholder: "Modelo")
    lazy var secondLastNameField = self.makeTextField(self.$secondLastName, placeholder: "Segundo Apellido")
    lazy var secondNameField = self.makeTextField(self.$secondName, placeholder: "Segundo Nombre")
    lazy var serieField = self.makeTextField(self.$serie, placeholder: "Serie")
    lazy var stateField = self.makeTextField(self.$state, placeholder: "Estado")
    lazy var streetField = self.makeTextField(self.$street, placeholder: "Calle")
    lazy var telephoneField = self.makeTextField(self.$telephone, placeholder: "Telefono")
    lazy var typeField = self.makeTextField(self.$type, placeholder: "Tipo")
    lazy var zipField = self.makeTextField(self.$zip, placeholder: "Codigo Postal")
    
    lazy var workedBySelect = Select(self.$workedBy)
        .class(.textFiledBlackDark)
        .custom("width", "calc(100% - 18px)")
        .height(37.px)
        .body {
            Option("Seleccione Usuario")
                .value("")
        }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div{

                Div {

                    Div{
                        Label(configServiceTags.idTagName)
                        .color(.gray)
                        self.idTag1Field
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label(configServiceTags.secondIDTagName)
                        .color(.gray)
                        self.idTag2Field

                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Movil")
                        .color(.gray)
                        self.mobileField

                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("Telefono")
                        .color(.gray)
                        self.telephoneField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)

                Div {

                    Div{
                        Label(configServiceTags.tag2Name)
                        .color(.gray)
                        self.typeField
                        
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Marca")
                        .color(.gray)
                        self.brandField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Modelo")
                        .color(.gray)
                        self.modelField
                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("Serie")
                        .color(.gray)
                        self.serieField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)

                Div {

                    Div{
                        Label("Primer Nombre")
                        .color(.gray)
                        self.firstNameField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Segundo Nombre")
                        .color(.gray)
                        self.secondNameField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Primer Apellido")
                        .color(.gray)
                        self.lastNameField
                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("Segundo Apellido")
                        .color(.gray)
                        self.secondLastNameField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)

                Div {

                    Div{
                        Label("Calle y numero")
                        .color(.gray)
                        self.streetField
                    }
                    .width(50.percent)
                    .float(.left)


                    Div{
                        Label("Colonia")
                        .color(.gray)
                        self.colonyField
                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("Ciudad")
                        .color(.gray)
                        self.cityField

                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)

                Div {

                    Div{
                        Label("")
                        .color(.gray)
                        
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("")
                        .color(.gray)

                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("")
                        .color(.gray)

                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("")
                        .color(.gray)

                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)

                Div {

                    Div{
                        Label("Estado")
                        .color(.gray)
                        self.stateField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Codigo Postal")
                        .color(.gray)
                        self.zipField
                    }
                    .width(25.percent)
                    .float(.left)

                    Div{
                        Label("Pais")
                        .color(.gray)
                        self.countryField
                    }
                    .width(25.percent)
                    .float(.left)
                    
                    Div{
                        Label("Operador")
                        .color(.darkGoldenRod)
                        self.workedBySelect
                    }
                    .width(25.percent)
                    .float(.left)

                    Div().clear(.both)
                }

                Div().clear(.both).height(3)


            }
            .width(75.percent)
            .float(.left)
            
            Div{

                Label("Descripcion")
                .color(.gray)

                self.descriptionArea

                if self.posibleConflict {

                    Div().clear(.both)

                    Div{

                        Img()
                            .src("/skyline/media/icons_alert.png")
                            .marginRight(7.px)
                            .height(24.px)
                        
                        Span("Posible Orden Duplicada")
                            .fontSize(18.px)
                            .color(.red)
                    }
                }

                Div().clear(.both).height(3.px)

                Div {
                    Div("Remover")
                    .class( .uibtnLarge )
                    .onClick {
                        self.onRemove(self.item.id)
                    }
                }
                .align(.right)

            }
            .width(25.percent)
            .float(.left)

        }
        .class(.roundDarkBlue)
        .padding(all: 16.px)
        .marginBottom(12.px)
        .overflow(.hidden)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.loadUsers()

        if mobile == "" {
            mobile = telephone
        }

    }
    
    func loadUsers() {
        self.workedBySelect.innerHTML = ""
        self.workedBySelect.appendChild(
            Option("Seleccione Usuario")
                .value("")
        )
        
        getUsers(storeid: nil, onlyActive: true) { users in
            users.forEach { user in
                self.workedBySelect.appendChild(
                    Option(user.username)
                        .value(user.id.uuidString.lowercased())
                )
            }
            
            if !self.workedBy.isEmpty {
                return
            }
            
        }
    }
    
    func extractPayload() -> OrderExtractPayload {
        .init(
            id: self.item.id,
            idOne: self.idOne.trimmingCharacters(in: .whitespacesAndNewlines),
            idTwo: self.idTwo.trimmingCharacters(in: .whitespacesAndNewlines),
            firstName: self.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            secondName: self.secondName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: self.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
            secondLastName: self.secondLastName.trimmingCharacters(in: .whitespacesAndNewlines),
            serie: self.serie.trimmingCharacters(in: .whitespacesAndNewlines),
            type: self.type.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: self.brand.trimmingCharacters(in: .whitespacesAndNewlines),
            model: self.model.trimmingCharacters(in: .whitespacesAndNewlines),
            description: self.itemDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            mobile: self.mobile.trimmingCharacters(in: .whitespacesAndNewlines),
            telephone: self.telephone.trimmingCharacters(in: .whitespacesAndNewlines),
            email: self.email.trimmingCharacters(in: .whitespacesAndNewlines),
            street: self.street.trimmingCharacters(in: .whitespacesAndNewlines),
            colony: self.colony.trimmingCharacters(in: .whitespacesAndNewlines),
            city: self.city.trimmingCharacters(in: .whitespacesAndNewlines),
            state: self.state.trimmingCharacters(in: .whitespacesAndNewlines),
            country: self.country.trimmingCharacters(in: .whitespacesAndNewlines),
            zip: self.zip.trimmingCharacters(in: .whitespacesAndNewlines),
            latitude: Double(self.latitude.trimmingCharacters(in: .whitespacesAndNewlines)),
            longitud: Double(self.longitud.trimmingCharacters(in: .whitespacesAndNewlines)),
            posibleConflict: self.posibleConflict,
            storeId: self.item.storeId ?? custCatchStore,
            groopId: self.item.groopId,
            workedBy: UUID(uuidString: self.workedBy)
        )
    }
    
    func makeTextField<U>(_ value: U, placeholder: String) -> InputText where U: UniValue, U.UniValue == String {
        InputText(value)
            .autocomplete(.off)
            .placeholder(placeholder)
            .class(.textFiledBlackDark)
            .custom("width", "calc(100% - 18px)")
    }
    
    func field(_ title: String, _ input: InputText) -> Div {
        Div {
            Label(title)
                .color(.gray)
                .fontSize(16.px)
            
            Div().class(.clear).height(4.px)
            
            input
        }
        .width(33.percent)
        .float(.left)
        .marginBottom(10.px)
    }
    
    func selectField(_ title: String) -> Div {
        Div {
            Label(title)
                .color(.gray)
                .fontSize(16.px)
            
            Div().class(.clear).height(4.px)
            
            self.workedBySelect
        }
        .width(33.percent)
        .float(.left)
        .marginBottom(10.px)
    }
    
    static func parse(json: String) -> OrderExtractPayload? {
        guard let data = json.data(using: .utf8) else {
            return nil
        }
        
        return try? JSONDecoder().decode(OrderExtractPayload.self, from: data)
    }
    
    static func formatCoordinate(_ value: Double?) -> String {
        guard let value else {
            return ""
        }
        
        return value.description
    }
    
}
