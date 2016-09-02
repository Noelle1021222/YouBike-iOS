//
//  YBUserModel.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

class YBUserModel {
    
    let identifier: String
    var name: String
    var email: String?
    var profileImageURL: NSURL?
    var facebookURL: NSURL?
    
    init(identifier: String, name: String) {
        
        self.identifier = identifier
        self.name = name
        
    }
    
}
