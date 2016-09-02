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
    
    var objects = [AnyObject]()
    var dataArray = [AnyObject]()
    var snaArray = [AnyObject]()
    var arArray = [AnyObject]()
    var sbiArray = [AnyObject]()
    var sareaArray = [AnyObject]()
    var arenArray = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    let nib = UINib(nibName: "stationsCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "Cell")

        getData()
        
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
        let cell: TbiCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TbiCell
        
        cell.stationNameLabel.text = "\(sareaArray[indexPath.row]) / \(snaArray[indexPath.row])"
        cell.stationPositionLabel.text = arArray[indexPath.row] as? String
        cell.bikeAmountLabel.text = sbiArray[indexPath.row] as? String
//        cell.mapButton.addTarget(self, action: #selector(ViewController.clickButton), forControlEvents: .TouchUpInside)
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let otherVC = storyboard.instantiateViewControllerWithIdentifier("MapViewController")
        cell.mapButton.addTarget(self, action: #selector(ViewController.MapBtnClicked), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func MapBtnClicked(sender:UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stationName = snaArray[indexPath.row]
        let address = arenArray[indexPath.row]
        
        let alert : UIAlertController = UIAlertController(title: "\(stationName)", message: "\(address)", preferredStyle: .Alert )
        let callaction = UIAlertAction(title: "返回", style: .Default , handler:nil);
        alert.addAction(callaction)
        self.presentViewController(alert, animated: true, completion: nil);
        
    }
    
    func clickButton(sender: UIButton)  {

        sender.tintColor = UIColor(hue: 0.1, saturation: 0.2, brightness: 0.1, alpha: 1)
    }
    
    //OK
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
                                
                                self.snaArray.append(stationName)
                                self.sareaArray.append(sareaName)
                                self.sbiArray.append(sbiName)
                                self.arArray.append(arName)
                                self.arenArray.append(arenName)
                            }

                    }
                    dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })

                } catch {print("Error!")}
                

            
            }
        }
            task.resume()
    }
}
