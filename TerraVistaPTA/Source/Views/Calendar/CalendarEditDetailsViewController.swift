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
    private var iconIndex:Int = 0
    
    
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
        whereTextField.delegate = self;
        titleTextField.delegate = self;
        
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
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == whenTextField || textField == startTextField || textField == endTextField)
        {
            return false;
        }
        else
        {
            return true;
        }
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
            saveEntry()
            let cal:CalendarEntry? = CalendarController.sharedInstance.getActive () as? CalendarEntry;
            
            CalendarController.sharedInstance.update (cal!, completion: { (hasError, error) -> Void in
                if (!hasError) {
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    ParseErrorHandler.showError(self, errorCode: error?.code)
                }
            })
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancelPressed (sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func iconTouched ()
    {
        saveEntry()
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
        let entry:CalendarEntry? = CalendarController.sharedInstance.getActive() as? CalendarEntry
        
        if (entry != nil)
        {
            // Editing an existing value
            titleTextField.text = entry!.title;
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            if (entry!.startDate != nil) {
                startTextField.text = timeFormatter.stringFromDate(entry!.startDate!)
                startTime = entry!.startDate;
            }
            
            if (entry!.stopDate != nil) {
                endTextField.text = timeFormatter.stringFromDate(entry!.stopDate!)
                endTime = entry!.stopDate;
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            
            if (entry!.startDate != nil) {
                whenTextField.text = dateFormatter.stringFromDate(entry!.startDate!)
                whenDate = entry!.startDate;
            }
            whereTextField.text = entry!.location
            
            detailsTextView.text = entry!.info
            
            iconBg.backgroundColor = entry!.getIconColor()
            iconLabel.text = entry!.getIconString()
            
            startTime = entry!.startDate
            endTime = entry!.stopDate
            whenDate = entry!.startDate
            
            iconIndex = entry!.iconIndex

        }
        else
        {
            self.navigationItem.title = "Add Event"
            iconIndex = 0
        }
        
        iconBg.layer.cornerRadius = 4
        
    }
    
    func saveEntry ()
    {
        let title = titleTextField.text!
        let location = whereTextField.text!
        let details = detailsTextView.text!
        
        var cal:CalendarEntry? = CalendarController.sharedInstance.getActive () as? CalendarEntry;
        if (cal == nil)
        {
            cal = CalendarEntry()
            cal?.pObj = PFObject(className:"PCalEntry")
            cal?.pObj!.ACL = PFACL(user: PFUser.currentUser()!)
            cal?.pObj!.ACL?.setPublicReadAccess(true)
        }
        cal?.title = title
        cal?.location = location
        cal?.info = details
        cal?.iconIndex = iconIndex;
        
        if (whenDate != nil && startTime != nil) {
            cal?.startDate = whenDate!.combineWithTime(startTime!) }
        
        if (whenDate != nil && endTime != nil) {
            cal?.stopDate = whenDate!.combineWithTime(endTime!) }
        
        CalendarController.sharedInstance.setActive(cal)
    }
    
    func doneButtonClickedDismissKeyboard()
    {
        if (activeView == whenTextField)
        {
            if (whenDate == nil)
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd, YYYY"
                whenTextField.text = dateFormatter.stringFromDate(NSDate())
                whenDate = NSDate()
            }
        }
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
            ParseErrorHandler.showError(self, errorMsg:"Please input an title for the entry.");
            return false;
        }
        
        if (startTextField.text == nil || startTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input a start time for the entry.");
            return false;
        }
        
        if (endTextField.text == nil || endTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input an end time for the entry.");
            return false;
        }
        
        if (whenTextField.text == nil || whenTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input a date for the entry.");
            return false;
        }
        
        if (startTime?.compare(endTime!) == NSComparisonResult.OrderedDescending)
        {
            ParseErrorHandler.showError(self, errorMsg:"Start time must be before or equal to the end time.");
            return false;
        }
        
        return true;
    }


}
