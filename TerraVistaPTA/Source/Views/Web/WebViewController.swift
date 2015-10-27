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
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet weak var table: UITableView!
    @IBOutlet var addButton: UIButton!
    
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.table.reloadData()
    }
    
    //------------------------------------------------------------------------------
    // Mark: TableView Methods
    //------------------------------------------------------------------------------
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WebLinkController.sharedInstance.countWebLinks()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "WebLinkCell";
        let cell: WebLinkTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! WebLinkTableViewCell
        let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
        cell.setLink(link.title)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let link: WebLink = WebLinkController.sharedInstance.getWebLinkAtIndex(indexPath.row)!
        let url: NSURL = NSURL(string: link.urlStr)!
        
        if (!UIApplication.sharedApplication().openURL(url)) {
            
        }
    }
    
    
}
