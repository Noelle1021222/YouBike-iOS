//
//  YBFacebook.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import Foundation

struct YBFacebook: Facebook {
    
    var requiredReadPermissions: [FacebookPermission] { return [ .PublicProfile, .Email ] }
    
}


// MARK: - Validation

extension YBFacebook {
    
    enum VerifyPermissionsError: ErrorType {
        case PermissionRequired(permission: FacebookPermission)
    }
    
    func verifyPermissions(permissions: [FacebookPermission], grantedPermissions: Set<NSObject>) -> [ErrorType] {
        
        var errors: [ErrorType] = []
        
        for permission in permissions {
            
            if !grantedPermissions.contains(permission.rawValue) {
                
                let error: VerifyPermissionsError = .PermissionRequired(permission: permission)
                errors.append(error)
                
            }
            
        }
        
        return errors
        
    }
    
    func verifyRequiredReadPermissions(grantedPermissions grantedPermissions: Set<NSObject>) -> [ErrorType] { return verifyPermissions(requiredReadPermissions, grantedPermissions: grantedPermissions) }
    
}
