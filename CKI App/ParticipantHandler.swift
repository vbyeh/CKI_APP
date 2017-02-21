import Foundation
import UIKit
import AWSDynamoDB

class ParticipantHandler: UICollectionViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    
    @IBOutlet weak var eventName: UILabel!
    var selectedName = 0
    var selectedPerson = String()
    var backgroundColor = Int()
	var currEventID = String()
	var currEventDate = String()
    var EventParticipants :[(person: String, status: Int)] = []
    //var eventYear:String!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor(netHex:backgroundColor)
		
		let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
		dynamoDBObjectMapper.load(Item.self, hashKey: currEventID, rangeKey: currEventDate).continueWithSuccessBlock( { (task:AWSTask!) -> AnyObject! in
		
		NSLog("Load participants - success")
		let item = task.result as! Item
		for (name, val) in item.Participants{
		//1 = checked out
		//0 = currently checked in
		//-1 = not yet checked in
			if (val.count > 1) {
				self.EventParticipants.append((person: name, status: 1))
			}else if (val.values.first == "null"){
				self.EventParticipants.append((person: name, status: -1))
			}else{
				self.EventParticipants.append((person: name, status: 0))
			}
		}
		
		if let error = task.error as NSError! {
			print("The request failed. Error: \(error)")
			return nil
		}
		
		dispatch_async(dispatch_get_main_queue()){ self.collectionView?.reloadData()}
		return nil
		})
		
        // Do any additional setup after loading the view, typically from a nib.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return EventParticipants.count
    }
    
    //fill in each collection cell with values
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Replace below with data
		let participant = collectionView.dequeueReusableCellWithReuseIdentifier("participant", forIndexPath: indexPath) as UICollectionViewCell
		
        let name = participant.viewWithTag(1) as! UILabel
        name.text = EventParticipants[indexPath.row].person
		
		let checkIn = participant.viewWithTag(2) as! UIButton
		if (EventParticipants[indexPath.row].status == 1){
			checkIn.hidden = true
		}else if (EventParticipants[indexPath.row].status == 0){
			name.font = UIFont.boldSystemFontOfSize(16)
			name.textColor = UIColor .blueColor()
			//Write current time to dynamoDB checkout
			checkIn.titleLabel!.text = "Check Out"
			checkIn.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
		}else if (EventParticipants[indexPath.row].status == -1){
			checkIn.titleLabel!.text = "Check In"
			checkIn.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
		}
        return participant
    }
    
    func buttonTapped(sender: UIButton!) {
        let view = sender.superview!
        let cell = view.superview as! UICollectionViewCell
        let name = cell.viewWithTag(1) as! UILabel
        let button = cell.viewWithTag(2) as! UIButton
        let helloName = "Would you like to check in as " + name.text! + "?"
        let byeName = "Would you like to check out as " + name.text! + "?"
        let buttonText = button.titleLabel!.text
        if (buttonText == "Check In"){
            let alertController = UIAlertController(title: helloName, message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Check In", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in self.userCheckedIn(name, button: button)}))
        
            self.presentViewController(alertController, animated: true, completion: nil)
			
			let todayDate = NSDate()
			let styler = NSDateFormatter()
			styler.dateFormat = "HH:MM"
			
			let dynamoDB = AWSDynamoDB.defaultDynamoDB()
			let updateInput = AWSDynamoDBUpdateItemInput()
			
			let hashKeyVal = AWSDynamoDBAttributeValue()
			let rangeKeyVal = AWSDynamoDBAttributeValue()
			hashKeyVal.S = currEventID
			rangeKeyVal.S = currEventDate
			
			updateInput.tableName = "Event"
			updateInput.key = ["ID": hashKeyVal, "EventDate": rangeKeyVal]
			
			let curr_time = AWSDynamoDBAttributeValue()
			curr_time.S = styler.stringFromDate(todayDate)
			
			let checkin = AWSDynamoDBAttributeValue()
			checkin.M = ["CheckIn": curr_time]
			
			let dictionaryInRightFormat:NSDictionary = [":stringKey": checkin]
			updateInput.expressionAttributeValues = dictionaryInRightFormat as? [String : AWSDynamoDBAttributeValue]
			
			updateInput.expressionAttributeNames = ["#name": name.text!]
			updateInput.conditionExpression = "attribute_exists(Participants.#name)"
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
			
        }else if (buttonText == "Check Out"){
			let alertController = UIAlertController(title: byeName, message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Check Out", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in self.userCheckedOut(name, button: button)}))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //Check if user is currently checked in, other wise check out
    func userCheckedIn(name: UILabel!, button: UIButton!){
        name.font = UIFont.boldSystemFontOfSize(16)
        name.textColor = UIColor .blueColor()
        //Write current time to dynamoDB checkout
        button.setTitle("Check Out", forState: .Normal)
    }
    
    func userCheckedOut(name: UILabel!, button: UIButton){
        name.font = UIFont.boldSystemFontOfSize(16)
        name.textColor = UIColor .grayColor()
        //Write current time to dynamoDB checkout
        button.hidden = true
    }
}

