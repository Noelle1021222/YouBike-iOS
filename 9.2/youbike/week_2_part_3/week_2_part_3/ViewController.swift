//
//  ViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/8/23.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var cellSelectPath : NSIndexPath?
    var btnSelectPath : NSIndexPath?

    var snaArray = [String]()
    var arArray = [String]()
    var sbiArray = [String]()
    var sareaArray = [String]()
    var arenArray = [String]()
    var latArray = [String]()
    var lngArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "YouBike"
        

        func getData() {
            //JSON資料處理
            
            let requestURL: NSURL = NSURL(string: "http://52.34.47.148/v1/stations")!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Everyone is fine, file downloaded successfully.")
                    
                    do{
                        
                        guard let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String: AnyObject] else {
                            return
                        }
                        
                        if let dataArray = jsonObject["data"] as? [AnyObject] {
                            
                            for item in dataArray {
                                
                                let stationName = (item["sna"] as? String) ?? "Unknown"
                                let sareaName = (item["sarea"] as? String) ?? "Unknown"
                                let sbiName = (item["sbi"] as? String) ?? "Unknown"
                                let arName = (item["ar"] as? String ) ?? "Unknown"
                                let arenName = (item["aren"] as? String) ?? "Unknown"
                                let latName = (item["lat"] as? String) ?? "Unknown"
                                let lngName = (item["lng"] as? String) ?? "Unknown"
                                self.snaArray.append(stationName)
                                self.sareaArray.append(sareaName)
                                self.sbiArray.append(sbiName)
                                self.arArray.append(arName)
                                self.arenArray.append(arenName)
                                self.latArray.append(latName)
                                self.lngArray.append(lngName)
                                
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                        
                    } catch {print("Error!")}
                    
                }
            }

            task.resume()
        }
        getData()
        
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

        return snaArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell: TbiCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TbiCell
        
        cell.stationNameLabel.text = "\(sareaArray[indexPath.row]) / \(snaArray[indexPath.row])"
        cell.stationPositionLabel.text = arArray[indexPath.row]

        cell.bikeAmountLabel.text = sbiArray[indexPath.row]

        cell.mapButton.addTarget(self, action: #selector(ViewController.MapBtnClicked), forControlEvents: .TouchUpInside)
        
        cell.mapButton.tag = indexPath.row
        

        
        return cell
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    
        
    let stationName = snaArray[indexPath.row]
    let address = arenArray[indexPath.row]
    print(stationName)
    let alert : UIAlertController = UIAlertController(title: "\(stationName)", message: "\(address)", preferredStyle: .Alert )
    let callaction = UIAlertAction(title: "返回", style: .Default , handler:nil);
    alert.addAction(callaction)
    self.presentViewController(alert, animated: true, completion: nil)
        
        cellSelectPath = indexPath
        
//        performSegueWithIdentifier("showMap", sender:self)
    
}
    var latitude = 0.0
    var longtitude = 0.0
    var subtitle = ""
    
    func MapBtnClicked(sender:UIButton)  {
        print(latArray[sender.tag])
        latitude = Double(latArray[sender.tag])!
        print(latitude)
        longtitude = Double(lngArray[sender.tag])!
        subtitle = "\(sareaArray[sender.tag]) / \(snaArray[sender.tag])"

        self.performSegueWithIdentifier("showMap", sender: sender)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showMap" {
            let destinationViewController = segue.destinationViewController as? MapViewController
            
            destinationViewController!.mapTitle = subtitle
            destinationViewController!.mapLatitude = latitude
            
            destinationViewController!.mapLongtitude = longtitude
        }
        
    }


    
    
    }
