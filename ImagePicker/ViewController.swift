//
//  ViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/22/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var TopText: UITextField!
    @IBOutlet weak var BottomText: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor() ,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TopText.defaultTextAttributes = memeTextAttributes
        TopText.placeholder = "Top Text"
        TopText.textAlignment = NSTextAlignment.Center
        
        
        BottomText.defaultTextAttributes = memeTextAttributes
        BottomText.placeholder = "Bottom Text"
        BottomText.textAlignment = NSTextAlignment.Center
       
        
        self.TopText.delegate=self
        self.BottomText.delegate = self
        
        self.subscribeToKeyboardNotifications()
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        CameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func pickAnImage(sender: AnyObject) {
        // let pickController = UIImagePickerController()
        // self.presentViewController(pickController, animated: true, completion: nil)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.contentMode = .ScaleAspectFit
            ImagePickerView.image = pickedImage
             dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
         textField.placeholder = nil;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if BottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if BottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func save() {
        //Create the meme
        //var meme = Meme( topText: TopText.text!, bottomText: BottomText.text!, originalImage: ImagePickerView.image, memeImage: memeImage)
    }
    
   
    
    
}

