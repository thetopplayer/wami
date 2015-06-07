//
//  SearchMoreInfo.swift
//  MyWami
//
//  Created by Robert Lanter on 5/18/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class SearchMoreInfo: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    
    var moreInfoView = UIView()
    
    func moreInfoDialog(moreInfoView: UIView, profileName: String, tag: String, description: String, closeBtn: UIButton) -> UIView {
        self.moreInfoView = moreInfoView
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.moreInfoView.frame = CGRectMake(45, 30, 240, 300)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.moreInfoView.frame = CGRectMake(30, 80, 270, 300)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.moreInfoView.frame = CGRectMake(65, 40, 240, 300)
        }
        else if DeviceType.IS_IPHONE_6P {
            self.moreInfoView.frame = CGRectMake(80, 40, 240, 300)
        }
        else if DeviceType.IS_IPAD {
            self.moreInfoView.frame = CGRectMake(35, 65, 250, 422)
        }
        else {
            self.moreInfoView.frame = CGRectMake(35, 65, 250, 422)
        }

        self.moreInfoView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.moreInfoView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.moreInfoView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "More Info"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 270, 30)
        self.moreInfoView.addSubview(headingLbl)
        
        let profileNameLbl = UILabel()
        profileNameLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        profileNameLbl.text = "Profile Name"
        profileNameLbl.textColor = UIColor.blackColor()
        profileNameLbl.font = UIFont.boldSystemFontOfSize(12)
        profileNameLbl.frame = CGRectMake(10, 40, 80, 20)
        self.moreInfoView.addSubview(profileNameLbl)

        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        var profileNameTxt = UITextField()
        profileNameTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        profileNameTxt.textColor = UIColor.blackColor()
        profileNameTxt.font = UIFont.systemFontOfSize(12)
        profileNameTxt.enabled = false
        profileNameTxt.text = profileName
        profileNameTxt.frame = CGRectMake(13, 63, 242, 20)
        txtFldBorderLbL1.frame = CGRectMake(8, 60, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL1)
        moreInfoView.addSubview(profileNameTxt)
        
        let tagLbl = UILabel()
        tagLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        tagLbl.text = "Tag Keywords"
        tagLbl.textColor = UIColor.blackColor()
        tagLbl.font = UIFont.boldSystemFontOfSize(12)
        tagLbl.frame = CGRectMake(10, 95, 100, 20)
        self.moreInfoView.addSubview(tagLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        var tagTxt = UITextField()
        tagTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        tagTxt.textColor = UIColor.blackColor()
        tagTxt.font = UIFont.systemFontOfSize(12)
        tagTxt.enabled = false
        tagTxt.text = tag
        tagTxt.frame = CGRectMake(13, 118, 242, 20)
        txtFldBorderLbL2.frame = CGRectMake(8, 115, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL2)
        moreInfoView.addSubview(tagTxt)
        
        let descriptionLbl = UILabel()
        descriptionLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        descriptionLbl.text = "Description"
        descriptionLbl.textColor = UIColor.blackColor()
        descriptionLbl.font = UIFont.boldSystemFontOfSize(12)
        descriptionLbl.frame = CGRectMake(10, 150, 100, 20)
        self.moreInfoView.addSubview(descriptionLbl)
        
        var descriptionTxtView = UITextView()
        descriptionTxtView.font = UIFont.systemFontOfSize(12)
        descriptionTxtView.textAlignment = .Left
        descriptionTxtView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        descriptionTxtView.layer.borderWidth = 1.5
        descriptionTxtView.editable = false
        descriptionTxtView.text = description
        descriptionTxtView.textColor = UIColor.blackColor()
        descriptionTxtView.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        descriptionTxtView.frame = CGRectMake(10, 170, 250, 80)
        self.moreInfoView.addSubview(descriptionTxtView)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 260, 250, 1)
        line.backgroundColor = UIColor.blackColor()
        moreInfoView.addSubview(line)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(110, 270, 60, 20)
        self.moreInfoView.addSubview(closeBtn)
        
        return self.moreInfoView
        
    }
}