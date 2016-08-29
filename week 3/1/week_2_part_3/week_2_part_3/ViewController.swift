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
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TbiCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TbiCell
        
        cell.stationNameLabel.text = "\(sareaArray[indexPath.row]) / \(snaArray[indexPath.row])"
        cell.stationPositionLabel.text = arArray[indexPath.row] as? String
        cell.bikeAmountLabel.text = sbiArray[indexPath.row] as? String
        

        
        return cell
    }
    
    //OK
    func getData() {
        
        guard let path = NSBundle.mainBundle().pathForResource("stations", ofType: "json") else {
            print("Error finding file")
            return
        }
        
        do {
            //JSON資料處理
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: path)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["data"]! as! [AnyObject]
            print(dataArray)
            for item in dataArray{
                snaArray.append(item["sna"]!!)
                sareaArray.append(item["sarea"]!!)
                sbiArray.append(item["sbi"]!!)
                arArray.append(item["ar"]!!)
                

            }
            
        } catch {
            print("Error!")
        }
        
    }


}
