//
//  BaseTableViewController.swift
//  RoyHsu
//
//  Created by 許郁棋 on 2015/12/3.
//  Copyright © 2015年 Roy Hsu. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class BaseTableViewController: UITableViewController {
    
    var isRotatable = false { didSet { supportedInterfaceOrientations() } }
    
}


// MARK: - Setup

extension BaseTableViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad: return isRotatable ? [ .All ] : [ .Portrait ]
        default: return isRotatable ? [ .AllButUpsideDown ] : [ .Portrait ]
        }
        
    }
    
}


// MARK: - Refresh Control

extension BaseTableViewController {
    
    func beginPullToRefresh() {
        
        if let refreshControl = refreshControl {
            
            let offsetY = topLayoutGuide.length + refreshControl.bounds.size.height
            tableView.setContentOffset(CGPointMake(0.0, -offsetY), animated: true)
            refreshControl.beginRefreshing()
            refreshControl.sendActionsForControlEvents(.ValueChanged)
            
        }
        
    }
    
    func endPullToRefresh() { refreshControl?.endRefreshing() }
    
}


// MARK: - Infinity Scroll

extension BaseTableViewController {
    
    func addInfinityScroll(activityIndicatorStyle style: UIActivityIndicatorViewStyle, handler: (() -> Void)) {
        
        removeInfinityScroll()
        
        tableView.infiniteScrollIndicatorStyle = style
        tableView.addInfiniteScrollWithHandler { _ in handler() }
        
    }
    
    func removeInfinityScroll() {
        
        if tableView.infiniteScrollIndicatorView != nil {
            
            endInfinityScroll(completion: nil)
            tableView.removeInfiniteScroll()
            
        }
        
    }
    
    func endInfinityScroll(completion completion: (() -> Void)?) { tableView.finishInfiniteScrollWithCompletion { _ in completion?() } }
    
}
