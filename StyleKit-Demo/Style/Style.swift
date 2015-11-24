import UIKit

class Style: NSObject {

    static let sharedInstance = Style()    
    
    let primaryFontMedium: String = "BrandonGrotesque-Medium"    
    let primaryFontBlack: String = "BrandonGrotesque-Black"    
    let primaryFontLight: String = "BrandonGrotesque-Light"    
    let primaryFontLightItalic: String = "BrandonGrotesque-LightItalic"    
    let primaryFontBold: String = "BrandonGrotesque-Bold"    
    
    let blueColor = UIColor(red: 0.0/255.0, green: 84.0/255.0, blue: 136.0/255.0, alpha: 1.0)    
    let whiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)    
    let blackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)    
    
    let buttonImage1 = UIImage(named: "black_button_image")    
    
    @IBOutlet var H2Label: [UILabel]! {        
        didSet {            
            styleH2Label(H2Label)            
        }        
    }    
    
    @IBOutlet var H3Label: [UILabel]! {        
        didSet {            
            styleH3Label(H3Label)            
        }        
    }    
    
    @IBOutlet var H1Label: [UILabel]! {        
        didSet {            
            styleH1Label(H1Label)            
        }        
    }    
    
    @IBOutlet var specialView: [UIView]! {        
        didSet {            
            stylespecialView(specialView)            
        }        
    }    
    
    @IBOutlet var B4Button: [UIButton]! {        
        didSet {            
            styleB4Button(B4Button)            
        }        
    }    
    
    @IBOutlet var B1Button: [UIButton]! {        
        didSet {            
            styleB1Button(B1Button)            
        }        
    }    
    
    @IBOutlet var B2Button: [UIButton]! {        
        didSet {            
            styleB2Button(B2Button)            
        }        
    }    
    
    @IBOutlet var B3Button: [UIButton]! {        
        didSet {            
            styleB3Button(B3Button)            
        }        
    }    
    
    @IBOutlet var T1TextField: [UITextField]! {        
        didSet {            
            styleT1TextField(T1TextField)            
        }        
    }    
    
    func styleH2Label(objects: [UILabel]) {        
        for object in objects {        
            object.textColor = blackColor            
            object.font = UIFont (name: primaryFontLightItalic, size: 20)            
            }            
        }    
    
    func styleH3Label(objects: [UILabel]) {        
        for object in objects {        
            object.textColor = blueColor            
            object.font = UIFont (name: primaryFontBlack, size: 24)            
            }            
        }    
    
    func styleH1Label(objects: [UILabel]) {        
        for object in objects {        
            object.textColor = whiteColor            
            object.font = UIFont (name: primaryFontLight, size: 34)            
            object.textAlignment = NSTextAlignment.Center            
            }            
        }    
    
    func stylespecialView(objects: [UIView]) {        
        for object in objects {        
            object.backgroundColor = blueColor            
            object.layer.cornerRadius = 5            
            object.layer.borderColor = blackColor.CGColor            
            object.layer.borderWidth = 5            
            }            
        }    
    
    func styleB4Button(objects: [UIButton]) {        
        for object in objects {        
            object.backgroundColor = whiteColor            
            object.layer.borderColor = blackColor.CGColor            
            object.layer.borderWidth = 3            
            object.setTitleColor(blackColor, forState: .Normal)            
            object.titleLabel?.font = UIFont (name: primaryFontBold, size: 17)            
            }            
        }    
    
    func styleB1Button(objects: [UIButton]) {        
        for object in objects {        
            object.backgroundColor = blackColor            
            object.layer.cornerRadius = 10            
            object.layer.borderColor = whiteColor.CGColor            
            object.layer.borderWidth = 3            
            object.setTitleColor(whiteColor, forState: .Normal)            
            object.setTitleColor(blueColor, forState: .Highlighted)            
            object.titleLabel?.font = UIFont (name: primaryFontLight, size: 34)            
            }            
        }    
    
    func styleB2Button(objects: [UIButton]) {        
        for object in objects {        
            object.backgroundColor = whiteColor            
            object.layer.cornerRadius = 3            
            object.layer.borderColor = blueColor.CGColor            
            object.layer.borderWidth = 5            
            object.setTitleColor(blueColor, forState: .Normal)            
            object.titleLabel?.font = UIFont (name: primaryFontLight, size: 28)            
            }            
        }    
    
    func styleB3Button(objects: [UIButton]) {        
        for object in objects {        
            object.backgroundColor = blackColor            
            object.layer.cornerRadius = 15            
            object.layer.borderColor = blueColor.CGColor            
            object.layer.borderWidth = 3            
            object.setTitleColor(blueColor, forState: .Normal)            
            object.titleLabel?.font = UIFont (name: primaryFontMedium, size: 20)            
            }            
        }    
    
    func styleT1TextField(objects: [UITextField]) {        
        for object in objects {        
            object.backgroundColor = blueColor            
            object.layer.cornerRadius = 5            
            object.layer.borderColor = blackColor.CGColor            
            object.layer.borderWidth = 2            
            object.textColor = whiteColor            
            object.font = UIFont (name: primaryFontMedium, size: 15)            
            object.textAlignment = NSTextAlignment.Center            
            object.borderStyle = UITextBorderStyle.RoundedRect            
            }            
        }    
    
}