//
//  NewPhotoViewController.swift
//  Photo
//
//  Created by 許雅筑 on 2016/9/19.
//  Copyright © 2016年 hsu.ya.chu. All rights reserved.
//

import UIKit
protocol DataEnteredDelegate {
    func userDidEnterInformation(infoTopic:NSString,infoDescription:NSString,infoPicture:UIImage)
}

class NewPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var imageview: UIImageView!
    let imagePicker = UIImagePickerController()

    
    @IBOutlet var save: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var topicTextField: UITextField! = UITextField()
    @IBOutlet var descriptionTextField: UITextView! = UITextView()
    
    var delegate:DataEnteredDelegate? = nil
    
    @IBAction func loadImageButton(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewPhotoViewController.imageTapped(_:)))
        imageview!.userInteractionEnabled = true
        imageview!.addGestureRecognizer(tapGestureRecognizer)

    }
    func imageTapped(img: AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageview.contentMode = .ScaleAspectFit
            imageview.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveData(sender: AnyObject) {
        if (delegate != nil){
            let information:NSString = topicTextField.text!
            
            let descriptionInformation:NSString = descriptionTextField.text
            delegate!.userDidEnterInformation(information,infoDescription: descriptionInformation,infoPicture:imageview.image!)
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }



}
