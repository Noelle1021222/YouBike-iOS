//
//  YBGlobal.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

struct YBGlobal {
    static let AppName = NSLocalizedString("YouBike", comment: "")
}

struct YBDate {
    static let DateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let TimeZone = NSTimeZone(name: "UTC")
}


// MARK: - UIStoryboard

extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone: return UIStoryboard(name: "Main_iPhone", bundle: nil)
        default: return UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        
    }
    
}


// MARK: - NSURLComponents

extension NSURLComponents {
    
    typealias QueryItem = (name: String, value: String)
    
    func appendQueryItem(item: QueryItem) {
        
        var queryItems: [NSURLQueryItem] = self.queryItems ?? []
        
        queryItems.append(NSURLQueryItem(name: item.name, value: item.value))
        
        self.queryItems = queryItems
        
    }
    
}
