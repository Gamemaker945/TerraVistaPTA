//
//  CalendarEditDetailsViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/22/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class CalendarEditDetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet var iconBg: UIView!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var whenTextField: UITextField!
    
    @IBOutlet var startTextField: UITextField!
    @IBOutlet var endTextField: UITextField!
    @IBOutlet var whereTextField: UITextField!
    
    @IBOutlet var detailsTextView: UITextView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    private var activeView: UIView?
    private var kpos: CGPoint?
    
    private var startTime: NSDate?
    private var endTime: NSDate?
    private var whenDate: NSDate?
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        detailsTextView.layer.cornerRadius = 5
        detailsTextView.layer.borderWidth = 1
        detailsTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        
        let doneToolbar:UIToolbar = UIToolbar (frame: CGRectMake(0, 0, screenBounds.size.width, 30))
        
        let bbItem1:UIBarButtonItem = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let bbItem2:UIBarButtonItem = UIBarButtonItem (title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonClickedDismissKeyboard")
        doneToolbar.items = [bbItem1, bbItem2]
        detailsTextView.inputAccessoryView = doneToolbar
        whenTextField.inputAccessoryView = doneToolbar
        startTextField.inputAccessoryView = doneToolbar
        endTextField.inputAccessoryView = doneToolbar
        
        detailsTextView.delegate = self;
        whenTextField.delegate = self;
        startTextField.delegate = self;
        endTextField.delegate = self;
        
        let gesture = UITapGestureRecognizer.init(target: self, action: "iconTouched")
        
        iconBg.userInteractionEnabled = true;
        iconBg.addGestureRecognizer(gesture)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCalendarEntry()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        kpos = scrollView.contentOffset;
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //------------------------------------------------------------------------------
    // Mark: UITextFieldDelegate
    //------------------------------------------------------------------------------
    func textFieldDidBeginEditing(textField: UITextField) {
        activeView = textField
        
//        if (textField == whenTextField)
//        {
//            var datePickerView  : UIDatePicker = UIDatePicker()
//            datePickerView.datePickerMode = UIDatePickerMode.Time
//            whenTextField.inputView = datePickerView
//            datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
//        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        activeView = nil;
    }
    
    @IBAction func dp(sender: UITextField) {
        
        activeView = sender
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func tpstart(sender: UITextField) {
        
        activeView = sender
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleStartTimePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func tpend(sender: UITextField) {
        
        activeView = sender
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleEndTimePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func savePressed (sender: UIButton)
    {
        if (verify())
        {
            var isNewEntry:Bool = false
            let entry:CalendarEntry? = CalendarController.sharedInstance.getActiveEntry()
            if (entry!.pObj == nil && entry?.pObj?.objectId == nil)
            {
                isNewEntry = true
            }
            
            saveEntry(entry)
            
            if (isNewEntry) {
                CalendarController.sharedInstance.addCalendarEntry(entry)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelPressed (sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func iconTouched ()
    {
        let entry:CalendarEntry? = CalendarController.sharedInstance.getActiveEntry()
        saveEntry(entry)
        self.performSegueWithIdentifier("SegueToEntryType", sender: self)
    }
    
    //------------------------------------------------------------------------------
    // Mark: UITextViewDelegate
    //------------------------------------------------------------------------------
    func textViewDidBeginEditing(textView: UITextView) {
        activeView = textView
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        activeView = nil;
    }

    //------------------------------------------------------------------------------
    // Mark: Keyboard Methods
    //------------------------------------------------------------------------------
    func keyboardDidShow (notification: NSNotification)
    {

        if (activeView != nil && activeView == detailsTextView) {
            scrollView.setContentOffset(CGPointMake(0, 160), animated: true)
        }
    }
    
    func keyboardWillHide (notification: NSNotification)
    {
        scrollView.setContentOffset(kpos!, animated: true)
    }
    

    //------------------------------------------------------------------------------
    // Mark: Private Methods
    //------------------------------------------------------------------------------
    func loadCalendarEntry()
    {
        let entry:CalendarEntry? = CalendarController.sharedInstance.getActiveEntry()
        
        if (entry != nil)
        {
            // Editing an existing value
            titleTextField.text = entry!.title;
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            startTextField.text = timeFormatter.stringFromDate(entry!.startDate!)
            endTextField.text = timeFormatter.stringFromDate(entry!.stopDate!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            whenTextField.text = dateFormatter.stringFromDate(entry!.startDate!)
            whereTextField.text = entry!.location
            
            detailsTextView.text = entry!.info
            
            iconBg.backgroundColor = entry!.getIconColor()
            iconLabel.text = entry!.getIconString()
            
            startTime = entry!.startDate
            endTime = entry!.stopDate
            whenDate = entry!.startDate

        }
        
        iconBg.layer.cornerRadius = 4
        
    }
    
    func saveEntry (entry:CalendarEntry?)
    {
        entry?.title = titleTextField.text!
        
        let calendar = NSCalendar.currentCalendar()
        //let startcomponents = calendar.components(.Cal, fromDate: startTime)
        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: whenDate!)
        var timeComponents = calendar.components([.Hour, .Minute, .Second], fromDate: startTime!)
        
        var mergedComponments = NSDateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        let startDate = calendar.dateFromComponents(mergedComponments)
        
        timeComponents = calendar.components([.Hour, .Minute, .Second], fromDate: endTime!)
        
        mergedComponments = NSDateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        let endDate = calendar.dateFromComponents(mergedComponments)
        
        entry?.startDate = startDate
        entry?.stopDate = endDate
        
        entry?.location = whereTextField.text!
        entry?.info = detailsTextView.text!
    }
    
    func doneButtonClickedDismissKeyboard()
    {
        activeView?.resignFirstResponder()
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        whenTextField.text = dateFormatter.stringFromDate(sender.date)
        whenDate = sender.date
    }
    
    func handleStartTimePicker(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        startTextField.text = timeFormatter.stringFromDate(sender.date)
        startTime = sender.date
    }
    
    func handleEndTimePicker(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        endTextField.text = timeFormatter.stringFromDate(sender.date)
        endTime = sender.date
    }
    
    
    private func verify () -> Bool
    {
        if (titleTextField.text == nil || titleTextField.text!.isEmpty)
        {
            showErrorAlert("Please input an title for the entry.");
            return false;
        }
        
        if (startTextField.text == nil || startTextField.text!.isEmpty)
        {
            showErrorAlert("Please input a start time for the entry.");
            return false;
        }
        
        if (endTextField.text == nil || endTextField.text!.isEmpty)
        {
            showErrorAlert("Please input an end time for the entry.");
            return false;
        }
        
        if (whenTextField.text == nil || whenTextField.text!.isEmpty)
        {
            showErrorAlert("Please input a date for the entry.");
            return false;
        }
        
        if (startTime?.compare(endTime!) == NSComparisonResult.OrderedDescending)
        {
            showErrorAlert("Start time must be before or equal to the end time.");
            return false;
        }
        
        return true;
    }

    private func showErrorAlert (msg: String)
    {
        let alert = UIAlertView (title: "Error", message: msg, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }

}
