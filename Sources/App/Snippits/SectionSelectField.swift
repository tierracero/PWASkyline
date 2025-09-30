//
//  SectionSelectField.swift
//  
//
//  Created by Victor Cantu on 2/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class SectionSelectField: Div {
    
    override class var name: String { "div" }
    
    let storeid: UUID
    
    let storeName: String
    
    let bodid: UUID
    
    let bodName: String
    
    private var callback: ((
        _ section: CustStoreSeccionesSinc
    ) -> ())
    
    init(
        storeid: UUID,
        storeName: String,
        bodid: UUID,
        bodName: String,
        callback: @escaping ((
            _ section: CustStoreSeccionesSinc
        ) -> ())
    ) {
        self.storeid = storeid
        self.storeName = storeName
        self.bodid = bodid
        self.bodName = bodName
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var sectionSelectResultIsHidden = true
    
    @State var sectionSelectText = ""
    
    var sectionSelectId: UUID? = nil
    
    var availableSection: [CustStoreSeccionesSinc] = []
    
    @State var displayedSection: [CustStoreSeccionesSinc] = []
    
    lazy var sectionSelectFiled = InputText(self.$sectionSelectText)
        .class(.textFiledBlackDark)
        .placeholder("Seleccione Seccion")
        .width(90.percent)
        .fontSize(23.px)
        .height(28.px)
        .onFocus({ tf in
            tf.select()
            self.processSectionPrase(self.sectionSelectText)
            self.sectionSelectResultIsHidden = false
        })
        .onBlur{
            Dispatch.asyncAfter(0.3) {
                
                if let sectid = self.sectionSelectId {
                    self.sectionSelectText = seccions[sectid]?.name ?? ""
                }
                
                self.sectionSelectResultIsHidden = true
            }
        }
    
    lazy var sectionSelectResult = Div{
        
    }
        .hidden(self.$sectionSelectResultIsHidden)
        .backgroundColor(.grayBlackDark)
        .borderRadius(all: 12.px)
        .padding(all: 7.px)
        .width(70.percent)
        .minHeight(100.px)
        .maxHeight(400.px)
        .overflow(.auto)
    
    @DOM override var body: DOM.Content {
        
        self.sectionSelectFiled
        
        Div{
            self.sectionSelectResult
            Div("+ Agregar Seccion")
                .hidden(self.$sectionSelectResultIsHidden)
                .align(.center)
                .class(.uibtnLarge)
                .width(70.percent)
                .marginTop(7.px)
                .onClick {
                    self.addSection(text: "")
                }
        }
        .position(.absolute)
        .width(95.percent)
        .marginTop(7.px)
        .zIndex(1)
        
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        var sectionRefrence: [String:CustStoreSeccionesSinc] = [:]

        seccions.forEach { item, sect in
            if sect.custStoreBodegas == bodid {
                sectionRefrence[sect.name] = sect
            }
        }

        let sorted = sectionRefrence.sorted { $0.0 > $1.0 }

        self.availableSection = sorted.map{$1}
        
        $sectionSelectText.listen {
            self.processSectionPrase($0)
        }
        
        $displayedSection.listen {
            
            self.sectionSelectResult.innerHTML = ""
            
            /// if no results
            if $0.isEmpty {
                /// if text is not empy
                if !self.sectionSelectText.isEmpty {
                    self.sectionSelectResult.appendChild(
                        Div("+ Agregar \"\(self.sectionSelectText)\"")
                            .backgroundColor(.grayBlack)
                            .class(.uibtnLarge)
                            .width(95.percent)
                            .align(.center)
                            .color(.white)
                            .onClick {
                                self.addSection(text: self.sectionSelectText)
                            }
                    )
                }
            }
            
            $0.forEach { section in
                self.sectionSelectResult.appendChild(
                    Div(section.name)
                        .class(.uibtnLarge)
                        .width(95.percent)
                        .backgroundColor(.grayBlack)
                        .color(.white)
                        .onClick {
                            
                            self.sectionSelectText = section.name
                            self.sectionSelectId = section.id
                            self.callback(section)
                        }
                )
            }
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func processSectionPrase(_ rawTerm: String) {
        
        let term = rawTerm.purgeSpaces.uppercased()
        
        if term.isEmpty {
            self.displayedSection = self.availableSection
            return
        }
        
        var sections: [CustStoreSeccionesSinc] = []
        
        var included: [String] = []
        
        // Starts with
        self.availableSection.forEach { section in
            if section.name.uppercased().hasPrefix(term) {
                sections.append(section)
                included.append(section.name)
            }
        }
        
        // Contains
        self.availableSection.forEach { section in
            if section.name.uppercased().contains(term) && !included.contains(section.name){
                sections.append(section)
            }
        }
        
        self.displayedSection = sections
    }
    
    func addSection(text: String) {
        addToDom(CreateSectionView(
            storeid: storeid,
            storeName: storeName,
            bodid: bodid,
            bodName: bodName,
            sectionName: text,
            callback: { sec in
                
                seccions[sec.id] = sec
                
                self.availableSection.append(sec)

                self.displayedSection.append(sec)
                
                self.sectionSelectText = sec.name
                
                self.sectionSelectId = sec.id

                self.callback(sec)
                
            }))
    }
    
}
