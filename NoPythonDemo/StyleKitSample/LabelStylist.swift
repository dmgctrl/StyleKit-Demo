
import Foundation
import UIKit

class LabelStyle: Stylist {
    
    typealias Element = UILabel
    
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
    
    static func serialize(spec: [String:AnyObject], resources:CommonResources) throws -> LabelStyle {
        let labelStyle = LabelStyle()
        for (key,value) in spec {
            guard let property = LabelStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignored.")
                continue
            }
            switch property {
                
            case LabelStyle.Properties.TextAlignment:
                if let textAlignmentKey = value as? String, let alignment = LabelStyle.textAlignmentKeyMap[textAlignmentKey] {
                    labelStyle.textAlignment = alignment
                }
            case LabelStyle.Properties.TextColor:
                if let colorKey = value as? String, let color = resources.colors[colorKey] {
                    labelStyle.textColor = color
                }
            case LabelStyle.Properties.Attributes:
                if let attributes = value as? [String:AnyObject]
                {
                    let attr = try LabelStyle.serializeFormatAttributesSpec(attributes, resources:resources)
                    labelStyle.attributes = attr
                }
            }
        }
        return labelStyle
    }
    
    static func serializeFormatAttributesSpec(spec: [String:AnyObject], resources:CommonResources) throws -> AttributedTextStyle {
        
        let style = AttributedTextStyle()
        for (key,value) in spec {
            guard let property = AttributedTextStyle.Properties(rawValue: key) else {
                print("StyleKit: Warning: \(key) is not a recognized property. Ignored.")
                continue
            }
            switch property {
            case .FontStyle:
                if let fontSpec = value as? [String:AnyObject] {
                    let font = try Style.serializeFontSpec(fontSpec, resources: resources)
                    style.fontStyle = font
                }
            case .Tracking:
                if let tracking = value as? Int {
                    style.tracking = tracking
                }
            case .LineSpacing:
                if let lineSpacing = value as? CGFloat {
                    style.lineSpacing = lineSpacing
                }
            case .Ligature:
                if let ligature = value as? Int {
                    style.ligature = ligature
                }
            }
        }
        return style
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

extension UILabel {
    func applyStyle(style:LabelStyle, resources:CommonResources) {
        for property in LabelStyle.Properties.allValues {
            switch property {
            case .TextColor:
                self.textColor = style.textColor
            case .TextAlignment:
                self.textAlignment = style.textAlignment ?? self.textAlignment
            case .Attributes:
                if let attributes = style.attributes, text = self.text {
                    let asdf = LabelStyle.attributesForLabel(attributes)
                    self.attributedText = NSAttributedString(string: text, attributes:asdf)
                }
            }
        }
    }
}


