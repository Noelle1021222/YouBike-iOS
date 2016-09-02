//
//  Facebook.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

enum FacebookPermission: String {
    case PublicProfile = "public_profile"
    case Email = "email"
}

protocol Facebook {
    
    var requiredReadPermissions: [FacebookPermission] { get }
    
}
