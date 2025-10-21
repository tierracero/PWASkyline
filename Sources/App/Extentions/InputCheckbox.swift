//
//  InputCheckbox.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web

extension InputCheckbox {
    
    public func toggleRental(_ isReady: State<Bool>, _ isDisabled: State<Bool>, callback: @escaping ( (_ isChecked: Bool) -> () ) ) ->  Label {
        
        let toggle = Span()
        
        if isDisabled.wrappedValue {
            toggle.class(.alpha3)
        }
        
        isDisabled.listen {
            if $0 {
                toggle.class(.alpha3)
            }
            else {
                toggle.removeClass(.alpha3)
            }
        }
        
        return Label {
            
            InputCheckbox(isReady)
                .disabled(true)

            toggle
                .class(.slider, .round)
                .cursor(isDisabled.map{ $0 ? .default : .pointer })
                .onClick {
                    if isDisabled.wrappedValue {
                        return
                    }
                    callback(isReady.wrappedValue)
                }
        }
        .class(.switch)
        .float(.left)
    }
    
    public func toggle(_ isReady: State<Bool>, _ isDisabled: Bool = false) ->  Label {
        
        let toggle = Span()
        
        return Label {
            
            InputCheckbox(isReady)
                .disabled(isDisabled)
            toggle
                .class(.slider, .round)
                .cursor(.pointer)
        }
        .class(.switch)
        .float(.left)
    }
    
    public func toggle(_ isReady: Bool, _ isDisabled: Bool = false) ->  Label {
        
        let toggle = Span()
        
        return Label {
            
            InputCheckbox(isReady)
                .disabled(isDisabled)
            toggle
                .class(.slider, .round)
                .cursor(.pointer)
        }
        .class(.switch)
        .float(.left)
    }
    

    public func toggle(_ isReady: State<Bool>, _ isDisabled: State<Bool>, callback: @escaping ( (_ isChecked: Bool) -> () ) ) ->  Label {
        
        let toggle = Span()
        
        if isDisabled.wrappedValue {
            toggle.class(.alpha3)
        }
        
        isDisabled.listen {
            if $0 {
                toggle.class(.alpha3)
            }
            else {
                toggle.removeClass(.alpha3)
            }
        }
        
        return Label {
            
            InputCheckbox(isReady)
                .disabled(isDisabled)

            toggle
                .class(.slider, .round)
                .cursor(isDisabled.map{ $0 ? .default : .pointer })
                .onClick {
                    if isDisabled.wrappedValue {
                        return
                    }
                    callback(isReady.wrappedValue)
                }
        }
        .class(.switch)
        .float(.left)
    }
}
