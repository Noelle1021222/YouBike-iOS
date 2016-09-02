//
//  YBRouter.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Alamofire
import JWT

enum YBRouter {
    case GetStations(parameters: [String: AnyObject]?)
    case GetCommentsForStation(stationID: String, parameters: [String: AnyObject]?)
}


// MARK: - URLRequestConvertible

extension YBRouter: URLRequestConvertible {
    
    var baseURLString: String { return "http://52.34.47.148/v2" }
    
    var method: Alamofire.Method {
        
        switch self {
        case .GetStations, .GetCommentsForStation: return .GET
        }
        
    }
    
    var path: String {
        
        switch self {
        case .GetStations: return "stations"
        case .GetCommentsForStation(let stationID, _): return "stations/\(stationID)/comments"
        }
        
    }
    
    var URLRequest: NSMutableURLRequest {
    
        let URL = NSURL(string: baseURLString)!.URLByAppendingPathComponent(path)
        let URLRequest = NSMutableURLRequest(URL: URL)
        
        URLRequest.HTTPMethod = method.rawValue
        
        if let accessToken = accessToken {
            
            URLRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
        }
        
        switch self {
        case .GetStations(let parameters): return ParameterEncoding.URL.encode(URLRequest, parameters: parameters).0
        case .GetCommentsForStation(_, let parameters): return ParameterEncoding.URL.encode(URLRequest, parameters: parameters).0
        }
        
    }
    
    private var accessToken: String? {
        
        guard let user = YBUserManager.sharedManager.user else { return nil }
        
        return JWT.encode(.HS256("appworks")) { builder in
            
            let currentDate = NSDate()
            
            builder.issuer = user.name
            builder.issuedAt = currentDate
            builder.expiration = currentDate.dateByAddingTimeInterval(5.0 * 60.0) // 5 minutes
            
        }
        
    }
    
}
