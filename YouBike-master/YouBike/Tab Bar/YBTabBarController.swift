//
//  YBTabBarController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBTabBarController: BaseTabBarController {

    struct Static {
        static let Identifier = "YBTabBarController"
    }
    
    enum TabBarItemType: Int {
        
        case Stations, Profile
        
        var title: String {
            
            switch self {
            case .Stations: return NSLocalizedString("Stations", comment: "")
            case .Profile: return NSLocalizedString("Profile", comment: "")
            }
            
        }
        
        var image: UIImage {
            
            switch self {
            case .Stations: return UIImage(named: "tab-bar-bike")!.imageWithRenderingMode(.AlwaysTemplate)
            case .Profile: return UIImage(named: "tab-bar-profile")!.imageWithRenderingMode(.AlwaysTemplate)
            }
            
        }
        
    }
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension YBTabBarController {
    
    private func setup() {
        
        setupTabBarItems()
        
        tabBar.translucent = false
        tabBar.barTintColor = YBColor.Color7
        tabBar.tintColor = YBColor.Color6
        
    }
    
    private func setupTabBarItems() {
        
        guard let items = tabBar.items else { return }
            
        for item in items {
            
            if let itemType = TabBarItemType(rawValue: item.tag) {
                
                item.title = itemType.title
                item.image = itemType.image
                
            }
            
        }
        
    }
    
}


// MARK: - Initializer

extension YBTabBarController {
    
    class func controller() -> YBTabBarController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBTabBarController }
    
}
