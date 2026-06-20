//
//  SelectCustContractView.swift
//
//
//  Created by Codex on 6/19/26.
//

import Foundation
import TCFundamentals
import Web

class SelectCustContractView: Div {
    
    override class var name: String { "div" }
    
    var orderContract: [CustomerCustomeScript]
    
    private var callback: ((
        _ contract: CustomerCustomeScript
    ) -> ())
    
    init(
        orderContract: [CustomerCustomeScript],
        callback: @escaping ((
            _ contract: CustomerCustomeScript
        ) -> ())
    ) {
        self.orderContract = orderContract
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var contractSelectListener = ""
    
    lazy var contractSelect = Select(self.$contractSelectListener)
        .class(.textFiledBlackDarkLarge)
        .marginBottom(7.px)
        .width(99.percent)
        .fontSize(32.px)
        .height(48.px)
        .body {
            Option("Seleccione Contrato")
                .value("")
        }
        .onChange { _, _ in
            self.selectContract()
        }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }
                
                H2("Seleccione Contrato")
                    .color(.lightBlueText)
                    .height(35.px)
                
            }
            
            Div {
                self.contractSelect
            }
            .position(.relative)
            .overflow(.hidden)
            
        }
        .custom("left", "calc(50% - 274px)")
        .custom("top", "calc(50% - 274px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(500.px)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        orderContract.forEach { contract in
            self.contractSelect.appendChild(
                Option(contract.name)
                    .value(contract.id.uuidString)
            )
        }
    }
    
    func selectContract() {
        
        let idString = contractSelect.value
        
        if idString.isEmpty {
            return
        }
        
        guard let id = UUID(uuidString: idString) else {
            print("❌ 001")
            return
        }
        
        guard let contract = orderContract.first(where: { $0.id == id }) else {
            print("❌ 002")
            return
        }
        
        self.callback(contract)
        self.remove()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $contractSelectListener.removeAllListeners()
    }
}
