//
//  CreateCustContractView.swift
//
//
//  Created by Codex on 6/19/26.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class CreateCustContractView: Div {
    
    override class var name: String { "div" }
    
    let orderId: UUID

    let contractName: String

    let configuration: CustContractRelationConfiguration

    let equipment: CustOrderLoadFolioEquipments

    let serviceTags: ConfigServiceTags
    
    private var callback: ((
        _ fileName: String
    ) -> ())
    
    init(
        orderId: UUID,
        contractName: String,
        configuration: CustContractRelationConfiguration,
        equipment: CustOrderLoadFolioEquipments,
        serviceTags: ConfigServiceTags = configServiceTags,
        callback: @escaping ((
            _ fileName: String
        ) -> ())
    ) {
        self.orderId = orderId
        self.contractName = contractName
        self.configuration = configuration
        self.equipment = equipment
        self.serviceTags = serviceTags
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var valueOneField = makeInputField(
        key: "valueOne",
        relation: configuration.valueOne,
        type: configuration.valueOneIO,
        placeholder: configuration.valueOnePlaceholder
    )
    
    lazy var valueTwoField = makeInputField(
        key: "valueTwo",
        relation: configuration.valueTwo,
        type: configuration.valueTwoIO,
        placeholder: configuration.valueTwoPlaceholder
    )
    
    lazy var valueThreeField = makeInputField(
        key: "valueThree",
        relation: configuration.valueThree,
        type: configuration.valueThreeIO,
        placeholder: configuration.valueThreePlaceholder
    )
    
    lazy var valueFourField = makeInputField(
        key: "valueFour",
        relation: configuration.valueFour,
        type: configuration.valueFourIO,
        placeholder: configuration.valueFourPlaceholder
    )
    
    lazy var valueFiveField = makeInputField(
        key: "valueFive",
        relation: configuration.valueFive,
        type: configuration.valueFiveIO,
        placeholder: configuration.valueFivePlaceholder
    )
    
    lazy var valueSixField = makeInputField(
        key: "valueSix",
        relation: configuration.valueSix,
        type: configuration.valueSixIO,
        placeholder: configuration.valueSixPlaceholder
    )
    
    lazy var valueSevenField = makeInputField(
        key: "valueSeven",
        relation: configuration.valueSeven,
        type: configuration.valueSevenIO,
        placeholder: configuration.valueSevenPlaceholder
    )
    
    lazy var valueEightField = makeInputField(
        key: "valueEight",
        relation: configuration.valueEight,
        type: configuration.valueEightIO,
        placeholder: configuration.valueEightPlaceholder
    )
    
    lazy var valueNineField = makeInputField(
        key: "valueNine",
        relation: configuration.valueNine,
        type: configuration.valueNineIO,
        placeholder: configuration.valueNinePlaceholder
    )
    
    lazy var valueTenField = makeInputField(
        key: "valueTen",
        relation: configuration.valueTen,
        type: configuration.valueTenIO,
        placeholder: configuration.valueTenPlaceholder
    )
    
    lazy var valueElevenField = makeInputField(
        key: "valueEleven",
        relation: configuration.valueEleven,
        type: configuration.valueElevenIO,
        placeholder: configuration.valueElevenPlaceholder
    )
    
    lazy var valueTwelveField = makeInputField(
        key: "valueTwelve",
        relation: configuration.valueTwelve,
        type: configuration.valueTwelveIO,
        placeholder: configuration.valueTwelvePlaceholder
    )
    
    lazy var valueThirteenField = makeInputField(
        key: "valueThirteen",
        relation: configuration.valueThirteen,
        type: configuration.valueThirteenIO,
        placeholder: configuration.valueThirteenPlaceholder
    )
    
    lazy var valueFourteenField = makeInputField(
        key: "valueFourteen",
        relation: configuration.valueFourteen,
        type: configuration.valueFourteenIO,
        placeholder: configuration.valueFourteenPlaceholder
    )
    
    lazy var valueFifteenField = makeInputField(
        key: "valueFifteen",
        relation: configuration.valueFifteen,
        type: configuration.valueFifteenIO,
        placeholder: configuration.valueFifteenPlaceholder
    )
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick {
                        self.remove()
                    }
                
                H2("Crear Contrato | \(self.contractName)")
                    .color(.lightBlueText)
                    .height(35.px)
                
            }
            
            Div {
                if self.valueOneField.isActive {
                    self.valueOneField
                }
                if self.valueTwoField.isActive {
                    self.valueTwoField
                }
                if self.valueThreeField.isActive {
                    self.valueThreeField
                }
                if self.valueFourField.isActive {
                    self.valueFourField
                }
                if self.valueFiveField.isActive {
                    self.valueFiveField
                }
                if self.valueSixField.isActive {
                    self.valueSixField
                }
                if self.valueSevenField.isActive {
                    self.valueSevenField
                }
                if self.valueEightField.isActive {
                    self.valueEightField
                }
                if self.valueNineField.isActive {
                    self.valueNineField
                }
                if self.valueTenField.isActive {
                    self.valueTenField
                }
                if self.valueElevenField.isActive {
                    self.valueElevenField
                }
                if self.valueTwelveField.isActive {
                    self.valueTwelveField
                }
                if self.valueThirteenField.isActive {
                    self.valueThirteenField
                }
                if self.valueFourteenField.isActive {
                    self.valueFourteenField
                }
                if self.valueFifteenField.isActive {
                    self.valueFifteenField
                }
            }
            .custom("max-height", "calc(80vh - 115px)")
            .display(.grid)
            .custom("grid-template-columns", "repeat(\(self.fieldColumnCount), minmax(0, 1fr))")
            .custom("column-gap", "14px")
            .overflow(.auto)
            
            Div {
                Div("Crear")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.createContract()
                    }
            }
            .align(.right)
            .marginTop(12.px)
            
        }
        .custom("left", self.fieldColumnCount == 1 ? "calc(50% - 274px)" : "calc(50% - 454px)")
        .custom("top", "10%")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .custom("width", self.fieldColumnCount == 1 ? "500px" : "860px")
        .custom("max-width", "calc(100% - 48px)")
    }
    
    override func buildUI() {
        super.buildUI()
        
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }

    func makeInputField(
        key: String,
        relation: CustContractRelationRelationType,
        type: SaleActionInputType,
        placeholder: String
    ) -> ContractInputField {
        let relationData = resolveRelationData(relation, fallbackPlaceholder: placeholder)
        
        return ContractInputField(
            key: key,
            relation: relation,
            type: type,
            title: relationData.title,
            placeholder: relationData.placeholder,
            value: relationData.value,
            checked: relationData.checked
        )
    }

    func resolveRelationData(
        _ relation: CustContractRelationRelationType,
        fallbackPlaceholder: String
    ) -> (title: String, placeholder: String, value: String, checked: Bool) {
        switch relation {
        case .inactive:
            return ("", fallbackPlaceholder, "", false)
        case .custome(let title):
            return (title, fallbackPlaceholder, "", false)
        case .relation(let key):
            return (
                relationTitle(key),
                relationPlaceholder(key),
                relationValue(key),
                relationCheckedValue(key)
            )
        }
    }

    func relationTitle(_ key: EquipmentObject.CodingKeys) -> String {
        switch key {
        case .refid:
            return "ID"
        case .IDTag1:
            return serviceTags.idTagName
        case .IDTag2:
            return serviceTags.secondIDTagName
        case .tag1:
            return serviceTags.tag1Name
        case .tag2:
            return serviceTags.tag2Name
        case .tag3:
            return serviceTags.tag3Name
        case .tag4:
            return serviceTags.tag4Name
        case .tag5:
            return serviceTags.tag5Name
        case .tag6:
            return serviceTags.tag6Name
        case .tagCheck1:
            return serviceTags.checkTag1Name
        case .tagCheck2:
            return serviceTags.checkTag2Name
        case .tagCheck3:
            return serviceTags.checkTag3Name
        case .tagCheck4:
            return serviceTags.checkTag4Name
        case .tagCheck5:
            return serviceTags.checkTag5Name
        case .tagCheck6:
            return serviceTags.checkTag6Name
        case .tagDescr:
            return serviceTags.tagDescrName
        }
    }

    func relationPlaceholder(_ key: EquipmentObject.CodingKeys) -> String {
        switch key {
        case .refid:
            return ""
        case .IDTag1:
            return serviceTags.idTagPlaceholder
        case .IDTag2:
            return serviceTags.secondIDTagPlaceholder
        case .tag1:
            return serviceTags.tag1Placeholder
        case .tag2:
            return serviceTags.tag2Placeholder
        case .tag3:
            return serviceTags.tag3Placeholder
        case .tag4:
            return serviceTags.tag4Placeholder
        case .tag5:
            return serviceTags.tag5Placeholder
        case .tag6:
            return serviceTags.tag6Placeholder
        case .tagCheck1, .tagCheck2, .tagCheck3, .tagCheck4, .tagCheck5, .tagCheck6:
            return ""
        case .tagDescr:
            return serviceTags.tagDescrPlaceholder
        }
    }

    func relationValue(_ key: EquipmentObject.CodingKeys) -> String {
        switch key {
        case .refid:
            return equipment.id.uuidString
        case .IDTag1:
            return equipment.IDTag1
        case .IDTag2:
            return equipment.IDTag2
        case .tag1:
            return equipment.tag1
        case .tag2:
            return equipment.tag2
        case .tag3:
            return equipment.tag3
        case .tag4:
            return equipment.tag4
        case .tag5:
            return equipment.tag5
        case .tag6:
            return equipment.tag6
        case .tagCheck1:
            return equipment.tagCheck1 ? "true" : "false"
        case .tagCheck2:
            return equipment.tagCheck2 ? "true" : "false"
        case .tagCheck3:
            return equipment.tagCheck3 ? "true" : "false"
        case .tagCheck4:
            return equipment.tagCheck4 ? "true" : "false"
        case .tagCheck5:
            return equipment.tagCheck5 ? "true" : "false"
        case .tagCheck6:
            return equipment.tagCheck6 ? "true" : "false"
        case .tagDescr:
            return equipment.tagDescr
        }
    }

    func relationCheckedValue(_ key: EquipmentObject.CodingKeys) -> Bool {
        switch key {
        case .tagCheck1:
            return equipment.tagCheck1
        case .tagCheck2:
            return equipment.tagCheck2
        case .tagCheck3:
            return equipment.tagCheck3
        case .tagCheck4:
            return equipment.tagCheck4
        case .tagCheck5:
            return equipment.tagCheck5
        case .tagCheck6:
            return equipment.tagCheck6
        case .refid, .IDTag1, .IDTag2, .tag1, .tag2, .tag3, .tag4, .tag5, .tag6, .tagDescr:
            return false
        }
    }
    
    func createContract() {
        
        let fields = contractFields
        
        if let invalidField = fields.first(where: { !$0.hasRequiredValue }) {
            showError(.requiredField, .requierdValid(invalidField.title))
            return
        }
        
        let payload = CustContractPayload(
            valueOne: valueOneField.payloadValue ?? "",
            valueTwo: valueTwoField.payloadValue ?? "",
            valueThree: valueThreeField.payloadValue ?? "",
            valueFour: valueFourField.payloadValue ?? "",
            valueFive: valueFiveField.payloadValue ?? "",
            valueSix: valueSixField.payloadValue ?? "",
            valueSeven: valueSevenField.payloadValue ?? "",
            valueEight: valueEightField.payloadValue ?? "",
            valueNine: valueNineField.payloadValue ?? "",
            valueTen: valueTenField.payloadValue ?? "",
            valueEleven: valueElevenField.payloadValue ?? "",
            valueTwelve: valueTwelveField.payloadValue ?? "",
            valueThirteen: valueThirteenField.payloadValue ?? "",
            valueFourteen: valueFourteenField.payloadValue ?? "",
            valueFifteen: valueFifteenField.payloadValue ?? ""
        )
        
        loadingView.show()
        
        API.custOrderV1.requestContract(
            orderId: orderId,
            configuration: configuration,
            payload: payload
        ) { resp in
            
            loadingView.hide()
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.callback(payload.fileName)
            showSuccess(.operacionExitosa, "Contrato creado, descargando.")


            let url = baseAPIUrl("https://api.tierracero.co/cust/v1/customePrintDownloader") +
            "&file=" + payload.fileName
            
            print(url)

            _ = JSObject.global.goToURL!(url)

            self.remove()


        }
        
    }
    
    var contractFields: [ContractInputField] {
        [
            valueOneField,
            valueTwoField,
            valueThreeField,
            valueFourField,
            valueFiveField,
            valueSixField,
            valueSevenField,
            valueEightField,
            valueNineField,
            valueTenField,
            valueElevenField,
            valueTwelveField,
            valueThirteenField,
            valueFourteenField,
            valueFifteenField
        ]
    }

    var activeFieldCount: Int {
        contractFields.filter { $0.isActive }.count
    }

    var fieldColumnCount: Int {
        activeFieldCount > 6 ? 2 : 1
    }
    

}

