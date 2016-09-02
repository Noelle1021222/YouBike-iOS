//
//  BaseViewController.swift
//  RoyHsu
//
//  Created by 許郁棋 on 2015/9/30.
//  Copyright © 2015年 Roy Hsu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var isRotatable = false { didSet { supportedInterfaceOrientations() } }
    
}


// MARK: - Setup

extension BaseViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad: return isRotatable ? [ .All ] : [ .Portrait ]
        default: return isRotatable ? [ .AllButUpsideDown ] : [ .Portrait ]
        }
        
    }
    
}
