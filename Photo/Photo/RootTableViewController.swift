//
//  RootTableViewController.swift
//  Photo
//
//  Created by 許雅筑 on 2016/9/19.
//  Copyright © 2016年 hsu.ya.chu. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController,DataEnteredDelegate,EditDataEnteredDelegate {


    
    struct everyPhoto {
        var topic:String? = ""
        var description:String? = ""
        var picture : UIImage?
        
    }
    
    var photosArray :[everyPhoto] = []
    var throwToEditPhoto: UIImage? = nil
    
//    @IBAction func save(segue:UIStoryboardSegue) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tableView.reloadData()
//            
//        })
//        
//    }
    @IBAction func editSave(segue:UIStoryboardSegue) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
        })
        
    }
    
    var chooseIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "myJournalsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        var everyPhoto1 = everyPhoto()
        everyPhoto1.picture = UIImage(named:"crossmap")
        everyPhoto1.topic = "test"
        photosArray.append(everyPhoto1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    func userDidEnterInformation(infoTopic: NSString,infoDescription: NSString,infoPicture:UIImage) {
    var photoObject = everyPhoto()
        photoObject.topic = infoTopic as String
        photoObject.description = infoDescription as String
        photoObject.picture = infoPicture
        
        self.photosArray.append(photoObject)
        print(photosArray)

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
        })

    }
    func userEditEnterInformation(infoTopic: NSString,infoDescription: NSString,infoPicture:UIImage) {
        var photoObject = everyPhoto()
        photoObject.topic = infoTopic as String
        photoObject.description = infoDescription as String
        photoObject.picture = infoPicture
        self.photosArray.removeAtIndex(chooseIndex)
        print("-------------------------")
        print(photosArray)
        self.photosArray.insert(photoObject, atIndex: chooseIndex)
//        self.photosArray.append(photoObject)
//        print(photosArray)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
        })
    
    }
    

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photosArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cellIdentifier = "Cell"
        let cell: myJournalsCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! myJournalsCell
        cell.beautifulPhoto?.image = photosArray[indexPath.row].picture
        throwToEditPhoto = photosArray[indexPath.row].picture
        cell.beautifulPhotoTopic?.text = photosArray[indexPath.row].topic
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(RootTableViewController.imageTapped(_:)))
//        cell.beautifulPhoto!.userInteractionEnabled = true
//        cell.beautifulPhoto!.addGestureRecognizer(tapGestureRecognizer)

//        cell.mapButton.addTarget(self, action: #selector(ViewController.MapBtnClicked), forControlEvents: .TouchUpInside)
        
        return cell

    }
    
    var tranferTopic = ""
    var tranferDescription = ""
    var tranferPicture:UIImage? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tranferTopic = photosArray[indexPath.row].topic!
        tranferDescription = photosArray[indexPath.row].description!
        tranferPicture = photosArray[indexPath.row].picture
        self.performSegueWithIdentifier("editPhoto", sender:self)
        
        chooseIndex = indexPath.row
        print(chooseIndex)

    }
    
//    func imageTapped(img: AnyObject)
//    {
//        
//        self.performSegueWithIdentifier("editPhoto", sender:self)
//
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "showNewPhoto" {
            let destinationViewController = segue.destinationViewController as? NewPhotoViewController
            destinationViewController!.delegate = self
        }
        else if segue.identifier == "editPhoto" {
            let destinationViewController = segue.destinationViewController as? EditPhotoViewController

            destinationViewController!.editTranferPicture = tranferPicture
            destinationViewController!.editTranferTopic = tranferTopic
            destinationViewController!.editTranferDescription = tranferDescription
            destinationViewController!.delegate = self
        }
        
    }



}
