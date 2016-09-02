//
//  YBStationModelHelper.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct YBStationModelHelper { }


// MARK: - JSONParsable

extension YBStationModelHelper: JSONParsable {
    
    struct JSONKey {
        static let Identifier = "sno"
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let Name = "sna"
        static let Address = "ar"
        static let NumberOfRemainingBikes = "sbi"
    }
    
    enum JSONError: ErrorType { case MissingIdentifier, MissingLatitude, MissingLongitude, MissingName, MissingAddress, MissingNumberOfRemainingBikes, InvalidNumberOfRemainingBikes }
    
    func parse(json json: JSON) throws -> YBStationModel {
        
        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }
        guard let address = json[JSONKey.Address].string else { throw JSONError.MissingAddress }
        
        let station = YBStationModel(
            identifier: identifier,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            name: name,
            address: address
        )
        
        guard let numberOfRemainingBikesString = json[JSONKey.NumberOfRemainingBikes].string else { throw JSONError.MissingNumberOfRemainingBikes }
        
        guard let numberOfRemainingBikes = numberFormatter.numberFromString(numberOfRemainingBikesString) as? UInt else { throw JSONError.InvalidNumberOfRemainingBikes }
        station.numberOfRemainingBikes = numberOfRemainingBikes ?? 0
        
        return station
        
    }
    
}
