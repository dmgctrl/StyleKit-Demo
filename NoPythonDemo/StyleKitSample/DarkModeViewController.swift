import UIKit

enum DarkOrLight: String {
    case Dark = "Dark"
    case Light = "Light"
}

class DarkModeViewController: UIViewController, StyleKitSubscriber {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Style.sharedInstance.addSubscriber(self)
        self.loadResource(withType: .Light)
    }
    
    func update() {
        UIView.animateWithDuration(0.25) {
            self.textView.styleTag = "TV1"
            self.view.styleTag = "V1"
        }
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        guard let theSwitch = sender as? UISwitch else {
            return
        }

        if theSwitch.on {
            self.loadResource(withType: .Dark)
        } else {
            self.loadResource(withType: .Light)
        }
    }
    
    private func loadResource(withType type: DarkOrLight) {
        if let string = NSBundle.mainBundle().infoDictionary?[Style.sharedInstance.bundleKeyForLocation] as? String,
            srcURL = NSBundle.mainBundle().URLForResource(type.rawValue, withExtension: "json"),
            destURL = Utils.documentDirectory?.URLByAppendingPathComponent(string)
        {
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.copyStyleFile(from: srcURL, to: destURL)
            Style.sharedInstance.refresh()
        }
    }
}
