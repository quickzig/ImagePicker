//
//  MemeTableViewController.swift
//  ImagePicker
//
//  Created by Brian Quick on 7/28/15.
//  Copyright (c) 2015 Brian Quick. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Add the image and text to the table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        var memesForRow = memes[indexPath.row]
        cell.imageView?.image = memesForRow.memeImage
        cell.textLabel!.text = memesForRow.topText! + "-" + memesForRow.bottomText!
    return cell
    }
    
   //Show the detail view of the selected meme
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = memes[indexPath.row]
        let destinationController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        destinationController.meme = meme
        destinationController.memeIndex = indexPath.row
        navigationController?.pushViewController(destinationController, animated: true)
    }
}
