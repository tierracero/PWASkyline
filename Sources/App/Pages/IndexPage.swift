import Web

class IndexPage: PageController {
    @DOM override var body: DOM.Content {
        P("Index pagepage 😵‍💫")
    }

    override func buildUI() {
        super.buildUI()
        rendered()
    }
}