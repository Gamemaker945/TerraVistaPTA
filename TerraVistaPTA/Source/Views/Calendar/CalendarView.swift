//
//  CalendarView.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/16/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit


class CalendarView: UIViewController, UITableViewDelegate, UITableViewDataSource, JTCalendarDelegate
{

    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet weak var table: UITableView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!

    var calendarManager: JTCalendarManager!
    @IBOutlet weak var calendarView: UIView!
    
    var dateSelected:NSDate? = nil
    var activeEntries:NSArray? = nil
    
    var calArray:[CalendarEntry] = []


    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        
        self.calendarManager.menuView = self.calendarMenuView
        self.calendarManager.contentView = self.calendarContentView
        self.calendarManager.setDate(NSDate())
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        self.addButton.hidden = !LoginController.sharedInstance.getLoggedIn()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.table.reloadData()
        self.table.hidden = true
        
        CalendarController.sharedInstance.fetch { (hasError, error) -> Void in
            if (!hasError)
            {
                self.calArray = CalendarController.sharedInstance.getParseObjects() as! [CalendarEntry]
                self.table.reloadData()
                self.table.hidden = false;
                self.calendarManager.reload()
                self.calendarManager.setDate(NSDate())
                

                let data: NSDictionary = ["SelectedDate":NSDate()]
                let center:NSNotificationCenter = NSNotificationCenter.defaultCenter()
                center.postNotificationName("kJTCalendarDaySelected", object:data)
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
                ParseErrorHandler.showError(self, errorCode: error?.code)
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.activeEntries = nil
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (activeEntries != nil)
        {
            return activeEntries!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "CalendarCell";
        let cell:CalendarTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CalendarTableViewCell
        let msg: CalendarEntry = activeEntries!.objectAtIndex(indexPath.row) as! CalendarEntry
        cell.setEntry(msg)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let msg: CalendarEntry = activeEntries!.objectAtIndex(indexPath.row) as! CalendarEntry
        CalendarController.sharedInstance.setActive(msg)
        
        self.performSegueWithIdentifier("CalendarDetailsSegue", sender: self)
    }
    
    
    //------------------------------------------------------------------------------
    // Mark: JTCalendarDelegate Methods
    //------------------------------------------------------------------------------

    func calendar(calendar:JTCalendarManager!, prepareDayView dayView:UIView!)
    {
        let dv = dayView as! JTCalendarDayView
        
        dv.hidden = false;
    
        // Test if the dayView is from another month than the page
        // Use only in month mode for indicate the day of the previous or next month
        if(dv.isFromAnotherMonth)
        {
            dv.hidden = true;
        }
            // Today
            
        else if ( calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: dv.date))
        {
            dv.circleView.hidden = false;
            dv.circleView.backgroundColor = UIColor.blueColor();
            dv.dotView.backgroundColor = UIColor.whiteColor();
            dv.textLabel.textColor = UIColor.whiteColor();
        }
            // Selected date
        else if (dateSelected != nil && calendarManager.dateHelper.date(dateSelected!, isTheSameDayThan: dv.date))
        {
            dv.circleView.hidden = false;
            dv.circleView.backgroundColor = UIColor.redColor();
            dv.dotView.backgroundColor = UIColor.whiteColor();
            dv.textLabel.textColor = UIColor.whiteColor();
        }
            // Another day of the current month
        else
        {
            dv.circleView.hidden = true;
            dv.dotView.backgroundColor = UIColor.redColor();
            dv.textLabel.textColor = UIColor.blackColor();
        }
    
        // Your method to test if a date have an event for example
        if(CalendarController.sharedInstance.hasEntriesForDate(dv.date))
        {
            dv.dotView.hidden = false;
        }
        else
        {
            dv.dotView.hidden = true;
        }
    }
    
    
    func calendar(calendar:JTCalendarManager!, didTouchDayView dayView:UIView!)
    {
        let dv = dayView as! JTCalendarDayView
        
        // Use to indicate the selected date
        dateSelected = dv.date;
        
        // Animation for the circleView
        dv.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        UIView.transitionWithView(dayView, duration: 0.05, options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                dv.circleView.transform = CGAffineTransformIdentity
                self.calendarManager.reload()
            }, completion: nil)
        
        
        // Load the previous or next page if touch a day from another month
        if (!calendarManager.dateHelper.date(self.calendarContentView.date, isTheSameMonthThan: dv.date))
        {
            if (self.calendarContentView.date.compare(dv.date) == NSComparisonResult.OrderedAscending)
            {
                self.calendarContentView.loadNextPageWithAnimation()
            }
            else
            {
                self.calendarContentView.loadPreviousPageWithAnimation()
            }
        }
        
        activeEntries = CalendarController.sharedInstance.getEntriesForDate(dateSelected!)
        
        if (activeEntries != nil && activeEntries!.count > 0)
        {
            self.table.hidden = false;
            self.table.reloadData()
        }
        else
        {
            self.table.hidden = true;
        }
    }


    @IBAction func addButtonPressed(sender: AnyObject) {
        
        CalendarController.sharedInstance.setActive (nil)
        self.performSegueWithIdentifier("SegueToNewEntry", sender: self)
        
    }
    

    

}
