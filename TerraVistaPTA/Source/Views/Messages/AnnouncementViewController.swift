//
//  AnnouncementViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet var table: UITableView!
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
        return AnnouncementController.sharedInstance.countAnnouncements()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let msg: Announcement = AnnouncementController.sharedInstance.getAnnouncementAtIndex(indexPath.row)!
        return 43.0 + 47.0 + getCellContentHeight(msg.content as String)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "AnnoucementCell";
        let cell:AnnouncementTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! AnnouncementTableViewCell
        let msg: Announcement = AnnouncementController.sharedInstance.getAnnouncementAtIndex(indexPath.row)!
        cell.setAnnouncement(msg)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var msg: Announcement = AnnouncementController.sharedInstance.getAnnouncementAtIndex(indexPath.row)!
    }
    
    private func getCellContentHeight (label: String) -> CGFloat
    {
        //let constraint:CGSize = CGSizeMake(self.view.frame.size.width - 32, 100000.0);
    
        //var context:NSStringDrawingContext = NSStringDrawingContext();
        let height:CGFloat = label.heightWithConstrainedWidth (self.view.frame.size.width - 32, font: UIFont.systemFontOfSize(14))
        
        return height;
    }
    
}
