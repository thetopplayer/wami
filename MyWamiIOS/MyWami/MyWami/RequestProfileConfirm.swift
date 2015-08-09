//
//  RequestProfileConfirm.swift
//  MyWami
//
//  Created by Robert Lanter on 5/19/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class RequestProfileConfirm: UIViewController {
    let UTILITIES = Utilities()
    var confirmView = UIView()
    
    func confirmDialog(confirmView: UIView, cancelBtn: UIButton, requestBtn: UIButton) -> UIView {
        self.confirmView = confirmView
        
        self.confirmView.frame = CGRectMake(55, 150, 220, 180)
        self.confirmView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 0.92)
        self.confirmView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        self.confirmView.layer.cornerRadius = 5.0
        self.confirmView.layer.borderWidth = 1.0
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Request Profile Confirmation"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 220, 30)
        headingLbl.roundCorners(.TopLeft | .TopRight, radius: 5.0)
        self.confirmView.addSubview(headingLbl)
       
        var confirmMsgTxtView = UITextView()
        confirmMsgTxtView.font = UIFont.systemFontOfSize(12)
        confirmMsgTxtView.textAlignment = .Center
        confirmMsgTxtView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        confirmMsgTxtView.layer.borderWidth = 1.5
        confirmMsgTxtView.editable = false
        confirmMsgTxtView.text = "You are about to send REQUEST(s) to subscribe/connect to the chosen profile(s) adding to your collection. Are you sure?"
        confirmMsgTxtView.textColor = UIColor.blackColor()
        confirmMsgTxtView.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        confirmMsgTxtView.frame = CGRectMake(20, 40, 180, 90)
        self.confirmView.addSubview(confirmMsgTxtView)
        
        requestBtn.setTitle("Send Request(s)", forState: UIControlState.Normal)
        requestBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        requestBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        requestBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        requestBtn.showsTouchWhenHighlighted = true
        requestBtn.frame = CGRectMake(20, 140, 110, 25)
        self.confirmView.addSubview(requestBtn)
        
        cancelBtn.setTitle("Close", forState: UIControlState.Normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cancelBtn.showsTouchWhenHighlighted = true
        cancelBtn.frame = CGRectMake(145, 140, 55, 25)
        self.confirmView.addSubview(cancelBtn)
        
        return self.confirmView

    }
}