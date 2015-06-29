//
//  ProfilerImageMoreInfo.swift
//  MyWami
//
//  Created by Robert Lanter on 5/28/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfilerImageMoreInfo: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    
    var moreInfoView = UIView()
    
    func moreInfoDialog(moreInfoView: UIView, imageFileDecription: String, imageName: String, imageFileName: String, closeBtn: UIButton) -> UIView {
        self.moreInfoView = moreInfoView
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.moreInfoView.frame = CGRectMake(25, 5, 270, 285)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.moreInfoView.frame = CGRectMake(25, 10, 270, 300)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.moreInfoView.frame = CGRectMake(50, 20, 270, 300)
        }
        else if DeviceType.IS_IPHONE_6P {
            self.moreInfoView.frame = CGRectMake(70, 30, 270, 300)
        }
        else if DeviceType.IS_IPAD {
            self.moreInfoView.frame = CGRectMake(25, 10, 270, 300)
        }
        else {
            self.moreInfoView.frame = CGRectMake(25, 10, 270, 300)
        }
        
//        self.moreInfoView.frame = CGRectMake(20, 10, 270, 300)
        self.moreInfoView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 0.92)
        self.moreInfoView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        self.moreInfoView.layer.cornerRadius = 5.0
        self.moreInfoView.layer.borderWidth = 1.0
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "More Info"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 270, 30)
        headingLbl.roundCorners(.TopLeft | .TopRight, radius: 5.0)
        self.moreInfoView.addSubview(headingLbl)
        
        let imageNameLbl = UILabel()
        imageNameLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        imageNameLbl.text = "Image Name"
        imageNameLbl.textColor = UIColor.blackColor()
        imageNameLbl.font = UIFont.boldSystemFontOfSize(12)
        imageNameLbl.frame = CGRectMake(10, 40, 80, 20)
        self.moreInfoView.addSubview(imageNameLbl)
        
        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        var imageNameTxt = UITextField()
        imageNameTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        imageNameTxt.textColor = UIColor.blackColor()
        imageNameTxt.font = UIFont.systemFontOfSize(12)
        imageNameTxt.enabled = false
        imageNameTxt.text = imageName
        imageNameTxt.frame = CGRectMake(13, 63, 242, 20)
        txtFldBorderLbL1.frame = CGRectMake(8, 60, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL1)
        moreInfoView.addSubview(imageNameTxt)
        
        let imageFileNameLbl = UILabel()
        imageFileNameLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        imageFileNameLbl.text = "File Name"
        imageFileNameLbl.textColor = UIColor.blackColor()
        imageFileNameLbl.font = UIFont.boldSystemFontOfSize(12)
        imageFileNameLbl.frame = CGRectMake(10, 95, 100, 20)
        self.moreInfoView.addSubview(imageFileNameLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        var imageFileNameTxt = UITextField()
        imageFileNameTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        imageFileNameTxt.textColor = UIColor.blackColor()
        imageFileNameTxt.font = UIFont.systemFontOfSize(12)
        imageFileNameTxt.enabled = false
        imageFileNameTxt.text = imageFileName
        imageFileNameTxt.frame = CGRectMake(13, 118, 242, 20)
        txtFldBorderLbL2.frame = CGRectMake(8, 115, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL2)
        moreInfoView.addSubview(imageFileNameTxt)
        
        let imageFileDecriptionLbl = UILabel()
        imageFileDecriptionLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        imageFileDecriptionLbl.text = "Description"
        imageFileDecriptionLbl.textColor = UIColor.blackColor()
        imageFileDecriptionLbl.font = UIFont.boldSystemFontOfSize(12)
        imageFileDecriptionLbl.frame = CGRectMake(10, 150, 100, 20)
        self.moreInfoView.addSubview(imageFileDecriptionLbl)
        
        var imageFileDecriptionView = UITextView()
        imageFileDecriptionView.font = UIFont.systemFontOfSize(12)
        imageFileDecriptionView.textAlignment = .Left
        imageFileDecriptionView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        imageFileDecriptionView.layer.borderWidth = 1.5
        imageFileDecriptionView.editable = false
        imageFileDecriptionView.text = imageFileDecription
        imageFileDecriptionView.textColor = UIColor.blackColor()
        imageFileDecriptionView.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        imageFileDecriptionView.frame = CGRectMake(10, 170, 250, 80)
        self.moreInfoView.addSubview(imageFileDecriptionView)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        if DeviceType.IS_IPHONE_4_OR_LESS {
            closeBtn.frame = CGRectMake(110, 257, 60, 20)
        }
        else {
            closeBtn.frame = CGRectMake(110, 265, 60, 20)
        }
        self.moreInfoView.addSubview(closeBtn)
        
        return self.moreInfoView
        
    }
}