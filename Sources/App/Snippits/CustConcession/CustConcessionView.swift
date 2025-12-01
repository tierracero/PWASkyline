//
//  CustConcessionView.swift
//
//
//  Created by Victor Cantu on 1/10/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CustConcessionView: Div {
    
    override class var name: String { "div" }
    
    let account: CustAcct

    var items: [CustPOCInventorySoldObject]
    
    var pocs: [CustPOCQuick]
    
    var managers: [CustInventoryPurchaseManager]

    var controls: [CustFiscalInventoryControl]
    
    @State  var sales: [CustSaleQuick]
    
    @State  var bodegas: [CustStoreBodegasQuick]

    init(
        account: CustAcct,
        items: [CustPOCInventorySoldObject],
        pocs: [CustPOCQuick],
        managers: [CustInventoryPurchaseManager],
        controls: [CustFiscalInventoryControl],
        sales: [CustSaleQuick],
        bodegas: [CustStoreBodegasQuick]
    ) {
        self.account = account
        self.items = items
        self.pocs = pocs
        self.managers = managers
        self.controls = controls
        self.sales = sales
        self.bodegas = bodegas
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    @State var hasAnyActiveElement: Bool = false

    //// CustPOCInventorySoldObject.id : isCheked
    @State var selectedItemsState: [UUID:State<Bool>] = [:]
    
    /// [ CustPOCInventorySoldObject.id : CustPOCInventorySoldObject ]
    @State var itemsRefrence: [UUID:CustPOCInventorySoldObject] = [:]
    
    /// [ CustPOCInventorySoldObject.POC : [CustPOCInventorySoldObject] ]
    @State var itemsPOCRefrence: [UUID:[CustPOCInventorySoldObject]] = [:]
    
    /// [ CustStoreBodega.id : [CustPOCInventorySoldObject] ]
    var itemsInBodegas: [ UUID : [CustPOCInventorySoldObject] ] = [:]

    @State var totalItemCount: Int = 0
    
    @State var totalItemAmount: Int64 = 0
    
    var pocRefrence: [UUID:CustPOCQuick] = [:]

    /// [ CustStoreBodegas.id: [CustStoreSeccionesQuickRef] ]
    var seccionRefrence: [ UUID: [CustStoreSeccionesQuickRef] ] = [:]
    
    @State var codeFilter: String = ""
    
    lazy var codeFilterField = InputText(self.$codeFilter)
        .placeholder("POC/SKU/UPC")
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .float(.right)
        .width(250.px)
        .height(31.px)
    
    lazy var productDiv = Div()
        .custom("height", "calc(100% - 100px)")
        .class(.roundDarkBlue)
        .padding(all: 3.px)
        .overflow(.auto)
    
    @State var sideView: SideView = .incomingView
    
    @State var sideViewSelectIsHiden: Bool = true

    lazy var sideMenuItems = Div()

    /// administartes: concession, purchases (includes manual purcases)
    @State var inItems: [ControlManager] = []

    /// unconcession, order, sold
    @State var outItems: [CustFiscalInventoryControl] = []

    /// merm
    @State var mermItems: [CustFiscalInventoryControl] = []
    
    var bodegaRefrence: [ UUID : BodegaView ] = [:]


    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Concesión") 
                    .marginLeft(7.px)
                    .color(.lightBlueText)
                
                Div().class(.clear)
            }
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                
                Div{
                    Div{
                        Table().noResult(label: "🛒 No hay articulos en concesion.")
                            .hidden(self.$hasAnyActiveElement)
                            .height(100.percent)
                        
                        Div{
                            
                            Div{
                                
                                H2(self.$itemsRefrence.map{ $0.count.toString })
                                    .marginRight(12.px)
                                    .color(.yellowTC)
                                    .float(.right)
                                
                                Img()
                                    .src("/skyline/media/icon_print.png")
                                    .marginRight(12.px)
                                    .class(.iconWhite)
                                    .float(.right)
                                    .height(24.px)
                                    .onClick {
                                        if self.itemsRefrence.isEmpty {
                                            return
                                        }
                                        
                                        self.printCurrentConcession()
                                        
                                    }
                                    .hidden(self.$itemsRefrence.map { $0.isEmpty })
                                
                                self.codeFilterField
                                
                                H2("Productos Actuales")
                                    .color(.white)
                                    .float(.left)
                                
                                Div().clear(.both)
                            }
                            
                            Div().clear(.both).height(7.px)
                            
                            self.productDiv
                            
                            Div().clear(.both).height(12.px)

                            Div{

                                Div{

                                    Div("Unidades Select.")
                                    .class(.oneLineText)
                                    .width(75.percent)
                                    .float(.left)

                                    Div(self.$totalItemCount.map{ $0.toString })
                                    .class(.oneLineText)
                                    .width(25.percent)
                                    .align(.right)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .width(30.percent)
                                .fontSize(18.px)
                                .float(.left)

                                Div{

                                    Div("Precio Total")
                                    .class(.oneLineText)
                                    .width(50.percent)
                                    .float(.left)

                                    Div(self.$totalItemAmount.map{ $0.formatMoney })
                                    .class(.oneLineText)
                                    .width(50.percent)
                                    .align(.right)
                                    .float(.left)

                                    Div().clear(.both)

                                }
                                .width(30.percent)
                                .fontSize(18.px)
                                .float(.left)
                                
                                Div{

                                    Div{
                                        Span("Vender")
                                    }
                                    .marginRight(7.px)
                                    .class(.uibtn)
                                    .float(.left)
                                    .onClick {
                                        self.removeFromConcession(isSale: true)
                                    }
                                    
                                    Div{
                                        Span("Devolución")
                                    }
                                    .marginRight(7.px)
                                    .class(.uibtn)
                                    .float(.left)
                                    .onClick {
                                        self.removeFromConcession(isSale: false)
                                    }
                                    
                                    Div().clear(.both)
                                }
                                .width(40.percent)
                                .align(.right)
                                .float(.left)

                                Div().clear(.both)
                            }

                        }
                        
                        .hidden(self.$hasAnyActiveElement.map{ !$0 })
                        .height(100.percent)
                        
                    }
                    .height(100.percent)
                    .margin(all: 3.px)
                }
                .height(100.percent)
                .width(60.percent)
                .float(.left)
                
                Div{

                    Div{

                        Div{

                            Div{
                                
                                Span(self.$sideView.map{ $0.documentableName })
                                
                                Div{
                                    Img()
                                        .src(self.$sideViewSelectIsHiden.map{ $0 ? "/skyline/media/dropDown.png" : "/skyline/media/dropDownClose.png"  })
                                        .class(.iconWhite)
                                        .paddingTop(7.px)
                                        .width(18.px)
                                }
                                .borderLeft(width: BorderWidthType.thin, style: .solid, color: .gray)
                                .paddingRight(3.px)
                                .paddingLeft(7.px)
                                .marginLeft(7.px)
                                .float(.right)
                                
                                Div().clear(.both)
                                
                            }
                            .width(250.px)
                            .class(.uibtn)
                            .float(.left)
                            .onClick { _, event in
                                self.sideViewSelectIsHiden = !self.sideViewSelectIsHiden
                                event.stopPropagation()
                            }

                            Img()
                                .src("skyline/media/history_color.png")
                                .marginRight(18.px)
                                .cursor(.pointer)
                                .height(24.px)
                                .float(.right)
                                .onClick {
                                    addToDom(ProductTransferReportView(reportType: .byConcessionaire(self.account)))
                                }
                            
                            Div().class(.clear)

                            Div()
                            .position(.absolute)
                            .height(100.percent)
                            .width(100.percent)
                            .left(0.px)
                            .top(0.px)
                            .hidden(self.$sideViewSelectIsHiden)
                            .onClick {
                                self.sideViewSelectIsHiden = true
                                $1.stopPropagation()
                            }

                            Div{
                                self.sideMenuItems
                            }
                            .hidden(self.$sideViewSelectIsHiden)
                            .backgroundColor(.transparentBlack)
                            .position(.absolute)
                            .borderRadius(12.px)
                            .padding(all: 3.px)
                            .margin(all: 3.px)
                            .marginTop(7.px)
                            .width(300.px)
                            .zIndex(1)
                            .onClick { _, event in
                                event.stopPropagation()
                            }

                        }
                        
                        Div().class(.clear).marginTop(3.px)

                        Div{
                            
                            Div{
                                Table().noResult(label: "🗳️ No existen conseciones")
                                    .hidden(self.$inItems.map{ !$0.isEmpty })
                                
                                ForEach(self.$inItems) { item in

                                    self.outItemDiv(item)
                                   
                                }
                                .hidden(self.$inItems.map{ $0.isEmpty })
                                
                            }
                            .hidden(self.$sideView.map{ $0 != .incomingView })
                            .height(100.percent)
                            .margin(all: 3.px)
                            
                            Div{

                                Table().noResult(label: "🗳️ No existen salidas")
                                    .hidden(self.$outItems.map{ !$0.isEmpty })

                                ForEach(self.$outItems) { control in

                                    self.controlItemDiv(control)
                                   
                                }
                                .hidden(self.$outItems.map{ $0.isEmpty })

                            }
                            .hidden(self.$sideView.map{ $0 != .outgoingView })
                            .height(100.percent)
                            .margin(all: 3.px)
                            
                            Div{
                                
                                Table().noResult(label: "🗳️  No existen ventas")
                                    .hidden(self.$sales.map{ !$0.isEmpty })
                                
                                ForEach(self.$sales) { sale in
                                    Div{
                                        
                                        Div(sale.total.formatMoney)
                                            .marginRight(3.px)
                                            .float(.right)
                                        
                                        Div(sale.folio)
                                            .marginRight(7.px)
                                            .float(.left)
                                        
                                        Div(getDate(sale.createdAt).formatedShort)
                                            .marginRight(7.px)
                                            .float(.left)
                                        
                                    }
                                    .class(.uibtnLarge)
                                    .width(97.percent)
                                    .onClick {
                                        addToDom(SalePointView.DetailView(saleId: .id(sale.id)))
                                    }
                                }
                                .hidden(self.$sales.map{ $0.isEmpty })
                                
                            }
                            .hidden(self.$sideView.map{ $0 != .salesView })
                            .height(100.percent)
                            .margin(all: 3.px)
                            
                            Div{

                                Table().noResult(label: "🗳️ No existen mermados")
                                    .hidden(self.$mermItems.map{ !$0.isEmpty })

                                ForEach(self.$mermItems) { control in

                                    self.controlItemDiv(control)
                                   
                                }
                                .hidden(self.$mermItems.map{ $0.isEmpty })
                                
                            }
                            .hidden(self.$sideView.map{ $0 != .otherView })
                            .height(100.percent)
                            .margin(all: 3.px)

                        }
                        .custom("height", "calc(50% - 35px)")
                        .class(.roundGrayBlackDark)
                        .overflow(.auto)
                        
                        Div().class(.clear).marginTop(3.px)
                    
                        Div{
                            
                            H2("Herramientas")
                                .float(.left)

                            Div().class(.clear).height(7.px)

                            Div{
    
                                Div{
                                     Img()
                                        .src("skyline/media/zoom.png")
                                        .marginRight(12.px)
                                        .cursor(.pointer)
                                        .height(18.px)

                                    Span("Auditar")
                                }
                                .custom("width", "calc(100% - 14px)")
                                .align(.center)
                                .class(.uibtn)

                                .onClick {
                                    addToDom(ProductManagerView.AuditView(auditType: .concessionaire(self.account)))
                                }
                            }
                            .width(50.percent)
                            .float(.left)

                                                           
                            Div{
                                Div{
                                     Img()
                                        .src("skyline/media/add.png")
                                        .marginRight(12.px)
                                        .cursor(.pointer)
                                        .height(18.px)

                                    Span("Agregar Manual")
                                }
                                .custom("width", "calc(100% - 14px)")
                                .align(.center)
                                .class(.uibtn)
                                .onClick {

                                    let view = StartManualInventory { name, vendor, profile in

                                            let view: CustConcessionView.AddManualInventorieView = AddManualInventorieView(
                                                account: self.account,
                                                newDocumentName: name,
                                                vendor: vendor,
                                                profile: profile,
                                                bodegas: self.bodegas
                                            )

                                            addToDom(view)

                                    }

                                    let date = Date()

                                    view.newDocumentName = " Ingreso a concession manual \(date.dateStamp)"

                                    addToDom(view)
                                    
                                }
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div().class(.clear).height(12.px)

                            Div{
                                Div{
                                     Img()
                                        .src("skyline/media/pencil.png")
                                        .marginRight(12.px)
                                        .cursor(.pointer)
                                        .height(18.px)

                                    Span("Agregar Bodega")
                                }
                                .custom("width", "calc(100% - 14px)")
                                .align(.center)
                                .class(.uibtn)
                                .onClick {
                                    
                                    let view: ManageBodegaView = .init(
                                        relationType: .consessioner(self.account.id),
                                        relationName: "Crear bodega para concesionario",
                                        loadBy: .createForConcession,
                                        onCreate: { bodega, _ in
                                        
                                            self.bodegas.append(.init(
                                                id: bodega.id,
                                                name: bodega.name
                                            ))

                                            
                                        },
                                        onUpdate: { id, name, _ in

                                            var bodegas: [CustStoreBodegasQuick] = []

                                            self.bodegas.forEach { bodega in
                                                
                                                if bodega.id  == id  {
                                                    
                                                    bodegas.append(.init(
                                                        id: id,
                                                        name: name
                                                    ) )

                                                    return
                                                }

                                                bodegas.append(bodega)

                                            }

                                            self.bodegas = bodegas

                                            let view = BodegaView(
                                                consetionId: self.account.id,
                                                consetionName: "Conseccion \(self.account.businessName)",
                                                bodega: .init(id: id, name: name)
                                            )

                                            self.productDiv.appendChild(view)

                                            self.bodegaRefrence[id] = view
                                            
                                        }
                                    )

                                    addToDom(view)

                                }
                            }
                            .width(50.percent)
                            .float(.left)
                            
                            Div{
                                
                            }
                            .width(50.percent)
                            .float(.left)

                            Div().class(.clear).height(7.px)


                        }
                        
                        Div().class(.clear).height(7.px)
                        
                    }
                    .height(100.percent)
                    .margin(all: 3.px)
                    
                }
                .height(100.percent)
                .width(40.percent)
                .float(.left)
                Div().class(.clear)
                 
            }
            .custom("height", "calc(100% - 37px)")
            
        }
        .custom("height","calc(100% - 50px)")
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(90.percent)
        .left(5.percent)
        .top(25.px)

    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        color(.white)
        left(0.px)
        top(0.px)

        SideView.allCases.forEach { item in
        
            let view = Div {
                Div(item.documentableName)
                .paddingRight(7.px)
                .paddingLeft(7.px)
                .width(95.percent)
                .class(.uibtn)
                .onClick {
                    self.sideView = item
                    self.sideViewSelectIsHiden = true
                }

                Div().height(7.px)

            }

            sideMenuItems.appendChild(view)

        }
        
        self.pocRefrence = Dictionary(uniqueKeysWithValues: pocs.map{ value in ( value.id, value ) })
        
        self.itemsRefrence = Dictionary(uniqueKeysWithValues: items.map{ value in ( value.id, value ) })
        
        items.forEach { item in

            if let bodegaId = item.alocatedTo {
                if let _ = itemsInBodegas[bodegaId]  {
                    itemsInBodegas[bodegaId]?.append(item)
                }
                else {
                    itemsInBodegas[bodegaId] = [item]
                }
                return
            }
            //

            if let _ = self.itemsPOCRefrence[item.POC] {
                self.itemsPOCRefrence[item.POC]?.append(item)
            }
            else {
                self.itemsPOCRefrence[item.POC] = [item]
            }
        }
        

        hasAnyActiveElement = ( !items.isEmpty || !bodegas.isEmpty)
        
        // MARK:  porceess CURRENT INVENTORIE items
        self.processRecrenceItems()

        // MARK: process DOCUMENTS

        let managerRefrence: [ UUID : CustInventoryPurchaseManager ] = Dictionary.init(uniqueKeysWithValues: managers.map{ ($0.id, $0) })
        
        var inoutItems: [ControlManagerItem] = []

        controls.forEach { control in

            print(control.disperseType.rawValue)

            switch control.disperseType {
                case .store:
                
                    /*
                    guard let managerId = control.managerId, let manager = managerRefrence[managerId] else {
                        fatalError("🔴  COULD NOT GET MANAGER \(control.disperseType.description)")
                    }

                    if  control.toStore == account.id {

                        inoutItems.append(.in coming(.init(
                            manager: manager,
                            control: control
                        )))

                    }
                    else {

                        inoutItems.append(.out going(.init(
                            manager: manager,
                            control: control
                        )))

                    }*/

                    fatalError("\(control.disperseType.description) is not a case senerio that should apply to a concessioner")

                case .order:

                    inoutItems.append(.outevent(.sale(control)))

                case .sold:

                    inoutItems.append(.outevent(.order(control)))

                case .merm:

                    inoutItems.append(.outevent(.merm(control)))
                    
                case .returnToVendor, .missingFromVendor:
                    /*

                    guard let managerId = control.managerId, let manager = managerRefrence[managerId] else {
                        fatalError("🔴  COULD NOT GET MANAGER \(control.disperseType.description)")
                    }

                    inoutItems.append(.out going(.init(
                        manager: manager,
                        control: control
                    )))
                    
                    */
                    fatalError("\(control.disperseType.description) is not a case senerio that should apply to a concessioner")

                case .concession:

                    var manager: CustInventoryPurchaseManager? = nil

                    if let managerId = control.managerId {
                        manager = managerRefrence[managerId]
                    }

                    inoutItems.append(.concession(.init(
                        manager: manager,
                        control: control
                    )))

                case .unconcession:
                    
                    inoutItems.append(.outevent(.unconcession(control)))

            }
        
        }

        /// administartes: concession, purchases (includes manual purcases)
        var inItems: [ControlManager] = []

        /// unconcession, order, sold
        var outItems: [CustFiscalInventoryControl] = []

        /// merm
        var mermItems: [CustFiscalInventoryControl] = []

        inoutItems.forEach { io in 
            switch io  {
                /// let item: ControlManager
                /// concession, purchases (includes manual purchases)
                case .concession(let  item):
                
                inItems.append(item)

                /// let item: ControlManagerOutEvent
                /// merm, unconcession, sale, order
                case .outevent(let item):
                
                    switch item {
                    /// let control: CustFiscalInventoryControl
                    case .merm (let control):

                        mermItems.append(control)

                    /// let control: CustFiscalInventoryControl
                    case .unconcession (let control):

                        outItems.append(control)
                    
                    /// let control: CustFiscalInventoryControl
                    case .sale (let control):

                        outItems.append(control)

                    /// let control: CustFiscalInventoryControl
                    case .order (let control):

                        outItems.append(control)
                    
                    }

                }
        }

        self.inItems = inItems

        self.outItems = outItems

        self.mermItems = mermItems

    }
    
    func processRecrenceItems(){
        
        self.productDiv.innerHTML = ""
        
        itemsPOCRefrence.forEach { pocId, items in
            
            let poc = self.pocRefrence[pocId]
            
            var avatar = "/skyline/media/skylineapp.svg"
            
            var url = ""
            
            var mainAvatar = ""
            
            if let image = poc?.avatar {
                
                if !image.isEmpty {
                    
                    if let pDir = customerServiceProfile?.account.pDir {
                        
                        url = "https://intratc.co/cdn/\(pDir)/"
                        
                        mainAvatar = image
                        
                        avatar = "https://intratc.co/cdn/\(pDir)/thump_\(image)"
                    }
                    
                }
                
            }
            
            let total: Int64 = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +)
            
            @State var itemsCount = "0"
            
            @State var viewItemsHidden = true
            
            $itemsCount.listen {
                self.calculateSelectedItems()
            }
            
            let table: Table = Table{
                THead {
                    Tr{
                        Td{
                            InputText($itemsCount)
                                .textAlign(.right)
                                .onKeyDown({ tf, event in
                                    
                                    print(event.key)
                                    
                                    guard let _ = Float(event.key) else {
                                        if !ignoredKeys.contains(event.key) {
                                            event.preventDefault()
                                        }
                                        return
                                    }
                                })
                                .onFocus { tf in
                                    tf.select()
                                }
                                .width(50)
                                .onBlur { tf, _ in
                                    
                                    items.forEach { item in
                                        self.selectedItemsState[item.id]?.wrappedValue = false
                                    }
                                    
                                    guard var int = Int(tf.text) else {
                                        return
                                    }
                                    
                                    if int > items.count {
                                        int = items.count
                                        itemsCount = int.toString
                                    }
                                    
                                    items.forEach { item in
                                        
                                        if int <= 0 {
                                            return
                                        }
                                        
                                        self.selectedItemsState[item.id]?.wrappedValue = true
                                        
                                        int -= 1
                                        
                                    }
                                    
                                    self.calculateSelectedItems()
                                    
                                }
                        }
                        Td("POC/SKU/UPC")
                        Td("Marca")
                        Td("Modelo")
                        Td("Nombre")
                        Td("Unis.")
                        Td("Costo")
                        Td{
                            Img()
                                .src($viewItemsHidden.map{ $0 ?  "/skyline/media/dropDownClose.png" : "/skyline/media/dropDown.png" })
                                .class(.iconWhite)
                                .height(24.px)
                                .width(24.px)
                                .onClick {
                                    viewItemsHidden = !viewItemsHidden
                                }
                        }
                    }
                    Tr{
                        Td{
                            Img()
                                .src(avatar)
                                .cursor( { url.isEmpty ? .default : .pointer }())
                                .height(28.px)
                                .width(28.px)
                                .onClick {
                                    
                                    if url.isEmpty {
                                        return
                                    }
                                    
                                    addToDom(MediaViewer(
                                        relid: nil,
                                        type: .product,
                                        url: url,
                                        files: [.init(
                                            fileId: nil,
                                            file: mainAvatar,
                                            avatar: mainAvatar,
                                            type: .image
                                        )],
                                        currentView: 0
                                    ))
                                }
                        }.align(.center)
                        Td(poc?.upc ?? "")
                        Td(poc?.brand ?? "")
                        Td(poc?.model ?? "")
                        Td(poc?.name ?? "")
                        Td(items.count.toString)
                        Td(total.formatMoney)
                            .align(.center)
                            .colSpan(2)
                    }
                }
            }
            .width(100.percent)
            .color(.white)
            .hidden($codeFilter.map{
                
                guard let upc = poc?.upc.lowercased() else {
                    return false
                }
                
                guard let name = poc?.name.lowercased() else {
                    return false
                }
                
                guard let model = poc?.model.lowercased() else {
                    return false
                }
                
                if upc.isEmpty {
                    return false
                }
                
                let term = $0.lowercased()
                
                if $0.isEmpty {
                    return false
                } else if upc.hasPrefix(term) || name.hasPrefix(term) || model.hasPrefix(term) {
                    return false
                }
                else if upc.hasSuffix(term)  || name.hasSuffix(term) || model.hasSuffix(term) {
                   return false
                }
                else if upc == term || name == term || model == term {
                   return false
                }
                
                return true
            })
            
            let tableBody = TBody ().hidden($viewItemsHidden)
            
            items.forEach { item in
                
                @State var isSelected = false
                
                @State var soldPrice: Int64? = item.soldPrice
                
                self.selectedItemsState[item.id] = $isSelected
                
                tableBody.appendChild(
                    Tr{
                        Td{
                            InputCheckbox($isSelected)
                                .onChange { _, cb in
                                    
                                    guard var int = Int(itemsCount) else {
                                        return
                                    }
                                    
                                    if cb.checked {
                                        int += 1
                                    }
                                    else {
                                        int -= 1
                                    }
                                    
                                    itemsCount = int.toString
                                }
                        }.align(.center)
                        Td("SERIE:")
                        Td("\(item.id.suffix)\({item.series.isEmpty ? "" : " - \(item.series)" }())").colSpan(3)
                        Td{
                            Img()
                                .src("/skyline/media/maximizeWindow.png")
                                .class(.iconWhite)
                                .cursor(.pointer)
                                .height(18.px)
                                .onClick {
                                    let view = InventoryItemDetailView(itemid: item.id){ price in
                                        
                                        soldPrice = price
                                        
                                        self.itemsRefrence[item.id]?.soldPrice = price
                                        
                                        if let _items = self.itemsPOCRefrence[item.POC] {
                                            var nitems: [CustPOCInventorySoldObject] = []
                                            
                                            
                                            _items.forEach { _item in
                                                var _item = _item
                                                
                                                if item.id == _item.id {
                                                    _item.soldPrice = price
                                                }
                                                
                                                nitems.append(_item)
                                            }
                                            
                                            self.itemsPOCRefrence[item.POC] = nitems
                                            
                                        }
                                        
                                    }
                                    addToDom(view)
                                }
                        }
                        .align(.center)
                        Td($soldPrice.map{ $0?.formatMoney ?? "" })
                            .align(.center)
                            .colSpan(2)
                        
                    }
                )
                
            }
            
            table.appendChild(tableBody)
            
            self.productDiv.appendChild(table)
            
        }

        bodegas.forEach{ bodega in 

            let view = BodegaView(
                consetionId: self.account.id,
                consetionName: "Conseccion \(self.account.businessName)",
                bodega: bodega
            )

            productDiv.appendChild(view)

            bodegaRefrence[bodega.id] = view
            
        }
    
