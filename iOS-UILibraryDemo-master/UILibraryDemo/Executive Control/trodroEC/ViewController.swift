//
//  ViewController.swift
//  trodroEC
//
//  Created by Princess Candice on 2/26/18.
//

import UIKit

class ViewController: UIViewController {
    var executiveControlInstance:ExecutiveControl!
    @IBOutlet weak var DCState: UILabel!
    @IBOutlet weak var CVState: UILabel!
    @IBOutlet weak var UIState: UILabel!
    @IBOutlet weak var FCState: UILabel!
    @IBOutlet weak var xCoordinate: UILabel!
    @IBOutlet weak var xCoordInput: UITextField!
    @IBOutlet weak var yCoordinate: UILabel!
    @IBOutlet weak var yCoordInput: UITextField!
    @IBOutlet weak var droneRepositionedStatus: UILabel!
    @IBOutlet weak var camera90State: UILabel!
    @IBOutlet weak var ECstate: UILabel!
    @IBOutlet weak var frameCenteredState: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var errorMessageInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        executiveControlInstance = ExecutiveControl()
    }

    
 
    
    @IBAction func sendError(_ sender: Any) {
        let newerror:String = errorMessageInput!.text!
        executiveControlInstance.error(error: newerror)
    }
    //    @IBAction func sendError(_ sender: Any) {
//        let newerror:String = errorMessageInput!.text!
//        executiveControlInstance.error(error: newerror)
//    }
    @IBAction func landed(_ sender: Any) {
        executiveControlInstance.landingComplete()
    }
    @IBAction func setTargetCoordinates(_ sender: Any) {
    }
    @IBAction func targetDenied(_ sender: Any) {
        executiveControlInstance.targetConfirmed(yesNo: false)
    }
    @IBAction func targetConfirmed(_ sender: Any) {
         executiveControlInstance.targetConfirmed(yesNo: true)
    }
    @IBAction func frameCenteredNotification(_ sender: Any) {
    }
    @IBAction func camera90notification(_ sender: Any) {
    }
    @IBAction func targetSelecter(_ sender: Any) {
        executiveControlInstance.targetBeingSelected()
    }
    @IBAction func targetDetected(_ sender: Any) {
        executiveControlInstance.targetsBeingDetected()
    }
    @IBAction func viewCoordinates(_ sender: Any) {
    }
    @IBAction func showUpdates(_ sender: Any) {
        ECstate.text = executiveControlInstance.sysState
        DCState.text = executiveControlInstance.sysState
        UIState.text = executiveControlInstance.sysState
        FCState.text = executiveControlInstance.sysState
        CVState.text = executiveControlInstance.sysState
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

