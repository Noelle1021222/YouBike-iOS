//
//  YBStationViewModeSwitcherView.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/3.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBStationViewModeSwitcherView: UISegmentedControl {

    struct Static {
        static let Identifier = "YBStationViewModeSwitcherView"
    }
    
    enum Item: Int {
        
        case List, Grid
        
        var image: UIImage {
            
            switch self {
            case .List: return UIImage(named: "icon-list")!.imageWithRenderingMode(.AlwaysTemplate)
            case .Grid: return UIImage(named: "icon-grid")!.imageWithRenderingMode(.AlwaysTemplate)
            }
            
        }
        
    }
    
    let items: [Item] = [ .List, .Grid ]
    
    var selectedItem: Item { return Item(rawValue: selectedSegmentIndex)! }
    
    
    // MARK: - Initializer
    
    init() {
        
        super.init(items: items.map { return $0.image })
        
        selectedSegmentIndex = Item.List.rawValue
        
    }
    
    private override init(frame: CGRect) { super.init(frame: frame) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
