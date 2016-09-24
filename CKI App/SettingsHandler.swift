import Foundation
import UIKit

class SettingsHandler: UITableViewController{    //when it doesn't conform to protocol it is because some
    var Settings: [String] = ["About", "Notification Configuration", "Feedback"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingsCell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("settingsCell")! as UITableViewCell
        
        settingsCell.textLabel?.text = self.Settings[indexPath.row]
        
        return settingsCell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0){
            performSegueWithIdentifier("about", sender: self)
        }else if (indexPath.row == 1){
            performSegueWithIdentifier("notification", sender: self)
        }else if (indexPath.row == 2){
            performSegueWithIdentifier("feedback", sender: self)
        }
    }
}

