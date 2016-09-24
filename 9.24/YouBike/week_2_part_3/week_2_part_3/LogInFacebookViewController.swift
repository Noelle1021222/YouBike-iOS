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
import Firebase
import FirebaseAuth
//import LoadFacebookProfileKit

class LogInFacebookViewController: UIViewController {
    //for firebase
    private let dataURL = "https://youbike-2c47f.firebaseio.com"
    
    //當我按facebook button 我firebase上面就會更新一筆score
    let conditionRef = FIRDatabase.database().reference().child("user").child("score")

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
        //登入的NSLocalizedString

        logButton.setTitle(NSLocalizedString("login", comment: "Title for sound on"), forState: UIControlState.Normal)
        print(NSLocalizedString("test",comment:"defalue"))
        super.viewDidLoad()
        //background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-wood")!)
        
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        conditionRef.observeEventType(.Value){(snap:FIRDataSnapshot) in
        // if I want to print out the high score 
//        self.conditionLabel.text = snap.value?description
        }
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
            case .Success(let grantedPermissions, _, _):
                if grantedPermissions.contains("email")
                {
                    self.returnUserData()
                }
                
                print("Logged in!")
                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController

                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = protectedPage
                //LogInFacebookViewController 會被記憶體釋放
                
                
            }
        }
    }
    //firebase
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential, completion: {(user,error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            print("User logged in with facebook")
        })
        let facebookLogin = FBSDKLoginManager()
        print("logging In")
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled { print("Facebook login was cancelled.")
            } else { print("You’re inz ;)")
                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = protectedPage}
        });
     
        //write data
        
        // Write data to Firebase
        //another type
        conditionRef.setValue("3")

        
    }
    
    //retrieve
    func returnUserData()
    {
        var dict : NSDictionary!

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,link,picture.width(150).height(150)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {

                print("Error: \(error)")
            }
            else
            {
                var myImageURL:String = ""
                print("fetched user: \(result)")
                dict = result as! NSDictionary
                self.userDefault.setObject(result.valueForKey("name"),forKey: "userName")
                
                self.userDefault.setObject(result.valueForKey("link"),forKey: "userLink")

                self.userDefault.setObject(result.valueForKey("email"),forKey: "userEmail")

                if let imageURL = dict.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                    myImageURL = imageURL
                }
                //已解析
                self.userDefault.setObject(myImageURL,forKey: "userPictureURL")
                
//                self.userDefault.synchronize()
                self.userName = self.userDefault.objectForKey("userName") as! String
                self.userPictureURL = self.userDefault.objectForKey("userPictureURL") as! String
                self.userLink = self.userDefault.objectForKey("userLink") as! String
                self.userEmail = self.userDefault.objectForKey("userEmail") as! String
                self.userPictureURL = self.userDefault.objectForKey("userPictureURL") as! String

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
