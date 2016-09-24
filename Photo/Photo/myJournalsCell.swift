//
//  myJournalsCell.swift
//  Photo
//
//  Created by 許雅筑 on 2016/9/19.
//  Copyright © 2016年 hsu.ya.chu. All rights reserved.
//

import UIKit

class myJournalsCell: UITableViewCell {

    @IBOutlet weak var beautifulPhoto: UIImageView?
    @IBOutlet weak var beautifulPhotoTopic: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
