//
//  NavigateTo.swift
//  MyWami
//
//  Created by Robert Lanter on 4/9/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class NavigateTo: UIViewController {
    func navigateTo(navigateToView: UIView, closeBtn: UIButton, profileInfoBtn: UIButton,
                    profilerBtn: UIButton, flashBtn: UIButton, profileCollectionBtn: UIButton) -> UIView {
                    
        if DeviceType.IS_IPHONE_4_OR_LESS {
            navigateToView.frame = CGRectMake(45, 80, 240, 230)
        }
        else if DeviceType.IS_IPHONE_5 {
            navigateToView.frame = CGRectMake(45, 80, 240, 230)
        }
        else if DeviceType.IS_IPHONE_6 {
            navigateToView.frame = CGRectMake(70, 90, 240, 230)
        }
        else if DeviceType.IS_IPHONE_6P {
            navigateToView.frame = CGRectMake(85, 90, 240, 230)
        }
        else if DeviceType.IS_IPAD {
            navigateToView.frame = CGRectMake(35, 65, 240, 230)
        }
        else {
           navigateToView.frame = CGRectMake(35, 65, 240, 230)
        }
                
        navigateToView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 0.95)
        navigateToView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        navigateToView.layer.cornerRadius = 5.0
        navigateToView.layer.borderWidth = 1.0
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Navigate To..."
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        headingLbl.roundCorners(.TopLeft | .TopRight, radius: 5.0)
        navigateToView.addSubview(headingLbl)
        
        profileInfoBtn.setTitle("Profile Info", forState: UIControlState.Normal)
        profileInfoBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        profileInfoBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        profileInfoBtn.backgroundColor = UIColor(red: 0xcc/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        profileInfoBtn.showsTouchWhenHighlighted = true
        profileInfoBtn.frame = CGRectMake(20, 40, 200, 25)
        navigateToView.addSubview(profileInfoBtn)
        
        profilerBtn.setTitle("Profiler", forState: UIControlState.Normal)
        profilerBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        profilerBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        profilerBtn.backgroundColor = UIColor(red: 0xcc/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        profilerBtn.showsTouchWhenHighlighted = true
        profilerBtn.frame = CGRectMake(20, 75, 200, 25)
        navigateToView.addSubview(profilerBtn)
        
        flashBtn.setTitle("Flash Announcements", forState: UIControlState.Normal)
        flashBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        flashBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        flashBtn.backgroundColor = UIColor(red: 0xcc/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        flashBtn.showsTouchWhenHighlighted = true
        flashBtn.frame = CGRectMake(20, 110, 200, 25)
        navigateToView.addSubview(flashBtn)
        
        profileCollectionBtn.setTitle("Profile Collection (home)", forState: UIControlState.Normal)
        profileCollectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        profileCollectionBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        profileCollectionBtn.backgroundColor = UIColor(red: 0xcc/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        profileCollectionBtn.showsTouchWhenHighlighted = true
        profileCollectionBtn.frame = CGRectMake(20, 145, 200, 25)
        navigateToView.addSubview(profileCollectionBtn)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(20, 180, 200, 1)
        line.backgroundColor = UIColor.blackColor()
        navigateToView.addSubview(line)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(30, 190, 60, 20)
        navigateToView.addSubview(closeBtn)
        
        return navigateToView
    }
}