//     var bodegaRefrence: [ UUID : BodegaView ] = [:]
// takeInItems
        itemsInBodegas.forEach { bodegaId, items in

            guard let view = bodegaRefrence[bodegaId] else {
                showError(.errorGeneral, "No se puco localizr una de las bodegas, refresque e eintente de nuevo. Si el problema persiste contacte a soporte.")
                return
            }

            view.takeInItems(items: items)

        }
    }
    
    func calculateSelectedItems(){
        
        var soldPrices: [Int64] = []
        
        selectedItemsState.forEach { itemId, state in
            
            if state.wrappedValue {
                
                guard let item = itemsRefrence[itemId] else {
                    return
                }
                
                soldPrices.append(item.soldPrice ?? 0)
            }
            
        }
        
        totalItemCount = soldPrices.count
        
        totalItemAmount = soldPrices.reduce(0, +)
        
    }
    
    func printCurrentConcession(){
        
        var logo = ""
        
        if let custWebFilesLogos {
            if !custWebFilesLogos.logoIndexWhite.avatar.isEmpty {
                logo = "https://\(custCatchUrl)/contenido/\(custWebFilesLogos.logoIndexWhite.avatar)"
            }
        }
        
        let container = Div{
            Table{
                Tr{
                    Td{
                        if !logo.isEmpty {
                            Img()
                                .src(logo)
                                .height(45.px)
                        }
                    }
                    Td{
                        Div("\(self.account.fiscalRfc) \(self.account.fiscalRazon)")
                            .textAlign(.center)
                    }
                    Td{
                        getDate().formatedLong
                    }
                }
            }
            .width(100.percent)
        }
        
        itemsPOCRefrence.forEach { pocId, items in
            
            let poc = self.pocRefrence[pocId]
            
            var avatar = "/skyline/media/skylineapp.svg"
            
//            var url = ""
            
            //var mainAvatar = ""
            
            if let image = poc?.avatar {
                
                if !image.isEmpty {
                    
                    if let pDir = customerServiceProfile?.account.pDir {
                        
                        // url = "https://intratc.co/cdn/\(pDir)/"
                        
                        // mainAvatar = image
                        
                        avatar = "https://intratc.co/cdn/\(pDir)/thump_\(image)"
                    }
                    
                }
                
            }
            
            let total: Int64 = items.map{ ($0.soldPrice ?? 0) }.reduce(0, +)
            
            var table = Table{
                THead {
                    Tr{
                        Td()
                        Td("POC/SKU/UPC")
                        Td("Marca")
                        Td("Modelo")
                        Td("Nombre")
                        Td("Unis.")
                        Td("Costo")
                    }
                    Tr{
                        Td{
                            Img()
                                .src(avatar)
                                .height(28.px)
                                .width(28.px)
                        }.align(.center)
                        Td(poc?.upc ?? "")
                        Td(poc?.brand ?? "")
                        Td(poc?.model ?? "")
                        Td(poc?.name ?? "")
                        Td(items.count.toString)
                        Td(total.formatMoney)
                            .align(.center)
                            .colSpan(2)
                    }
                }
            }
            .width(100.percent)
            
            let tableBody = TBody ()
            
            items.forEach { item in
                
                tableBody.appendChild(
                    Tr{
                        Td("SERIE:").colSpan(2)
                        Td(item.series).colSpan(3)
                        Td((item.soldPrice ?? 0).formatMoney)
                            .align(.center)
                            .colSpan(2)
                        
                    }
                )
                
            }
            
            table.appendChild(tableBody)
            
            container.appendChild(table)
            
        }
        
        container.appendChild(H2("Resumen"))
        
        container.appendChild(Div{
            Table{
                Tr{
                    Td("Total de unidades")
                        .width(25.percent)
                    Td(self.totalItemCount.toString)
                        .width(25.percent)
                    Td("Precio Total")
                        .width(25.percent)
                    Td(self.totalItemAmount.formatMoney)
                        .width(25.percent)
                }
            }
            .width(100.percent)
        })
        
        generalPrint(body: container.innerHTML)
        
    }
    
    func downloadCurrentConcession(){
        
    }
    
    func removeFromConcession(isSale: Bool){
        
        var selectedItems:[CustPOCInventorySoldObject] = []
        
        var hasError = false
        
        selectedItemsState.forEach { itemId, state in
            if state.wrappedValue {
                
                guard let item = itemsRefrence[itemId] else {
                    hasError = true
                    return
                }
                selectedItems.append(item)
            }
        }
        
        if hasError {
            showError(.errorGeneral, "Hay inconsistencias en la peticion, refresque la pantalla e intente de nuevo.")
            return
        }
        
        if selectedItems.isEmpty {
            showError(.errorGeneral, "Seleccione elementos para \({ isSale ? "la venta" : "la devolución" }()).")
            return
        }
        
        let view = CustRemoveFromConcessionView(
            account: self.account,
            isSale: isSale,
            pocRefrence: pocRefrence,
            items: selectedItems
        ){ ids, control in
            
            if let control {
                self.controls.insert(control, at: 0)
            }
            
            self.removeItemsFromConcession(ids: ids)
        }
        
        addToDom(view)
        
    }
    
    func openConcession(controlId: UUID) {
        
        loadingView(show: true)
        
        API.custPOCV1.getTransferInventory(identifier: .id(controlId)) { resp in
            
            loadingView(show: false)
            
            guard let resp = resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }

            guard resp.status == .ok else{
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, "No se pudo obtener documento")
                return
            }
            
            addToDom(InventoryControlView(
                control: data.control,
                items: data.items,
                pocs: data.pocs,
                places: data.places,
                notes: data.notes,
                fromStore: data.fromStore,
                toStore: data.toStore,
                hasRecived: {
                    
                },
                hasIngressed: {
                    
                })
            )
            
        }
        
    }
    
    func removeItemsFromConcession(ids: [UUID]){
        
        totalItemCount = 0
         
        totalItemAmount = 0
        
        var newSelectedItemsState: [UUID:State<Bool>] = selectedItemsState
        
        var newItemsRefrence: [UUID:CustPOCInventorySoldObject] = itemsRefrence
        
        var newItemsPOCRefrence: [UUID:[CustPOCInventorySoldObject]] = [:]
        
        itemsPOCRefrence.forEach { pocIds, items in
            
            var newItems: [CustPOCInventorySoldObject] = []
            
            items.forEach { item in
                if ids.contains(item.id) {
                    return
                }
                newItems.append(item)
            }
            
            newItemsPOCRefrence[pocIds] = newItems
            
        }
        
        ids.forEach { id in
            newSelectedItemsState.removeValue(forKey: id)
            newItemsRefrence.removeValue(forKey: id)
        }
        
        itemsPOCRefrence = newItemsPOCRefrence
        
        selectedItemsState = newSelectedItemsState
        
        processRecrenceItems()
    }
    
}

