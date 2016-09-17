//
//  IntroductionViewController.swift
//  week_2_part_3
//
//  Created by 許雅筑 on 2016/9/8.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit
import SafariServices


class IntroductionViewController: UIViewController,SFSafariViewControllerDelegate {
    var facebookLinkUrl: String = ""
    @IBOutlet weak var headImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-wood")!)
        headImage.layer.borderWidth = 1
        headImage.layer.cornerRadius = headImage.frame.height/2
        headImage.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func lineToFaceBookPage(sender: AnyObject) {
        let Device = UIDevice.currentDevice()
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        print(iosVersion)
        if iosVersion > 9.0{
            let myLogin:LogInFacebookViewController = LogInFacebookViewController()
            facebookLinkUrl = myLogin.userDefault.objectForKey("userLink") as! String
        
            if #available(iOS 9.0, *) {
                let safariVC = SFSafariViewController(URL:NSURL(string: facebookLinkUrl)!, entersReaderIfAvailable: true)
                safariVC.delegate = self
                self.presentViewController(safariVC, animated: true, completion: nil)
        
                func safariViewControllerDidFinish(controller: SFSafariViewController) {
                    controller.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
        }
        else {
//                UIApplication.sharedApplication().openURL(NSURL(string:facebookLinkUrl)!)
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:facebookLinkUrl)!)){
                            UIApplication.sharedApplication().openURL(NSURL(string:facebookLinkUrl)!)
            }

            }
        }


    }



