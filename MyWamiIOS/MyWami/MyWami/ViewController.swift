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
    
    let JSONDATA = JsonGetData()
    let UTILITIES = Utilities()
    var userName: String!
    var userId: String!
    var identityProfileId: String!

    @IBAction func loginButtonPressed(sender: AnyObject) {
        var username = self.usernameText.text
        var password = self.passwordText.text
        
        if (username.isEmpty || password.isEmpty) {
            UTILITIES.alertMessage("Please enter a Username and Password", viewController: self)
            return
        }

        let GET_USER_DATA = UTILITIES.IP + "get_user_data.php"
        JSONDATA.jsonGetData(getUserData, url: GET_USER_DATA, params: ["param1": username, "param2": password])

        usleep(100000)

        let GET_DEFAULT_IDENTITY_PROFILE_ID = UTILITIES.IP + "get_default_identity_profile_id.php"
        JSONDATA.jsonGetData(getDefaultIdentityProfileId, url: GET_DEFAULT_IDENTITY_PROFILE_ID, params: ["param1": self.userId])
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black

        let titleBar = UIImage(named: "actionbar_login.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfileCollection") {
            var svc = segue.destinationViewController as ProfileCollectionController;
            svc.userName = self.userName
            svc.userId = self.userId
            svc.identityProfileId = self.identityProfileId
        }
    }

    // Callback func - getUserData
    func getUserData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            self.userId = jsonData["user_info"][0]["user_id"].string!
            self.userName = jsonData["user_info"][0]["username"].string!
        }
    }

    // Callback func - getDefaultIdentityProfileId
    func getDefaultIdentityProfileId (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            self.identityProfileId = jsonData["default_identity_profile_id"][0]["identity_profile_id"].string!
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("showProfileCollection", sender: self)
            }
        }


    }
}

