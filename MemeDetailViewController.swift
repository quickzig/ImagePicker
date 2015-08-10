//
//  MemeDetailViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 8/6/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit



class MemeDetailViewController: UIViewController  {
    
    var meme: Meme!
    var memeIndex: Int!

    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImageView.image = meme.memeImage
    }
    
    
   }

