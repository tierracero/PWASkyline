//
// CustConcession+BodegaDetailView.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class BodegaDetailView: Div {

        override class var name: String { "div" }

        let consetionId: UUID
        
        let consetionName: String
        
        let pocs: [CustPOCQuick]
        
        let items: [CustPOCInventorySoldObject]

        let bodega: CustStoreBodegasQuick

        let bodegas: [CustStoreBodegasQuick]

        private var relinquishItems: ((
            _ items: [CustPOCInventorySoldObject],
            _ alocatedTo: UUID?
        ) -> ())

        init(
            consetionId: UUID,
            consetionName: String,
            pocs: [CustPOCQuick],
            items: [CustPOCInventorySoldObject],
            bodega: CustStoreBodegasQuick,
            bodegas: [CustStoreBodegasQuick],
            relinquishItems: @escaping ((
                _ items: [CustPOCInventorySoldObject],
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.consetionId = consetionId
            self.consetionName = consetionName
            self.pocs = pocs
            self.items = items
            self.bodega = bodega
            self.bodegas = bodegas
            self.relinquishItems = relinquishItems
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

        @State var totalItemCount: Int = 0
        
        @State var totalItemAmount: Int64 = 0
        
        var pocRefrence: [UUID:CustPOCQuick] = [:]

        @State var codeFilter: String = ""
        
        lazy var codeFilterField = InputText(self.$codeFilter)
            .placeholder("POC/SKU/UPC")
            .class(.textFiledBlackDark)
            .marginRight(7.px)
            .width(250.px)
            .height(31.px)
            .float(.right)
        
        lazy var productDiv = Div()
            .custom("height", "calc(100% - 150px)")
            .class(.roundDarkBlue)
            .padding(all: 3.px)
            .overflow(.auto)
        
        @DOM override var body: DOM.Content {
            Div {

                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Concesión \(self.consetionName) | \(self.bodega.name)")
                        .color(.lightBlueText)
                        .height(35.px)
                    
                }
                
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
                                    .marginBottom(12.px)
                                    .padding(all: 3.px)
                                    .fontSize(18.px)

                                    Div(self.$totalItemCount.map{ $0.toString })
                                    .class(.oneLineText)
                                    .padding(all: 3.px)
                                    .fontSize(48.px)
                                    .align(.right)

                                    Div().clear(.both)

                                }
                                .width(30.percent)
                                .float(.left)

                                Div{

                                    Div("Precio Total")
                                    .class(.oneLineText)
                                    .marginBottom(12.px)
                                    .padding(all: 3.px)
                                    .fontSize(18.px)

                                    Div(self.$totalItemAmount.map{ $0.formatMoney })
                                    .class(.oneLineText)
                                    .padding(all: 3.px)
                                    .fontSize(48.px)
                                    .align(.right)

                                    Div().clear(.both)

                                }
                                .width(30.percent)
                                .fontSize(18.px)
                                .float(.left)
                                
                                Div{

                                    Div{
                                        Span("Mover a Bod.")
                                    }
                                    .margin(all: 7.px)
                                    .class(.uibtn)
                                    .float(.left)
                                    .onClick {
                                        self.moveItemsTo()
                                    }
                                    
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
                    .custom("height", "calc(100% - 35px)")
                    .margin(all: 3.px)
                }
                .height(100.percent)

            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(80.percent)
            .width(50.percent)
            .left(25.percent)
            .top(10.percent)
        }

        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.absolute)
            color(.white)
            left(0.px)
            top(0.px)

            self.pocRefrence = Dictionary(uniqueKeysWithValues: pocs.map{ value in ( value.id, value ) })
            
            self.itemsRefrence = Dictionary(uniqueKeysWithValues: items.map{ value in ( value.id, value ) })
            
            items.forEach { item in

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

        }
                    
        /// This function remove form UI items that where proceed out
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
            
            itemsRefrence = newItemsRefrence

            itemsPOCRefrence = newItemsPOCRefrence
            
            selectedItemsState = newSelectedItemsState
            
            processRecrenceItems()
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
                            Div("\(self.consetionName)")
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
                
                if let image = poc?.avatar {
                    
                    if !image.isEmpty {
                        
                        if let pDir = customerServiceProfile?.account.pDir {
                            
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
            
        func moveItemsTo() {
            
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
                showError(.errorGeneral, "Seleccione elementos para Mover")
                return
            }

            let view = ConfirmBodegaMovment(
                accountId: self.consetionId,
                bodega: self.bodega,
                bodegas: self.bodegas,
                selectedItems: selectedItems
            ) { items, to  in

                self.removeItemsFromConcession(ids: items.map( \.id ))

                self.relinquishItems(items, to)

            }
            
            addToDom(view)

            
        }

    }
}