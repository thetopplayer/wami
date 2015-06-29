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
    var radioBtn: WamiRadioBtn2!
    var radioBtns = [WamiRadioBtn2?]()
    var identityProfileId = 0
    var groupId = 0
    var numGroups: Int = 0
    
    func initSelect() {
        var numGroups = 0
        self.groupModels.removeAll()
        self.radioBtns.removeAll()
    }
    
    var verticalPos: CGFloat = 0
    func filterCollectionDialog(filterCollectionView: UIView, closeBtn: UIButton, filterCollectionBtn: UIButton, userIdentityProfileId: String, verticalPos: CGFloat) -> UIView? {
        initSelect()
        
        self.filterCollectionView = filterCollectionView
        self.verticalPos = verticalPos + 40
        
        var retCode = getGroupList(userIdentityProfileId)
        if retCode == -1 {
            return nil
        }
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.filterCollectionView.frame = CGRectMake(45, self.verticalPos, 240, 300)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.filterCollectionView.frame = CGRectMake(40, self.verticalPos, 240, 300)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.filterCollectionView.frame = CGRectMake(65, self.verticalPos, 240, 300)
        }
        else if DeviceType.IS_IPHONE_6P {
            self.filterCollectionView.frame = CGRectMake(80, self.verticalPos, 240, 300)
        }
        else if DeviceType.IS_IPAD {
            self.filterCollectionView.frame = CGRectMake(35, self.verticalPos, 250, 422)
        }
        else {
            self.filterCollectionView.frame = CGRectMake(35, self.verticalPos, 250, 422)
        }
    
        filterCollectionView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 0.92)
        filterCollectionView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        filterCollectionView.layer.cornerRadius = 5.0
        filterCollectionView.layer.borderWidth = 1.0
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.grayColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Filter Collection By Group"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        headingLbl.roundCorners(.TopLeft | .TopRight, radius: 5.0)
        filterCollectionView.addSubview(headingLbl)
    
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        self.scrollView.layer.borderWidth = 1.0
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(230, 400)
        self.scrollView.frame = CGRectMake(5, 35, 230, 215)
        
        containerView = UIView()
        containerView.frame = CGRectMake(0, 0, 230, 180)

        var groupModel = GroupModel()
        var widthPlacement = CGFloat(35)
        var heightPlacement = CGFloat(0)
        var line: UILabel!
        self.numGroups = groupModels.count
        for index in 0...numGroups - 1 {
            groupModel = groupModels[index]!
            
            radioBtn = WamiRadioBtn2()
            radioBtn.frame = CGRectMake(5, heightPlacement, 30, 30)
            radioBtn.awakeFromNib()
            radioBtn.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            radioBtn.tag = Int(groupModel.getGroupId())
            radioBtns.append(radioBtn)
            containerView.addSubview(radioBtn)
            
            var groupNameTxt = UITextField()
            groupNameTxt.frame = CGRectMake(widthPlacement, heightPlacement, 220, 30)
            groupNameTxt.font = UIFont.boldSystemFontOfSize(12)
            groupNameTxt.textColor = UIColor.blackColor()
            groupNameTxt.enabled = false
            groupNameTxt.text = groupModel.getGroupName()
            containerView.addSubview(groupNameTxt)
            
            line = UILabel()
            line.frame = CGRectMake(10, heightPlacement + 30, 240, 1)
            line.backgroundColor = UIColor.grayColor()
            containerView.addSubview(line)
            
            heightPlacement = heightPlacement + 30
        }
        
        scrollView.addSubview(containerView)
        filterCollectionView.addSubview(scrollView)
        
        filterCollectionBtn.setTitle("Filter", forState: UIControlState.Normal)
        filterCollectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        filterCollectionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterCollectionBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        filterCollectionBtn.showsTouchWhenHighlighted = true
        filterCollectionBtn.frame = CGRectMake(45, 265, 60, 20)
        filterCollectionView.addSubview(filterCollectionBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 265, 60, 20)
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
            radioBtn = radioBtns[index]
            radioBtn.awakeFromNib()
        }
    }
    
    func getGroupId () -> Int {
        return self.groupId
    }

    func getGroupList(userIdentityProfileId: String) -> Int {
        let GET_PROFILE_GROUP_DATA = UTILITIES.IP + "get_profile_group_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_GROUP_DATA, params: ["param1": userIdentityProfileId])
        
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            return -1
        }
        else {
            var numGroups: Int! = jsonData["profile_group_data"].array?.count
            self.groupModels = [GroupModel?](count: numGroups + 1, repeatedValue: nil)
            
            var groupModel = GroupModel()
            var identityProfileId = -99
            groupModel.setIdentityProfileId(identityProfileId)
            
            var groupName = "All Groups"
            groupModel.setGroupName(groupName)
            
            var groupId = -99
            groupModel.setGroupId(groupId)
            
            groupModel.setSelected(false)
            self.groupModels[0] = groupModel

            var groupIndex = 1
            for index in 0...numGroups - 1 {
                var groupModel = GroupModel()
                
                identityProfileId = jsonData["profile_group_data"][index]["identity_profile_id"].intValue
                groupModel.setIdentityProfileId(identityProfileId)

                groupName = jsonData["profile_group_data"][index]["group"].string!
                groupModel.setGroupName(groupName)
                
                groupId = jsonData["profile_group_data"][index]["profile_group_id"].intValue
                groupModel.setGroupId(groupId)
                
                groupModel.setSelected(false)
                self.groupModels[groupIndex] = groupModel
                groupIndex++
            }
        }
        return 0
    }
    
}




