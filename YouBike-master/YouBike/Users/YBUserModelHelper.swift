//
//  YBUserModelHelper.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import SwiftyJSON

struct YBUserModelHelper { }


// MARK: - JSONParsable

extension YBUserModelHelper: JSONParsable {
    
    struct JSONKey {
        static let Identifier = "id"
        static let Name = "name"
        static let Email = "email"
        static let ProfileImageURL = "picture"
        static let FacebookURL = "link"
    }
    
    enum JSONError: ErrorType { case MissingIdentifier, InvalidName }
    
    func parse(json json: JSON) throws -> YBUserModel {
        
        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        guard let name = json[JSONKey.Name].string where !name.isEmpty else { throw JSONError.InvalidName }
        
        let user = YBUserModel(identifier: identifier, name: name)
        
        user.email = json[JSONKey.Email].string
        
        if let profileImageURLString = json[JSONKey.ProfileImageURL]["data"]["url"].string {
            
           user.profileImageURL = NSURL(string: profileImageURLString)
            
        }
        else if let profileImageURLString = json[JSONKey.ProfileImageURL].string {
            
            user.profileImageURL = NSURL(string: profileImageURLString)
            
        }
        
        if let facebookURLString = json[JSONKey.FacebookURL].string {
            
            user.facebookURL = NSURL(string: facebookURLString)
            
        }
        
        return user
        
    }
    
}


// MARK: - NSUserDefaultsParsable

extension YBUserModelHelper: NSUserDefaultsParsable {
    
    typealias NSUserDefaultsKey = YBUserManager.NSUserDefaultsKey
    
    enum NSUserDefaultsError: ErrorType { case MissingIdentifier, MissingName, MissingEmail }
    
    func parse(defaults defaults: NSUserDefaults) throws -> YBUserModel {
        
        guard let identifier = defaults.stringForKey(NSUserDefaultsKey.Identifier) else { throw NSUserDefaultsError.MissingIdentifier }
        
        guard let name = defaults.stringForKey(NSUserDefaultsKey.Name) where !name.isEmpty else { throw NSUserDefaultsError.MissingName }
        
        guard let email = defaults.stringForKey(NSUserDefaultsKey.Email) where !email.isEmpty else { throw NSUserDefaultsError.MissingEmail }
        
        let user = YBUserModel(identifier: identifier, name: name)
        
        user.email = email
        
        user.profileImageURL = defaults.URLForKey(NSUserDefaultsKey.ProfileImageURL)
        
        user.facebookURL = defaults.URLForKey(NSUserDefaultsKey.FacebookURL)
        
        return user
        
    }
    
}
