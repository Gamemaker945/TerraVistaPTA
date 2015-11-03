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
        WebLinkController.sharedInstance.fetchWebLinks { (hasError, error) -> Void in
            if (!hasError)
            {
                self.table.reloadData()
                self.table.hidden = false;
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
                self.showError("There was an error fetching the web links from the server: \(error!) \(error!.userInfo)")
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
            return WebLinkController.sharedInstance.countWebLinks()
        }
        else
        {
            return WebLinkController.sharedInstance.countWebLinks() + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let WebCellIdentifier: String = "WebLinkCell";
        let AddCellIdentifier: String = "AddLinkCell";
        
        if (indexPath.row == WebLinkController.sharedInstance.countWebLinks())
        {
            let cell: WebLinkTableViewCell = tableView.dequeueReusableCellWithIdentifier(AddCellIdentifier) as! WebLinkTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
        else
        {
            let cell: WebLinkTableViewCell = tableView.dequeueReusableCellWithIdentifier(WebCellIdentifier) as! WebLinkTableViewCell
            let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
            cell.setLink(link)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Not Admin User
        if (indexPath.row == WebLinkController.sharedInstance.countWebLinks())
        {
            WebLinkController.sharedInstance.setActiveLink(nil)
            self.performSegueWithIdentifier("SegueToEditWebLink", sender: self)
        }
        
        else if (isViewEditing)
        {
            let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
            WebLinkController.sharedInstance.setActiveLink(link)
            self.performSegueWithIdentifier("SegueToEditWebLink", sender: self)

        }
        else
        {
            let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
            var urlStr = link.urlStr
            if (urlStr.rangeOfString("http://") == nil) {
                urlStr = "http://" + urlStr
            }

            let url: NSURL = NSURL(string: urlStr)!
            
            if (!UIApplication.sharedApplication().openURL(url)) {
                 self.showError("It appears this is not a valid link or the link is not responding. Please wait a bit and try again or contact the applicaiton administrator.")
            }

        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
            self.deleteLink(link)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !(indexPath.row == WebLinkController.sharedInstance.countWebLinks())
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
//        var itemToMove = tableData[fromIndexPath.row]
//        tableData.removeAtIndex(fromIndexPath.row)
//        tableData.insert(itemToMove, atIndex: toIndexPath.row)
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
            WebLinkController.sharedInstance.deleteWebLink(link, completion: { (hasError, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                if (!hasError)
                {
                    self.table.reloadData()
                }
                else
                {
                    self.showError("There was an error deleting the web link from the server: \(error!) \(error!.userInfo)")
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
