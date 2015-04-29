//
//  TransmitProfile.swift
//  MyWami
//
//  Created by Robert Lanter on 4/9/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class TransmitProfile: UIViewController {
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    var uview = UIView()
    var userProfileName = ""
    var profileNames: [String] = []
    var numNames = 0
    var profileNamesView: CompletionTableView!
    
    var profileNameTxt = UITextField()
    func transmitProfileDialog(transmitProfileView: UIView, closeBtn: UIButton, transmitBtn: UIButton) -> UIView {
        self.uview = transmitProfileView
        
        getProfileNames()
        
        transmitProfileView.frame = CGRectMake(45, 100, 240, 215)
        transmitProfileView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        transmitProfileView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        transmitProfileView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Transmit Profile(s)"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        transmitProfileView.addSubview(headingLbl)
        
        let profileNameLbl = UILabel()
        profileNameLbl.backgroundColor = UIColor.whiteColor()
        profileNameLbl.text = "To Profile Name"
        profileNameLbl.textColor = UIColor.blackColor()
        profileNameLbl.font = UIFont.boldSystemFontOfSize(13)
        profileNameLbl.frame = CGRectMake(10, 40, 100, 20)
        transmitProfileView.addSubview(profileNameLbl)
        
        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        self.profileNamesView = CompletionTableView(relatedTextField: self.profileNameTxt, inView: self.uview, searchInArray: self.profileNames, tableCellNibName: nil, tableCellIdentifier: nil)
        self.profileNamesView.frame = CGRectMake(15, 80, 210, 120)
        self.profileNamesView.layer.borderColor = UIColor.grayColor().CGColor
        self.profileNamesView.layer.borderWidth = 1.5
        self.profileNamesView.show(false)

        profileNameTxt.backgroundColor = UIColor.whiteColor()
        profileNameTxt.textColor = UIColor.blackColor()
        profileNameTxt.font = UIFont.systemFontOfSize(12)
        profileNameTxt.frame = CGRectMake(15, 63, 210, 20)
        profileNameTxt.placeholder = "Enter destination Profile Name"
        txtFldBorderLbL1.frame = CGRectMake(10, 60, 220, 25)
        transmitProfileView.addSubview(txtFldBorderLbL1)
        transmitProfileView.addSubview(profileNameTxt)
        
        let emailAddressLbl = UILabel()
        emailAddressLbl.backgroundColor = UIColor.whiteColor()
        emailAddressLbl.text = "To Email Address"
        emailAddressLbl.textColor = UIColor.blackColor()
        emailAddressLbl.font = UIFont.boldSystemFontOfSize(12)
        emailAddressLbl.frame = CGRectMake(10, 100, 100, 20)
        transmitProfileView.addSubview(emailAddressLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        let emailAddressTxt = UITextField()
        emailAddressTxt.backgroundColor = UIColor.whiteColor()
        emailAddressTxt.textColor = UIColor.blackColor()
        emailAddressTxt.font = UIFont.systemFontOfSize(13)
        emailAddressTxt.frame = CGRectMake(15, 123, 210, 20)
        emailAddressTxt.placeholder = "Enter destination Email Address"
        txtFldBorderLbL2.frame = CGRectMake(10, 120, 220, 25)
        transmitProfileView.addSubview(txtFldBorderLbL2)
        transmitProfileView.addSubview(emailAddressTxt)
        
        var line: UILabel = UILabel()
        line.frame = CGRectMake(10, 165, 220, 1)
        line.backgroundColor = UIColor.blackColor()
        transmitProfileView.addSubview(line)
        
        transmitBtn.setTitle("Transmit", forState: UIControlState.Normal)
        transmitBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        transmitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        transmitBtn.showsTouchWhenHighlighted = true
        transmitBtn.frame = CGRectMake(45, 180, 60, 20)
        transmitProfileView.addSubview(transmitBtn)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 180, 60, 20)
        transmitProfileView.addSubview(closeBtn)
                
        return transmitProfileView
    }
    
    func transmit(fromProfileId: String, identityProfileId: String, numToTransmit: String) {
        var num_to_transmit = numToTransmit
        var transmit_to_profile = profileNameTxt.text
        if transmit_to_profile == "" || transmit_to_profile == nil {
            self.uview.makeToast(message: "No Profile Name was entered to transmit to!", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        var from_profile_id = String(fromProfileId)
        var profiles_to_transmit = identityProfileId
        let INSERT_TRANSMITTED_PROFILE = UTILITIES.IP + "insert_transmitted_profile.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(INSERT_TRANSMITTED_PROFILE,
            params: ["param1": num_to_transmit, "param2": from_profile_id, "param3": profiles_to_transmit, "param4": transmit_to_profile])
        insertTransmittedData(jsonData)
    }
    
    func insertTransmittedData(jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        var noRecExistRetCode = jsonData["no_rec_found_ret_code"]
        var recExistRetCode = jsonData["rec_exist_ret_code"]
        if retCode == -1 {
            var message = jsonData["db_error"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        if noRecExistRetCode == 1 {
            var message = jsonData["no_records_found"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        if recExistRetCode == 1 {
            var message = jsonData["record_already_exist"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        
        if retCode == 0 {
            var numProfilesTransmitted = jsonData["num_profiles_transmitted"]
            var message = "Number of profiles transmitted = \(numProfilesTransmitted)"
            var fullMsg = ""
            if let dupMessage = jsonData["record_already_exist"][0].string {
                fullMsg = message + ".\n" + dupMessage
            }
            else {
                fullMsg = message
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.uview.makeToast(message: fullMsg, duration: HRToastDefaultDuration, position: HRToastPositionDefault)
            }
        }
    }
    
    func getProfileNames () {
        let GET_PROFILE_NAMES = UTILITIES.IP + "get_profile_names.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_NAMES, params: ["param1": " "])

        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            let numNames: Int! = jsonData["profile_names"].array?.count
            self.numNames = numNames
            for index in 0...numNames - 1 {
                if let profileName = jsonData["profile_names"][index].string {
                    profileNames.append(profileName)
                }
                else {
                    profileNames.append("")
                }
            }
        }
    }

    
}






