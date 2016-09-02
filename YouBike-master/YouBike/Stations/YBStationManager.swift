//
//  YBStationManager.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Alamofire
import SwiftyJSON

class YBStationManager: BaseManager {
    
    struct Static {
        static let Identifier = "YBStationManager"
    }
    
    static let sharedManager = YBStationManager()
    
    
    // MARK: - Init
    
    private override init() {
        
        super.init()
        setup()
        
    }
    
}


// MARK: - Setup

extension YBStationManager {
    
    private func setup() { }
    
}


// MARK: - Stations

extension YBStationManager {
    
    typealias GetStationsSuccess = (stations: [YBStationModel], next: String?) -> Void
    typealias GetStationsFailure = (error: ErrorType) -> Void
    
    enum GetStationsError: ErrorType { case Server(message: String) }
    
    func getStations(success success: GetStationsSuccess, failure: GetStationsFailure?) -> Request {
        
        let functionName = "getStations(success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        let URLRequest = YBRouter.GetStations(parameters: nil)
        let request = Alamofire.request(URLRequest).validate().responseData { result in
            
            self.printDebug("\(identifier): [Response]: \(result.response)", level: .Low)
            
            if let statusCode = result.response?.statusCode {
                
                self.printDebug("\(identifier): (\(statusCode)) \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))", level: .High)
                
            }
            
            switch result.result {
            case .Success(let data):
                
                let json = JSON(data: data)
                
                self.printDebug("\(identifier): [Data]: \(json)", level: .Low)
                
                var stations: [YBStationModel] = []
                
                for (_, subJSON) in json["data"] {
                    
                    do {
                        
                        let station = try YBStationModelHelper().parse(json: subJSON)
                        
                        stations.append(station)
                        
                    }
                    catch(let error) { self.printDebug("\(identifier): \(error)", level: .Low) }
                    
                }
                
                let next = json["paging"]["next"].string
                
                success(stations: stations, next: next)
                
            case .Failure(let err):
                
                let error: GetStationsError = .Server(message: err.localizedDescription)
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                failure?(error: error)
                
            }
            
        }
        
        printDebug("\(identifier): [Request]: \(request.debugDescription)", level: .Low)
        
        return request
        
    }
    
    typealias GetMoreStationsSuccess = (stations: [YBStationModel], next: String?) -> Void
    typealias GetMoreStationsFailure = (error: ErrorType) -> Void

    enum GetMoreStationsError: ErrorType { case EmptyPaging, Server(message: String) }
    
    func getMoreStations(paging paging: String, success: GetMoreStationsSuccess, failure: GetMoreStationsFailure?) -> Request? {
        
        let functionName = "getMoreStations(paging:success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        if paging.isEmpty {
            
            let error: GetMoreStationsError = .EmptyPaging
            self.printDebug("\(identifier): \(error)", level: .Medium)
            
            failure?(error: error)
            
            return nil
            
        }
        
        let URLRequest = YBRouter.GetStations(parameters: [ "paging": paging ])
        let request = Alamofire.request(URLRequest).validate().responseData { result in
            
            self.printDebug("\(identifier): [Response]: \(result.response)", level: .Low)
            
            if let statusCode = result.response?.statusCode {
                
                self.printDebug("\(identifier): (\(statusCode)) \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))", level: .High)
                
            }
            
            switch result.result {
            case .Success(let data):
                
                let json = JSON(data: data)
                
                self.printDebug("\(identifier): [Data]: \(json)", level: .Low)
                
                var stations: [YBStationModel] = []
                
                for (_, subJSON) in json["data"] {
                    
                    do {
                        
                        let station = try YBStationModelHelper().parse(json: subJSON)
                        
                        stations.append(station)
                        
                    }
                    catch(let error) { self.printDebug("\(identifier): \(error)", level: .Low) }
                    
                }
                
                let next = json["paging"]["next"].string
                
                success(stations: stations, next: next)
                
            case .Failure(let err):
                
                let error: GetMoreStationsError = .Server(message: err.localizedDescription)
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                failure?(error: error)
                
            }
            
        }
        
        printDebug("\(identifier): [Request]: \(request.debugDescription)", level: .Low)
        
        return request
        
    }
    
}


// MARK: - Comments

extension YBStationManager {
    
