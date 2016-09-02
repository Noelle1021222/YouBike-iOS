//
//  YBCommentTableViewCell.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBCommentTableViewCell: UITableViewCell {

    struct Static {
        static let Identifier = "YBCommentTableViewCell"
    }
    
    @IBOutlet private(set) weak var profileImageView: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var dateLabel: UILabel!
    @IBOutlet private(set) weak var commentLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
}


// MARK: - View Life Cycle

extension YBCommentTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}


// MARK: - Setup

extension YBCommentTableViewCell {
    
    private func setup() {
        
        backgroundColor = YBColor.Color1
        
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.layer.borderColor = YBColor.Color7.CGColor
        profileImageView.layer.borderWidth = 1.0
        
        nameLabel.text = ""
        nameLabel.textColor = YBColor.Color2
        
        dateLabel.text = ""
        dateLabel.textColor = YBColor.Color3
        
        commentLabel.text = ""
        commentLabel.textColor = YBColor.Color3
        
        bottomView.backgroundColor = YBColor.Color5
        
    }
    
}
