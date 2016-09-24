import Foundation
import UIKit

class ParticipantHandler: UICollectionViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    
    @IBOutlet weak var eventName: UILabel!
    var timeHasPassed = Bool()
    var Name = [String]()
    var selectedName = 0
    var selectedPerson = String()
    var backgroundColor = Int()
    //var eventYear:String!
    
    override func viewDidLoad() {
        //temporary hard codes of month and date
        //Month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        Name = ["Bob Yeh", "Bobby Yeh", "Vincent Yeh"]
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor(netHex:backgroundColor)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Name.count
    }
    
    //fill in each collection cell with values
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Replace below with data
        let participant = collectionView.dequeueReusableCellWithReuseIdentifier("participant", forIndexPath: indexPath) as UICollectionViewCell
        
        let name = participant.viewWithTag(1) as! UILabel
        name.text = Name[indexPath.row]
        
        let checkIn = participant.viewWithTag(2) as! UIButton
        
        if (timeHasPassed == true){  //check if time has passed, if it hasn't, you can't check in
            checkIn.hidden = false
        }else{
            checkIn.hidden = true
        }
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
    
    func userCheckedIn(name: UILabel!, button: UIButton!){
        name.font = UIFont.boldSystemFontOfSize(16)
        name.textColor = UIColor .blueColor()
        button.setTitle("Check Out", forState: .Normal)
    }
    
    func userCheckedOut(name: UILabel!, button: UIButton){
        name.font = UIFont.boldSystemFontOfSize(16)
        name.textColor = UIColor .grayColor()
        button.hidden = true
    }
}

