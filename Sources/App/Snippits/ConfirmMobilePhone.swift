import Foundation
import TCFundamentals
import Web
import TCFireSignal

class ConfirmMobilePhone: Div {
    
    override class var name: String { "div" }
    
    @State var term: String
    
    private var callback: ((
        _ term: String
    ) -> ())
    
    init(
        term: String,
        callback: @escaping ((
            _ term: String
        ) -> ())
    ) {
        self.term = term
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var seachCustomerField = InputText(self.$term)
        .placeholder("Ingrese Telefono")
        .width(70.percent)
        .height(52.px)
        .fontSize(36.px)
        .class(.textFiledLight)
        .onKeyUp { input, event in
            if event.code == "Enter" || event.code ==  "NumpadEnter" {
                self.searchCustomer()
            }
        }
    
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.subView)
                .onClick{
                    self.remove()
                }
            
            H2("Confirmar Celular")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(3.px)
            
            Div{
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                self.seachCustomerField
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
                
                Div{
                    Span("Confirmar Celular")
                }
                .width(70.percent)
                .fontSize(36.px)
                .align(.center)
                .class(.smallButtonBox)
                .onClick(self.searchCustomer)
                
                Div()
                    .class(.clear)
                    .marginTop(12.px)
            }
            .align(.center)
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 134px)")
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .position(.absolute)
        .padding(all: 12.px)
        .height(220.px)
        .width(500.px)
    }
    
    override func buildUI() {
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        width(100.percent)
        position(.absolute)
        top(0.px)
        left(0.px)
        
        super.buildUI()
        
    }
    
    func searchCustomer(){
        
        term = term.purgeSpaces
        
        if term.isEmpty {
            return
        }
        
        callback(term)

    }
    
}

