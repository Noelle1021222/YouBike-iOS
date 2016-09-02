//
//  YBCommentModel.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

class YBCommentModel {
    
    let identifier: String
    let text: String
    let user: YBUserModel
    let createdDate: NSDate
    
    init(identifier: String, text: String, user: YBUserModel, createdDate: NSDate) {
        
        self.identifier = identifier
        self.text = text
        self.user = user
        self.createdDate = createdDate
        
    }
    
}
