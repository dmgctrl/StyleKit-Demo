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
    var fontStyle: FontStyle?
    
    enum Properties: String {
        case FontStyle = "fontStyle"
        static let allValues:[Properties] = [.FontStyle]
    }
    
    static let allValues:[Properties] = [.FontStyle]
}

//--------------------------------------
// MARK: - Buttons
//--------------------------------------

class ButtonStyle {

    var fontStyle: FontStyle?
    var borderWidth: Int?
    var borderColor: UIColor?
    var cornerRadius: Int?
    var titleColorStates: [AllowedStates:UIColor]?

    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case TitleColor = "titleColor"
    }

    enum AllowedStates: String {
        case Normal = "normalState"
        case Highlighted = "highlightedState"
        case Selected = "selectedState"
        case Disabled = "disabledState"
    }

    static let allValues:[Properties] = [.FontStyle, .BorderWidth, .BorderColor, .CornerRadius, .TitleColor]
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

    enum Properties: String {
        case FontStyle = "fontStyle"
        case BorderWidth = "borderWidth"
        case BorderColor = "borderColor"
        case CornerRadius = "cornerRadius"
        case TextAlignment = "textAlignment"
        case BorderStyle = "borderStyle"
        case TextColor = "textColor"
    }
    
    static let allValues:[Properties] = [.FontStyle, .BorderWidth, .BorderColor, .CornerRadius, .TextAlignment, .BorderStyle, .TextColor]

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

