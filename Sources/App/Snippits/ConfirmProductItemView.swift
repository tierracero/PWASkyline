//
//  ConfirmProductItemView.swift
//
//
//  Created by Victor Cantu on 2/20/22.
//

import Foundation
import TCFundamentals
import Web

class ConfirmProductItemView: Div {
    
    override class var name: String { "div" }
    
    let poc: SearchChargeResponse

    let item: CustPOCInventory

    var from: SoldObjectFrom?

    let warenty: SoldObjectWarenty?
    
    private var callback: ((
        _ item: SoldProductObject
    ) -> ())
    
    init(
        poc: SearchChargeResponse,
        item: CustPOCInventory,
        warenty: SoldObjectWarenty?,
        callback: @escaping ((
            _ item: SoldProductObject
        ) -> ())
    ) {
        self.poc = poc
        self.item = item
        self.from = nil
        self.warenty = warenty
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var avatarImg = Img()
        .src("/skyline/media/512.png")
        .custom("height", "calc(100% - 6px)")
        .custom("width", "calc(100% - 6px)")
        .objectFit(.cover)
    
    @State var unitsToAdd: String = "0"
    
    lazy var unitsToAddField = InputText(self.item.series)
        .custom("width", "calc(100% - 16px)")
        .class(.textFiledBlackDark)
        .textAlign(.right)
        .placeholder("0")
        .disabled(true)
        .height(28.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Confirmar producto")
                    .color(.lightBlueText)
                    .marginLeft(7.px)
                    .float(.left)
                
                Div().class(.clear)
            }
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                self.avatarImg
                    
            }
            .padding(all: 3.px)
            .width(164.px)
            .float(.left)
            
            Div{
                
                Div("Name")
                    .marginBottom(3.px)
                    .color(.gray)
                
                Div(self.item.name.isEmpty ? "SIN NOMBRE" : self.item.name)
                    .color(self.item.name.isEmpty ? .gray : .white)
                    .class(.oneLineText)
                    .marginBottom(7.px)
                
                Div("Marca")
                    .marginBottom(3.px)
                    .color(.gray)
                
                Div(self.item.brand.isEmpty ? "SIN MARCA" : self.item.brand)
                    .color(self.item.brand.isEmpty ? .gray : .white)
                    .class(.oneLineText)
                    .marginBottom(7.px)
                
                Div("Modelo")
                    .marginBottom(3.px)
                    .color(.gray)
                
                Div(self.item.model.isEmpty ? "SIN MODELO" : self.item.model)
                    .color(self.item.model.isEmpty ? .gray : .white)
                    .class(.oneLineText)
                    .marginBottom(7.px)
                
            }
            .custom("width", "calc(100% - 170px)")
            .color(.white)
            .float(.left)
            
            Div().clear(.both).height(3.px)
            
            Div{
                Div("Serie")
                    .width(70.percent)
                    .color(.yellowTC)
                    .fontSize(24.px)
                    .float(.left)
                
                Div{
                    self.unitsToAddField
                }
                .width(30.percent)
                .float(.left)
            }
            
            
            Div().clear(.both).height(3.px)
            
            Div{
                Div("Agergar")
                    .class(.uibtnLargeOrange)
                    .onClick {
                        self.addItems()
                    }
            }
            .align(.right)
            
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left","calc(50% - 239px)")
        .custom("top","calc(50% - 139px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .width(450.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        if let pDir = customerServiceProfile?.account.pDir, !poc.a.isEmpty {
            avatarImg.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.a)")
        }


        if item.status == .inConcession {

            guard let accountId = item.custAcct else {
                showError(.unexpectedResult, "No se localizo la cuenta de la concesion")
                self.remove()
                return 
            }

            from = .consessionId(accountId)
        }
        else {
            from = .storeId(item.custStore)
        }

        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        unitsToAddField.select()
    }
    
    func addItems(){
        
        guard let from else {
            showError( .errorGeneral, "Ingrese unidades validas")
            return
        }

        let itemName = "\(poc.u) \(poc.n) \(poc.m)"

        self.callback(.init(
            description: itemName,
            pocId: item.POC,
            from: from,
            units: .serilized([self.item.series]),
            price: item.pricea,
            warenty: warenty
        ))
        
        
        self.remove()
        
    }   
}