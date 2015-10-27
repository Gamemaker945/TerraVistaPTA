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
    
    
    //------------------------------------------------------------------------------
    // Mark: IBActions
    //------------------------------------------------------------------------------
    @IBAction func cancelPressed (sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func okPressed (sender: UIButton) {
        if (verify())
        {
            let link:WebLink = WebLink()
            link.title = linkTitleTextField.text!
            
            var url:String = linkURLTextField.text!
            if (url.rangeOfString("http://") == nil) {
                url = "http://" + url
            }
            link.urlStr = url
            
            WebLinkController.sharedInstance.addWebLink(link)
            self.navigationController?.popToRootViewControllerAnimated(true)
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
