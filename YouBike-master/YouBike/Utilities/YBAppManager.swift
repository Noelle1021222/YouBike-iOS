//
//  YBAppManager.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBAppManager: BaseManager {

    struct Static {
        static let Identifier = "YBAppManager"
    }
    
    static let sharedManager = YBAppManager()
    
    
    // MARK: - Init
    
    private override init() {
        super.init()
        setup()
    }
    
}


// MARK: - Setup

extension YBAppManager {
    
    private func setup() { }

}


// MARK: - Root View Controller

extension YBAppManager {
    
    var rootViewController: UIViewController {
        
        if !YBUserManager.sharedManager.isLoggedIn { return YBLogInViewController.controller() }
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone: return YBTabBarController.controller()
        default: return YBSplitViewController.controller()
        }
        
    }
    
}
