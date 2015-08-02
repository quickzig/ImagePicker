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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        var memesForRow = self.memes[indexPath.row]
        cell.textLabel!.text = memesForRow.topText! + "-" + memesForRow.bottomText!
        
    return cell
        
    }

}
