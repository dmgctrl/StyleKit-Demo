import UIKit

class SteppersViewController: UIViewController {
    

    
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.label1.text = "\(stepper1.value)"
        self.label2.text = "\(stepper2.value)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepperOneValueChanged(sender: UIStepper) {
        self.label1.text = "\(stepper1.value)"
    }
    
    @IBAction func stepperTwoValueChanged(sender: UIStepper) {
        self.label2.text = "\(stepper2.value)"
    }
    
}
