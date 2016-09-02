//
//  YBStationMapViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/26.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import MapKit

class YBStationMapViewController: BaseViewController {

    struct Static {
        static let Identifier = "YBStationMapViewController"
    }
    
    enum MapType: Int {
        
        case Standard, Satellite, Hybrid
        
        var title: String {
            
            switch self {
            case .Standard: return NSLocalizedString("Standard", comment: "")
            case .Satellite: return NSLocalizedString("Satellite", comment: "")
            case .Hybrid: return NSLocalizedString("Hybrid", comment: "")
            }
            
        }
        
    }
    
    @IBOutlet private(set) weak var mapView: MKMapView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mapTypeSegmentedControl: UISegmentedControl!
    
    var stationAnnotation: YBStationAnnotation? { didSet { stationAnnotationDidSet() } }
    var hidesBottomView = false { didSet { hidesBottomViewDidSet() } }
    
    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation?
    private var polylineTimer: NSTimer?
    private var isLoaded = false
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBStationMapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
}


// MARK: - Setup

extension YBStationMapViewController {
    
    private func setup() {
        
        isLoaded = true
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        bottomView.backgroundColor = YBColor.Color7
        
        mapTypeSegmentedControl.tintColor = YBColor.Color6
        
        for segmentIndex in 0..<mapTypeSegmentedControl.numberOfSegments {
            
            let mapType = MapType(rawValue: segmentIndex)!
            mapTypeSegmentedControl.setTitle(mapType.title, forSegmentAtIndex: segmentIndex)
            
        }
        
        stationAnnotationDidSet()
        hidesBottomViewDidSet()
        
    }
    
}


// MARK: - Observer

extension YBStationMapViewController {
    
    private func stationAnnotationDidSet() {
        
        if !isLoaded { return }
        
        guard let stationAnnotation = stationAnnotation else { return }
        
        navigationItem.title = stationAnnotation.title
        mapView.addAnnotation(stationAnnotation)
        
    }
    
    private func hidesBottomViewDidSet() {
        
        if !isLoaded { return }
        
        let bottomViewHeight = bottomView.bounds.size.height
        bottomViewBottomConstraint.constant = hidesBottomView ? -bottomViewHeight : 0.0
        
        bottomView.hidden = hidesBottomView
        
    }
    
}


// MARK: - Action

extension YBStationMapViewController {
    
    @IBAction func changeMapType(sender: AnyObject) {
        
        let segmentedControl = sender as? UISegmentedControl
        guard let selectedSegmentIndex = segmentedControl?.selectedSegmentIndex else { return }
        guard let selectedMapType = MapType(rawValue: selectedSegmentIndex) else { return }
        
        switch selectedMapType {
        case .Standard: mapView.mapType = .Standard
        case .Satellite: mapView.mapType = .Satellite
        case .Hybrid: mapView.mapType = .Hybrid
        }
        
    }
    
    private func checkLocationPermissionsStatus(status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined: locationManager.requestWhenInUseAuthorization()
        case .Denied:
            
            // todo: - alert
            selectStationAnnotation()
            
        case .Restricted: break // todo - : alert
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
        
    }
    
    private func selectStationAnnotation() {
        
        guard let stationAnnotation = stationAnnotation else { return }
        mapView.selectAnnotation(stationAnnotation, animated: true)
        
    }
    
    @objc private func getPolyline(sender: AnyObject?) {
    
        guard let currentUserLocation = currentUserLocation else { return }
        guard let stationAnnotation = stationAnnotation else { return }
        
        YBLocationManager.sharedManager.getPolyline(
            fromCoordinate: currentUserLocation.coordinate,
            toCoordinate: stationAnnotation.coordinate,
            transportType: .Walking,
            success: { [weak self] polyline in
                
                guard let weakSelf = self else { return }
                
                let existingOverlays = weakSelf.mapView.overlays
                weakSelf.mapView.removeOverlays(existingOverlays)
                
                weakSelf.mapView.addOverlay(polyline)
                weakSelf.mapView.selectAnnotation(stationAnnotation, animated: true)
                weakSelf.mapView.zoomToPolyLine(polyline, animated: true)
                
            },
            failure: { error in
                
                print(error)
            
            }
        )
    
    }
    
}


// MARK: - MKMapViewDelegate

extension YBStationMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is YBStationAnnotation {
            
            let identifier = YBStationAnnotationView.Static.Identifier
            let stationAnnotationView: YBStationAnnotationView!
            
            if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? YBStationAnnotationView {
                
                stationAnnotationView = annotationView
                
            }
            else {
                
                stationAnnotationView = YBStationAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
            }
            
            // Configure annotation view here.
            stationAnnotationView.canShowCallout = true
            
            return stationAnnotationView
            
        }
        
        return nil
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            
            let overlayRender = MKPolylineRenderer(overlay: overlay)
            overlayRender.strokeColor = YBColor.Color8
            
            return overlayRender
            
        }
        
        return MKOverlayRenderer()
        
    }
    
}


// MARK: - CLLocationManagerDelegate

extension YBStationMapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { checkLocationPermissionsStatus(status) }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentUserLocation = locations.last
        
        polylineTimer?.invalidate()
        polylineTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(getPolyline(_:)), userInfo: nil, repeats: false)
        
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        
        print("didFailToLocateUserWithError: \(error.localizedDescription)")
        
    }
    
}


// MARK: - Initializer

extension YBStationMapViewController {
    
    class func controller() -> YBStationMapViewController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBStationMapViewController }
    
}


// MARK: - MKMapView

extension MKMapView {
    
    private func zoomToPolyLine(polyline: MKPolyline, animated: Bool) {
        
        setVisibleMapRect(
            polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0),
            animated: animated
        )
        
    }
    
}
