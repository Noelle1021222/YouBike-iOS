//
//  YBNavigationController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBNavigationController: BaseNavigationController {

    struct Static {
        static let Identifier = "YBNavigationController"
    }
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension YBNavigationController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle { return .LightContent }
    
    private func setup() {
        
        navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: YBColor.Color6 ]
        navigationBar.barTintColor = YBColor.Color7
        navigationBar.translucent = false
        navigationBar.tintColor = YBColor.Color6
        
    }
    
}
