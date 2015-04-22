//
//  SelectProfile.swift
//  MyWami
//
//  Created by Robert Lanter on 4/21/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class SelectProfile: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var selectProfileView = UIView()
    
    func selectProfileDialog(selectProfileView: UIView, closeBtn: UIButton, selectBtn: UIButton) -> UIView {
        getProfileList()
        
        self.uview = selectProfileView
        
        selectProfileView.frame = CGRectMake(45, 100, 240, 215)
        selectProfileView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        selectProfileView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        selectProfileView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Select Profile Collection"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        selectProfileView.addSubview(headingLbl)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 165, 220, 1)
        line.backgroundColor = UIColor.blackColor()
        selectProfileView.addSubview(line)
        
        selectBtn.setTitle("Select", forState: UIControlState.Normal)
        selectBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        selectBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        selectBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        selectBtn.showsTouchWhenHighlighted = true
        selectBtn.frame = CGRectMake(45, 180, 60, 20)
        selectProfileView.addSubview(selectBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 180, 60, 20)
        selectProfileView.addSubview(closeBtn)

    
        return selectProfileView
    }
    
    func selectProfileCollection(userIdentityProfileId: String) {
        
        
    }
    
    private func getProfileList() {
        let getUserId = GetUserId()
        var userId = String(getUserId.getUserId())
        
        let GET_PROFILE_LIST = UTILITIES.IP + "get_profile_list.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_LIST, params: ["param1": userId])
        
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            let numProfiles: Int! = jsonData["profile_list_data"].array?.count
            for index in 0...numProfiles - 1 {
                var profileName = jsonData["profile_list_data"][index]["profile_name"].string!
                
                var identityProfileId = jsonData["profile_list_data"][index]["identity_profile_id"].string!
                
                var defaultInd = jsonData["profile_list_data"][index]["default_profile_ind"].string!
            }
        }
    }
}








