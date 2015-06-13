//
//  FlashTableViewCell.swift
//  MyWami
//
//  Created by Robert Lanter on 4/3/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class FlashTableViewCell: UITableViewCell  {
    
    var flashText: UITextField = UITextField()
    var createDateText: UITextField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.createDateText = UITextField(frame: CGRect(x: 2.00, y: 1, width: 112, height: 20))
        self.createDateText.enabled = false
        self.createDateText.font = UIFont.systemFontOfSize(11)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 200, height: 20))
        }
        else if DeviceType.IS_IPHONE_5 {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 200, height: 20))
        }
        else if DeviceType.IS_IPHONE_6 {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 250, height: 20))
        }
        else if DeviceType.IS_IPHONE_6P {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 280, height: 20))
        }
        else if DeviceType.IS_IPAD {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 200, height: 20))
        }
        else {
            self.flashText = UITextField(frame: CGRect(x: 117.00, y: 1, width: 200, height: 20))
        }
        
        self.flashText.font = UIFont.systemFontOfSize(11)
        
        self.addSubview(self.createDateText)
        self.addSubview(self.flashText)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
