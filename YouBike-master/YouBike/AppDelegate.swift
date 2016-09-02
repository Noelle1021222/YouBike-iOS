//
//  AppDelegate.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/26.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import FBSDKCoreKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.rootViewController = YBAppManager.sharedManager.rootViewController
        
        return true
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) { FBSDKAppEvents.activateApp() }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool { return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) }

}

