//
//  ViewController.swift
//  CKIAPP
//
//  Created by Vincent Yeh on 3/22/16.
//  Copyright © 2016 Vincent Bob Yeh. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component of Hex color")
        assert(green >= 0 && green <= 255, "Invalid green component of Hex color")
        assert(blue >= 0 && blue <= 255, "Invalid blue component of Hex color")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class CollectionViewController: UICollectionViewController {

    @IBOutlet weak var settingsButton: UIButton!
    var monthName = [String]()
    var Year = [String]()
    var Month = [String]()
    var Date = [String]()
    var Name = [String]()
    var Type = [Int]()
    var Time = [String]()
    var EndTime = [String]()
    var Description = [String]()
    var Participants = [[String:[String:String]]]()
    var serviceColor = 0xb2daff     //lightblue type 1
    var leadershipColor = 0xcbffed    //lightgreen type 0
    var fellowshipColor = 0xeaeaff    //lightpurple type -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //temporary hard codes of month and date
        monthName = ["JAN", "FEB", "MAR", "APR", "MAY", "JUNE", "JULY", "AUG", "SEP", "OCT", "NOV", "DEC"]
        
        self.collectionView?.backgroundColor = UIColor(netHex:0xFFFFFF)
        settingsButton.frame = CGRectMake(0, 0, 30, 30)
        let gears : UIImage = UIImage(named:"gears")!
        settingsButton.setBackgroundImage(gears, forState: .Normal)
        settingsButton.setTitle("", forState: .Normal)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Month.count    //return # of events available to be created
    }
    
    //fill in each collection cell with values
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Replace below with data
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        let month = cell.viewWithTag(1) as! UILabel
        month.text = monthName[Int(Month[indexPath.row])!-1]
        month.layer.zPosition = 1
        
        let date = cell.viewWithTag(2) as! UILabel
        date.text = self.Date[indexPath.row]
        date.layer.zPosition = 1

        let name = cell.viewWithTag(3) as! UILabel
        name.text = Name[indexPath.row]

        let time = cell.viewWithTag(4) as! UILabel
        time.text = Time[indexPath.row]
        
        let endTime = cell.viewWithTag(5) as! UILabel
        if (EndTime[indexPath.row] == ""){
            endTime.text = "TBA"
        }else{
            endTime.text = EndTime[indexPath.row]
        }
        
        switch Type[indexPath.row]{
        case 1:
            cell.backgroundColor = UIColor(netHex: serviceColor)
        case 0:
            cell.backgroundColor = UIColor(netHex: leadershipColor)
        case -1:
            cell.backgroundColor = UIColor(netHex: fellowshipColor)
        default:
            print("Type error")
        }
        let likeButton = cell.viewWithTag(6) as! UIButton
        let empty_heart : UIImage = UIImage(named:"empty_heart")!
        likeButton.setBackgroundImage(empty_heart, forState: .Normal)
        likeButton.setTitle("", forState: .Normal)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "event"){
            let indexPaths : NSArray = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath : NSIndexPath = indexPaths[0] as! NSIndexPath
            let Event:EventHandler = segue.destinationViewController as! EventHandler
            Event.passedEventMonth = Month[indexPath.row]
            Event.passedEventYear = Year[indexPath.row]
            Event.passedEventDate = Date[indexPath.row]
            Event.passedEventName = Name[indexPath.row]
            Event.passedEventTime = Time[indexPath.row]
            Event.passedEventEndTime = EndTime[indexPath.row]
            Event.passedEventDescription = Description[indexPath.row]
            Event.passedEventParticipants = Participants[indexPath.row]
            switch Type[indexPath.row]{
            case 1:
                Event.passedEventColor = serviceColor
            case 0:
                Event.passedEventColor = leadershipColor
            case -1:
                Event.passedEventColor = fellowshipColor
            default:
                print("Error with type color")
            }
        }
    }

    @IBAction func likeEvent(sender: UIButton!){
        let heart : UIImage = UIImage(named:"heart")!
        let empty_heart : UIImage = UIImage(named:"empty_heart")!
        if (sender.currentBackgroundImage!.isEqual(UIImage(named:"heart"))){
            sender.setBackgroundImage(empty_heart, forState: .Normal)
        }else{
            sender.setBackgroundImage(heart, forState: .Normal)
        }
    }

}

