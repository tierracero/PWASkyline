import Web

class NotFoundPage: PageController {
    @DOM override var body: DOM.Content {

        P("404 NOT FOUND page")
            .textAlign(.center)
            .body {
                Button("go back").display(.block).onClick {
                    History.back()
                }
            }
    }
}

class NotFound_Preview: WebPreview {
    @Preview override class var content: Preview.Content {
        Language.en
        Title("Not found endpoint")
        Size(200, 200)
        NotFoundPage()
    }
}