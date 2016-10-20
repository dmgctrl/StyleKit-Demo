import Foundation
import UIKit

enum FontProperty: String {
    case name = "font"
    case size = "size"
}

enum UIElement: String {
    case segmentedControl = "SegmentedControls"
    case textField = "TextFields"
    case button = "Buttons"
    case label = "Labels"
    case slider = "Sliders"
    case stepper = "Steppers"
    case progressView = "ProgressViews"
    case view = "Views"
    
    static let allValues:[UIElement] = [.view, .segmentedControl, .textField, .button, .label, .slider, .stepper, .progressView]
}

enum CommonObjects: String {
    case Fonts = "Fonts"
    case Colors = "Colors"
    case Images = "Images"
}

enum ColorProperties: String {
    case Red = "red"
    case Green = "green"
    case Blue = "blue"
    case Alpha = "alpha"
    case Hex = "hex"
}

//--------------------------------------
// MARK: - Labels
//--------------------------------------

class LabelStyle {
    
    var textColor: UIColor?
    var textAlignment: NSTextAlignment?
    var attributes: AttributedTextStyle?
    
    enum Properties: String {
        case TextColor = "textColor"
        case TextAlignment = "textAlignment"
        case Attributes = "attributes"
        static let allValues:[Properties] = [.TextColor, .TextAlignment, .Attributes]
    }

    static var textAlignmentKeyMap:[String:NSTextAlignment] = ["Left":.Left,
                                                        "Center":.Center,
                                                        "Right":.Right,
                                                        "Justified":.Justified,
                                                        "Natural":.Natural]
    
    static func attributesForLabel(styles:AttributedTextStyle) ->  Dictionary<String, AnyObject> {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        if let lineSpace = styles.lineSpacing {
            style.lineSpacing = lineSpace
        }
        
        var attributes:[String: AnyObject] = [:]

        if let fontName = styles.fontStyle?.fontName, let fontSize = styles.fontStyle?.size  {
            attributes[NSFontAttributeName] = UIFont(name: fontName, size: CGFloat(fontSize))
        }

        if let tracking = styles.tracking, let fontSize = styles.fontStyle?.size {
            let characterSpacing = fontSize * tracking / 1000
            attributes[NSKernAttributeName] = characterSpacing
        }

        attributes[NSParagraphStyleAttributeName] = style
        
        return attributes
    }

}

class AttributedTextStyle {
    
    var fontStyle: FontStyle?
    var tracking: Int?
    var lineSpacing: CGFloat?
    var ligature: Int?

    enum Properties: String {
        case FontStyle = "fontStyle"
        case Tracking = "tracking"
        case LineSpacing = "lineSpacing"
        case Ligature = "ligature"
        static let allValues:[Properties] = [.FontStyle, .Tracking, .LineSpacing, .Ligature]
    }
}

//--------------------------------------
// MARK: - Buttons
//--------------------------------------

class ButtonStyle {
    
    var fontStyle: FontStyle?
    var borderWidth: Int?
    var borderColor: UIColor?
    var cornerRadius: Int?
    var normalColors: [ColorType: UIColor]
    var highlightedColors: [ColorType: UIColor]
    var selectedColors: [ColorType: UIColor]
    var disabledColors: [ColorType: UIColor]
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Selected = "selectedState"
        case Disabled = "disabledState"
    }
    
    enum ColorType: String {
        case Background = "backgroundColor"
        case Text = "textColor"
    }
    
    static let allValues:[Properties] = [.FontStyle, .BorderWidth, .BorderColor, .CornerRadius, .Normal, .Highlighted, .Selected, .Disabled]
    
    init() {
        self.normalColors = [ColorType: UIColor]()
        self.highlightedColors = [ColorType: UIColor]()
        self.selectedColors = [ColorType: UIColor]()
        self.disabledColors = [ColorType: UIColor]()
    }
}

//--------------------------------------
// MARK: - Views
//--------------------------------------

class ViewStyle {
    
    var borderWidth: Int?
    var borderColor: UIColor?
    var cornerRadius: Int?
    var backgroundColor: UIColor?
    