    typealias GetCommentsForStationSuccess = (comments: [YBCommentModel], next: String?) -> Void
    typealias GetCommentsForStationFailure = (error: ErrorType) -> Void
    
    enum GetCommentsForStationError: ErrorType { case EmptyStationID, Server(message: String) }
    
    func getCommentsForStation(stationID stationID: String, success: GetCommentsForStationSuccess, failure: GetCommentsForStationFailure?) -> Request? {
        
        let functionName = "getCommentsForStation(stationID:success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
    
        if stationID.isEmpty {
            
            let error: GetCommentsForStationError = .EmptyStationID
            printDebug("\(identifier): \(error)", level: .Medium)
            
            failure?(error: error)
            
            return nil
            
        }
        
        let URLRequest = YBRouter.GetCommentsForStation(stationID: stationID, parameters: nil)
        let request = Alamofire.request(URLRequest).validate().responseData { response in
            
            self.printDebug("\(identifier): [Response]: \(response.response)", level: .Low)
            
            if let statusCode = response.response?.statusCode {
                
                self.printDebug("\(identifier): (\(statusCode)) \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))", level: .High)
                
            }
            
            switch response.result {
            case .Success(let data):
                
                let json = JSON(data: data)
                
                self.printDebug("\(identifier): [Data]: \(json)", level: .Low)
                
                var comments: [YBCommentModel] = []

                for (_, subJSON) in json["data"] {
                    
                    if let comment = try? YBCommentModelHelper().parse(json: subJSON) {
                        
                        comments.append(comment)
                        
                    }
                    
                }
                
                let next = json["paging"]["next"].string

                success(comments: comments, next: next)
                
            case .Failure(let err):
                
                let error: GetCommentsForStationError = .Server(message: err.localizedDescription)
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                failure?(error: error)
                
            }
            
        }
        
        printDebug("\(identifier): [Request]: \(request.debugDescription)", level: .Low)
        
        return request
        
    }
    
    
    typealias GetMoreCommentsForStationSuccess = (comments: [YBCommentModel], next: String?) -> Void
    typealias GetMoreCommentsForStationFailure = (error: ErrorType) -> Void
    
    enum GetMoreCommentsForStationError: ErrorType { case EmptyStationID, EmptyPaging, Server(message: String) }
    
    func getMoreCommentsForStation(stationID stationID: String, paging: String, success: GetCommentsForStationSuccess, failure: GetCommentsForStationFailure?) -> Request? {
        
        let functionName = "getMoreCommentsForStation(stationID:paging:success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        if stationID.isEmpty {
            
            let error: GetMoreCommentsForStationError = .EmptyStationID
            printDebug("\(identifier): \(error)", level: .Medium)
            
            failure?(error: error)
            
            return nil
            
        }
        
        if paging.isEmpty {
            
            let error: GetMoreCommentsForStationError = .EmptyPaging
            printDebug("\(identifier): \(error)", level: .Medium)
            
            failure?(error: error)
            
            return nil
            
        }
        
        let URLRequest = YBRouter.GetCommentsForStation(stationID: stationID, parameters: [ "paging": paging ])
        let request = Alamofire.request(URLRequest).validate().responseData { response in
            
            self.printDebug("\(identifier): [Response]: \(response.response)", level: .Low)
            
            if let statusCode = response.response?.statusCode {
                
                self.printDebug("\(identifier): (\(statusCode)) \(NSHTTPURLResponse.localizedStringForStatusCode(statusCode))", level: .High)
                
            }
            
            switch response.result {
            case .Success(let data):
                
                let json = JSON(data: data)
                
                self.printDebug("\(identifier): [Data]: \(json)", level: .Low)
                
                var comments: [YBCommentModel] = []
                
                for (_, subJSON) in json["data"] {
                    
                    if let comment = try? YBCommentModelHelper().parse(json: subJSON) {
                        
                        comments.append(comment)
                        
                    }
                    
                }
                
                let next = json["paging"]["next"].string
                
                success(comments: comments, next: next)
                
            case .Failure(let err):
                
                let error: GetMoreCommentsForStationError = .Server(message: err.localizedDescription)
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                failure?(error: error)
                
            }
            
        }
        
        printDebug("\(identifier): [Request]: \(request.debugDescription)", level: .Low)
        
        return request
        
    }
    
}