extension CreateCustContractView {
    
    class ContractInputField: Div {
        
        override class var name: String { "div" }
        
        let key: String
        let relation: CustContractRelationRelationType
        let type: SaleActionInputType
        let title: String
        let placeholder: String
        
        init(
            key: String,
            relation: CustContractRelationRelationType,
            type: SaleActionInputType,
            title: String,
            placeholder: String,
            value: String,
            checked: Bool
        ) {
            self.key = key
            self.relation = relation
            self.type = type
            self.title = title
            self.placeholder = placeholder
            self.value = value
            self.checked = checked
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var value = ""
        
        @State var checked = false
        
        lazy var textField = InputText(self.$value)
            .placeholder(placeholder)
            .custom("width", "calc(100% - 18px)")
            .class(.textFiledBlackDark)
            .height(32.px)
        
        lazy var textArea = TextArea(self.$value)
            .placeholder(placeholder)
            .custom("width", "calc(100% - 18px)")
            .class(.textFiledBlackDark)
            .height(95.px)
        
        lazy var checkBox = InputCheckbox().toggle(self.$checked)
        
        @DOM override var body: DOM.Content {
            
            if self.isActive {
                
                Div {
                    
                    Div(self.title)
                        .color(.lightGray)
                        .marginBottom(3.px)
                    
                    switch self.type {
                    case .textField:
                        self.textField
                    case .textArea:
                        self.textArea
                    case .checkBox:
                        Div {
                            self.checkBox
                                .marginRight(7.px)
                            
                            Span(self.placeholder.isEmpty ? self.title : self.placeholder)
                                .color(.gray)
                        }
                    case .selection, .radio:
                        self.textField
                    case .instruction:
                        Div(self.placeholder.isEmpty ? self.title : self.placeholder)
                            .color(.gray)
                    }
                    
                }
                .marginBottom(12.px)
                
            }
        }
        
        var isActive: Bool {
            switch relation {
            case .inactive:
                return false
            case .custome, .relation:
                return true
            }
        }
        
        var requiresValue: Bool {
            switch type {
            case .textField, .textArea, .selection, .radio:
                return isActive
            case .checkBox, .instruction:
                return false
            }
        }
        
        var hasRequiredValue: Bool {
            if !requiresValue {
                return true
            }
            
            return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        var payloadValue: String? {
            guard isActive else {
                return nil
            }
            
            switch type {
            case .instruction:
                return nil
            case .checkBox:
                return checked ? "true" : "false"
            case .textField, .textArea, .selection, .radio:
                return value
            }
        }
        
        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $value.removeAllListeners()
            $checked.removeAllListeners()
        }
    }
}
