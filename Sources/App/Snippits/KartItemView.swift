//
//  KartItemView.swift
//  
//
//  Created by Victor Cantu on 2/20/22.
//

import Foundation
import TCFundamentals
import Web

class KartItemView: Tr {
	
	override class var name: String { "tr" }
	
	var deleteButton: Bool
	
	var id: UUID
	var cost: Int64
	@State var quant: Int64
    @State var price: Int64
	var data: SearchChargeResponse
    var missingInventory: Bool
	
    private var callback: ((
        _ id: UUID
    ) -> ())
    
    private var editManualCharge: ((
        _ id: UUID,
        _ units: Int64,
        _ description: String,
        _ price: Int64,
        _ cost: Int64
    ) -> ())
	
	init(
		id: UUID,
		cost: Int64,
		quant: Int64,
        price: Int64,
		data: SearchChargeResponse,
		deleteButton: Bool = true,
        missingInventory: Bool = false,
		callback: @escaping ((
            _ id: UUID
        ) -> ()),
        editManualCharge: @escaping ((
            _ id: UUID,
            _ units: Int64,
            _ description: String,
            _ price: Int64,
            _ cost: Int64
        ) -> ())
	) {
		self.id = id
		self.cost = cost
		self.quant = quant
        self.price = price
		self.data = data
		self.deleteButton = deleteButton
        self.missingInventory = missingInventory
		self.callback = callback
        self.editManualCharge = editManualCharge
		super.init()
	}
	
	required init() {
		fatalError("init() has not been implemented")
	}
    
    @State var name = ""
    
    @State var total: Int64 = 0
    
    @State var viewDetailButton = false
    
    var items: [CustPOCInventorySoldObject] = []
    
    lazy var img = Img()
        .src("/skyline/media/tc-logo-32x32.png")
        .height(16.px)
        .marginRight(7.px)
    
	@DOM override var body: DOM.Content {
        
		if self.deleteButton {
			Td{
				Img()
                    .src( (self.data.t == .manual) ? "/skyline/media/pencil.png" : "/skyline/media/cross.png")
                    .width(18.px)
					.onClick {
                        
                        if self.data.t == .manual {
                            
                            let view = BudgetManualChargeView { units, description, price, cost in
                                
                                self.cost = cost
                                
                                self.price = price
                                
                                self.quant = units / 100
                                
                                self.name = description
                                
                                self.total = (units / 100) * price
                                
                                self.data = .init(
                                    t: .manual,
                                    i: self.data.i,
                                    u: self.data.u,
                                    n: description,
                                    b: self.data.b,
                                    m: self.data.m,
                                    p: price,
                                    a: self.data.a,
                                    reqSeries: self.data.reqSeries
                                )

                                self.editManualCharge(self.id, units, description, price, cost)
                                
                            } removeCharge: {
                                self.callback(self.id)
                                self.remove()
                            }
                            
                            view.units = (self.quant * 100).formatMoney
                            view.descr = self.name
                            view.price = self.price.formatMoney
                            view.cost = self.cost.formatMoney
                            view.removeButtonIsHidden = false
                            
                            addToDom(view)
                            
                        }
                        else {
                            self.callback(self.id)
                            self.remove()
                        }
                        
					}
			}
			.align(.center)
		}
		
        Td(self.data.b)
        Td{
            Span(self.$name)
            Strong("** EN PEDIDO **")
                .hidden(!self.missingInventory)
                .marginLeft(7.px)
                .color(.red)
        }
        //Td("Hubicación")
        Td(self.$quant.map{ $0.toString })
            .align(.center)
        Td(self.$price.map{ $0.formatMoney })
            .align(.center)
        Td(self.$total.map{ $0.formatMoney })
            .align(.center)
        
        Td{
            Img()
                .src("skyline/media/maximizeWindow.png")
                .class(.iconWhite)
                .cursor(.pointer)
                .width(18.px)
                .onClick {
                    self.viewSoldItems()
                }
        }
        .hidden(self.$viewDetailButton.map{ !$0 })
        .align(.center)
        
	}
	
	override func buildUI() {
        self.padding(all: 12.px)
		self.color(.black)
        
        name = "\(data.m) \(data.n)"
        
        total = quant * price
	}
	
    func viewSoldItems(){
        
        if items.count == 1 {
            addToDom(InventoryItemDetailView(itemid: items.first!.id){ price in
                
            })
        }
        else {
            addToDom(SalePointView.SelectItemView(items: items) )
        }
        
    }
    
}
