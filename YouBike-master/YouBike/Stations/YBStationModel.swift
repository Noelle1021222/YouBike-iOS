//
//  YBStationModel.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreLocation

class YBStationModel {
    
    let identifier: String
    let coordinate: CLLocationCoordinate2D
    let name: String
    let address: String
    var numberOfRemainingBikes: UInt = 0
    
    init(identifier: String, coordinate: CLLocationCoordinate2D, name: String, address: String) {
        
        self.identifier = identifier
        self.coordinate = coordinate
        self.name = name
        self.address = address
        
    }
    
}
