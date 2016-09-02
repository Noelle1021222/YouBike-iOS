//
//  YBUserManager.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/2.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import FBSDKLoginKit
import SwiftyJSON

class YBUserManager: BaseManager {

    struct Static {
        static let Identifier = "YBUserManager"
    }
    
    static let sharedManager = YBUserManager()
    
    private(set) var user: YBUserModel? { didSet { userDidSet() } }
    
    var isLoggedIn: Bool { return (user != nil) }
    
    
    // MARK: - Init
    
    private override init() {
        
        super.init()
        setup()
        
    }
    
}


// MARK: - Setup

extension YBUserManager {
    
    private func setup() { restoreUser() }
    
}


// MARK: - Observer

extension YBUserManager {
    
    struct NSUserDefaultsKey {
        static let Identifier = "YBUserManager.NSUserDefaultsKey.Identifier"
        static let Name = "YBUserManager.NSUserDefaultsKey.Name"
        static let Email = "YBUserManager.NSUserDefaultsKey.Email"
        static let ProfileImageURL = "YBUserManager.NSUserDefaultsKey.ProfileImageURL"
        static let FacebookURL = "YBUserManager.NSUserDefaultsKey.FacebookURL"
    }
    
    private func userDidSet() {
        
        if let user = user {
            
            NSUserDefaults.standardUserDefaults().setObject(user.identifier, forKey: NSUserDefaultsKey.Identifier)
            NSUserDefaults.standardUserDefaults().setObject(user.name, forKey: NSUserDefaultsKey.Name)
            
            if let email = user.email {
                
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: NSUserDefaultsKey.Email)
                
            }
            
            if let profileImageURL = user.profileImageURL {
                
                NSUserDefaults.standardUserDefaults().setURL(profileImageURL, forKey: NSUserDefaultsKey.ProfileImageURL)
                
            }
            
            if let facebookURL = user.facebookURL {
                
                NSUserDefaults.standardUserDefaults().setURL(facebookURL, forKey: NSUserDefaultsKey.FacebookURL)
                
            }
            
        }
        else {
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultsKey.Identifier)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultsKey.Name)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultsKey.Email)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultsKey.ProfileImageURL)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(NSUserDefaultsKey.FacebookURL)
            
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
}


// MARK - Restore

extension YBUserManager {
    
    private func restoreUser() {
        
        do { user = try YBUserModelHelper().parse(defaults: NSUserDefaults.standardUserDefaults()) }
        catch { FBSDKLoginManager().logOut() }
        
    }
    
}


// MARK: - Log Out

extension YBUserManager {
    
    func logOut() {
        
        user = nil
        FBSDKLoginManager().logOut()
        
    }
    
}


// MARK: - Facebook

extension YBUserManager {
    
    enum LogInWithFacebookError: ErrorType {
        case FacebookError(error: NSError)
        case NoResult
        case Cancelled
    }
    
    typealias LogInWithFacebookSuccess = (user: YBUserModel) -> Void
    typealias LogInWithFacebookFailure = (error: ErrorType) -> Void
    
    func logInWithFacebook(fromViewController fromViewController: UIViewController, success: LogInWithFacebookSuccess, failure: LogInWithFacebookFailure?) {
        
        let functionName = "logInWithFacebook(fromViewController:success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        let facebook = YBFacebook()
        
        FBSDKLoginManager().logInWithReadPermissions(
            facebook.requiredReadPermissions.map { return $0.rawValue },
            fromViewController: fromViewController,
            handler: { [unowned self] result, fbError in
                
                if fbError != nil {
                    
                    let error: LogInWithFacebookError = .FacebookError(error: fbError)
                    self.printDebug("\(identifier): \(error)", level: .Medium)
                    
                    failure?(error: error)
                    
                    return
                    
                }
                
                if result == nil {
                    
                    let error: LogInWithFacebookError = .NoResult
                    self.printDebug("\(identifier): \(error)", level: .Medium)
                    
                    failure?(error: error)
                    
                    return
                    
                }
                
                if result.isCancelled {
                    
                    let error: LogInWithFacebookError = .Cancelled
                    self.printDebug("\(identifier): \(error)", level: .Medium)
                    
                    failure?(error: error)
                    
                    return
                    
                }
                
                let permissionErrors = facebook.verifyRequiredReadPermissions(grantedPermissions: result.grantedPermissions)
                
                if let error = permissionErrors.first {
                    
                    FBSDKLoginManager().logOut()
                    
                    self.printDebug("\(identifier): \(error)", level: .Medium)
                    
                    failure?(error: error)
                    
                    return
                    
                }
                
                self.getFacebookProfile(
                    success: { json in
                        
                        do {
                            
                            let user = try YBUserModelHelper().parse(json: json)
                            self.user = user
                            
                            success(user: user)
                            
                        }
                        catch(let error) {
                            
                            FBSDKLoginManager().logOut()
                            
                            failure?(error: error)
                            
                        }
                        
                    },
                    failure: { error in
                        
                        FBSDKLoginManager().logOut()
                        
                        failure?(error: error)
                    
                    }
                )
                
            }
        )
        
    }
    
    enum GetFacebookProfileError: ErrorType {
        case FacebookError(error: NSError)
        case NoAccessToken
    }
    
    typealias GetFacebookProfileSuccess = (json: JSON) -> Void
    typealias GetFacebookProfileFailure = (error: ErrorType) -> Void
    
    func getFacebookProfile(success success: GetFacebookProfileSuccess, failure: GetFacebookProfileFailure?) {
        
        let functionName = "getFacebookProfile(success:failure:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        guard let _ = FBSDKAccessToken.currentAccessToken() else {
            
            FBSDKLoginManager().logOut()
            
            let error: GetFacebookProfileError = .NoAccessToken
            self.printDebug("\(identifier): \(error)", level: .Medium)
            
            failure?(error: error)
            
            return
            
        }
        
        FBSDKGraphRequest(
            graphPath: "me",
            parameters: [ "fields": "name, picture.type(large), link, email" ]
        )
        .startWithCompletionHandler { _, result, fbError in
            
            if fbError != nil {
                
                let error: GetFacebookProfileError = .FacebookError(error: fbError)
                self.printDebug("\(identifier): \(error)", level: .Medium)
                
                failure?(error: error)
                
                return
                
            }
            
            success(json: JSON(result))
            
        }
        
    }
    
}
