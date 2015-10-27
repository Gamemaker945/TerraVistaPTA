//
//  CalendarEntryTypeViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/23/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarEntryTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet var table: UITableView!
    
    
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CalendarIcon.countTypes()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "CalendarCell";
        let cell:CalendarEntryTypeTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CalendarEntryTypeTableViewCell
        let type:Int = indexPath.row
        cell.setType(type)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry:CalendarEntry? = CalendarController.sharedInstance.getActiveEntry()
        entry?.iconIndex = indexPath.row
        self.navigationController?.popViewControllerAnimated(true)
    }

}
