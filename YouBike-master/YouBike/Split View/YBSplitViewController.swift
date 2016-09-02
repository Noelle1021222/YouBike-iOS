//
//  YBSplitViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/18.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBSplitViewController: BaseSplitViewController {

    struct Static {
        static let Identifier = "YBSplitViewController"
    }
    
    private var stationListViewController: YBStationListViewController? {
        
        for viewController in viewControllers {
            
            if let navigationController = viewController as? UINavigationController {
            
                if let stationListViewController = navigationController.viewControllers.first as? YBStationListViewController {
                    
                    return stationListViewController
                    
                }
                
            }
            
        }
        
        return nil
        
    }

    private var stationMapViewController: YBStationMapViewController? {
        
        for viewController in viewControllers {
            
            if let navigationController = viewController as? UINavigationController {
                
                if let stationMapViewController = navigationController.viewControllers.first as? YBStationMapViewController {
                    
                    return stationMapViewController
                    
                }
                
            }
            
        }
        
        return nil
        
    }
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }
    
}


// MARK: - View Life Cycle

extension YBSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRotatable = true
        
        stationListViewController?.delegate = self
        
    }
    
}


// MARK: - Setup

extension YBSplitViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle { return .LightContent }
    
}


// MARK: - Initializer

extension YBSplitViewController {
    
    class func controller() -> YBSplitViewController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBSplitViewController }
    
}


// MARK: - YBStationListViewControllerDelegate

extension YBSplitViewController: YBStationListViewControllerDelegate {
    
    func stationListViewController(controller: YBStationListViewController, stationDidSelect selectedStation: YBStationModel) {
        
        stationMapViewController?.stationAnnotation = YBStationAnnotation(station: selectedStation)
        
    }
    
}
