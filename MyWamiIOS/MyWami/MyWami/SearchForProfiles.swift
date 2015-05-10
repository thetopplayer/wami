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
    var uview = UIView()
    var userProfileName = ""
    var profileNames: [String] = []
    var numNames = 0
    var profileNamesView: CompletionTableView!
    
    var profileNameTxt = UITextField()
    var emailAddressTxt = UITextField()
    func searchProfilesDialog(searchProfileView: UIView, closeBtn: UIButton, searchBtn: UIButton) -> UIView {
        self.uview = searchProfileView
        
//        getProfileNames()
        
        searchProfileView.frame = CGRectMake(45, 100, 240, 215)
        searchProfileView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        searchProfileView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        searchProfileView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "Search For Profiles"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        searchProfileView.addSubview(headingLbl)
        
        return searchProfileView
    }
}