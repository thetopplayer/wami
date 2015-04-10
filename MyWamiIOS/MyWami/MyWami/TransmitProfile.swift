//
//  TransmitProfile.swift
//  MyWami
//
//  Created by Robert Lanter on 4/9/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class TransmitProfile: UIViewController {
    func transmitProfile(transmitProfileView: UIView, closeBtn: UIButton, transmitBtn: UIButton) -> UIView {
            
        transmitProfileView.frame = CGRectMake(45, 200, 240, 215)
        transmitProfileView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        transmitProfileView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        transmitProfileView.layer.borderWidth = 1.5
            
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Transmit This Profile"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        transmitProfileView.addSubview(headingLbl)
        
        let profileNameLbl = UILabel()
        profileNameLbl.backgroundColor = UIColor.whiteColor()
        profileNameLbl.text = "Profile Name"
        profileNameLbl.textColor = UIColor.blackColor()
        profileNameLbl.font = UIFont.boldSystemFontOfSize(13)
        profileNameLbl.frame = CGRectMake(10, 40, 100, 20)
        transmitProfileView.addSubview(profileNameLbl)
        
        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        let profileNameTxt = UITextField()
        profileNameTxt.backgroundColor = UIColor.whiteColor()
        profileNameTxt.textColor = UIColor.blackColor()
        profileNameTxt.font = UIFont.systemFontOfSize(12)
        profileNameTxt.frame = CGRectMake(15, 63, 210, 20)
        profileNameTxt.placeholder = "Enter destination Profile Name"
        txtFldBorderLbL1.frame = CGRectMake(10, 60, 220, 25)
        transmitProfileView.addSubview(txtFldBorderLbL1)
        transmitProfileView.addSubview(profileNameTxt)
        
        let emailAddressLbl = UILabel()
        emailAddressLbl.backgroundColor = UIColor.whiteColor()
        emailAddressLbl.text = "Email Address"
        emailAddressLbl.textColor = UIColor.blackColor()
        emailAddressLbl.font = UIFont.boldSystemFontOfSize(12)
        emailAddressLbl.frame = CGRectMake(10, 100, 100, 20)
        transmitProfileView.addSubview(emailAddressLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        let emailAddressTxt = UITextField()
        emailAddressTxt.backgroundColor = UIColor.whiteColor()
        emailAddressTxt.textColor = UIColor.blackColor()
        emailAddressTxt.font = UIFont.systemFontOfSize(13)
        emailAddressTxt.frame = CGRectMake(15, 123, 210, 20)
        emailAddressTxt.placeholder = "Enter destination Email Address"
        txtFldBorderLbL2.frame = CGRectMake(10, 120, 220, 25)
        transmitProfileView.addSubview(txtFldBorderLbL2)
        transmitProfileView.addSubview(emailAddressTxt)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 165, 220, 1)
        line.backgroundColor = UIColor.blackColor()
        transmitProfileView.addSubview(line)
        
        transmitBtn.setTitle("Transmit", forState: UIControlState.Normal)
        transmitBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        transmitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        transmitBtn.showsTouchWhenHighlighted = true
        transmitBtn.frame = CGRectMake(45, 180, 60, 20)
        transmitProfileView.addSubview(transmitBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 180, 60, 20)
        transmitProfileView.addSubview(closeBtn)
        
        return transmitProfileView
    }
}
