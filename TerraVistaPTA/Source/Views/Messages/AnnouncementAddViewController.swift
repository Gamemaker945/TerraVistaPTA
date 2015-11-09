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
    
    @IBOutlet var contentHtConstraint: NSLayoutConstraint!
    
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
        
        contentHtConstraint.constant = okButton.frame.origin.y - annContentTextView.frame.origin.y - 8;
        
        let msg:Announcement? = AnnouncementController.sharedInstance.getActive () as? Announcement
        if (msg != nil)
        {
            annTitleTextField.text = msg?.title
            annContentTextView.text = msg?.content
        }
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
            let title = annTitleTextField.text!
            let content = annContentTextView.text!
            
            var msg:Announcement? = AnnouncementController.sharedInstance.getActive () as? Announcement;
            if (msg == nil)
            {
                msg = Announcement()
                msg?.pObj = PFObject(className:"PAnnouncement")
                msg?.pObj!.ACL = PFACL(user: PFUser.currentUser()!)
                msg?.pObj!.ACL?.setPublicReadAccess(true)
            }
            msg?.title = title
            msg?.content = content
            
            AnnouncementController.sharedInstance.update (msg!, completion: { (hasError, error) -> Void in
                if (!hasError) {
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    ParseErrorHandler.showError(self, errorCode: error?.code)
                }
            })
        }
    }
    
    //------------------------------------------------------------------------------
    // Mark: UITextViewDelegate
    //------------------------------------------------------------------------------
    func textViewDidChange(textView: UITextView) {
        //scrollToCursor()
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
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                let kbY = self.view.frame.size.height - keyboardSize.height
                contentHtConstraint.constant = kbY - annContentTextView.frame.origin.y - 68;
                self.view.layoutIfNeeded()
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
        // Keyboard
//        let userInfo = notification.userInfo!
//        let keyboardSize:CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGSizeValue()
//        kbSize = keyboardSize;
//        
//        let keyboardRect:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue();
//        keyboardFrame = self.view.convertRect(keyboardRect, fromView: nil)
//        
        //scrollToCursor();
    }
    
    func keyboardWillHide (notification: NSNotification)
    {
        contentHtConstraint.constant = okButton.frame.origin.y - annContentTextView.frame.origin.y - 8;
    }

    func doneButtonClickedDismissKeyboard ()
    {
        annContentTextView .resignFirstResponder()
    }
    //------------------------------------------------------------------------------
    // Mark: Private Methods
    //------------------------------------------------------------------------------
    private func verify () -> Bool
    {
        if (annTitleTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input an announcement title.");
            return false;
        }
        
        if (annContentTextView.text.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input announcement content.");
            return false;
        }
        
        return true;
    }



}
