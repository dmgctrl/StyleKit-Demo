import UIKit
import Foundation

struct FontStyle {
    let fontName: String
    let size: Int
}

class CommonResources {
    var fontLabels = [String: String]()
    var colors = [String: UIColor]()
    var imageNames = [String: String]()
}


class Style: NSObject {
    
    static let sharedInstance = Style()
    
    var fileName = "Style2.json"
    
    var resources = CommonResources()
    
    var textFieldStyles = StyleMap()
    var segmentedControlStyles = StyleMap()
    var sliderStyles = StyleMap()
    var stepperStyles = StyleMap()
    var progressViewStyles = StyleMap()
    
    typealias StyleMap = [String: AnyObject]
    
    var styleMap = [UIElement:StyleMap]()
    
    private override init() {
        super.init()
        serialize(fileName)
    }
    
    private func configurationStyleURL(styleFile:String) -> NSURL? {
        let documentsDirPath = urlForFileInDocumentsDirectory(styleFile)
        if NSFileManager.defaultManager().fileExistsAtPath(documentsDirPath.path!)   {
            return documentsDirPath
        }
        let bundlePath = NSBundle.mainBundle().pathForResource(styleFile, ofType: nil)
        return NSURL(fileURLWithPath: bundlePath!)
    }
    
    private func urlForFileInDocumentsDirectory(fileName: String) -> NSURL {
        let docsDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return docsDir.URLByAppendingPathComponent(fileName)!
    }
    
    private func serialize(styleFile:String) {
        
        let stylePath = configurationStyleURL(styleFile)!
        
        do {
            
            let data = try NSData(contentsOfURL: stylePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let items = json[CommonObjects.Fonts.rawValue] as? [String: String] {
                resources.fontLabels = items
            }
            
            if let colorDict = json[CommonObjects.Colors.rawValue] as? [String: [String: AnyObject]] {
                for (colorKey, components) in colorDict {
                    if let red = components[ColorProperties.Red.rawValue] as? Int,
                        let green = components[ColorProperties.Green.rawValue] as? Int,
                        let blue = components[ColorProperties.Blue.rawValue] as? Int,
                        let alpha = components[ColorProperties.Alpha.rawValue] as? Int {
                        resources.colors[colorKey] = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
                    } else if let hex = components[ColorProperties.Hex.rawValue] as? String,
                        let alpha = components[ColorProperties.Alpha.rawValue] as? Float {
                        if let hexInt = hex.hexColorToInt() {
                            resources.colors[colorKey] = UIColor(withHex: hexInt, alpha: alpha)
                        }
                    }
                }
            }
            
            if let items = json[CommonObjects.Images.rawValue] as? [String: String] {
                resources.imageNames = items
            }
            
            for element in UIElement.allValues {
                // Look for instances of supported UIElement types in json spec
                guard let elementDict = json[element.rawValue] as? [String: [String:AnyObject]] else { continue }
                
                var styles = StyleMap()
                for (labelKey, specification) in elementDict {
                    switch element {
                    case .button:
                        styles[labelKey] = try serializeButtonSpec(specification) as AnyObject
                    case .label:
                        styles[labelKey] = try serializeLabelSpec(specification) as AnyObject
                    case .progressView:
                        styles[labelKey] = try serializeProgressSpec(specification) as AnyObject
                    case .segmentedControl:
                        styles[labelKey] = try serializeSegmentControlSpec(specification) as AnyObject
                    case .slider:
                        styles[labelKey] = try serializeSliderSpec(specification) as AnyObject
                    case .stepper:
                        styles[labelKey] = try serializeStepperSpec(specification) as AnyObject
                    case .view:
                        styles[labelKey] = try serializeViewSpec(specification) as AnyObject
                    case .textField:
                        styles[labelKey] = try serializeTextFieldSpec(specification) as AnyObject
                    }
                }
                styleMap[element] = styles
            }
        } catch {
            assert(false,"error serializing JSON: \(error)")
        }
    }
    
    
    enum ParseError: ErrorType {
        case invalidFontStyle
        case invalidTextFieldProperty
        case invalidLabelStyle
    }
    
    private func mapTextAlignmentType(styleStr:String) -> NSTextAlignment?  {
        let allowedValues = ["Left","Center","Right","Justified","Natural"]
        if let index = allowedValues.indexOf(styleStr) {
            return NSTextAlignment(rawValue: index)
        }
        return nil
    }
    
    private func mapBorderStyle(styleStr:String) -> UITextBorderStyle?  {
        let allowedValues = ["None","Line","Bezel","RoundedRect"]
        if let index = allowedValues.indexOf(styleStr) {
            return UITextBorderStyle(rawValue: index)
        }
        return nil
    }
    
    
    //--------------------------------------
    // MARK: - Serialize JSON into Objects
    //--------------------------------------
    
    
    private func serializeTextFieldSpec(spec: [String:AnyObject]) throws -> TextFieldStyle {
        let result = TextFieldStyle()
        for (key,value) in spec {
            guard let property = TextFieldStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring.")
                continue
            }
            
            switch property {
            case TextFieldStyle.Properties.FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    result.fontStyle = try serializeFontSpec(fontSpec)
                }
            case TextFieldStyle.Properties.BorderWidth:
                if let borderWidth = spec[key] as? Int {
                    result.borderWidth = borderWidth
                }
            case TextFieldStyle.Properties.TextColor:
                if let colorKey = value as? String, color = resources.colors[colorKey]  {
                    result.textColor = color
                }
            case TextFieldStyle.Properties.BorderColor:
                if let colorKey = value as? String, color = resources.colors[colorKey]  {
                    result.borderColor = color
                }
            case TextFieldStyle.Properties.TextAlignment:
                if let styleStr = value as? String, let alignment = mapTextAlignmentType(styleStr) {
                    result.textAlignment = alignment
                }
            case TextFieldStyle.Properties.BorderStyle:
                if let styleStr = value as? String, let border = mapBorderStyle(styleStr) {
                    result.borderStyle = border
                }
            case TextFieldStyle.Properties.CornerRadius:
                if let cornerRadius = spec[key] as? Int {
                    result.cornerRadius = cornerRadius
                }
                
            }
        }
        
