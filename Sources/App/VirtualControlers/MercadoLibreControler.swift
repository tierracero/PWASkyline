//
//  MercadoLibreControler.swift
//  
//
//  Created by Victor Cantu on 10/20/23.
//

import Foundation
import TCFundamentals
import Web

private var mercadoLibreControler = MercadoLibreControler()

public class MercadoLibreControler {
    
    @State public internal(set) var profile: MercadoLibreProfile? = nil
    
    init () {}
    
    static var shared: MercadoLibreControler { mercadoLibreControler }
    
    public static var currentState: State<MercadoLibreProfile?> {
        get { shared._profile }
        set { shared._profile = newValue }
    }
    
}
