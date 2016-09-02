//
//  JSONParsable.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import SwiftyJSON

protocol JSONParsable {
    
    associatedtype T
    
    func parse(json json: JSON) throws -> T
    
}
