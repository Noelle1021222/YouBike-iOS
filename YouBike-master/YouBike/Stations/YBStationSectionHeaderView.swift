//
//  YBStationSectionHeaderView.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBStationSectionHeaderView: UIView {

    struct Static {
        static let Identifier = "YBStationSectionHeaderView"
        static let Height: CGFloat = 28.0
    }
    
    @IBOutlet private(set) weak var titleLabel: UILabel!

}


// MARK: - View Life Cycle

extension YBStationSectionHeaderView {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}


// MARK: - Setup

extension YBStationSectionHeaderView {
    
    private func setup() {
        
        backgroundColor = YBColor.Color7
        
        titleLabel.text = ""
        titleLabel.textColor = YBColor.Color6
        
    }
    
}


// MARK: - Initializer

extension YBStationSectionHeaderView {
    
    class func view() -> YBStationSectionHeaderView { return UIView.loadFromNibNamed(Static.Identifier) as! YBStationSectionHeaderView }
    
}
