//
//  ViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/22/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
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
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        topText.delegate=self
        bottomText.delegate = self

        shareButton.enabled = false
    }
    
    //Check if camera button should be enabled and subscribe to keyboard notification
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    //Unsubscribe to keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //Display ActivityViewController
    @IBAction func shareMeme(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            presentViewController(controller, animated: true, completion: nil)
        
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
        presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
       
    }
    //Select image from photo library
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Select image and dismiss the image picker controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = pickedImage
            dismissViewControllerAnimated(true, completion: nil)
        }
        shareButton.enabled = true
    }
    
    //Dismiss the image picker controller if cancel is selected
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Remove the placeholder text when starting to add text
    func textFieldDidBeginEditing(textField: UITextField) {
         textField.placeholder = nil;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
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
        if bottomText.isFirstResponder() {
        if(keyboardHidden){
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardHidden = false
        }
        }
    }
    /**
    Determine if the keyboard will hide
    if it's the bottem text, move display down to it's original location. **/
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            if(!keyboardHidden){
                view.frame.origin.y += getKeyboardHeight(notification)
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
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Unhide the toolbar and navigation bar
        hideNavigationAndToolBar(false)
        
        return memedImage
    }
    
    //Save the meme image
    func save() {
        var meme = Meme()
        meme.topText = topText.text!
        meme.bottomText = bottomText.text!
        meme.originalImage =  imagePickerView.image!
        meme.memeImage =  generateMemedImage()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func cancelEditor(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //Hides or displays the navigation bar or toolbar
    func hideNavigationAndToolBar(hide: Bool){
        bottomToolBar.hidden = hide
        topNavBar.hidden = hide
    }
    
}

