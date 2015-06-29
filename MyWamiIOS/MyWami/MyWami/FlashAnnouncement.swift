//
//  FlashAnnouncement.swift
//  MyWami
//
//  Created by Robert Lanter on 4/22/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class FlashAnnouncement: UIViewController, UITextViewDelegate  {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var newFlashView = UIView()

    func flashDialog(newFlashView: UIView, textView: UITextView, closeBtn: UIButton, createBtn: UIButton) -> UIView {
        self.newFlashView = newFlashView
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            newFlashView.frame = CGRectMake(45, 100, 240, 230)
        }
        else if DeviceType.IS_IPHONE_5 {
            newFlashView.frame = CGRectMake(40, 100, 240, 230)
        }
        else if DeviceType.IS_IPHONE_6 {
            newFlashView.frame = CGRectMake(65, 100, 240, 230)
        }
        else if DeviceType.IS_IPHONE_6P {
            newFlashView.frame = CGRectMake(80, 100, 240, 230)
        }
        else if DeviceType.IS_IPAD {
            newFlashView.frame = CGRectMake(35, 100, 250, 230)
        }
        else {
            newFlashView.frame = CGRectMake(35, 100, 250, 230)
        }
        
//        newFlashView.frame = CGRectMake(45, 200, 240, 230)
        newFlashView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 0.92)
        newFlashView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        newFlashView.layer.cornerRadius = 5.0
        newFlashView.layer.borderWidth = 1.0
            
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "New Flash Anncouncement"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        headingLbl.roundCorners(.TopLeft | .TopRight, radius: 5.0)
        newFlashView.addSubview(headingLbl)
            
        textView.font = UIFont.systemFontOfSize(12)
        textView.textAlignment = .Left
        textView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        textView.layer.borderWidth = 0.5
        textView.frame = CGRectMake(20, 40, 200, 120)
            
        textView.text = "New Flash up to 110 characters"
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
        newFlashView.addSubview(textView)

        createBtn.setTitle("Create", forState: UIControlState.Normal)
        createBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        createBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        createBtn.showsTouchWhenHighlighted = true
        createBtn.frame = CGRectMake(45, 180, 60, 25)
        newFlashView.addSubview(createBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 180, 60, 25)
        newFlashView.addSubview(closeBtn)
        
        return newFlashView
    }
    // used for text view placeholder
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    // limit number of chars in flash msg
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if count(textView.text) > 109 {
            self.newFlashView.makeToast(message: "Only 110 characters allowed.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            textView.text = textView.text.substringToIndex(advance(textView.text.startIndex, count(textView.text) - 1))
        }
        return true
    }
}




