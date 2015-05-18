//
//  SearchForProfiles.swift
//  MyWami
//
//  Created by Robert Lanter on 5/10/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class SearchForProfiles: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var numProfiles = 0

    var searchInBtn = UIButton()
    var profileNameBtn = UIButton()
    var firstNameBtn = UIButton()
    var lastNameBtn = UIButton()
    var tagsBtn = UIButton()
    var descriptionBtn = UIButton()
    var searchStringLikeTxt = UITextField()
    var radioBtns = [UIButton]()
    var radioBtn1 = UIButton()
    var radioBtn2 = UIButton()
    
    let radioEnabledImage = UIImage(named: "radioBtnEnabled.png") as UIImage?
    let radioDisabledImage = UIImage(named: "radioBtnDisabled.png") as UIImage?
    var entireNetwork = false
    
    var dropdownView = UIView()
    var searchProfileView = UIView()
    
    func searchProfilesDialog(searchProfileView: UIView, closeBtn: UIButton, searchBtn: UIButton) -> UIView {
        self.searchProfileView = searchProfileView
        self.entireNetwork = false
        
        searchProfileView.frame = CGRectMake(50, 50, 230, 285)
        searchProfileView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        searchProfileView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        searchProfileView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Search For Profiles"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 230, 30)
        searchProfileView.addSubview(headingLbl)
        
        let searchInLbl = UILabel()
        searchInLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        searchInLbl.text = "Search In"
        searchInLbl.textColor = UIColor.blackColor()
        searchInLbl.font = UIFont.boldSystemFontOfSize(12)
        searchInLbl.frame = CGRectMake(10, 35, 100, 20)
        searchProfileView.addSubview(searchInLbl)
        
        searchInBtn.backgroundColor = UIColor.lightGrayColor()
        searchInBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        searchInBtn.setTitle("Profile Name", forState: UIControlState.Normal)
        searchInBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchInBtn.addTarget(self, action: "doDropDown", forControlEvents: UIControlEvents.TouchUpInside)
        searchInBtn.frame = CGRectMake(10, 53, 210, 25)
        searchInBtn.showsTouchWhenHighlighted = true
        searchProfileView.addSubview(searchInBtn)
        self.dropdownView.hidden = true
        
        let dropDownIndicator = UILabel()
        dropDownIndicator.text = "v"
        dropDownIndicator.textColor = UIColor.darkGrayColor()
        dropDownIndicator.font = UIFont.boldSystemFontOfSize(12)
        dropDownIndicator.frame = CGRectMake(15, 53, 22, 25)
        searchProfileView.addSubview(dropDownIndicator)

        
        let searchStringLikeLbl = UILabel()
        searchStringLikeLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        searchStringLikeLbl.text = "Search String Like"
        searchStringLikeLbl.textColor = UIColor.blackColor()
        searchStringLikeLbl.font = UIFont.boldSystemFontOfSize(12)
        searchStringLikeLbl.frame = CGRectMake(10, 90, 120, 20)
        searchProfileView.addSubview(searchStringLikeLbl)
        
        let txtFldBorderLbL = UILabel()
        txtFldBorderLbL.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL.layer.borderWidth = 1.5
        
        searchStringLikeTxt.backgroundColor = UIColor.whiteColor()
        searchStringLikeTxt.textColor = UIColor.blackColor()
        searchStringLikeTxt.font = UIFont.systemFontOfSize(13)
        searchStringLikeTxt.text = ""
        searchStringLikeTxt.frame = CGRectMake(15, 111, 170, 20)
        txtFldBorderLbL.frame = CGRectMake(10, 108, 210, 25)
        searchProfileView.addSubview(txtFldBorderLbL)
        searchProfileView.addSubview(searchStringLikeTxt)
        
        let searchWithinLbl = UILabel()
        searchWithinLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        searchWithinLbl.text = "Search Within"
        searchWithinLbl.textColor = UIColor.blackColor()
        searchWithinLbl.font = UIFont.boldSystemFontOfSize(12)
        searchWithinLbl.frame = CGRectMake(11, 140, 120, 20)
        searchProfileView.addSubview(searchWithinLbl)
        
        self.radioBtns = [self.radioBtn1, self.radioBtn2]
        radioBtns[0].frame = CGRectMake(10, 160, 30, 30)
        radioBtns[0].setImage(radioEnabledImage, forState: .Normal)
        radioBtns[0].tag = 1
        radioBtns[0].addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        searchProfileView.addSubview(radioBtns[0])
        
        let myWamiLbl = UILabel()
        myWamiLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        myWamiLbl.text = "My Wami Collection"
        myWamiLbl.textColor = UIColor.blackColor()
        myWamiLbl.font = UIFont.boldSystemFontOfSize(11)
        myWamiLbl.frame = CGRectMake(40, 162, 105, 20)
        searchProfileView.addSubview(myWamiLbl)
        
        radioBtns[1].frame = CGRectMake(10, 188, 30, 30)
        radioBtns[1].setImage(radioDisabledImage, forState: .Normal)
        radioBtns[1].tag = 2
        radioBtns[1].addTarget(self, action: "buttonClicked:", forControlEvents:UIControlEvents.TouchUpInside)
        searchProfileView.addSubview(radioBtns[1])
       
        let entireNetworkLbl = UILabel()
        entireNetworkLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        entireNetworkLbl.text = "Entire Wami Network"
        entireNetworkLbl.textColor = UIColor.blackColor()
        entireNetworkLbl.font = UIFont.boldSystemFontOfSize(11)
        entireNetworkLbl.frame = CGRectMake(40, 193, 125, 20)
        searchProfileView.addSubview(entireNetworkLbl)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 235, 210, 1)
        line.backgroundColor = UIColor.blackColor()
        searchProfileView.addSubview(line)
        
        searchBtn.setTitle("Search", forState: UIControlState.Normal)
        searchBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        searchBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        searchBtn.showsTouchWhenHighlighted = true
        searchBtn.frame = CGRectMake(40, 250, 60, 20)
        searchProfileView.addSubview(searchBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(130, 250, 60, 20)
        searchProfileView.addSubview(closeBtn)
        
        return searchProfileView
    }
    
    func buttonClicked(sender: UIButton) {
        var whichRadioBtn = sender.tag
        if whichRadioBtn == 1 {
            radioBtns[0].setImage(radioEnabledImage, forState: .Normal)
            radioBtns[1].setImage(radioDisabledImage, forState: .Normal)
            entireNetwork = false
        }
        else {
            radioBtns[0].setImage(radioDisabledImage, forState: .Normal)
            radioBtns[1].setImage(radioEnabledImage, forState: .Normal)
            entireNetwork = true
        }
    }
    
    func getSearchIn() -> String {
        if searchInBtn.titleLabel!.text! == "Tag Keywords" {
            return "Tags"
        }
        if searchInBtn.titleLabel!.text! == "Profile Description" {
            return "Description"
        }
        return searchInBtn.titleLabel!.text!
    }
    func getsSearchStringLikeTxt() -> String {
        return searchStringLikeTxt.text
    }
    func getSearchIndicator() -> String {
        var searchEntireNetwork = "0"
        if entireNetwork == true {
            searchEntireNetwork = "1"
        }
        return searchEntireNetwork
    }
    
    
    func doDropDown() {
        dropdownView.frame = CGRectMake(45, 80, 150, 110)
        dropdownView.backgroundColor = UIColor.whiteColor()
        dropdownView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        dropdownView.layer.borderWidth = 1.0
        
        profileNameBtn.backgroundColor = UIColor.whiteColor()
        profileNameBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        profileNameBtn.setTitle("Profile Name", forState: UIControlState.Normal)
        profileNameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        profileNameBtn.addTarget(self, action: "profileName", forControlEvents: UIControlEvents.TouchUpInside)
        profileNameBtn.frame = CGRectMake(0, 5, 140, 15)
        profileNameBtn.showsTouchWhenHighlighted = true
        dropdownView.addSubview(profileNameBtn)
        
        firstNameBtn.backgroundColor = UIColor.whiteColor()
        firstNameBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        firstNameBtn.setTitle("First Name", forState: UIControlState.Normal)
        firstNameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        firstNameBtn.addTarget(self, action: "firstName", forControlEvents: UIControlEvents.TouchUpInside)
        firstNameBtn.frame = CGRectMake(0, 25, 140, 15)
        firstNameBtn.showsTouchWhenHighlighted = true
        dropdownView.addSubview(firstNameBtn)

        lastNameBtn.backgroundColor = UIColor.whiteColor()
        lastNameBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        lastNameBtn.setTitle("Last Name", forState: UIControlState.Normal)
        lastNameBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        lastNameBtn.addTarget(self, action: "lastName", forControlEvents: UIControlEvents.TouchUpInside)
        lastNameBtn.frame = CGRectMake(0, 45, 140, 15)
        lastNameBtn.showsTouchWhenHighlighted = true
        dropdownView.addSubview(lastNameBtn)
        
        tagsBtn.backgroundColor = UIColor.whiteColor()
        tagsBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        tagsBtn.setTitle("Tag Keywords", forState: UIControlState.Normal)
        tagsBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        tagsBtn.addTarget(self, action: "tags", forControlEvents: UIControlEvents.TouchUpInside)
        tagsBtn.frame = CGRectMake(0, 65, 140, 15)
        tagsBtn.showsTouchWhenHighlighted = true
        dropdownView.addSubview(tagsBtn)
        
        descriptionBtn.backgroundColor = UIColor.whiteColor()
        descriptionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        descriptionBtn.setTitle("Profile Description", forState: UIControlState.Normal)
        descriptionBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        descriptionBtn.addTarget(self, action: "profileDescription", forControlEvents: UIControlEvents.TouchUpInside)
        descriptionBtn.frame = CGRectMake(0, 85, 140, 15)
        descriptionBtn.showsTouchWhenHighlighted = true
        dropdownView.addSubview(descriptionBtn)
        
        if dropdownView.hidden {
            dropdownView.hidden = false
        }
        else {
            dropdownView.hidden = true
        }
        
        searchProfileView.addSubview(dropdownView)
        
    }
    
    func profileName () {
        dropdownView.hidden = true
        searchInBtn.setTitle("Profile Name", forState: UIControlState.Normal)
    }
    func firstName () {
        dropdownView.hidden = true
        searchInBtn.setTitle("First Name", forState: UIControlState.Normal)
    }
    func lastName () {
        dropdownView.hidden = true
        searchInBtn.setTitle("Last Name", forState: UIControlState.Normal)
    }
    func tags () {
        dropdownView.hidden = true
        searchInBtn.setTitle("Tag Keywords", forState: UIControlState.Normal)
    }
    func profileDescription () {
        dropdownView.hidden = true
        searchInBtn.setTitle("Profile Description", forState: UIControlState.Normal)
    }
}





