import Foundation
import UIKit
import MapKit

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

class EventHandler: UIViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var participantButton: UIButton!
    @IBOutlet weak var eventDescription: UITextView!
    let eventPeople = UILabel()
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var passedEventYear = String()
    var passedEventMonth = String()
    var passedEventDate = String()
    var passedEventName = String()
    var passedEventTime = String()
    var passedEventEndTime = String()
    var passedEventColor = Int()
    var passedEventDescription = String()
    var timeBool = Bool()
    var eventTimeString = String()
    var timeString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HOK")
        self.view.backgroundColor = UIColor(netHex:passedEventColor)
        eventTimeString = passedEventTime + " - " + passedEventEndTime
        eventName.text = passedEventName
        eventTime.text = eventTimeString
        timeString = passedEventYear + "-" + passedEventMonth + "-" + passedEventDate + "T" + passedEventTime
         if (timeCompare(timeString) == true){
         submitButton.setTitle("Sign Up", forState: .Normal)
         timeBool = false
         }else{
         submitButton.setTitle("Check In", forState: .Normal)
         timeBool = true
         }
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
            User.timePassed = timeBool
            User.backgroundColor = passedEventColor
        }else if (segue.identifier == "participant"){
            let Participant:ParticipantHandler = segue.destinationViewController as! ParticipantHandler
            Participant.timeHasPassed = timeBool
            Participant.backgroundColor = passedEventColor
        }
    }
    
    func timeCompare(stringDate: String)->Bool{
        let currentDate: NSDate = NSDate()
        //let eventDate: NSDate = NSDate(dateString:"2016-03-23T23:06")
        //print(stringDate)
        let eventDate: NSDate = NSDate(dateString:stringDate)
        if (currentDate == currentDate.earlierDate(eventDate)){
            return true
        }else{
            return false
        }
    }
}
