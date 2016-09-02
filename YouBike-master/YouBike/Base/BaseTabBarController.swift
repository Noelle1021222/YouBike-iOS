//
//  BaseTabBarController.swift
//  RoyHsu
//
//  Created by 許郁棋 on 2016/5/11.
//  Copyright © 2016年 Roy Hsu. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var isRotatable = false { didSet { supportedInterfaceOrientations() } }

}


// MARK: - Setup

extension BaseTabBarController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad: return isRotatable ? [ .All ] : [ .Portrait ]
        default: return isRotatable ? [ .AllButUpsideDown ] : [ .Portrait ]
        }
        
    }
    
}
