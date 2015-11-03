//
//  WebLinkAddViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//
import UIKit

class WebLinkAddViewController: UIViewController {
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var linkTitleTextField: UITextField!
    @IBOutlet weak var linkURLTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let link:WebLink? = WebLinkController.sharedInstance.getActiveLink()
        if (link != nil)
        {
            linkTitleTextField.text = link?.title
            linkURLTextField.text = link?.urlStr
        }
    }
    
    
    //------------------------------------------------------------------------------
    // Mark: IBActions
    //------------------------------------------------------------------------------
    @IBAction func cancelPressed (sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func okPressed (sender: UIButton) {
        if (verify())
        {
            let title = linkTitleTextField.text!
            
            var url:String = linkURLTextField.text!
            if (url.rangeOfString("http://") == nil) {
                url = "http://" + url
            }
            let urlStr:String = url
            
            let link = PFObject(className:"PWebLink")
            link["title"] = title
            link["url"] = urlStr
            link.ACL = PFACL(user: PFUser.currentUser()!)
            link.ACL?.setPublicReadAccess(true)
            link.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    let newLink = WebLink()
                    newLink.initWithParse(link)
                    WebLinkController.sharedInstance.addWebLink(newLink)
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    // There was a problem, check error.description
                    // TODO Present Error
                }
            }
            
            
        }
    }

    
    private func verify () -> Bool
    {
        if (linkTitleTextField.text!.isEmpty)
        {
            showErrorAlert("Please input a web link title");
            return false;
        }
        
        if (linkURLTextField.text!.isEmpty)
        {
            showErrorAlert("Please input a web link URL");
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
