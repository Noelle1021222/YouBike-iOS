//
//  EditPhotoViewController.swift
//  Photo
//
//  Created by 許雅筑 on 2016/9/19.
//  Copyright © 2016年 hsu.ya.chu. All rights reserved.
//

import UIKit



protocol EditDataEnteredDelegate {
    func userEditEnterInformation(infoTopic:NSString,infoDescription:NSString,infoPicture:UIImage)
}

class EditPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //負責接收
    var editTranferPicture:UIImage?
    var editTranferTopic:String = ""
    var editTranferDescription:String = ""    
    
        @IBOutlet var editImageView: UIImageView!
    let imagePicker = UIImagePickerController()

    @IBOutlet var editSave: UIButton!
    @IBOutlet var editTopicTextField: UITextField! = UITextField()
    
    @IBOutlet var editDescriptionTextField: UITextView! = UITextView()
    var delegate:EditDataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        editImageView.image = editTranferPicture
        editTopicTextField.text = editTranferTopic
        editDescriptionTextField.text = editTranferDescription

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EditPhotoViewController.imageTapped(_:)))
        editImageView!.userInteractionEnabled = true
        editImageView!.addGestureRecognizer(tapGestureRecognizer)

        
        
    }
    
    func imageTapped(img: AnyObject)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            editImageView.contentMode = .ScaleAspectFit
            editImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveData(sender: AnyObject) {
        if (delegate != nil){
            let information:NSString = editTopicTextField.text!
            
            let descriptionInformation:NSString = editDescriptionTextField.text
            
            delegate!.userEditEnterInformation(information,infoDescription: descriptionInformation,infoPicture:editImageView.image!)
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
