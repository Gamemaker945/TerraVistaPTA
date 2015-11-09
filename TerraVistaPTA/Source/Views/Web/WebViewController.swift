//
//  WebViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//
import UIKit

class WebViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //------------------------------------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------------------------------------
    @IBOutlet var table: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var isViewEditing = false
    var linkArray:[WebLink] = []
    
    //------------------------------------------------------------------------------
    // MARK: - Lifecycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.editButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.activityIndicator.startAnimating()
        self.table.hidden = true;
        WebLinkController.sharedInstance.fetch { (hasError, error) -> Void in
            if (!hasError)
            {
                self.linkArray = WebLinkController.sharedInstance.getParseObjects() as! [WebLink]
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
    
    //------------------------------------------------------------------------------
    // MARK: - TableView Methods
    //------------------------------------------------------------------------------
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Not Admin User
        if (LoginController.sharedInstance.getActiveUser() == nil)
        {
            return linkArray.count
        }
        else
        {
            return linkArray.count + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let WebCellIdentifier: String = "WebLinkCell";
        let AddCellIdentifier: String = "AddLinkCell";
        
        if (indexPath.row == linkArray.count)
        {
            let cell: WebLinkTableViewCell = tableView.dequeueReusableCellWithIdentifier(AddCellIdentifier) as! WebLinkTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
        else
        {
            let cell: WebLinkTableViewCell = tableView.dequeueReusableCellWithIdentifier(WebCellIdentifier) as! WebLinkTableViewCell
            let link: WebLink = linkArray[indexPath.row]
            cell.setLink(link)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Not Admin User
        if (indexPath.row == linkArray.count)
        {
            WebLinkController.sharedInstance.setActive (nil)
            self.performSegueWithIdentifier("SegueToEditWebLink", sender: self)
        }
        
        else if (isViewEditing)
        {
            let link: WebLink = linkArray[indexPath.row]
            WebLinkController.sharedInstance.setActive (link)
            self.performSegueWithIdentifier("SegueToEditWebLink", sender: self)

        }
        else
        {
            let link: WebLink = linkArray[indexPath.row]
            var urlStr = link.urlStr
            if (urlStr.rangeOfString("http://") == nil) {
                urlStr = "http://" + urlStr
            }

            let url: NSURL = NSURL(string: urlStr)!
            
            if (!UIApplication.sharedApplication().openURL(url)) {
                 ParseErrorHandler.showError(self, errorMsg:"It appears this is not a valid link or the link is not responding. Please wait a bit and try again or contact the applicaiton administrator.")
            }

        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let link: WebLink = linkArray[indexPath.row]
            self.deleteLink(link)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !(indexPath.row == linkArray.count)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove:WebLink = linkArray[fromIndexPath.row]
        itemToMove.order = toIndexPath.row
        linkArray.removeAtIndex(fromIndexPath.row)
        linkArray.insert(itemToMove, atIndex: toIndexPath.row)
        
        var pfObjArray = [PFObject]()
        pfObjArray.append(itemToMove.pObj!)
        
        for (var i=toIndexPath.row+1; i < linkArray.count; i++)
        {
            let link = linkArray[i]
            link.order++
            pfObjArray.append(link.pObj!)
        }
        
        PFObject.saveAllInBackground(pfObjArray)
    }
    
    //------------------------------------------------------------------------------
    // MARK: - WebLinkTableViewCellProtocol Methods
    //------------------------------------------------------------------------------
    func deleteLink (link: WebLink)
    {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this link?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No",  style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            self.activityIndicator.startAnimating()
            WebLinkController.sharedInstance.delete(link, completion: { (hasError, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                if (!hasError)
                {
                    self.linkArray = WebLinkController.sharedInstance.getParseObjects() as! [WebLink]
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
}
