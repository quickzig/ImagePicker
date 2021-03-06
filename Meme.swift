//
//  Meme.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/26/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//


import UIKit

//Meme image object
struct Meme {
    
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    func generateImage(view: UIView) {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let memeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        }

}
