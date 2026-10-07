import Foundation
import TCFundamentals
import TCFireSignal
import Web

final class SearchSubCustomerView: Div {
    override class var name: String { "div" }

    let custAcct: CustAcctSearch

    let requierFullAddress: Bool

    private let callback: (CustSubAcct) -> Void

    private var searchRequestId: UUID?

    @State var term = ""

    @State private var isSearching = false

    init(
        custAcct: CustAcctSearch,
        requierFullAddress: Bool = false,
        callback: @escaping (CustSubAcct) -> Void
    ) {
        self.custAcct = custAcct
        self.requierFullAddress = requierFullAddress
        self.callback = callback
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    private var parentName: String {
        custAcct.type == .personal
            ? "\(custAcct.firstName) \(custAcct.lastName)".purgeSpaces
            : custAcct.businessName
    }

    lazy var searchCustomerField = InputText(self.$term)
        .placeholder("Ingrese teléfono, empresa o nombre")
        .width(100.percent)
        .height(48.px)
        .fontSize(18.px)
        .class(.textFiledLight)
        .disabled(self.$isSearching)
        .onKeyUp { _, event in
            if event.code == "Enter" || event.code == "NumpadEnter" {
                self.searchCustomer()
            }
        }

    private lazy var resultsContainer = Div()
        .custom("max-height", "360px")
        .custom("overflow-y", "auto")
        .custom("display", "grid")
        .custom("gap", "12px")

    @DOM override var body: DOM.Content {
        VPopUp(.fitContent(w: 560)) {

            VTitle("Buscar Subcliente", icon: "icon_user.png") {
                USmallTitle("Cuenta: \(self.parentName)")
            } onClose: {
                self.remove()
            }

            VBodyGrid {

                VGrid(.full) {

                    VBox(.raised) {
                        
                        UMinorTitle("Ingrese teléfono, nombre de empresa, o nombre y apellido.")
                            .custom("line-height", "1.5")

                        UField("Tel, negcio, nombre, lat;;lon", required: false) {
                            self.searchCustomerField
                        }
                        .marginTop(14.px)

                        ULargeButton(self.$isSearching.map { $0 ? "Buscando…" : "Buscar Subcliente" })
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(100.percent)
                            .marginTop(16.px)
                            .disabled(self.$isSearching)
                            .onClick(self.searchCustomer)


                        self.resultsContainer
                            .marginTop(14.px)
                    }
                }
            }
        }
    }

    override func buildUI() {
        super.buildUI()
        TCCrystalSurfaceTheme.apply(to: self, variant: .customerSearch)
        position(.absolute)
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        attribute("role", "dialog")
        attribute("aria-modal", "true")
    }

    override func didAddToDOM() {
        super.didAddToDOM()
        searchCustomerField.select()
    }

    func searchCustomer() {

        term = term.purgeSpaces

        guard !term.isEmpty else { return }

        if Int64(term) != nil {
            guard term.count >= 5 else {
                showError(.invalidFormat, "Si busca por teléfono, deberá ingresar 5 dígitos por lo menos")
                return
            }
        } else {
            guard term.count >= 4 else {
                showError(.invalidFormat, "La búsqueda debe incluir por lo menos 4 caracteres")
                return
            }
        }

        loadingView.show()

        API.custSubAcctV1.search(custAcct: custAcct.id, term: term) { [weak self] searchedTerm, response in

            guard let self else {
                return
            }

            guard let results = response else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            guard results.allSatisfy({ $0.custAcct == self.custAcct.id }) else {
                showError(.unexpectedResult, "La búsqueda devolvió clientes de otra cuenta")
                return
            }

            loadingView.hide()

            if results.isEmpty {
                self.createCustomer(searchTerm: searchedTerm)
            } else if results.count == 1, let item = results.first {
                self.selectCustomer(item)
            } else {
                results.forEach { self.resultsContainer.appendChild(self.resultCard($0)) }
            }
        }
    }

    private func resultCard(_ item: CustSubAcct) -> VBox {
        let name = item.businessName.purgeSpaces.isEmpty
            ? [item.firstName, item.secondName, item.lastName, item.secondLastName]
                .filter { !$0.purgeSpaces.isEmpty }.joined(separator: " ")
            : item.businessName
        let contact = [item.mobile, item.telephone, item.email]
            .filter { !$0.purgeSpaces.isEmpty }.joined(separator: " · ")
        let address = [item.street, item.colony, item.city, item.state]
            .filter { !$0.purgeSpaces.isEmpty }.joined(separator: ", ")

        return VBox(.interactive) {
            USubTitle(name.isEmpty ? item.folio : name)
            if !contact.isEmpty { UMinorTitle(contact) }
            if !address.isEmpty { UMinorTitle(address) }
        }
        .attribute("role", "button")
        .attribute("tabindex", "0")
        .onClick { self.selectCustomer(item) }
        .onKeyDown { _, event in
            guard event.code == "Enter" || event.code == "NumpadEnter" || event.code == "Space" else { return }
            event.preventDefault()
            self.selectCustomer(item)
        }
    }

    private func createCustomer(searchTerm: String) {

        addToDom(CreateNewCusomerView(
            searchTerm: searchTerm,
            custType: .general
        ) { acctType, _, selectedTerm in

            addToDom(ManageSubCustomerAccountView(
                custAcct: self.custAcct,
                acctType: acctType,
                searchTerm: selectedTerm,
                requierFullAddress: self.requierFullAddress
            ) { item in
                self.selectCustomer(item)
            })
        })
    }
 
    private func selectCustomer(_ item: CustSubAcct) {
        
        if requierFullAddress, !ManageSubCustomerAccountView.hasFullAddress(item) {

            let view = ManageSubCustomerAccountView(
                custAcct: custAcct,
                custSubAcct: item,
                requierFullAddress: true
            ) { [weak self] updated in
                
                guard let self else { return }

                self.selectCustomer(updated)
            }
            
            addToDom(view)

            showAlert(.alerta, ManageSubCustomerAccountView.fullAddressMessage)

            return
        }

        callback(item)

        remove()
    }

    override func didRemoveFromDOM() {
        searchRequestId = nil
        $term.removeAllListeners()
        $isSearching.removeAllListeners()
        super.didRemoveFromDOM()
    }
}