        return result
    }
    
    private func serializeLabelSpec(spec: [String:AnyObject]) throws -> LabelStyle {
        let labelStyle = LabelStyle()
        for (key,value) in spec {
            guard let property = LabelStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case LabelStyle.Properties.FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    let font = try serializeFontSpec(fontSpec)
                    labelStyle.fontStyle = font
                    return labelStyle
                }
            }
        }
        return labelStyle
    }
    
    private func serializeButtonSpec(spec: [String:AnyObject]) throws -> ButtonStyle {
        let style = ButtonStyle()
        for (key,value) in spec {
            guard let property = ButtonStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    let font = try serializeFontSpec(fontSpec)
                    style.fontStyle = font
                }
            case .BorderColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.borderColor = color
                }
            case .BorderWidth:
                if let width = value as? Int {
                    style.borderWidth = width
                }
            case .CornerRadius:
                if let radius = value as? Int {
                    style.cornerRadius = radius
                }
            case .Normal:
                guard let normalColorEntries = value as? [String: String] else {
                    break
                }
                for entry in normalColorEntries {
                    if let color = resources.colors[entry.1], colorType = ButtonStyle.ColorType(rawValue: entry.0) {
                        style.normalColors[colorType] = color
                    }
                }
            case .Selected:
                guard let selectedColorEntries = value as? [String: String] else {
                    break
                }
                for entry in selectedColorEntries {
                    if let color = resources.colors[entry.1], colorType = ButtonStyle.ColorType(rawValue: entry.0) {
                        style.selectedColors[colorType] = color
                    }
                }
            case .Highlighted:
                guard let highlightedColorEntries = value as? [String: String] else {
                    break
                }
                for entry in highlightedColorEntries {
                    if let color = resources.colors[entry.1], colorType = ButtonStyle.ColorType(rawValue: entry.0) {
                        style.highlightedColors[colorType] = color
                    }
                }
            case .Disabled:
                guard let disabledColorEntries = value as? [String: String] else {
                    break
                }
                for entry in disabledColorEntries {
                    if let color = resources.colors[entry.1], colorType = ButtonStyle.ColorType(rawValue: entry.0) {
                        style.disabledColors[colorType] = color
                    }
                }
            }
        }
        return style
    }
    
    private func serializeViewSpec(spec: [String:AnyObject]) throws -> ViewStyle {
        let style = ViewStyle()
        for (key,value) in spec {
            guard let property = ViewStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case .BorderColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.borderColor = color
                }
            case .BorderWidth:
                if let width = value as? Int {
                    style.borderWidth = width
                }
            case .CornerRadius:
                if let radius = value as? Int {
                    style.cornerRadius = radius
                }
            case .BackgroundColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.backgroundColor = color
                }
            }
        }
        return style
    }
    
    private func serializeSegmentControlSpec(spec: [String:AnyObject]) throws -> SegmentedControlStyle {
        let style = SegmentedControlStyle()
        for (key,value) in spec {
            guard let property = SegmentedControlStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    let font = try serializeFontSpec(fontSpec)
                    style.fontStyle = font
                }
            case .TextColor:
                if let colorStates = value as? [String:String] {
                    var states:[SegmentedControlStyle.AllowedStates:UIColor] = [:]
                    for state in colorStates {
                        if let allowedState = SegmentedControlStyle.AllowedStates(rawValue: state.0),
                            let color = resources.colors[state.1] {
                            states[allowedState] = color
                        }
                    }
                    if states.keys.count > 0 {
                        style.textColor = states
                    }
                }
            case .TintColor:
                if let colorKey = value as? String,
                    let color = resources.colors[colorKey] {
                    style.tintColor = color
                }
            }
        }
        return style
    }
    
    func serializeSliderSpec(spec: [String:AnyObject]) throws -> SliderStyle {
        let style = SliderStyle()
        for (key,value) in spec {
            guard let property = SliderStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
                
            case .MaximumTrackTintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    style.maximumTrackTintColor = color
                }
            case .MinimumTrackTintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    style.minimumTrackTintColor = color
                }
            case .ThumbImage:
                if let imageKey = value as? String, imageName = resources.imageNames[imageKey],
                    image = UIImage(named:imageName){
                    style.thumbImage = image
                }
            case .MinimumTrackImage:
                if let imageKey = value as? String, imageName = resources.imageNames[imageKey],
                    image = UIImage(named:imageName){
                    style.minimumTrackImage = image
                }
            case .MaximumTrackImage:
                if let imageKey = value as? String, imageName = resources.imageNames[imageKey],
                    image = UIImage(named:imageName){
                    style.maximumTrackImage = image
                }
            }
            
        }
        return style
    }
    
    func serializeStepperSpec(spec: [String:AnyObject]) throws -> StepperStyle {
        let style = StepperStyle()
        for (key,value) in spec {
            guard let property = StepperStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case .TintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    style.tintColor = color
                }
            case .IncrementImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.incrementImage = values
                }
            case .DecrementImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.decrementImage = values
                }
            case .BackgroundImage:
                if let states = value as? [String: String] {
                    var values:[StepperStyle.AllowedStates:UIImage] = [:]
                    for (key, value) in states {
                        if let state = StepperStyle.AllowedStates(rawValue: key),
                            let imageKey = resources.imageNames[value],
                            let image = UIImage(named: imageKey) {
                            values[state] = image
                        }
                    }
                    style.backgroundImage = values
                }
            }
        }
        return style
    }
    
    func serializeProgressSpec(spec: [String:AnyObject]) throws -> ProgressViewStyle {
        let style = ProgressViewStyle()
        for (key,value) in spec {
            guard let property = ProgressViewStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignoring")
                continue
            }
            switch property {
            case .Style:
                if let theValue = value as? Int, let viewStyle = UIProgressViewStyle(rawValue: theValue) {
                    style.style = viewStyle
                }
            case .ProgressTintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    style.progressTintColor = color
                }
            case .TrackTintColor:
                if let colorKey = value as? String, color = resources.colors[colorKey] {
                    style.trackTintColor = color
                }
            case .ProgressImage:
                if let imageKey = value as? String, imageName = resources.imageNames[imageKey] {
                    style.progressImage = UIImage(named: imageName)
                }
            case .TrackImage:
                if let imageKey = value as? String, imageName = resources.imageNames[imageKey] {
                    style.trackImage = UIImage(named: imageName)
                }
            }
        }
        return style
    }
    
    func serializeFontSpec(spec: [String:AnyObject]) throws -> FontStyle {
        if let nameKey = spec[FontProperty.name.rawValue] as? String,
            let fontName = resources.fontLabels[nameKey],
            let size = spec[FontProperty.size.rawValue] as? Int {
            return FontStyle(fontName: fontName, size: size)
        } else {
            throw ParseError.invalidFontStyle
        }
    }
    
}

