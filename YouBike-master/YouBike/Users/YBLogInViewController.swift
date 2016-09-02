//
//  YBLogInViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/29.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

class YBLogInViewController: BaseViewController {

    struct Static {
        static let Identifier = "YBLogInViewController"
    }
    
    @IBOutlet private weak var logoLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var facebookContainerView: UIView!
    @IBOutlet private weak var facebookLabel: UILabel!
    
}


// MARK: - View Life Cycle

extension YBLogInViewController {
    
    override func prefersStatusBarHidden() -> Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension YBLogInViewController {
    
    private func setup() {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone: isRotatable = false
        default: isRotatable = true
        }
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-wood")!)
        
        logoLabel.text = YBGlobal.AppName
        logoLabel.textColor = YBColor.Color7
        
        logoImageView.image = UIImage(named: "logo-bike")!.imageWithRenderingMode(.AlwaysTemplate)
        logoImageView.tintColor = YBColor.Color7
        logoImageView.backgroundColor = YBColor.Color1
        logoImageView.layer.cornerRadius = logoImageView.bounds.size.width / 2.0
        logoImageView.layer.borderColor = YBColor.Color7.CGColor
        logoImageView.layer.borderWidth = 1.0
        
        facebookContainerView.backgroundColor = YBColor.Color9
        facebookContainerView.layer.cornerRadius = 10.0
        
        facebookLabel.text = NSLocalizedString("Log in with Facebook", comment: "")
        
    }
    
}


// MARK: - Action

extension YBLogInViewController {
    
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        YBUserManager.sharedManager.logInWithFacebook(
            fromViewController: self,
            success: { user in
                
                let rootViewController = YBAppManager.sharedManager.rootViewController
                
                RHManager.sharedManager.changeRootViewController(
                    viewController: rootViewController,
                    animated: true,
                    success: nil,
                    failure: nil
                )
                
            },
            failure: { [weak self] error in
                
                guard let weakSelf = self else { return }
                
                let alert = UIAlertController(
                    title: NSLocalizedString("Error", comment: ""),
                    message: "\(error)",
                    preferredStyle: .Alert
                )
                
                let ok = UIAlertAction(
                    title: NSLocalizedString("OK", comment: ""),
                    style: .Cancel,
                    handler: nil
                )
                
                alert.addAction(ok)
                
                weakSelf.presentViewController(alert, animated: true, completion: nil)
                
            }
        )
        
    }
    
}


// MARK: - Initializer

extension YBLogInViewController {
    
    class func controller() -> YBLogInViewController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBLogInViewController }
    
}
