//
//  YBJSONHelper.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/26.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

struct YBJSONHelper {
    
    enum LoadJSONError: ErrorType { case FileNotFound, InvalidFile }
    
    func loadJSON(name name: String) throws -> AnyObject {
        
        guard let jsonPath = NSBundle.mainBundle().pathForResource(name, ofType: "json") else { throw LoadJSONError.FileNotFound }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else { throw LoadJSONError.InvalidFile }
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
            
            return json
            
        }
        catch(let error) { throw error }
        
    }
    
}
