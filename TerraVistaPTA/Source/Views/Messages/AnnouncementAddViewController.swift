//
//  AnnouncementAddViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class AnnouncementAddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var annTitleTextField: UITextField!
    @IBOutlet weak var annContentTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    
    var kbSize: CGSize!
    var keyboardFrame: CGRect!
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        annContentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        annContentTextView.layer.borderWidth = 1
        annContentTextView.layer.cornerRadius = 5
    
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        
        let doneToolbar:UIToolbar = UIToolbar (frame: CGRectMake(0, 0, screenBounds.size.width, 30))
        
        let bbItem1:UIBarButtonItem = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let bbItem2:UIBarButtonItem = UIBarButtonItem (title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonClickedDismissKeyboard")
        doneToolbar.items = [bbItem1, bbItem2]
        annContentTextView.inputAccessoryView = doneToolbar
        
        annContentTextView.delegate = self;
        annTitleTextField.delegate = self;

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------------------------------
    // Mark: IBActions
    //------------------------------------------------------------------------------
    @IBAction func cancelPressed (sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func okPressed (sender: UIButton) {
        if (verify())
        {
            let ann:Announcement = Announcement()
            ann.title = annTitleTextField.text!
            ann.content = annContentTextView.text
            ann.date = NSDate()
            
            AnnouncementController.sharedInstance.addAnnouncement(ann)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    //------------------------------------------------------------------------------
    // Mark: UITextViewDelegate
    //------------------------------------------------------------------------------
    func textViewDidChange(textView: UITextView) {
        scrollToCursor()
    }
    
    //------------------------------------------------------------------------------
    // Mark: UITextFieldDelegate
    //------------------------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        annTitleTextField.resignFirstResponder()
        return true
    }
    
    //------------------------------------------------------------------------------
    // Mark: Keyboard Methods
    //------------------------------------------------------------------------------
    func keyboardDidShow (notification: NSNotification)
    {
        // Keyboard
        let userInfo = notification.userInfo!
        let keyboardSize:CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGSizeValue()
        kbSize = keyboardSize;
        
        let keyboardRect:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue();
        keyboardFrame = self.view.convertRect(keyboardRect, fromView: nil)
        
        scrollToCursor();
    }
    
    func keyboardWillHide (notification: NSNotification)
    {
    
    }

    
    //------------------------------------------------------------------------------
    // Mark: Private Methods
    //------------------------------------------------------------------------------
    private func verify () -> Bool
    {
        if (annTitleTextField.text!.isEmpty)
        {
            showErrorAlert("Please input an announcement title.");
            return false;
        }
        
        if (annContentTextView.text.isEmpty)
        {
            showErrorAlert("Please input announcement content.");
            return false;
        }
        
        return true;
    }
    
    private func showErrorAlert (msg: String)
    {
        let alert = UIAlertView (title: "Error", message: msg, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func scrollToCursor()
    {
        // View
        let viewBounds:CGRect = self.view.bounds;
        // TextView
        let textViewBounds:CGRect = self.view.convertRect(self.annContentTextView.frame, fromView:self.annContentTextView.superview)
        let textViewOrigin:CGPoint = textViewBounds.origin;
        
        // Cursor
        let textViewCursor:CGPoint = self.annContentTextView.caretRectForPosition(self.annContentTextView.selectedTextRange!.start).origin;
        let cursorPoint:CGPoint = CGPointMake((textViewCursor.x + textViewOrigin.x), (textViewOrigin.y + textViewCursor.y - self.annContentTextView.contentOffset.y));
        
        // Scroll to point
        if (cursorPoint.y > (keyboardFrame.origin.y - 20))
        {
            self.annContentTextView.setContentOffset(CGPointMake(0, (cursorPoint.y - (viewBounds.size.height - kbSize.height)) + self.annContentTextView.contentOffset.y + 25), animated: true);
            
        }
    }


}
