//
//  BaseManager.swift
//  RoyHsu
//
//  Created by 許郁棋 on 2015/10/12.
//  Copyright © 2015年 Roy Hsu. All rights reserved.
//

import Foundation

class BaseManager {
    
    enum DebugLevel: Int {
        case Low // System. Customized functions. Raw data.
        case Medium // System. Customized functions.
        case High // System.
    }
    
    var debugLevel: DebugLevel = .High
    
    func printDebug(string: String, level: DebugLevel) {
        
        if debugLevel.rawValue <= level.rawValue { print(string) }
        
    }
    
}
