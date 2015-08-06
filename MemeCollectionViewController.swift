//
//  MemeCollectionViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/28/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme]!

    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MemeEditorController
        self.presentViewController(editorViewController, animated: true, completion: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        let imageView = UIImageView(image: meme.memeImage)
        cell.backgroundView = imageView
        return cell
    }
    
}