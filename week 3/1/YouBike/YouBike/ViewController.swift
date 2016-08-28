//
//  ViewController.swift
//  YouBike
//
//  Created by 許雅筑 on 2016/8/26.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import Alamofire
import JWT

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //get
            let token =  JWT.encode(.HS256("appworks")) { builder in
            builder["name"] = "noelle"
            builder.issuedAt = NSDate()
            builder.expiration = NSDate().dateByAddingTimeInterval(5*60)
                
        }
            
        Alamofire.request(.GET, NSURL(string: "http://52.34.47.148/v1/stations")!, encoding:.JSON , headers: ["Authorization" : "Bearer \(token)"]).responseJSON { response in

            
            if let JSON = response.result.value {
                print("GET Request: \(JSON)")
            }
        }
        
        //post
        Alamofire.request(.POST, NSURL(string: "http://52.34.47.148/v2/checkins")!, encoding:.JSON , headers: ["Authorization" : "Bearer \(token)"],parameters:["latitude": 13.0,
            "longitude": 23.0]).responseJSON { response in
            
            if let JSON = response.result.value {
                print("POST Request: \(JSON)")
            }
        }
        
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
