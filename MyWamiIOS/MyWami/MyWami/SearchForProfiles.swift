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
    var numProfiles = 0

    var searchInTxt = UITextField()
    var searchStringLikeTxt = UITextField()
    func searchProfilesDialog(searchProfileView: UIView, closeBtn: UIButton, searchBtn: UIButton) -> UIView {
        self.uview = searchProfileView
        
//        getProfileNames()
        
        searchProfileView.frame = CGRectMake(45, 100, 240, 245)
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
        
        
        
        let searchInLbl = UILabel()
        searchInLbl.backgroundColor = UIColor.whiteColor()
        searchInLbl.text = "Search In"
        searchInLbl.textColor = UIColor.blackColor()
        searchInLbl.font = UIFont.boldSystemFontOfSize(12)
        searchInLbl.frame = CGRectMake(10, 30, 100, 20)
        searchProfileView.addSubview(searchInLbl)
        
        let txtFldBorderLbL1 = UILabel()
        txtFldBorderLbL1.backgroundColor = UIColor.lightGrayColor()
        txtFldBorderLbL1.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL1.layer.borderWidth = 1.5
        
        searchInTxt.backgroundColor = UIColor.lightGrayColor()
        searchInTxt.textColor = UIColor.blackColor()
        searchInTxt.font = UIFont.systemFontOfSize(13)
        searchInTxt.addTarget(self, action: "setValue", forControlEvents: UIControlEvents.TouchUpInside)
        searchInTxt.frame = CGRectMake(15, 51, 210, 20)
        txtFldBorderLbL1.frame = CGRectMake(10, 48, 220, 25)
        searchProfileView.addSubview(txtFldBorderLbL1)
        searchProfileView.addSubview(searchInTxt)
        

        
        let searchStringLikeLbl = UILabel()
        searchStringLikeLbl.backgroundColor = UIColor.whiteColor()
        searchStringLikeLbl.text = "Search String Like"
        searchStringLikeLbl.textColor = UIColor.blackColor()
        searchStringLikeLbl.font = UIFont.boldSystemFontOfSize(12)
        searchStringLikeLbl.frame = CGRectMake(10, 80, 120, 20)
        searchProfileView.addSubview(searchStringLikeLbl)
        
        let txtFldBorderLbL2 = UILabel()
        txtFldBorderLbL2.backgroundColor = UIColor.whiteColor()
        txtFldBorderLbL2.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        txtFldBorderLbL2.layer.borderWidth = 1.5
        
        searchStringLikeTxt.backgroundColor = UIColor.whiteColor()
        searchStringLikeTxt.textColor = UIColor.blackColor()
        searchStringLikeTxt.font = UIFont.systemFontOfSize(13)
        searchStringLikeTxt.frame = CGRectMake(15, 101, 210, 20)
        txtFldBorderLbL2.frame = CGRectMake(10, 98, 220, 25)
        searchProfileView.addSubview(txtFldBorderLbL2)
        searchProfileView.addSubview(searchStringLikeTxt)
        
        
        return searchProfileView
    }
}





