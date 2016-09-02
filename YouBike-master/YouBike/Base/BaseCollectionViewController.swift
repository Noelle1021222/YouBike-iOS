//
//  BaseCollectionViewController.swift
//  RoyHsu
//
//  Created by 許郁棋 on 2015/12/3.
//  Copyright © 2015年 Roy Hsu. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class BaseCollectionViewController: UICollectionViewController {
    
    var isRotatable = false { didSet { supportedInterfaceOrientations() } }
    
    var refreshControl: UIRefreshControl?
    
}


// MARK: - Setup

extension BaseCollectionViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad: return isRotatable ? [ .All ] : [ .Portrait ]
        default: return isRotatable ? [ .AllButUpsideDown ] : [ .Portrait ]
        }
        
    }
    
}


// MARK: - Refresh Control

extension BaseCollectionViewController {
    
    func beginPullToRefresh() {
        
        if let refreshControl = refreshControl {
            
            let offsetY = topLayoutGuide.length + refreshControl.bounds.size.height
            collectionView!.setContentOffset(CGPointMake(0.0, -offsetY), animated: true)
            refreshControl.beginRefreshing()
            refreshControl.sendActionsForControlEvents(.ValueChanged)
            
        }
        
    }
    
    func endPullToRefresh() { refreshControl?.endRefreshing() }
    
}


// MARK: - Infinity Scroll

extension BaseCollectionViewController {
    
    func addInfinityScroll(activityIndicatorStyle style: UIActivityIndicatorViewStyle, handler: (() -> Void)) {
        
        removeInfinityScroll()
        
        collectionView?.infiniteScrollIndicatorStyle = style
        collectionView?.addInfiniteScrollWithHandler { _ in handler() }
        
    }
    
    func removeInfinityScroll() {
        
        if collectionView?.infiniteScrollIndicatorView != nil {
            
            endInfinityScroll(completion: nil)
            collectionView?.removeInfiniteScroll()
            
        }
        
    }
    
    func endInfinityScroll(completion completion: (() -> Void)?) { collectionView?.finishInfiniteScrollWithCompletion { _ in completion?() } }
    
}
