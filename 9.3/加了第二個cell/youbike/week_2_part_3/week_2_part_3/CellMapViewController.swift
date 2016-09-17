//
//  CellMapViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/9/2.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import MapKit
class CellMapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var mapTableview: UITableView!
    @IBOutlet var cellMyMap: MKMapView!
    var mapLatitude : Double = 0.0
    var mapLongtitude : Double = 0.0
    var mapTitle: String = ""
    //for card
    var mapStationname : String = ""
    var mapStationposition: String = ""
    var mapBikeamount: String = ""
    

    //for card
    var mapMyStationname : String = ""
    var mapMyStationposition: String = ""
    var mapMyBikeamount: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //register
        let nib = UINib(nibName: "mapCell", bundle: nil)
        mapTableview.registerNib(nib, forCellReuseIdentifier: "mapCell")
        
        let nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor(red: 251/255, green: 197/255, blue: 111/255, alpha: 1)
        
        
        self.navigationItem.title = mapTitle
        
        mapMyStationname = mapStationname
        mapMyBikeamount = mapBikeamount
        mapMyStationposition = mapStationposition
        
        //map
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView:UITableView,numberOfRowsInSection section:Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "mapCell"
        let cell : mapCell = self.mapTableview.dequeueReusableCellWithIdentifier(cellIdentifier) as! mapCell
        
        cell.stationNameLabel.text = mapMyStationname
        cell.stationPositionLabel.text = mapMyStationposition
        cell.bikeAmountLabel.text = mapMyBikeamount
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
