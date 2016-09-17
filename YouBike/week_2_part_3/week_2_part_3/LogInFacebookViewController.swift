//
//  LogInFacebookViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/9/6.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
//import LoadFacebookProfileKit

class LogInFacebookViewController: UIViewController {
    
    //供外部存取
    var userName: String = ""
    var userEmail: String = ""
    var userLink: String = ""
    var userID: String = ""
    var userPictureURL: String = ""
    var userDefault = NSUserDefaults.standardUserDefaults()



    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var bikeImage: UIImageView!
    
    var userProfile: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background
        view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-wood")!)
        
        bikeImage.layer.borderWidth = 1
        bikeImage.layer.masksToBounds = false
        bikeImage.layer.borderColor = UIColor(red: 61/255, green: 52/255, blue: 66/255, alpha: 1).CGColor
        bikeImage.layer.cornerRadius = bikeImage.frame.height/2
        bikeImage.layer.backgroundColor = UIColor(red: 254/255, green: 241/255, blue: 220/255, alpha: 1).CGColor
        bikeImage.clipsToBounds = true
        
        //圓角
        logInView.layer.cornerRadius = 10
        
        
        logButton.addTarget(self, action: #selector(self.loginButtonClicked), forControlEvents: .TouchUpInside)
        //part4
        

    }
    
    //點擊login
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .PublicProfile,.Email ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error):
                print(error)
            case .Cancelled:
                print("User cancelled login.")
            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
                if grantedPermissions.contains("email")
                {
                    self.returnUserData()
                }
                print("Logged in!")
                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController

                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = protectedPage

                
                
            }
        }
    }
    //retrieve
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,link"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")

                self.userDefault.setObject(result.valueForKey("name"),forKey: "userName")
                
                self.userDefault.setObject(result.valueForKey("link"),forKey: "userLink")

                self.userDefault.setObject(result.valueForKey("email"),forKey: "userEmail")
                
                self.userDefault.setObject(result.valueForKey("id"),forKey: "userID")
                
                self.userDefault.setObject("https://graph.facebook.com/\(self.userID)/picture?type=large&return_ssl_resources=1",forKey: "userPictureURL")
                
                self.userDefault.synchronize()
                self.userName = self.userDefault.objectForKey("userName") as! String
                self.userPictureURL = self.userDefault.objectForKey("userPictureURL") as! String
                self.userLink = self.userDefault.objectForKey("userLink") as! String
                self.userEmail = self.userDefault.objectForKey("userEmail") as! String

                print("name:\(self.userName)")
                print("picture url:\(self.userPictureURL)")
                print("user link:\(self.userLink)")
                print("user mail: \(self.userEmail)")

            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
