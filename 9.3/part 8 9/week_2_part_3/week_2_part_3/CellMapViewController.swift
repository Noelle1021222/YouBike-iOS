//
//  CellMapViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/9/4.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CellMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    var mapLatitude : Double = 0.0
    var mapLongtitude : Double = 0.0
    var mapTitle: String = ""
    //for card
    var mapStationname : String = ""
    var mapStationposition: String = ""
    var mapBikeamount: String = ""

    //get user
    var locationManager:CLLocationManager!
    
    var userCoordinate: CLLocationCoordinate2D!
    
    @IBOutlet var cellMyMap: MKMapView!
    @IBOutlet weak var onlyView: TbiView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        //navigation title
        nav?.tintColor = UIColor(red: 251/255, green: 197/255, blue: 111/255, alpha: 1)
        self.navigationItem.title = mapTitle
        
        //view
        onlyView.bikeAmountLabel.text = mapBikeamount
        onlyView.stationNameLabel.text = mapStationname
        onlyView.stationPositionLabel.text = mapStationposition
    
        //map
        let myposition = CLLocationCoordinate2D(latitude: mapLatitude, longitude: mapLongtitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center:myposition,span:span)
        
        cellMyMap.showsUserLocation = true
        cellMyMap.zoomEnabled = true
        
        cellMyMap.setRegion(region,animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myposition
        cellMyMap.addAnnotation(annotation)
        
        
        
        
                
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        //get user coordinate
        userCoordinate = locationManager.location?.coordinate

        print(userCoordinate)

    }
    
    //假如要user置中時
    func locationManager(manager:CLLocationManager,didUpdateLocations locations:[CLLocation] ){
//        let userLocation:CLLocation = locations[0] as CLLocation
        
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.02,longitudeDelta:0.02))
//        
//        cellMyMap.setRegion(region, animated: true)

    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
}
