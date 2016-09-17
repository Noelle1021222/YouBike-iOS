//
//  CellMapViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/9/2.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import MapKit
class CellMapViewController: UIViewController {
    var mapLatitude : Double = 0.0
    var mapLongtitude : Double = 0.0
    var mapTitle: String = ""
    @IBOutlet var cellMyMap: MKMapView!
    
    @IBOutlet weak var mapTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "stationsCell", bundle: nil)
        mapTableview.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor(red: 251/255, green: 197/255, blue: 111/255, alpha: 1)
        
        
        
        self.navigationItem.title = mapTitle
        
        
        let myposition = CLLocationCoordinate2D(latitude: mapLatitude, longitude: mapLongtitude)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center:myposition,span:span)
        
        cellMyMap.showsUserLocation = true
        cellMyMap.zoomEnabled = true
        
        cellMyMap.setRegion(region,animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myposition
        cellMyMap.addAnnotation(annotation)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
