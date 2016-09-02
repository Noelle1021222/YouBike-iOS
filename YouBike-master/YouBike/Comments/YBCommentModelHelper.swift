//
//  YBCommentModelHelper.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/6.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import SwiftyJSON

struct YBCommentModelHelper { }


// MARK: - JSONParsable

extension YBCommentModelHelper: JSONParsable {
    
    struct JSONKey {
        static let Identifier = "id"
        static let Text = "text"
        static let User = "user"
        static let createdDate = "created"
    }
    
    enum JSONError: ErrorType { case MissingIdentifier, InvalidCreatedDate }
    
    func parse(json json: JSON) throws -> YBCommentModel {
        
        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        let text = json[JSONKey.Text].stringValue
        
        let user: YBUserModel!
        
        do { user = try YBUserModelHelper().parse(json: json[JSONKey.User]) }
        catch(let error) { throw error }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = YBDate.DateFormat
        dateFormatter.timeZone = YBDate.TimeZone
        
        let createdDateString = json[JSONKey.createdDate].stringValue
        guard let createdDate = dateFormatter.dateFromString(createdDateString) else { throw JSONError.InvalidCreatedDate }
        
        return YBCommentModel(
            identifier: identifier,
            text: text,
            user: user,
            createdDate: createdDate
        )
        
    }
    
}
