//
// TripPrintEngine.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class TripPrintEngine: Div {

    override class var name: String { "div" }

    let trip: CustCommercialTripsComponents.GetTripItem

    let account: CustAcctQuick

    var logo = "/skyline/media/logoTierraCeroLongBlack.svg"

    lazy var locationsTable = Table {
        Tr {
            Td("Tipo").width(80.px)
            Td("Ubicacion")
            Td("Fecha / Hora").width(130.px)
            Td("Distancia").width(90.px)
        }
    }
    .width(100.percent)

    lazy var merchandiseTable = Table {
        Tr {
            Td("Mercancia")
            Td("Unidad").width(100.px)
            Td("Cantidad").width(80.px)
            Td("Peso").width(80.px)
            Td("Origen").width(120.px)
            Td("Destino").width(120.px)
        }
    }
    .width(100.percent)

    lazy var trailersTable = Table {
        Tr {
            Td("Tipo")
            Td("Nombre")
            Td("Serie")
        }
    }
    .width(100.percent)

    lazy var insuranceTable = Table {
        Tr {
            Td("Tipo")
            Td("Proveedor")
            Td("Poliza")
            Td("Vigencia")
            Td("Monto")
        }
    }
    .width(100.percent)

    init(
        trip: CustCommercialTripsComponents.GetTripItem,
        account: CustAcctQuick
    ) {
        self.trip = trip
        self.account = account
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    @DOM override var body: DOM.Content {
        Div {
            self.headerView()

            self.sectionTitle("Datos del cliente")
            Div {
                self.detail("Cuenta", self.account.folio)
                self.detail("Cliente", self.accountName)
                self.detail("Telefono", self.account.mobile)
                self.detail("Correo", self.account.email)
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "6px 12px")

            self.sectionTitle("Datos del viaje")
            Div {
                self.detail("Folio", self.trip.folio)
                self.detail("Estatus", self.trip.status.description)
                self.detail("Balance", self.trip.balance.formatMoney)
                self.detail("Creado", getDate(self.trip.createdAt).formatedShort)
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "6px 12px")

            self.sectionTitle("Operador")
            Div {
                tripAvatarImage(self.trip.operadorId.avatar)
                    .width(72.px)
                    .height(72.px)
                    .borderRadius(all: 8.px)

                self.detail("Tipo", self.trip.operadorId.operadorType.description)
                self.detail("Nombre", self.trip.operadorId.operadorName)
                self.detail("RFC", self.trip.operadorId.operadorRfc)
                self.detail("Licencia", self.trip.operadorId.operadorLicens)
                self.detail("Telefono", self.trip.operadorId.operadorMobile)
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "6px 12px")

            self.sectionTitle("Vehiculo y permiso")
            Div {
                tripAvatarImage(self.trip.vehicalId.avatar)
                    .width(72.px)
                    .height(72.px)
                    .borderRadius(all: 8.px)

                self.detail("Autotransporte", "\(self.trip.vehicalId.autotransporteCode) \(self.trip.vehicalId.autotransporteName)")
                self.detail("Vehiculo", self.trip.vehicalId.vehicalTypeName)
                self.detail("Placas / Año / Modelo / Marca", "\(self.trip.vehicalId.vehicalLicensePlate) / \(self.trip.vehicalId.vehicalYear) / \(self.trip.vehicalId.vehicalModel) / \(self.trip.vehicalId.vehicalMake)")
                self.detail("Propietario del Permiso", self.trip.permitId.permitName)
                self.detail("Permiso", "\(self.trip.permitId.permitTypeName) \(self.trip.permitId.permitNumber)")
            }
            .display(.grid)
            .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
            .custom("gap", "6px 12px")

            self.sectionTitle("Polizas")
            self.insuranceTable

            self.sectionTitle("Remolques")
            self.trailersTable

            self.sectionTitle("Ubicaciones")
            self.locationsTable

            self.sectionTitle("Mercancia")
            self.merchandiseTable

            self.signatureView()
        }
        .custom("box-sizing", "border-box")
        .custom("width", "8.5in")
        .custom("min-height", "11in")
        .padding(all: 34.px)
        .backgroundColor(.white)
        .color(.black)
        .fontSize(12.px)
    }

    override func buildUI() {
        super.buildUI()

        // Keep the print canvas white; this only registers the scoped Trip theme
        // for any shared controls rendered inside the print view.
        TCCrystalSurfaceTheme.apply(to: self, variant: .trip)

        if let _logo = custWebFilesLogos?.logoIndexWhite.avatar {
            if !_logo.isEmpty {
                logo = "https://\(custCatchUrl)\(skylineUrlPatch)/contenido/\(_logo)"
            }
        }

        appendInsuranceRows()
        appendTrailerRows()
        appendLocationRows()
        appendMerchandiseRows()
    }

    private var accountName: String {
        let name = "\(account.businessName) \(account.firstName) \(account.lastName)".purgeSpaces
        return name.isEmpty ? account.folio : name
    }

    private func headerView() -> Div {
        Div {
            Table {
                Tr {
                    Td {
                        Img()
                            .src(self.logo)
                            .maxWidth(210.px)
                            .maxHeight(70.px)
                    }
                    .width(33.percent)

                    Td {
                        Strong("Carta Liberacion")
                            .fontSize(26.px)
                        Div("Viaje comercial")
                            .fontSize(14.px)
                    }
                    .align(.center)
                    .width(34.percent)

                    Td {
                        Strong(self.trip.folio)
                            .fontSize(24.px)
                        Div(getDate(getNow()).formatedShort)
                            .fontSize(12.px)
                    }
                    .align(.right)
                    .width(33.percent)
                }
            }
            .width(100.percent)
        }
        .marginBottom(16.px)
    }

    private func sectionTitle(_ title: String) -> Div {
        Div(title)
            .fontSize(14.px)
            .fontWeight(.bold)
            .borderBottom(width: .thin, style: .solid, color: .black)
            .marginTop(12.px)
            .marginBottom(6.px)
    }

    private func detail(_ title: String, _ value: String) -> Div {
        Div {
            Strong("\(title): ")
            Span(value.isEmpty ? "Sin informacion" : value)
        }
    }

    private func appendInsuranceRows() {
        appendInsuranceRow("Civil", trip.insuranceCivilId)
        appendInsuranceRow("Ambiental", trip.insuranceAmbientId)
        appendInsuranceRow("Carga", trip.insurancePayloadId)
    }

    private func appendInsuranceRow(_ title: String, _ item: CustCommercialTripInsurance?) {
        guard let item else {
            insuranceTable.appendChild(
                Tr {
                    Td(title)
                    Td("Sin poliza").colSpan(4)
                }
            )
            return
        }

        insuranceTable.appendChild(
            Tr {
                Td(title)
                Td(item.provider)
                Td(item.policyNumber)
                Td("\(getDate(item.validAt).formatedShort) - \(getDate(item.expiredAt).formatedShort)")
                Td(item.insuredAmount.formatMoney)
            }
        )
    }

    private func appendTrailerRows() {
        guard !trip.trailers.isEmpty else {
            trailersTable.appendChild(
                Tr {
                    Td("Sin remolques").colSpan(3)
                }
            )
            return
        }

        trip.trailers.forEach { item in
            trailersTable.appendChild(
                Tr {
                    Td(item.type.description)
                    Td(item.name)
                    Td(item.series)
                }
            )
        }
    }

    private func appendLocationRows() {
        guard !trip.locations.isEmpty else {
            locationsTable.appendChild(
                Tr {
                    Td("Sin ubicaciones").colSpan(4)
                }
            )
            return
        }

        trip.locations.sorted { $0.position < $1.position }.forEach { item in
            locationsTable.appendChild(
                Tr {
                    Td(item.placementType.description)
                    Td {
                        Strong(item.storeName.isEmpty ? item.razon : item.storeName)
                        Div("\(item.street) \(item.number), \(item.colonie), \(item.state.description), \(item.zipCode)")
                            .fontSize(10.px)
                    }
                    Td(getDate(item.uts + (60 * 60 * 6)).formatedShort)
                    Td(item.distance?.fromCents.toString ?? "")
                }
            )
        }
    }

    private func appendMerchandiseRows() {
        guard !trip.merchandise.isEmpty else {
            merchandiseTable.appendChild(
                Tr {
                    Td("Sin mercancia").colSpan(6)
                }
            )
            return
        }

        trip.merchandise.forEach { item in
            merchandiseTable.appendChild(
                Tr {
                    Td {
                        Strong(item.description)
                        Div("\(item.fiscCode) \(item.fiscCodeName)")
                            .fontSize(10.px)
                    }
                    Td(item.fiscUnitName)
                    Td(item.units.fromCents.toString)
                    Td("\(item.kilograms.fromCents.toString) kg")
                    Td(item.fromStoreName)
                    Td(item.toStoreName)
                }
            )
        }
    }

    private func signatureView() -> Div {
        Div {
            Div {
                Div()
                    .borderBottom(width: .thin, style: .solid, color: .black)
                    .height(40.px)
                Div("Entrega")
                    .align(.center)
            }

            Div {
                Div()
                    .borderBottom(width: .thin, style: .solid, color: .black)
                    .height(40.px)
                Div("Recibe")
                    .align(.center)
            }
        }
        .display(.grid)
        .custom("grid-template-columns", "repeat(2, minmax(0, 1fr))")
        .custom("gap", "42px")
        .marginTop(26.px)
    }
}
