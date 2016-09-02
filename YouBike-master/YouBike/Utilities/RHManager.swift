//
//  RHManager.swift
//  RoyHsu
//
//  Created by Roy Hsu on 2015/8/11.
//  Copyright (c) 2015年 Roy Hsu. All rights reserved.
//

import UIKit
import AVFoundation

class RHManager: BaseManager {
    
    struct Static {
        static let Identifier = "RHManager"
    }
    
    static let sharedManager = RHManager()
    
    
    // MARK: - Init
    
    private override init() {
        super.init()
        setup()
    }
    
}


// MARK: - Setup

extension RHManager {
    
    private func setup() { }
    
}


// MARK: - Root View Controller

extension RHManager {
    
    var rootViewController: UIViewController? {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let viewController = appDelegate?.window?.rootViewController
        
        return viewController
    }
    
    typealias ChangeRootViewControllerSuccess = () -> Void
    typealias ChangeRootViewControllerFailure = (error: ErrorType) -> Void
    
    enum ChangeRootViewControllerError: ErrorType {
        case NoWindow
    }
    
    func changeRootViewController(viewController viewController: UIViewController, animated: Bool, success: ChangeRootViewControllerSuccess?, failure: ChangeRootViewControllerFailure?) {
        
        let functionName = "changeRootViewController(viewController:animated:)"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            
            if animated {
                
                if let currentRootViewController = window?.rootViewController {
                    
                    let snapshotView = currentRootViewController.view.snapshotViewAfterScreenUpdates(true)
                    viewController.view.addSubview(snapshotView)
                    window?.rootViewController = viewController
                    
                    UIView.animateWithDuration(
                        1.0,
                        animations: { snapshotView.layer.opacity = 0.0 },
                        completion: { _ in
                            snapshotView.removeFromSuperview()
                            success?()
                        }
                    )
                    
                }
                else {
                    window?.rootViewController = viewController
                    success?()
                }
                
            }
            else {
                window?.rootViewController = viewController
                success?()
            }
            
        }
        else {
            let error: ChangeRootViewControllerError = .NoWindow
            failure?(error: error)
            printDebug("\(identifier): \(error)", level: .Medium)
        }
        
    }
    
}


// MARK: - Other

extension RHManager {
    
    typealias DelayCompletion = () -> Void
    
    func delay(timeInterval: Double, completion: DelayCompletion) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(timeInterval * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            completion
        )
        
    }
    
}


// MARK: - String

extension String {
    
    func validURLString() -> String? {
        
        guard let encodedString = stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else { return nil }
        
        if encodedString.isEmpty { return nil }
        
        let length = (self as NSString).length
        let range = NSMakeRange(0, length)
        let types: UInt64 = NSTextCheckingType.Link.rawValue
        guard let dataDetector = try? NSDataDetector(types: types) else { return nil }
        guard let result = dataDetector.firstMatchInString(encodedString, options: .ReportCompletion, range: range) else { return nil }
        
        return result.URL?.absoluteString
        
    }
    
}


// MARK: - NSDate

extension NSDate {
    
    func daysFromDate(date: NSDate) -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: self, toDate: date, options: [])
        
        return components.day
        
    }
    
}


// MARK: - NSURL

extension NSURL {
    
    var parameters: [String: AnyObject] {
        
        var parameters = [String: AnyObject]()
        let parametersQuery = query?.componentsSeparatedByString("?").last
        
        if let pairs = parametersQuery?.componentsSeparatedByString("&") {
            
            for pair in pairs {
                
                let components = pair.componentsSeparatedByString("=")
                
                if let key = components.first,
                    let value = components.last?.stringByRemovingPercentEncoding {
                    parameters[key] = value
                }
                
            }
            
        }
        
        return parameters
        
    }
    
}


// MARK: - UIView

extension UIView {
    
    class func loadFromNibNamed(nibNamed: String) -> UIView? {
        
        return UINib(nibName: nibNamed, bundle: nil).instantiateWithOwner(nil, options: nil).first as? UIView
        
    }
    
    func croppedView(visibleRect visibleRect: CGRect) throws -> UIView {
        
        do {
            
            let contentView = try snapshotImageView()
            
            let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: visibleRect.size.width, height: visibleRect.size.height))
            scrollView.contentSize = contentView.bounds.size
            scrollView.addSubview(contentView)
            scrollView.contentOffset = visibleRect.origin
            scrollView.userInteractionEnabled = false
            
            return scrollView
            
        }
        catch(let error) { throw error }
        
    }
    
    enum SnapshotImageViewError: ErrorType { case NoCurrentContext }
    
    func snapshotImageView(scale scale: CGFloat = 0.0) throws -> UIImageView {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { throw SnapshotImageViewError.NoCurrentContext }
        
        layer.renderInContext(context)
        
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(frame: frame)
        imageView.image = snapshotImage
        
        return imageView
        
    }
    
}


// MARK: - UIImage

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        
        if let imageData1 = UIImagePNGRepresentation(self),
            let imageData2 = UIImagePNGRepresentation(image) {
                
                return imageData1.isEqualToData(imageData2)
                
        }
        
        return false
        
    }
    
    struct ThumbnailImage {
        static let Size = CGSize(width: 180.0, height: 180.0)
        static let Rect = CGRect(origin: CGPointZero, size: Size)
    }
    
    var thumbnailImage: UIImage {
        
        let rect = AVMakeRectWithAspectRatioInsideRect(size, ThumbnailImage.Rect)
        
        UIGraphicsBeginImageContextWithOptions(ThumbnailImage.Size, false, scale)
        
        drawInRect(rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage
        
    }
    
}

extension UILabel {
    
    var isTruncated: Bool {
        
        guard let text = text else { return false }
        
        let size = CGSize(width: bounds.size.width, height: CGFloat.max)
        let sizeOfText = NSString(string: text).boundingRectWithSize(
            size,
            options: [ .UsesLineFragmentOrigin ],
            attributes: [ NSFontAttributeName: font ],
            context: nil)
            .size
        
        let lines = Int(ceil(sizeOfText.height / font.lineHeight))
        
        return numberOfLines < lines
        
    }
    
}


// MARK: - Device Token

extension RHManager {
    
    func deviceTokenString(deviceToken deviceToken: NSData) -> String? {
        
        let deviceTokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var deviceTokenString = ""
        
        for i in 0..<deviceToken.length { deviceTokenString += String(format: "%02.2hhx", arguments: [deviceTokenChars[i]]) }
        
        return deviceTokenString.isEmpty ? nil : deviceTokenString
        
    }
    
}


// MARK: - UIDevice

extension UIDevice {
    
    var modelName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
            
        }
        
        return identifier
        
    }
    
}


// MARK: - UINavigationController
// Reference: http://stackoverflow.com/questions/9906966/completion-handler-for-uinavigationcontroller-pushviewcontrolleranimated
extension UINavigationController {
    
    func pushViewController(viewController: UIViewController, animated: Bool, completion: () -> Void) {
        
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator() else {
            
            completion()
            
            return
            
        }
        
        coordinator.animateAlongsideTransition(
            { _ in viewController.setNeedsStatusBarAppearanceUpdate() },
            completion: { _ in completion() }
        )
        
    }
    
}
