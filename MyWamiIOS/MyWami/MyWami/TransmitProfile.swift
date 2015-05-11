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
    var emailAddressTxt = UITextField()
    func transmitProfileDialog(transmitProfileView: UIView, closeBtn: UIButton, transmitBtn: UIButton) -> UIView {
        self.uview = transmitProfileView
        
        getProfileNames()
        
        transmitProfileView.frame = CGRectMake(45, 100, 240, 215)
        transmitProfileView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
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
        profileNameLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
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
        self.profileNamesView.frame = CGRectMake(15, 80, 210, 0)
        self.profileNamesView.layer.borderColor = UIColor.lightGrayColor().CGColor
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
        emailAddressLbl.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        emailAddressLbl.text = "To Email Address"
        emailAddressLbl.textColor = UIColor.blackColor()
        emailAddressLbl.font = UIFont.boldSystemFontOfSize(12)
        emailAddressLbl.frame = CGRectMake(10, 100, 100, 20)
        transmitProfileView.addSubview(emailAddressLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
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
        var firstName = ""
        var lastName = ""
        var profileName = ""
        var description = ""
        var email = ""
        var profileType = ""
        var streetAddress = ""
        var city = ""
        var state = ""
        var zipcode = ""
        var country = ""
        var telephone = ""
        var createDate = ""
        var tags = ""
        var fromFirstName = ""
        var fromLastName = ""
        var fromProfileName = ""
        var fromEmail = ""
        
        var transmit_to_profile = profileNameTxt.text
        var transmit_to_email = emailAddressTxt.text
        if transmit_to_profile == "" && transmit_to_email == "" {
            self.uview.makeToast(message: "Pleas provide a Profile Name and/or Email Address to transmit to!", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        if transmit_to_profile != "" {
            let INSERT_TRANSMITTED_PROFILE = UTILITIES.IP + "insert_transmitted_profile.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(INSERT_TRANSMITTED_PROFILE,
                params: ["param1": numToTransmit, "param2": String(fromProfileId), "param3": identityProfileId, "param4": transmit_to_profile])
            var retCode = insertTransmittedData(jsonData)
            if retCode != 0 {
                var message = jsonData["db_error"].string
                self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
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
                self.uview.makeToast(message: fullMsg, duration: HRToastDefaultDuration, position: HRToastPositionDefault)
            }
        }
        if transmit_to_email != ""  {
            var idArray = identityProfileId.componentsSeparatedByString(",")
            var numProfiles = idArray.count
            var profileId = ""
            for index in 0...numProfiles - 1 {
                profileId = idArray[index]
            
                if transmit_to_email.rangeOfString("@") == nil {
                    self.uview.makeToast(message: "Invalid Email address. Must be in the form of user@host.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                    return
                }
                var fromIdentityProfileId = fromProfileId
                var GET_PROFILE_DATA = UTILITIES.IP + "get_profile_data.php"
                var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_DATA, params: ["param1": profileId, "param2": fromIdentityProfileId, "param3": "NA"])
                
                var retCode = jsonData["ret_code"]
                if retCode == 1 {
                    var message = jsonData["message"].string
                    self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                    return
                }
                firstName = jsonData["identity_profile_data"][0]["first_name"].string!
                lastName = jsonData["identity_profile_data"][0]["last_name"].string!
                profileName = jsonData["identity_profile_data"][0]["profile_name"].string!
                profileType = jsonData["identity_profile_data"][0]["profile_type"].string!
                description = jsonData["identity_profile_data"][0]["description"].string!
                streetAddress = jsonData["identity_profile_data"][0]["street_address"].string!
                city = jsonData["identity_profile_data"][0]["city"].string!
                state = jsonData["identity_profile_data"][0]["state"].string!
                zipcode = jsonData["identity_profile_data"][0]["zipcode"].string!
                country = jsonData["identity_profile_data"][0]["country"].string!
                telephone = jsonData["identity_profile_data"][0]["telephone"].string!
                email = jsonData["identity_profile_data"][0]["email"].string!
                tags = jsonData["identity_profile_data"][0]["tags"].string!
                createDate = jsonData["identity_profile_data"][0]["create_date"].string!
                fromFirstName = jsonData["identity_profile_data"][0]["from_first_name"].string!
                fromLastName = jsonData["identity_profile_data"][0]["from_last_name"].string!
                fromProfileName = jsonData["identity_profile_data"][0]["from_profile_name"].string!
                fromEmail = jsonData["identity_profile_data"][0]["from_email"].string!
            
                var contactName = firstName + " " + lastName
                let TRANSMIT_PROFILE_TO_EMAIL_ADDRESS_IOS = UTILITIES.EMAIL_IP + "transmit_profile_to_email_address_ios.php"
                jsonData = JSON_DATA_SYNCH.jsonGetData(TRANSMIT_PROFILE_TO_EMAIL_ADDRESS_IOS,
                    params: ["param1": transmit_to_email, "param2": "rob@roblanter.com", "param3": profileName, "param4": fromFirstName,
                         "param5": fromLastName, "param6": fromProfileName, "param7": contactName, "param8": email,
                         "param9": profileType, "param10": description, "param11": streetAddress, "param12": city,
                         "param13": state, "param14": zipcode, "param15": country, "param16": telephone,
                         "param17": tags, "param18": createDate])
            
                var message = jsonData["message"].string
                self.uview.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
    }
    
    func insertTransmittedData(jsonData: JSON) -> Int {
        var retCode = jsonData["ret_code"]
        var noRecExistRetCode = jsonData["no_rec_found_ret_code"]
        var recExistRetCode = jsonData["rec_exist_ret_code"]
        if retCode == -1 {
            return retCode.int!
        }
        if noRecExistRetCode == 1 {
            return noRecExistRetCode.int!
        }
        if recExistRetCode == 1 {
            return recExistRetCode.int!
        }
        return retCode.int!
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






