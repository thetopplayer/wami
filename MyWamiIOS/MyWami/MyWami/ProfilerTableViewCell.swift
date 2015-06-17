//
//  ProfilerTableViewCell.swift
//  MyWami
//
//  Created by Robert Lanter on 4/1/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfilerTableViewCell: UITableViewCell  {
        
//    @IBOutlet var categoryBtn: UIButton!
    var categoryBtn: UIButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoryBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        categoryBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        categoryBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        categoryBtn.showsTouchWhenHighlighted = true
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            categoryBtn.frame = CGRectMake(10, 5, 50, 20)
        }
        else if DeviceType.IS_IPHONE_5 {
            categoryBtn.frame = CGRectMake(0, 2, 320, 43)
        }
        else if DeviceType.IS_IPHONE_6 {
            categoryBtn.frame = CGRectMake(10, 5, 50, 20)
        }
        else if DeviceType.IS_IPHONE_6P {
            categoryBtn.frame = CGRectMake(10, 5, 50, 20)
        }
        else if DeviceType.IS_IPAD {
            categoryBtn.frame = CGRectMake(10, 5, 50, 20)
        }
        else {
            categoryBtn.frame = CGRectMake(10, 5, 50, 20)
        }
        
        self.addSubview(self.categoryBtn)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
