//
//  AnnouncementViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

// *****************************************************************************
// AnnouncementViewController
// *****************************************************************************
class AnnouncementViewController: UIViewController
{
    
    //--------------------------------------------------------------------------
    // VARS
    //--------------------------------------------------------------------------
    @IBOutlet var table: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var msgArray:[Announcement] = []
    var isViewEditing = false
    
    
    //--------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.editButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.activityIndicator.startAnimating()
        self.table.hidden = true;
        AnnouncementController.sharedInstance.fetch { (hasError, error) -> Void in
            if (!hasError)
            {
                self.msgArray = AnnouncementController.sharedInstance.getParseObjects() as! [Announcement]
                self.table.reloadData()
                self.table.hidden = false;
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
                ParseErrorHandler.showError(self, errorCode: error?.code)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    //------------------------------------------------------------------------------
    // Mark: - Table Methods
    //------------------------------------------------------------------------------
    private func getCellContentHeight (label: String) -> CGFloat
    {
        //let constraint:CGSize = CGSizeMake(self.view.frame.size.width - 32, 100000.0);
    
        //var context:NSStringDrawingContext = NSStringDrawingContext();
        let height:CGFloat = label.heightWithConstrainedWidth (self.view.frame.size.width - 32, font: UIFont.systemFontOfSize(14))
        
        return height;
    }
    
    //------------------------------------------------------------------------------
    // MARK: - Private Methods
    //------------------------------------------------------------------------------
    func deleteMsg (msg: Announcement)
    {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this Announcement?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No",  style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            self.activityIndicator.startAnimating()
            AnnouncementController.sharedInstance.delete (msg, completion: { (hasError, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                if (!hasError)
                {
                    self.msgArray = AnnouncementController.sharedInstance.getParseObjects() as! [Announcement]
                    self.table.reloadData()
                }
                else
                {
                    ParseErrorHandler.showError(self, errorCode: error?.code)
                }
            })
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if (isViewEditing)
        {
            isViewEditing = false
            self.table.setEditing(false, animated: true)
            self.editButton.setTitle("Edit", forState: UIControlState.Normal)
        }
        else
        {
            isViewEditing = true
            self.table.setEditing(true, animated: true)
            self.editButton.setTitle("Done", forState: UIControlState.Normal)
        }
        
    }
    
    func showError (errorMsg: String)
    {
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK",  style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}


// *****************************************************************************
// MARK: - UITableViewDataSource
// *****************************************************************************

extension AnnouncementViewController : UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Not Admin User
        if (LoginController.sharedInstance.getActiveUser() == nil)
        {
            return msgArray.count
        }
        else
        {
            return msgArray.count + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "AnnoucementCell";
        let AddCellIdentifier: String = "AddAnnoucementCell";
        
        if (indexPath.row == msgArray.count)
        {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(AddCellIdentifier)!
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
        else
        {
            let cell:AnnouncementTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! AnnouncementTableViewCell
            let msg: Announcement = msgArray[indexPath.row]
            cell.setAnnouncement(msg)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let msg: Announcement = msgArray[indexPath.row]
            self.deleteMsg(msg)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !(indexPath.row == msgArray.count)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
}


// *****************************************************************************
// MARK: - UITableViewDelegate
// *****************************************************************************

extension AnnouncementViewController : UITableViewDelegate
{
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == msgArray.count)
        {
            return 58.0
        }
        else
        {
            let msg: Announcement = msgArray[indexPath.row]
            return 43.0 + 47.0 + getCellContentHeight(msg.content as String)
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Not Admin User
        if (indexPath.row == msgArray.count)
        {
            AnnouncementController.sharedInstance.setActive (nil)
            self.performSegueWithIdentifier("SegueToEditAnnouncement", sender: self)
        }
            
        else if (isViewEditing)
        {
            let msg: Announcement = msgArray[indexPath.row]
            AnnouncementController.sharedInstance.setActive (msg)
            self.performSegueWithIdentifier("SegueToEditAnnouncement", sender: self)
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
}


