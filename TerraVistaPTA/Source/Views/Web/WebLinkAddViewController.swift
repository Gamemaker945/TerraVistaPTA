//
//  WebLinkAddViewController.swift
//  TerraVistaPTA
//
//  Created by Christian Henne on 9/15/15.
//  Copyright (c) 2015 Brain Glove Apps. All rights reserved.
//
import UIKit
import Parse

class WebLinkAddViewController: UIViewController {
    
    //------------------------------------------------------------------------------
    // VARS
    //------------------------------------------------------------------------------
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var linkTitleTextField: UITextField!
    @IBOutlet weak var linkURLTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet var navTitle: UINavigationItem!
    
    
    //------------------------------------------------------------------------------
    // Mark: Lifecycle Methods
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let link:WebLink? = WebLinkController.sharedInstance.getActive () as? WebLink
        if (link != nil)
        {
            linkTitleTextField.text = link?.title
            linkURLTextField.text = link?.urlStr
            navTitle.title = "Edit Web link"
        }
    }
    
    
    //------------------------------------------------------------------------------
    // Mark: IBActions
    //------------------------------------------------------------------------------
    @IBAction func okPressed (sender: UIButton) {
        if (verify())
        {
            let title = linkTitleTextField.text!
            
            var url:String = linkURLTextField.text!
            if (url.rangeOfString("http://") == nil) {
                url = "http://" + url
            }
            let urlStr:String = url
            
            var link:WebLink? = WebLinkController.sharedInstance.getActive() as? WebLink;
            if (link == nil)
            {
                link = WebLink()
                link?.pObj = PFObject(className:"PWebLink")
                link?.pObj!.ACL = PFACL(user: PFUser.currentUser()!)
                link?.pObj!.ACL?.setPublicReadAccess(true)
                link?.order = WebLinkController.sharedInstance.count()
            }
            link?.title = title
            link?.urlStr = urlStr
            
            WebLinkController.sharedInstance.update(link!, completion: { (hasError, error) -> Void in
                if (!hasError) {
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    ParseErrorHandler.showError(self, errorCode: error?.code)
                }
            })
        }
    }

    
    private func verify () -> Bool
    {
        if (linkTitleTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input a web link title");
            return false;
        }
        
        if (linkURLTextField.text!.isEmpty)
        {
            ParseErrorHandler.showError(self, errorMsg:"Please input a web link URL");
            return false;
        }
        
        return true;
    }
}
