//
//  FilterCollection.swift
//  MyWami
//
//  Created by Robert Lanter on 4/26/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class FilterCollection: UIViewController, UIScrollViewDelegate {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var filterCollectionView = UIView()
    var scrollView: UIScrollView!
    var containerView: UIView!
    var groupModels = [GroupModel?]()
    var checkbox: WamiCheckBox!
    var checkBoxes = [WamiCheckBox?]()
    var identityProfileId = 0
    var groupId = 0
    var numGroups: Int = 0
    
    func initSelect() {
        var numGroups = 0
        self.groupModels.removeAll()
        self.checkBoxes.removeAll()
    }
    
    func filterCollectionDialog(filterCollectionView: UIView, closeBtn: UIButton, filterCollectionBtn: UIButton, userIdentityProfileId: String) -> UIView {
        initSelect()
        getGroupList(userIdentityProfileId)
        
        self.filterCollectionView = filterCollectionView
        
        filterCollectionView.frame = CGRectMake(45, 100, 240, 215)
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
    
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(230, 400)
        self.scrollView.frame = CGRectMake(0, 35, 230, 120)
        
        containerView = UIView()
        containerView.frame = CGRectMake(0, 0, 230, 400)

        var groupModel = GroupModel()
        var widthPlacement = CGFloat(35)
        var heightPlacement = CGFloat(0)
        var line: UILabel!
        self.numGroups = groupModels.count
        for index in 0...numGroups - 1 {
            groupModel = groupModels[index]!
            
            checkbox = WamiCheckBox()
            checkbox.frame = CGRectMake(5, heightPlacement, 30, 30)
            checkbox.awakeFromNib()
            checkbox.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            checkbox.tag = Int(groupModel.getIdentityProfileId())
            checkBoxes.append(checkbox)
            containerView.addSubview(checkbox)
            
            var groupNameTxt = UITextField()
            groupNameTxt.frame = CGRectMake(widthPlacement, heightPlacement, 220, 30)
            groupNameTxt.font = UIFont.boldSystemFontOfSize(12)
            groupNameTxt.textColor = UIColor.blackColor()
            groupNameTxt.enabled = false
            groupNameTxt.text = groupModel.getGroupName()
            containerView.addSubview(groupNameTxt)
            
            line = UILabel()
            line.frame = CGRectMake(10, heightPlacement + 24, 240, 1)
            line.backgroundColor = UIColor.grayColor()
            containerView.addSubview(line)
            
            heightPlacement = heightPlacement + 20
        }
        
        scrollView.addSubview(containerView)
        filterCollectionView.addSubview(scrollView)
        
        line = UILabel()
        line.frame = CGRectMake(10, 165, 220, 1)
        line.backgroundColor = UIColor.blackColor()
        filterCollectionView.addSubview(line)
        
        filterCollectionBtn.setTitle("Filter", forState: UIControlState.Normal)
        filterCollectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        filterCollectionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterCollectionBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        filterCollectionBtn.showsTouchWhenHighlighted = true
        filterCollectionBtn.frame = CGRectMake(45, 180, 60, 20)
        filterCollectionView.addSubview(filterCollectionBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 180, 60, 20)
        filterCollectionView.addSubview(closeBtn)
        
        return filterCollectionView
    }
    
    func buttonClicked(sender: UIButton) {
        var groupId = sender.tag
        self.groupId = groupId
        var groupModel = GroupModel()
        for index in 0...numGroups - 1 {
            groupModel = groupModels[index]!
            var groupIdCheck = groupModel.getGroupId()
            if groupId == groupIdCheck {
                continue
            }
            checkbox = checkBoxes[index]
            checkbox.awakeFromNib()
        }
    }
    
    func getGroupId () -> String {
        return String(self.groupId)
    }

    func getGroupList(userIdentityProfileId: String) {
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
            var numGroups: Int! = jsonData["profile_group_data"].array?.count
            self.numGroups = numGroups + 1
            self.groupModels = [GroupModel?](count: numGroups, repeatedValue: nil)
            
            var groupModel = GroupModel()
            var identityProfileId = -99
            groupModel.setIdentityProfileId(identityProfileId)
            
            var groupName = "All Groups"
            groupModel.setGroupName(groupName)
            
            var groupId = -99
            groupModel.setGroupId(groupId)
            
            groupModel.setSelected(false)
            groupModels[0] = groupModel

            for index in 1...numGroups - 1 {
                var groupModel = GroupModel()
                
                identityProfileId = jsonData["profile_group_data"][index]["identity_profile_id"].intValue
                groupModel.setIdentityProfileId(identityProfileId)

                groupName = jsonData["profile_group_data"][index]["group"].string!
                groupModel.setGroupName(groupName)
                
                groupId = jsonData["profile_group_data"][index]["profile_group_id"].intValue
                groupModel.setGroupId(groupId)
                
                groupModel.setSelected(false)
                groupModels[index] = groupModel
            }
        }
    }
    
}




