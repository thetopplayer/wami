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
    var retCode: Int = 0

    @IBAction func loginButtonPressed(sender: AnyObject) {
        var username = self.usernameText.text
        var password = self.passwordText.text
        
        if (username.isEmpty || password.isEmpty) {
            alertMessage("Please enter a Username and Password")
            return
        }
        let jsonData = JsonGetData()
        let CONSTANTS = Constants()
        let GET_USER_DATA = CONSTANTS.IP + "get_user_data.php"
        jsonData.jsonGetData(processJsonData, url: GET_USER_DATA, params: ["param1": username, "param2": password])
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "showProfileCollection" {
            if (usernameText.text.isEmpty || passwordText.text.isEmpty) {
                return false
            }
            if self.retCode == 1 {
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

    func processJsonData (jsonData: JSON) {
        self.retCode = jsonData["ret_code"].int!
//        var retCode = jsonData["ret_code"]
        if self.retCode == 1 {
//            self.retCode = retCode.int!
            var message = jsonData["message"].string
            alertMessage(message!)
        }
    }

    @IBAction func alertMessage(message: NSString) {
        var alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        var height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.20)
        alertController.view.addConstraint(height);
        alertController.view.backgroundColor = UIColor.blackColor()
        alertController.view.tintColor = UIColor.blackColor()
        presentViewController(alertController, animated: true, completion: nil)
        return
    }
}

