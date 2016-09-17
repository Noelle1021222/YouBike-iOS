//
//  ViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/8/23.
//  Copyright © 2016年 許雅筑. All rights reserved.

//pod 'FBSDKCoreKit'
//pod 'FBSDKShareKit'
//pod 'FBSDKLoginKit'


import UIKit
//part 3
import FBSDKLoginKit
import FBSDKShareKit
import CoreData
import ReachabilitySwift
import Alamofire
import JWT

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var cellSelectPath : NSIndexPath?
    var btnSelectPath : NSIndexPath?
    var countAmount :Int = 0
    
    
    
    struct stationObject {
        var idNumber:String = ""
        var stationName:String = ""
        var sareaName:String = ""
        var sbiName:String = ""
        var arName:String = ""
        var arenName:String = ""
        var latName:String = ""
        var lngName:String = ""

    }
    
    var stationsArray :[stationObject] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "YouBike"
        //判斷連線
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            
            switch reachability.currentReachabilityStatus{
            case .ReachableViaWiFi:
                print("Connected With wifi")
                removeData()
                parseStation()
                break
            case .ReachableViaWWAN:
                print("Connected With Cellular network(3G/4G)")
                removeData()
                parseStation()
                break
            case .NotReachable:
                print("Internet connection FAILED")
                let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
                alert.actions
                removeData()

                fetch()
                break
            }
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
    
        
        let nib = UINib(nibName: "stationsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView:UITableView,numberOfRowsInSection section:Int) -> Int {
        return stationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell: TbiCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TbiCell
        
        cell.stationNameLabel.text = "\(stationsArray[indexPath.row].sareaName) / \(stationsArray[indexPath.row].stationName)"
        cell.stationPositionLabel.text = stationsArray[indexPath.row].arName

        cell.bikeAmountLabel.text = stationsArray[indexPath.row].sbiName

        cell.mapButton.addTarget(self, action: #selector(ViewController.MapBtnClicked), forControlEvents: .TouchUpInside)
        
        cell.mapButton.tag = indexPath.row
        
        countAmount = indexPath.row
        
        return cell
    }
    
    
    var latitude = 0.0
    var longtitude = 0.0
    var subtitle = ""
    var stationname = ""
    var stationposition = ""
    var bikeamount = ""
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        latitude = Double(stationsArray[indexPath.row].latName)!
        longtitude = Double(stationsArray[indexPath.row].lngName)!
        subtitle = "\(stationsArray[indexPath.row].sareaName) / \(stationsArray[indexPath.row].stationName)"
        stationname = "\(stationsArray[indexPath.row].sareaName) / \(stationsArray[indexPath.row].stationName)"
        stationposition = stationsArray[indexPath.row].arName
        bikeamount = stationsArray[indexPath.row].sbiName
        cellSelectPath = indexPath
        
        
        self.performSegueWithIdentifier("cellMyMap", sender:self)
        
        cellSelectPath = indexPath
        
    
}

    func MapBtnClicked(sender:UIButton)  {
        print(stationsArray[sender.tag].latName)
        latitude = Double(stationsArray[sender.tag].latName)!
        print(latitude)
        longtitude = Double(stationsArray[sender.tag].lngName)!
        subtitle = "\(stationsArray[sender.tag].sareaName) / \(stationsArray[sender.tag].stationName)"

        self.performSegueWithIdentifier("showMap", sender: sender)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destinationViewController as? MapViewController
            
            destinationViewController!.mapTitle = subtitle
            destinationViewController!.mapLatitude = latitude
            
            destinationViewController!.mapLongtitude = longtitude
        }
        
        else if segue.identifier == "cellMyMap" {
            let destinationViewController = segue.destinationViewController as? CellMapViewController
            
            destinationViewController!.mapTitle = subtitle
            destinationViewController!.mapLatitude = latitude
            destinationViewController!.mapLongtitude = longtitude
            destinationViewController!.mapStationname = stationname
            destinationViewController!.mapStationposition = stationposition

            destinationViewController!.mapBikeamount = bikeamount

    //            destinationViewController?.hidesBottomBarWhenPushed = true
//
//            navigationController?.pushViewController(ViewController, animated: true)
            
            segue.destinationViewController.hidesBottomBarWhenPushed = true
            
//            self.navigationController?.pushViewController(segue.destinationViewController, animated: true)
        }
        
    }
    
    let appdel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //coreData
    //coreData
    func fetch() {

        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Station")
        do {
            let results = try moc.executeFetchRequest(fetchRequest) as! [Station]

            for result in results {
                //no internet will print
                print("Product Name: \(result.sbi), Price: \(result.sna)")

                var stationReal = stationObject()
                stationReal.stationName = result.sna!
                stationReal.sareaName = result.sarea!
                stationReal.sbiName = result.sbi!
                stationReal.arName = result.ar!
                stationReal.arenName = result.aren!
                stationReal.latName = result.lat!
                stationReal.lngName = result.lng!
                
                
                
                self.stationsArray.append(stationReal)
                
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData()

            })

        } catch{
            fatalError()
        }
        
    }
    
    func removeData () {
        // Remove the existing items
        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Station")
        
        do {
            let stationItems = try moc.executeFetchRequest(fetchRequest) as! [Station]
            for stationItem in stationItems {
                moc.deleteObject(stationItem)
            }
            do {
                try moc.save()
            }
        } catch {
            print(error)
        }
        
    }
    
