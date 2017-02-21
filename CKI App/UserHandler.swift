import Foundation
import UIKit
import AWSDynamoDB
import AWSCore

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
	var eventID = String()
	var eventDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex:backgroundColor)
        eventName.text = userEventName
		submitButton.setTitle("Sign Up", forState: .Normal)
        submitButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
        //get eventName from call
        //get eventTime from call
        //get eventDescrpition from server
        //get eventPeople from server
    }
    
    //Determine whether to sign up or check in based on name field
    func buttonTapped(sender: UIButton!) {
		let dynamoDB = AWSDynamoDB.defaultDynamoDB()
		let updateInput = AWSDynamoDBUpdateItemInput()
		
		let hashKeyVal = AWSDynamoDBAttributeValue()
		let rangeKeyVal = AWSDynamoDBAttributeValue()
		hashKeyVal.S = eventID
		rangeKeyVal.S = eventDate
		
		updateInput.tableName = "Event"
		updateInput.key = ["ID": hashKeyVal, "EventDate": rangeKeyVal]
	
        if (nameTextfield.text == ""){
            let alertController = UIAlertController(title: "Please enter your name", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
			let signName = "Thank you for signing up " + nameTextfield.text! + "!"
			
			let checkin = AWSDynamoDBAttributeValue()
			checkin.S = "null"

			let newParticipant = AWSDynamoDBAttributeValue()
			newParticipant.M = ["CheckIn": checkin]
			
			let dictionaryInRightFormat:NSDictionary = [":stringKey": newParticipant]
			updateInput.expressionAttributeValues = dictionaryInRightFormat as? [String : AWSDynamoDBAttributeValue]
			
			updateInput.expressionAttributeNames = ["#name": nameTextfield.text!]
			updateInput.conditionExpression = "attribute_not_exists(Participants.#name)"
			updateInput.updateExpression = "SET Participants.#name = :stringKey"
			
			updateInput.returnValues = .UpdatedNew
			dynamoDB.updateItem(updateInput!).continueWithBlock( { (task:AWSTask!) -> AnyObject! in
				
				NSLog(task.description)
				
				if let error = task.error as NSError! {
					print("The request failed. Error: \(error)")
					return nil
				}
				
				// Do something with task.result
				
				return nil
			})
			
			let alertController = UIAlertController(title: signName, message:
		"", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
			self.presentViewController(alertController, animated: true, completion: nil)
            }
    }
	
    func dismissToEvent(){
        //after clicking check in or sign up, user dismiss the alert and is returned to event page
    }
}

