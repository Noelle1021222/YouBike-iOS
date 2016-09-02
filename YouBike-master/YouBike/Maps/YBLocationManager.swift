//
//  YBLocationManager.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/26.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import MapKit

class YBLocationManager: BaseManager {
    
    struct Static {
        static let Identifier = "YBLocationManager"
    }
    
    static let sharedManager = YBLocationManager()
    
    
    // MARK: - Init
    
    private override init() {
        
        super.init()
        setup()
    
    }
    
}


// MARK: - Setup

extension YBLocationManager {
    
    private func setup() { }
    
}


// MARK: - Polyline

extension YBLocationManager {
    
    typealias GetPolylineSuccess = (polyline: MKPolyline) -> Void
    typealias GetPolylineFailure = (error: ErrorType) -> Void
    
    enum GetPolylineError: ErrorType { case Error(error: ErrorType), NoPolyline }
    
    func getPolyline(fromCoordinate fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, success: GetPolylineSuccess, failure: GetPolylineFailure?) -> MKDirections {
        
        let functionName = "getPolyline(fromCoordinate:toCoordinate:transportType:success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        let sourcePlaceMark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        
        let destinationPlaceMark = MKPlacemark(coordinate: toCoordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.transportType = transportType
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler { response, error in
            
            if let err = error {
                
                failure?(error: GetPolylineError.Error(error: err))
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                return
                
            }
            
            guard let polyline = response?.routes.first?.polyline else {
                
                let polylineError: GetPolylineError = .NoPolyline
                failure?(error: polylineError)
                self.printDebug("\(identifier): \(polylineError)", level: .Medium)
                
                return
                
            }
            
            success(polyline: polyline)

        }
        
        return directions
        
    }
    
}
