//
//  ViewController.swift
//  week_1_part_13_v_2
//
//  Created by 許雅筑 on 2016/8/19.
//  Copyright © 2016年 許雅筑. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstView:UIView = UIView(frame: CGRect(x:100,y:100,width:375*0.75,height:120*0.75))
        firstView.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 214/255, alpha: 1)
        self.view.addSubview(firstView)

        
        /**************************/

        
        let roadLabel: UILabel = UILabel(frame: CGRectMake(100+10*0.75,100+42*0.75,157*0.75,20*0.75))
        roadLabel.text = "忠孝東路/松仁路(東南側)"
        roadLabel.font = UIFont(name: "PingFangTC-Regular", size: 14)
        roadLabel.textColor = UIColor(red: 211/255, green: 150/255, blue: 104/255, alpha: 1)
        roadLabel.textAlignment = NSTextAlignment.Center
        
        //不會truncated
        roadLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(roadLabel)
        /***************************/
        let busStopLabel: UILabel = UILabel(frame: CGRectMake(100+52*0.75,100+10*0.75,303*0.75,28*0.75))

        busStopLabel.text = "信義區 / 捷運市府站（3號出口）"
        busStopLabel.font = UIFont.boldSystemFontOfSize(20)
        busStopLabel.textColor = UIColor(red: 160/255, green: 98/255, blue: 90/255, alpha: 1)
        // 文字對齊方式為：中央對齊
        busStopLabel.textAlignment = NSTextAlignment.Center
        
        busStopLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(busStopLabel)
        
        /**************************/
        
        let myImageView = UIImageView(
            frame: CGRect(x:100+17*0.75, y: 100+9*0.75, width: 30*0.75, height: 30*0.75))

        let tintedImage = UIImage(named:"icon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        myImageView.image = tintedImage
        myImageView.tintColor = UIColor(red: 160/255, green: 98/255, blue: 90/255, alpha: 1)
        self.view.addSubview(myImageView)
        /**************************/
        
    
        let hasLabel: UILabel = UILabel(frame: CGRectMake(100+206*0.75,100+78*0.75,20*0.75,28*0.75))
        hasLabel.text = "剩"
        hasLabel.font = UIFont.boldSystemFontOfSize(20)
        hasLabel.textColor = UIColor(red: 211/255, green: 150/255, blue: 104/255, alpha: 1)
        hasLabel.textAlignment = NSTextAlignment.Center
        hasLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(hasLabel)
        
        /**************************/
        
        let taiLabel: UILabel = UILabel(frame: CGRectMake(100+335*0.75,100+78*0.75,20*0.75,28*0.75))
        taiLabel.text = "台"
        taiLabel.font = UIFont.boldSystemFontOfSize(20)
        taiLabel.textColor = UIColor(red: 211/255, green: 150/255, blue: 104/255, alpha: 1)
        taiLabel.textAlignment = NSTextAlignment.Center
        taiLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(taiLabel)
        
        /**************************/
        
        let numberLabel: UILabel = UILabel(frame: CGRectMake(100+230*0.75,100+24*0.75,101*0.75,96*0.75))
        numberLabel.text = "20"
        numberLabel.font = UIFont(name: "Helvetica-Bold", size: 80)
        numberLabel.textColor = UIColor(red: 204/255, green: 113/255, blue: 93/255, alpha: 1)
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(numberLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

