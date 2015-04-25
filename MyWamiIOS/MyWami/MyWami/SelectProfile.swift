//
//  SelectProfile.swift
//  MyWami
//
//  Created by Robert Lanter on 4/21/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class SelectProfile: UIViewController, UIScrollViewDelegate {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var selectProfileView: UIView!
    var scrollView: UIScrollView!
    var containerView: UIView!
    var numProfiles = 0
    var profileModels = [ProfileModel?]()
    var checkbox: WamiCheckBox!
    var checkBoxes = [WamiCheckBox?]()
    var identityProfileId = 0
    
    func initSelect() {
        var numProfiles = 0
        self.profileModels.removeAll()
        self.checkBoxes.removeAll()
    }
    
    func selectProfileDialog(selectProfileView: UIView, closeBtn: UIButton, selectBtn: UIButton) -> UIView {
        initSelect()
        getProfileList()
    
        self.selectProfileView = selectProfileView
        
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
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(230, 400)
        self.scrollView.frame = CGRectMake(0, 35, 230, 120)
        
        containerView = UIView()
        containerView.frame = CGRectMake(0, 0, 230, 400)
        
        var profileModel = ProfileModel()
        var widthPlacement = CGFloat(35)
        var heightPlacement = CGFloat(0)
        var line: UILabel!
        self.numProfiles = profileModels.count
        for index in 0...numProfiles - 1 {
            profileModel = profileModels[index]!
            
            checkbox = WamiCheckBox()
            checkbox.frame = CGRectMake(5, heightPlacement, 30, 30)
            checkbox.awakeFromNib()
            checkbox.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            checkbox.tag = Int(profileModel.getIdentityProfileId())
            checkBoxes.append(checkbox)
            containerView.addSubview(checkbox)
            
            var profileNameTxt = UITextField()
            profileNameTxt.frame = CGRectMake(widthPlacement, heightPlacement, 220, 30)
            profileNameTxt.font = UIFont.boldSystemFontOfSize(12)
            profileNameTxt.textColor = UIColor.blackColor()
            profileNameTxt.enabled = false
            profileNameTxt.text = profileModel.getProfileName()
            containerView.addSubview(profileNameTxt)
            
            line = UILabel()
            line.frame = CGRectMake(10, heightPlacement + 24, 240, 1)
            line.backgroundColor = UIColor.grayColor()
            containerView.addSubview(line)
            
            heightPlacement = heightPlacement + 20
        }
        
        scrollView.addSubview(containerView)
        selectProfileView.addSubview(scrollView)
    
        line = UILabel()
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
    
    func buttonClicked(sender: UIButton) {
        var identityProfileId = sender.tag
        self.identityProfileId = identityProfileId
        var profileModel = ProfileModel()
        for index in 0...numProfiles - 1 {
            profileModel = profileModels[index]!
            var identityProfileIdCheck = profileModel.getIdentityProfileId()
            if identityProfileId == identityProfileIdCheck {
                continue
            }
            checkbox = checkBoxes[index]
            checkbox.awakeFromNib()
        }
    }
    
    func getNewIdentityProfileId () -> String {
        return String(self.identityProfileId)
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
            var numProfiles: Int! = jsonData["profile_list_data"].array?.count
            self.profileModels = [ProfileModel?](count: numProfiles, repeatedValue: nil)
            for index in 0...numProfiles - 1 {
                var profileModel = ProfileModel()
                
                var profileName = jsonData["profile_list_data"][index]["profile_name"].string!
                profileModel.setProfileName(profileName)
                
                var identityProfileId = jsonData["profile_list_data"][index]["identity_profile_id"].string!
                profileModel.setIdentityProfileId(identityProfileId.toInt()!)
                
                var defaultInd = jsonData["profile_list_data"][index]["default_profile_ind"].string!
                profileModel.setDefaultProfileInd(defaultInd.toInt()!)
                
                profileModel.setSelected(false)                
                profileModels[index] = profileModel
            }
        }
    }
}








