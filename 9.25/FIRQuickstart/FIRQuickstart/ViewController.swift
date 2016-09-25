//
//  ViewController.swift
//  FIRQuickstart
//
//  Created by 許雅筑 on 2016/9/25.
//  Copyright © 2016年 hsu.ya.chu. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!
    //import database 就會有FIRDatabase
    
    let conditionRef = FIRDatabase.database().reference().child("condition")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        conditionRef.observeEventType(.Value) { (snap:FIRDataSnapshot) in
            self.conditionLabel.text = snap.value?.description
            
        }
    }

    @IBAction func sunnyDidTouch(sender: AnyObject) {
        conditionRef.setValue("Sunny")
    }

    @IBAction func foggyDidTouch(sender: AnyObject) {
        conditionRef.setValue("Foggy")

    }
    
    


}

