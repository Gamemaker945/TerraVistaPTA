//
//  CalendarDetailsViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarDetailsViewController: UIViewController {

    
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
        let entry:CalendarEntry = CalendarController.sharedInstance.getActiveEntry()!
        
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
    
    

}
