//
//  Executive.swift
//  trodroEC
//
//  Created by Princess Candice on 2/26/18.
//

import Foundation

    class ExecutiveControl {
        let dc = DroneCommunication()
        let fc = FlightControl()
        let cv = ComputerVision()
        let UI = UserInterface()
        var sysState:String = ""
        func updateState(state: String) {
            sysState = state
            //after this call each subsystems method stateChange(sysState)
            dc.stateChange(newState:state)
            fc.stateChange(newState:state)
            cv.stateChange(newState:state)
            //UserInterface.stateChange(state)
        
        }
    
        func targetsBeingDetected(){ //UI will call once user taps on screen for CV to find targets
            updateState(state: "TD")
        }
        func targetBeingSelected(){ //UI will call right when they receive the coordinates of all potential targets
            updateState(state: "TS")
        }
         func targetSelected(x:Int, y:Int) { //UI will call this to notify EC
            cv.setTargetCoordinates(xcoord:x,ycoord:y)
            updateState(state:"DR")
        }
        func targetConfirmed(yesNo:Bool){
            if (yesNo == true){ //we can begin landing
                updateState(state: "DR")
            }
            else {//target was denied and cancel button was pressed
                updateState(state: "FF") //give control back to user
            }
        }
        func landingComplete(){ //drone communication will call this once the drone has been landed
            updateState(state: "Landed")
        }
         func error(error: String){ //will handle any error
            //target is lost during reposition or landing
//            if error == "target lost"{
//                UI.sendMessage(message: "Target has been Lost. Please re-select target.")
//                updateState(state: "FF")
//            }
//            if error == "connection failed"{
//                //send UI an error message to show "Network Connection Down" and update state to free flying
//                UI.sendMessage(message: "Connection Failed.")
//                updateState(state: "FF")
//            }
//            if error == "no targets found"{
//                //send UI error message "No targets were found. Please try again."
//                UI.sendMessage(message: "No targets Found. Please Try Again.")
//                //update state to free flying
//                updateState(state: "FF")
//            }
            UI.sendMessage(message: error)
            updateState(state: "FF")

        }
    
    //drone repositioning
        class droneReposition{ //to creaate an instance of this var dc = ExecutiveControl.DroneReposition(EC instance)
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
                        ec.updateState(state: "DRC")
                    }
                }
            }
        }
}
