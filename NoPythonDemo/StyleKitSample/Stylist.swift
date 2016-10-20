//
//  Stylist.swift
//  StyleKitSample
//
//  Created by Eric Kille on 10/19/16.
//  Copyright © 2016 Tonic Design. All rights reserved.
//

import Foundation
import UIKit

class Stylist: NSObject {
    
    @IBOutlet var buttons: [UIButton]! {
        didSet {
            //buttons.forEach { $0.style() }
        }
    }
    
    @IBOutlet var segmentedControls: [UISegmentedControl]! {
        didSet {
            //segmentedControls.forEach { $0.style() }
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            //textFields.forEach { $0.style() }
        }
    }
    
    @IBOutlet var labels: [UILabel]! {
        didSet {
            //labels.forEach { $0.style() }
        }
    }
    
    @IBOutlet var sliders: [UISlider]! {
        didSet {
            //sliders.forEach { $0.style() }
        }
    }
    
    @IBOutlet var steppers: [UIStepper]! {
        didSet {
            //steppers.forEach { $0.style() }
        }
    }
    
    @IBOutlet var progressViews: [UIProgressView]! {
        didSet {
            //progressViews.forEach { $0.style() }
        }
    }
    
    @IBOutlet var views: [UIView]! {
        didSet {
            //views.forEach { $0.style() }
        }
    }
}