extension CustConcessionView {
            
    enum SideView: String, CaseIterable {

        /// administartes concession, purchases
        /// 
        case incomingView

        /// unconcession,  order, sold
        case outgoingView

        case salesView

        /// merm
        case otherView

        var documentableName: String {
            switch self {                
            case .incomingView:
                return "Entradas"
            case .outgoingView:
                return "Salidas"
            case .salesView:
                return "Lista de Ventas"
            case .otherView:
                return "Otras"
            }
        }

    }

    struct ControlManager: Hashable, Equatable{

        private let id: UUID

        let manager: CustInventoryPurchaseManager?

        let control:  CustFiscalInventoryControl
        
        init(
            manager: CustInventoryPurchaseManager?,
            control:  CustFiscalInventoryControl
        ) {
            self.id = .init()
            self.manager = manager
            self.control = control
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash (into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    struct SaleItem {

        let sale: CustSaleQuick

        let control:  CustFiscalInventoryControl
        
        init(
            sale: CustSaleQuick,
            control:  CustFiscalInventoryControl
        ) {
            self.sale = sale
            self.control = control
        }
    }

    /// merm, unconcession, sale, order
    enum ControlManagerOutEvent {

        case merm (CustFiscalInventoryControl)

        case unconcession (CustFiscalInventoryControl)

        case sale (CustFiscalInventoryControl)

        case order (CustFiscalInventoryControl)

    }

    enum ControlManagerItem {

        /// concession, purchases (includes manual purchases)
        case concession (ControlManager)

        /// merm, unconcession, sale, order
        case outevent (ControlManagerOutEvent)

    }

    func  outItemDiv(_ item: ControlManager) -> Div {

        let control = item.control 

        return  Div{
            
            if let manager = item.manager {

                Div{
                    
                    Div{
                            
                        Div{

                            Div("Tipo de adquisición:")
                            .marginBottom(3.px)
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .color(.gray)

                            Div(manager.type.description)
                            .class(.oneLineText)
                            .fontSize(18.px)

                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            
                            Div("Folio de adquisición:")
                            .marginBottom(3.px)
                            .class(.oneLineText)
                            .fontSize(12.px)
                            .color(.gray)

                            Div(manager.folio)
                            .class(.oneLineText)
                            .fontSize(18.px)

                        }
                        .width(50.percent)
                        .float(.left)

                    }
                }

                Div()
                .borderBottom(width: .thin, style: .solid, color: .init(r: 64, g: 64, b: 64))
                .height(3.px)
                .clear(.both)

                Div()
                .height(3.px)
                .clear(.both)

            }

            Div{

                Div {
                    Div{

                        Div("Folio de Control:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.folio)
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .custom("width", "calc(50% - 50px)")
                    .float(.left)

                    Div{
                        
                        Div("Fecha:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(getDate(control.createdAt).formatedShort)
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .custom("width", "calc(50% - 50px)")
                    .float(.left)

                    Div{
                        
                        Div("Unis:")
                        .marginBottom(3.px)
                        .fontSize(12.px)
                        .align(.right)
                        .color(.gray)

                        Div(control.items.count.toString)
                        .class(.oneLineText)
                        .fontSize(18.px)
                        .align(.right)

                    }
                    .width(100.px)
                    .float(.left)                    
                }

                Div().clear(.both).height(3.px)

                Div{

                        Div("Nombre:")
                        .marginBottom(3.px)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.description)
                        .class(.oneLineText)
                        .fontSize(18.px)
                }
            
                Div().clear(.both).height(3.px)

                Div{

                    Div{

                        Div("Serie Externa:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.vendorSerie ?? "N/A")
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div{

                        Div("Folio Externa:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.vendorFolio ?? "N/A")
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .width(50.percent)
                    .float(.left)

                }

            }

        }
        .custom("width", "calc(100% - 32px)")
        .padding(all: 7.px)
        .margin(all: 7.px)
        .marginBottom(12.px)
        .class(.uibtnLarge)
        .onClick {
            self.openConcession(controlId: item.control.id)
        }
    }
    
    func  controlItemDiv(_ control: CustFiscalInventoryControl) -> Div {

        return  Div{
            
            Div{

                Div {
                    Div{

                        Div("Folio de Control:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.folio)
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .custom("width", "calc(50% - 50px)")
                    .float(.left)

                    Div{
                        
                        Div("Fecha:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(getDate(control.createdAt).formatedShort)
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .custom("width", "calc(50% - 50px)")
                    .float(.left)

                    Div{
                        
                        Div("Unis:")
                        .marginBottom(3.px)
                        .fontSize(12.px)
                        .align(.right)
                        .color(.gray)

                        Div(control.items.count.toString)
                        .class(.oneLineText)
                        .fontSize(18.px)
                        .align(.right)

                    }
                    .width(100.px)
                    .float(.left)                    
                }

                Div().clear(.both).height(3.px)

                Div{

                        Div("Nombre:")
                        .marginBottom(3.px)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.description)
                        .class(.oneLineText)
                        .fontSize(18.px)
                }
            
                Div().clear(.both).height(3.px)

                Div{

                    Div{

                        Div("Serie Externa:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.vendorSerie ?? "N/A")
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .width(50.percent)
                    .float(.left)

                    Div{

                        Div("Folio Externa:")
                        .marginBottom(3.px)
                        .class(.oneLineText)
                        .fontSize(12.px)
                        .color(.gray)

                        Div(control.vendorFolio ?? "N/A")
                        .class(.oneLineText)
                        .fontSize(18.px)

                    }
                    .width(50.percent)
                    .float(.left)

                }

            }

        }
        .custom("width", "calc(100% - 32px)")
        .padding(all: 7.px)
        .margin(all: 7.px)
        .marginBottom(12.px)
        .class(.uibtnLarge)
        .onClick {
            self.openConcession(controlId: control.id)
        }
    }

}
