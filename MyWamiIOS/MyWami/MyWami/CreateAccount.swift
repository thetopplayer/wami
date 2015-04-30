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
        
        createAccountView.frame = CGRectMake(35, 70, 250, 450)
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
        descLbl1.textAlignment = NSTextAlignment.Center
        descLbl1.textColor = UIColor.blackColor()
        descLbl1.font = UIFont.boldSystemFontOfSize(11)
        descLbl1.frame = CGRectMake(0, 40, 250, 15)
        createAccountView.addSubview(descLbl1)
        
        let descLbl2 = UILabel()
        descLbl2.text = "2. Login"
        descLbl2.textAlignment = NSTextAlignment.Center
        descLbl2.textColor = UIColor.blackColor()
        descLbl2.font = UIFont.boldSystemFontOfSize(11)
        descLbl2.frame = CGRectMake(0, 55, 250, 15)
        createAccountView.addSubview(descLbl2)
        
        let descLbl3 = UILabel()
        descLbl3.text = "3. Start Using WAMI Immediatley"
        descLbl3.textAlignment = NSTextAlignment.Center
        descLbl3.textColor = UIColor.blackColor()
        descLbl3.font = UIFont.boldSystemFontOfSize(11)
        descLbl3.frame = CGRectMake(0, 70, 250, 15)
        createAccountView.addSubview(descLbl3)
        
        let descLbl4 = UILabel()
        
        
        
        return createAccountView
    }

}