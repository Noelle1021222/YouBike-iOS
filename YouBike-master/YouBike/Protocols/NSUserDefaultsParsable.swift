//
//  NSUserDefaultsParsable.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

protocol NSUserDefaultsParsable {
    
    associatedtype T
    
    func parse(defaults defaults: NSUserDefaults) throws -> T
    
}
