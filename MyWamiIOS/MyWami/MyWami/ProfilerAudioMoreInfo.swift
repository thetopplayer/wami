//
//  ProfilerAudioMoreInfo.swift
//  MyWami
//
//  Created by Robert Lanter on 5/27/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfilerAudioMoreInfo: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    
    var moreInfoView = UIView()
    
    func moreInfoDialog(moreInfoView: UIView, audioFileDecription: String, audioSongTitle: String, audioFileName: String, closeBtn: UIButton) -> UIView {
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
        
        let songTitleLbl = UILabel()
        songTitleLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        songTitleLbl.text = "Song Title"
        songTitleLbl.textColor = UIColor.blackColor()
        songTitleLbl.font = UIFont.boldSystemFontOfSize(12)
        songTitleLbl.frame = CGRectMake(10, 40, 80, 20)
        self.moreInfoView.addSubview(songTitleLbl)
        
        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        var songTitleTxt = UITextField()
        songTitleTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        songTitleTxt.textColor = UIColor.blackColor()
        songTitleTxt.font = UIFont.systemFontOfSize(12)
        songTitleTxt.enabled = false
        songTitleTxt.text = audioSongTitle
        songTitleTxt.frame = CGRectMake(13, 63, 242, 20)
        txtFldBorderLbL1.frame = CGRectMake(8, 60, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL1)
        moreInfoView.addSubview(songTitleTxt)
        
        let audioFileNameLbl = UILabel()
        audioFileNameLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        audioFileNameLbl.text = "File Name"
        audioFileNameLbl.textColor = UIColor.blackColor()
        audioFileNameLbl.font = UIFont.boldSystemFontOfSize(12)
        audioFileNameLbl.frame = CGRectMake(10, 95, 100, 20)
        self.moreInfoView.addSubview(audioFileNameLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        var audioFileNameTxt = UITextField()
        audioFileNameTxt.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        audioFileNameTxt.textColor = UIColor.blackColor()
        audioFileNameTxt.font = UIFont.systemFontOfSize(12)
        audioFileNameTxt.enabled = false
        audioFileNameTxt.text = audioFileName
        audioFileNameTxt.frame = CGRectMake(13, 118, 242, 20)
        txtFldBorderLbL2.frame = CGRectMake(8, 115, 252, 25)
        moreInfoView.addSubview(txtFldBorderLbL2)
        moreInfoView.addSubview(audioFileNameTxt)
        
        let audioFileDecriptionLbl = UILabel()
        audioFileDecriptionLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        audioFileDecriptionLbl.text = "Description"
        audioFileDecriptionLbl.textColor = UIColor.blackColor()
        audioFileDecriptionLbl.font = UIFont.boldSystemFontOfSize(12)
        audioFileDecriptionLbl.frame = CGRectMake(10, 150, 100, 20)
        self.moreInfoView.addSubview(audioFileDecriptionLbl)
        
        var audioFileDecriptionView = UITextView()
        audioFileDecriptionView.font = UIFont.systemFontOfSize(12)
        audioFileDecriptionView.textAlignment = .Left
        audioFileDecriptionView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        audioFileDecriptionView.layer.borderWidth = 1.5
        audioFileDecriptionView.editable = false
        audioFileDecriptionView.text = audioFileDecription
        audioFileDecriptionView.textColor = UIColor.blackColor()
        audioFileDecriptionView.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1.0)
        audioFileDecriptionView.frame = CGRectMake(10, 170, 250, 80)
        self.moreInfoView.addSubview(audioFileDecriptionView)
        
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