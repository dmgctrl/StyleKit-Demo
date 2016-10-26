//
//  ViewController.swift
//  StyleKitSample
//
//  Created by Eric Kille on 3/10/16.
//  Copyright © 2016 Tonic Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StyleKitSubscriber {
    
    @IBOutlet weak var button1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Style.sharedInstance.addSubscriber(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func update() {
        self.button1.style()
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.downloadStyleFile()
    }
}

