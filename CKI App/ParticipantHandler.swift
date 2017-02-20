import Foundation
import UIKit

class ParticipantHandler: UICollectionViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    
    @IBOutlet weak var eventName: UILabel!
    var selectedName = 0
    var selectedPerson = String()
    var backgroundColor = Int()
    var EventParticipants = [String]()
    //var eventYear:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor(netHex:backgroundColor)
        print(EventParticipants)
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
        name.text = EventParticipants[indexPath.row]
        
        let checkIn = participant.viewWithTag(2) as! UIButton
        checkIn.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)

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

