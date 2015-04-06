//
//  Menu.swift
//  MyWami
//
//  Created by Robert Lanter on 4/1/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation
import UIKit

class Menu {       
    func setMenuBtnAttributes(title: String) -> UIButton {
        let menuBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        menuBtn.setTitle(title, forState: UIControlState.Normal)
        menuBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        menuBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        menuBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        menuBtn.showsTouchWhenHighlighted = true
        return menuBtn
    }
    
    func toggleMenu (menuView: UIView) {
        if menuView.hidden {
            menuView.hidden = false
        }
        else {
            menuView.hidden = true
        }
    }
    
    func createMenuLine (offset: Int) -> UILabel {
        var line: UILabel = UILabel()
        line.frame = CGRectMake(0, CGFloat(25 + offset), 150, 1)
        line.backgroundColor = UIColor.grayColor()
        return line
    }
}