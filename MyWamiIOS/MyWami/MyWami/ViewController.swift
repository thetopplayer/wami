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
    @IBOutlet var createAccountBtn: UIButton!
    
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    
    let UTILITIES = Utilities()
    var userPassword: String!
    var userName: String!
    var userId: String!
    var userIdentityProfileId: String!
    var userModel = UserModel()
    let sqliteHelper = SQLiteHelper()

    var createAccountViewDialog = UIView()
    var createAccountView = UIView()
    var createAccount = CreateAccount()
    @IBAction func createAccountAction(sender: AnyObject) {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeCreateAccountDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let createAccountBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        createAccountBtn.addTarget(self, action: "createNewAccount", forControlEvents: UIControlEvents.TouchUpInside)
        createAccountViewDialog = createAccount.createAccountDialog(createAccountView, closeBtn: closeBtn, createAccountBtn: createAccountBtn)
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
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        var username = self.usernameText.text
        var password = self.passwordText.text

        if (username.isEmpty || password.isEmpty) {
            self.view.makeToast(message: "Please enter a Username and Password", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }

        let GET_USER_DATA = UTILITIES.IP + "get_user_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_USER_DATA, params: ["param1": username, "param2": password])
        getUserData(jsonData)
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
        if let userModel = sqliteHelper.getUserInfo() {
            self.userName = userModel.getUserName()
            self.userId = String(userModel.getUserId())
            self.userPassword = userModel.getUserPassword()
            self.usernameText.text = self.userName
            self.passwordText.text = self.userPassword
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        sqliteHelper.cleanup()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfileCollection") {
            var svc = segue.destinationViewController as! ProfileCollectionController;
            svc.userName = self.userName
            svc.userId = self.userId
            svc.userIdentityProfileId = self.userIdentityProfileId
            userModel.setUserId(self.userId.toInt()!)
            userModel.setUserName(self.userName)
            userModel.setUserPassword(self.userPassword )
            sqliteHelper.saveUserInfo(userModel)
        }
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
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("showProfileCollection", sender: self)
            }
        }
    }    
}

