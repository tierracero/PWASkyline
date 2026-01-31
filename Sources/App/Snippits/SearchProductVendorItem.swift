//
//  SearchProductVendorItem.swift
//  
//
//  Created by Victor Cantu on 9/7/22.
//

import TCFundamentals
import Foundation
import Web

class SearchProductVendorItem: Tr {
    
    override class var name: String { "tr" }
    
    var term: String
    
    let vendor: CustVendorsQuick?
    
    let item: CustFiscalProductControl
    
    let pocid: UUID
    
    @State var isActive: Bool
    
    private var addVendor: ((
        _ isActive: Bool
    ) -> ())
    
    init(
        term: String,
        vendor: CustVendorsQuick?,
        item: CustFiscalProductControl,
        isActive: Bool,
        pocid: UUID,
        addVendor: @escaping ((
            _ isActive: Bool
        ) -> ())
    ) {
        self.term = term
        self.vendor = vendor
        self.item = item
        self.isActive = isActive
        self.pocid = pocid
        self.addVendor = addVendor
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var codeIsIncluded: Bool = false
    
    let nameGrid = Td()
    
    @DOM override var body: DOM.Content {
        Td(vendor?.folio ?? "N/A")
            .color(.gray)
        Td("\(vendor?.businessName ?? "") \(vendor?.razon ?? "")")
            .color(.gray)
        Td(item.code)
            .width(100.px)
            .color(self.$codeIsIncluded.map{ $0 ? .lightBlueText : .gray })
            .fontWeight(self.$codeIsIncluded.map{ $0 ? .bolder  : .normal })
        self.nameGrid
        Td(self.item.cost.formatMoney).color(.gray)
        Td{
            Img()
                .src(self.$isActive.map{ $0 ? "/skyline/media/heart.png" : "/skyline/media/heart_gray.png"})
                .cursor(.pointer)
                .width(18.px)
                .onClick {
                    self.updateItemPOCRelation()
                }
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        var parts:[String] = []
        
        let shortSerchWordHelper = ["de","la","los","las", "del", "x","-","_", "un"]
        
        term.pseudo.ssql
            .replace(from: "\"", to: " ")
            .replace(from: ",", to: " ")
            .replace(from: "(", to: " ")
            .replace(from: ")", to: " ")
            .purgeSpaces
            .explode(" ").forEach { part in
                parts.append(part)
            }

        item.description.purgeSpaces.explode(" ").forEach { word in
            
            if shortSerchWordHelper.contains(word.pseudo){
                Span(word)
                    .color(.init(r: 184, g: 182, b: 182))
                    .marginRight(7.px)
                return
            }
            
            if parts.contains(word.pseudo) {
                self.nameGrid.appendChild(
                    Strong(word)
                        .color(.black)
                        .marginRight(7.px)
                )
                return
            }
            
            if term.contains(item.code.pseudo) {
                self.codeIsIncluded = true
            }
            else{
                self.codeIsIncluded = false
            }
            
            var containsPart = false
            
            parts.forEach { part in
                
                var _part = part
                
                if part.count  < 3{
                    _part = " \(part) "
                }
                
                
                if word.contains(_part.pseudo){
                    containsPart = true
                }
                
            }
            
            if containsPart {
                self.nameGrid.appendChild(
                    Strong(word)
                        .color(.init(r: 78, g: 76, b: 76))
                        .marginRight(7.px)
                )
            }
            else{
                self.nameGrid.appendChild(
                    Span(word)
                        .color(.init(r: 184, g: 182, b: 182))
                        .marginRight(7.px)
                )
            }
            
        }
    }
    
    /// Mark  wether this item is related to poc or unlink of poc
    func updateItemPOCRelation(){
        
        loadingView(show: true)
        
        API.custPOCV1.modifyPOCVendorRelation(
            add: !isActive,
            pocid: self.pocid,
            itemid: self.item.id
        ) { resp in
            
            loadingView(show: false)
         
            guard let resp = resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            /// I am currently related, ``will unrelate``
            if self.isActive {
                showSuccess(.operacionExitosa, "Fue DESMARCADO con exito")
                self.isActive = false
                self.addVendor(false)
                
            }
            /// I am un related, ``will relate``
            else {
                showSuccess(.operacionExitosa, "Fue MARCADO con exito")
                self.isActive = true
                self.addVendor(true)
            }
        }
        
    }
}
