//
//  OrderRoute+CreateView.swift
//
//
//  Created by Victor Cantu on 11/12/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderRouteView{
    class CreateView: Div {
        
        override class var name: String { "div" }
        
        /// [ CustOrder.id :  OrderRowView]
        var orders: [CustOrderLoadFolios]
        
        private var addRoute: ((
            _ addedOrders: [UUID],
            _ route: CustOrderRoute
        ) -> ())
        
        init(
            orders: [CustOrderLoadFolios],
            addRoute: @escaping ((
                _ addedOrders: [UUID],
                _ route: CustOrderRoute
            ) -> ())
        ) {
            self.orders = orders
            self.addRoute = addRoute
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var items: [API.custRouteV1.OrderRouteItem] = []
        
        @State var name: String? = nil
        
        @State var day: String? = nil
        
        @State var month: String? = nil
        
        @State var year: String? = nil
        
        @State var initialTime: String? = nil
        
        @State var endingTime: String? = nil
        
        @State var mapInitiated: Bool = false
        
        var supervisor: UUID? = nil
        
        var assignUsers: [UUID] = []
        
        var travel: Int64 = 0
        
        var distance: Int64 = 0
        
        lazy var addRouteButton = Div{
            
            Div{
                Img()
                    .src("/skyline/media/addBlueIcon.png")
                    .marginRight(12.px)
                    .marginLeft(12.px)
                    .marginTop(9.px)
                    .height(33.px)
                    .width(33.px)
            }
            .align(.center)
            
            Div("Orden")
                .fontSize(14.px)
                .align(.center)
            
        }
        .class(.uibtn, .roundBlue)
        .borderRadius(50.percent)
        .position(.absolute)
        .cursor(.pointer)
        .bottom(40.px)
        .right(20.px)
        .height(67.px)
        .width(67.px)
        .onClick {
            self.searchOrder()
        }
        
        lazy var mapContainer = Div()
        .id(.init("routeMap"))
        .height(100.percent)
        .width(65.percent)
        .float(.left)
        
        lazy var itemsContainer = Ul()
            .id(.init("mapItemDivContainer"))
            .height(100.percent)

        @DOM override var body: DOM.Content {
            Div{
                // MARK: Header
                Div{
                    
                    Img()
                        .closeButton(.view)
                        .onClick{
                            let _ = JSObject.global.removeAppleMapRought!()
                            self.remove()
                        }
                    
                    Div("Imprimir")
                        .marginRight(7.px)
                        .class(.uibtn)
                        .float(.right)
                        .onClick {
                            let _ = JSObject.global.print!()
                        }
                    
                    H2("Crear Nueva Ruta")
                        .color(.lightBlueText)
                        .marginRight(7.px)
                        .float(.left)
                    
                    H2(self.$name.map{ $0 ?? "" })
                        .hidden(self.$name.map{ ($0 == nil) })
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.left)
                    
                    H2(self.$day.map{ $0 ?? "" })
                        .hidden(self.$day.map{ ($0 == nil) })
                        .color(.lightGray)
                        .float(.left)
                    
                    H2("/")
                        .hidden(self.$day.map{ ($0 == nil) })
                        .color(.lightGray)
                        .float(.left)
                    
                    H2(self.$month.map{ $0 ?? "" })
                        .hidden(self.$month.map{ ($0 == nil) })
                        .color(.lightGray)
                        .float(.left)
                    
                    H2("/")
                        .hidden(self.$month.map{ ($0 == nil) })
                        .color(.lightGray)
                        .float(.left)
                    
                    H2(self.$year.map{ $0 ?? "" })
                        .hidden(self.$year.map{ ($0 == nil) })
                        .marginRight(7.px)
                        .color(.lightGray)
                        .float(.left)
                    
                    H2(self.$initialTime.map{ $0 ?? "" })
                        .hidden(self.$initialTime.map{ ($0 == nil) })
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.left)
                    
                    H2("-")
                        .hidden(self.$initialTime.map{ ($0 == nil) })
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.left)
                    
                    H2(self.$endingTime.map{ $0 ?? "" })
                        .hidden(self.$endingTime.map{ ($0 == nil) })
                        .color(.lightGray)
                        .marginRight(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).marginTop(7.px)
                
                // MARK: Body
                Div{
                    Div{
                        Div{
                            
                            H2("Direcciones")
                                .color(.lightBlueText)
                            
                            Div{
                                self.itemsContainer
                            }
                            .custom("height", "calc(100% - 80px)")
                            .class(.roundDarkBlue)
                            
                            Div("Crear Ruta")
                                .custom("width", "calc(100% - 15px)")
                                .class(.uibtnLargeOrange)
                                .textAlign(.center)
                                .cursor(.default)
                                .opacity(0.3)
                                .hidden(self.$items.map{ !$0.isEmpty })
                            
                            Div("Crear Ruta")
                                .custom("width", "calc(100% - 15px)")
                                .class(.uibtnLargeOrange)
                                .textAlign(.center)
                                .hidden(self.$items.map{ $0.isEmpty })
                                .onClick {
                                    self.createRoute()
                                }
                            
                        }
                        .custom("width", "calc(33% - 55px)")
                        .height(100.percent)
                        .marginRight(7.px)
                        .float(.left)
                        
                        self.mapContainer
                        
                        Div().clear(.both)
                        
                    }
                    .hidden(self.$mapInitiated.map{ !$0 })
                    .height(100.percent)
                    .width(100.percent)
                    
                    Table().noResult(label: "🗺️ Seleccione orden para iniciar map.")
                        .hidden(self.$mapInitiated)
                    
                }
                .custom("height", "calc(100% - 35px)")
                
                self.addRouteButton
                
            }
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .padding(all: 12.px)
            .position(.absolute)
            .height(90.percent)
            .width(90.percent)
            .left(5.percent)
            .top(5.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            super.buildUI()
            
            $items.listen {
                self.initiateMap()
                self.redrawMapItems()
            }
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            addBasicData{
                self.searchOrder()
            }
            
            let _ = JSObject.global.initiateMapItemDivContainer!(JSClosure { args in
                
                if let json = args.first?.string {
                    
                    guard let data = json.data(using: .utf8) else {
                        showError(.unexpectedResult, "No se pudo actualizar mapa, error al converto hilo a data.")
                        return .undefined
                    }
                    
                    do {
                        
                        let ids = try JSONDecoder().decode([UUID].self, from: data)
                        
                        var items: [API.custRouteV1.OrderRouteItem] = []
                        
                        var itemRefrence: [ UUID : API.custRouteV1.OrderRouteItem ] = Dictionary.init(uniqueKeysWithValues: self.items.map{ ($0.orderId, $0) })
                        
                        ids.forEach { id in
                            
                            guard let item = itemRefrence[id] else {
                                return
                            }
                            
                            items.append(item)
                            
                        }
                        
                        self.items = items
                        
                    }
                    catch {
                        showError(.unexpectedResult, "No se pudo iniciar mapa, error al converto data a objeto.")
                    }
                    
                }
                
                return .undefined
            })
            
        }
        
        func addBasicData( callback: ( () -> ())? = nil ) {
            
            let view = BasicDataView(
                name: name,
                day: day,
                month: month,
                year: year,
                initialTime: initialTime,
                endingTime: endingTime,
                supervisor: supervisor,
                assignUsers: assignUsers
            ) { name, day, month, year, initialTime, endingTime, supervisor, assignUsers in
                self.name = name
                self.day = day
                self.month = month
                self.year = year
                self.initialTime = initialTime
                self.endingTime = endingTime
                self.supervisor = supervisor
                self.assignUsers = assignUsers
                if let callback {
                    callback()
                }
            }
            
            addToDom(view)
            
        }
        
        func searchOrder() {
            
            if name == nil {
                addBasicData {
                    self.searchOrder()
                }
                return
            }
            
            let view = SelectOrderView(
                selectedOrderFolio: nil,
                currentOrderIds: self.items.map{ $0.orderId }
            ) { item in
                
                var orders: [CustOrderLoadFolios] = []
                
                self.orders.forEach { currentOrders in
                    
                    if currentOrders.id == item.orderId {
                        return
                    }
                    
                    orders.append(currentOrders)
                    
                }
                
                self.orders = orders
                
                self.items.append(item)
                
            }
            
            addToDom(view)
            
        }
        
        func initiateMap(){
            
            if !mapInitiated {
                
                loadingView(show: true)
                
                API.v1.jwt { token in
                    
                    guard let token else {
                        loadingView(show: false)
                        showError(.errorDeCommunicacion, "No se pudo cargar token")
                        return
                    }
                    
                    self.mapContainer.innerHTML = ""
                        
                    let _ = JSObject.global.initiatAppleMaps!("routeMap", token, JSOneshotClosure { _ in
                        
                        loadingView(show: false)
                        
                        Dispatch.asyncAfter(0.3) {
                            
                            self.processMap()
                            
                        }
                        
                        return .undefined
                    })
                }
            }
            else {
                self.processMap()
            }
        }
        
        func processMap() {
            
            do {
                let data = try JSONEncoder().encode(items)
                
                guard let json = String(data: data, encoding: .utf8) else {
                    showError(.unexpectedResult, "No se pudo iniciar mapa, error al convertir data a hilo.")
                    return
                }
                
                //self.mapContainer.innerHTML = ""
                    
                mapInitiated = true
                
                /// loadAppleMap(mapId, locations, updateCoordinate)
                let _ = JSObject.global.loadAppleMapRought!("routeMap", json, "[]", JSClosure { args in
                    
                    loadingView(show: false)
                    
                    if let json = args.first?.string {
                        self.updateCoordanate(json)
                    }
                    
                    
                    return .undefined
                })
                
            }
            catch  {
                showError(.unexpectedResult, "No se pudo iniciar mapa, error al converto objeto a data.")
            }
        }
        
        func updateCoordanate(_ json: String) {
            print("🟢  updateCoordanate")
            
            print(json)
            
            struct UpdateCoordinate: Codable {
                let orderId: UUID
                let latitude: Double
                let longitude: Double
            }
            
            guard let data = json.data(using: .utf8) else {
                showError(.unexpectedResult, "No se pudo actualizar mapa, error al converto hilo a data.")
                return
            }
            
            do {
                let update = try JSONDecoder().decode(UpdateCoordinate.self, from: data)
             
                var items: [API.custRouteV1.OrderRouteItem] = []
                
                self.items.forEach { item in
                    if item.orderId == update.orderId {
                        items.append(.init(
                            orderId: item.orderId,
                            folio: item.folio,
                            name: item.name,
                            street: item.street,
                            colony: item.colony,
                            city: item.city,
                            state: item.state,
                            country: item.country,
                            zip: item.zip,
                            latitude: update.latitude,
                            longitude: update.longitude
                        ))
                    }
                    else {
                        items.append(item)
                    }
                }
                
                self.items = items
                
            }
            catch  {
                showError(.unexpectedResult, "No se pudo iniciar mapa, error al converto data a objeto.")
            }
            
            
        }
        
        func redrawMapItems(){
            
            itemsContainer.innerHTML = ""
            
            items.forEach { item in
                itemsContainer.appendChild(
                    Li{
                        
                        Div{
                            
                            InputHidden()
                                .value(item.orderId.uuidString)
                                .class(.mapItemObject)
                            
                            H3("\(item.folio.explode("-").last ?? item.folio) \(item.name)")
                                .class(.oneLineText)
                            
                            Div("\(item.colony) \(item.zip)")
                                .class(.oneLineText)
                                .color(.gray)
                            
                            Div().clear(.both)
                            
                        }
                        .custom("width", "calc(100% - 35px)")
                        .float(.left)
                        
                        Div{
                            Table{
                                Tr{
                                    Td{
                                        Img()
                                            .src("/skyline/media/cross.png")
                                            .marginRight(7.px)
                                            .cursor(.pointer)
                                            .height(18.px)
                                            .onClick {
                                                self.removeItem(item.orderId)
                                            }
                                    }
                                    .align(.center)
                                    .verticalAlign(.middle)
                                }
                            }
                            .height(100.percent)
                            .width(100.percent)
                        }
                        .height(60.px)
                        .width(35.px)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                        .custom("width", "calc(100% - 24px)")
                        .class(.uibtnLarge)
                        .cursor(.nsResize)
                        
                )
            }
        }
        
        func removeItem(_ id: UUID){
            
            var items: [API.custRouteV1.OrderRouteItem] = []
            
            self.items.forEach { item in
                
                if item.orderId == id {
                    return
                }
                
                items.append(item)
                
            }
            
            self.items = items
            
        }
        
        func createRoute(){
            
            if items.isEmpty {
                return
            }
            
            guard let name else {
                print("🔴  Could not load NAME")
                return
            }
            
            guard let day = Int(day ?? "") else {
                print("🔴  Could not load DAY")
                return
            }
            
            guard let month = Int(month ?? "") else {
                print("🔴  Could not load MONTH")
                return
            }
            
            guard let year = Int(year ?? "") else {
                print("🔴  Could not load YEAR")
                return
            }
            
            guard let initialTime else {
                print("🔴  Could not load INITIALTIME")
                return
            }
            
            guard let endingTime else {
                print("🔴  Could not load name")
                return
            }
            
            guard let supervisor else {
                return
            }
            
            loadingView(show: true)
            
            API.custRouteV1.create(
                storeId: custCatchStore,
                supervisor: supervisor,
                assignUsers: assignUsers,
                name: name,
                day: day,
                month: month,
                year: year,
                initialTime: initialTime,
                endingTime: endingTime,
                items: items,
                travel: travel,
                distance: distance
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
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                self.addRoute(self.items.map{ $0.orderId }, payload.route)
                
                let _ = JSObject.global.removeAppleMapRought!()
                
                self.remove()
                
                
                
            }
        }
    }
}
