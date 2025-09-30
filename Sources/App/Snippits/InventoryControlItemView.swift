//
//  InventoryControlItemView.swift
//  
//
//  Created by Victor Cantu on 10/5/22.
//

import Foundation
import TCFundamentals
import Web

class InventoryControlItemView: Tr {
    
    override class var name: String { "tr" }
 
    let poc: CustPOCQuick
    let items: [UUID]
    let store: UUID?
    let bod: UUID?
    let sec: UUID?
    /// if has been confirmed need to disble  selct
    let closedByName: State<String>
    
    init(
        poc: CustPOCQuick,
        items: [UUID],
        store: UUID?,
        bod: UUID?,
        sec: UUID?,
        closedByName: State<String>
    ) {
        self.poc = poc
        self.items = items
        self.store = store
        self.bod = bod
        self.sec = sec
        self.closedByName = closedByName
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var bodid: UUID? = nil
    @State var bodidstr = ""
    
    var secid: UUID? = nil
    @State var secidstr = ""
    
    lazy var bodSelect = Select(self.$bodidstr)
        .disabled(self.closedByName.map { !$0.isEmpty })
        .class(.textFiledBlackDark)
        .marginRight(7.px)
        .width(170.px)
    
    lazy var bodView = Div()
        .class(.oneLineText)
        .align(.center)
        .hidden(true)
    
    lazy var secSelect = Select(self.$secidstr)
        .disabled(self.closedByName.map { !$0.isEmpty })
        .class(.textFiledBlackDark)
        .width(170.px)
    
    lazy var secView = Div()
        .class(.oneLineText)
        .align(.center)
        .hidden(true)
    
    @DOM override var body: DOM.Content {
        Td(self.items.count.toString)
        Td(self.poc.brand)
        Td(self.poc.model)
        Td(self.poc.name)
        Td("")
        Td{
            self.bodSelect
            self.bodView
        }
        Td{
            self.secSelect
            self.secView
        }
    }
    
    override func buildUI() {
        super.buildUI()
        
        $bodidstr.listen {
            
            self.secSelect.innerHTML = ""
            
            var mysecs: [CustStoreSeccionesSinc] = []
            
            guard let _bid = UUID(uuidString: $0) else{
                return
            }
            
            self.bodid = _bid
            
            seccions.forEach { secid, sec in
                
                if sec.custStoreBodegas == self.bodid {
                    mysecs.append(sec)
                }
            }
            
            self.secSelect.appendChild(
                Option("Seleccione Seccion")
                    .value("")
            )
            
            mysecs.forEach { section in
                self.secSelect.appendChild(
                    Option(section.name)
                        .value(section.id.uuidString.uppercased())
                )
            }
            
            if let sec = self.sec {
                
                let secsids = mysecs.map{ $0.id}
                
                if secsids.contains(sec) {
                    self.secidstr = sec.uuidString.uppercased()
                    self.secSelect.disabled(true)
                }
            }
            
            // =
            
            
        }
        
        $secidstr.listen {
            self.secid = UUID(uuidString: $0)
        }
        
        /// Asighn  place if has been provided
        bodid = bod
        
        secid = sec
        
        print("⭐️  001")
        if let id = self.bodid {
            print("⭐️  002")
            if let data = bodegas[id] {
                print("⭐️  003")
                self.bodView.appendChild(Span(data.name).color(.gray))
            }
        }
        
        if let id = self.secid {
            if let data = seccions[id] {
                self.secView.appendChild(Span(data.name).color(.gray))
            }
        }
        
        if let store {
            
            if store != custCatchStore {
                self.bodSelect.hidden(true)
                self.secSelect.hidden(true)
                
                self.bodView.hidden(false)
                self.secView.hidden(false)
                return
            }
            
            var mybods: [CustStoreBodegasSinc] = []
            
            bodegas.forEach { id, data in
                
                if data.custStore == store {
                    mybods.append(data)
                }
                
            }
            
            if (bodid == nil) {
                if mybods.count == 1 {
                    /// no pre selected  bod provided  will  preselect first
                    bodid = mybods.first?.id
                }
            }
            
            mybods.forEach { bod in
                
                let opt = Option(bod.name)
                    .value(bod.id.uuidString)
                
                if bodid == bod.id {
                    opt.selected(true)
                }
                
                bodSelect.appendChild(opt)
                
            }
            
            if let bodid {
                bodidstr = bodid.uuidString
            }
                        
        }
        else {
            self.bodSelect.hidden(true)
            self.secSelect.hidden(true)
            self.bodView.hidden(false)
            self.secView.hidden(false)
        }
        
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
        $bodidstr.removeAllListeners()
        $secidstr.removeAllListeners()
        
    }
}