protocol CanBeStyled {
    
    associatedtype ViewType
    
    func style(viewType:ViewType)
    
}


//--------------------------------------
// MARK: - Extensions
//--------------------------------------

extension UIView {
    
    func applyStyle(style:ViewStyle, resources:CommonResources) {
        for property in ViewStyle.allValues {
            switch property {
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                }
            case .BackgroundColor:
                if let color = style.backgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    func style() {
        guard let styleTag = self.styleTag else { return }
        switch self {
        case is UISegmentedControl:
            if let elementStyles = Style.sharedInstance.styleMap[.segmentedControl],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? SegmentedControlStyle {
                (self as! UISegmentedControl).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UITextField:
            if let elementStyles = Style.sharedInstance.styleMap[.textField],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? TextFieldStyle {
                (self as! UITextField).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UIButton:
            if let elementStyles = Style.sharedInstance.styleMap[.button],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ButtonStyle {
                (self as! UIButton).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UILabel:
            if let elementStyles = Style.sharedInstance.styleMap[.label],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? LabelStyle {
                (self as! UILabel).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UISlider:
            if let elementStyles = Style.sharedInstance.styleMap[.slider],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? SliderStyle {
                (self as! UISlider).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UIStepper:
            if let elementStyles = Style.sharedInstance.styleMap[.stepper],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? StepperStyle {
                (self as! UIStepper).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        case is UIProgressView:
            if let elementStyles = Style.sharedInstance.styleMap[.progressView],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ProgressViewStyle {
                (self as! UIProgressView).applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        default:
            if let elementStyles = Style.sharedInstance.styleMap[.view],
                let styles = elementStyles[styleTag],
                let styleObject = styles as? ViewStyle {
                self.applyStyle(styleObject, resources: Style.sharedInstance.resources)
            }
        }
    }
}

extension UITextField {
    
    func applyStyle(style:TextFieldStyle, resources:CommonResources) {
        for property in TextFieldStyle.allValues {
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    self.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                }
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .TextAlignment:
                if let aValue = style.textAlignment {
                    self.textAlignment = aValue
                }
            case .BorderStyle:
                if let aValue = style.borderStyle {
                    self.borderStyle = aValue
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                }
            case .TextColor:
                if let color = style.textColor {
                    self.textColor = color
                }
            }
        }
    }
    
}

extension UISegmentedControl {
    
    func applyStyle(style:SegmentedControlStyle, resources:CommonResources) {
        for property in SegmentedControlStyle.allValues {
            
            var normalAttributes: [NSObject: AnyObject] = [:]
            var selectedAttributes: [NSObject: AnyObject] = [:]
            
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    let font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                    normalAttributes[NSFontAttributeName] = font
                    selectedAttributes[NSFontAttributeName] = font
                }
            case .TextColor:
                if let colorInfo = style.textColor {
                    for (stateKey, color) in colorInfo {
                        switch stateKey {
                        case .Normal:
                            normalAttributes[NSForegroundColorAttributeName] = color
                        case .Selected:
                            selectedAttributes[NSForegroundColorAttributeName] = color
                        }
                    }
                }
            case .TintColor:
                if let tintColor = style.tintColor {
                    self.tintColor = tintColor
                }
            }
            
            self.setTitleTextAttributes(normalAttributes, forState: .Normal)
            self.setTitleTextAttributes(selectedAttributes, forState: .Selected)
        }
    }
    
}


extension UISlider {
    
    func applyStyle(style:SliderStyle, resources:CommonResources) {
        for property in SliderStyle.allValues {
            switch property {
            case .MaximumTrackTintColor:
                if let color = style.tintColor {
                    self.maximumTrackTintColor = color
                }
            case .MinimumTrackTintColor:
                if let color = style.minimumTrackTintColor {
                    self.minimumTrackTintColor = color
                }
            case .ThumbImage:
                if let image = style.thumbImage {
                    self.setThumbImage(image, forState: .Normal)
                }
            case .MinimumTrackImage:
                if let image = style.minimumTrackImage {
                    self.setMinimumTrackImage(image, forState: .Normal)
                }
            case .MaximumTrackImage:
                if let image = style.maximumTrackImage {
                    self.setMaximumTrackImage(image, forState: .Normal)
                }
            }
        }
    }
    
}

extension UIStepper {
    
    func applyStyle(style:StepperStyle, resources:CommonResources) {
        for property in StepperStyle.allValues {
            switch property {
            case .TintColor:
                if let color = style.tintColor {
                    self.tintColor = color
                }
            case .IncrementImage:
                if let states = style.incrementImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setIncrementImage(value, forState: controlState)
                    }
                }
            case .DecrementImage:
                if let states = style.decrementImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setDecrementImage(value, forState: controlState)
                    }
                }
            case .BackgroundImage:
                if let states = style.backgroundImage {
                    for (key, value) in states {
                        let controlState = StepperStyle.controlStateForAllowedState(key)
                        self.setBackgroundImage(value, forState: controlState)
                    }
                }
            }
        }
    }
    
}

extension UIProgressView {
    