//
    func parseStation (){
        removeData()
        //get
        let token =  JWT.encode(.HS256("appworks")) { builder in
            builder["name"] = "noelle"
            builder.issuedAt = NSDate()
            builder.expiration = NSDate().dateByAddingTimeInterval(5*60)
        }
        var coreDataStation = stationObject()
        let moc = DataController().managedObjectContext

        Alamofire.request(.GET, NSURL(string: "http://52.34.47.148/v2/stations")!, encoding:.JSON , headers: ["Authorization" : "Bearer \(token)"]).responseJSON { response in
            
            if let JSON = response.result.value {
                print("GET Request: \(JSON)")
                if let dataArray = JSON["data"] as? [AnyObject] {
                    for thing in dataArray {
                        coreDataStation.idNumber = (thing["sno"] as? String) ?? "Unknown"
                        coreDataStation.stationName = (thing["sna"] as? String) ?? "Unknown"
                        coreDataStation.sareaName = (thing["sarea"] as? String) ?? "Unknown"
                        coreDataStation.sbiName = (thing["sbi"] as? String) ?? "Unknown"
                        coreDataStation.arName = (thing["ar"] as? String ) ?? "Unknown"
                        coreDataStation.arenName = (thing["aren"] as? String) ?? "Unknown"
                        coreDataStation.latName = (thing["lat"] as? String) ?? "Unknown"
                        coreDataStation.lngName = (thing["lng"] as? String) ?? "Unknown"
                        coreDataStation.idNumber = (thing["sno"] as? String) ?? "Unknown"
                        
                        print("Product Name: \(coreDataStation.sbiName), Price: \(coreDataStation.stationName)")
                        self.stationsArray.append(coreDataStation)
                        
                        let stationItem = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: moc) as! Station
                        stationItem.id = coreDataStation.idNumber
                        stationItem.sna = coreDataStation.stationName
                        stationItem.sarea = coreDataStation.sareaName
                        stationItem.sbi = coreDataStation.sbiName
                        stationItem.ar = coreDataStation.arName
                        stationItem.aren = coreDataStation.arenName
                        stationItem.lat = coreDataStation.latName
                        stationItem.lng = coreDataStation.lngName
                        stationItem.id = coreDataStation.idNumber
                    }
                    do {
                        try moc.save()
                    }
                    catch {
                        fatalError("failure to save context : \(error)")
                    }

                }
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                }
                
            }
        }
    }
//        var coreDataStation = stationObject()
//        let moc = DataController().managedObjectContext
//        do {
//            let remoteURL = NSURL(string: "http://52.34.47.148/v1/stations")!
//            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: remoteURL)
//            let session = NSURLSession.sharedSession()
//            let task = session.dataTaskWithRequest(urlRequest) {
//                (data, response, error) -> Void in
//                let httpResponse = response as! NSHTTPURLResponse
//                let statusCode = httpResponse.statusCode
//                if (statusCode == 200) {
//                    print("Everyone is fine, file downloaded successfully.")
//                    do{
//                        guard let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String: AnyObject] else {
//                            return
//                        }
//                        if let dataArray = jsonObject["data"] as? [AnyObject] {
//                            for thing in dataArray {
//                                coreDataStation.idNumber = (thing["sno"] as? String) ?? "Unknown"
//                                coreDataStation.stationName = (thing["sna"] as? String) ?? "Unknown"
//                                coreDataStation.sareaName = (thing["sarea"] as? String) ?? "Unknown"
//                                coreDataStation.sbiName = (thing["sbi"] as? String) ?? "Unknown"
//                                coreDataStation.arName = (thing["ar"] as? String ) ?? "Unknown"
//                                coreDataStation.arenName = (thing["aren"] as? String) ?? "Unknown"
//                                coreDataStation.latName = (thing["lat"] as? String) ?? "Unknown"
//                                coreDataStation.lngName = (thing["lng"] as? String) ?? "Unknown"
//                                coreDataStation.idNumber = (thing["sno"] as? String) ?? "Unknown"
//

//                            }

//                            
//                        }
//                        dispatch_async(dispatch_get_main_queue()){
//                            self.tableView.reloadData()
//                        }
//                    }
//                    catch {print("Error!")}
//                }
//            }
//            task.resume()
//        }
        
    }

