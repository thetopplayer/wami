//
//  ViewController.swift
//  MyWami
//
//  Created by Robert Lanter on 2/16/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    @IBAction func loginButtonPressed(sender: AnyObject) {
        var username = self.usernameText.text
        var password = self.passwordText.text
        
        if (username.isEmpty || password.isEmpty) {
            var alertController = UIAlertController(title: "", message: "Please enter a Username and Password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            var height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.20)
            alertController.view.addConstraint(height);
            alertController.view.backgroundColor = UIColor.blackColor()
            alertController.view.tintColor = UIColor.blackColor()
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let jsonData = JsonGetData()
        let CONSTANTS = Constants()
        let GET_USER_DATA = CONSTANTS.IP + "get_user_data.php"
        var data: String
        data = jsonData.jsonGetData(GET_USER_DATA, params: ["param1":"rlanter", "param2":"st00p!DD"])
        println ("Data = '\(data)'")

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "showProfileCollection" {
            if (usernameText.text.isEmpty || passwordText.text.isEmpty) {
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_heading.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

