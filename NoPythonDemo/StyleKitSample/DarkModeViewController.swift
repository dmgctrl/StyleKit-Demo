import UIKit

class DarkModeViewController: UIViewController, StyleKitSubscriber {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Style.sharedInstance.addSubscriber(self)
    }
    
    func update() {
        self.textView.style()
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        guard let theSwitch = sender as? UISwitch else {
            return
        }

        let filename: String
        if theSwitch.on {
            filename = "Dark"
        } else {
            filename = "Light"
        }

        if let string = NSBundle.mainBundle().infoDictionary?[Style.sharedInstance.bundleKeyForLocation] as? String,
            srcURL = NSBundle.mainBundle().URLForResource(filename, withExtension: "json"),
            destURL = Utils.documentDirectory?.URLByAppendingPathComponent(string)
        {
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.copyStyleFile(from: srcURL, to: destURL)
            Style.sharedInstance.refresh()
        }
    }
}
