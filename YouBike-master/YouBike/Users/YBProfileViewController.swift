//
//  YBProfileViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/28.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import SafariServices
import SDWebImage

class YBProfileViewController: BaseViewController {

    struct Static {
        static let Identifier = "YBProfileViewController"
        static let Title = NSLocalizedString("Profile", comment: "")
    }
    
    @IBOutlet private weak var cardView: UIView!
    
    private let cardViewRoundedLayer = CAShapeLayer()
    private let cardShadowView = UIView()
    private let cardShadowViewShadowLayer = CAShapeLayer()
    
    @IBOutlet private weak var profileHeaderBackgroundImageView: UIImageView!
    @IBOutlet private weak var profileImageBorderView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var facebookLinkContainerView: UIView!
    @IBOutlet private weak var facebookLinkLabel: UILabel!
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCardView()
    }
    
}


// MARK: - Setup

extension YBProfileViewController {
    
    private func setup() {
        
        navigationItem.title = Static.Title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Log Out", comment: ""),
            style: .Plain,
            target: self,
            action: #selector(logOut(_:))
        )
    
        view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-wood")!)
        
        cardView.backgroundColor = YBColor.Color1
        
        view.insertSubview(cardShadowView, belowSubview: cardView)
        
        profileHeaderBackgroundImageView.image = UIImage(named: "background-profile")!
        
        profileImageBorderView.layer.cornerRadius = profileImageBorderView.bounds.size.width / 2.0
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        
        nameLabel.text = ""
        nameLabel.textColor = YBColor.Color7
        
        facebookLinkContainerView.backgroundColor = YBColor.Color9
        facebookLinkContainerView.layer.cornerRadius = 10.0
        
        facebookLinkLabel.text = NSLocalizedString("FaceBook Page", comment: "")
        
        setupUser()
        
    }
    
    private func setupCardView() {
        
        cardViewRoundedLayer.removeFromSuperlayer()
        cardShadowViewShadowLayer.removeFromSuperlayer()
        
        let roundedPath = UIBezierPath(
            roundedRect: cardView.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight ],
            cornerRadii: CGSize(width: 20.0, height: 20.0)
        )
        
        cardViewRoundedLayer.path = roundedPath.CGPath
        cardView.layer.mask = cardViewRoundedLayer
        
        // Create shadow view for card view.
        cardShadowView.frame = cardView.frame
        
        cardShadowViewShadowLayer.frame = cardShadowView.bounds
        cardShadowViewShadowLayer.path = roundedPath.CGPath
        cardShadowViewShadowLayer.shadowRadius = 2.0
        cardShadowViewShadowLayer.shadowOpacity = 0.2
        cardShadowViewShadowLayer.shadowColor = UIColor.blackColor().CGColor
        cardShadowViewShadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)

        cardShadowView.layer.insertSublayer(cardShadowViewShadowLayer, atIndex: 0)

    }
    
    private func setupUser() {
        
        guard let user = YBUserManager.sharedManager.user else { return }
        
        nameLabel.text = user.name
        
        if let profileImageURL = user.profileImageURL {
            
            profileImageView.sd_setImageWithURL(profileImageURL, placeholderImage: nil, options: .RefreshCached)
            
        }
        
    }
    
}


// MAKR: - Action

extension YBProfileViewController {
    
    @IBAction func goToFacebookProfilePage(sender: AnyObject) {
    
        guard let facebookURL = YBUserManager.sharedManager.user?.facebookURL else { return }
        
        if #available(iOS 9.0, *) {
            
            let safariViewController = SFSafariViewController(URL: facebookURL)
            
            presentViewController(safariViewController, animated: true, completion: nil)
            
        }
        else { UIApplication.sharedApplication().openURL(facebookURL) }
    
    }
    
    @objc private func logOut(sender: AnyObject?) {
        
        YBUserManager.sharedManager.logOut()
        
        let rootViewController = YBAppManager.sharedManager.rootViewController
        
        RHManager.sharedManager.changeRootViewController(
            viewController: rootViewController,
            animated: true,
            success: nil,
            failure: nil
        )
        
    }
    
}


// MARK: - Initializer

extension YBProfileViewController {
    
    class func controller() -> YBProfileViewController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBProfileViewController }
    
}