    func applyStyle(style:ProgressViewStyle, resources:CommonResources) {
        for property in ProgressViewStyle.allValues {
            switch property {
            case .Style:
                if let theValue = style.style {
                    self.progressViewStyle = theValue
                }
            case .ProgressTintColor:
                if let color = style.progressTintColor {
                    self.progressTintColor = color
                }
            case .TrackTintColor:
                if let color = style.trackTintColor {
                    self.trackTintColor = color
                }
            case .ProgressImage:
                if let image = style.progressImage {
                    self.progressImage = image
                }
            case .TrackImage:
                if let trackImage = style.trackImage {
                    self.trackImage = trackImage
                }
            }
        }
    }
    
}

extension UILabel {
    
    func applyStyle(style:LabelStyle, resources:CommonResources) {
        for property in LabelStyle.allValues {
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    self.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                }
            }
        }
    }
    
    
}

extension UIButton {
    
    func applyStyle(style:ButtonStyle, resources:CommonResources) {
        for property in ButtonStyle.allValues {
            switch property {
            case .FontStyle:
                if let fontStyle = style.fontStyle {
                    self.titleLabel?.font = UIFont(name: fontStyle.fontName, size: CGFloat(fontStyle.size))
                }
            case .BorderWidth:
                if let borderWidth = style.borderWidth {
                    self.layer.borderWidth = CGFloat(borderWidth)
                }
            case .BorderColor:
                if let borderColor = style.borderColor {
                    self.layer.borderColor = borderColor.CGColor
                }
            case .CornerRadius:
                if let cornerRadius = style.cornerRadius {
                    self.layer.cornerRadius = CGFloat(cornerRadius)
                    self.layer.masksToBounds = true
                }
            case .Normal:
                self.assignColors(style.normalColors, forState: .Normal)
            case .Selected:
                self.assignColors(style.selectedColors, forState: .Selected)
            case .Highlighted:
                self.assignColors(style.highlightedColors, forState: .Highlighted)
            case .Disabled:
                self.assignColors(style.disabledColors, forState: .Disabled)
            }
        }
    }
    
