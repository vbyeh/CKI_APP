import UIKit
import AWSDynamoDB
import Foundation

//Loading screen that loads DynamoDB data onto iOS device
class Welcome: UIViewController {
	var ID = [String]()
    var Name = [String]()
    var Month = [String]()
    var Date = [String]()
    var Year = [String]()
    var Location = [String]()
    var Time = [String]()
    var End_Time = [String]()
    var Type = [Int]()
    var Description = [String]()
	var Participants = [[String:[String:String]]]()
    override func viewDidLoad() {

		let todayDate = NSDate()
		let styler = NSDateFormatter()
		styler.dateFormat = "yyyy-MM-dd"
		let todaysDate = styler.stringFromDate(todayDate)
		let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
		let queryExpression = AWSDynamoDBQueryExpression()
		
		queryExpression.indexName = "Dummy-EventDate-index"
		queryExpression.keyConditionExpression = "Dummy = :num AND EventDate >= :val"
		queryExpression.expressionAttributeValues = [":num" : "0", ":val": todaysDate]
		queryExpression.limit = 50; //limit number of events to 50
		dynamoDBObjectMapper.query(Item.self, expression: queryExpression).continueWithBlock({ (task:AWSTask!) -> AnyObject! in
			
			if task.result != nil {
				let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
				
				for item in paginatedOutput.items as! [Item] {
					//iterate through each item in event and append to designated array
					self.ID.append(item.ID)
					self.Name.append(item.Name)
					var dateArray = item.EventDate.componentsSeparatedByString("-")  //split date into month, date, and year
					self.Year.append(dateArray[0])
					self.Month.append(dateArray[1])
					self.Date.append(dateArray[2])
					self.Location.append(item.Location)
					self.Time.append(item.Time)
					self.End_Time.append(item.End_Time)
					self.Type.append(item.Type)
					self.Description.append(item.Description)
					self.Participants.append(item.Participants)
				}
				if ((task.error) != nil) {
					print("Error: \(task.error)")
				}
				return nil
			}
			
			return nil
		})
        super.viewDidLoad()
        //Loading screen for 3 seconds to load necessary data, then segue
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(finishLoading), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //on segue, pass parameters
        if (segue.identifier == "welcome"){
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let collection:CollectionViewController = destinationNavigationController.topViewController as! CollectionViewController

			collection.ID = self.ID
            collection.Name = self.Name
            collection.Month = self.Month
            collection.Date = self.Date
            collection.Year = self.Year
            collection.Time = self.Time
            collection.EndTime = self.End_Time
            collection.Type = self.Type
            collection.Description = self.Description
			collection.Participants = self.Participants
        }
    }
    
    /*
     func loadSettings(){
        //load settings from user configuration
     }
    */
    
    func finishLoading() {
        self.performSegueWithIdentifier("welcome", sender: self)
    }
 
}