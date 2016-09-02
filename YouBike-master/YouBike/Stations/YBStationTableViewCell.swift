//
//  YBStationTableViewCell.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

protocol YBStationTableViewCellDelegate: class {
    
    func stationTableViewCell(cell: YBStationTableViewCell, viewMap sender: AnyObject?)
    
}

class YBStationTableViewCell: UITableViewCell {

    struct Static {
        static let Identifier = "YBStationTableViewCell"
        static let Height: CGFloat = 122.0
    }
    
    @IBOutlet private weak var markerIconImageView: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var addressLabel: UILabel!
    @IBOutlet private weak var remainingBikesLabel: UILabel!
    @IBOutlet private(set) weak var viewMapButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    
    private var isLoaded = false
    
    var numberOfRemainingBikes: UInt = 0 { didSet { numberOfRemainingBikesDidSet() } }
    
    weak var delegate: YBStationTableViewCellDelegate?
    
}


// MARK: - View Life Cycle

extension YBStationTableViewCell {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}


// MARK: - Setup

extension YBStationTableViewCell {
    
    private func setup() {
        
        isLoaded = true
        
        backgroundColor = YBColor.Color1
        
        markerIconImageView.image = UIImage(named: "icon-marker")!.imageWithRenderingMode(.AlwaysTemplate)
        markerIconImageView.tintColor = YBColor.Color2
        
        nameLabel.text = ""
        nameLabel.textColor = YBColor.Color2
        
        addressLabel.text = ""
        addressLabel.textColor = YBColor.Color3
        
        viewMapButton.setTitle(NSLocalizedString("View Map", comment: ""), forState: .Normal)
        viewMapButton.tintColor = YBColor.Color4
        viewMapButton.layer.cornerRadius = 4.0
        viewMapButton.layer.borderWidth = 1.0
        viewMapButton.layer.borderColor = YBColor.Color4.CGColor
        viewMapButton.addTarget(self, action: #selector(viewMap(_:)), forControlEvents: .TouchUpInside)
        
        numberOfRemainingBikes = 0
        
        bottomView.backgroundColor = YBColor.Color5
        
    }
    
}


// MARK: - Observer

extension YBStationTableViewCell {
    
    private func numberOfRemainingBikesDidSet() {
    
        if !isLoaded { return }
        
        let remainingBikesString = NSLocalizedString("%d bikes left", comment: "")
        let numberOfRemainingBikesRange = (remainingBikesString as NSString).rangeOfString("%d")
        
        let remainingBikesAttributedString = NSMutableAttributedString(
            string: String(format: remainingBikesString, numberOfRemainingBikes),
            attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(20.0),
                NSForegroundColorAttributeName: YBColor.Color3
            ]
        )
        
        remainingBikesAttributedString.addAttributes(
            [
                NSFontAttributeName: UIFont.boldSystemFontOfSize(80.0),
                NSForegroundColorAttributeName: YBColor.Color4
            ],
            range: numberOfRemainingBikesRange
        )
        
        remainingBikesLabel.attributedText = remainingBikesAttributedString
    
    }
    
}


// MARK: - Action

extension YBStationTableViewCell {
    
    @objc private func viewMap(sender: AnyObject?) { delegate?.stationTableViewCell(self, viewMap: sender) }
    
}
