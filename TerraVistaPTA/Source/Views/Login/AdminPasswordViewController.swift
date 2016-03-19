//
//  AdminPasswordViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 11/13/15.
//  Copyright © 2015 Brain Glove Apps. All rights reserved.
//

import UIKit

class AdminPasswordViewController: UIViewController
{
    //--------------------------------------------------------------------------
    // VARS
    //--------------------------------------------------------------------------
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    //--------------------------------------------------------------------------
    // Mark: - Lifecycle Methods
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------
    // Mark: - IBAction Methods
    //--------------------------------------------------------------------------
    @IBAction func resetPressed(sender: UIButton)
    {
        if (self.verifyInput())
        {
            activityIndicator.startAnimating()
//            if let email = self.emailTextField.text
//            {
//                PFUser.requestPasswordResetForEmailInBackground(email, block: { (hasError, error) -> Void in
//                    if (error == nil) {
//                        self.activityIndicator.stopAnimating()
//                        let msg = "Reset instructions have been sent to the email provided. Please check for them shortly and act accordingly."
//                        let alert = UIAlertController(title: " ", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK",  style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
//                            self.navigationController?.popToRootViewControllerAnimated(true)
//                        }))
//                            
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    } else {
//                        // Log details of the failure
//                        ParseErrorHandler.showErrorWithTitle(self, title: "Reset Error", errorCode: error?.code)
//                    }
//                    self.activityIndicator.stopAnimating()
//                })
//            }
        }
    }
    
    //--------------------------------------------------------------------------
    // Mark: - Private Methods
    //--------------------------------------------------------------------------
    func verifyInput () -> Bool
    {
    
        if self.emailTextField.isEmpty() == false && !emailTextField.validateEmailInput()
        {
            ParseErrorHandler.showError(self, errorMsg: "Invalid Email. Please check the format of the email address and try again.")
            return false
        }
        
        return true
    }
}

extension AdminPasswordViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
}