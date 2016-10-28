//
//  AppDelegate.swift
//  StyleKitSample
//
//  Created by Eric Kille on 3/10/16.
//  Copyright © 2016 Tonic Design. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {        
        
        Utils.copyStyleFileFromBundle()
        return true
    }

}