    func assignColors(colors: [ButtonStyle.ColorType: UIColor], forState state: UIControlState) {
        for (type, color) in colors {
            switch type {
            case .Background:
                self.setBackgroundImage(UIImage.imageWithColor(color), forState: state)
            case .Text:
                self.setTitleColor(color, forState: state)
            }
        }
    }
    
}


//    func applyStyle(style:ViewStyle, resources:CommonResources) {
//        for property in ViewStyle.allValues {
//            switch property {
//            case .BorderWidth:
//                if let borderWidth = style.borderWidth {
//                    self.layer.borderWidth = CGFloat(borderWidth)
//                }
//            case .BorderColor:
//                if let borderColor = style.borderColor {
//                    self.layer.borderColor = borderColor.CGColor
//                }
//            case .CornerRadius:
//                if let cornerRadius = style.cornerRadius {
//                    self.layer.cornerRadius = CGFloat(cornerRadius)
//                }
//            case .BackgroundColor:
//                if let color = style.backgroundColor {
//                    self.backgroundColor = color
//                }
//            }
//        }
//    }
//
//    // Conform to Stylizer
//
//    func style() {
//        if let styleTag = self.styleTag,
//            let elementStyles = Style.sharedInstance.styleMap[.view],
//            let styles = elementStyles[styleTag],
//            let styleObject = styles as? ViewStyle {
//            self.applyStyle(styleObject, resources: Style.sharedInstance.resources)
//        }
//    }





