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
    
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    
    let UTILITIES = Utilities()
    var userPassword: String!
    var userName: String!
    var userId: String!
    var userIdentityProfileId: String!
    var userModel = UserModel()
    let sqliteHelper = SQLiteHelper()
    var segue = UIStoryboardSegue()
    var createAccountBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton

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
        if let userModel = sqliteHelper.getUserInfo() {
            self.userName = userModel.getUserName()
            self.userId = String(userModel.getUserId())
            self.userPassword = userModel.getUserPassword()
            self.usernameText.text = self.userName
            self.passwordText.text = self.userPassword
        }
        // Login Button
        let loginBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        loginBtn.setTitle("Login", forState: UIControlState.Normal)
        loginBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        loginBtn.showsTouchWhenHighlighted = true
        loginBtn.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Create Account
        self.createAccountBtn.setTitle("Create Wami Account", forState: UIControlState.Normal)
        self.createAccountBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        self.createAccountBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.createAccountBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        self.createAccountBtn.showsTouchWhenHighlighted = true
        self.createAccountBtn.addTarget(self, action: "createAccountAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        var imageView = UIImageView()
        var logo  = UIImage(named: "logo")
        imageView.image = logo
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            loginBtn.frame = CGRectMake(130, 280,  65, 30)
            self.createAccountBtn.frame = CGRectMake(77, 340,  167, 30)
            imageView.frame = CGRectMake(70, 355, 190, 130)
        }
        else if DeviceType.IS_IPHONE_5 {
            loginBtn.frame = CGRectMake(128, 310, 65, 30)
            self.createAccountBtn.frame = CGRectMake(77, 374, 167, 30)
            imageView.frame = CGRectMake(65, 390, 190, 130)
        }
        else if DeviceType.IS_IPHONE_6 {
            loginBtn.frame = CGRectMake(160, 310,  65, 30)
            self.createAccountBtn.frame = CGRectMake(110, 380,  167, 30)
            imageView.frame = CGRectMake(95, 420, 190, 130)
        }
        else if DeviceType.IS_IPHONE_6P {
            loginBtn.frame = CGRectMake(175, 310,  65, 30)
            self.createAccountBtn.frame = CGRectMake(125, 385,  167, 30)
            imageView.frame = CGRectMake(65, 390, 190, 130)
        }
        else if DeviceType.IS_IPAD {
            loginBtn.frame = CGRectMake(350, 310,  65, 30)
            self.createAccountBtn.frame = CGRectMake(350, 310,  57, 30)
            imageView.frame = CGRectMake(65, 390, 190, 130)
        }
        else {
            loginBtn.frame = CGRectMake(350, 310,  65, 30)
            self.createAccountBtn.frame = CGRectMake(350, 310,  57, 30)
            imageView.frame = CGRectMake(65, 390, 190, 130)
        }
        
        view.addSubview(loginBtn)
        view.addSubview(self.createAccountBtn)
        view.addSubview(imageView)
    }

    func loginButtonPressed() {
        var username = self.usernameText.text
        var password = self.passwordText.text
        
        if (username.isEmpty || password.isEmpty) {
            self.view.makeToast(message: "Please enter a Username and Password", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        
        let GET_USER_DATA = UTILITIES.IP + "get_user_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_USER_DATA, params: ["param1": username, "param2": password])
        getUserData(jsonData)
  
        performSegueWithIdentifier("showProfileCollection", sender: nil)
        var svc = segue.destinationViewController as! ProfileCollectionController;
        svc.userName = self.userName
        svc.userId = self.userId
        svc.userIdentityProfileId = self.userIdentityProfileId
        userModel.setUserId(self.userId.toInt()!)
        userModel.setUserName(self.userName)
        userModel.setUserPassword(self.userPassword )
        sqliteHelper.saveUserInfo(userModel)

    }
    
    var createAccountViewDialog = UIView()
    var createAccount = CreateAccount()
    func createAccountAction() {
        var createAccountView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeCreateAccountDialog", forControlEvents: UIControlEvents.TouchUpInside)
        var createNewAccountBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton        
        createNewAccountBtn.addTarget(self, action: "createNewAccount", forControlEvents: UIControlEvents.TouchUpInside)
        self.createAccountViewDialog = createAccount.createAccountDialog(createAccountView, closeBtn: closeBtn, createNewAccountBtn: createNewAccountBtn)
        view.addSubview(self.createAccountViewDialog)
    }
    func closeCreateAccountDialog() {
        self.createAccountViewDialog.removeFromSuperview()
    }
    func createNewAccount() {
        var retCode = self.createAccount.processAccount()
        if retCode {
            self.view.makeToast(message: "Congrats...Account created. Login and start connecting...", duration: HRToastDefaultDuration, position: HRToastPositionDefault)
            self.usernameText.text = self.createAccount.getUserName()
            self.passwordText.text = self.createAccount.getPassword()
            closeCreateAccountDialog()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        sqliteHelper.cleanup()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.segue = segue
    }

    func getUserData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            self.userId = jsonData["user_info"][0]["user_id"].string!
            self.userName = jsonData["user_info"][0]["username"].string!
            self.userPassword = jsonData["user_info"][0]["password"].string!

            let GET_DEFAULT_IDENTITY_PROFILE_ID = UTILITIES.IP + "get_default_identity_profile_id.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_DEFAULT_IDENTITY_PROFILE_ID, params: ["param1": self.userId])
            getDefaultIdentityProfileId(jsonData)
        }
    }

    func getDefaultIdentityProfileId (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)

            }
        }
        else {
            self.userIdentityProfileId = jsonData["default_identity_profile_id"][0]["identity_profile_id"].string!
        }
    }    
}

