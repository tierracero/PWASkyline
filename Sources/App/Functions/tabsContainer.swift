
import Web


private func tabButton(_ selectedValue: State<String>, title: String) -> Div {
    Div(title)
        .padding(v: 8.px, h: 14.px)
        .cursor(.pointer)
        .fontWeight(.bold)
        .color(selectedValue.map { $0 == title ? .white : .gray })
        .backgroundColor(selectedValue.map {
            $0 == title ? .init(r: 37, g: 90, b: 124, a: 0.82) : .transparent
        })
        .custom("border", "1px solid rgba(102, 184, 236, 0.24)")
        .custom("border-bottom", "0")
        .custom("border-radius", "8px 8px 0 0")
        .onClick {
            selectedValue.wrappedValue = title
        }
}

struct TabContainer: Codable {
    let name: String
}

func tabsContainer( selectedValue: State<String>, items: [String], callback: (_ item: String) -> Void) -> Div {

    var container = Div()
        .custom("border-bottom", "1px solid rgba(102, 184, 236, 0.25)")
        .custom("gap", "4px")
        .marginTop(14.px)
        .display(.flex)

    items.forEach { item in
        container.appendChild(tabButton(selectedValue, title: item))
    }

    return container

}
