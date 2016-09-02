//
//  BaseSplitViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/18.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class BaseSplitViewController: UISplitViewController {

    var isRotatable = false { didSet { supportedInterfaceOrientations() } }

}


// MARK: - View Life Cycle

extension BaseSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension BaseSplitViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad: return isRotatable ? [ .All ] : [ .Portrait ]
        default: return isRotatable ? [ .AllButUpsideDown ] : [ .Portrait ]
        }
        
    }
    
    private func setup() { preferredDisplayMode = .AllVisible }
    
}
