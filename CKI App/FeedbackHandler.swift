import Foundation
import UIKit

//Routing function that emails feedback to club executives
class FeedbackHandler: UIViewController{    //when it doesn't conform to protocol it is because some functions need to be implemented
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackLabel.text = "Feedback"
        feedbackTextView.layer.borderWidth = 3
        feedbackTextView.layer.borderColor = UIColor.blackColor().CGColor
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
    }
}
