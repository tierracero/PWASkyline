//
// TripControler+AddElement.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
/*


    func selectOperador() {
        addToDom(TripControlerAddElement(
            title: "Seleccione Operador",
            items: operadors,
            titleForItem: { "\($0.operadorType.description): \($0.operadorName)" },
            subtitleForItem: { "RFC \($0.operadorRfc) | Licencia \($0.operadorLicens)" },
            callback: { item in
                self.operador = item
            }
        ))
    }

    func selectVehical() {
        
    }

    func selectPermit() {
        addToDom(TripCreateSelectionView(
            title: "Seleccione Permiso",
            items: permits,
            titleForItem: { $0.permitTypeName },
            subtitleForItem: { "Permiso \($0.permitNumber) | Seguro \($0.insuranceAmount)" },
            callback: { item in
                self.permit = item
            }
        ))
    }

    func selectInsurance(_ type: ComertialTripInsuranceType) {
        addToDom(TripCreateSelectionView(
            title: "Seleccione Polisa \(type.description)",
            items: insurances.filter { $0.type == type },
            titleForItem: { $0.provider },
            subtitleForItem: { "Polisa \($0.policyNumber) | Monto \($0.insuredAmount)" },
            callback: { item in
                switch type {
                case .civil:
                    self.civilInsurance = item
                case .ambient:
                    self.ambientInsurance = item
                case .payload:
                    self.payloadInsurance = item
                }
            }
        ))
    }

    func selectTrailer(_ placement: TrailerPlacement) {
        addToDom(TripCreateSelectionView(
            title: placement == .one ? "Seleccione Remolque 1" : "Seleccione Remolque 2",
            items: trailers,
            titleForItem: { $0.name },
            subtitleForItem: { "\($0.type.description) | Series \($0.series)" },
            callback: { item in
                switch placement {
                case .one:
                    self.trailerOne = item
                case .two:
                    self.trailerTwo = item
                }
            }
        ))
    }

*/

class TripControlerAddElement<Item>: Div {

    override class var name: String { "div" }

    let title: String
    let items: [Item]
    let titleForItem: (Item) -> String
    let subtitleForItem: (Item) -> String
    let callback: (Item) -> Void
    let create: () -> Void

    init(
        title: String,
        items: [Item],
        titleForItem: @escaping (Item) -> String,
        subtitleForItem: @escaping (Item) -> String,
        callback: @escaping (Item) -> Void,
        create: @escaping () -> Void
    ) {
        self.title = title
        self.items = items
        self.titleForItem = titleForItem
        self.subtitleForItem = subtitleForItem
        self.callback = callback
        self.create = create
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    lazy var itemsContainer = Div()
        .height(100.percent)
        .width(100.percent)

    @DOM override var body: DOM.Content {
        Div {

            Img()
                .closeButton(.uiView2)
                .onClick {
                    self.remove()
                }

            Div("+ Agregar")
                .color(.goldenRod)
                .marginRight(12.px)
                .padding(all: 3.px)
                .marginTop(-3.px)
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.create()
                    self.remove()
                }

            H2(self.title)
                .color(.lightBlueText)
                .margin(all: 0.px)

            Div().class(.clear)

            Div {
                self.itemsContainer 
            }
            .class(.roundBlue)
            .overflow(.auto)
            .height(250.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(46.percent)
        .left(27.percent)
        .top(12.percent)
    }

    override func buildUI() {
        super.buildUI()

        TCTripBetaTheme.apply(to: self)

        position(.absolute)
        height(100.percent)
        width(100.percent)
        top(0.px)
        left(0.px)

        if items.isEmpty {
            itemsContainer.appendChild(
                Table {
                    Tr {
                         Td {
                            H2("👾 No hay opciones disponibles")
                            .padding(all: 12.px)
                            .color(.gray)
                            
                            Div("+ Agregar")
                            .padding(all: 5.px)
                            .class(.uibtn)
                            .onClick {
                                self.create()
                                self.remove()
                            }

                         }
                         .verticalAlign(.middle)
                         .align(.center)
                    }
                }
                .width(100.percent)
                .height(100.percent)
            )
            return
        }

        items.forEach { item in
            itemsContainer.appendChild(
                Div {
                    Div(self.titleForItem(item))
                        .color(.white)
                        .fontSize(18.px)
                        .class(.oneLineText)

                    Div(self.subtitleForItem(item))
                        .color(.gray)
                        .fontSize(14.px)
                        .class(.oneLineText)
                }
                .class(.roundGrayBlackDark)
                .padding(all: 10.px)
                .marginBottom(8.px)
                .cursor(.pointer)
                .onClick {
                    self.callback(item)
                    self.remove()
                }
            )
        }
    }

}
