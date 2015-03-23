//
//  WamiCheckBox.swift
//  MyWami
//
//  Created by Robert Lanter on 3/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class WamiCheckBox: UIButton {
    let checkedImage = UIImage(named: "checkboxChecked")
    let unCheckedImage = UIImage(named: "checkboxUnchecked")
        
    var isChecked:Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            }
            else {
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
        
    func buttonClicked(sender:UIButton) {
        if (sender == self) {
            if isChecked == true {
                isChecked = false
            }
            else {
                isChecked = true
            }
        }
    }
}
