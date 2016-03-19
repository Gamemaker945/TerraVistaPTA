//
//  AnnouncementAddViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

// *****************************************************************************
// *****************************************************************************
class AnnouncementAddViewController: UIViewController, UIAlertViewDelegate
{
    
    //--------------------------------------------------------------------------
    // Outlets
    //--------------------------------------------------------------------------
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var annTitleTextField: UITextField!
    var annContentTextView: UITextView!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!
    
    @IBOutlet var navTitle: UINavigationItem!
    
    
    //--------------------------------------------------------------------------
    // VARS
    //--------------------------------------------------------------------------
    var kbSize: CGSize!
    var keyboardFrame: CGRect!
    var generatePush = false
    var contentHeight: CGFloat!
    
    //--------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //--------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        annTitleTextField.delegate = self;
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.bgView.layoutIfNeeded()
        
        let myY = contentLabel.frame.origin.y + contentLabel.frame.size.height + 8
        contentHeight = pushButton.frame.origin.y - myY - 66
        annContentTextView = UITextView(frame: CGRectMake(pushButton.frame.origin.x, myY, pushButton.frame.size.width, contentHeight))
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
        bgView.addSubview(annContentTextView)
        
        //contentHtConstraint.constant = okButton.frame.origin.y - annContentTextView.frame.origin.y - 8;
        
        let msg:Announcement? = AnnouncementController.sharedInstance.getActive () as? Announcement
        if (msg != nil)
        {
            annTitleTextField.text = msg?.title
            annContentTextView.text = msg?.content
            navTitle.title = "Edit Announcement"
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------
    // Mark: IBActions
    //--------------------------------------------------------------------------
    @IBAction func okPressed (sender: UIButton)
    {
        if (verify())
        {
            var isNew = false
            let title = annTitleTextField.text!
            let content = annContentTextView.text!
            
            var msg:Announcement? = AnnouncementController.sharedInstance.getActive () as? Announcement;
            if (msg == nil)
            {
                msg = AnnouncementController.sharedInstance.createEntry()
                isNew = true
            }
            msg?.title = title
            msg?.content = content
            
            if self.generatePush {
                
                let alert = UIAlertController (title: "Notice", message: "This announcement will generate a push notification to all users. Is this ok?", preferredStyle: UIAlertControllerStyle.Alert)
                let yesButton = UIAlertAction (title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    AnnouncementController.sharedInstance.update (msg!, completion: { (hasError, error) -> Void in
                        if (!hasError) {
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                if isNew {
                                    AnnouncementController.sharedInstance.insertObject(msg!)
                                }

                                if (!hasError)
                                {
                                    self.navigationController?.popViewControllerAnimated(true)
                                }
                                else
                                {
                                    print("Error: \(error!) \(error!.userInfo)")
                                    ParseErrorHandler.showError(self, errorCode: error?.code)
                                }
                            }
                            
                        } else {
                            ParseErrorHandler.showError(self, errorCode: error?.code)
                        }
                    })
                    
                    alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                })
                
                let noButton = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alert.addAction(yesButton)
                alert.addAction(noButton)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                AnnouncementController.sharedInstance.update (msg!, completion: { (hasError, error) -> Void in
                    if (!hasError) {
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if isNew {
                                AnnouncementController.sharedInstance.insertObject(msg!)
                            }
                            
                            if (!hasError)
                            {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            else
                            {
                                print("Error: \(error!) \(error!.userInfo)")
                                ParseErrorHandler.showError(self, errorCode: error?.code)
                            }
                        }
                    } else {
                        ParseErrorHandler.showError(self, errorCode: error?.code)
                    }
                })
            }
        }
    }
    
    @IBAction func generatePushPressed(sender: UIButton)
    {
        generatePush = !generatePush
        pushButton.selected = generatePush
    }
    
    
    //--------------------------------------------------------------------------
    // Mark: Keyboard Methods
    //--------------------------------------------------------------------------
    func keyboardDidShow (notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                let kbY = self.view.frame.size.height - keyboardSize.height
                var frame = annContentTextView.frame
                frame.size.height = kbY - annContentTextView.frame.origin.y - 72;
                annContentTextView.frame = frame
                self.view.layoutIfNeeded()
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    
    func keyboardWillHide (notification: NSNotification)
    {
        var frame = annContentTextView.frame
        frame.size.height = contentHeight;
        annContentTextView.frame = frame
        //contentHtConstraint.constant = okButton.frame.origin.y - annContentTextView.frame.origin.y - 8;
    }
    
    func doneButtonClickedDismissKeyboard ()
    {
        annContentTextView .resignFirstResponder()
    }
    
    //--------------------------------------------------------------------------
    // Mark: Private Methods
    //--------------------------------------------------------------------------
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

// *****************************************************************************
// Mark: UITextViewDelegate
// *****************************************************************************
extension AnnouncementAddViewController : UITextViewDelegate
{
    func textViewDidChange(textView: UITextView) {
        //scrollToCursor()
    }
}

// *****************************************************************************
// Mark: UITextFieldDelegate
// *****************************************************************************
extension AnnouncementAddViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        annTitleTextField.resignFirstResponder()
        return true
    }
}
