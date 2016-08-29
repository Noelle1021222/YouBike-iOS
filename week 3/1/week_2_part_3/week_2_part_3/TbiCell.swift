//
//  TbiCell.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/8/29.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit

class TbiCell: UITableViewCell {


    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    @IBOutlet weak var stationPositionLabel: UILabel!
    @IBOutlet weak var bikeAmountLabel: UILabel!
    
    @IBOutlet weak var iconPosition: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconPosition.tintColor = UIColor(red: 160/255, green: 98/255, blue: 90/255, alpha: 1)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
