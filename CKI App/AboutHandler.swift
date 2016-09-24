import Foundation
import UIKit

class AboutHandler: UIViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    @IBOutlet weak var aboutCKI: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutCKI.text = "Circle K International is a collegiate community service, leadership development, and friendship organization. Circle K clubs are organized and sponsored by a Kiwanis club on a college or university campus. It is a self-governing organization and elects its own officers, conducts its own meetings, and determines its own service activities."
    }
    
    @IBAction func WebLink(sender: AnyObject) {
        if let url = NSURL(string: "http://daviscki.wix.com/ucdaviscki") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
