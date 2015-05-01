//
//  CreateAccount.swift
//  MyWami
//
//  Created by Robert Lanter on 4/29/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class CreateAccount: UIViewController {
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var uview = UIView()
    
    func createAccountDialog(createAccountView: UIView, closeBtn: UIButton, createAccountBtn: UIButton) -> UIView {
        self.uview = createAccountView
        
        var horizontalPlacement = CGFloat(40)
        var verticalPlacement = CGFloat(32)
        
        createAccountView.frame = CGRectMake(35, 65, 250, 480)
        createAccountView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        createAccountView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        createAccountView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Create Account"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 250, 30)
        createAccountView.addSubview(headingLbl)
        
        let descLbl1 = UILabel()
        descLbl1.text = "1. Create Simple Account"
        descLbl1.textColor = UIColor.blackColor()
        descLbl1.font = UIFont.boldSystemFontOfSize(10)
        descLbl1.frame = CGRectMake(horizontalPlacement, verticalPlacement, 250, 15)
        createAccountView.addSubview(descLbl1)
        
        let descLbl2 = UILabel()
        descLbl2.text = "2. Login"
        descLbl2.textColor = UIColor.blackColor()
        descLbl2.font = UIFont.boldSystemFontOfSize(10)
        descLbl2.frame = CGRectMake(horizontalPlacement, verticalPlacement + 12, 250, 15)
        createAccountView.addSubview(descLbl2)
        
        let descLbl3 = UILabel()
        descLbl3.text = "3. Start Using WAMI Immediatley"
        descLbl3.textColor = UIColor.blackColor()
        descLbl3.font = UIFont.boldSystemFontOfSize(10)
        descLbl3.frame = CGRectMake(horizontalPlacement, verticalPlacement + 24, 250, 15)
        createAccountView.addSubview(descLbl3)
        
        let descLbl4 = UILabel()
        descLbl4.text = "4. (Optional) Log onto www.mywami.com."
        descLbl4.textColor = UIColor.blackColor()
        descLbl4.font = UIFont.boldSystemFontOfSize(10)
        descLbl4.frame = CGRectMake(horizontalPlacement, verticalPlacement + 36, 250, 15)
        createAccountView.addSubview(descLbl4)
        
        let descLbl5 = UILabel()
        descLbl5.text = "Create deep profiles by adding audio,"
        descLbl5.textColor = UIColor.blackColor()
        descLbl5.font = UIFont.boldSystemFontOfSize(10)
        descLbl5.frame = CGRectMake(horizontalPlacement + 12, verticalPlacement + 48, 250, 15)
        createAccountView.addSubview(descLbl5)
        
        let descLbl6 = UILabel()
        descLbl6.text = "image, PDF, and text files."
        descLbl6.textColor = UIColor.blackColor()
        descLbl6.font = UIFont.boldSystemFontOfSize(10)
        descLbl6.frame = CGRectMake(horizontalPlacement + 13, verticalPlacement + 60, 250, 15)
        createAccountView.addSubview(descLbl6)
        
        var verticalPlacement2 = CGFloat(22)
        
        var requiredSymbol1 = getRequiredSymbol()
        requiredSymbol1.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 83, 20, 20)
        createAccountView.addSubview(requiredSymbol1)
        
        let txtFldBorderLbL1 = getLblBorder()
        var userNameTxt = getTxtFld("Account Username")
        userNameTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 98, 220, 20)
        txtFldBorderLbL1.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 95, 230, 25)
        createAccountView.addSubview(txtFldBorderLbL1)
        createAccountView.addSubview(userNameTxt)

        var requiredSymbol2 = getRequiredSymbol()
        requiredSymbol2.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 123, 20, 20)
        createAccountView.addSubview(requiredSymbol2)
        
        let txtFldBorderLbL2 = getLblBorder()
        var passwordTxt = getTxtFld("Password")
        passwordTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 138, 100, 20)
        txtFldBorderLbL2.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 135, 110, 25)
        createAccountView.addSubview(txtFldBorderLbL2)
        createAccountView.addSubview(passwordTxt)
        
        var requiredSymbol3 = getRequiredSymbol()
        requiredSymbol3.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 123, 20, 20)
        createAccountView.addSubview(requiredSymbol3)
        
        let txtFldBorderLbL3 = getLblBorder()
        var retypePasswordTxt = getTxtFld("Retype Password")
        retypePasswordTxt.frame = CGRectMake(135, verticalPlacement2 + 138, 100, 20)
        txtFldBorderLbL3.frame = CGRectMake(130, verticalPlacement2 + 135, 110, 25)
        createAccountView.addSubview(txtFldBorderLbL3)
        createAccountView.addSubview(retypePasswordTxt)
        
        var requiredSymbol4 = getRequiredSymbol()
        requiredSymbol4.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 165, 20, 20)
        createAccountView.addSubview(requiredSymbol4)
        
        let txtFldBorderLbL4 = getLblBorder()
        var emailTxt = getTxtFld("Email Address")
        emailTxt.frame = CGRectMake(horizontalPlacement - 25, verticalPlacement2 + 180, 100, 20)
        txtFldBorderLbL4.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 177, 110, 25)
        createAccountView.addSubview(txtFldBorderLbL4)
        createAccountView.addSubview(emailTxt)
        
        var requiredSymbol5 = getRequiredSymbol()
        requiredSymbol5.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 165, 20, 20)
        createAccountView.addSubview(requiredSymbol5)

        let txtFldBorderLbL5 = getLblBorder()
        var profileNameTxt = getTxtFld("First Profile Name")
        profileNameTxt.frame = CGRectMake(horizontalPlacement + 95, verticalPlacement2 + 180, 100, 20)
        txtFldBorderLbL5.frame = CGRectMake(horizontalPlacement + 90, verticalPlacement2 + 177, 110, 25)
        createAccountView.addSubview(txtFldBorderLbL5)
        createAccountView.addSubview(profileNameTxt)
        
        let requiredBlurbLbL = UILabel()
        requiredBlurbLbL.textColor = UIColor.orangeColor()
        requiredBlurbLbL.font = UIFont.boldSystemFontOfSize(12)
        requiredBlurbLbL.frame = CGRectMake(horizontalPlacement - 30, verticalPlacement2 + 200, 110, 25)
        requiredBlurbLbL.text = "* Required Fields"
        createAccountView.addSubview(requiredBlurbLbL)
        
        return createAccountView
    }

    func getLblBorder() -> UILabel {
        let txtFldBorderLbL = UILabel()
        txtFldBorderLbL.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL.layer.borderWidth = 1.5
        
        return txtFldBorderLbL
    }
    
    func getTxtFld(placeHolder: String) -> UITextField {
        var txtFld = UITextField()
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








