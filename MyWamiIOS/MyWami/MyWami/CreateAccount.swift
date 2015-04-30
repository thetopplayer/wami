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
    
    func createAccountDialog(createAccountView: UIView, closeBtn: UIButton, transmitBtn: UIButton) -> UIView {
        self.uview = createAccountView
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Create Account"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        createAccountView.addSubview(headingLbl)
        
        return createAccountView
    }

}