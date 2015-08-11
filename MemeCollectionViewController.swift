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

    //Button used to add a new Meme
    @IBAction func addMeme(sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editorViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MemeEditorController
        presentViewController(editorViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Add the image to the collection
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memeImage
        return cell
    }
    
    //Show the detail view of the selected meme
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = memes[indexPath.row]
        let destinationController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        destinationController.meme = meme
        destinationController.memeIndex = indexPath.row
        navigationController?.pushViewController(destinationController, animated: true)
    }
}