    enum Properties: String {
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case BackgroundColor = "backgroundColor"
    }
    
    static let allValues:[Properties] = [.BorderWidth, .BorderColor, .CornerRadius, .BackgroundColor]
}

//--------------------------------------
// MARK: - Text Fields
//--------------------------------------

class TextFieldStyle {
    var fontStyle: FontStyle?
    var textColor: UIColor?
    var borderColor: UIColor?
    var borderWidth: Int?
    var cornerRadius: Int?
    var textAlignment: NSTextAlignment?
    var borderStyle: UITextBorderStyle?
    var backgroundColor: UIColor?

    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case TextAlignment = "textAlignment"
        case BorderStyle = "borderStyle"
        case TextColor = "textColor"
        case BackgroundColor = "backgroundColor"
    }
 
    static let allValues:[Properties] = [.BackgroundColor, .FontStyle, .BorderWidth, .BorderColor, .CornerRadius, .TextAlignment, .BorderStyle, .TextColor]
}


//--------------------------------------
// MARK: - Segmented Controls
//--------------------------------------

class SegmentedControlStyle {
    var fontStyle: FontStyle?
    var tintColor:UIColor?
    var textColor: [AllowedStates:UIColor]?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        case TintColor = "tintColor"
        case TextColor = "textColor"
    }
    
    enum AllowedStates: String {
        case Normal = "normalState"
        case Selected = "selectedState"
    }
    
    static let allValues:[Properties] = [.FontStyle, .TintColor, .TextColor]
}


//--------------------------------------
// MARK: - Sliders
//--------------------------------------

class SliderStyle {
    var tintColor: UIColor?
    var minimumTrackTintColor: UIColor?
    var maximumTrackTintColor: UIColor?
    var thumbImage: UIImage?
    var minimumTrackImage: UIImage?
    var maximumTrackImage: UIImage?
    
    enum Properties: String {
        case MinimumTrackTintColor = "minimumTrackTintColor"
        case MaximumTrackTintColor = "maximumTrackTintColor"
        case ThumbImage = "thumbImage"
        case MinimumTrackImage = "minimumTrackImage"
        case MaximumTrackImage = "maximumTrackImage"
    }
    
    static let allValues:[Properties] = [.MinimumTrackTintColor, .MaximumTrackTintColor, .ThumbImage, .MinimumTrackImage, .MaximumTrackImage]
}


//--------------------------------------
// MARK: - Steppers
//--------------------------------------

class StepperStyle {
    var tintColor: UIColor?
    var backgroundImage: [AllowedStates:UIImage]?
    var incrementImage: [AllowedStates:UIImage]?
    var decrementImage: [AllowedStates:UIImage]?
    
    enum Properties: String {
        case TintColor = "tintColor"
        case IncrementImage = "incrementImage"
        case DecrementImage = "decrementImage"
        case BackgroundImage = "backgroundImage"
    }
    
    enum AllowedStates: String {
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Disabled = "disabledState"
    }
    
    static func controlStateForAllowedState(state:AllowedStates) -> UIControlState {
        switch state {
        case .Disabled:
            return UIControlState.Disabled
        case .Highlighted:
            return UIControlState.Highlighted
        case .Normal:
            return UIControlState.Normal
        }
    }
    
    static let allValues:[Properties] = [.TintColor, .IncrementImage, .DecrementImage, .BackgroundImage]
}

//--------------------------------------
// MARK: - Progress Views
//--------------------------------------

class ProgressViewStyle {
    var style: UIProgressViewStyle?
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    var progressImage: UIImage?
    var trackImage: UIImage?
    
    enum Properties: String {
        case Style = "style"
        case ProgressTintColor = "progressTintColor"
        case TrackTintColor = "trackTintColor"
        case ProgressImage = "progressImage"
        case TrackImage = "trackImage"
    }
    
    static let allValues:[Properties] = [.Style, .ProgressTintColor, .TrackTintColor, .ProgressImage, .TrackImage]
}

