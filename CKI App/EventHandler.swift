import Foundation
import UIKit
import MapKit
import AWSDynamoDB

class EventHandler: UIViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var participantButton: UIButton!
    @IBOutlet weak var eventDescription: UITextView!
    let eventPeople = UILabel()
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var mapView: MKMapView!
	var passedEventID = String()
    var passedEventYear = String()
    var passedEventMonth = String()
    var passedEventDate = String()
    var passedEventName = String()
    var passedEventTime = String()
    var passedEventEndTime = String()
    var passedEventColor = Int()
    var passedEventDescription = String()
    var passedEventParticipants = [String:[String:String]]()
    var currCheckedInParticipants = String()
    var eventTimeString = String()
    var timeString = String()
	var eventDateString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBScanExpression()
		/*
        dynamoDBObjectMapper.scan(Item.self, expression: queryExpression).continueWithBlock({ (task:AWSTask!) -> AnyObject! in
            
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                
                for item in paginatedOutput.items as! [Item] {
                    //iterate through each item in event and append to designated array
                    self.passedEventParticipants.append(item.Participants)
                }
                
                if (self.currCheckedInParticipants != ""){
                    // write to database
                    print(self.currCheckedInParticipants)
                }
                
                if ((task.error) != nil) {
                    print("Error: \(task.error)")
                }
                return nil
                
            }
            
            return nil
        })
        
		*/
        self.view.backgroundColor = UIColor(netHex:passedEventColor)
        eventTimeString = passedEventTime + " - " + passedEventEndTime
        eventName.text = passedEventName
        eventTime.text = eventTimeString
		eventDateString = passedEventYear + "-" + passedEventMonth + "-" + passedEventDate
        timeString = passedEventYear + "-" + passedEventMonth + "-" + passedEventDate + " " + passedEventTime
		
        //Determines if current time is later than desginated time, if it is, user is checking in, otherwise, user is signning up
         //if (timeCompare(timeString) == true){
		submitButton.setTitle("Sign Up", forState: .Normal)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
        participantButton.layer.cornerRadius = 5
        participantButton.layer.borderWidth = 1
        participantButton.layer.borderColor = UIColor.blackColor().CGColor
        eventDescription.backgroundColor = UIColor(netHex: passedEventColor)
        eventDescription.text = passedEventDescription
        //*******Change so able to generate location based on address********
        let location = CLLocationCoordinate2D(
            latitude: 38.5382,
            longitude: -121.7617
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "UC Davis"   //Title of the place if applicable
        annotation.subtitle = "1 Shields Ave, Davis, CA 95616"   //Address
        mapView.addAnnotation(annotation)
        //*******************************************************************
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "userSegue"){
            let User:UserHandler = segue.destinationViewController as! UserHandler
            User.userEventName = passedEventName
			User.eventID = passedEventID
			User.eventDate = eventDateString
            User.backgroundColor = passedEventColor
        }else if (segue.identifier == "participant"){
            let Participant:ParticipantHandler = segue.destinationViewController as! ParticipantHandler
            Participant.backgroundColor = passedEventColor
            
            //Load all participants given the keys
            //iterate through user names for display when participant is pressed
            for (name,_) in passedEventParticipants{
				Participant.EventParticipants.append(name)
                }
            }
        }
    }
    
    //Comparison function to determine if current time is earlier or later than event time
    func timeCompare(stringDate: String)->Bool{
		let todayDate = NSDate()
		let styler = NSDateFormatter()
		styler.dateFormat = "yyyy-MM-dd HH:MM"
		let todaysDate = styler.stringFromDate(todayDate)

        if (todaysDate < stringDate){
            return true
        }else{
            return false
        }
    }
