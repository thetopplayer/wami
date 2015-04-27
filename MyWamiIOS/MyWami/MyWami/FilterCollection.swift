//
//  FilterCollection.swift
//  MyWami
//
//  Created by Robert Lanter on 4/26/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class FilterCollection: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var uview = UIView()
    var userProfileName = ""
    
    var identityProfileId: Int!
    
    func filterCollectionDialog(filterCollectionView: UIView, closeBtn: UIButton, filterCollectionBtn: UIButton, filterDropDownBtn: UIButton) -> UIView {
        self.uview = filterCollectionView
        
        filterCollectionView.frame = CGRectMake(45, 100, 240, 180)
        filterCollectionView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        filterCollectionView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        filterCollectionView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Filter Collection By Group"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        filterCollectionView.addSubview(headingLbl)
        
        let profileNameLbl = UILabel()
        profileNameLbl.backgroundColor = UIColor.whiteColor()
        profileNameLbl.text = "Select Group"
        profileNameLbl.textColor = UIColor.blackColor()
        profileNameLbl.font = UIFont.boldSystemFontOfSize(13)
        profileNameLbl.frame = CGRectMake(10, 40, 100, 20)
        filterCollectionView.addSubview(profileNameLbl)
        
        filterDropDownBtn.backgroundColor = UIColor.whiteColor()
        filterDropDownBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        filterDropDownBtn.backgroundColor = UIColor.grayColor()
        filterDropDownBtn.frame = CGRectMake(10, 70, 210, 25)
        filterCollectionView.addSubview(filterDropDownBtn)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 130, 220, 1)
        line.backgroundColor = UIColor.blackColor()
        filterCollectionView.addSubview(line)
        
        filterCollectionBtn.setTitle("Filter", forState: UIControlState.Normal)
        filterCollectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        filterCollectionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterCollectionBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        filterCollectionBtn.showsTouchWhenHighlighted = true
        filterCollectionBtn.frame = CGRectMake(45, 145, 60, 20)
        filterCollectionView.addSubview(filterCollectionBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 145, 60, 20)
        filterCollectionView.addSubview(closeBtn)
        
        return filterCollectionView
    }
    
    func filter() {
      
    }
    
    func processDropDown(userIdentityProfileId: String) {
        let GET_PROFILE_GROUP_DATA = UTILITIES.IP + "get_profile_group_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_GROUP_DATA, params: ["param1": userIdentityProfileId])
        
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            let numPGroups: Int! = jsonData["profile_group_data"].array?.count
            for index in 0...numPGroups - 1 {
//               self.identityProfileId = jsonData["profile_group_data"][index]["identity_profile_id"].ToInt()!
            }
        }
    }
    
}

//
//int identityProfileId = jsonChildNode.optInt("identity_profile_id");
//String groupName = jsonChildNode.optString("group");
//int profileGroupId = jsonChildNode.optInt("profile_group_id");







