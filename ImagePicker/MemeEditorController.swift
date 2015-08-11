//
//  ViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/22/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var TopText: UITextField!
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var TopNavBar: UINavigationBar!
    @IBOutlet weak var BottomToolBar: UIToolbar!
    
    var memedImage = UIImage()
    var keyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        
        //Set the TopText and BottomText formatting
        TopText.defaultTextAttributes = memeTextAttributes
        TopText.textAlignment = NSTextAlignment.Center
        BottomText.defaultTextAttributes = memeTextAttributes
        BottomText.textAlignment = NSTextAlignment.Center
        self.TopText.delegate=self
        self.BottomText.delegate = self

        ShareButton.enabled = false
        self.subscribeToKeyboardNotifications()
    }
    
    //Check if camera button should be enabled and subscribe to keyboard notification
    override func viewWillAppear(animated: Bool) {
        CameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    //Unsubscribe to keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //Display ActivityViewController
    @IBAction func shareMeme(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarViewController") as! UITabBarController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    //Select image from camera
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        ShareButton.enabled = true
       
    }
    //Select image from photo library
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Select image and dismiss the image picker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.image = pickedImage
            dismissViewControllerAnimated(true, completion: nil)
        }
        ShareButton.enabled = true
    }
    
    //Dismiss the image picker controller if cancel is selected
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Remove the placeholder text when starting to add text
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Determine if the keyboard will display
    if it's the bottem text, move display up to show the textbox. **/
    func keyboardWillShow(notification: NSNotification) {
        if BottomText.isFirstResponder() {
        if(keyboardHidden){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardHidden = false
        }
        }
    }
    /**
    Determine if the keyboard will hide
    if it's the bottem text, move display down to it's original location. **/
    func keyboardWillHide(notification: NSNotification) {
        if BottomText.isFirstResponder() {
            if(!keyboardHidden){
                self.view.frame.origin.y += getKeyboardHeight(notification)
                keyboardHidden = true
            }
        }
    }
    
    //Figure out the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        //Hide the toolbar and navigation bar
        hideNavigationAndToolBar(true)
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Unhide the toolbar and navigation bar
        hideNavigationAndToolBar(false)
        
        return memedImage
    }
    
    //Save the meme image
    func save() {
        var meme = Meme( topText: TopText.text!, bottomText: BottomText.text!, withImage: ImagePickerView.image!, memeImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func cancelEditor(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //Hides or displays the navigation bar or toolbar
    func hideNavigationAndToolBar(hide: Bool){
        BottomToolBar.hidden = hide
        TopNavBar.hidden = hide
    }
    
}

