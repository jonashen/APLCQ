//
//  ComputerVision.swift
//  trodroEC
//
//  Created by Princess Candice on 3/21/18.
//

import Foundation

class ComputerVision {
    var sysState:String = ""
    var targetXCoord = 0
    var targetYCoord = 1
    func stateChange(newState:String){
        sysState = newState
    }
    func setTargetCoordinates(xcoord:Int,ycoord:Int){
        targetXCoord = xcoord
        targetYCoord = ycoord
    }
}
