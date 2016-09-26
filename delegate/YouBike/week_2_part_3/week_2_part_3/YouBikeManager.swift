//
//  YouBikeManager.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/8/30.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import Foundation
class YouBikeManager {
    static let shared = YouBikeManager()
    
    var delegate: YouBikeManagerDelegate?
    
    typealias GetStationsCompletionHandler = (stations: [String: AnyObject]) -> Void
    var stations : [String: AnyObject]?
    func getData(completionHandler completionHandler: GetStationsCompletionHandler) {
        //JSON資料處理
        guard let requestURL: NSURL = NSURL(string: "http://52.34.47.148/v1/stations") else {
            fatalError()
            return
        }
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) -> Void in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                fatalError()
                return
            }
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    
                    guard let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String: AnyObject] else {
                        return
                    }

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.tableView.reloadData()
                        self.stations = jsonObject
                        self.delegate?.reloadWhenReceivedData()
                        completionHandler(stations: jsonObject)
                    })
                    
                } catch {print("Error!")}
            }
        })
        
        task.resume()
    }
}