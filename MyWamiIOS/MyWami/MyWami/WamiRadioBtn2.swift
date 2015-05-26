//
//  WamiRadioBtn2.swift
//  MyWami
//
//  Created by Robert Lanter on 5/26/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class WamiRadioBtn2: UIButton {
    let enabledImage = UIImage(named: "radioBtnEnabled2")
    let disabledImage = UIImage(named: "radioBtnDisabled2")
    
    var isRadioEnabled:Bool = false {
        didSet {
            if isRadioEnabled == true {
                self.setImage(enabledImage, forState: .Normal)
            }
            else {
                self.setImage(disabledImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isRadioEnabled = false
    }
    
    func buttonClicked(sender:UIButton) {
        if (sender == self) {
            if isRadioEnabled == true {
                isRadioEnabled = false
            }
            else {
                isRadioEnabled = true
            }
        }
    }
}