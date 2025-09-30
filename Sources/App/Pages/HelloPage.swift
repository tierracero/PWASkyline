import Web

class HelloPage: PageController {
    @DOM override var body: DOM.Content {
        P("HELLO page")
            .textAlign(.center)
            .body {
                Button("go back").display(.block).onClick {
                    History.back()
                }
            }
    }
}

class Hello_Preview: WebPreview {
    @Preview override class var content: Preview.Content {
        Language.en
        Title("Hello endpoint")
        Size(200, 200)
        HelloPage()
    }
}