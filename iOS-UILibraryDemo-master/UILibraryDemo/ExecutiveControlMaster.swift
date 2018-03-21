//
//  ExecutiveControlMaster.swift
//  UILibraryDemo
//  Copyright © 2018 DJI. All rights reserved.
//

import Foundation


import Foundation

class ExecutiveControl {
    var sysState:String = ""
    func updateState(state: String) {
        sysState = state
        //after this call each subsystems method stateChange(sysState)
        DroneCommunication.stateChange(state)
        FlightControl.stateChange(state)
        ComputerVision.stateChange(state)
        UserInterface.stateChange(state)
        
    }
    
    
    func targetSelected(x:Int, y:Int) {
        ComputerVision.setTargetCoordinates(x,y)
        updateState("DR")
    }
    func error(error: String){
        //target is lost during reposition or landing
        if error == "target lost"{
            UI.sendMessage("Target has been Lost. Please re-select target.")
            updateState("FF")
        }
        if error == "connection failed"{
            //send UI an error message to show "Network Connection Down" and update state to free flying
            UI.sendMessage("Connection Failed.")
            updateState("FF")
        }
        if error == "no targets found"{
            //send UI error message "No targets were found. Please try again."
            UI.sendMessage("No targets Found. Please Try Again.")
            //update state to free flying
            updateState("FF")
        }
        
    }
    
    //drone repositioning
    class droneReposition{ ////to creaate an instance of this var dc = ExecutiveControl.DroneReposition(EC instance)
        init(ec:ExecutiveControl){
            var camera90:Bool = false
            var frameCentered:Bool = true
            func camera90Confirm(){
                camera90 = true
                droneRepoComplete()
            }
            func frameCenteredConfirm(){
                frameCentered = true
                droneRepoComplete()
            }
            func droneRepoComplete(){
                if (camera90 == true && frameCentered == true){
                    ExecutiveControl.updateState("DRC")
                }
            }
        }
    }
}
