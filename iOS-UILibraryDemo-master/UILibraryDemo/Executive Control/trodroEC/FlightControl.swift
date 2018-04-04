//
//  FlightControl.swift
//  trodroEC
//
//  Created by Princess Candice on 3/21/18.
//

import Foundation

class FlightControl {
    var sysState:String = ""
    func stateChange(newState:String){
        sysState = newState
    }
}
