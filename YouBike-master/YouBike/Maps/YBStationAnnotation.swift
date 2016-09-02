//
//  YBStationAnnotation.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/26.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import MapKit

class YBStationAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D { return station.coordinate }
    var station: YBStationModel
    var title: String? { return station.name }
    var subtitle: String? { return station.address }
    
    init(station: YBStationModel) { self.station = station }
    
}
