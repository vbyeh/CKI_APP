import UIKit
import AWSDynamoDB
import Foundation

class Welcome: UIViewController {
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
        /*
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        recognizer.direction = .Up
        self.view .addGestureRecognizer(recognizer)
         */
    
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.limit = 50;
        dynamoDBObjectMapper.scan(Item.self, expression: queryExpression).continueWithBlock({ (task:AWSTask!) -> AnyObject! in
            
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                
                for item in paginatedOutput.items as! [Item] {
                    //NSLog(item.M!.stringValue)
                    self.Name.append(item.Name)
                    var dateArray = item.Date.componentsSeparatedByString("/")
                    self.Month.append(dateArray[0])
                    self.Date.append(dateArray[1])
                    self.Year.append(dateArray[2])
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
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(finishLoading), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "welcome"){
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let collection:CollectionViewController = destinationNavigationController.topViewController as! CollectionViewController
            
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
    
    func finishLoading() {
        self.performSegueWithIdentifier("welcome", sender: self)
    }
 
}