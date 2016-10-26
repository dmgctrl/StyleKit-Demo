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
        Style.sharedInstance.refresh()
        
        return true
    }

    func copyStyleFile(from srcURL: NSURL, to destURL: NSURL) {
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(destURL.path!) {
            do {
                try fileManager.removeItemAtURL(destURL)
            } catch let error {
                print(error)
            }
        }
        
        do {
            try fileManager.createDirectoryAtURL(destURL, withIntermediateDirectories: false, attributes: nil)
            try fileManager.copyItemAtURL(srcURL, toURL: destURL.URLByAppendingPathComponent("Style.json")!)
        } catch let error {
            print(error)
        }
    }
    
    func downloadStyleFile() {
        if let url = NSURL(string:"https://dl.dropboxusercontent.com/u/26582460/Style.json") {
            NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: { tempFileDirectory, response, error in
                if error == nil {
                    if let srcDirectory = tempFileDirectory, destDirectory = Utils.documentDirectory?.URLByAppendingPathComponent("NewFolder/") {
                        self.copyStyleFile(from: srcDirectory, to: destDirectory)
                        dispatch_async(dispatch_get_main_queue(), { 
                            Style.sharedInstance.refresh()
                        })
                    }
                }
            }).resume()
        }
    }
}

