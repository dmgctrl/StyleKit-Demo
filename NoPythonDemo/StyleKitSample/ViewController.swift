//
//  ViewController.swift
//  StyleKitSample
//
//  Created by Eric Kille on 3/10/16.
//  Copyright © 2016 Tonic Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StyleKitSubscriber {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Style.sharedInstance.addSubscriber(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func update() {
        for view in self.view.subviews {
            view.style()
        }
    }
}

