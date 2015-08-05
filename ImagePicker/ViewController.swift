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
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    
    
    var memedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        
        TopText.defaultTextAttributes = memeTextAttributes
        TopText.textAlignment = NSTextAlignment.Center
        
        
        BottomText.defaultTextAttributes = memeTextAttributes
        BottomText.textAlignment = NSTextAlignment.Center
       
        ShareButton.enabled = false
        
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
    
    @IBAction func shareMeme(sender: AnyObject) {
                
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            
            let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
         //    //Reset Editor View.
            //let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
           // applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
           
        //}
        
        
        

    }

    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        ShareButton.enabled = true
       
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
        ShareButton.enabled = true
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
    
    
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    func save() {
        //Create the memed
        var meme = Meme( topText: TopText.text!, bottomText: BottomText.text!, withImage: ImagePickerView.image!, memeImage: generateMemedImage())
     
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    

    
   
    
    
}

