//
//  YBStationCollectionViewCell.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBStationCollectionViewCell: UICollectionViewCell {

    struct Static {
        static let Identifier = "YBStationCollectionViewCell"
        static let Margin: CGFloat = 15.0
    }

    @IBOutlet private weak var remainingBikesLabel: UILabel!
    @IBOutlet private weak var nameTopView: UIView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    
    private var isLoaded = false
    
    var numberOfRemainingBikes: UInt = 0 { didSet { numberOfRemainingBikesDidSet() } }
    
}


// MARK: - View Life Cycle

extension YBStationCollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}


// MARK: - Setup

extension YBStationCollectionViewCell {
    
    private func setup() {
        
        isLoaded = true
        
        backgroundColor = YBColor.Color1
        
        nameLabel.text = ""
        nameLabel.textColor = YBColor.Color2
        
        numberOfRemainingBikes = 0
        remainingBikesLabel.textColor = YBColor.Color4
        
        nameTopView.backgroundColor = YBColor.Color3
        
    }
    
}


// MARK: - Observer

extension YBStationCollectionViewCell {
    
    private func numberOfRemainingBikesDidSet() {
        
        if !isLoaded { return }
        
        remainingBikesLabel.text = "\(numberOfRemainingBikes)"
        
    }
    
}
