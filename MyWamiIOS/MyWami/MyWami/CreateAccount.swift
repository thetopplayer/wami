//
//  CreateAccount.swift
//  MyWami
//
//  Created by Robert Lanter on 4/29/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class CreateAccount: UIViewController, UITextViewDelegate  {
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var createAccountView = UIView()
    
    var userNameTxt = UITextField()
    var passwordTxt = UITextField()
    var retypePasswordTxt = UITextField()
    var emailTxt = UITextField()
    var profileNameTxt = UITextField()
    var firstNameTxt = UITextField()
    var lastNameTxt = UITextField()
    var teleNumberTxt = UITextField()
    var textView: UITextView!
    
    func createAccountDialog(createAccountView: UIView, closeBtn: UIButton) -> UIView {
        self.createAccountView = createAccountView
        
        let horizontalPlacement = CGFloat(40)
        let verticalPlacement = CGFloat(32)
        
        self.createAccountView.frame = CGRectMake(35, 65, 250, 480)
        self.createAccountView.backgroundColor = UIColor(red: 0xff/255, green: 0xff/255, blue: 0xff/255, alpha: 1.0)
        self.createAccountView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.createAccountView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Create Account"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 250, 30)
        self.createAccountView.addSubview(headingLbl)
        
        let descLbl1 = UILabel()
        descLbl1.text = "1. Create Simple Account"
        descLbl1.textColor = UIColor.blackColor()
        descLbl1.font = UIFont.boldSystemFontOfSize(10)
        descLbl1.frame = CGRectMake(horizontalPlacement, verticalPlacement, 250, 15)
        self.createAccountView.addSubview(descLbl1)
        
        let descLbl2 = UILabel()
        descLbl2.text = "2. Login"
        descLbl2.textColor = UIColor.blackColor()
        descLbl2.font = UIFont.boldSystemFontOfSize(10)
        descLbl2.frame = CGRectMake(horizontalPlacement, verticalPlacement + 12, 250, 15)
        self.createAccountView.addSubview(descLbl2)
        
        let descLbl3 = UILabel()
        descLbl3.text = "3. Start Using WAMI Immediatley"
        descLbl3.textColor = UIColor.blackColor()
        descLbl3.font = UIFont.boldSystemFontOfSize(10)
        descLbl3.frame = CGRectMake(horizontalPlacement, verticalPlacement + 24, 250, 15)
        self.createAccountView.addSubview(descLbl3)
        
        let descLbl4 = UILabel()
        descLbl4.text = "4. (Optional) Log onto www.mywami.com."
        descLbl4.textColor = UIColor.blackColor()
        descLbl4.font = UIFont.boldSystemFontOfSize(10)
        descLbl4.frame = CGRectMake(horizontalPlacement, verticalPlacement + 36, 250, 15)
        self.createAccountView.addSubview(descLbl4)
        
        let descLbl5 = UILabel()
        descLbl5.text = "Create deep profiles by adding audio,"
        descLbl5.textColor = UIColor.blackColor()
        descLbl5.font = UIFont.boldSystemFontOfSize(10)
        descLbl5.frame = CGRectMake(horizontalPlacement + 12, verticalPlacement + 48, 250, 15)
        self.createAccountView.addSubview(descLbl5)
        
        let descLbl6 = UILabel()
        descLbl6.text = "image, PDF, and text files."
        descLbl6.textColor = UIColor.blackColor()
        descLbl6.font = UIFont.boldSystemFontOfSize(10)
        descLbl6.frame = CGRectMake(horizontalPlacement + 13, verticalPlacement + 60, 250, 15)
        self.createAccountView.addSubview(descLbl6)
        
        let verticalPlacement2 = CGFloat(22)
        
        var requiredSymbol1 = getRequiredSymbol()
        requiredSymbol1.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 83, 20, 20)
        self.createAccountView.addSubview(requiredSymbol1)
        
        let txtFldBorderLbL1 = getLblBorder()
        self.userNameTxt = getTxtFld(self.userNameTxt, placeHolder: "Account Username")
        self.userNameTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 98, 220, 20)
        txtFldBorderLbL1.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 95, 230, 25)
        self.createAccountView.addSubview(txtFldBorderLbL1)
        self.createAccountView.addSubview(self.userNameTxt)

        var requiredSymbol2 = getRequiredSymbol()
        requiredSymbol2.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 123, 20, 20)
        self.createAccountView.addSubview(requiredSymbol2)
        
        let txtFldBorderLbL2 = getLblBorder()
        passwordTxt = getTxtFld(self.passwordTxt, placeHolder: "Password")
        passwordTxt.secureTextEntry = true
        passwordTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 138, 100, 20)
        txtFldBorderLbL2.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 135, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL2)
        self.createAccountView.addSubview(passwordTxt)
        
        var requiredSymbol3 = getRequiredSymbol()
        requiredSymbol3.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 123, 20, 20)
        self.createAccountView.addSubview(requiredSymbol3)
        
        let txtFldBorderLbL3 = getLblBorder()
        retypePasswordTxt = getTxtFld(self.retypePasswordTxt, placeHolder: "Retype Password")
        retypePasswordTxt.secureTextEntry = true
        retypePasswordTxt.frame = CGRectMake(135, verticalPlacement2 + 138, 100, 20)
        txtFldBorderLbL3.frame = CGRectMake(130, verticalPlacement2 + 135, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL3)
        self.createAccountView.addSubview(retypePasswordTxt)
        
        var requiredSymbol4 = getRequiredSymbol()
        requiredSymbol4.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 165, 20, 20)
        self.createAccountView.addSubview(requiredSymbol4)
        
        let txtFldBorderLbL4 = getLblBorder()
        emailTxt = getTxtFld(self.emailTxt, placeHolder: "Email Address")
        emailTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 180, 100, 20)
        txtFldBorderLbL4.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 177, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL4)
        self.createAccountView.addSubview(emailTxt)
        
        var requiredSymbol5 = getRequiredSymbol()
        requiredSymbol5.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 165, 20, 20)
        self.createAccountView.addSubview(requiredSymbol5)

        let txtFldBorderLbL5 = getLblBorder()
        profileNameTxt = getTxtFld(self.profileNameTxt, placeHolder: "First Profile Name")
        profileNameTxt.frame = CGRectMake(horizontalPlacement + 95, verticalPlacement2 + 180, 100, 20)
        txtFldBorderLbL5.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 177, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL5)
        self.createAccountView.addSubview(profileNameTxt)
        
        let requiredBlurbLbL = UILabel()
        requiredBlurbLbL.textColor = UIColor.orangeColor()
        requiredBlurbLbL.font = UIFont.boldSystemFontOfSize(12)
        requiredBlurbLbL.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 200, 110, 25)
        requiredBlurbLbL.text = "* Required Fields"
        self.createAccountView.addSubview(requiredBlurbLbL)
        
        let verticalPlacement3 = CGFloat(190)
        
        let optionalLbL = UILabel()
        optionalLbL.textColor = UIColor.grayColor()
        optionalLbL.font = UIFont.boldSystemFontOfSize(11)
        optionalLbL.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement3 + 60, 110, 25)
        optionalLbL.text = "Optional Fields"
        self.createAccountView.addSubview(optionalLbL)
        
        let txtFldBorderLbL6 = getLblBorder()
        firstNameTxt = getTxtFld(self.firstNameTxt, placeHolder: "First Name")
        firstNameTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement3 + 87, 100, 20)
        txtFldBorderLbL6.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement3 + 84, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL6)
        self.createAccountView.addSubview(firstNameTxt)
        
        let txtFldBorderLbL7 = getLblBorder()
        lastNameTxt = getTxtFld(self.lastNameTxt, placeHolder:  "Last Name")
        lastNameTxt.frame = CGRectMake(horizontalPlacement + 95, verticalPlacement3 + 87, 100, 20)
        txtFldBorderLbL7.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement3 + 84, 110, 25)
        self.createAccountView.addSubview(txtFldBorderLbL7)
        self.createAccountView.addSubview(lastNameTxt)
        
        let txtFldBorderLbL8 = getLblBorder()
        teleNumberTxt = getTxtFld(self.teleNumberTxt, placeHolder: "Telephone Number")
        teleNumberTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement3 + 122, 220, 20)
        txtFldBorderLbL8.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement3 + 119, 230, 25)
        self.createAccountView.addSubview(txtFldBorderLbL8)
        self.createAccountView.addSubview(teleNumberTxt)
        
        textView = UITextView()
        textView.font = UIFont.systemFontOfSize(12)
        textView.textAlignment = .Left
        textView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        textView.layer.borderWidth = 0.5
        textView.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement3 + 155, 230, 50)
        
        textView.text = "Profile Description"
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
        self.createAccountView.addSubview(textView)
        
        let verticalPlacement4 = CGFloat(250)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, verticalPlacement4 + 162, 230, 1)
        line.backgroundColor = UIColor.blackColor()
        self.createAccountView.addSubview(line)
        
        let createAccountBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        createAccountBtn.setTitle("Create", forState: UIControlState.Normal)
        createAccountBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        createAccountBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createAccountBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        createAccountBtn.showsTouchWhenHighlighted = true
        createAccountBtn.frame = CGRectMake(45, verticalPlacement4 + 180, 60, 23)
        createAccountBtn.addTarget(self, action: "createNewAccount", forControlEvents: UIControlEvents.TouchUpInside)
        self.createAccountView.addSubview(createAccountBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, verticalPlacement4 + 180, 60, 23)
        self.createAccountView.addSubview(closeBtn)
        
        addChildViewController(self)
        return self.createAccountView
    }
    
    func createNewAccount() {
        checkForRequiredFields()
    }
    
    // used for text view placeholder
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
 
    func checkForRequiredFields() {
        if self.userNameTxt.text == nil {
            self.createAccountView.makeToast(message: "Account Username is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if count(self.userNameTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            self.createAccountView.makeToast(message: "Account Username is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        let userNameRegex = NSRegularExpression(pattern: "^[a-zA-Z0-9_-]+$", options: nil, error: nil)!
        var nsString = self.userNameTxt.text as NSString
        var match = userNameRegex.numberOfMatchesInString(self.userNameTxt.text, options: nil, range: NSMakeRange(0, nsString.length))
        if match == 0 {
            self.createAccountView.makeToast(message: "Account Username must only contain letters, numbers, underscores, and hyphens", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        
        if self.passwordTxt.text == nil {
            self.createAccountView.makeToast(message: "Password is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if count(self.passwordTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            self.createAccountView.makeToast(message: "Password is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        let passwordRegex = NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&+-_])(?=\\S+$).{8,20}$", options: nil, error: nil)!
        var nsString1 = self.passwordTxt.text as NSString
        var match1 = passwordRegex.numberOfMatchesInString(self.passwordTxt.text, options: nil, range: NSMakeRange(0, nsString1.length))
        if match1 == 0 {
            self.createAccountView.makeToast(message: "Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number, and at least 1 of the following characters: ! @ # $ % ^ & - _\"", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        
        if self.retypePasswordTxt.text == nil {
            self.createAccountView.makeToast(message: "Retype Password is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if count(self.retypePasswordTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            self.createAccountView.makeToast(message: "Retype Password is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if self.passwordTxt.text != self.retypePasswordTxt.text {
            self.createAccountView.makeToast(message: "Password and Retype Password must be the same.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        
        if self.emailTxt.text == nil {
            self.createAccountView.makeToast(message: "Email address is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if count(self.emailTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            self.createAccountView.makeToast(message: "Email address is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        
        if self.profileNameTxt.text == nil {
            self.createAccountView.makeToast(message: "Profile Name is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if count(self.profileNameTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            self.createAccountView.makeToast(message: "Profile Name is a required field. Please enter a value.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
    }
    
    func getLblBorder() -> UILabel {
        let txtFldBorderLbL = UILabel()
        txtFldBorderLbL.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL.layer.borderWidth = 1.5
        
        return txtFldBorderLbL
    }
    
    func getTxtFld(txtFld: UITextField, placeHolder: String) -> UITextField {
//        var txtFld = UITextField()
        txtFld.backgroundColor = UIColor.whiteColor()
        txtFld.textColor = UIColor.blackColor()
        txtFld.font = UIFont.systemFontOfSize(12)
        txtFld.placeholder = placeHolder
        
        return txtFld
    }
    
    func getRequiredSymbol() -> UILabel {
        var requiredSymbol = UILabel()
        requiredSymbol.textColor = UIColor.orangeColor()
        requiredSymbol.font = UIFont.boldSystemFontOfSize(16)
        requiredSymbol.text = "*"
        
        return requiredSymbol
    }
    
    
}


//Pattern patternPassword = Pattern.compile("((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[#?!@$%^&*-_]).{8,20})");
//Matcher matcherPassword = patternPassword.matcher(password);
//if (!matcherPassword.matches()) {
//    Toast.makeText(context.getApplicationContext(), "Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number," +
//        " and at least 1 of the following characters: # ? ! @ $ % ^ & * - _\"", Toast.LENGTH_LONG).show();
//    return;
//}






