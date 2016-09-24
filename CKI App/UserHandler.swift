import Foundation
import UIKit

class UserHandler: UIViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var canDrive: UILabel!
    @IBOutlet weak var needRide: UILabel!
    var userEventName = String()
    var timePassed = Bool()
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var canDriveSwitch: UISwitch!
    @IBOutlet weak var needRideSwitch: UISwitch!
    var backgroundColor = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex:backgroundColor)
        eventName.text = userEventName
        if (timePassed == false){
            submitButton.setTitle("Sign Up", forState: .Normal)
            submitButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        }else{
            submitButton.setTitle("Check In", forState: .Normal)
            userEmail.hidden = true
            userPhone.hidden = true
            canDrive.hidden = true
            needRide.hidden = true
            emailTextfield.hidden = true
            phoneTextfield.hidden = true
            canDriveSwitch.hidden = true
            needRideSwitch.hidden = true
            submitButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        }
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
        //get eventName from call
        //get eventTime from call
        //get eventDescrpition from server
        //get eventPeople from server
    }
    
    func buttonTapped(sender: UIButton!) {
        if (nameTextfield.text == ""){
            print("Please enter your name")
        }else{
            let signName = "Thank you for signing up " + nameTextfield.text! + "!"
            let checkName = "Thank you for checking in " + nameTextfield.text! + "!"
            let buttonName = submitButton.titleLabel!.text
            if (buttonName == "Sign Up"){
                let alertController = UIAlertController(title: signName, message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }else if (buttonName == "Check In"){
                let alertController = UIAlertController(title: checkName, message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func dismissToEvent(){
        //after clicking check in or sign up, user dismiss the alert and is returned to event page
    }
}

