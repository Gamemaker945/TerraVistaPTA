//
//  CalendarDetailsViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarDetailsViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var iconBg: UIView!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var whenLabel: UILabel!
    
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var whereLabel: UILabel!
    
    @IBOutlet var detailsTextView: UITextView!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.editButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.deleteButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        loadCalendarEntry()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadCalendarEntry()
    {
        let entry:CalendarEntry = CalendarController.sharedInstance.getActive() as! CalendarEntry
        
        titleLabel.text = entry.title;
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startLabel.text = dateFormatter.stringFromDate(entry.startDate!)
        endLabel.text = dateFormatter.stringFromDate(entry.stopDate!)
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "MMM dd, YYYY"
        whenLabel.text = dateFormatter2.stringFromDate(entry.startDate!)
        whereLabel.text = entry.location
        
        detailsTextView.text = entry.info
        
        iconBg.backgroundColor = entry.getIconColor()
        iconLabel.text = entry.getIconString()
        
        iconBg.layer.cornerRadius = 4

    }
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        self.editButton.userInteractionEnabled = false;
        let entry:CalendarEntry = CalendarController.sharedInstance.getActive() as! CalendarEntry
        self.deleteMsg(entry)
    }
    
    func deleteMsg (entry: CalendarEntry)
    {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this entry?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No",  style: UIAlertActionStyle.Cancel, handler: { action in
            self.editButton.userInteractionEnabled = true;
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            self.activityIndicator.startAnimating()
            CalendarController.sharedInstance.delete (entry, completion: { (hasError, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    if (!hasError)
                    {
                        self.navigationController?.popViewControllerAnimated(true);
                    }
                    else
                    {
                        ParseErrorHandler.showError(self, errorCode: error?.code)
                    }
                }
            })
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
